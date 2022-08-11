#' Significant figure rounding
#'
#' Rounds the variable `x` to the number of digits specified. Can round
#' up or down (using logical with `round_up`)
#' 
#' @param x 
#' @param round_up 
#' @param digits 
#'
#' @return x rounded up or down to number of digits specified
#' @export
#'
#' @examples
#' x <- c(0.458, 1526)
#' significance_round(x, round_up = FALSE, digits = 2)
#' 
significance_round <- function(x, round_up = TRUE, digits = 1){
  
  if(x < 0){
    
    x <- abs(x)
    
    neg_multiplier <- -1
    
    if(round_up){
      x <- floor(x/10^ceiling(log10(x)- digits)) *10^ceiling(log10(x)- digits)
    }else{
      x <- ceiling(x/10^ceiling(log10(x)- digits)) *10^ceiling(log10(x)-digits)
    }
    
    x <- x * neg_multiplier
    
  }else{
    
    if(round_up){
      x <- ceiling(x/10^ceiling(log10(x)- digits)) *10^ceiling(log10(x)- digits)
    }else{
      x <- floor(x/10^ceiling(log10(x)- digits)) *10^ceiling(log10(x)-digits)
    }
    
  }
  
  return(x)
  
  
}
