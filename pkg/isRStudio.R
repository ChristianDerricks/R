is.RStudio <- function(){
  if (rstudioapi::isAvailable() & identical(.Platform$GUI, "RStudio")) return(TRUE)
  return(FALSE)
}
