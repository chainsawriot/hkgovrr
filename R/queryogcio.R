#' @import httr
#' @import xml2
#' @import magrittr
#' @import plyr


xml_grep <- function(xmlnode, xpath) {
  if (xmlnode %>% xml_find_all(xpath) %>% length == 0) {
    return(NA)
  } else {
    return(xmlnode %>% xml_find_all(xpath) %>% xml_text)
  }
}

parse_suggested <- function(suggestedaddress) {
  dc <- xml_grep(suggestedaddress, ".//EngPremisesAddress/EngDistrict/DcDistrict")
  building_no_from <- xml_grep(suggestedaddress, ".//EngPremisesAddress/EngStreet/BuildingNoFrom")
  building_no_to <- xml_grep(suggestedaddress, ".//EngPremisesAddress/EngStreet/BuildingNoTo")
  street_name <- xml_grep(suggestedaddress, ".//EngPremisesAddress/EngStreet/StreetName") 
  building_name <- xml_grep(suggestedaddress, ".//EngPremisesAddress/BuildingName")
  return(c(dc = dc, building_no_from = building_no_from, building_no_to = building_no_to, street_name = street_name, building_name = building_name))
}

#' Query OGCIO API to parse free text address
#' 
#' This function query the OGCIO server and return a parsed address.
#' @param text_address String of Hong Kong Address
#' @param n Integer, Number of suggested address to return
#' @param sleep_time Numeric, sleep time between each query
#' @return A data.frame of parsed address(es)
#' @examples 
#' queryogcio("66 Causeway Road, Causeway Bay, Hong Kong")
#' @export
queryogcio <- function(text_address, n = 1, sleep_time = 0) {
  content(GET("https://www.als.ogcio.gov.hk/lookup", query = list(q= text_address, n = n))) -> xml_result
  xml_result %>% xml_find_all(xpath = "/AddressLookupResult/SuggestedAddress") -> suggestedaddress
  Sys.sleep(sleep_time)
  return(ldply(suggestedaddress, parse_suggested))
}
