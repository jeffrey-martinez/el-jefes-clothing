view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

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
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
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
