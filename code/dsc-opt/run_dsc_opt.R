library(dscr)
dscr::source_dir("methods")

###### Initialize #######

dsc_opt=new_dsc("opt","../../output/dsc-opt-files")

###### Add Scenarios #####
dscr::source_dir("../dsc-shrink/datamakers")
source("../dsc-shrink/add_named_scenarios.R")
add_named_scenarios(dsc_opt,c("spiky","near-normal","flat-top","skew","big-normal","bimodal"))


###### Add Methods #####

add_method(dsc_opt,"ash.u",ash.multiopt.wrapper,args=list(mixcompdist="uniform",method="shrink"))
add_method(dsc_opt,"ash.hu",ash.multiopt.wrapper,args=list(mixcompdist="halfuniform",method="shrink"))
add_method(dsc_opt,"ash.n",ash.multiopt.wrapper,args=list(mixcompdist="normal",method="shrink"))



####### Define Score and Add it #######

score = function(data, output){
  x=output$loglik
  return(list(diff1 = x[1]-x[2])) 
}

add_score(dsc_opt,score)

######## Run the DSC #################

res_opt=run_dsc(dsc_opt)
save(dsc_opt,file="../../output/dsc-opt-files/dsc_opt.RData")






