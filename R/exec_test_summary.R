



# import helper function
source(here::here("R","create_test_summary.R"))


# creates test summary table
create_test_summary(
  tbl_name = "fye_", # name of image

  input_vars = c("New Starts",
                 "1/19/21 - 3/1/21", # Date range of test
                 "Login Rates Increased Significantly", # Test result 
                  "Systematic Expansion" ) # Recommendation
)


