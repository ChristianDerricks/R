is.RStudio <- function(){
  if (!rstudioapi::isAvailable()) return(FALSE)
  return(TRUE)
}
