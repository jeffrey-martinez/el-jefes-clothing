view: inventory_items {
  sql_table_name: demo_db.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: date_to_use_filter {
    label: "DATE TO USE"
    type: string
    suggestions: ["REPORTABLE SALES","TRANSACTION EVENT WEEK END"]
  }

  dimension: pass_through_test  {
    sql: {% parameter date_to_use_filter %} ;;
    type: string
  }

  parameter: period {
    type: unquoted
    suggestions: ["1", "2", "3", "4", "5", "6", "7", "10"]
  }

  dimension: pass_through  {
    sql: {% parameter period %} ;;
    type: string
  }

#   dimension: pass_through_test_if  {
#     sql: {% if date_to_use_filter._parameter_value == "'REPORTABLE SALES'" %}
#     "First if"
#     {% else %}
#     "Else clause"
#     {% endif %};;
#     type: string
#   }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
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

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, products.item_name, products.id, order_items.count]
  }
}
