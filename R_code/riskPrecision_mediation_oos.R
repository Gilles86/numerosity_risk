setwd("C:/Users/mgarcia/Documents/R/win-library/3.1")
install.packages("rjags")
install.packages("runjags")
library(rjags)
load.module("wiener")
load.module("dic") 
library(runjags)


setwd("D:/Projects/RISKPRECISION")
data_prec <- read.csv("prec_neural_sub.csv")

subcode <- 1:64
data_prec <- data.frame(data_prec,subcode)

### Mean
a1_all <- c(); a2_all <- c(); b_all <- c(); c1_all <- c()  
c2_all <- c(); d1_all <- c(); d2_all <- c(); e_all <- c()  

pnie_r_all <- c(); pnie_l_all <- c(); cde_r_all <- c(); cde_l_all <- c()   

tnie_r_all <- c(); tnie_l_all <- c()   

intmag_all <- c(); intrisk_all <- c(); intrisk_neuro_all <- c(); intrisk_behav_all <- c()

### P-value
pval_a1_all <- c(); pval_a2_all <- c(); pval_b_all <- c(); pval_c1_all <- c()  
pval_c2_all <- c(); pval_d1_all <- c(); pval_d2_all <- c(); pval_e_all <- c()  

pval_pnie_r_all <- c(); pval_pnie_l_all <- c(); pval_cde_r_all <- c(); pval_cde_l_all <- c()   

pval_tnie_r_all <- c(); pval_tnie_l_all <- c()   

pval_intmag_all <- c(); pval_intrisk_all <- c(); pval_intrisk_neuro_all <- c(); pval_intrisk_behav_all <- c()


data_prec2 <- data_prec

risk2 <- data_prec2$riskav_risk1
mag2 <- data_prec2$mag_prec1
npcr2 <- 1/data_prec2$NPC1_R_sd_trial
npcl2 <- 1/data_prec2$NPC1_L_sd_trial

