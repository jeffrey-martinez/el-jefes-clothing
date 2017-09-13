view: user_facts {
  derived_table: {
    sql: SELECT users.id AS user_id,
       COUNT(orders.id) AS 'Total Number of Orders',
       MIN(DATE(orders.created_at)) AS 'First Order Date',
       MAX(DATE(orders.created_at)) AS 'Most Recent Order Date',
       TIMESTAMPDIFF(day, MIN(DATE(orders.created_at)), DATE(CURDATE())) AS 'Days Since First Purchase',
       CASE WHEN TIMESTAMPDIFF(month, MIN(DATE(orders.created_at)), DATE(CURDATE())) > 0 THEN ROUND(COUNT(orders.id)/TIMESTAMPDIFF(month, MIN(DATE(orders.created_at)), DATE(CURDATE())), 4)
            ELSE ROUND(COUNT(orders.id)/1.000, 4) END AS 'Average Orders per Month'
  FROM demo_db.orders AS orders
  LEFT OUTER JOIN demo_db.users AS users ON orders.user_id = users.id
GROUP BY 1
  HAVING COUNT(orders.id) > 1
 ;;
    persist_for: "24 hours"
    indexes: ["user_id"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_number_of_orders {
    type: number
    label: "Total Number of Orders"
    sql: ${TABLE}.`Total Number of Orders` ;;
  }

  dimension: first_order_date {
    type: date
    label: "First Order Date"
    sql: ${TABLE}.`First Order Date` ;;
  }

  dimension: most_recent_order_date {
    type: date
    label: "Most Recent Order Date"
    sql: ${TABLE}.`Most Recent Order Date` ;;
  }

  dimension: days_since_first_purchase {
    type: number
    label: "Days Since First Purchase"
    sql: ${TABLE}.`Days Since First Purchase` ;;
  }

  dimension: average_orders_per_month {
    type: number
    label: "Average Orders per Month"
    sql: ${TABLE}.`Average Orders per Month` ;;
  }

  set: detail {
    fields: [
      user_id,
      total_number_of_orders,
      first_order_date,
      most_recent_order_date,
      days_since_first_purchase,
      average_orders_per_month
    ]
  }
}
