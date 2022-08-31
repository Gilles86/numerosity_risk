############################################################################
############################################################################
#######                                                              ####### 
####### FITTING THE NOISY CODING MODEL FOR RISKY AND MAGNITUDE TASKS #######
#######                                                              #######
############################################################################
############################################################################


#### LOAD JAGS ####

setwd("C:/Users/mgarcia/Documents/R/win-library/3.6")
install.packages("rjags")
install.packages("runjags")
library(rjags)
load.module("wiener")
load.module("dic") 
library(runjags)

'%!in%' <- function(x,y)!('%in%'(x,y))  ### overload my function

#### LOAD DATASET #### 

setwd("D:/Projects/RISKPRECISION")

riskcomp <- read.csv("magRiskData.csv") ### The file lives in a .csv file

#### RECODE VARIABLES ####

### Recode choice behaviour as 0s and 1s from file
for(i in 1:length(riskcomp$choice))
{
  if(riskcomp$choice[i] == 1){
    riskcomp$risky[i] <- 0                    #### 0 = incorrect/magnitude; 0 = safe choice/risk
  } else if (riskcomp$choice[i] == -1){
    riskcomp$risky[i] <- 1                    #### 1 = correct/magnitude; 1 = risky choice/risk
  } else if (riskcomp$choice[i] == -2){
    riskcomp$risky[i] <- 'NA'                 #### missed trial/left
  } else if (riskcomp$choice[i] == 2){
    riskcomp$risky[i] <- 'NA'                 #### missed trial/right
  }
}

riskcomp$risky <- as.numeric(as.character(riskcomp$risky))   ### Ensure all the values in the dataset are numeric

riskcomp1 <- subset(riskcomp, type == 0 & exptype == 1)      ### Magnitude Comparison Task
riskcomp2 <- subset(riskcomp, exptype == 2)                  ### Risky - Symbolic Numbers
riskcomp3 <- subset(riskcomp, exptype == 3)                  ### Risky - Coin Clouds


# riskcomp <- rbind(riskcomp1, riskcomp2, riskcomp3)      ### If you want to combine/bind subsets of the data

#### Recode 
for(i in 1:length(riskcomp$choice))
{
  if(riskcomp$exptype[i] == 1){
    riskcomp$type1[i] <- 0
  } else if (riskcomp$exptype[i] == 2){
    riskcomp$type1[i] <- 0
  } else if (riskcomp$exptype[i] == 3){
    riskcomp$type1[i] <- 1
  }
}

### Risky Comparison
choice_data <- as.numeric(as.character(riskcomp$risky))
c <- riskcomp$sure_bet
x <- riskcomp$prob_bet #*riskcomp$prob
idXP <- riskcomp$subcode
prob <- riskcomp$prob
num <- as.numeric(as.character(riskcomp$type1))
type <- riskcomp$type1
ns <- length(unique(idXP))
ratio <- x/c

### Risky Comparison
#dat <- dump.format(list(N=length(choice_data), choice_data=choice_data, x = x, c = c, idXP = idXP, ns=ns, ratio = ratio, num = num))

dat <- dump.format(list(N=length(choice_data), choice_data=choice_data, x = x, c = c, num = num, prob = prob, idXP = idXP, ns=ns))

