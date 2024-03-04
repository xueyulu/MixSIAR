rm(list=ls())

#R package
library(MixSIAR)      
library(splancs)

#load mix data
mix <- load_mix_data(filename = "con1.csv",
                     iso_names = c("Pb206","Pb208"),
                     factors = NULL,
                     fac_random = NULL,
                     fac_nested = NULL,
                     cont_effects = NULL)

#load source data
source <- load_source_data(filename = "sources.csv",
                           source_factors = NULL,
                           conc_dep = FALSE,
                           data_type = "raw",
                           mix)

#load discrimination data
discr <- load_discr_data(filename = "tef.csv", mix)

#visualization
#make isospace plot
plot_data(filename="isospace_plot",
          plot_save_pdf=TRUE,
          plot_save_png=FALSE,
          mix,source,discr)

#Calculation
#Calculate normalized surface area (if 2 biotraces)
if(mix$n.iso == 2) calc_area(source=source, mix=mix, discr=discr)

# Plot your prior
plot_prior(alpha.prior=1,source)

#Write JAGS model
model_filename <- "MixSIAR_model.txt"
resid_err <- FALSE
process_err <- TRUE
write_JAGS_model(model_filename,resid_err,process_err,mix,source)

#run model test
jags.1 <- run_model(run="normal",mix,source,discr,model_filename,
                    alpha.prior = 1, resid_err,process_err)
#test/very short/short/normal/long/very long/extreme

#output JAGS
output_JAGS(jags.1,mix,source)
