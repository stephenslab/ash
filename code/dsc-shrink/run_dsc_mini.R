library(dscr)
library(ashr)
sessionInfo()

dsc_shrink_mini=new_dsc("shrink_mini","../../output/dsc-shrink-mini-files")
source("add_named_scenarios.R")
add_named_scenarios(dsc_shrink_mini,c("spiky"))
dscr::source_dir("methods")
add_method(dsc_shrink_mini,name="ash.n",fn =ash.wrapper,args=list(mixcompdist="normal"),outputtype = "ash_output")
add_method(dsc_shrink_mini,name="mixfdr.tnull", fn=mixfdr.wrapper, args = list(theonull=TRUE),outputtype = "mixfdr_output")

add_output_parser(dsc_shrink_mini,"ash2beta",ash2beta_est,"ash_output","beta_est_output")
add_output_parser(dsc_shrink_mini,"mixfdr2beta",mixfdr2beta_est,"mixfdr_output","beta_est_output")

add_output_parser(dsc_shrink_mini,"ash2pi0",ash2pi0_est,"ash_output","pi0_est_output")
#add_output_parser(dsc_shrink_mini,"mixfdr2pi0",mixfdr2pi0_est,"mixfdr_output","pi0_est_output")
#add_output_parser(dsc_shrink_mini,"locfdr2pi0",locfdr2pi0_est,"locfdr_output","pi0_est_output")
#add_output_parser(dsc_shrink_mini,"qvalue2pi0",qvalue2pi0_est,"qvalue_output","pi0_est_output")

#add_output_parser(dsc_shrink_mini,"ash2fitted.g",ash2fitted.g,"ash_output","g_output")
#add_output_parser(dsc_shrink_mini,"mixfdr2fitted.g",mixfdr2fitted.g,"mixfdr_output","g_output")



source("score.R")
add_score(dsc_shrink_mini,score,"beta_err","beta_est_output")
# add_score(dsc_shrink,score2,"pi0_score","pi0_est_output")
# add_score(dsc_shrink,score3,"cdf_score","g_output")
# add_score(dsc_shrink,score_neg,"negprob","ash_output") #just extract the negativeprobs
# add_score(dsc_shrink,score_pos,"posprob","ash_output") #just extracts the positiveprobs
# add_score(dsc_shrink,score_fdr,"fdr","mixfdr_output") #just extracts the fdr
# add_score(dsc_shrink,score_betahat,"betahat","mixfdr_output") #just extracts the fdr
# add_score(dsc_shrink,score_lfsr,"lfsr","ash_output") #just extracts the lfsr
# add_score(dsc_shrink,score_lfdr,"lfdr","ash_output") #just extracts the lfdr


res=run_dsc(dsc_shrink_mini)
save(res,dsc_shrink_mini,file="../../output/dsc-shrink-files/res.mini.RData")