inits1 <- dump.format(list(noise.mu=0.01,noise.si=0.1,sigma.mu=0.1,sigma.si = 0.1, .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
inits2 <- dump.format(list(noise.mu=0.01,noise.si=0.1,sigma.mu=0.1,sigma.si = 0.1, .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
inits3 <- dump.format(list(noise.mu=0.01,noise.si=0.1,sigma.mu=0.1,sigma.si = 0.1, .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))

### Risky Comparison
monitor = c("noise.mu", "sigma.mu", "noise.mu.coin", "sigma.mu.coin", 
            "noise.p","sigma.p","noise.p.coin","sigma.p.coin","deviance")


model_symbolic_v02 <- run.jags(model="D:/Projects/RISKPRECISION/data/jags_file/riskPrec_separat.txt", monitor=monitor,
                         data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=10000, sample=1000, thin=10)

save(precision_magSym,    file="precision_magSym.RData")
save(precision_magCoin,   file="precision_magCoin.RData")
save(precision_symCoin,   file="precision_symCoin.RData")


source("D:/Projects/PECONFOOD_fMRI_TMS/SFS_BehaviorData/subjects_choices/HDIofMCMC.r")

### RISK VERSUS COIN 

##### BAYESIAN POSTERIOR ANALYSIS ####
load("rprec_symcoins.RData") 

model01 = rbind(model01$mcmc[[1]], model01$mcmc[[2]], model01$mcmc[[3]])
model02 = rbind(model02$mcmc[[1]], model02$mcmc[[2]], model02$mcmc[[3]])

prec_sym2 <- symcoin2[,"noise.mu"]        ### PRECISION FOR SYMBOLIC NUMBERS
prec_dff <- symcoin[,"noise.mu.coin"]   ### PRECISION DIFFERENCE
prec_coin <- prec_sym + prec_dff        ### PRECISION COIN

risk_sym_intercept2 <- symcoin2[,"sigma.mu"]        ### Intercept for symbolic numbers
risk_dff_intercept <- symcoin[,"sigma.mu.coin"]   ### Intercept difference 
risk_coin_intercept <- risk_sym_intercept + risk_dff_intercept ### Intercept for coins


noise_model1 <- model01[,"noise.mu.coin"]
noise_model2 <- model02[,"noise.mu.coin"]

sigma_model1 <- model01[,"sigma.mu.coin"]
sigma_model2 <- model02[,"sigma.mu.coin"]

prior_sym <- 1/(prec_sym*sqrt(2)*((risk_sym_intercept/prec_sym) - log(1/0.55))/log(1/0.55)  )
prior_coin <- 1/(prec_coin*sqrt(2)*(risk_coin_intercept/prec_coin) - log(1/0.55))/log(1/0.55)   )                            


prior_sym2 <- log(1/0.55)/(2*(prec_sym^2))*((risk_sym_intercept/prec_sym) - log(1/0.55))
prior_coin2 <- log(1/0.55)/(2*(prec_coin^2))*((risk_coin_intercept/prec_coin) - log(1/0.55))


rnp_sym <- exp(-risk_sym_intercept/prec_sym)
rnp_coin <- exp(-risk_coin_intercept/prec_coin)

ip_sym <- exp(risk_sym_intercept/prec_sym)
ip_coin <- exp(risk_coin_intercept/prec_coin)




#### For Alternative Models
crra_symCoin_logit2 <- run.jags(model="D:/Projects/DDM/riskPrec_crraSymCoin.txt", monitor=monitor,
                           data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=50000, sample=1000, thin=50)

#save(crra_symCoin_logit,   file="crra_symCoin_logit.RData")
#save(crra_symCoin_probit,   file="crra_symCoin_probit.RData")

save(crra_symCoin_logit2,   file="crra_symCoin_logit2.RData")
save(crra_symCoin_probit2,   file="crra_symCoin_probit2.RData")

####
cpt_symCoin_probit <- run.jags(model="D:/Projects/DDM/riskPrec_cptSymCoin.txt", monitor=monitor,
                              data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=50000, sample=1000, thin=50)

save(cpt_symCoin_logit,   file="cpt_symCoin_logit.RData")
save(cpt_symCoin_probit,   file="cpt_symCoin_probit.RData")


salience_symCoin_logit <- run.jags(model="D:/Projects/DDM/riskPrec_salienceSymCoin.txt", monitor=monitor,
                              data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=1000, sample=1000, thin=1)

save(salience_symCoin_logit,   file="salience_symCoin_logit.RData")
save(salience_symCoin_probit,  file="salience_symCoin_probit.RData")

####


save(cpt2_symcoinsNew_logit,   file="cpt2_symcoinsNew_logit.RData")
save(cpt2_coinsNew_logit,   file="cpt2_coinsNew_logit.RData")
save(cpt2_symNew_logit,   file="cpt2_symNew_logit.RData")


save(cpt_symcoinsNew_logit,   file="cpt_symcoinsNew_logit.RData")
save(cpt_symcoinsNew_probit,  file="cpt_symcoinsNew_probit.RData")
save(cpt_coinsNew_logit,   file="cpt_coinsNew_logit.RData")
save(cpt_coinsNew_probit,  file="cpt_coinsNew_probit.RData")
save(cpt_symNew_logit,   file="cpt_symNew_logit.RData")
save(cpt_symNew_probit,  file="cpt_symNew_probit.RData")

save(salience_symcoinsNew_logit_fin,   file="salience_symcoinsNew_logit_fin.RData")
save(salience_symcoinsNew_probit_fin,  file="salience_symcoinsNew_probit_fin.RData")
save(salience_coinsNew_logit_fin,      file="salience_coinsNew_logit_fin.RData")
save(salience_coinsNew_probit_fin,     file="salience_coinsNew_probit_fin.RData")
save(salience_symNew_logit_fin,        file="salience_symNew_logit_fin.RData")
save(salience_symNew_probit_fin,       file="cpt_symNew_probit_fin.RData")



save(rprec_symcoins2,   file="rprec_symcoins2.RData")


save(rprec_magAgg,   file="rprec_magAgg.RData")

riskcomp <- read.csv("prec_neural_sub.csv")

save(rprec_symcoinsAgg,   file="rprec_symcoinsAgg.RData")
save(rprec_symAgg,        file="rprec_symAgg.RData")
save(rprec_coinsAgg,      file="rprec_coinsAgg.RData")

pi <- riskcomp$riskav_risk3
gam <- riskcomp$risk_prec3

intercept <- riskcomp$int_risk3
slope <- riskcomp$risk_prec3

pi <- exp(-intercept/slope)

### Heterogeneity
dat <- dump.format(list(N=length(pi), pi=pi, gam = gam))
inits1 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
inits2 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
inits3 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))

monitor = c("invar.mu", "sigma.mu","deviance")
rr_df0 <- run.jags(model="D:/Projects/RISKPRECISION/data/jags_file/heterogen.txt", monitor=monitor,
                   data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=10000, sample=1000, thin=10)
