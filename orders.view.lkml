view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter:  name_of_your_filter {
    type: date
  }

  dimension: filter_value_test {
    type: string
    sql: DATE({% date_end name_of_your_filter %}) ;;
  }

  dimension: YTD_based_on_filter {
    type: date
    sql: DATE_FORMAT({% date_end name_of_your_filter %}, '%Y-01-01') ;;
  }

  measure: max_doy {
    type: number
    sql: MAX(${created_day_of_year}) ;;
  }

  dimension: date_diff_in_html {
    type: number
    sql: ${TABLE}.created_at ;;
    html:
        {% assign dateStart = value | date: '%s' %}
        {% assign nowTimestamp = 'now' | date: '%s' %}
        {% assign diffSeconds = nowTimestamp | minus: dateStart %}
        {% assign diffDays = diffSeconds | divided_by: 3600 | divided_by: 24 %}

        {{ diffDays }} ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_year,
      day_of_month,
      day_of_week,
      week,
      month,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

#   dimension_group: created_2 {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       day_of_year,
#       day_of_month,
#       day_of_week,
#       week,
#       month,
#       month_num,
#       quarter,
#       year
#     ]
#     sql: CASE WHEN {% condition name_of_your_filter %} ${TABLE}.created_at {% endcondition %}
#               THEN ${TABLE}.created_at ELSE NULL END ;;
#   }

  dimension: cal_year {
    type: string
    sql: ${created_year} ;;
  }

  dimension: cal_month {
    type:  string
    sql: EXTRACT(Month FROM ${created_raw}) ;;
  }

#   dimension: cal_quarter {
#     type: string
#     sql: date_trunc('quarter', to_date( cal_year || '-' || cal_month, 'YYYY-MM')) + 1 as cal_quarter ;;
#   }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: number
    sql: ${TABLE}.id ;;
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }

  measure: count_end {
    type: count_distinct
    sql: ${TABLE}.id ;;

    # drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }

  measure: first_order {
    type: date
    sql: MIN(${created_date}) ;;
  }

  measure: recent_order {
    type:  date
    sql: MAX(${created_date}) ;;
  }

  measure: days_since_first_purchase {
    type:  number
    sql: TIMESTAMPDIFF(day, ${first_order}, CURDATE()) ;;
  }
  measure: months_since_first_purchase {
    type:  number
    hidden: yes
    sql: TIMESTAMPDIFF(month, ${first_order}, CURDATE()) ;;
  }
}
