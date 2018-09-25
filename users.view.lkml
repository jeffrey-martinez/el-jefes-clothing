view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    description: "Hey hey hey"
    group_label: "Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    description: "Turkey Day"
    group_label: "Location"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
#     label: "Regular Old Count"
    type: count
#     html: <font style="font-size:200%">{{rendered_value}}</font> ;;
    drill_fields: [detail*]
  }

  ## am_way testing for Allen Maxwell ##

  parameter: frame_select {
    type: string
#     allowed_value: { value: "Last 7 days" }
#     allowed_value: { value: "MTD" }
#     allowed_value: { value: "Last 45 days" }
#     allowed_value: { value: "YTD" }
    suggestions: ["Last 7 days", "MTD", "Last 45 days", "YTD"]
  }

  measure: dynamic_count {
    label_from_parameter: frame_select
#     description: "Dynamic Count Based on Frame Selected"
    type: count
#     html: <p style="font-size:300%"; align="center">{{value}}</p>  ;;
    filters:  {
      field: am_way
      value: "yes"
    }
  }

  dimension: am_way {
    type: yesno
    sql: CASE WHEN {% parameter frame_select %} = "Last 7 days" THEN (((users.created_at ) >= ((DATE_ADD(DATE(NOW()),INTERVAL -6 day))) AND (users.created_at ) < ((DATE_ADD(DATE_ADD(DATE(NOW()),INTERVAL -6 day),INTERVAL 7 day)))))
              WHEN {% parameter frame_select %} = "MTD" THEN (((users.created_at ) >= ((TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-%m-01')))) AND (users.created_at ) < ((DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-%m-01')),INTERVAL 1 month)))))
              WHEN {% parameter frame_select %} = "Last 45 days" THEN (((users.created_at ) >= ((DATE_ADD(DATE(NOW()),INTERVAL -44 day))) AND (users.created_at ) < ((DATE_ADD(DATE_ADD(DATE(NOW()),INTERVAL -44 day),INTERVAL 45 day)))))
              WHEN {% parameter frame_select %} = "YTD" THEN (((users.created_at ) >= ((TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')))) AND (users.created_at ) < ((DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')),INTERVAL 1 year)))))
    ELSE 1=1 END;;
  }

  ## am_way testing for Allen Maxwell ##

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
