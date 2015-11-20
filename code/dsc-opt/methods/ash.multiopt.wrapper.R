#' @title wrapper for ash for shrinkage DSC
#'
#' @description Runs ash to compute betahat values  
#' @details None
#' 
#' @param input a list with elements betahat and sebetahat
#' @param args a list containing other additional arguments to ash
#' 
#' @return output a list containing a vector of loglikelihoods from multiple runs of ash
#'
library(ashr)

ash.multiopt.wrapper=function(input,args=NULL){
  if(is.null(args)){  #set shrink so that the likelihood is unpenalized
    args=list(mixcompdist="halfuniform",method="shrink")
  }
  loglik=rep(0,2)
  
  #first run is with interior point
  res=do.call(ash, args= c(list(betahat=input$betahat,sebetahat=input$sebetahat,optmethod="mixIP"),args))
  loglik[1]= get_loglik(res)
  
  #now with EM
  res=do.call(ash, args= c(list(betahat=input$betahat,sebetahat=input$sebetahat,optmethod="cxxMixSquarem"),args))
  loglik[2]= get_loglik(res)
  
  
  #first run is with non-random start (ie default start)
  #res=do.call(ash, args= c(list(betahat=input$betahat,sebetahat=input$sebetahat,randomstart=FALSE),args))
  #loglik[1]= get_loglik(res)
    
  #for(i in 2:11){
  #  res = do.call(ash, args= c(list(betahat=input$betahat,sebetahat=input$sebetahat,randomstart=TRUE),args))
  #  loglik[i]= get_loglik(res)
  #}
  return(list(loglik=loglik))
}
