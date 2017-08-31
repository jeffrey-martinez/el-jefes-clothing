view: top_items_by_category {
  derived_table: {
    sql: SELECT id, category, brand, MIN(rank) AS "Overall Rank", item_name, retail_price
        FROM products
        GROUP BY category;
       ;;
    persist_for: "4 hours"
    indexes: ["id"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: overall_rank {
    type: string
    label: "Overall Rank"
    sql: ${TABLE}.`Overall Rank` ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: retail_price {
    type: string
    sql: ${TABLE}.retail_price ;;
  }

  set: detail {
    fields: [category, brand, overall_rank, item_name, retail_price]
  }
}