for(i in subcode){
  
  data_prec <- subset(data_prec2, subcode != i)
  
  risk <- data_prec$riskav_risk1
  mag <- data_prec$mag_prec1
  npcr <- 1/data_prec$NPC1_R_sd_trial
  npcl <- 1/data_prec$NPC1_L_sd_trial
  
  
  dat <- dump.format(list(N=length(risk), risk=risk, risk_neuro=risk, risk_behav=risk, mag=mag, npcr= npcr, npcl = npcl))
  
  
  ####################################################
  
  ### Model Initalization
  inits1 <- dump.format(list(a1 = 0.5, a2 = 0.5, b = 0.5, c1 = 0.5, c2 = 0.5, d1 = 0.5, d2 = 0.5, e = 0.5,
                             .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
  inits2 <- dump.format(list(a1 = 0.5, a2 = 0.5, b = 0.5, c1 = 0.5, c2 = 0.5, d1 = 0.5, d2 = 0.5, e = 0.5,
                             .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
  inits3 <- dump.format(list(a1 = 0.5, a2 = 0.5, b = 0.5, c1 = 0.5, c2 = 0.5, d1 = 0.5, d2 = 0.5, e = 0.5,
                             .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))
  
  ### Monitor Parameters of Interest
  
  monitor = c("a1","a2","b","c1","c2","d1","d2","e", "pnie_r", "pnie_l","tnie_r","tnie_l","cde_r","cde_l","intmag ","intrisk ","intrisk_neuro ","intrisk_behav ","deviance")
  
  ### Run the Model
  risk_mediation2 <- run.jags(model="D:/Projects/RISKPRECISION/data/jags_file/riskprecision_mediation.txt", monitor=monitor,
                              data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", module="wiener", burnin=100000, sample=1000, thin=100)
  View(summary(risk_mediation2))
  
  mediation_analysis = rbind(risk_mediation2$mcmc[[1]], risk_mediation2$mcmc[[2]], risk_mediation2$mcmc[[3]])
  
  #### Mean
  a1 <- mean(mediation_analysis[,"a1"])    
  a2 <- mean(mediation_analysis[,"a2"])    
  b <- mean(mediation_analysis[,"b"] )  
  c1 <- mean(mediation_analysis[,"c1"])  
  c2 <- mean(mediation_analysis[,"c2"])  
  d1 <- mean(mediation_analysis[,"d1"])  
  d2 <- mean(mediation_analysis[,"d2"])   
  e <- mean(mediation_analysis[,"e"] )  
  
  pnie_r <- mean(mediation_analysis[,"pnie_r"])        
  pnie_l <- mean(mediation_analysis[,"pnie_l"])
  
  cde_r <- mean(mediation_analysis[,"cde_r"])   
  cde_l <- mean(mediation_analysis[,"cde_l"])   
  
  tnie_r <- mean(mediation_analysis[,"tnie_r"])  
  tnie_l <- mean(mediation_analysis[,"tnie_l"])   
  
  intmag <- mean(mediation_analysis[,"intmag"])  
  intrisk <- mean(mediation_analysis[,"intrisk"]) 
  intrisk_neuro <- mean(mediation_analysis[,"intrisk_neuro"]) 
  intrisk_behav <- mean(mediation_analysis[,"intrisk_behav"]) 
  
  
  pval_a1 <- mean(mediation_analysis[,"a1"]  < 0)    
  pval_a2 <- mean(mediation_analysis[,"a2"]  < 0)    
  pval_b <- mean(mediation_analysis[,"b"]    < 0)  
  pval_c1 <- mean(mediation_analysis[,"c1"]  < 0)  
  pval_c2 <- mean(mediation_analysis[,"c2"]  < 0)  
  pval_d1 <- mean(mediation_analysis[,"d1"]  < 0)  
  pval_d2 <- mean(mediation_analysis[,"d2"]  < 0)   
  pval_e <- mean(mediation_analysis[,"e"]    < 0)  
  
  pval_pnie_r <- mean(mediation_analysis[,"pnie_r"] < 0)        
  pval_pnie_l <- mean(mediation_analysis[,"pnie_l"] > 0)
  
  pval_cde_r <- mean(mediation_analysis[,"cde_r"] < 0)   
  pval_cde_l <- mean(mediation_analysis[,"cde_l"] > 0)   
  
  pval_tnie_r <- mean(mediation_analysis[,"tnie_r"] < 0)  
  pval_tnie_l <- mean(mediation_analysis[,"tnie_l"] > 0)   
  
  pval_intmag <- mean(mediation_analysis[,"intmag"] < 0)  
  pval_intrisk <- mean(mediation_analysis[,"intrisk"] < 0) 
  pval_intrisk_neuro <- mean(mediation_analysis[,"intrisk_neuro"] < 0) 
  pval_intrisk_behav <- mean(mediation_analysis[,"intrisk_behav"] < 0) 
  
  ### Mean
  a1_all <- c(a1_all, a1) 
  a2_all <- c(a2_all, a2) 
  b_all <- c(b_all, b) 
  c1_all <- c(c1_all, c1)  
  c2_all <- c(c2_all, c2) 
  d1_all <- c(d1_all, d1) 
  d2_all <- c(d2_all, d2)
  e_all <- c(e_all, e)  
  
  pnie_r_all <- c(pnie_r_all, pnie_r)
  pnie_l_all <- c(pnie_l_all, pnie_l)
  cde_r_all <- c(cde_r_all, cde_r)
  cde_l_all <- c(cde_l_all, cde_l)   
  
  tnie_r_all <- c(tnie_r_all, tnie_r)
  tnie_l_all <- c(tnie_l_all, tnie_l)   
  
  intmag_all <- c(intmag_all, intmag)
  intrisk_all <- c(intrisk_all, intrisk)
  
  intrisk_neuro_all <- c(intrisk_neuro_all, intrisk_neuro)
  intrisk_behav_all <- c(intrisk_behav_all, intrisk_behav)
  
  #### P-value
  pval_a1_all <- c(pval_a1_all, pval_a1) 
  pval_a2_all <- c(pval_a2_all, pval_a2) 
  pval_b_all  <- c(pval_b_all,  pval_b) 
  pval_c1_all <- c(pval_c1_all, pval_c1)  
  pval_c2_all <- c(pval_c2_all, pval_c2) 
  pval_d1_all <- c(pval_d1_all, pval_d1) 
  pval_d2_all <- c(pval_d2_all, pval_d2)
  pval_e_all  <- c(pval_e_all,  pval_e)  
  
  pval_pnie_r_all <- c(pval_pnie_r_all, pval_pnie_r)
  pval_pnie_l_all <- c(pval_pnie_l_all, pval_pnie_l)
  pval_cde_r_all  <- c(pval_cde_r_all,  pval_cde_r)
  pval_cde_l_all  <- c(pval_cde_l_all,  pval_cde_l)   
  
  pval_tnie_r_all <- c(pval_tnie_r_all, pval_tnie_r)
  pval_tnie_l_all <- c(pval_tnie_l_all, pval_tnie_l)   
  
  pval_intmag_all <- c(pval_intmag_all,  pval_intmag)
  pval_intrisk_all <- c(pval_intrisk_all, pval_intrisk)
  
  pval_intrisk_neuro_all <- c(pval_intrisk_neuro_all, pval_intrisk_neuro)
  pval_intrisk_behav_all <- c(pval_intrisk_behav_all, pval_intrisk_behav)
  
}

risk_pred <- intrisk_all + c1_all*npcr2 + c2_all*npcl2 + b_all*mag2
risk_pred2 <- intrisk_neuro_all + d1_all*npcr2 + d2_all*npcl2 
risk_pred3 <- intrisk_behav_all + e_all*mag2 
risk_pred4 <- intrisk_all + c1_all*npcr2 + c2_all*npcl2 + b_all*(intmag_all + a1_all*npcr2 + a2_all*npcl2)

mean(pnie_r < 0)
mean(pnie_l > 0)

mean(cde_r < 0)
mean(cde_l > 0)

mean(tnie_r < 0)
mean(tnie_l > 0)

##################################################################
##################################################################


setwd("D:/Projects/RISKPRECISION")

data_prec <- read.csv("riskPrecision_data_new2.csv")


### Check for Outliers in SYMBOLS
#noise_outlier2 <- boxplot.stats(data_prec$risknoise_coin, coef = 8)$out
#print(noise_outlier2) 

### Remove Outliers 
#data_prec <- data_prec[-which(data_prec$risknoise_coin %in% noise_outlier2),]


risk_sym <- (data_prec$rnp_sym)
risk_coin <- (data_prec$rnp_dot)
mag <- (data_prec$magPrec)
npc_int_r <- log(data_prec$npc_int_r)
npc_slp_r <- data_prec$npc_slp_r
#npc_int_l <- (data_prec$npc_int_l)
#npc_slp_r <- 1/data_prec$npc_slp_r
#npc_slp_l <- 1/data_prec$npc_slp_l


#dat <- dump.format(list(N=length(risk), risk=risk, risk_neuro=risk, risk_behav=risk, mag=mag, npcr= npcr, npcl = npcl))
dat <- dump.format(list(N=length(risk_sym), risk_sym=risk_sym, risk_coin=risk_coin, 
                        mag=mag, npc_int_r= npc_int_r,  npc_slp_r = npc_slp_r ))


####################################################

### Model Initalization
#inits1 <- dump.format(list(a1 = 0.5, a2 = 0.5, b = 0.5, c1 = 0.5, c2 = 0.5, d1 = 0.5, d2 = 0.5, e = 0.5,
#                           .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
#inits2 <- dump.format(list(a1 = 0.5, a2 = 0.5, b = 0.5, c1 = 0.5, c2 = 0.5, d1 = 0.5, d2 = 0.5, e = 0.5,
#                           .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
#inits3 <- dump.format(list(a1 = 0.5, a2 = 0.5, b = 0.5, c1 = 0.5, c2 = 0.5, d1 = 0.5, d2 = 0.5, e = 0.5,
#                           .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))

### Model Initalization
inits1 <- dump.format(list(a1 = 0.5, a2 = 0.5, a3 = 0.5, a4 = 0.5, b1 = 0.5, b2 = 0.5, c1 = 0.5, c2 = 0.5, c3 = 0.5, c4 = 0.5, d1 = 0.5, d2 = 0.5, d3 = 0.5, d4 = 0.5, 
                           .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
inits2 <- dump.format(list(a1 = 0.5, a2 = 0.5, a3 = 0.5, a4 = 0.5, b1 = 0.5, b2 = 0.5, c1 = 0.5, c2 = 0.5, c3 = 0.5, c4 = 0.5, d1 = 0.5, d2 = 0.5, d3 = 0.5, d4 = 0.5, 
                           .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
inits3 <- dump.format(list(a1 = 0.5, a2 = 0.5, a3 = 0.5, a4 = 0.5, b1 = 0.5, b2 = 0.5, c1 = 0.5, c2 = 0.5, c3 = 0.5, c4 = 0.5, d1 = 0.5, d2 = 0.5, d3 = 0.5, d4 = 0.5, 
                           .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))

### Monitor Parameters of Interest

#monitor = c("a1","a2","a1","a4","b","c1","c2","c3","c4","d1","d2","d3","d4","e", "pnie_r", "pnie_l","tnie_r","tnie_l","cde_r","cde_l","intmag ","intrisk ","intrisk_neuro ","intrisk_behav ","deviance")
monitor = c("a1","a2","a3","a4","b1","b2","c1","c2","c3","c4","d1","d2","d3","d4",
            "pnie_int_r_sym", "pnie_int_l_sym", "pnie_slp_r_sym", "pnie_slp_l_sym",
            "pnie_int_r_coin", "pnie_int_l_coin", "pnie_slp_r_coin", "pnie_slp_l_coin",
            "tnie_int_r_sym","tnie_int_l_sym","tnie_slp_r_sym","tnie_slp_l_sym",
            "tnie_int_r_coin","tnie_int_l_coin","tnie_slp_r_coin","tnie_slp_l_coin",
            "cde_int_r_sym","cde_int_l_sym","cde_slp_r_sym","cde_slp_l_sym",
            "cde_int_r_coin","cde_int_l_coin","cde_slp_r_coin","cde_slp_l_coin",
            "intmag ","intrisk_sym","intrisk_coin","deviance")


### Run the Model
risk_mediation_slp_new <- run.jags(model="D:/Projects/RISKPRECISION/data/jags_file/riskprecision_mediation_new.txt", monitor=monitor,
                            data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", module="wiener", burnin=100000, sample=1000, thin=100)
View(summary(risk_mediation_slp_new))

mediation_analysis = rbind(risk_mediation_slp_new$mcmc[[1]], risk_mediation_slp_new$mcmc[[2]], risk_mediation_slp_new$mcmc[[3]])

#### Mean

a1 <- (mediation_analysis[,"a1"])    
#a3 <- (mediation_analysis[,"a3"])    

b1  <- (mediation_analysis[,"b1"])  
#b2  <- (mediation_analysis[,"b2"])  

c1 <- (mediation_analysis[,"c1"])  
#c3 <- (mediation_analysis[,"c3"])  

d1 <- (mediation_analysis[,"d1"])  
#d3 <- (mediation_analysis[,"d3"])  

#a2 <- (mediation_analysis[,"a2"])
#a4 <- (mediation_analysis[,"a4"])    

#c2 <- (mediation_analysis[,"c2"])  
#c4 <- (mediation_analysis[,"c4"])  

#d2 <- (mediation_analysis[,"d2"])  
#d4 <- (mediation_analysis[,"d4"])   


###############################################################
pnie_int_r_sym <- (mediation_analysis[,"pnie_int_r_sym"])        
pnie_int_r_coin <- (mediation_analysis[,"pnie_int_r_coin"])        

#pnie_slp_r_sym <- (mediation_analysis[,"pnie_slp_r_sym"])        
#pnie_slp_r_coin <- (mediation_analysis[,"pnie_slp_r_coin"])        

#pnie_int_l_sym <- (mediation_analysis[,"pnie_int_l_sym"])
#pnie_slp_l_sym <- (mediation_analysis[,"pnie_slp_l_sym"])
#pnie_int_l_coin <- (mediation_analysis[,"pnie_int_l_coin"])
#pnie_slp_l_coin <- (mediation_analysis[,"pnie_slp_l_coin"])

###############################################################
cde_int_r_sym <- (mediation_analysis[,"cde_int_r_sym"])   
cde_int_r_coin <- (mediation_analysis[,"cde_int_r_coin"])   

#cde_slp_r_sym <- (mediation_analysis[,"cde_slp_r_sym"])   
#cde_slp_r_coin <- (mediation_analysis[,"cde_slp_r_coin"])   

#cde_int_l_sym <- (mediation_analysis[,"cde_int_l_sym"])   
#cde_slp_l_sym <- (mediation_analysis[,"cde_slp_l_sym"])   
#cde_int_l_coin <- (mediation_analysis[,"cde_int_l_coin"])   
#cde_slp_l_coin <- (mediation_analysis[,"cde_slp_l_coin"])   

###############################################################
tnie_int_r_sym <- (mediation_analysis[,"tnie_int_r_sym"])  
tnie_int_r_coin <- (mediation_analysis[,"tnie_int_r_coin"])  

#tnie_slp_r_sym <- (mediation_analysis[,"tnie_slp_r_sym"])  
#tnie_slp_r_coin <- (mediation_analysis[,"tnie_slp_r_coin"])  

#tnie_int_l_sym <- (mediation_analysis[,"tnie_int_l_sym"])   
#tnie_slp_l_sym <- (mediation_analysis[,"tnie_slp_l_sym"])   
#tnie_int_l_coin <- (mediation_analysis[,"tnie_int_l_coin"])   
#tnie_slp_l_coin <- (mediation_analysis[,"tnie_slp_l_coin"])   

###############################################################
intmag <- (mediation_analysis[,"intmag"])  
intrisk_sym <- (mediation_analysis[,"intrisk_sym"]) 
intrisk_coin <- (mediation_analysis[,"intrisk_coin"]) 


mean_a1 <- mean(mediation_analysis[,"a1"])    
pval_a1 <- mean((mediation_analysis[,"a1"] > 0))  

#mean_a3 <- mean(mediation_analysis[,"a3"])    
#pval_a3 <- mean((mediation_analysis[,"a3"] > 0)*2)  

### symbolic
mean_b1 <- mean(mediation_analysis[,"b1"])  
pval_b1 <- mean((mediation_analysis[,"b1"] < 0))  
### dots
mean_b2 <- mean(mediation_analysis[,"b2"])  
pval_b2 <- mean((mediation_analysis[,"b2"] < 0))  

#mean_c1 <- mean(mediation_analysis[,"c1"])  
#mean_c3 <- mean(mediation_analysis[,"c3"])  
#mean_d1 <- mean(mediation_analysis[,"d1"])  
#mean_d3 <- mean(mediation_analysis[,"d3"])  

#mean_a2 <- mean(mediation_analysis[,"a2"])    
#mean_a4 <- mean(mediation_analysis[,"a4"])    
#mean_c2 <- mean(mediation_analysis[,"c2"])  
#mean_c4 <- mean(mediation_analysis[,"c4"])  
#mean_d2 <- mean(mediation_analysis[,"d2"])   
#mean_d4 <- mean(mediation_analysis[,"d4"])   


mean_pnie_int_r_sym <- mean(mediation_analysis[,"pnie_int_r_sym"])        
pval_pnie_int_r_sym  <- mean((mediation_analysis[,"pnie_int_r_sym"] < 0))        

#mean_pnie_slp_r_sym <- mean(mediation_analysis[,"pnie_slp_r_sym"])        
#pval_pnie_slp_r_sym  <- mean((mediation_analysis[,"pnie_slp_r_sym"] < 0)*2)   

mean_pnie_int_r_coin <- mean(mediation_analysis[,"pnie_int_r_coin"])        
pval_pnie_int_r_coin <- mean((mediation_analysis[,"pnie_int_r_coin"] < 0))        

#mean_pnie_slp_r_coin <- mean(mediation_analysis[,"pnie_slp_r_coin"])        
#pval_pnie_slp_r_coin <- mean((mediation_analysis[,"pnie_slp_r_coin"] < 0)*2)   

mean_cde_int_r_sym <- mean(mediation_analysis[,"cde_int_r_sym"])   
pval_cde_int_r_sym  <- mean((mediation_analysis[,"cde_int_r_sym"] > 0))   

#mean_cde_slp_r_sym <- mean(mediation_analysis[,"cde_slp_r_sym"])   
#pval_cde_slp_r_sym  <- mean((mediation_analysis[,"cde_slp_r_sym"] > 0)*2)   

mean_cde_int_r_coin <- mean(mediation_analysis[,"cde_int_r_coin"])   
pval_cde_int_r_coin <- mean((mediation_analysis[,"cde_int_r_coin"] > 0)) 

#mean_cde_slp_r_coin <- mean(mediation_analysis[,"cde_slp_r_coin"])   
#pval_cde_slp_r_coin <- mean((mediation_analysis[,"cde_slp_r_coin"] > 0)*2)   

mean_tnie_int_r_sym <- mean(mediation_analysis[,"tnie_int_r_sym"])  
pval_tnie_int_r_sym  <- mean((mediation_analysis[,"tnie_int_r_sym"] < 0))

#mean_tnie_slp_r_sym <- mean(mediation_analysis[,"tnie_slp_r_sym"])  
#pval_tnie_slp_r_sym  <- mean((mediation_analysis[,"tnie_slp_r_sym"] > 0)*2) 

mean_tnie_int_r_coin <- mean(mediation_analysis[,"tnie_int_r_coin"])  
pval_tnie_int_r_coin <- mean((mediation_analysis[,"tnie_int_r_coin"] < 0)) 

#mean_tnie_slp_r_coin <- mean(mediation_analysis[,"tnie_slp_r_coin"])  
#pval_tnie_slp_r_coin <- mean((mediation_analysis[,"tnie_slp_r_coin"] > 0)*2) 

mean_intmag <- mean(mediation_analysis[,"intmag"])  
mean_intrisk_sym <- mean(mediation_analysis[,"intrisk_sym"]) 
mean_intrisk_coin <- mean(mediation_analysis[,"intrisk_coin"]) 

#mean_pnie_l <- mean(mediation_analysis[,"pnie_l"])
#mean_cde_l <- mean(mediation_analysis[,"cde_l"])   
#mean_tnie_l <- mean(mediation_analysis[,"tnie_l"])   
#mean_intrisk_neuro <- mean(mediation_analysis[,"intrisk_neuro"]) 
#mean_intrisk_behav <- mean(mediation_analysis[,"intrisk_behav"]) 


  

pval_c1 <- mean((mediation_analysis[,"c1"] < 0)*2)  
pval_c3 <- mean((mediation_analysis[,"c3"] < 0)*2)  
pval_d1 <- mean((mediation_analysis[,"d1"] < 0)*2)  
pval_d3 <- mean((mediation_analysis[,"d3"] < 0)*2)   

     






pval_intmag <- mean((mediation_analysis[,"intmag"] < 0)*2)  
pval_intrisk_sym <- mean((mediation_analysis[,"intrisk_sym"] < 0)*2) 
pval_intrisk_coin <- mean((mediation_analysis[,"intrisk_coin"] < 0)*2) 

library("scales")

source("D:/Projects/PECONFOOD_fMRI_TMS/SFS_BehaviorData/subjects_choices/HDIofMCMC.r")
hdi = HDIofMCMC(pnie_r , credMass=0.95)




mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 
par(mfrow=c(3,2))



########################
### Mediation Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(pnie_r)
plot(d, xlim = c(-2,4), lwd = 5, main = "Neural Precision (Intercept)", 
     ylab = "Right NPC", xlab = "Mediation Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_pnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(cde_r)
plot(d, xlim = c(-6,6), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Direct Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(1-round(pval_cde_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(tnie_r)
plot(d, xlim = c(-6,6), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Total Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

# -----------------------------------------------------------------------


########################
### Mediation Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"


d = density(pnie_l)
plot(d, xlim = c(-2,2), lwd = 5, main = "Sensitivity (Slope)", 
     ylab = "Right NPC", xlab = "Mediation Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(1-round(pval_pnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(cde_l)
plot(d, xlim = c(-10,7), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Direct Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_cde_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(tnie_l)
plot(d, xlim = c(-10,7), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Total Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)




################################################################################
################################################################################
################################################################################


mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 
par(mfrow=c(3,2))


########################
### Mediation Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(pnie_r)
plot(d, xlim = c(-2,4), lwd = 5, main = "Neural Precision (Intercept)", 
     ylab = "Left NPC", xlab = "Mediation Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_pnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(cde_r)
plot(d, xlim = c(-6,6), lwd = 5, main = "", 
     ylab = "Left NPC", xlab = "Direct Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(1-round(pval_cde_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(tnie_r)
plot(d, xlim = c(-6,6), lwd = 5, main = "", 
     ylab = "Left NPC", xlab = "Total Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

# -----------------------------------------------------------------------


########################
### Mediation Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"


d = density(pnie_l)
plot(d, xlim = c(-6,2), lwd = 5, main = "Sensitivity (Slope)", 
     ylab = "Left NPC", xlab = "Mediation Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_pnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(cde_l)
plot(d, xlim = c(-10,10), lwd = 5, main = "", 
     ylab = "Left NPC", xlab = "Direct Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_cde_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(tnie_l)
plot(d, xlim = c(-10,7), lwd = 5, main = "", 
     ylab = "Left NPC", xlab = "Total Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)



########################################
########################################
########################################
########################################
########################################


########################
### Mediation Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(pnie_r)
plot(d, xlim = c(-2,4), lwd = 5, main = "Neural Precision (Intercept)", 
     ylab = "Right NPC", xlab = "Mediation Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_pnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(cde_r)
plot(d, xlim = c(-6,6), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Direct Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(1-round(pval_cde_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(tnie_r)
plot(d, xlim = c(-6,6), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Total Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

# -----------------------------------------------------------------------


########################
### Mediation Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"


d = density(pnie_l)
plot(d, xlim = c(-2,2), lwd = 5, main = "Sensitivity (Slope)", 
     ylab = "Right NPC", xlab = "Mediation Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(1-round(pval_pnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(cde_l)
plot(d, xlim = c(-10,7), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Direct Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_cde_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(tnie_l)
plot(d, xlim = c(-10,7), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Total Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)




################################################################################
################################################################################
################################################################################


mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 
par(mfrow=c(3,2))



########################
### Mediation Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(pnie_r)
plot(d, xlim = c(-0.5,0.5), lwd = 5, main = "Neural Precision (Intercept)", 
     ylab = "Right NPC", xlab = "Mediation Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_pnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(cde_r)
plot(d, xlim = c(-1,0.5), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Direct Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(1-pval_cde_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(tnie_r)
plot(d, xlim = c(-1,1), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Total Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

# -----------------------------------------------------------------------

########################
### Mediation Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"


d = density(pnie_l)
plot(d, xlim = c(-0.5,0.5), lwd = 5, main = "Sensitivity (Slope)", 
     ylab = "Right NPC", xlab = "Mediation Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(1-pval_pnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(cde_l)
plot(d, xlim = c(-1,1), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Direct Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_cde_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(tnie_l)
plot(d, xlim = c(-1,1), lwd = 5, main = "", 
     ylab = "Right NPC", xlab = "Total Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)


# -------------------------------------------------------------------------------------


mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 
par(mfrow=c(3,2))

########################
### Mediation Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(pnie_r)
plot(d, xlim = c(-0.5,0.5), lwd = 5, main = "Neural Precision (Intercept)", 
     ylab = "Left NPC", xlab = "Mediation Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_pnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(cde_r)
plot(d, xlim = c(-1,0.5), lwd = 5, main = "", 
     ylab = "Left NPC", xlab = "Direct Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(1-round(pval_cde_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#A6CEE3"
color2 = "#1F78B4"

d = density(tnie_r)
plot(d, xlim = c(-0.5,1), lwd = 5, main = "", 
     ylab = "Left NPC", xlab = "Total Effect ", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_r,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_r, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

# -----------------------------------------------------------------------


########################
### Mediation Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"


d = density(pnie_l)
plot(d, xlim = c(-0.5,0.5), lwd = 5, main = "Sensitivity (Slope)", 
     ylab = "Left NPC", xlab = "Mediation Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_pnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(pnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Direct Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(cde_l)
plot(d, xlim = c(-1,1), lwd = 5, main = "", 
     ylab = "Left NPC", xlab = "Direct Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(1-pval_cde_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(cde_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)

########################
### Total Effect ###
color = "#FDBF6F"
color2 = "#FF7F00"

d = density(tnie_l)
plot(d, xlim = c(-1,0.5), lwd = 5, main = "", 
     ylab = "Left NPC", xlab = "Total Effect", cex.main = 3, cex.lab =1.8, cex.axis = 2,
     col = alpha(color2, 0.8))
polygon(d, col =alpha(color2, 0.7), border = alpha(color2, 0.7) )
legend(locator(1), paste("p = ",as.character(round(pval_tnie_l,3))),box.lty=0,cex=2)


hdi1 = HDIofMCMC(tnie_l, credMass=0.95)
x1 <- min(which(d$x >= hdi1[1] ))  
x2 <- max(which(d$x <  hdi1[2]))
with(d, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=color, border = color))
abline(v=0, lty=3, col="black", lwd=2)
