#' Initializes the database with the orders data
#' @param con Database connection
#' @param avg_daily_orders Number of average daily orders
#' @param avg_no_items Average number of sales in an order
#' @param days_in_segment Days in a segment
#' @param no_of_segments Number of segments
#' @param seed Seed to randomize to
#' @param product_data Product data frame source
#' @param customer_data Customer data frame source
#' @param start_date The start date for the orders
#' @param orders_view Name to give to the orders view
#' @param lineitems_view Name to give the line items view
#' @export
bdc_db_tables <- function(con,
                          avg_daily_orders = 100,
                          avg_no_items = 3,
                          days_in_segment = 10,
                          no_of_segments = 100,
                          seed = 7878,
                          product_data = bdc_data_products(),
                          customer_data = bigdataclass::customers,
                          start_date = "2016-01-01",
                          orders_view = "v_orders",
                          lineitems_view = "v_lineitems"
                          ) {
  ui_info("Creating product and customer tables")
  bdc_db_lookups(
    con = con,
    product_data = product_data,
    customer_data = customer_data
  )
  ui_done("Product table created")
  ui_done("Customer table created")
  ui_info("Creating order and line item tables")
  bdc_db_orders(
    con = con,
    avg_daily_orders = avg_daily_orders,
    avg_no_items = avg_no_items,
    days_in_segment = days_in_segment,
    no_of_segments = no_of_segments,
    seed = seed
  )
  ui_done("Orders table created")
  ui_done("Line items table created")
  bdc_db_create_dates(
    con = con,
    start_date = start_date
  )
  ui_done("Date table created")
  bdc_db_view_orders(
    con = con,
    name = orders_view
  )
  ui_done("Orders view created")
  bdc_db_view_lineitems(
    con = con,
    name = lineitems_view
  )
  ui_done("Line items view created")
}
