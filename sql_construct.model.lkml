connection: "thelook"

include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }


explore: test {}

view: test  {
  derived_table: {
    sql:
      SELECT 'opp1' as name, 10 as total, '2018-01-01' AS start, '2018-01-31' AS end, 1 AS length
      UNION
      SELECT 'opp2' as name, 20 as total, '2018-01-01' AS start, '2018-02-28' AS end, 2 AS length
      UNION
      SELECT 'opp3' as name, 30 as total, '2018-02-01' AS start, '2018-02-28' AS end, 1 AS length
      ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: total {
    type: number
    sql: ${TABLE}.total ;;
  }

  dimension_group: start {
    type: time
    timeframes: [raw, date, week, month, day_of_month]
    sql: CAST(${TABLE}.start AS DATE) ;;
  }

  dimension_group: end {
    type: time
    timeframes: [raw, date, week, month, day_of_month]
    sql: CAST(${TABLE}.end AS DATE) ;;
  }

  measure: monthly_RR {
    type: max
    sql: ${total}*1.0 / ${length} ;;
  }

  dimension: length {
    label: "Length (Months)"
    description: "Length in Months"
    sql: ${TABLE}.length ;;
  }

  measure: count {
    type: count
  }

# Name  Total start end length (Months)
# opp1  $10 1/1/18  1/30/18 1
# opp2  $20 1/1/18  2/28/18 2
# opp3  $30 2/1/18  2/28/18 1

}
