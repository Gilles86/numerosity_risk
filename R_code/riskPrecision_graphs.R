
### Take the 

riskcomp <- read.csv("magRiskData.csv")

for(i in 1:length(riskcomp$choice))
{
  if(riskcomp$choice[i] == 1){
    riskcomp$risky[i] <- 0
  } else if (riskcomp$choice[i] == -1){
    riskcomp$risky[i] <- 1
  } else if (riskcomp$choice[i] == -2){
    riskcomp$risky[i] <- 'NA'
  } else if (riskcomp$choice[i] == 2){
    riskcomp$risky[i] <- 'NA'
  }
}

#########################################################################################################################################


x0 <- seq(0, 10, length=1000)

hx0 <- dlnorm((x0))

degf <- c(7,10,14,20,28)
colors <- c("orange", "yellow", "green", "blue", "purple")
labels <- c("df=1", "df=3", "df=8", "df=30", "normal")


mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

plot(5*x0, hx0, type="l", lty=1, xlab="Magnitude", lwd = 20,
     ylab="Density", main="Tuning Curves", xlim = c(0,20), col = "red",
     cex.main = 3, cex.lab = 3, cex.axis = 2)

for (i in 1:5){
  lines(degf[i]*x0, hx0, lwd=20, col=colors[i])
}

riskcomp1 <- subset(riskcomp, type == 0 & exptype == 1)  ### Magnitude Comparison Task
riskcomp2 <- subset(riskcomp, exptype == 2)              ### Risky - Symbolic Numbers
riskcomp3 <- subset(riskcomp, exptype == 3)              ### Risky - Pile of Coins              ### Risky - Pile of Coins

r1_05 <- subset(riskcomp1, sure_bet == 5); r1_07 <- subset(riskcomp1, sure_bet == 7)
r1_10 <- subset(riskcomp1, sure_bet == 10); r1_14 <- subset(riskcomp1, sure_bet == 14)
r1_20 <- subset(riskcomp1, sure_bet == 20); r1_28 <- subset(riskcomp1, sure_bet == 28)

r1_05 <- r1_05[order(r1_05$prob_bet),]; r1_07 <- r1_07[order(r1_07$prob_bet),]
r1_10 <- r1_10[order(r1_10$prob_bet),]; r1_14 <- r1_14[order(r1_14$prob_bet),]
r1_20 <- r1_20[order(r1_20$prob_bet),]; r1_28 <- r1_28[order(r1_28$prob_bet),]

r2_05 <- subset(riskcomp2, sure_bet == 5);  r2_07 <- subset(riskcomp2, sure_bet == 7)
r2_10 <- subset(riskcomp2, sure_bet == 10); r2_14 <- subset(riskcomp2, sure_bet == 14)
r2_20 <- subset(riskcomp2, sure_bet == 20); r2_28 <- subset(riskcomp2, sure_bet == 28)

r3_05 <- subset(riskcomp3, sure_bet == 5);  r3_07 <- subset(riskcomp3, sure_bet == 7)
r3_10 <- subset(riskcomp3, sure_bet == 10); r3_14 <- subset(riskcomp3, sure_bet == 14)
r3_20 <- subset(riskcomp3, sure_bet == 20); r3_28 <- subset(riskcomp3, sure_bet == 28)

mag_05 <- pnorm(3*log(r1_05$prob_bet) - 1,0,1)
mag_07 <- pnorm(3*log(r1_07$prob_bet) - 1,0,1)
mag_10 <- pnorm(log(r1_10$prob_bet),0,1)

plot(r1_05$prob_bet, mag_05,  col = "white", , pch = 16, cex.main = 3, cex = 3.5, cex.lab = 2.5, cex.axis = 2, 
     main = "LINEAR",xlab = "2nd Pile of Coins", ylab = "Pr(Choose 2nd Pile)", xlim = c(0,80), ylim = c(0,1))
lines(r1_05$prob_bet, mag_05,  lwd = 8, col =  "red", pch = 16, cex = 2.5, lty = 1)
lines(r1_07$prob_bet, mag_07, lwd = 8, col =  "orange", pch = 16, cex = 2.5, lty = 1)
lines(r1_07$prob_bet, mag_08,  lwd = 8, col =  rgb3, pch = 16, cex = 2.5, lty = 1)
lines(prob_bet14, mag_14,  lwd = 8, col =  rgb4, pch = 16, cex = 2.5, lty = 1)
lines(prob_bet20, mag_20,  lwd = 8, col =  rgb5, pch = 16, cex = 2.5, lty = 1)
lines(prob_bet28, mag_28,  lwd = 8, col =  rgb6, pch = 16, cex = 2.5, lty = 1)

#########################################################################################################################################


riskcomp$risky <- as.numeric(as.character(riskcomp$risky))

riskcomp1 <- subset(riskcomp, type == 0 & exptype == 1)  ### Magnitude Comparison Task
riskcomp2 <- subset(riskcomp, exptype == 2)              ### Risky - Symbolic Numbers
riskcomp3 <- subset(riskcomp, exptype == 3)              ### Risky - Pile of Coins              ### Risky - Pile of Coins

### ALL
riskcomp4 <- rbind(riskcomp2, riskcomp3)                             ### Subset of Total

#riskcomp05 <- subset(riskcomp, sure_bet == 5);  riskcomp07 <- subset(riskcomp, sure_bet == 7)
#riskcomp10 <- subset(riskcomp, sure_bet == 10); riskcomp14 <- subset(riskcomp, sure_bet == 14)
#riskcomp20 <- subset(riskcomp, sure_bet == 20); riskcomp28 <- subset(riskcomp, sure_bet == 28)

#riskcomp05 <- riskcomp05[order(riskcomp05$prob_bet),]; riskcomp07 <- riskcomp07[order(riskcomp07$prob_bet),]
#riskcomp10 <- riskcomp10[order(riskcomp10$prob_bet),]; riskcomp14 <- riskcomp14[order(riskcomp14$prob_bet),]
#riskcomp20 <- riskcomp20[order(riskcomp20$prob_bet),]; riskcomp28 <- riskcomp28[order(riskcomp28$prob_bet),]
#riskcomp <- riskcomp[order(riskcomp$prob_bet/riskcomp$sure_bet),]

### MAGNITUDE
riskcomp1_05 <- subset(riskcomp1, sure_bet == 5);  riskcomp1_07 <- subset(riskcomp1, sure_bet == 7)
riskcomp1_10 <- subset(riskcomp1, sure_bet == 10); riskcomp1_14 <- subset(riskcomp1, sure_bet == 14)
riskcomp1_20 <- subset(riskcomp1, sure_bet == 20); riskcomp1_28 <- subset(riskcomp1, sure_bet == 28)

riskcomp1_05 <- riskcomp1_05[order(riskcomp1_05$prob_bet),]; riskcomp1_07 <- riskcomp1_07[order(riskcomp1_07$prob_bet),]
riskcomp1_10 <- riskcomp1_10[order(riskcomp1_10$prob_bet),]; riskcomp1_14 <- riskcomp1_14[order(riskcomp1_14$prob_bet),]
riskcomp1_20 <- riskcomp1_20[order(riskcomp1_20$prob_bet),]; riskcomp1_28 <- riskcomp1_28[order(riskcomp1_28$prob_bet),]
riskcomp1 <- riskcomp1[order(riskcomp1$prob_bet/riskcomp1$sure_bet),]

### RISKY CHOICE - NUMBERS
riskcomp2_05 <- subset(riskcomp2, sure_bet == 5);  riskcomp2_07 <- subset(riskcomp2, sure_bet == 7)
riskcomp2_10 <- subset(riskcomp2, sure_bet == 10); riskcomp2_14 <- subset(riskcomp2, sure_bet == 14)
riskcomp2_20 <- subset(riskcomp2, sure_bet == 20); riskcomp2_28 <- subset(riskcomp2, sure_bet == 28)

riskcomp2_05 <- riskcomp2_05[order(riskcomp2_05$prob_bet),]; riskcomp2_07 <- riskcomp2_07[order(riskcomp2_07$prob_bet),]
riskcomp2_10 <- riskcomp2_10[order(riskcomp2_10$prob_bet),]; riskcomp2_14 <- riskcomp2_14[order(riskcomp2_14$prob_bet),]
riskcomp2_20 <- riskcomp2_20[order(riskcomp2_20$prob_bet),]; riskcomp2_28 <- riskcomp2_28[order(riskcomp2_28$prob_bet),]
riskcomp2 <- riskcomp2[order(riskcomp2$prob_bet/riskcomp2$sure_bet),]

### RISKY CHOICE - COINS
riskcomp3_05 <- subset(riskcomp3, sure_bet == 5);  riskcomp3_07 <- subset(riskcomp3, sure_bet == 7)
riskcomp3_10 <- subset(riskcomp3, sure_bet == 10); riskcomp3_14 <- subset(riskcomp3, sure_bet == 14)
riskcomp3_20 <- subset(riskcomp3, sure_bet == 20); riskcomp3_28 <- subset(riskcomp3, sure_bet == 28)

riskcomp3_05 <- riskcomp3_05[order(riskcomp3_05$prob_bet),]; riskcomp3_07 <- riskcomp3_07[order(riskcomp3_07$prob_bet),]
riskcomp3_10 <- riskcomp3_10[order(riskcomp3_10$prob_bet),]; riskcomp3_14 <- riskcomp3_14[order(riskcomp3_14$prob_bet),]
riskcomp3_20 <- riskcomp3_20[order(riskcomp3_20$prob_bet),]; riskcomp3_28 <- riskcomp3_28[order(riskcomp3_28$prob_bet),]
riskcomp3 <- riskcomp3[order(riskcomp3$prob_bet/riskcomp3$sure_bet),]

### RISKY CHOICE - POOLED
riskcomp4_05 <- subset(riskcomp4, sure_bet == 5);  riskcomp4_07 <- subset(riskcomp4, sure_bet == 7)
riskcomp4_10 <- subset(riskcomp4, sure_bet == 10); riskcomp4_14 <- subset(riskcomp4, sure_bet == 14)
riskcomp4_20 <- subset(riskcomp4, sure_bet == 20); riskcomp4_28 <- subset(riskcomp4, sure_bet == 28)

riskcomp4_05 <- riskcomp4_05[order(riskcomp4_05$prob_bet),]; riskcomp4_07 <- riskcomp4_07[order(riskcomp4_07$prob_bet),]
riskcomp4_10 <- riskcomp4_10[order(riskcomp4_10$prob_bet),]; riskcomp4_14 <- riskcomp4_14[order(riskcomp4_14$prob_bet),]
riskcomp4_20 <- riskcomp4_20[order(riskcomp4_20$prob_bet),]; riskcomp4_28 <- riskcomp4_28[order(riskcomp4_28$prob_bet),]
riskcomp4 <- riskcomp4[order(riskcomp4$prob_bet/riskcomp4$sure_bet),]



#########################################################################################################################################
### Base 5
############################
### Magnitude Comparison ###
mag_05_02 <- subset(riskcomp1_05, prob_bet ==  2); mu_mag_05_02 <- mean(na.omit(mag_05_02$risky))
mag_05_03 <- subset(riskcomp1_05, prob_bet ==  3); mu_mag_05_03 <- mean(na.omit(mag_05_03$risky))
mag_05_04 <- subset(riskcomp1_05, prob_bet ==  4); mu_mag_05_04 <- mean(na.omit(mag_05_04$risky))
mag_05_06 <- subset(riskcomp1_05, prob_bet ==  6); mu_mag_05_06 <- mean(na.omit(mag_05_06$risky))
mag_05_07 <- subset(riskcomp1_05, prob_bet ==  7); mu_mag_05_07 <- mean(na.omit(mag_05_07$risky))
mag_05_10 <- subset(riskcomp1_05, prob_bet == 10); mu_mag_05_10 <- mean(na.omit(mag_05_10$risky))
mag_05_14 <- subset(riskcomp1_05, prob_bet == 14); mu_mag_05_14 <- mean(na.omit(mag_05_14$risky))

mu_mag_05 <- c(mu_mag_05_02, mu_mag_05_03, mu_mag_05_04, mu_mag_05_06, mu_mag_05_07, mu_mag_05_10, mu_mag_05_14)
prob_mag_05<- c(2,3,4,6,7,10,14)

####################
### Risky Choice - NUMBERS ###
risk2_05_06 <- subset(riskcomp2_05, prob_bet ==  6); mu_risk2_05_06 <- mean(na.omit(risk2_05_06$risky))
risk2_05_07 <- subset(riskcomp2_05, prob_bet ==  7); mu_risk2_05_07 <- mean(na.omit(risk2_05_07$risky))
risk2_05_08 <- subset(riskcomp2_05, prob_bet ==  8); mu_risk2_05_08 <- mean(na.omit(risk2_05_08$risky))
risk2_05_10 <- subset(riskcomp2_05, prob_bet == 10); mu_risk2_05_10 <- mean(na.omit(risk2_05_10$risky))
risk2_05_12 <- subset(riskcomp2_05, prob_bet == 12); mu_risk2_05_12 <- mean(na.omit(risk2_05_12$risky))
risk2_05_14 <- subset(riskcomp2_05, prob_bet == 14); mu_risk2_05_14 <- mean(na.omit(risk2_05_14$risky))
risk2_05_17 <- subset(riskcomp2_05, prob_bet == 17); mu_risk2_05_17 <- mean(na.omit(risk2_05_17$risky))
risk2_05_20 <- subset(riskcomp2_05, prob_bet == 20); mu_risk2_05_20 <- mean(na.omit(risk2_05_20$risky))

mu_risk2_05 <- c(mu_risk2_05_06, mu_risk2_05_07, mu_risk2_05_08, mu_risk2_05_10, mu_risk2_05_12, mu_risk2_05_14, mu_risk2_05_17, mu_risk2_05_20)
prob_risk2_05<- c(6,7,8,10,12,14,17,20)

####################
### Risky Choice - COINS ###
risk3_05_06 <- subset(riskcomp3_05, prob_bet ==  6); mu_risk3_05_06 <- mean(na.omit(risk3_05_06$risky))
risk3_05_07 <- subset(riskcomp3_05, prob_bet ==  7); mu_risk3_05_07 <- mean(na.omit(risk3_05_07$risky))
risk3_05_08 <- subset(riskcomp3_05, prob_bet ==  8); mu_risk3_05_08 <- mean(na.omit(risk3_05_08$risky))
risk3_05_10 <- subset(riskcomp3_05, prob_bet == 10); mu_risk3_05_10 <- mean(na.omit(risk3_05_10$risky))
risk3_05_12 <- subset(riskcomp3_05, prob_bet == 12); mu_risk3_05_12 <- mean(na.omit(risk3_05_12$risky))
risk3_05_14 <- subset(riskcomp3_05, prob_bet == 14); mu_risk3_05_14 <- mean(na.omit(risk3_05_14$risky))
risk3_05_17 <- subset(riskcomp3_05, prob_bet == 17); mu_risk3_05_17 <- mean(na.omit(risk3_05_17$risky))
risk3_05_20 <- subset(riskcomp3_05, prob_bet == 20); mu_risk3_05_20 <- mean(na.omit(risk3_05_20$risky))

mu_risk3_05 <- c(mu_risk3_05_06, mu_risk3_05_07, mu_risk3_05_08, mu_risk3_05_10, mu_risk3_05_12, mu_risk3_05_14, mu_risk3_05_17, mu_risk3_05_20)
prob_risk3_05<- c(6,7,8,10,12,14,17,20)

####################
### Risky Choice - POOLED ###
risk4_05_06 <- subset(riskcomp4_05, prob_bet ==  6); mu_risk4_05_06 <- mean(na.omit(risk4_05_06$risky))
risk4_05_07 <- subset(riskcomp4_05, prob_bet ==  7); mu_risk4_05_07 <- mean(na.omit(risk4_05_07$risky))
risk4_05_08 <- subset(riskcomp4_05, prob_bet ==  8); mu_risk4_05_08 <- mean(na.omit(risk4_05_08$risky))
risk4_05_10 <- subset(riskcomp4_05, prob_bet == 10); mu_risk4_05_10 <- mean(na.omit(risk4_05_10$risky))
risk4_05_12 <- subset(riskcomp4_05, prob_bet == 12); mu_risk4_05_12 <- mean(na.omit(risk4_05_12$risky))
risk4_05_14 <- subset(riskcomp4_05, prob_bet == 14); mu_risk4_05_14 <- mean(na.omit(risk4_05_14$risky))
risk4_05_17 <- subset(riskcomp4_05, prob_bet == 17); mu_risk4_05_17 <- mean(na.omit(risk4_05_17$risky))
risk4_05_20 <- subset(riskcomp4_05, prob_bet == 20); mu_risk4_05_20 <- mean(na.omit(risk4_05_20$risky))

mu_risk4_05 <- c(mu_risk4_05_06, mu_risk4_05_07, mu_risk4_05_08, mu_risk4_05_10, mu_risk4_05_12, mu_risk4_05_14, mu_risk4_05_17, mu_risk4_05_20)
prob_risk4_05<- c(6,7,8,10,12,14,17,20)


#########################################################################################################################################
### Base 7
############################
### Magnitude Comparison ###
mag_07_02 <- subset(riskcomp1_07, prob_bet ==  2); mu_mag_07_02 <- mean(na.omit(mag_07_02$risky))
mag_07_04 <- subset(riskcomp1_07, prob_bet ==  4); mu_mag_07_04 <- mean(na.omit(mag_07_04$risky))
mag_07_05 <- subset(riskcomp1_07, prob_bet ==  5); mu_mag_07_05 <- mean(na.omit(mag_07_05$risky))
mag_07_06 <- subset(riskcomp1_07, prob_bet ==  6); mu_mag_07_06 <- mean(na.omit(mag_07_06$risky))
mag_07_08 <- subset(riskcomp1_07, prob_bet ==  8); mu_mag_07_08 <- mean(na.omit(mag_07_08$risky))
mag_07_10 <- subset(riskcomp1_07, prob_bet == 10); mu_mag_07_10 <- mean(na.omit(mag_07_10$risky))
mag_07_14 <- subset(riskcomp1_07, prob_bet == 14); mu_mag_07_14 <- mean(na.omit(mag_07_14$risky))
mag_07_20 <- subset(riskcomp1_07, prob_bet == 20); mu_mag_07_20 <- mean(na.omit(mag_07_20$risky))

mu_mag_07 <- c(mu_mag_07_02, mu_mag_07_04, mu_mag_07_05, mu_mag_07_06, mu_mag_07_08, mu_mag_07_10, mu_mag_07_14, mu_mag_07_20)
prob_mag_07<- c(2,4,5,6,8,10,14,20)

####################
### Risky Choice - NUMBERS ###
risk2_07_08 <- subset(riskcomp2_07, prob_bet ==  8); mu_risk2_07_08 <- mean(na.omit(risk2_07_08$risky))
risk2_07_09 <- subset(riskcomp2_07, prob_bet ==  9); mu_risk2_07_09 <- mean(na.omit(risk2_07_09$risky))
risk2_07_10 <- subset(riskcomp2_07, prob_bet == 10); mu_risk2_07_10 <- mean(na.omit(risk2_07_10$risky))
risk2_07_12 <- subset(riskcomp2_07, prob_bet == 12); mu_risk2_07_12 <- mean(na.omit(risk2_07_12$risky))
risk2_07_14 <- subset(riskcomp2_07, prob_bet == 14); mu_risk2_07_14 <- mean(na.omit(risk2_07_14$risky))
risk2_07_17 <- subset(riskcomp2_07, prob_bet == 17); mu_risk2_07_17 <- mean(na.omit(risk2_07_17$risky))
risk2_07_20 <- subset(riskcomp2_07, prob_bet == 20); mu_risk2_07_20 <- mean(na.omit(risk2_07_20$risky))
risk2_07_24 <- subset(riskcomp2_07, prob_bet == 24); mu_risk2_07_24 <- mean(na.omit(risk2_07_24$risky))
risk2_07_28 <- subset(riskcomp2_07, prob_bet == 28); mu_risk2_07_28 <- mean(na.omit(risk2_07_28$risky))

mu_risk2_07 <- c(mu_risk2_07_08, mu_risk2_07_09, mu_risk2_07_10, mu_risk2_07_12, mu_risk2_07_14, mu_risk2_07_17, mu_risk2_07_20, mu_risk2_07_24, mu_risk2_07_28)
prob_risk2_07<- c(8,9,10,12,14,17,20,24,28)

####################
### Risky Choice - COINS ###
risk3_07_08 <- subset(riskcomp3_07, prob_bet ==  8); mu_risk3_07_08 <- mean(na.omit(risk3_07_08$risky))
risk3_07_09 <- subset(riskcomp3_07, prob_bet ==  9); mu_risk3_07_09 <- mean(na.omit(risk3_07_09$risky))
risk3_07_10 <- subset(riskcomp3_07, prob_bet == 10); mu_risk3_07_10 <- mean(na.omit(risk3_07_10$risky))
risk3_07_12 <- subset(riskcomp3_07, prob_bet == 12); mu_risk3_07_12 <- mean(na.omit(risk3_07_12$risky))
risk3_07_14 <- subset(riskcomp3_07, prob_bet == 14); mu_risk3_07_14 <- mean(na.omit(risk3_07_14$risky))
risk3_07_17 <- subset(riskcomp3_07, prob_bet == 17); mu_risk3_07_17 <- mean(na.omit(risk3_07_17$risky))
risk3_07_20 <- subset(riskcomp3_07, prob_bet == 20); mu_risk3_07_20 <- mean(na.omit(risk3_07_20$risky))
risk3_07_24 <- subset(riskcomp3_07, prob_bet == 24); mu_risk3_07_24 <- mean(na.omit(risk3_07_24$risky))
risk3_07_28 <- subset(riskcomp3_07, prob_bet == 28); mu_risk3_07_28 <- mean(na.omit(risk3_07_28$risky))

mu_risk3_07 <- c(mu_risk3_07_08, mu_risk3_07_09, mu_risk3_07_10, mu_risk3_07_12, mu_risk3_07_14, mu_risk3_07_17, mu_risk3_07_20, mu_risk3_07_24, mu_risk3_07_28)
prob_risk3_07<- c(8,9,10,12,14,17,20,24,28)

####################
### Risky Choice - POOLED ###
risk4_07_08 <- subset(riskcomp4_07, prob_bet ==  8); mu_risk4_07_08 <- mean(na.omit(risk4_07_08$risky))
risk4_07_09 <- subset(riskcomp4_07, prob_bet ==  9); mu_risk4_07_09 <- mean(na.omit(risk4_07_09$risky))
risk4_07_10 <- subset(riskcomp4_07, prob_bet == 10); mu_risk4_07_10 <- mean(na.omit(risk4_07_10$risky))
risk4_07_12 <- subset(riskcomp4_07, prob_bet == 12); mu_risk4_07_12 <- mean(na.omit(risk4_07_12$risky))
risk4_07_14 <- subset(riskcomp4_07, prob_bet == 14); mu_risk4_07_14 <- mean(na.omit(risk4_07_14$risky))
risk4_07_17 <- subset(riskcomp4_07, prob_bet == 17); mu_risk4_07_17 <- mean(na.omit(risk4_07_17$risky))
risk4_07_20 <- subset(riskcomp4_07, prob_bet == 20); mu_risk4_07_20 <- mean(na.omit(risk4_07_20$risky))
risk4_07_24 <- subset(riskcomp4_07, prob_bet == 24); mu_risk4_07_24 <- mean(na.omit(risk4_07_24$risky))
risk4_07_28 <- subset(riskcomp4_07, prob_bet == 28); mu_risk4_07_28 <- mean(na.omit(risk4_07_28$risky))

mu_risk4_07 <- c(mu_risk4_07_08, mu_risk4_07_09, mu_risk4_07_10, mu_risk4_07_12, mu_risk4_07_14, mu_risk4_07_17, mu_risk4_07_20, mu_risk4_07_24, mu_risk4_07_28)
prob_risk4_07<- c(8,9,10,12,14,17,20,24,28)

#########################################################################################################################################
### Base 10
############################
### Magnitude Comparison ###
mag_10_04 <- subset(riskcomp1_10, prob_bet ==  4); mu_mag_10_04 <- mean(na.omit(mag_10_04$risky))
mag_10_05 <- subset(riskcomp1_10, prob_bet ==  5); mu_mag_10_05 <- mean(na.omit(mag_10_05$risky))
mag_10_07 <- subset(riskcomp1_10, prob_bet ==  7); mu_mag_10_07 <- mean(na.omit(mag_10_07$risky))
mag_10_09 <- subset(riskcomp1_10, prob_bet ==  9); mu_mag_10_09 <- mean(na.omit(mag_10_09$risky))
mag_10_11 <- subset(riskcomp1_10, prob_bet == 11); mu_mag_10_11 <- mean(na.omit(mag_10_11$risky))
mag_10_14 <- subset(riskcomp1_10, prob_bet == 14); mu_mag_10_14 <- mean(na.omit(mag_10_14$risky))
mag_10_20 <- subset(riskcomp1_10, prob_bet == 20); mu_mag_10_20 <- mean(na.omit(mag_10_20$risky))
mag_10_28 <- subset(riskcomp1_10, prob_bet == 28); mu_mag_10_28 <- mean(na.omit(mag_10_28$risky))

mu_mag_10 <- c(mu_mag_10_04, mu_mag_10_05, mu_mag_10_07, mu_mag_10_09, mu_mag_10_11, mu_mag_10_14, mu_mag_10_20, mu_mag_10_28)
prob_mag_10<- c(4,5,7,9,11,14,20,28)

####################
### Risky Choice - NUMBERS ###
risk2_10_11 <- subset(riskcomp2_10, prob_bet == 11); mu_risk2_10_11 <- mean(na.omit(risk2_10_11$risky))
risk2_10_12 <- subset(riskcomp2_10, prob_bet == 12); mu_risk2_10_12 <- mean(na.omit(risk2_10_12$risky)) 
risk2_10_14 <- subset(riskcomp2_10, prob_bet == 14); mu_risk2_10_14 <- mean(na.omit(risk2_10_14$risky))
risk2_10_17 <- subset(riskcomp2_10, prob_bet == 17); mu_risk2_10_17 <- mean(na.omit(risk2_10_17$risky))
risk2_10_20 <- subset(riskcomp2_10, prob_bet == 20); mu_risk2_10_20 <- mean(na.omit(risk2_10_20$risky))
risk2_10_24 <- subset(riskcomp2_10, prob_bet == 24); mu_risk2_10_24 <- mean(na.omit(risk2_10_24$risky))
risk2_10_28 <- subset(riskcomp2_10, prob_bet == 28); mu_risk2_10_28 <- mean(na.omit(risk2_10_28$risky))
risk2_10_34 <- subset(riskcomp2_10, prob_bet == 34); mu_risk2_10_34 <- mean(na.omit(risk2_10_34$risky))
risk2_10_40 <- subset(riskcomp2_10, prob_bet == 40); mu_risk2_10_40 <- mean(na.omit(risk2_10_40$risky))

mu_risk2_10 <- c(mu_risk2_10_11, mu_risk2_10_12, mu_risk2_10_14, mu_risk2_10_17, mu_risk2_10_20, mu_risk2_10_24, mu_risk2_10_28, mu_risk2_10_34, mu_risk2_10_40)
prob_risk2_10<- c(11,12,14,17,20,24,28,34,40)

####################
### Risky Choice - COINS ###
risk3_10_11 <- subset(riskcomp3_10, prob_bet == 11); mu_risk3_10_11 <- mean(na.omit(risk3_10_11$risky))
risk3_10_12 <- subset(riskcomp3_10, prob_bet == 12); mu_risk3_10_12 <- mean(na.omit(risk3_10_12$risky)) 
risk3_10_14 <- subset(riskcomp3_10, prob_bet == 14); mu_risk3_10_14 <- mean(na.omit(risk3_10_14$risky))
risk3_10_17 <- subset(riskcomp3_10, prob_bet == 17); mu_risk3_10_17 <- mean(na.omit(risk3_10_17$risky))
risk3_10_20 <- subset(riskcomp3_10, prob_bet == 20); mu_risk3_10_20 <- mean(na.omit(risk3_10_20$risky))
risk3_10_24 <- subset(riskcomp3_10, prob_bet == 24); mu_risk3_10_24 <- mean(na.omit(risk3_10_24$risky))
risk3_10_28 <- subset(riskcomp3_10, prob_bet == 28); mu_risk3_10_28 <- mean(na.omit(risk3_10_28$risky))
risk3_10_34 <- subset(riskcomp3_10, prob_bet == 34); mu_risk3_10_34 <- mean(na.omit(risk3_10_34$risky))
risk3_10_40 <- subset(riskcomp3_10, prob_bet == 40); mu_risk3_10_40 <- mean(na.omit(risk3_10_40$risky))

mu_risk3_10 <- c(mu_risk3_10_11, mu_risk3_10_12, mu_risk3_10_14, mu_risk3_10_17, mu_risk3_10_20, mu_risk3_10_24, mu_risk3_10_28, mu_risk3_10_34, mu_risk3_10_40)
prob_risk3_10<- c(11,12,14,17,20,24,28,34,40)

####################
### Risky Choice - POOLED ###
risk4_10_11 <- subset(riskcomp4_10, prob_bet == 11); mu_risk4_10_11 <- mean(na.omit(risk4_10_11$risky))
risk4_10_12 <- subset(riskcomp4_10, prob_bet == 12); mu_risk4_10_12 <- mean(na.omit(risk4_10_12$risky)) 
risk4_10_14 <- subset(riskcomp4_10, prob_bet == 14); mu_risk4_10_14 <- mean(na.omit(risk4_10_14$risky))
risk4_10_17 <- subset(riskcomp4_10, prob_bet == 17); mu_risk4_10_17 <- mean(na.omit(risk4_10_17$risky))
risk4_10_20 <- subset(riskcomp4_10, prob_bet == 20); mu_risk4_10_20 <- mean(na.omit(risk4_10_20$risky))
risk4_10_24 <- subset(riskcomp4_10, prob_bet == 24); mu_risk4_10_24 <- mean(na.omit(risk4_10_24$risky))
risk4_10_28 <- subset(riskcomp4_10, prob_bet == 28); mu_risk4_10_28 <- mean(na.omit(risk4_10_28$risky))
risk4_10_34 <- subset(riskcomp4_10, prob_bet == 34); mu_risk4_10_34 <- mean(na.omit(risk4_10_34$risky))
risk4_10_40 <- subset(riskcomp4_10, prob_bet == 40); mu_risk4_10_40 <- mean(na.omit(risk4_10_40$risky))

mu_risk4_10 <- c(mu_risk4_10_11, mu_risk4_10_12, mu_risk4_10_14, mu_risk4_10_17, mu_risk4_10_20, mu_risk4_10_24, mu_risk4_10_28, mu_risk4_10_34, mu_risk4_10_40)
prob_risk4_10<- c(11,12,14,17,20,24,28,34,40)


#########################################################################################################################################
### Base 14
############################
### Magnitude Comparison ###
mag_14_05 <- subset(riskcomp1_14, prob_bet ==  5); mu_mag_14_05 <- mean(na.omit(mag_14_05$risky))
mag_14_07 <- subset(riskcomp1_14, prob_bet ==  7); mu_mag_14_07 <- mean(na.omit(mag_14_07$risky))
mag_14_10 <- subset(riskcomp1_14, prob_bet == 10); mu_mag_14_10 <- mean(na.omit(mag_14_10$risky))
mag_14_13 <- subset(riskcomp1_14, prob_bet == 13); mu_mag_14_13 <- mean(na.omit(mag_14_13$risky))
mag_14_15 <- subset(riskcomp1_14, prob_bet == 15); mu_mag_14_15 <- mean(na.omit(mag_14_15$risky))
mag_14_20 <- subset(riskcomp1_14, prob_bet == 20); mu_mag_14_20 <- mean(na.omit(mag_14_20$risky))
mag_14_28 <- subset(riskcomp1_14, prob_bet == 28); mu_mag_14_28 <- mean(na.omit(mag_14_28$risky))
mag_14_40 <- subset(riskcomp1_14, prob_bet == 40); mu_mag_14_40 <- mean(na.omit(mag_14_40$risky))

mu_mag_14 <- c(mu_mag_14_05, mu_mag_14_07, mu_mag_14_10, mu_mag_14_13, mu_mag_14_15, mu_mag_14_20, mu_mag_14_28, mu_mag_14_40)
prob_mag_14<- c(5,7,10,13,15,20,28,40)

####################
### Risky Choice - NUMBERS ###
risk2_14_15 <- subset(riskcomp2_14, prob_bet == 15); mu_risk2_14_15 <- mean(na.omit(risk2_14_15$risky))
risk2_14_16 <- subset(riskcomp2_14, prob_bet == 16); mu_risk2_14_16 <- mean(na.omit(risk2_14_16$risky)) 
risk2_14_17 <- subset(riskcomp2_14, prob_bet == 17); mu_risk2_14_17 <- mean(na.omit(risk2_14_17$risky))
risk2_14_20 <- subset(riskcomp2_14, prob_bet == 20); mu_risk2_14_20 <- mean(na.omit(risk2_14_20$risky))
risk2_14_24 <- subset(riskcomp2_14, prob_bet == 24); mu_risk2_14_24 <- mean(na.omit(risk2_14_24$risky))
risk2_14_28 <- subset(riskcomp2_14, prob_bet == 28); mu_risk2_14_28 <- mean(na.omit(risk2_14_28$risky))
risk2_14_33 <- subset(riskcomp2_14, prob_bet == 33); mu_risk2_14_33 <- mean(na.omit(risk2_14_33$risky))
risk2_14_40 <- subset(riskcomp2_14, prob_bet == 40); mu_risk2_14_40 <- mean(na.omit(risk2_14_40$risky))
risk2_14_47 <- subset(riskcomp2_14, prob_bet == 47); mu_risk2_14_47 <- mean(na.omit(risk2_14_47$risky))
risk2_14_56 <- subset(riskcomp2_14, prob_bet == 56); mu_risk2_14_56 <- mean(na.omit(risk2_14_56$risky))

mu_risk2_14 <- c(mu_risk2_14_15, mu_risk2_14_16, mu_risk2_14_17, mu_risk2_14_20, mu_risk2_14_24, mu_risk2_14_28, mu_risk2_14_33, mu_risk2_14_40, mu_risk2_14_47, mu_risk2_14_56)
prob_risk2_14<- c(15,16,17,20,24,28,33,40,47,56)

####################
### Risky Choice - COINS ###
risk3_14_15 <- subset(riskcomp3_14, prob_bet == 15); mu_risk3_14_15 <- mean(na.omit(risk3_14_15$risky))
risk3_14_16 <- subset(riskcomp3_14, prob_bet == 16); mu_risk3_14_16 <- mean(na.omit(risk3_14_16$risky)) 
risk3_14_17 <- subset(riskcomp3_14, prob_bet == 17); mu_risk3_14_17 <- mean(na.omit(risk3_14_17$risky))
risk3_14_20 <- subset(riskcomp3_14, prob_bet == 20); mu_risk3_14_20 <- mean(na.omit(risk3_14_20$risky))
risk3_14_24 <- subset(riskcomp3_14, prob_bet == 24); mu_risk3_14_24 <- mean(na.omit(risk3_14_24$risky))
risk3_14_28 <- subset(riskcomp3_14, prob_bet == 28); mu_risk3_14_28 <- mean(na.omit(risk3_14_28$risky))
risk3_14_33 <- subset(riskcomp3_14, prob_bet == 33); mu_risk3_14_33 <- mean(na.omit(risk3_14_33$risky))
risk3_14_40 <- subset(riskcomp3_14, prob_bet == 40); mu_risk3_14_40 <- mean(na.omit(risk3_14_40$risky))
risk3_14_47 <- subset(riskcomp3_14, prob_bet == 47); mu_risk3_14_47 <- mean(na.omit(risk3_14_47$risky))
risk3_14_56 <- subset(riskcomp3_14, prob_bet == 56); mu_risk3_14_56 <- mean(na.omit(risk3_14_56$risky))

mu_risk3_14 <- c(mu_risk3_14_15, mu_risk3_14_16, mu_risk3_14_17, mu_risk3_14_20, mu_risk3_14_24, mu_risk3_14_28, mu_risk3_14_33, mu_risk3_14_40, mu_risk3_14_47, mu_risk3_14_56)
prob_risk3_14<- c(15,16,17,20,24,28,33,40,47,56)

####################
### Risky Choice - POOLED ###
risk4_14_15 <- subset(riskcomp4_14, prob_bet == 15); mu_risk4_14_15 <- mean(na.omit(risk4_14_15$risky))
risk4_14_16 <- subset(riskcomp4_14, prob_bet == 16); mu_risk4_14_16 <- mean(na.omit(risk4_14_16$risky)) 
risk4_14_17 <- subset(riskcomp4_14, prob_bet == 17); mu_risk4_14_17 <- mean(na.omit(risk4_14_17$risky))
risk4_14_20 <- subset(riskcomp4_14, prob_bet == 20); mu_risk4_14_20 <- mean(na.omit(risk4_14_20$risky))
risk4_14_24 <- subset(riskcomp4_14, prob_bet == 24); mu_risk4_14_24 <- mean(na.omit(risk4_14_24$risky))
risk4_14_28 <- subset(riskcomp4_14, prob_bet == 28); mu_risk4_14_28 <- mean(na.omit(risk4_14_28$risky))
risk4_14_33 <- subset(riskcomp4_14, prob_bet == 33); mu_risk4_14_33 <- mean(na.omit(risk4_14_33$risky))
risk4_14_40 <- subset(riskcomp4_14, prob_bet == 40); mu_risk4_14_40 <- mean(na.omit(risk4_14_40$risky))
risk4_14_47 <- subset(riskcomp4_14, prob_bet == 47); mu_risk4_14_47 <- mean(na.omit(risk4_14_47$risky))
risk4_14_56 <- subset(riskcomp4_14, prob_bet == 56); mu_risk4_14_56 <- mean(na.omit(risk4_14_56$risky))

mu_risk4_14 <- c(mu_risk4_14_15, mu_risk4_14_16, mu_risk4_14_17, mu_risk4_14_20, mu_risk4_14_24, mu_risk4_14_28, mu_risk4_14_33, mu_risk4_14_40, mu_risk4_14_47, mu_risk4_14_56)
prob_risk4_14<- c(15,16,17,20,24,28,33,40,47,56)


#########################################################################################################################################
### Base 20
############################
### Magnitude Comparison ###
mag_20_07 <- subset(riskcomp1_20, prob_bet ==  7); mu_mag_20_07 <- mean(na.omit(mag_20_07$risky))
mag_20_10 <- subset(riskcomp1_20, prob_bet == 10); mu_mag_20_10 <- mean(na.omit(mag_20_10$risky))
mag_20_14 <- subset(riskcomp1_20, prob_bet == 14); mu_mag_20_14 <- mean(na.omit(mag_20_14$risky))
mag_20_19 <- subset(riskcomp1_20, prob_bet == 19); mu_mag_20_19 <- mean(na.omit(mag_20_19$risky))
mag_20_21 <- subset(riskcomp1_20, prob_bet == 21); mu_mag_20_21 <- mean(na.omit(mag_20_21$risky))
mag_20_28 <- subset(riskcomp1_20, prob_bet == 28); mu_mag_20_28 <- mean(na.omit(mag_20_28$risky))
mag_20_40 <- subset(riskcomp1_20, prob_bet == 40); mu_mag_20_40 <- mean(na.omit(mag_20_40$risky))
mag_20_57 <- subset(riskcomp1_20, prob_bet == 57); mu_mag_20_57 <- mean(na.omit(mag_20_57$risky))

mu_mag_20 <- c(mu_mag_20_07, mu_mag_20_10, mu_mag_20_14, mu_mag_20_19, mu_mag_20_21, mu_mag_20_28, mu_mag_20_40, mu_mag_20_57)
prob_mag_20<- c(7,10,14,19,21,28,40,57)

##############################
### Risky Choice - NUMBERS ###
risk2_20_21 <- subset(riskcomp2_20, prob_bet == 21); mu_risk2_20_21 <- mean(na.omit(risk2_20_21$risky))
risk2_20_22 <- subset(riskcomp2_20, prob_bet == 22); mu_risk2_20_22 <- mean(na.omit(risk2_20_22$risky)) 
risk2_20_24 <- subset(riskcomp2_20, prob_bet == 24); mu_risk2_20_24 <- mean(na.omit(risk2_20_24$risky))
risk2_20_28 <- subset(riskcomp2_20, prob_bet == 28); mu_risk2_20_28 <- mean(na.omit(risk2_20_28$risky))
risk2_20_34 <- subset(riskcomp2_20, prob_bet == 34); mu_risk2_20_34 <- mean(na.omit(risk2_20_34$risky))
risk2_20_40 <- subset(riskcomp2_20, prob_bet == 40); mu_risk2_20_40 <- mean(na.omit(risk2_20_40$risky))
risk2_20_48 <- subset(riskcomp2_20, prob_bet == 48); mu_risk2_20_48 <- mean(na.omit(risk2_20_48$risky))
risk2_20_57 <- subset(riskcomp2_20, prob_bet == 57); mu_risk2_20_57 <- mean(na.omit(risk2_20_57$risky))
risk2_20_67 <- subset(riskcomp2_20, prob_bet == 67); mu_risk2_20_67 <- mean(na.omit(risk2_20_67$risky))
risk2_20_80 <- subset(riskcomp2_20, prob_bet == 80); mu_risk2_20_80 <- mean(na.omit(risk2_20_80$risky))

mu_risk2_20 <- c(mu_risk2_20_21, mu_risk2_20_22, mu_risk2_20_24, mu_risk2_20_28, mu_risk2_20_34, mu_risk2_20_40, mu_risk2_20_48, mu_risk2_20_57, mu_risk2_20_67, mu_risk2_20_80)
prob_risk2_20<- c(21,22,24,28,34,40,48,57,67,80)

##############################
### Risky Choice - COINS ###
risk3_20_21 <- subset(riskcomp3_20, prob_bet == 21); mu_risk3_20_21 <- mean(na.omit(risk3_20_21$risky))
risk3_20_22 <- subset(riskcomp3_20, prob_bet == 22); mu_risk3_20_22 <- mean(na.omit(risk3_20_22$risky)) 
risk3_20_24 <- subset(riskcomp3_20, prob_bet == 24); mu_risk3_20_24 <- mean(na.omit(risk3_20_24$risky))
risk3_20_28 <- subset(riskcomp3_20, prob_bet == 28); mu_risk3_20_28 <- mean(na.omit(risk3_20_28$risky))
risk3_20_34 <- subset(riskcomp3_20, prob_bet == 34); mu_risk3_20_34 <- mean(na.omit(risk3_20_34$risky))
risk3_20_40 <- subset(riskcomp3_20, prob_bet == 40); mu_risk3_20_40 <- mean(na.omit(risk3_20_40$risky))
risk3_20_48 <- subset(riskcomp3_20, prob_bet == 48); mu_risk3_20_48 <- mean(na.omit(risk3_20_48$risky))
risk3_20_57 <- subset(riskcomp3_20, prob_bet == 57); mu_risk3_20_57 <- mean(na.omit(risk3_20_57$risky))
risk3_20_67 <- subset(riskcomp3_20, prob_bet == 67); mu_risk3_20_67 <- mean(na.omit(risk3_20_67$risky))
risk3_20_80 <- subset(riskcomp3_20, prob_bet == 80); mu_risk3_20_80 <- mean(na.omit(risk3_20_80$risky))

mu_risk3_20 <- c(mu_risk3_20_21, mu_risk3_20_22, mu_risk3_20_24, mu_risk3_20_28, mu_risk3_20_34, mu_risk3_20_40, mu_risk3_20_48, mu_risk3_20_57, mu_risk3_20_67, mu_risk3_20_80)
prob_risk3_20<- c(21,22,24,28,34,40,48,57,67,80)

##############################
### Risky Choice - POOLED ###
risk4_20_21 <- subset(riskcomp4_20, prob_bet == 21); mu_risk4_20_21 <- mean(na.omit(risk4_20_21$risky))
risk4_20_22 <- subset(riskcomp4_20, prob_bet == 22); mu_risk4_20_22 <- mean(na.omit(risk4_20_22$risky)) 
risk4_20_24 <- subset(riskcomp4_20, prob_bet == 24); mu_risk4_20_24 <- mean(na.omit(risk4_20_24$risky))
risk4_20_28 <- subset(riskcomp4_20, prob_bet == 28); mu_risk4_20_28 <- mean(na.omit(risk4_20_28$risky))
risk4_20_34 <- subset(riskcomp4_20, prob_bet == 34); mu_risk4_20_34 <- mean(na.omit(risk4_20_34$risky))
risk4_20_40 <- subset(riskcomp4_20, prob_bet == 40); mu_risk4_20_40 <- mean(na.omit(risk4_20_40$risky))
risk4_20_48 <- subset(riskcomp4_20, prob_bet == 48); mu_risk4_20_48 <- mean(na.omit(risk4_20_48$risky))
risk4_20_57 <- subset(riskcomp4_20, prob_bet == 57); mu_risk4_20_57 <- mean(na.omit(risk4_20_57$risky))
risk4_20_67 <- subset(riskcomp4_20, prob_bet == 67); mu_risk4_20_67 <- mean(na.omit(risk4_20_67$risky))
risk4_20_80 <- subset(riskcomp4_20, prob_bet == 80); mu_risk4_20_80 <- mean(na.omit(risk4_20_80$risky))

mu_risk4_20 <- c(mu_risk4_20_21, mu_risk4_20_22, mu_risk4_20_24, mu_risk4_20_28, mu_risk4_20_34, mu_risk4_20_40, mu_risk4_20_48, mu_risk4_20_57, mu_risk4_20_67, mu_risk4_20_80)
prob_risk4_20<- c(21,22,24,28,34,40,48,57,67,80)


#########################################################################################################################################
### Base 28
############################
### Magnitude Comparison ###
mag_28_10 <- subset(riskcomp1_28, prob_bet == 10); mu_mag_28_10 <- mean(na.omit(mag_28_10$risky))
mag_28_14 <- subset(riskcomp1_28, prob_bet == 14); mu_mag_28_14 <- mean(na.omit(mag_28_14$risky))
mag_28_20 <- subset(riskcomp1_28, prob_bet == 20); mu_mag_28_20 <- mean(na.omit(mag_28_20$risky))
mag_28_27 <- subset(riskcomp1_28, prob_bet == 27); mu_mag_28_27 <- mean(na.omit(mag_28_27$risky))
mag_28_29 <- subset(riskcomp1_28, prob_bet == 29); mu_mag_28_29 <- mean(na.omit(mag_28_29$risky))
mag_28_40 <- subset(riskcomp1_28, prob_bet == 40); mu_mag_28_40 <- mean(na.omit(mag_28_40$risky))
mag_28_56 <- subset(riskcomp1_28, prob_bet == 56); mu_mag_28_56 <- mean(na.omit(mag_28_56$risky))
mag_28_79 <- subset(riskcomp1_28, prob_bet == 79); mu_mag_28_79 <- mean(na.omit(mag_28_79$risky))

mu_mag_28 <- c(mu_mag_28_10, mu_mag_28_14, mu_mag_28_20, mu_mag_28_27, mu_mag_28_29, mu_mag_28_40, mu_mag_28_56, mu_mag_28_79)
prob_mag_28<- c(10,14,20,27,29,40,56,79)

####################
### Risky Choice - NUMBERS ###
 risk2_28_29 <- subset(riskcomp2_28, prob_bet == 29);   mu_risk2_28_29 <- mean(na.omit(risk2_28_29$risky))
 risk2_28_30 <- subset(riskcomp2_28, prob_bet == 30);   mu_risk2_28_30 <- mean(na.omit(risk2_28_30$risky)) 
 risk2_28_33 <- subset(riskcomp2_28, prob_bet == 33);   mu_risk2_28_33 <- mean(na.omit(risk2_28_33$risky))
 risk2_28_40 <- subset(riskcomp2_28, prob_bet == 40);   mu_risk2_28_40 <- mean(na.omit(risk2_28_40$risky))
 risk2_28_47 <- subset(riskcomp2_28, prob_bet == 47);   mu_risk2_28_47 <- mean(na.omit(risk2_28_47$risky))
 risk2_28_56 <- subset(riskcomp2_28, prob_bet == 56);   mu_risk2_28_56 <- mean(na.omit(risk2_28_56$risky))
 risk2_28_67 <- subset(riskcomp2_28, prob_bet == 67);   mu_risk2_28_67 <- mean(na.omit(risk2_28_67$risky))
 risk2_28_79 <- subset(riskcomp2_28, prob_bet == 79);   mu_risk2_28_79 <- mean(na.omit(risk2_28_79$risky))
 risk2_28_94 <- subset(riskcomp2_28, prob_bet == 94);   mu_risk2_28_94 <- mean(na.omit(risk2_28_94$risky))
risk2_28_112 <- subset(riskcomp2_28, prob_bet == 112); mu_risk2_28_112 <- mean(na.omit(risk2_28_112$risky))

mu_risk2_28 <- c(mu_risk2_28_29, mu_risk2_28_30, mu_risk2_28_33, mu_risk2_28_40, mu_risk2_28_47, mu_risk2_28_56, mu_risk2_28_67, mu_risk2_28_79, mu_risk2_28_94, mu_risk2_28_112)
prob_risk2_28 <- c(29,30,33,40,47,56,67,79,94,112)

####################
### Risky Choice - COINS ###
risk3_28_29 <- subset(riskcomp3_28, prob_bet == 29);   mu_risk3_28_29 <- mean(na.omit(risk3_28_29$risky))
risk3_28_30 <- subset(riskcomp3_28, prob_bet == 30);   mu_risk3_28_30 <- mean(na.omit(risk3_28_30$risky)) 
risk3_28_33 <- subset(riskcomp3_28, prob_bet == 33);   mu_risk3_28_33 <- mean(na.omit(risk3_28_33$risky))
risk3_28_40 <- subset(riskcomp3_28, prob_bet == 40);   mu_risk3_28_40 <- mean(na.omit(risk3_28_40$risky))
risk3_28_47 <- subset(riskcomp3_28, prob_bet == 47);   mu_risk3_28_47 <- mean(na.omit(risk3_28_47$risky))
risk3_28_56 <- subset(riskcomp3_28, prob_bet == 56);   mu_risk3_28_56 <- mean(na.omit(risk3_28_56$risky))
risk3_28_67 <- subset(riskcomp3_28, prob_bet == 67);   mu_risk3_28_67 <- mean(na.omit(risk3_28_67$risky))
risk3_28_79 <- subset(riskcomp3_28, prob_bet == 79);   mu_risk3_28_79 <- mean(na.omit(risk3_28_79$risky))
risk3_28_94 <- subset(riskcomp3_28, prob_bet == 94);   mu_risk3_28_94 <- mean(na.omit(risk3_28_94$risky))
risk3_28_112 <- subset(riskcomp3_28, prob_bet == 112); mu_risk3_28_112 <- mean(na.omit(risk3_28_112$risky))

mu_risk3_28 <- c(mu_risk3_28_29, mu_risk3_28_30, mu_risk3_28_33, mu_risk3_28_40, mu_risk3_28_47, mu_risk3_28_56, mu_risk3_28_67, mu_risk3_28_79, mu_risk3_28_94, mu_risk3_28_112)
prob_risk3_28<- c(29,30,33,40,47,56,67,79,94,112)

####################
### Risky Choice - COINS ###
risk4_28_29 <- subset(riskcomp4_28, prob_bet == 29);   mu_risk4_28_29 <- mean(na.omit(risk4_28_29$risky))
risk4_28_30 <- subset(riskcomp4_28, prob_bet == 30);   mu_risk4_28_30 <- mean(na.omit(risk4_28_30$risky)) 
risk4_28_33 <- subset(riskcomp4_28, prob_bet == 33);   mu_risk4_28_33 <- mean(na.omit(risk4_28_33$risky))
risk4_28_40 <- subset(riskcomp4_28, prob_bet == 40);   mu_risk4_28_40 <- mean(na.omit(risk4_28_40$risky))
risk4_28_47 <- subset(riskcomp4_28, prob_bet == 47);   mu_risk4_28_47 <- mean(na.omit(risk4_28_47$risky))
risk4_28_56 <- subset(riskcomp4_28, prob_bet == 56);   mu_risk4_28_56 <- mean(na.omit(risk4_28_56$risky))
risk4_28_67 <- subset(riskcomp4_28, prob_bet == 67);   mu_risk4_28_67 <- mean(na.omit(risk4_28_67$risky))
risk4_28_79 <- subset(riskcomp4_28, prob_bet == 79);   mu_risk4_28_79 <- mean(na.omit(risk4_28_79$risky))
risk4_28_94 <- subset(riskcomp4_28, prob_bet == 94);   mu_risk4_28_94 <- mean(na.omit(risk4_28_94$risky))
risk4_28_112 <- subset(riskcomp4_28, prob_bet == 112); mu_risk4_28_112 <- mean(na.omit(risk4_28_112$risky))

mu_risk4_28 <- c(mu_risk4_28_29, mu_risk4_28_30, mu_risk4_28_33, mu_risk4_28_40, mu_risk4_28_47, mu_risk4_28_56, mu_risk4_28_67, mu_risk4_28_79, mu_risk4_28_94, mu_risk4_28_112)
prob_risk4_28<- c(29,30,33,40,47,56,67,79,94,112)


#########################################################################################################################################
#########################################################################################################################################

### 
prob1_bet05 <- riskcomp1_05$prob_bet; prob1_bet07 <- riskcomp1_07$prob_bet
prob1_bet10 <- riskcomp1_10$prob_bet; prob1_bet14 <- riskcomp1_14$prob_bet
prob1_bet20 <- riskcomp1_20$prob_bet; prob1_bet28 <- riskcomp1_28$prob_bet
prob1_bet   <- riskcomp1$prob_bet

sure1_bet05 <- riskcomp1_05$sure_bet; sure1_bet07 <- riskcomp1_07$sure_bet
sure1_bet10 <- riskcomp1_10$sure_bet; sure1_bet14 <- riskcomp1_14$sure_bet
sure1_bet20 <- riskcomp1_20$sure_bet; sure1_bet28 <- riskcomp1_28$sure_bet
sure1_bet   <- riskcomp1$sure_bet

### 
prob2_bet05 <- riskcomp2_05$prob_bet; prob2_bet07 <- riskcomp2_07$prob_bet
prob2_bet10 <- riskcomp2_10$prob_bet; prob2_bet14 <- riskcomp2_14$prob_bet
prob2_bet20 <- riskcomp2_20$prob_bet; prob2_bet28 <- riskcomp2_28$prob_bet
prob2_bet   <- riskcomp2$prob_bet

sure2_bet05 <- riskcomp2_05$sure_bet; sure2_bet07 <- riskcomp2_07$sure_bet
sure2_bet10 <- riskcomp2_10$sure_bet; sure2_bet14 <- riskcomp2_14$sure_bet
sure2_bet20 <- riskcomp2_20$sure_bet; sure2_bet28 <- riskcomp2_28$sure_bet
sure2_bet   <- riskcomp2$sure_bet

### 
prob3_bet05 <- riskcomp3_05$prob_bet; prob3_bet07 <- riskcomp3_07$prob_bet
prob3_bet10 <- riskcomp3_10$prob_bet; prob3_bet14 <- riskcomp3_14$prob_bet
prob3_bet20 <- riskcomp3_20$prob_bet; prob3_bet28 <- riskcomp3_28$prob_bet
prob3_bet   <- riskcomp3$prob_bet

sure3_bet05 <- riskcomp3_05$sure_bet; sure3_bet07 <- riskcomp3_07$sure_bet
sure3_bet10 <- riskcomp3_10$sure_bet; sure3_bet14 <- riskcomp3_14$sure_bet
sure3_bet20 <- riskcomp3_20$sure_bet; sure3_bet28 <- riskcomp3_28$sure_bet
sure3_bet   <- riskcomp3$sure_bet

### 
prob4_bet05 <- riskcomp4_05$prob_bet; prob4_bet07 <- riskcomp4_07$prob_bet
prob4_bet10 <- riskcomp4_10$prob_bet; prob4_bet14 <- riskcomp4_14$prob_bet
prob4_bet20 <- riskcomp4_20$prob_bet; prob4_bet28 <- riskcomp4_28$prob_bet
prob4_bet   <- riskcomp4$prob_bet

sure4_bet05 <- riskcomp4_05$sure_bet; sure4_bet07 <- riskcomp4_07$sure_bet
sure4_bet10 <- riskcomp4_10$sure_bet; sure4_bet14 <- riskcomp4_14$sure_bet
sure4_bet20 <- riskcomp4_20$sure_bet; sure4_bet28 <- riskcomp4_28$sure_bet
sure4_bet   <- riskcomp4$sure_bet


### Estimated Parameters ###
### MAGNITUDE COMPARISON 
precs1 <- c(4.177740, 3.399895, 3.085700, 2.933620, 2.841110, 2.433750)
sigma1 <- c(7.207735, 6.865315, 7.356315, 7.721725, 8.286745, 7.834100)

### RISK - SYMBOL
precs2 <- c(3.307865, 3.161925, 3.188250, 3.807470, 4.142295, 3.809950)
sigma2 <- c(8.510705, 8.919050, 10.181150, 13.143200, 15.694650, 15.407300)

### RISK - COINS
precs3 <- c(2.498195, 2.403285, 2.434030, 2.681825, 2.823600, 2.873040)
sigma3 <- c(6.391040, 7.027605, 7.927395, 9.626295, 10.836500, 11.895250)

### RISK - POOLED
precs4 <- c(2.812240, 2.674490, 2.721830, 3.006050, 3.223980, 3.191925)
sigma4 <- c(7.214975, 7.689465, 8.796655, 10.600500, 12.306500, 13.069700)


########################
### MAGNITUDE COMPARISON 
precs1_sv <- c(4.6625700, 3.9178200,  3.440365, 3.112505, 2.926895, 2.501555, 3.099575)
sigma1_sv <- c(0.4927165, 0.2482065, 0.244105, 0.0293383, 0.00687705, 0.004759795, 0.02540065)

### RISK - SYMBOL
precs2_sv <- c(3.4917700, 3.3986500,  3.5333200, 4.043880, 4.4984950, 4.3407900, 3.7056250)
sigma2_sv <- c(3.2566250, 2.8929100, 3.0229650, 3.159505, 3.4726250, 2.9600250, 2.9701850)

### RISK - COINS
precs3_sv <- c(2.600545, 2.5978150, 2.6270550, 2.764615, 2.9655300, 3.212205, 2.685195)
sigma3_sv <- c(2.422600, 2.5037600, 2.4545800, 2.587415, 2.4430450, 2.507890, 2.405355)

### RISK - POOLED
precs4_sv <- c(2.917070, 2.8574500,  2.9373800, 3.145370, 3.5009300, 3.543395, 2.967595)
sigma4_sv <- c(2.722860, 2.6019750, 2.6394200, 2.714425, 2.7937250, 2.603550, 2.532455)



### Without C

mag_05 <- pnorm(precs1[1]*log(prob1_bet05) - sigma1[1],0,1)
mag_07 <- pnorm(precs1[2]*log(prob1_bet07) - sigma1[2],0,1)
mag_10 <- pnorm(precs1[3]*log(prob1_bet10) - sigma1[3],0,1)
mag_14 <- pnorm(precs1[4]*log(prob1_bet14) - sigma1[4],0,1)
mag_20 <- pnorm(precs1[5]*log(prob1_bet20) - sigma1[5],0,1)
mag_28 <- pnorm(precs1[6]*log(prob1_bet28) - sigma1[6],0,1)

risk2_05 <- pnorm(precs2[1]*log(prob2_bet05) - sigma2[1],0,1)
risk2_07 <- pnorm(precs2[2]*log(prob2_bet07) - sigma2[2],0,1)
risk2_10 <- pnorm(precs2[3]*log(prob2_bet10) - sigma2[3],0,1)
risk2_14 <- pnorm(precs2[4]*log(prob2_bet14) - sigma2[4],0,1)
risk2_20 <- pnorm(precs2[5]*log(prob2_bet20) - sigma2[5],0,1)
risk2_28 <- pnorm(precs2[6]*log(prob2_bet28) - sigma2[6],0,1)

risk3_05 <- pnorm(precs3[1]*log(prob3_bet05) - sigma3[1],0,1)
risk3_07 <- pnorm(precs3[2]*log(prob3_bet07) - sigma3[2],0,1)
risk3_10 <- pnorm(precs3[3]*log(prob3_bet10) - sigma3[3],0,1)
risk3_14 <- pnorm(precs3[4]*log(prob3_bet14) - sigma3[4],0,1)
risk3_20 <- pnorm(precs3[5]*log(prob3_bet20) - sigma3[5],0,1)
risk3_28 <- pnorm(precs3[6]*log(prob3_bet28) - sigma3[6],0,1)

risk4_05 <- pnorm(precs4[1]*log(prob4_bet05) - sigma4[1],0,1)
risk4_07 <- pnorm(precs4[2]*log(prob4_bet07) - sigma4[2],0,1)
risk4_10 <- pnorm(precs4[3]*log(prob4_bet10) - sigma4[3],0,1)
risk4_14 <- pnorm(precs4[4]*log(prob4_bet14) - sigma4[4],0,1)
risk4_20 <- pnorm(precs4[5]*log(prob4_bet20) - sigma4[5],0,1)
risk4_28 <- pnorm(precs4[6]*log(prob4_bet28) - sigma4[6],0,1)


### With C
mag_sv_05 <- pnorm(precs1_sv[1]*log(prob1_bet05/sure1_bet05) - sigma1_sv[1],0,1)
mag_sv_07 <- pnorm(precs1_sv[2]*log(prob1_bet07/sure1_bet07) - sigma1_sv[2],0,1)
mag_sv_10 <- pnorm(precs1_sv[3]*log(prob1_bet10/sure1_bet10) - sigma1_sv[3],0,1)
mag_sv_14 <- pnorm(precs1_sv[4]*log(prob1_bet14/sure1_bet14) - sigma1_sv[4],0,1)
mag_sv_20 <- pnorm(precs1_sv[5]*log(prob1_bet20/sure1_bet20) - sigma1_sv[5],0,1)
mag_sv_28 <- pnorm(precs1_sv[6]*log(prob1_bet28/sure1_bet28) - sigma1_sv[6],0,1)
mag_sv_All <- pnorm(precs1_sv[7]*log(prob1_bet/sure1_bet) - sigma1_sv[7],0,1)

risk2_sv_05 <- pnorm(precs2_sv[1]*log(prob2_bet05/sure2_bet05) - sigma2_sv[1],0,1)
risk2_sv_07 <- pnorm(precs2_sv[2]*log(prob2_bet07/sure2_bet07) - sigma2_sv[2],0,1)
risk2_sv_10 <- pnorm(precs2_sv[3]*log(prob2_bet10/sure2_bet10) - sigma2_sv[3],0,1)
risk2_sv_14 <- pnorm(precs2_sv[4]*log(prob2_bet14/sure2_bet14) - sigma2_sv[4],0,1)
risk2_sv_20 <- pnorm(precs2_sv[5]*log(prob2_bet20/sure2_bet20) - sigma2_sv[5],0,1)
risk2_sv_28 <- pnorm(precs2_sv[6]*log(prob2_bet28/sure2_bet28) - sigma2_sv[6],0,1)
risk2_sv_All <- pnorm(precs2_sv[7]*log(prob2_bet/sure2_bet) - sigma2_sv[7],0,1)

risk3_sv_05 <- pnorm(precs3_sv[1]*log(prob3_bet05/sure3_bet05) - sigma3_sv[1],0,1)
risk3_sv_07 <- pnorm(precs3_sv[2]*log(prob3_bet07/sure3_bet07) - sigma3_sv[2],0,1)
risk3_sv_10 <- pnorm(precs3_sv[3]*log(prob3_bet10/sure3_bet10) - sigma3_sv[3],0,1)
risk3_sv_14 <- pnorm(precs3_sv[4]*log(prob3_bet14/sure3_bet14) - sigma3_sv[4],0,1)
risk3_sv_20 <- pnorm(precs3_sv[5]*log(prob3_bet20/sure3_bet20) - sigma3_sv[5],0,1)
risk3_sv_28 <- pnorm(precs3_sv[6]*log(prob3_bet28/sure3_bet28) - sigma3_sv[6],0,1)
risk3_sv_All <- pnorm(precs3_sv[7]*log(prob3_bet/sure3_bet) - sigma3_sv[7],0,1)

risk4_sv_05  <- pnorm(precs4_sv[1]*log(prob4_bet05/sure4_bet05) - sigma4_sv[1],0,1)
risk4_sv_07  <- pnorm(precs4_sv[2]*log(prob4_bet07/sure4_bet07) - sigma4_sv[2],0,1)
risk4_sv_10  <- pnorm(precs4_sv[3]*log(prob4_bet10/sure4_bet10) - sigma4_sv[3],0,1)
risk4_sv_14  <- pnorm(precs4_sv[4]*log(prob4_bet14/sure4_bet14) - sigma4_sv[4],0,1)
risk4_sv_20  <- pnorm(precs4_sv[5]*log(prob4_bet20/sure4_bet20) - sigma4_sv[5],0,1)
risk4_sv_28  <- pnorm(precs4_sv[6]*log(prob4_bet28/sure4_bet28) - sigma4_sv[6],0,1)
risk4_sv_All <- pnorm(precs4_sv[7]*log(prob4_bet/sure4_bet) - sigma4_sv[7],0,1)



### PLOT

library(RColorBrewer)

### COLORS - PURPLES
rgb1 = rgb(253/255, 224/255 , 221/255, 0.9)
rgb2 = rgb(250/255, 159/255 , 181/255, 0.9)
rgb3 = rgb(247/255, 104/255 , 161/255, 0.9)
rgb4 = rgb(221/255, 52/255 , 151/255, 0.9)
rgb5 = rgb(174/255, 1/255 , 126/255, 0.9)
rgb6 = rgb(73/255, 0/255 , 106/255, 0.9)

### COLORS - BLUES
rgb2_1 = rgb(214/255, 229/255, 244/255, 0.9)
rgb2_2 = rgb(171/255, 207/255, 229/255, 0.9)
rgb2_3 = rgb(107/255, 174/255, 214/255, 0.9)
rgb2_4 = rgb(55/255, 135/255, 192/255, 0.9)
rgb2_5 = rgb(16/255, 91/255, 164/255, 0.9)
rgb2_6 = rgb(8/255, 48/255, 107/255, 0.9)

### COLORS - ORANGE
rgb3_1 = rgb(253/255, 225/255, 186/255, 0.9)
rgb3_2 = rgb(253/255, 195/255, 140/255, 0.9)
rgb3_3 = rgb(252/255, 141/255, 89/255, 0.9)
rgb3_4 = rgb(231/255, 83/255, 58/255, 0.9)
rgb3_5 = rgb(191/255, 16/255, 10/255, 0.9)
rgb3_6 = rgb(127/255, 0/255, 0/255, 0.9)




layout.matrix <-  matrix(c(1,1,2,2,1,1,2,2,3,3,4,4,3,3,5,5), nrow = 4, ncol = 4)

layout(mat = layout.matrix,
       heights = c(1, 1), # Heights of the two rows
       widths = c(1, 1)) # Widths of the two columns

#layout.show(5)

############################################################################################################################
install.packages("Rttf2pt1")
install.packages("extrafontdb")
install.packages("extrafont")

library(Rttf2pt1)
library(extrafontdb)
library(extrafont)

install.packages("showtext")
library(showtext)

font_import(paths = "C:/Windows/Fonts")

extrafont::loadfonts()

font_add(family = "helvetica", regular = "C:/Windows/Fonts/Helvetica.ttf")
showtext_auto()

############################################################################################################################

### FIG 1.1 LINEAR SCALE

### ASPECT 1500 x 1040

par(mfrow=c(3,3))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### MAGNITUDE COMPARISON
plot(prob_mag_05, mu_mag_05,  col = rgb1, , pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "",xlab = "2nd Set of Coin Clouds", ylab = "Pr(Choose 2nd Set)", xlim = c(0,80), ylim = c(0,1), axes = F)
axis(side=1,at=seq(-20,80,20), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
lines(prob1_bet05, mag_05,  lwd = 8, col =  rgb1, pch = 16, cex = 2.5, lty = 1)
lines(prob1_bet07, mag_07,  lwd = 8, col =  rgb2, pch = 16, cex = 2.5, lty = 1)
lines(prob1_bet10, mag_10,  lwd = 8, col =  rgb3, pch = 16, cex = 2.5, lty = 1)
lines(prob1_bet14, mag_14,  lwd = 8, col =  rgb4, pch = 16, cex = 2.5, lty = 1)
lines(prob1_bet20, mag_20,  lwd = 8, col =  rgb5, pch = 16, cex = 2.5, lty = 1)
lines(prob1_bet28, mag_28,  lwd = 8, col =  rgb6, pch = 16, cex = 2.5, lty = 1)

points(prob_mag_07, mu_mag_07, col = rgb2, pch = 16, cex = 3.5)
points(prob_mag_10, mu_mag_10, col = rgb3, pch = 16, cex = 3.5)
points(prob_mag_14, mu_mag_14, col = rgb4, pch = 16, cex = 3.5)
points(prob_mag_20, mu_mag_20, col = rgb5, pch = 16, cex = 3.5)
points(prob_mag_28, mu_mag_28, col = rgb6, pch = 16, cex = 3.5)

legend(55,0.76, legend = c(5,7,10,14,20,28), title = "1st Set", 
       col = c(rgb1,rgb2,rgb3,rgb4,rgb5,rgb6),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)


### RISKY CHOICE - COINS
plot(prob_risk3_05, mu_risk3_05,  col = rgb3_1, , pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "Linear",xlab = "Risky Offers", ylab = "Pr(Accept Risky)", xlim = c(0,115), ylim = c(0,1), axes = F)
axis(side=1,at=seq(-20,120,20), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(85,0.76, legend = c(5,7,10,14,20,28), title = "Sure Offer", 
       col = c(rgb3_1,rgb3_2,rgb3_3,rgb3_4,rgb3_5,rgb3_6),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob3_bet05, risk3_05,  lwd = 8, col =  rgb3_1, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet07, risk3_07,  lwd = 8, col =  rgb3_2, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet10, risk3_10,  lwd = 8, col =  rgb3_3, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet14, risk3_14,  lwd = 8, col =  rgb3_4, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet20, risk3_20,  lwd = 8, col =  rgb3_5, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet28, risk3_28,  lwd = 8, col =  rgb3_6, pch = 16, cex = 2.5, lty = 1)

points(prob_risk3_07, mu_risk3_07, col = rgb3_2, pch = 16, cex = 3.5)
points(prob_risk3_10, mu_risk3_10, col = rgb3_3, pch = 16, cex = 3.5)
points(prob_risk3_14, mu_risk3_14, col = rgb3_4, pch = 16, cex = 3.5)
points(prob_risk3_20, mu_risk3_20, col = rgb3_5, pch = 16, cex = 3.5)
points(prob_risk3_28, mu_risk3_28, col = rgb3_6, pch = 16, cex = 3.5)

### RISKY CHOICE - NUMBERS
plot(prob_risk2_05, mu_risk2_05,  col = rgb2_1, , pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "",xlab = "Risky Offers", ylab = "Pr(Accept Risky)", xlim = c(0,115), ylim = c(0,1), axes = F)
axis(side=1,at=seq(-20,120,20), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(85,0.76, legend = c(5,7,10,14,20,28), title = "Sure Offer", 
       col = c(rgb2_1,rgb2_2,rgb2_3,rgb2_4,rgb2_5,rgb2_6),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob2_bet05, risk2_05,  lwd = 8, col =  rgb2_1, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet07, risk2_07,  lwd = 8, col =  rgb2_2, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet10, risk2_10,  lwd = 8, col =  rgb2_3, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet14, risk2_14,  lwd = 8, col =  rgb2_4, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet20, risk2_20,  lwd = 8, col =  rgb2_5, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet28, risk2_28,  lwd = 8, col =  rgb2_6, pch = 16, cex = 2.5, lty = 1)

points(prob_risk2_07, mu_risk2_07, col = rgb2_2, pch = 16, cex = 3.5)
points(prob_risk2_10, mu_risk2_10, col = rgb2_3, pch = 16, cex = 3.5)
points(prob_risk2_14, mu_risk2_14, col = rgb2_4, pch = 16, cex = 3.5)
points(prob_risk2_20, mu_risk2_20, col = rgb2_5, pch = 16, cex = 3.5)
points(prob_risk2_28, mu_risk2_28, col = rgb2_6, pch = 16, cex = 3.5)



############################################################################################################################
### FIG 1.2 LOG SCALE

### MAGNITUDE COMPARISON
plot((prob_mag_05), mu_mag_05,  col = rgb1,  log = "x", pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "",xlab = "2nd Set of Coin Clouds", ylab = "Pr(Choose 2nd Set)", xlim = c(2,100), ylim = c(0,1), axes = F)
axis(side=1,at=seq(-20,100,5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
lines(prob1_bet05, mag_05,  lwd = 8, col =  rgb1, pch = 16, cex = 3, lty = 1)
lines(prob1_bet07, mag_07,  lwd = 8, col =  rgb2, pch = 16, cex = 3, lty = 1)
lines(prob1_bet10, mag_10,  lwd = 8, col =  rgb3, pch = 16, cex = 3, lty = 1)
lines(prob1_bet14, mag_14,  lwd = 8, col =  rgb4, pch = 16, cex = 3, lty = 1)
lines(prob1_bet20, mag_20,  lwd = 8, col =  rgb5, pch = 16, cex = 3, lty = 1)
lines(prob1_bet28, mag_28,  lwd = 8, col =  rgb6, pch = 16, cex = 3, lty = 1)

points(prob_mag_07, mu_mag_07, col = rgb2, pch = 16, cex = 3.5)
points(prob_mag_10, mu_mag_10, col = rgb3, pch = 16, cex = 3.5)
points(prob_mag_14, mu_mag_14, col = rgb4, pch = 16, cex = 3.5)
points(prob_mag_20, mu_mag_20, col = rgb5, pch = 16, cex = 3.5)
points(prob_mag_28, mu_mag_28, col = rgb6, pch = 16, cex = 3.5)

legend(50,0.76, legend = c(5,7,10,14,20,28), title = "1st Set", 
       col = c(rgb1,rgb2,rgb3,rgb4,rgb5,rgb6),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)


### RISKY CHOICE - COINS
plot(prob_risk3_05, mu_risk3_05,  col = rgb3_1, log = "x", pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "Logarithmic",xlab = "Risky Offers", ylab = "Pr(Accept Risky)", xlim = c(5,211), ylim = c(0,1), axes = F)
axis(side=1,at=seq(-20,150,5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(100,0.76, legend = c(5,7,10,14,20,28), title = "Sure Offer", 
       col = c(rgb3_1,rgb3_2,rgb3_3,rgb3_4,rgb3_5,rgb3_6),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob3_bet05, risk3_05,  lwd = 8, col =  rgb3_1, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet07, risk3_07,  lwd = 8, col =  rgb3_2, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet10, risk3_10,  lwd = 8, col =  rgb3_3, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet14, risk3_14,  lwd = 8, col =  rgb3_4, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet20, risk3_20,  lwd = 8, col =  rgb3_5, pch = 16, cex = 2.5, lty = 1)
lines(prob3_bet28, risk3_28,  lwd = 8, col =  rgb3_6, pch = 16, cex = 2.5, lty = 1)

points(prob_risk3_07, mu_risk3_07, col = rgb3_2, pch = 16, cex = 3.5)
points(prob_risk3_10, mu_risk3_10, col = rgb3_3, pch = 16, cex = 3.5)
points(prob_risk3_14, mu_risk3_14, col = rgb3_4, pch = 16, cex = 3.5)
points(prob_risk3_20, mu_risk3_20, col = rgb3_5, pch = 16, cex = 3.5)
points(prob_risk3_28, mu_risk3_28, col = rgb3_6, pch = 16, cex = 3.5)


### RISKY CHOICE - NUMBERS
plot(prob_risk2_05, mu_risk2_05,  col = rgb2_1, log = "x", pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "",xlab = "Risky Offers", ylab = "Pr(Accept Risky)", xlim = c(5,200), ylim = c(0,1), axes = F)
axis(side=1,at=seq(-20,150,5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(100,0.76, legend = c(5,7,10,14,20,28), title = "Sure Offer", 
       col = c(rgb2_1,rgb2_2,rgb2_3,rgb2_4,rgb2_5,rgb2_6),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob2_bet05, risk2_05,  lwd = 8, col =  rgb2_1, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet07, risk2_07,  lwd = 8, col =  rgb2_2, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet10, risk2_10,  lwd = 8, col =  rgb2_3, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet14, risk2_14,  lwd = 8, col =  rgb2_4, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet20, risk2_20,  lwd = 8, col =  rgb2_5, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet28, risk2_28,  lwd = 8, col =  rgb2_6, pch = 16, cex = 2.5, lty = 1)

points(prob_risk2_07, mu_risk2_07, col = rgb2_2, pch = 16, cex = 3.5)
points(prob_risk2_10, mu_risk2_10, col = rgb2_3, pch = 16, cex = 3.5)
points(prob_risk2_14, mu_risk2_14, col = rgb2_4, pch = 16, cex = 3.5)
points(prob_risk2_20, mu_risk2_20, col = rgb2_5, pch = 16, cex = 3.5)
points(prob_risk2_28, mu_risk2_28, col = rgb2_6, pch = 16, cex = 3.5)




############################################################################################################################
### FIG 1.3 SCALE INVARIANCE

### MAGNITUDE COMPARISON
plot(prob_mag_05/5, mu_mag_05, log = "x", col = rgb1, pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "Perceptual",xlab = "2nd Set / 1st Set", ylab = "Pr(Choose 2nd Set)", xlim = c(0.2,4.5), ylim = c(0,1), axes = F)
axis(side=1,at=seq(0,5,0.2), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
lines(prob1_bet05/sure1_bet05, mag_sv_05,  lwd = 8, col =  rgb1, pch = 16, cex = 3, lty = 2)
lines(prob1_bet07/sure1_bet07, mag_sv_07,  lwd = 8, col =  rgb2, pch = 16, cex = 3, lty = 2)
lines(prob1_bet10/sure1_bet10, mag_sv_10,  lwd = 8, col =  rgb3, pch = 16, cex = 3, lty = 2)
lines(prob1_bet14/sure1_bet14, mag_sv_14,  lwd = 8, col =  rgb4, pch = 16, cex = 3, lty = 2)
lines(prob1_bet20/sure1_bet20, mag_sv_20,  lwd = 8, col =  rgb5, pch = 16, cex = 3, lty = 2)
lines(prob1_bet28/sure1_bet28, mag_sv_28,  lwd = 8, col =  rgb6, pch = 16, cex = 3, lty = 2)

 points(prob_mag_07/7, mu_mag_07, col = rgb2, pch = 16, cex = 3.5); points(prob_mag_10/10, mu_mag_10, col = rgb3, pch = 16, cex = 3.5)
points(prob_mag_14/14, mu_mag_14, col = rgb4, pch = 16, cex = 3.5); points(prob_mag_20/20, mu_mag_20, col = rgb5, pch = 16, cex = 3.5)
points(prob_mag_28/28, mu_mag_28, col = rgb6, pch = 16, cex = 3.5); #points(prob_mag_28/28, mu_mag_28, col = rgb6, pch = 16, cex = 3.5)

lines(prob1_bet/sure1_bet, mag_sv_All,  lwd = 10, col =  "black", pch = 16, cex = 3, lty = 1)

legend(2.5,0.87, legend = c(5,7,10,14,20,28,"NLC"), title = "1st Set", 
       col = c(rgb1,rgb2,rgb3,rgb4,rgb5,rgb6,"black"),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)


### RISKY CHOICE - COINS
plot(prob_risk3_05/5, mu_risk3_05, col = rgb3_1, pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "Nonsymbolic",xlab = "Risky / Sure", ylab = "Pr(Accept Risky)", xlim = c(1.0,6), ylim = c(0,1), axes = F)
axis(side=1,at=seq(0,7,0.5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(4.5,0.87, legend = c(5,7,10,14,20,28,"NLC"), title = "Sure Offer", 
       col = c(rgb3_1,rgb3_2,rgb3_3,rgb3_4,rgb3_5,rgb3_6,"black"),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob3_bet05/sure3_bet05, risk3_sv_05,  lwd = 8, col =  rgb3_1, pch = 16, cex = 3, lty = 2)
lines(prob3_bet07/sure3_bet07, risk3_sv_07,  lwd = 8, col =  rgb3_2, pch = 16, cex = 3, lty = 2)
lines(prob3_bet10/sure3_bet10, risk3_sv_10,  lwd = 8, col =  rgb3_3, pch = 16, cex = 3, lty = 2)
lines(prob3_bet14/sure3_bet14, risk3_sv_14,  lwd = 8, col =  rgb3_4, pch = 16, cex = 3, lty = 2)
lines(prob3_bet20/sure3_bet20, risk3_sv_20,  lwd = 8, col =  rgb3_5, pch = 16, cex = 3, lty = 2)
lines(prob3_bet28/sure3_bet28, risk3_sv_28,  lwd = 8, col =  rgb3_6, pch = 16, cex = 3, lty = 2)

points(prob_risk3_07/7, mu_risk3_07, col = rgb3_2, pch = 16, cex = 3.5); points(prob_risk3_10/10, mu_risk3_10, col = rgb3_3, pch = 16, cex = 3.5)
points(prob_risk3_14/14, mu_risk3_14, col = rgb3_4, pch = 16, cex = 3.5); points(prob_risk3_20/20, mu_risk3_20, col = rgb3_5, pch = 16, cex = 3.5)
points(prob_risk3_28/28, mu_risk3_28, col = rgb3_6, pch = 16, cex = 3.5); #points(prob_risk2_28/28, mu_risk2_28, col = rgb6, pch = 16, cex = 3.5)

lines(prob3_bet/sure3_bet, risk3_sv_All,  lwd = 10, col =  "black", pch = 16, cex = 3, lty = 1)


### RISKY CHOICE - NUMBERS
plot(prob_risk2_05/5, mu_risk2_05, col = rgb2_1, pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "Symbolic",xlab = "Risky / Sure", ylab = "Pr(Accept Risky)", xlim = c(1.0,6), ylim = c(0,1), axes = F)
axis(side=1,at=seq(0,7,0.5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(4.5,0.87, legend = c(5,7,10,14,20,28,"NLC"), title = "Sure Offer", 
       col = c(rgb2_1,rgb2_2,rgb2_3,rgb2_4,rgb2_5,rgb2_6,"black"),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob2_bet05/sure2_bet05, risk2_sv_05,  lwd = 8, col =  rgb2_1, pch = 16, cex = 3, lty = 2)
lines(prob2_bet07/sure2_bet07, risk2_sv_07,  lwd = 8, col =  rgb2_2, pch = 16, cex = 3, lty = 2)
lines(prob2_bet10/sure2_bet10, risk2_sv_10,  lwd = 8, col =  rgb2_3, pch = 16, cex = 3, lty = 2)
lines(prob2_bet14/sure2_bet14, risk2_sv_14,  lwd = 8, col =  rgb2_4, pch = 16, cex = 3, lty = 2)
lines(prob2_bet20/sure2_bet20, risk2_sv_20,  lwd = 8, col =  rgb2_5, pch = 16, cex = 3, lty = 2)
lines(prob2_bet28/sure2_bet28, risk2_sv_28,  lwd = 8, col =  rgb2_6, pch = 16, cex = 3, lty = 2)

points(prob_risk2_07/7, mu_risk2_07, col = rgb2_2, pch = 16, cex = 3.5); points(prob_risk2_10/10, mu_risk2_10, col = rgb2_3, pch = 16, cex = 3.5)
points(prob_risk2_14/14, mu_risk2_14, col = rgb2_4, pch = 16, cex = 3.5); points(prob_risk2_20/20, mu_risk2_20, col = rgb2_5, pch = 16, cex = 3.5)
points(prob_risk2_28/28, mu_risk2_28, col = rgb2_6, pch = 16, cex = 3.5); #points(prob_risk2_28/28, mu_risk2_28, col = rgb6, pch = 16, cex = 3.5)

lines(prob2_bet/sure2_bet, risk2_sv_All,  lwd = 10, col =  "black", pch = 16, cex = 3, lty = 1)


##########################################################
##########################################################

##############################################
#### MAGNITUDE

precsExample_sv1 <- 4; sigmaExample_sv1 <- 0
precsExample_sv2 <- 2; sigmaExample_sv2 <- 0

psychFunc1 <- pnorm(precsExample_sv1*log(prob1_bet/sure1_bet) - sigmaExample_sv1,0,1)
psychFunc2 <- pnorm(precsExample_sv2*log(prob1_bet/sure1_bet) - sigmaExample_sv2,0,1)

plot(prob1_bet/sure1_bet, psychFunc1, log = "x", col = "white", pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "",xlab = "2nd Set / 1st Set", ylab = "Pr(Choose 2nd Set)", xlim = c(0.2,5), ylim = c(0,1), axes = F)
axis(side=1,at=seq(0,5,0.1), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
lines(prob1_bet/sure1_bet, psychFunc1,  lwd = 6, col =  rgb5, pch = 16, cex = 2.5, lty = 1)
lines(prob1_bet/sure1_bet, psychFunc2,  lwd = 6, col =  rgb3, pch = 16, cex = 2.5, lty = 3)

legend(1.2,0.4, legend = c("Precise Coding", "Noisy Log Coding"), 
       col = c(rgb5,rgb3), pch = c(1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(c(0.2:6), rep(0.5,length(c(0.2:6))),  lwd = 3, col =  "black", pch = 16, cex = 3, lty = 2)
lines(rep(1,length(c(0:1))), c(0:1),  lwd = 3, col =  "black", pch = 16, cex = 3, lty = 2)


##############################################
#### RISKY - NUMBERS
precsExample_sv1 <- 8; sigmaExample_sv1 <- 8
precsExample_sv2 <- 5; sigmaExample_sv2 <- 4

psychFunc1 <- pnorm(precsExample_sv1*log(prob2_bet/sure2_bet) - log(0.55^-1)*sigmaExample_sv1,0,1)
psychFunc2 <- pnorm(precsExample_sv2*log(prob2_bet/sure2_bet) - log(0.55^-1)*sigmaExample_sv2,0,1)

plot(prob2_bet/sure2_bet, psychFunc1, log = "x", col = "white", pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "Predictions",xlab = "Risky / Sure", ylab = "Pr(Accept Risky)", xlim = c(1,4), ylim = c(0,1), axes = F)
axis(side=1,at=seq(0,7,0.5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
lines(prob2_bet/sure2_bet, psychFunc1,  lwd = 6, col =  rgb2_5, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet/sure2_bet, psychFunc2,  lwd = 6, col =  rgb2_3, pch = 16, cex = 2.5, lty = 3)

legend(2.1,0.4, legend = c("Precise Coding", "Noisy Log Coding"), 
       col = c(rgb2_5,rgb2_3), pch = c(1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(c(1:4), rep(0.55,length(c(1:4))),  lwd = 3, col =  "black", pch = 16, cex = 3, lty = 2)
lines(rep(1.85,length(c(0:1))), c(0:1),  lwd = 3, col =  "black", pch = 16, cex = 3, lty = 2)
lines(rep(1.65,length(c(0:1))), c(0:1),  lwd = 4, col =  rgb2_3, pch = 16, cex = 3, lty = 1)

points(1.85, 0.55,  lwd = 4, col =  rgb2_5, pch = 16, cex = 3, lty = 1)
points(1.65, 0.55,  lwd = 4, col =  rgb2_3, pch = 16, cex = 3, lty = 1)


##############################################
#### RISKY - COINS
precsExample_sv1 <- 6; sigmaExample_sv1 <- 6
precsExample_sv2 <- 4; sigmaExample_sv2 <- 3

psychFunc1 <- pnorm(precsExample_sv1*log(prob2_bet/sure2_bet) - log(0.55^-1)*sigmaExample_sv1,0,1)
psychFunc2 <- pnorm(precsExample_sv2*log(prob2_bet/sure2_bet) - log(0.55^-1)*sigmaExample_sv2,0,1)

plot(prob2_bet/sure2_bet, psychFunc1, log = "x", col = "white", pch = 16, cex.main = 3, cex = 3.5, cex.lab = 1.6, cex.axis = 2, 
     main = "",xlab = "Risky / Sure", ylab = "Pr(Accept Risky)", xlim = c(1,4), ylim = c(0,1), axes = F)
axis(side=1,at=seq(0,7,0.5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
lines(prob2_bet/sure2_bet, psychFunc1,  lwd = 6, col =  rgb3_5, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet/sure2_bet, psychFunc2,  lwd = 6, col =  rgb3_3, pch = 16, cex = 2.5, lty = 3)

legend(2.1,0.4, legend = c("Precise Coding", "Noisy Log Coding"), 
       col = c(rgb3_5,rgb3_3), pch = c(1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(c(1:4), rep(0.55,length(c(1:4))),  lwd = 3, col =  "black", pch = 16, cex = 3, lty = 2)
lines(rep(1.86,length(c(0:1))), c(0:1),  lwd = 3, col =  "black", pch = 16, cex = 3, lty = 2)
lines(rep(1.62,length(c(0:1))), c(0:1),  lwd = 4, col =  rgb3_3, pch = 16, cex = 3, lty = 1)

points(1.86, 0.55,  lwd = 4, col =  rgb3_5, pch = 16, cex = 3, lty = 1)
points(1.62, 0.55,  lwd = 4, col =  rgb3_3, pch = 16, cex = 3, lty = 1)


############################################################################################################################
### FIG 1.4
### MAGNITUDE COMPARISON
sep_dic <- matrix(  c(1454.343176, 1296.299097,1226.80956,1153.115726,965.3543375,833.4928938)/1000, byrow=1)
### RISKY - POOLED
sep_dic <- matrix(c(3599.287788,3734.456405,3744.525444,3524.653465,3492.480291,3533.701516)/1000,byrow=1)
### RISKY - SYMBOL
sep_dic <- matrix(c(1578.187832,1679.810415,1696.352309,1447.480338,1405.564608,1526.043456)/1000,byrow=1)
### RISKY - COIN
sep_dic <- matrix(c(1987.634208, 2010.015854, 2014.08641, 1880.655695, 1894.481143, 1852.22964)/1000,byrow=1)


colnames(sep_dic) <- "Unrestricted"
rownames(sep_dic) <- c("28","20","14","10","7","5")

### MAGNITUDE COMPARISON
barplot(sep_dic, main="DIC",
        col=c(rgb6,rgb5,rgb4,rgb3,rgb2,rgb1), ylim = c(0,7),
        cex.axis = 2, cex.names = 2.2, cex.main = 3, ylab = "in Thousands", cex.lab = 2.5)

text(0.7,6.55,"5", cex= 3); text(0.7,5.65,"7", cex= 3); text(0.7,4.6,"10", cex= 3)
text(0.7,3.4,"14", cex= 3); text(0.7,2.15,"20", cex= 3); text(0.7,0.8,"28", cex= 3)

### RISKY CHOICE - POOLED
barplot(sep_dic, main="DIC", 
        col=c(rgb6,rgb5,rgb4,rgb3,rgb2,rgb1), ylim = c(0,25),
        cex.axis = 2, cex.names = 2.2, cex.main = 3, ylab = "in Thousands", cex.lab = 2.5)

text(0.7,20,"5", cex= 3); text(0.7,16.5,"7", cex= 3); text(0.7,13,"10", cex= 3)
text(0.7,9.5,"14", cex= 3); text(0.7,5.7,"20", cex= 3); text(0.7,2,"28", cex= 3)

### RISKY CHOICE - SYMBOL
barplot(sep_dic, main="DIC", 
        col=c(rgb6,rgb5,rgb4,rgb3,rgb2,rgb1), ylim = c(0,10),
        cex.axis = 2, cex.names = 2.2, cex.main = 3, ylab = "in Thousands", cex.lab = 2.5)

text(0.7,8.6,"5", cex= 3); text(0.7,7.2,"7", cex= 3); text(0.7,5.7,"10", cex= 3)
text(0.7,4.2,"14", cex= 3); text(0.7,2.5,"20", cex= 3); text(0.7,0.9,"28", cex= 3)

### RISKY CHOICE - COINS
barplot(sep_dic, main="DIC", 
        col=c(rgb6,rgb5,rgb4,rgb3,rgb2,rgb1), ylim = c(0,12),
        cex.axis = 2, cex.names = 2.2, cex.main = 3, ylab = "in Thousands", cex.lab = 2.5)

text(0.7,10.7,"5", cex= 3); text(0.7,8.9,"7", cex= 3); text(0.7,7,"10", cex= 3)
text(0.7,5,"14", cex= 3); text(0.7,3,"20", cex= 3); text(0.7,1,"28", cex= 3)

############################################################################################################################

### FIG 1.5
Separate1 <- 6929.414791
     KLW1 <- 6907.375162


     
Separate2 <- 9333.438958
     KLW2 <- 9103.933025

Separate3 <- 11639.10295
     KLW3 <- 11305.19639

     
model1 <- KLW1 - Separate1
model2 <- KLW2 - Separate2
model3 <- KLW3 - Separate3
     
dic1 <- c(Separate1, KLW1)
dic2 <- c(Separate2, KLW2)
dic3 <- c(Separate3, KLW3)

dic_all <- c(model1, model2, model3)

#par(mfrow=c(4,3))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### MAGNITUDE COMPARISON     
barplot(dic1, ylim = c(6.9,6.94), names.arg = c("Unrestricted","NLC"), border =c(rgb4,rgb6), col =c(rgb4,rgb6), main = "",beside = TRUE, xpd = FALSE, cex.lab = 2.0, cex.names = 2, cex.main = 3, ylab = "in Thousands", cex.axis = 2.0)     
### RISKY CHOICE - COINS
barplot(dic3, ylim = c(11.2,11.8), names.arg = c("Unrestricted","NLC"), border =c(rgb3_4,rgb3_6), col =c(rgb3_4,rgb3_6), main = "DIC",beside = TRUE, xpd = FALSE, cex.lab = 2.0, cex.names = 2, cex.main = 3, ylab = "in Thousands", cex.axis = 2.0)  
### RISKY CHOICE - SYMBOL
barplot(dic2, ylim = c(9,9.4), names.arg = c("Unrestricted","NLC"), border =c(rgb2_4,rgb2_6), col =c(rgb2_4,rgb2_6), main = "",beside = TRUE, xpd = FALSE, cex.lab = 2.0, cex.names = 2, cex.main = 3, ylab = "in Thousands", cex.axis = 2.0)     

barplot(dic_all, ylim = c(-400,0), names.arg = c("Perceptual","Nonsymbolic","Symbolic"), border =c("black"), col =c(rgb4,rgb3_4,rgb2_4), main = "",beside = TRUE, xpd = FALSE, cex.lab = 2.0, cex.names = 2, cex.main = 3, ylab = "IC Difference", cex.axis = 2.0)     


#########################################################################################################################################
#########################################################################################################################################

par(mfrow=c(2,1))

#########################################################################

riskcomp <- read.csv("prec_neural_sub.csv")
riskcomp_coin <- read.csv("prec_neural_sub.csv")

riskcomp <- read.csv("riskPrecision_data_new2.csv")

### Check for Outliers in POOLED
noise_outlier0 <- boxplot.stats (riskcomp$risk_noise3, coef = 8)$out
print(noise_outlier0)

### Check for Outliers in SYMBOLS
noise_outlier1 <- boxplot.stats (riskcomp$risk_noise1, coef = 8)$out
print(noise_outlier1)

### Check for Outliers in COINS
noise_outlier2 <- boxplot.stats (riskcomp$risk_noise2, coef = 8)$out
print(noise_outlier2)

riskcomp[which(riskcomp$risk_noise3 %in% noise_outlier0),]
riskcomp <- riskcomp[-which(riskcomp$risk_noise3 %in% noise_outlier0),]

### COINS
riskcomp_coin[which(riskcomp_coin$risk_noise2 %in% noise_outlier2),]
riskcomp_coin <- riskcomp_coin[-which(riskcomp_coin$risk_noise2 %in% noise_outlier2),]

#########################################################################
#########################################################################

### FIGURE 2
par(mfrow=c(2,2))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 


#####################################

### 2.4 COINS - RNP (RISK)
df4 <- data.frame(x = riskcomp$riskPrec_dot, y = riskcomp$rnp_dot)
mod4 <- (lm(y ~ x, data = df4))
newx4 <- seq(min(df4$x), max(df4$x), length.out = 100000)
preds4 <- predict(mod4, newdata = data.frame(x=newx4),interval='confidence')

plot(df4$x, df4$y, col = rgb(253/255, 195/255, 140/255, 0.8), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Risk payoff precision", ylab = "Risk-neutral probability", xlim = c(0,max(df4$x)), ylim = c(0,0.8), axes = F)
axis(side=1,at=seq(round(min(df4$x),0),round(max(df4$x),0),1), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)
abline(mod4, lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx4), newx4), c(rev(preds4[ ,3]), preds4[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

cor.test(df4$x,df4$y)

#text(3.1,0.1,"r = 0.734***", cex= 1.8)
legend(3.1,0.1, legend=c("r = 0.70***"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  "black", cex = 2.5)
#legend(3.1,0.1, legend=c("r = 0.734, p < 0.001"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 1)), cex = 2.5)

point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.44403550^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)

### 2.3 SYMBOLIC NUMBERS - RNP (RISK)
df3 <- data.frame(x = riskcomp$riskPrec_sym, y = riskcomp$rnp_sym)
mod3 <- (lm(y ~ x, data = df3))
newx3 <- seq(min(df3$x), max(df3$x), length.out = 100000)
preds3 <- predict(mod3, newdata = data.frame(x=newx3),interval='confidence')

plot(df3$x, df3$y, col = rgb(107/255, 174/255, 214/255, 0.8), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Risk payoff precision", ylab = "Risk-neutral probability", xlim = c(0,max(df3$x)), ylim = c(0,0.8), axes = F)
axis(side=1,at=seq(round(min(df3$x),0),round(max(df3$x),0),1), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)
abline(mod3, lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx3), newx3), c(rev(preds3[ ,3]), preds3[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)

cor.test(df3$x,df3$y)
#text(4,0.1,"r = 0.567***", cex= 1.8)
legend(4,0.1, legend=c("r = 0.55***"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  "black", cex = 2.5)
#legend(4,0.1, legend=c("r = 0.567, p < 0.001"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  c(rgb(55/255, 135/255, 192/255, 1)), cex = 2.5)

point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.3821815^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)


####################################
### 2.2 COINS - PRECISION
df2 <- data.frame(y = riskcomp$riskPrec_dot, x = riskcomp$magPrec)
mod2 <- (lm(y ~ x, data = df2))
newx2 <- seq(min(df2$x), max(df2$x), length.out = 100000)
preds2 <- predict(mod2, newdata = data.frame(x=newx2),interval='confidence')

plot(df2$x, df2$y, col =rgb(253/255, 195/255, 140/255, 0.9), pch = 19, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Magnitude precision", ylab = "Risky payoff precision", xlim = c(round(min(df2$x),1),round(max(df2$x),1)), ylim = c(0,round(max(df2$y),0)), axes = F)
axis(side=1,at=seq(round(min(df2$x),0),round(max(df2$x),0),1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df2$y),0),1), cex.axis = 2)
abline(mod2, lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx2), newx2), c(rev(preds2[ ,3]), preds2[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)
cor.test(df2$x,df2$y)
#text(3.0,1.0,"r = 0.349, p < 0.005", cex= 1.8)

legend(3.3,0.5, legend=c("r = 0.298**"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  "black", cex = 2.5)
#legend(3.3,0.5, legend=c("r = 0.349, p = 0.005"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 1)), cex = 2.5)


####################################
### 2.1 SYMBOLIC NUMBERS - PRECISION

df1 <- data.frame(y = riskcomp$riskPrec_sym, x = riskcomp$magPrec)
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(107/255, 174/255, 214/255, 0.9), pch = 19, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Magnitude precision", ylab = "Risky payoff precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(0,max(df1$y)), axes = F)
axis(side=1,at=seq(round(min(df1$x),0),round(max(df1$x),0),1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df1$y),0),1), cex.axis = 2)
abline(mod1, lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)
cor.test(df1$x,df1$y)
#text(3.3,1.5,"r = 0.437, p < 0.001", cex= 1.8)

legend(3.3,0.7, legend=c("r = 0.305**"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  "black", cex = 2.5)
#legend(3.3,0.7, legend=c("r = 0.437, p < 0.001"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  c(rgb(55/255, 135/255, 192/255, 1)), cex = 2.5)

###0.332109
###0.4065865



### 2.6 COINS - PRECISION
df6 <- data.frame(x = riskcomp$magPrec, y = riskcomp$rnp_dot)
mod6 <- (lm(y ~ x, data = df6))
newx6 <- seq(min(df6$x), max(df6$x), length.out = 100000)
preds6 <- predict(mod6, newdata = data.frame(x=newx6),interval='confidence')
plot(df6$x, df6$y, col = rgb(253/255, 195/255, 140/255, 0.8), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Magnitude precision", ylab = "Risk-neutral probability", xlim = c(min(df6$x),max(df6$x)), ylim = c(0,0.8), axes =F)
axis(side=1,at=seq(round(min(df6$x),0),round(max(df6$x),0),1), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)
abline(mod6, lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx6), newx6), c(rev(preds6[ ,3]), preds6[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

cor.test(df6$x,df6$y)

#text(3.2,0.10,"r = 0.35, p = 0.005", cex= 1.8)
legend(3.2,0.10, legend=c("r = 0.34**"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  "black", cex = 2.5)
#legend(3.2,0.10, legend=c("r = 0.35, p = 0.005"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 1)), cex = 2.5)


point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.332109^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)


### 2.5 SYMBOLIC NUMBERS - MAGNITUDE PRECISION
df5 <- data.frame(x = riskcomp$magPrec, y = riskcomp$rnp_sym)
mod5 <- (lm(y ~ x, data = df5))
newx5 <- seq(min(df5$x), max(df5$x), length.out = 100000)
preds5 <- predict(mod5, newdata = data.frame(x=newx5),interval='confidence')

plot(df5$x, df5$y, col = rgb(107/255, 174/255, 214/255, 0.8), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Magnitude precision", ylab = "Risk-neutral probability", xlim = c(min(df5$x),max(df5$x)), ylim = c(0,0.8), axes =F)
axis(side=1,at=seq(round(min(df5$x),0),round(max(df5$x),0),1), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)
abline(mod5, lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx5), newx5), c(rev(preds5[ ,3]), preds5[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)

cor.test(df5$x,df5$y)

#text(3.5,0.2,"r = 0.283, p = 0.02", cex= 1.8)
legend(3.5,0.1, legend=c("r = 0.241*"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  "black", cex = 2.5)
#legend(3.5,0.1, legend=c("r = 0.283, p = 0.02"),bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.1,adj = c(0, 0.5), text.col =  c(rgb(55/255, 135/255, 192/255, 1)), cex = 2.5)


point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.400^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)




################################################################################

#########################################################################
#########################################################################

### FIGURE 2
par(mfrow=c(3,2))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

####################################
### 2.2 COINS - PRECISION
df2 <- data.frame(y = log(riskcomp$risk_prec2), x = log(riskcomp$mag_prec2))
mod2 <- (lm(y ~ x, data = df2))
newx2 <- seq(min(df2$x), max(df2$x), length.out = 100000)
preds2 <- predict(mod2, newdata = data.frame(x=newx2),interval='confidence')

plot(df2$x, df2$y, col =rgb(253/255, 195/255, 140/255, 0.9), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Log magnitude comparison precision", ylab = "Log risky payoff precision", xlim = c(round(min(df2$x),1),round(max(df2$x),1)), ylim = c(round(min(df2$y),1),round(max(df2$y),1)), axes = F)
axis(side=1,at=seq(round(min(df2$x),1),round(max(df2$x),1),0.2), cex.axis = 2)
axis(side=2,at=seq(round(min(df2$y),1),round(max(df2$y),1),0.2), cex.axis = 2)
abline(mod2, lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx2), newx2), c(rev(preds2[ ,3]), preds2[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)
cor.test(df2$x,df2$y)
text(1.0,-1.6,"r = 0.345, p = 0.005", cex= 1.8)

####################################
### 2.1 SYMBOLIC NUMBERS - PRECISION

df1 <- data.frame(y = log(riskcomp$risk_prec1), x = log(riskcomp$mag_prec1))
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(107/255, 174/255, 214/255, 0.9), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Log magnitude comparison precision", ylab = "Log risky payoff precision", xlim = c(round(min(df1$x),1),round(max(df1$x),1)), ylim = c(round(min(df1$y),1),round(max(df1$y),1)), axes = F)
axis(side=1,at=seq(round(min(df1$x),1),round(max(df1$x),1),0.2), cex.axis = 2)
axis(side=2,at=seq(round(min(df1$y),1),round(max(df1$y),1),0.2), cex.axis = 2)
abline(mod1, lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(1.2,-0.35,"r = 0.403, p < 0.001", cex= 1.8)



#####################################

### 2.4 COINS - RNP (RISK)
df4 <- data.frame(x = log(riskcomp$risk_prec2), y = log(riskcomp$riskav_risk2))
mod4 <- (lm(y ~ x, data = df4))
newx4 <- seq(min(df4$x), max(df4$x), length.out = 100000)
preds4 <- predict(mod4, newdata = data.frame(x=newx4),interval='confidence')

plot(df4$x, df4$y, col = rgb(253/255, 195/255, 140/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Log risk payoff precision", ylab = "Log risk-neutral probability", xlim = c(round(min(df4$x),1),round(max(df4$x),1)), ylim = c(round(min(df4$y),1),round(max(df4$y),1)), axes = F)
axis(side=1,at=seq(round(min(df4$x),1),round(max(df4$x),1),0.2), cex.axis = 2)
axis(side=2,at=seq(round(min(df4$y),1),round(max(df4$y),1),0.2), cex.axis = 2)
abline(mod4, lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx4), newx4), c(rev(preds4[ ,3]), preds4[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

cor.test(df4$x,df4$y)

text(-0.3,-6.0,"r = 0.765, p < 0.001", cex= 1.8)

#point <- (seq(0,16,0.01)
#pi_pred <- log(0.55^(1+(2*(0.4406^2)*(point^2))^-1 ))

#lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
#abline(h=0.55, lty=2, col="black", lwd=3)

### 2.3 SYMBOLIC NUMBERS - RNP (RISK)
df3 <- data.frame(x = log(riskcomp$risk_prec1), y = log(riskcomp$riskav_risk1))
mod3 <- (lm(y ~ x, data = df3))
newx3 <- seq(min(df3$x), max(df3$x), length.out = 100000)
preds3 <- predict(mod3, newdata = data.frame(x=newx3),interval='confidence')

plot(df3$x, df3$y, col = rgb(107/255, 174/255, 214/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Log risk payoff precision", ylab = "Log risk-neutral probability", xlim = c(round(min(df3$x),1),round(max(df3$x),1)), ylim = c(round(min(df3$y),1),round(max(df3$y),1)), axes = F)
axis(side=1,at=seq(round(min(df3$x),1),round(max(df3$x),1),0.2), cex.axis = 2)
axis(side=2,at=seq(round(min(df3$y),1),round(max(df3$y),1),0.2), cex.axis = 2)
abline(mod3, lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx3), newx3), c(rev(preds3[ ,3]), preds3[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)

cor.test(df3$x,df3$y)
text(1,-2.0,"r = 0.522, p < 0.001", cex= 1.8)

#point <- seq(0,16,0.01)
#pi_pred <- 0.55^(1+(2*(0.382^2)*(point^2))^-1 )

#lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
#abline(h=0.55, lty=2, col="black", lwd=3)


### 2.6 COINS - PRECISION
df6 <- data.frame(x = log(riskcomp$mag_prec2), y = log(riskcomp$riskav_risk2))
mod6 <- (lm(y ~ x, data = df6))
newx6 <- seq(min(df6$x), max(df6$x), length.out = 100000)
preds6 <- predict(mod6, newdata = data.frame(x=newx6),interval='confidence')
plot(df6$x, df6$y, col = rgb(253/255, 195/255, 140/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Log magnitude comparison precision", ylab = "Log risk-neutral probability", xlim = c(round(min(df6$x),1),round(max(df6$x),1)), ylim = c(round(min(df6$y),1),round(max(df6$y),1)), axes =F)
axis(side=1,at=seq(round(min(df6$x),1),round(max(df6$x),1),0.2), cex.axis = 2)
axis(side=2,at=seq(round(min(df6$y),1),round(max(df6$y),1),0.2), cex.axis = 2)
abline(mod6, lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx6), newx6), c(rev(preds6[ ,3]), preds6[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

cor.test(df6$x,df6$y)

text(1,-6.0,"r = 0.382, p = 0.001", cex= 1.8)

#point <- seq(0,16,0.01)
#pi_pred <- 0.55^(1+(2*(0.333^2)*(point^2))^-1 )

#lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
#abline(h=0.55, lty=2, col="black", lwd=3)


### 2.5 SYMBOLIC NUMBERS - MAGNITUDE PRECISION
df5 <- data.frame(x = log(riskcomp$mag_prec1), y = log(riskcomp$riskav_risk1))
mod5 <- (lm(y ~ x, data = df5))
newx5 <- seq(min(df5$x), max(df5$x), length.out = 100000)
preds5 <- predict(mod5, newdata = data.frame(x=newx5),interval='confidence')

plot(df5$x, df5$y, col = rgb(107/255, 174/255, 214/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Log magnitude comparison precision", ylab = "Log risk-neutral probability", xlim = c(round(min(df5$x),1),round(max(df5$x),1)), ylim = c(round(min(df5$y),1),round(max(df5$y),1)), axes =F)
axis(side=1,at=seq(round(min(df5$x),1),round(max(df5$x),1),0.2), cex.axis = 2)
axis(side=2,at=seq(round(min(df5$y),1),round(max(df5$y),1),0.2), cex.axis = 2)
abline(mod5, lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx5), newx5), c(rev(preds5[ ,3]), preds5[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)

cor.test(df5$x,df5$y)

text(1.0,-2.0,"r = 0.378, p = 0.002", cex= 1.8)

#point <- seq(0,16,0.01)
#pi_pred <- 0.55^(1+(2*(0.400^2)*(point^2))^-1 )

#lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
#abline(h=0.55, lty=2, col="black", lwd=3)




################################################################################


###########################
###########################

### SUPPLEMENTARY 2.1 LINEAR
par(mfrow=c(3,3))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

plot(prob_risk4_05, mu_risk4_05,  col = rgb1, , pch = 16, cex.main = 3, cex = 3.5, cex.lab = 2, cex.axis = 2, 
     main = "Linear",xlab = "Risky Offers", ylab = "Pr(Accept Risky)", xlim = c(0,115), ylim = c(0,1), axes = F)
axis(side=1,at=seq(-20,150,20), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(85,0.76, legend = c(5,7,10,14,20,28), title = "Sure Offer", 
       col = c(rgb1,rgb2,rgb3,rgb4,rgb5,rgb6),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob4_bet05, risk4_05,  lwd = 8, col =  rgb1, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet07, risk4_07,  lwd = 8, col =  rgb2, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet10, risk4_10,  lwd = 8, col =  rgb3, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet14, risk4_14,  lwd = 8, col =  rgb4, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet20, risk4_20,  lwd = 8, col =  rgb5, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet28, risk4_28,  lwd = 8, col =  rgb6, pch = 16, cex = 2.5, lty = 1)

points(prob_risk4_07, mu_risk4_07, col = rgb2, pch = 16, cex = 3.5)
points(prob_risk4_10, mu_risk4_10, col = rgb3, pch = 16, cex = 3.5)
points(prob_risk4_14, mu_risk4_14, col = rgb4, pch = 16, cex = 3.5)
points(prob_risk4_20, mu_risk4_20, col = rgb5, pch = 16, cex = 3.5)
points(prob_risk4_28, mu_risk4_28, col = rgb6, pch = 16, cex = 3.5)

###  SUPPLEMENTARY 2.2 - CORRELATION 1
df0 <- data.frame(y = riskcomp$risk_prec3, x = riskcomp$mag_prec3)
mod0 <- (lm(y ~ x, data = df0))
newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')

plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.9), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Numerosity Precision", ylab = "Risk Precision", xlim = c(min(df0$x),max(df0$x)), ylim = c(min(df0$y),max(df0$y)), axes = F)
axis(side=1,at=seq(round(min(df0$x),0),round(max(df0$x),0),1), cex.axis = 2)
axis(side=2,at=seq(round(min(df0$y),0),round(max(df0$y),0),1), cex.axis = 2)
abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)

cor.test(df0$x,df0$y)
text(3.2,1.5,"r = 0.356, p = 0.004", cex= 1.8)

### SUPPLEMENTARY 2.3 - LOGARITHMIC
plot(prob_risk4_05, mu_risk4_05,  col = rgb1, log = "x", pch = 16, cex.main = 3, cex = 3.5, cex.lab = 2, cex.axis = 2, 
     main = "Logarithmic",xlab = "Risky Offers", ylab = "Pr(Accept Risky)", xlim = c(5,211), ylim = c(0,1), axes = F)
axis(side=1,at=seq(-20,150,5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(100,0.76, legend = c(5,7,10,14,20,28), title = "Sure Offer", 
       col = c(rgb1,rgb2,rgb3,rgb4,rgb5,rgb6),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob4_bet05, risk4_05,  lwd = 8, col =  rgb1, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet07, risk4_07,  lwd = 8, col =  rgb2, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet10, risk4_10,  lwd = 8, col =  rgb3, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet14, risk4_14,  lwd = 8, col =  rgb4, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet20, risk4_20,  lwd = 8, col =  rgb5, pch = 16, cex = 2.5, lty = 1)
lines(prob4_bet28, risk4_28,  lwd = 8, col =  rgb6, pch = 16, cex = 2.5, lty = 1)

points(prob_risk4_07, mu_risk4_07, col = rgb2, pch = 16, cex = 3.5)
points(prob_risk4_10, mu_risk4_10, col = rgb3, pch = 16, cex = 3.5)
points(prob_risk4_14, mu_risk4_14, col = rgb4, pch = 16, cex = 3.5)
points(prob_risk4_20, mu_risk4_20, col = rgb5, pch = 16, cex = 3.5)
points(prob_risk4_28, mu_risk4_28, col = rgb6, pch = 16, cex = 3.5)

### SUPPLEMENTARY 2.4 - RNP (RISK)
df0 <- data.frame(x = riskcomp$risk_prec3, y = riskcomp$riskav_risk3)
mod0 <- (lm(y ~ x, data = df0))
newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')

plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.9), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Risk Precision", ylab = "Risk-Neutral Probability", xlim = c(0,max(df0$x)), ylim = c(0,0.8), axes = F)
axis(side=1,at=seq(0,round(max(df0$x),0),1), cex.axis = 2)
axis(side=2,at=seq(0,0.8,0.2), cex.axis = 2)
abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)

cor.test(df0$x,df0$y)
text(3,0.1,"r = 0.678, p < 0.001", cex= 1.8)

point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.439^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)

### SUPPLEMENTARY 2.5 - SCALE INVARIANCE
plot(prob_risk4_05/5, mu_risk4_05, log = "x", col = rgb1, pch = 16, cex.main = 3, cex = 3.5, cex.lab = 2, cex.axis = 2, 
     main = "Ratio",xlab = "Risky / Sure", ylab = "Pr(Accept Risky)", xlim = c(1.0,7), ylim = c(0,1), axes = F)
axis(side=1,at=seq(0,7,0.5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
legend(4.5,0.87, legend = c(5,7,10,14,20,28,"NC"), title = "Sure Offer", 
       col = c(rgb1,rgb2,rgb3,rgb4,rgb5,rgb6,"black"),
       pch = c(1,1,1,1,1,1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(prob4_bet05/sure4_bet05, risk4_sv_05,  lwd = 8, col =  rgb1, pch = 16, cex = 3, lty = 2)
lines(prob4_bet07/sure4_bet07, risk4_sv_07,  lwd = 8, col =  rgb2, pch = 16, cex = 3, lty = 2)
lines(prob4_bet10/sure4_bet10, risk4_sv_10,  lwd = 8, col =  rgb3, pch = 16, cex = 3, lty = 2)
lines(prob4_bet14/sure4_bet14, risk4_sv_14,  lwd = 8, col =  rgb4, pch = 16, cex = 3, lty = 2)
lines(prob4_bet20/sure4_bet20, risk4_sv_20,  lwd = 8, col =  rgb5, pch = 16, cex = 3, lty = 2)
lines(prob4_bet28/sure4_bet28, risk4_sv_28,  lwd = 8, col =  rgb6, pch = 16, cex = 3, lty = 2)

points(prob_risk4_07/7, mu_risk4_07, col = rgb2, pch = 16, cex = 3.5); points(prob_risk4_10/10, mu_risk4_10, col = rgb3, pch = 16, cex = 3.5)
points(prob_risk4_14/14, mu_risk4_14, col = rgb4, pch = 16, cex = 3.5); points(prob_risk4_20/20, mu_risk4_20, col = rgb5, pch = 16, cex = 3.5)
points(prob_risk4_28/28, mu_risk4_28, col = rgb6, pch = 16, cex = 3.5); #points(prob_risk2_28/28, mu_risk2_28, col = rgb6, pch = 16, cex = 3.5)

lines(prob4_bet/sure4_bet, risk4_sv_All,  lwd = 10, col =  "black", pch = 16, cex = 3, lty = 1)


### SUPPLEMENTARY 2.6 - RNP
df0 <- data.frame(x = riskcomp$mag_prec3, y = riskcomp$riskav_risk3)
mod0 <- (lm(y ~ x, data = df0))
newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')
plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Numerosity Precision", ylab = "Risk-Neutral Probability", xlim = c(min(df0$x),max(df0$x)), ylim = c(0,0.8), axes = F)
axis(side=1,at=seq(round(min(df0$x),0),round(max(df0$x),0),1), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)
abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)

cor.test(df0$x,df0$y)
text(2.5,0.1,"r = 0.323, p = 0.009", cex= 1.8)

point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.358^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)

##############################################
### SUPPLEMENTARY 2.1 LINEAR
par(mfrow=c(3,3))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### RISKY CHOICE - POOLED
Separate <- 21629.10491/1000
KLW <- 21247.06589/1000
dic0 <- c(Separate, KLW)
barplot(dic0, ylim = c(21,21.8), names.arg = c("Unrestricted","NC"), border =c(rgb4,rgb6), col =c(rgb4,rgb6), main = "DIC",beside = TRUE, xpd = FALSE, cex.lab = 2.0, cex.names = 2, cex.main = 3, ylab = "in Thousands", cex.axis = 2.0)     


#### RISKY - POOLED
precsExample_sv1 <- 7; sigmaExample_sv1 <- 7
precsExample_sv2 <- 5; sigmaExample_sv2 <- 4

psychFunc1 <- pnorm(precsExample_sv1*log(prob2_bet/sure2_bet) - log(0.55^-1)*sigmaExample_sv1,0,1)
psychFunc2 <- pnorm(precsExample_sv2*log(prob2_bet/sure2_bet) - log(0.55^-1)*sigmaExample_sv2,0,1)

plot(prob2_bet/sure2_bet, psychFunc1, log = "x", col = "white", pch = 16, cex.main = 3, cex = 3.5, cex.lab = 2, cex.axis = 2, 
     main = "Prediction",xlab = "Risky / Sure", ylab = "Pr(Accept Risky)", xlim = c(1,4), ylim = c(0,1), axes = F)
axis(side=1,at=seq(0,7,0.5), cex.axis = 2)
axis(side=2,at=seq(-1,1,0.5), cex.axis = 2)
lines(prob2_bet/sure2_bet, psychFunc1,  lwd = 6, col =  rgb5, pch = 16, cex = 2.5, lty = 1)
lines(prob2_bet/sure2_bet, psychFunc2,  lwd = 6, col =  rgb3, pch = 16, cex = 2.5, lty = 3)

legend(2.1,0.4, legend = c("Precise Coding", "Noisy Log Coding"), 
       col = c(rgb5,rgb3), pch = c(1,1), box.lty=0,cex=1.1, pt.cex = 0.5, pt.lwd = 12)

lines(c(1:4), rep(0.55,length(c(1:4))),  lwd = 3, col =  "black", pch = 16, cex = 3, lty = 2)
lines(rep(1.86,length(c(0:1))), c(0:1),  lwd = 3, col =  "black", pch = 16, cex = 3, lty = 2)
lines(rep(1.66,length(c(0:1))), c(0:1),  lwd = 4, col =  rgb3, pch = 16, cex = 3, lty = 1)

points(1.86, 0.55,  lwd = 4, col =  rgb5, pch = 16, cex = 3, lty = 1)
points(1.66, 0.55,  lwd = 4, col =  rgb3, pch = 16, cex = 3, lty = 1)

###########################
###########################


#########################################################################################################################

par(mfrow=c(4,3))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### SUPPLEMENTARY 3.1 SYMBOLIC NUMBERS - NOISE
df1 <- data.frame(y = riskcomp$risk_noise1, x = riskcomp$mag_noise1)
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')
plot(df1$x, df1$y, col =rgb(107/255, 174/255, 214/255, 0.9), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Numerosity Noise", ylab = "Risk Noise", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
axis(side=1,at=seq(0,round(max(df1$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df1$y),1),0.1), cex.axis = 2)
abline(mod1, lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(0.32,0.8,"r = 0.403, p = 0.001", cex= 1.8)

### SUPPLEMENTARY 3.2 SYMBOLIC NUMBERS - NOISE
df2 <- data.frame(y = riskcomp$risk_noise2, x = riskcomp$mag_noise2)
mod2 <- (lm(y ~ x, data = df2))
newx2 <- seq(min(df2$x), max(df2$x), length.out = 100000)
preds2 <- predict(mod2, newdata = data.frame(x=newx2),interval='confidence')
plot(df2$x, df2$y, col =rgb(253/255, 195/255, 140/255, 0.9), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Numerosity Noise", ylab = "Risk Noise", xlim = c(min(df2$x),max(df2$x)), ylim = c(min(df2$y),max(df2$y)), axes = F)
axis(side=1,at=seq(0,round(max(df2$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df2$y),1),0.1), cex.axis = 2)
abline(mod2, lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx2), newx2), c(rev(preds2[ ,3]), preds2[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)
cor.test(df2$x,df2$y)
text(0.32,1.40,"r = 0.497, p < 0.001", cex= 1.8)

### SUPPLEMENTARY 3.2 POOLED - NOISE
df0 <- data.frame(x = riskcomp$mag_noise3, y = riskcomp$risk_noise3)
mod0 <- (lm(y ~ x, data = df0))
newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')
plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Numerosity Noise", ylab = "Risk Noise", xlim = c(min(df0$x),max(df0$x)), ylim = c(min(df0$y),max(df0$y)), axes = F)
axis(side=1,at=seq(0,round(max(df0$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df0$y),1),0.1), cex.axis = 2)
abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)
cor.test(df0$x,df0$y)
text(0.32,0.75,"r = 0.461, p < 0.001", cex= 1.8)

### SUPPLEMENTARY 3.2 COIN CLOUDS - NOISE
df1 <- data.frame(x = riskcomp$mag_noise1, y = riskcomp$riskav_risk1)
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')
plot(df1$x, df1$y, col = rgb(107/255, 174/255, 214/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Numerosity Noise", ylab = "Risk-Neutral Probability", xlim = c(min(df1$x),max(df1$x)), ylim = c(0,0.8), axes = F)
axis(side=1,at=seq(0,round(max(df1$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(0,0.8,0.2), cex.axis = 2)
abline(mod1, lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(0.32,0.6,"r = -0.327, p = 0.009", cex= 1.8)

### 2.12 COINS - NOISE
df2 <- data.frame(x = riskcomp$mag_noise2, y = riskcomp$riskav_risk2)
mod2 <- (lm(y ~ x, data = df2))
newx2 <- seq(min(df2$x), max(df2$x), length.out = 100000)
preds2 <- predict(mod2, newdata = data.frame(x=newx2),interval='confidence')
plot(df2$x, df2$y, col = rgb(253/255, 195/255, 140/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Numerosity Noise", ylab = "Risk-Neutral Probability", xlim = c(min(df2$x),max(df2$x)), ylim = c(0,0.8), axes = F)
axis(side=1,at=seq(0,round(max(df2$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(0,0.8,0.2), cex.axis = 2)
abline(mod2, lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx2), newx2), c(rev(preds2[ ,3]), preds2[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)
cor.test(df2$x,df2$y)
text(0.32,0.6,"r = -0.406, p < 0.001", cex= 1.8)

### 2.4 POOLED - MAGNITUDE NOISE
df0 <- data.frame(x = riskcomp$mag_noise3, y = riskcomp$riskav_risk3)
mod0 <- (lm(y ~ x, data = df0))
newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')
plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "Numerosity Noise", ylab = "Risk-Neutral Probability", xlim = c(min(df0$x),max(df0$x)), ylim = c(0,0.8), axes = F)
axis(side=1,at=seq(0,round(max(df0$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(0,0.8,0.2), cex.axis = 2)
abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)
cor.test(df0$x,df0$y)
text(0.32,0.55,"r = -0.374, p = 0.003", cex= 1.8)


#########################################################################################################################################
#########################################################################################################################################

### FIGURE 3
setwd("D:/Projects/RISKPRECISION")
riskcomp <- read.csv("riskPrecision_data_new.csv")
par(mfrow=c(3,2))

#######################################################################

x_new <- c(riskcomp$risk_prec2, riskcomp$risk_prec3)
y_new <- c(riskcomp$riskav_risk2, riskcomp$riskav_risk3)
num <- c(rep(0,64),rep(1,64))

### 3.2 SYMBOLIC NUMBERS - PRECISION
df1 <- data.frame(x = riskcomp$risk_prec3, y = riskcomp$riskav_risk3)
plot(df1$x, df1$y, col = rgb(107/255, 174/255, 214/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "NUMBERS",xlab = "Risk Precision", ylab = "Risk-Neutral Probability", xlim = c(0,max(df1$x)+0.05), ylim = c(0,0.7))

#0.4396
#0.380

### FIT THE MODEL
pi <- riskcomp$rnp_sym
gam <- riskcomp$magPrec
num <- num #riskcomp$risk_prec2
#b = 1/riskcomp$mag_prec2

dat <- dump.format(list(N=length(pi), pi=pi, gam = gam))
inits1 <- dump.format(list(invar.mu=0.5,delta.mu=0.3,sigma.mu=0.5,gamma.mu = 0.3, .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
inits2 <- dump.format(list(invar.mu=0.5,delta.mu=0.3,sigma.mu=0.5,gamma.mu = 0.3, .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
inits3 <- dump.format(list(invar.mu=0.5,delta.mu=0.3,sigma.mu=0.5,gamma.mu = 0.3, .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))

monitor = c("invar.mu", "sigma.mu","gamma.mu","delta.mu","invar.mu.coin", "sigma.mu.coin","gamma.mu.coin","deviance")
test <- run.jags(model="D:/Projects/RISKPRECISION/data/jags_file/heterogen2.txt", monitor=monitor,
                   data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=100000, sample=1000, thin=100)
View(summary(test))


rr_model3 = rbind(rr_df3$mcmc[[1]], rr_df3$mcmc[[2]], rr_df3$mcmc[[3]])
rr_model2 = rbind(rr_df2$mcmc[[1]], rr_df2$mcmc[[2]], rr_df2$mcmc[[3]])


sigma_sym3 <- rr_model3[,"sigma.mu"]        ### PRECISION FOR SYMBOLIC NUMBERS
sigma_sym2 <- rr_model2[,"sigma.mu"]        ### PRECISION FOR SYMBOLIC NUMBERS


point <- seq(0,16,0.01)
#pi_pred <- 0.55^(1+(2*(0.382^2)*(gam^2))^-1 )
#pi_pred <- 0.55^(1+(2*(0.382^2)*((point)^2))^-1 )

lines(gam, pi_pred,  lwd = 5, col =  "red", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)


### 3.8 POOLED - MAGNITUDE PRECISION
df1 <- data.frame(x = riskcomp$mag_prec1, y = riskcomp$riskav_risk1)
plot(df1$x, df1$y, col = rgb(107/255, 174/255, 214/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "NUMBERS",xlab = "Magnitude Precision", ylab = "Risk-Neutral Probability", xlim = c(0,max(df1$x)+0.05), ylim = c(0,0.7))

### FIT THE MODEL
pi <- riskcomp$riskav_risk1
gam <- riskcomp$mag_prec1

dat <- dump.format(list(N=length(pi), pi=pi, gam = gam))
inits1 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
inits2 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
inits3 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))

monitor = c("invar.mu", "sigma.mu","deviance")
rm_df1 <- run.jags(model="D:/Projects/RISKPRECISION/data/jags_file/heterogen.txt", monitor=monitor,
                   data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=10000, sample=1000, thin=10)

point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.400^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)

#######################################################################

### 3.3 COINS - PRECISION
df2 <- data.frame(x = riskcomp$risk_prec2, y = riskcomp$riskav_risk2)
plot(df2$x, df2$y, col = rgb(253/255, 195/255, 140/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "COINS",xlab = "Risk Precision", ylab = "Risk-Neutral Probability", xlim = c(0,max(df2$x)+0.05), ylim = c(0,0.7))

### FIT THE MODEL
pi <- riskcomp$riskav_risk2
gam <- riskcomp$risk_prec2

dat <- dump.format(list(N=length(pi), pi=pi, gam = gam))
inits1 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
inits2 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
inits3 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))

monitor = c("invar.mu", "sigma.mu","deviance")
rr_df2 <- run.jags(model="D:/Projects/RISKPRECISION/data/jags_file/heterogen.txt", monitor=monitor,
                   data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=10000, sample=1000, thin=10)

point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.4406^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)


### 3.9 COINS - PRECISION
df2 <- data.frame(x = riskcomp$mag_prec2, y = riskcomp$riskav_risk2)
plot(df2$x, df2$y, col = rgb(253/255, 195/255, 140/255, 0.8), pch = 16, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "COINS",xlab = "Magnitude Precision", ylab = "Risk-Neutral Probability", xlim = c(0,max(df2$x)+0.05), ylim = c(0,0.7))

### FIT THE MODEL
pi <- riskcomp$riskav_risk2
gam <- riskcomp$mag_prec2

dat <- dump.format(list(N=length(pi), pi=pi, gam = gam))
inits1 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Super-Duper", .RNG.seed=99999 ))
inits2 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Wichmann-Hill", .RNG.seed=1234 ))
inits3 <- dump.format(list(invar.mu=0.5,noise.si=0.3,sigma.mu=0.5,sigma.si = 0.3, .RNG.name="base::Mersenne-Twister", .RNG.seed=6666 ))

monitor = c("invar.mu", "sigma.mu","deviance")
rm_df2 <- run.jags(model="D:/Projects/RISKPRECISION/data/jags_file/heterogen.txt", monitor=monitor,
                   data=dat, n.chains=3, inits=c(inits1,inits2, inits3), plots = FALSE, method="parallel", burnin=10000, sample=1000, thin=10)

point <- seq(0,16,0.01)
pi_pred <- 0.55^(1+(2*(0.333^2)*(point^2))^-1 )

lines(point, pi_pred,  lwd = 5, col =  "black", pch = 16, cex = 3, lty = 3)
abline(h=0.55, lty=2, col="black", lwd=3)


#######################################################################

source("D:/Projects/PECONFOOD_fMRI_TMS/SFS_BehaviorData/subjects_choices/HDIofMCMC.r")

### RISK VERSUS COIN 

##### BAYESIAN POSTERIOR ANALYSIS ####
load("rprec_symcoins.RData") 

load("rprec_magAgg.RData")

symcoin = rbind(rprec_symcoins$mcmc[[1]], rprec_symcoins$mcmc[[2]], rprec_symcoins$mcmc[[3]])

prec_sym <- symcoin[,"noise.mu"]        ### PRECISION FOR SYMBOLIC NUMBERS
prec_dff <- symcoin[,"noise.mu.coin"]   ### PRECISION DIFFERENCE
prec_coin <- prec_sym + prec_dff        ### PRECISION COIN

risk_sym_intercept <- symcoin[,"sigma.mu"]        ### Intercept for symbolic numbers
risk_dff_intercept <- symcoin[,"sigma.mu.coin"]   ### Intercept difference 
risk_coin_intercept <- risk_sym_intercept + risk_dff_intercept ### Intercept for coins

sym_noise <- 1/(sqrt(2)*prec_sym) ### NOISE SYMBOLIC
coin_noise <- 1/(sqrt(2)*prec_coin) ### NOISE COIN
noise_dff <- coin_noise - sym_noise

prior_sym <- sqrt((sym_noise^2)*log(1/0.55)/(risk_sym_intercept/prec_sym - log(1/0.55)))     ### PRIOR SYMBOLIC NUMBERS
prior_coin <- sqrt((coin_noise^2)*log(1/0.55)/(risk_coin_intercept/prec_coin - log(1/0.55))) ### PRIOR COINS

rnp_sym <- exp(-risk_sym_intercept/prec_sym)
rnp_coin <- exp(-risk_coin_intercept/prec_coin)
rnp_dff <- rnp_coin  - rnp_sym

prior_diff <- prior_sym - prior_coin


ip_sym  <- exp(risk_sym_intercept/prec_sym)
ip_coin <- exp(risk_coin_intercept/prec_coin)
ip_diff <- ip_coin - ip_sym 


r_sym_prec <- density(prec_sym)     ### Create density for precision symbolic 
r_coin_prec <- density(prec_coin)   ### Create density for precision coins 

r_sym_noise <- density(sym_noise)    ### Create density for noise symbolic
r_coin_noise <- density(coin_noise)  ### Create density for noise coins

r_sym_rnp <- density(rnp_sym)    ### Create density for Risk Neutral Probability symbolic
r_coin_rnp <- density(rnp_coin)  ### Create density for Risk Neutral Probability coins

r_sym_prior <- density(prior_sym)    ### Create density for prior symbolic
r_coin_prior <- density(prior_coin)  ### Create density for prior coins

r_prec_dff <- density(prec_dff) ### Post=hoc difference in precision
r_noise_dff <- density(noise_dff) ### Post=hoc difference in noise
r_prior_dff <- density(prior_diff) ### Post=hoc difference in priors
r_rnp_dff <- density(rnp_dff)

r_sym_ip <- density(ip_sym)
r_coin_ip <- density(ip_coin)
r_ip_diff <- density(ip_sym - ip_coin)


##### INDIVIDUAL DIFFERENCES #####

riskcomp <- read.csv("prec_neural_sub.csv")

### Check for Outliers in POOLED
noise_outlier1 <- boxplot.stats (riskcomp$mag_noise3, coef = 8)$out
print(noise_outlier1)

### Check for Outliers in SYMBOLS
noise_outlier2 <- boxplot.stats (riskcomp$symcoin_coinNoise, coef = 8)$out
print(noise_outlier2)

### Remove Outliers 
riskcomp <- riskcomp[-which(riskcomp$mag_noise1 %in% noise_outlier1),]
riskcomp <- riskcomp[-which(riskcomp$symcoin_coinNoise %in% noise_outlier2),]

######################################################################################
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0))

#layout.matrix <-  matrix(c(1,1,2,2,3,3,4,4,2,2,3,3, 5,5,6,6,7,7,8,8,6,6,7,7, 9,9,10,10,11,11,12,12,10,10,11,11), nrow = 6, ncol = 6)

#layout.matrix <-  matrix(c(1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,5,5,5,6,6,6), nrow = 6)

layout.matrix <-  matrix(c(1,1,2,2,3,3,4,4,5,5,6,6,7,7,7,8,8,8), nrow = 6)
layout.matrix <- t(layout.matrix)

layout(layout.matrix,
       heights = c(1,1), # Heights of the two rows
       widths = c(1,1)) # Widths of the two columns
layout.show(8)

### BAYESIAN COMPARISON
##### PRECISION
plot(r_sym_prec, xlim = c(1,4.5), ylim = c(0,4), lwd = 5, main = "", 
     ylab = "Density", xlab = "Precision", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
lines(r_coin_prec, col = rgb(252/255, 141/255, 89/255, 0.9), lwd = 5)
axis(side=1,at=seq(0,4,1), cex.axis = 2)
axis(side=2,at=seq(0,4,2), cex.axis = 2)
polygon(r_sym_prec, col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
polygon(r_coin_prec, col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
legend(1,4.1, c("Symbolic","Non-symbolic"), col = c( rgb(55/255, 135/255, 192/255, 0.9),rgb(252/255, 141/255, 89/255, 0.9)),box.lty=0,cex=1.3, pch = c(1,1),pt.cex = 1.4, pt.lwd = 8, bty="n")

##### NOISE
#plot(r_sym_noise, xlim = c(0.1,0.35), ylim = c(0,60), lwd = 5, main = "", 
#    ylab = "Density", xlab = "Noise", cex.main = 3, cex = 3, cex.lab = 2, cex.axis = 2.0,
#     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
#lines(r_coin_noise, col = rgb(252/255, 141/255, 89/255, 0.9), lwd = 5)
#axis(side=1,at=seq(0,0.5,0.1), cex.axis = 2)
#axis(side=2,at=seq(0,60,30), cex.axis = 2)
#polygon(r_sym_noise, col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
#polygon(r_coin_noise, col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
#legend(0.1,60, c("Numbers","Coins"), col = c( rgb(55/255, 135/255, 192/255, 0.9),rgb(252/255, 141/255, 89/255, 0.9)),box.lty=0,cex=1.3, pch = c(1,1),pt.cex = 1.4, pt.lwd = 8, bty = "n")

### PRIOR
plot(r_sym_prior, xlim = c(0.2,0.5), ylim = c(0,30), lwd = 5, main = "Parameter posteriors", 
     ylab = "Density", xlab = "Prior", cex.main = 3, cex = 3, cex.lab = 2, cex.axis = 2.4,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
lines(r_coin_prior, col = rgb(252/255, 141/255, 89/255, 0.9), lwd = 5)
axis(side=1,at=seq(0,0.6,0.1), cex.axis = 2)
axis(side=2,at=seq(0,30,15), cex.axis = 2)
polygon(r_sym_prior, col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
polygon(r_coin_prior, col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
legend(0.2,30, c("Symbolic","Nonsymbolic"), col = c( rgb(55/255, 135/255, 192/255, 0.9),rgb(252/255, 141/255, 89/255, 0.9)),box.lty=0,cex=1.3, pch = c(1,1),pt.cex = 1.4, pt.lwd = 8, bty="n")

### RISK-NEUTRAL PROBABILITY
plot(r_sym_rnp, xlim = c(0.2,0.6), ylim = c(0,30), lwd = 5, main = "", 
     ylab = "Density", xlab = "Risk aversion", cex.main = 3, cex = 3, cex.lab = 2, cex.axis = 2.4,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
lines(r_coin_rnp, col = rgb(252/255, 141/255, 89/255, 0.9), lwd = 5)
axis(side=1,at=seq(0,0.6,0.1), cex.axis = 2)
axis(side=2,at=seq(0,30,15), cex.axis = 2)
polygon(r_sym_rnp, col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
polygon(r_coin_rnp, col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
legend(0.2,30, c("Symbolic","Nonsymbolic"), col = c( rgb(55/255, 135/255, 192/255, 0.9),rgb(252/255, 141/255, 89/255, 0.9)),box.lty=0,cex=1.3, pch = c(1,1),pt.cex = 1.4, pt.lwd = 8, bty="n")
abline(v=0.55, lty=3, col="black", lwd=4)

#####################################################################################
### POST HOC TEST - PRECISION
plot(r_prec_dff, xlim = c(-1.5,0.2), ylim = c(0,4), lwd = 5, main = "", 
     ylab = "Density", xlab = "Precision", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(221/255, 52/255 , 151/255, 0.9), axes = F)
polygon(r_prec_dff, col =rgb(221/255, 52/255 , 151/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9) )
axis(side=1,at=seq(-1.5,1.5,0.5), cex.axis = 2)
axis(side=2,at=seq(0,4,2), cex.axis = 2)
hdi1 = HDIofMCMC(prec_dff, credMass=0.95)
x1 <- min(which(r_prec_dff$x >= hdi1[1] ))  
x2 <- max(which(r_prec_dff$x <  hdi1[2]))
with(r_prec_dff, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=rgb(253/255, 224/255 , 221/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9)))
abline(v=0, lty=3, col="black", lwd=4)

### POST HOC TEST - NOISE
#plot(r_noise_dff, xlim = c(-0.02,0.12), ylim = c(0,50), lwd = 5, main = "", 
#     ylab = "Density", xlab = "Risk aversion Post-hoc test", cex.main = 3, cex.lab =2, cex.axis = 2.4,
#     col = rgb(221/255, 52/255 , 151/255, 0.9), axes = F)
#polygon(r_noise_dff, col =rgb(221/255, 52/255 , 151/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9) )
#axis(side=1,at=seq(-0.5,0.10,0.05), cex.axis = 2)
#axis(side=2,at=seq(0,50,25), cex.axis = 2)
#hdi1 = HDIofMCMC(noise_dff, credMass=0.95)
#x1 <- min(which(r_noise_dff$x >= hdi1[1] ))  
#x2 <- max(which(r_noise_dff$x <  hdi1[2]))
#with(r_noise_dff, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=rgb(253/255, 224/255 , 221/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9)))
#abline(v=0, lty=3, col="black", lwd=4)

### POST HOC TEST - PRIOR
plot(r_prior_dff, xlim = c(-0.10,0.10), ylim = c(0,40), lwd = 5, main = "Post-hoc tests", 
     ylab = "Density", xlab = "Prior", cex.main = 3, cex.lab =2, cex.axis = 2.4,
     col = rgb(221/255, 52/255 , 151/255, 0.9), axes = F)
polygon(r_prior_dff, col =rgb(221/255, 52/255 , 151/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9) )
axis(side=1,at=seq(-0.15,0.15,0.1), cex.axis = 2)
axis(side=2,at=seq(0,40,20), cex.axis = 2)
hdi1 = HDIofMCMC(prior_diff , credMass=0.95)
x1 <- min(which(r_prior_dff$x >= hdi1[1] ))  
x2 <- max(which(r_prior_dff$x <  hdi1[2]))
with(r_prior_dff, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=rgb(253/255, 224/255 , 221/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9)))
abline(v=0, lty=3, col="black", lwd=4)

### POST HOC TEST - RISK NEUTRAL PROBABILITY
plot(r_rnp_dff, xlim = c(-0.15,0.05), ylim = c(0,40), lwd = 5, main = "", 
     ylab = "Density", xlab = "Risk aversion", cex.main = 3, cex.lab =2, cex.axis = 2.4,
     col = rgb(221/255, 52/255 , 151/255, 0.9), axes = F)
polygon(r_rnp_dff, col =rgb(221/255, 52/255 , 151/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9) )
axis(side=1,at=seq(-0.15,0.10,0.1), cex.axis = 2)
axis(side=2,at=seq(0,40,20), cex.axis = 2)
hdi1 = HDIofMCMC(rnp_dff , credMass=0.95)
x1 <- min(which(r_rnp_dff$x >= hdi1[1] ))  
x2 <- max(which(r_rnp_dff$x <  hdi1[2]))
with(r_rnp_dff, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=rgb(253/255, 224/255 , 221/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9)))
abline(v=0, lty=3, col="black", lwd=4)


### INDIVIDUAL DIFFERENCES
### PRECISION
riskcomp <- read.csv("riskPrecision_data_new2.csv")
df0 <- data.frame(y = riskcomp$riskPrec_sym, x = riskcomp$riskPrec_dot)
mod0 <- (lm(y ~ x, data = df0))
newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')
plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.9), pch = 16, cex.main = 3, cex = 3, cex.lab = 2.4, cex.axis = 2.0, 
     main = "Risky payoff precision",xlab = "Symbolic", ylab = "Non-symbolic", xlim = c(min(df0$x),max(df0$x)), ylim = c(min(df0$y),max(df0$y)), axes = F)
axis(side=1,at=seq(round(min(df0$x),0),round(max(df0$x),0),1), cex.axis = 2)
axis(side=2,at=seq(round(min(df0$y),0),round(max(df0$y),0),1), cex.axis = 2)
abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)
cor.test(df0$x,df0$y)
text(3.2,1.5,"r = 0.777, p < 0.001", cex= 2)

### NOISE
#riskcomp <- read.csv("prec_neural_sub.csv")
#noise_outlier2 <- boxplot.stats (riskcomp$symcoin_coinNoise, coef = 8)$out
#print(noise_outlier2)
#riskcomp <- riskcomp[-which(riskcomp$symcoin_coinNoise %in% noise_outlier2),]

#df0 <- data.frame(y = riskcomp$symcoin_symNoise, x = riskcomp$symcoin_coinNoise)
#mod0 <- (lm(y ~ x, data = df0))
#newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
#preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')
#plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.9), pch = 16, cex.main = 3, cex = 3, cex.lab = 2.4, cex.axis = 2.4, 
#     main = "",xlab = "Symbolic", ylab = "Non-symbolic", xlim = c(min(df0$x),max(df0$x)), ylim = c(min(df0$y),max(df0$y)), axes = F)
#axis(side=1,at=seq(round(min(df0$x),1),round(max(df0$x),1),0.2), cex.axis = 2)
#axis(side=2,at=seq(round(min(df0$x),1),round(max(df0$x),1),0.2), cex.axis = 2)
#abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
#polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)
#cor.test(df0$x,df0$y)
#text(0.5,0.7,"r = 0.89, p < 0.001", cex= 2)

### RISK NEUTRAL PROBABILITY
#riskcomp <- read.csv("prec_neural_sub.csv")

df0 <- data.frame(y = riskcomp$rnp_sym, x = riskcomp$rnp_dot)

df0$x[45] <- exp(-2.985690e-01/3.811145e-01)

mod0 <- (lm(y ~ x, data = df0))
newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')
plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.9), pch = 16, cex.main = 3, cex = 3, cex.lab = 2.4, cex.axis = 2.4, 
     main = "Risk aversion",xlab = "Symbolic", ylab = "Non-symbolic", xlim = c(min(df0$x),max(df0$x)), ylim = c(min(df0$y),max(df0$y)), axes = F)
axis(side=1,at=seq(round(min(df0$x),1),round(max(df0$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(round(min(df0$y),1),round(max(df0$y),1),0.1), cex.axis = 2)
abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)
cor.test(df0$x,df0$y)
text(0.3,0.6,"r = 0.792, p < 0.001", cex= 2)


######################################################################################
####################### TRIALWISE REULTS #############################################
riskcomp <- read.csv("prec_neural_sub.csv")

par(mfrow=c(3,4))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### 2.1 SYMBOLIC NUMBERS - NPC1 RIGHT
df1 <- data.frame(y = riskcomp$mag_prec3, x = riskcomp$NPC1_R_r_trial)
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(0/255, 255/255, 0/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = "R NPC Decoded Accuracy ", ylab = "Numerosity Precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(50/255, 205/255, 50/2555, 0.9))
axis(side=1,at=seq(round(min(df1$x),1),round(max(df1$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(round(min(df1$y),0),round(max(df1$y),0),1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(50/255, 205/255, 50/2555, 0.3), border = NA)
cor.test(df1$x,df1$y)

text(0.2,2,"r = 0.474, p < 0.001", cex= 1.8) ## TRIAL
#text(0.25,2,"r = 0.467, p < 0.001", cex= 1.8) ## RUN

### 2.3 SYMBOLIC NUMBERS - NPC1 LEFT
df1 <- data.frame(y = riskcomp$mag_prec3, x = riskcomp$NPC1_L_r_trial)
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(135/255, 206/255, 250/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = "L NPC Decoded Accuracy", ylab = "Numerosity Precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(30/255, 144/255, 255/255, 0.9))
axis(side=1,at=seq(round(min(df1$x),1),round(max(df1$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(round(min(df1$y),0),round(max(df1$y),0),1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(30/255, 144/255, 255/255, 0.3), border = NA)
cor.test(df1$x,df1$y)

text(0.15,2,"r = 0.343, p = 0.006", cex= 1.8)
#text(0.3,2,"r = 0.201, p = 0.11", cex= 1.8)

### 2.5 SYMBOLIC NUMBERS - NPC1 RIGHT
df1 <- data.frame(y = riskcomp$mag_prec3, x = (1/riskcomp$NPC1_R_sd_trial))
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(0/255, 255/255, 0/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = expression("R NPC"~1/sigma), ylab = "Numerosity Precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(50/255, 205/255, 50/2555, 0.9))
axis(side=1,at=seq(round(min(df1$x),1),round(max(df1$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(round(min(df1$y),0),round(max(df1$y),0),1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(50/255, 205/255, 50/2555, 0.3), border = NA)
cor.test(df1$x,df1$y)

text(0.6,2.0,"r = 0.469, p < 0.001", cex= 1.8)
#text(3,2,"r = -0.457, p < 0.001", cex= 1.8)
#text(1,2.0,"r = 0.182, p = 0.2", cex= 1.8)


### 2.6 COIN CLOUDS - NPC1 RIGHT
df1 <- data.frame(y = riskcomp$mag_prec3, x = (1/riskcomp$NPC1_L_sd_trial))
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(135/255, 206/255, 250/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = expression("L NPC"~1/sigma), ylab = "Numerosity Precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(30/255, 144/255, 255/255, 0.9))
axis(side=1,at=seq(round(min(df1$x),1),round(max(df1$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(round(min(df1$y),0),round(max(df1$y),0),1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(30/255, 144/255, 255/255, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(0.6,2.0,"r = 0.223, p = 0.08", cex= 1.8)
#text(2.5,2.0,"r = -0.202, p = 0.11", cex= 1.8)


#####################################################################################
####################### RUNWISE  REULTS #############################################
riskcomp <- read.csv("prec_neural_sub.csv")

par(mfrow=c(3,4))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### 2.1 SYMBOLIC NUMBERS - NPC1 RIGHT
df1 <- data.frame(y = riskcomp$mag_prec3, x = riskcomp$NPC1_R_r_run)
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(0/255, 255/255, 0/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = "R NPC Decoded Accuracy ", ylab = "Numerosity Precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(50/255, 205/255, 50/2555, 0.9))
axis(side=1,at=seq(round(min(df1$x),1),round(max(df1$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(round(min(df1$y),0),round(max(df1$y),0),1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(50/255, 205/255, 50/2555, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(0.25,2,"r = 0.467, p < 0.001", cex= 1.8) ## RUN

### 2.3 SYMBOLIC NUMBERS - NPC1 LEFT
df1 <- data.frame(y = riskcomp$mag_prec3, x = riskcomp$NPC1_L_r_run)
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(135/255, 206/255, 250/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = "L NPC Decoded Accuracy", ylab = "Numerosity Precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(30/255, 144/255, 255/255, 0.9))
axis(side=1,at=seq(round(min(df1$x),1),round(max(df1$x),1),0.1), cex.axis = 2)
axis(side=2,at=seq(round(min(df1$y),0),round(max(df1$y),0),1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(30/255, 144/255, 255/255, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(0.3,2,"r = 0.201, p = 0.11", cex= 1.8)

### 2.1 SYMBOLIC NUMBERS - NPC1 RIGHT
df1 <- data.frame(y = riskcomp$mag_prec3, x = riskcomp$NPC1_R_sd_trial)
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(0/255, 255/255, 0/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = expression("R NPC"~sigma), ylab = "Numerosity Precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(50/255, 205/255, 50/2555, 0.9))
axis(side=1,at=seq(0,round(max(df1$x),0),1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df1$y),1),1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(50/255, 205/255, 50/2555, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(3,2,"r = -0.457, p < 0.001", cex= 1.8)

### 2.3 SYMBOLIC NUMBERS - NPC1 LEFT
df1 <- data.frame(y = riskcomp$mag_prec3, x = riskcomp$NPC1_L_sd_trial)
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(135/255, 206/255, 250/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = expression("L NPC"~sigma), ylab = "Numerosity Precision", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(30/255, 144/255, 255/255, 0.9))
axis(side=1,at=seq(0,round(max(df1$x),0),1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df1$y),1),1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(30/255, 144/255, 255/255, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(2.5,2,"r = -0.202, p = 0.11", cex= 1.8)

### 2.1 SYMBOLIC NUMBERS - NPC1 RIGHT
df1 <- data.frame(y = riskcomp$mag_noise3, x = riskcomp$NPC1_R_sd_trial)
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(0/255, 255/255, 0/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = expression("R NPC"~sigma), ylab = "Numerosity Noise", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(50/255, 205/255, 50/2555, 0.9))
axis(side=1,at=seq(0,round(max(df1$x),0),1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df1$y),1),0.1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(50/255, 205/255, 50/2555, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(3,0.35,"r = 0.420, p < 0.001", cex= 1.8) ## RUN

### 2.3 SYMBOLIC NUMBERS - NPC1 LEFT
df1 <- data.frame(y = riskcomp$mag_noise3, x = riskcomp$NPC1_L_sd_trial)
df1 <- df1[complete.cases(df1), ]
mod1 <- (lm(y ~ x, data = df1))
newx1 <- seq(min(df1$x), max(df1$x), length.out = 100000)
preds1 <- predict(mod1, newdata = data.frame(x=newx1),interval='confidence')

plot(df1$x, df1$y, col =rgb(135/255, 206/255, 250/255, 0.8), pch = 16, cex.main = 2.7, cex = 2.5, cex.lab = 2, cex.axis = 1.7, 
     main = "",xlab = expression("L NPC"~sigma), ylab = "Numerosity Noise", xlim = c(min(df1$x),max(df1$x)), ylim = c(min(df1$y),max(df1$y)), axes = F)
abline(mod1, lwd = 5, col = rgb(30/255, 144/255, 255/255, 0.9))
axis(side=1,at=seq(0,round(max(df1$x),0),1), cex.axis = 2)
axis(side=2,at=seq(0,round(max(df1$y),1),0.1), cex.axis = 2)
polygon(c(rev(newx1), newx1), c(rev(preds1[ ,3]), preds1[ ,2]), col = rgb(30/255, 144/255, 255/255, 0.3), border = NA)
cor.test(df1$x,df1$y)
text(2.5,0.35,"r = 0.145, p = 0.25", cex= 1.8)


############################################################################################################################
############################################################################################################################

### FIG 1.5
crra_log_sym  <- 9585.312
crra_prob_sym <- 9777.091
cpt_log_sym   <- 9478.338
cpt_prob_sym  <- 9614.668
sal_log_sym   <- 9141.302
sal_prob_sym  <- 9413.497
rprec_sym     <- 9093.884

#cpt_log_sym   <- 9628.886/1000
#cpt_prob_sym  <- 9773.472/1000

model1_1 <- rprec_sym - crra_log_sym
model1_2 <- rprec_sym - crra_prob_sym
model1_3 <- rprec_sym - cpt_log_sym
model1_4 <- rprec_sym - cpt_prob_sym
model1_5 <- rprec_sym - sal_log_sym
model1_6 <- rprec_sym - sal_prob_sym

crra_log_coins  <- 11779.18
crra_prob_coins <- 11897.82
cpt_log_coins   <-  11801.4
cpt_prob_coins  <- 11868.11
sal_log_coins   <- 11972.14
sal_prob_coins  <- 12178.78
rprec_coins     <- 11307.54

#cpt_log_coins   <- 11825.51/1000
#cpt_prob_coins  <- 11906.39/1000
 
model2_1 <- rprec_coins - crra_log_coins
model2_2 <- rprec_coins - crra_prob_coins
model2_3 <- rprec_coins - cpt_log_coins
model2_4 <- rprec_coins - cpt_prob_coins
model2_5 <- rprec_coins - sal_log_coins
model2_6 <- rprec_coins - sal_prob_coins
 
  
################################## 
#crra_log_symcoin  <- 22377.3/1000
#crra_prob_symcoin <- 22708.84/1000
#cpt_log_symcoin   <- 22303.58/1000
#cpt_prob_symcoin  <- 22588.99/1000
#sal_log_symcoin   <- 22351.39/1000
#sal_prob_symcoin  <- 22896.25/1000
#rprec_symcoin     <- 21252.96/1000

##cpt_log_symcoin   <- 22417.67/1000
##cpt_prob_symcoin  <- 22713.18/1000
##sal_log_symcoin   <- 23283.8/1000
##sal_prob_symcoin  <- 23835.94/1000

#dic1 <- c(crra_log_sym, crra_prob_sym, cpt_log_sym, cpt_prob_sym,sal_log_sym,sal_prob_sym,rprec_sym)
#dic2 <- c(crra_log_coins, crra_prob_coins, cpt_log_coins, cpt_prob_coins,sal_log_coins,sal_prob_coins,rprec_coins)
#dic3 <- c(crra_log_symcoin, crra_prob_symcoin, cpt_log_symcoin, cpt_prob_symcoin,sal_log_symcoin,sal_prob_symcoin,rprec_symcoin)

dic2 <- c(model1_1, model1_2, model1_3, model1_4, model1_5, model1_6)
dic3 <- c(model2_1, model2_2, model2_3, model2_4, model2_5, model2_6)

par(mfrow=c(2,2))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### COLORS - PURPLES
rgb1 = brewer.pal(9, "RdPu")[3]
rgb2 = brewer.pal(9, "RdPu")[4]
rgb3 = brewer.pal(9, "RdPu")[5]
rgb4 = brewer.pal(9, "RdPu")[6]
rgb5 = brewer.pal(9, "RdPu")[7]
rgb6 = brewer.pal(9, "RdPu")[8]
rgb7 = brewer.pal(9, "RdPu")[9]

### COLORS - BLUES
rgb2_1 = brewer.pal(9, "Blues")[3]
rgb2_2 = brewer.pal(9, "Blues")[4]
rgb2_3 = brewer.pal(9, "Blues")[5]
rgb2_4 = brewer.pal(9, "Blues")[6]
rgb2_5 = brewer.pal(9, "Blues")[7]
rgb2_6 = brewer.pal(9, "Blues")[8]
rgb2_7 = brewer.pal(9, "Blues")[9]

### COLORS - ORANGE
rgb3_1 = brewer.pal(9, "Oranges")[3]
rgb3_2 = brewer.pal(9, "Oranges")[4]
rgb3_3 = brewer.pal(9, "Oranges")[5]
rgb3_4 = brewer.pal(9, "Oranges")[6]
rgb3_5 = brewer.pal(9, "Oranges")[7]
rgb3_6 = brewer.pal(9, "Oranges")[8]
rgb3_7 = brewer.pal(9, "Oranges")[9]

### RISKY CHOICE - SYMBOL
barplot(dic3, ylim = c(-900,0), names.arg = c("1","2","1","2","1","2"), border =c("black"), col =c(rgb3_1, rgb3_2, rgb3_3,rgb3_4,rgb3_5, rgb3_6), main = "Nonsymbolic",beside = TRUE, xpd = FALSE, cex.lab = 2.0, cex.names = 2.5, cex.main = 3.5, ylab = "IC Difference", cex.axis = 2.0, axes = F)     
axis(side=2,at=seq(-900,0,300),cex.axis = 2)

### RISKY CHOICE - COINS
barplot(dic2, ylim = c(-900,0), names.arg = c("1","2","1","2","1","2"), border =c("black"), col =c(rgb1, rgb2, rgb3,rgb4,rgb5, rgb6), main = "Symbolic",beside = TRUE, xpd = FALSE, cex.lab = 2.0, cex.names = 2.5, cex.main = 3.5, ylab = "IC Difference", cex.axis = 2.0, axes = F)  
axis(side=2,at=seq(-900,0,300), cex.axis = 2)



#### MAGNITUDE COMPARISON     
#barplot(dic1, ylim = c(9,10), names.arg = c("1","2","1","2","1","2",""), border =c(rgb2_1, rgb2_2, rgb2_3,rgb2_4,rgb2_5, rgb2_6, rgb2_7), col =c(rgb2_1, rgb2_2, rgb2_3,rgb2_4,rgb2_5, rgb2_6, rgb2_7), main = "",beside = TRUE, xpd = FALSE, cex.lab = 2.0, cex.names = 2.5, cex.main = 3, ylab = "in Thousands", cex.axis = 2.0, axes = F)     
#axis(side=2,at=seq(9,10,0.5), cex.axis = 2)



######################################################################################
### Correlation Matrix

NPC_R_r_trial <- riskcomp$NPC1_R_r_trial
NPC_L_r_trial <- riskcomp$NPC1_L_r_trial
NPC_R_r_run <- riskcomp$NPC1_R_r_run
NPC_L_r_run <- riskcomp$NPC1_L_r_run
NPC_R_sd_trial <- riskcomp$NPC1_R_sd_trial
NPC_L_sd_trial <- riskcomp$NPC1_L_sd_trial
NPC_R_prec_trial <- 1/riskcomp$NPC1_R_sd_trial
NPC_L_prec_trial <- 1/riskcomp$NPC1_L_sd_trial

dat_neural = data.frame(NPC_R_r_trial,NPC_L_r_trial,NPC_R_r_run,NPC_L_r_run,
                        NPC_R_sd_trial,NPC_L_sd_trial,NPC_R_prec_trial,NPC_L_prec_trial)

round(cor(dat_neural),2)


require(ggpubr)
require(tidyverse)
require(Hmisc)
require(corrplot)
require(RColorBrewer)

#col <- colorRampPalette(c("darkorange", "white", "steelblue"))(10)
col <- brewer.pal(n=8, name="GnBu")
M <- cor(dat_neural)
colnames(M) <- c("R NPC r (t)","L NPC r (t)","R NPC r (r)","L NPC r (r)",
                 "R NPC s (t)","L NPC s (t)","R NPC 1/s (t)","L NPC 1/s (t)")
rownames(M) <- c("R NPC r (t)","L NPC r (t)","R NPC r (r)","L NPC r (r)",
                 "R NPC s (t)","L NPC s (t)","R NPC 1/s (t)","L NPC 1/s (t)")

corrplot(M, type = "upper", method = "color", col = col,
         addCoef.col = "black", # Add coefficient of correlation
         number.cex = 2, tl.cex = 1.5, cl.cex = 1.5,
         tl.col = "darkblue", tl.srt = 50, diag = FALSE)



################################################################################



load("rprec_magAgg.RData")

magAgg= rbind(rprec_magAgg$mcmc[[1]], rprec_magAgg$mcmc[[2]], rprec_magAgg$mcmc[[3]])

prec_mag <- magAgg[,"noise.mu"]        ### PRECISION FOR SYMBOLIC NUMBERS

mag_intercept <- magAgg[,"sigma.mu"]        ### Intercept for symbolic numbers

#rnp_mag <- exp(-mag_intercept/prec_mag)
ip_mag  <- exp(mag_intercept/prec_mag)



mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0))

layout.matrix <-  matrix(c(1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,8,8), nrow = 6)
layout.matrix <- t(layout.matrix)

layout(layout.matrix,
       heights = c(1,1), # Heights of the two rows
       widths = c(1,1)) # Widths of the two columns
layout.show(8)

################################################################
plot(density(mag_intercept), xlim = c(-1,0.5), ylim = c(0,4), lwd = 5, main = "Perceptual", 
     ylab = "Density", xlab = "Intercept", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(221/255, 52/255 , 151/255, 0.9), axes = F)
axis(side=1,at=seq(-1,0.5,0.5), cex.axis = 2)
axis(side=2,at=seq(0,4,2), cex.axis = 2)
polygon(density(mag_intercept), col =rgb(221/255, 52/255 , 151/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9) )
hdi1 = HDIofMCMC(mag_intercept , credMass=0.95)
x1 <- min(which(density(mag_intercept)$x >= hdi1[1] ))  
x2 <- max(which(density(mag_intercept)$x <  hdi1[2]))
with(density(mag_intercept), polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=rgb(253/255, 224/255 , 221/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9)))
abline(v=0, lty=3, col="black", lwd=4)

################################################################################
##### INTERCEPT
plot(density(risk_sym_intercept), xlim = c(-1,4), ylim = c(0,4), lwd = 5, main = "", 
     ylab = "Density", xlab = "Intercept", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
lines(density(risk_coin_intercept), col = rgb(252/255, 141/255, 89/255, 0.9), lwd = 5)
axis(side=1,at=seq(-2,4,1), cex.axis = 2)
axis(side=2,at=seq(-2,4,2), cex.axis = 2)
polygon(density(risk_sym_intercept), col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
polygon(density(risk_coin_intercept), col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
legend(0.5,4.1, c("Symbolic","Non-symbolic"), col = c( rgb(55/255, 135/255, 192/255, 0.9),rgb(252/255, 141/255, 89/255, 0.9)),box.lty=0,cex=1.3, pch = c(1,1),pt.cex = 1.4, pt.lwd = 8, bty="n")
abline(v=0, lty=3, col="black", lwd=4)

### POST HOC TEST - INTERCEPT
plot(density(risk_sym_intercept - risk_coin_intercept), xlim = c(-0.4,1), ylim = c(0,5), lwd = 5, main = "", 
     ylab = "Density", xlab = "Intercept Post-hoc test", cex.main = 3, cex.lab =2, cex.axis = 2.4,
     col = rgb(221/255, 52/255 , 151/255, 0.9), axes = F)
polygon(density(risk_sym_intercept - risk_coin_intercept), col =rgb(221/255, 52/255 , 151/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9) )
axis(side=1,at=seq(-0.4,1.2,0.1), cex.axis = 2)
axis(side=2,at=seq(0,5,1), cex.axis = 2)
hdi1 = HDIofMCMC((risk_sym_intercept - risk_coin_intercept) , credMass=0.95)
x1 <- min(which(density(risk_sym_intercept - risk_coin_intercept)$x >= hdi1[1] ))  
x2 <- max(which(density(risk_sym_intercept - risk_coin_intercept)$x <  hdi1[2]))
with(density(risk_sym_intercept - risk_coin_intercept), polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=rgb(253/255, 224/255 , 221/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9)))
abline(v=0, lty=3, col="black", lwd=4)


################################################################
plot(density(ip_mag), xlim = c(0,1.5), ylim = c(0,10), lwd = 5, main = "", 
     ylab = "Density", xlab = "Indifference point", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(221/255, 52/255 , 151/255, 0.9), axes = F)
axis(side=1,at=seq(0,1.5,0.5), cex.axis = 2)
axis(side=2,at=seq(0,10,2), cex.axis = 2)
polygon(density(ip_mag), col =rgb(221/255, 52/255 , 151/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9) )
hdi1 = HDIofMCMC(ip_mag , credMass=0.95)
x1 <- min(which(density(ip_mag)$x >= hdi1[1] ))  
x2 <- max(which(density(ip_mag)$x <  hdi1[2]))
with(density(ip_mag), polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=rgb(253/255, 224/255 , 221/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9)))
abline(v=(1), lty=3, col="black", lwd=4)

##### INDIFFERENCE POINT
plot(r_sym_ip, xlim = c(1,4), ylim = c(0,4), lwd = 5, main = "", 
     ylab = "Density", xlab = "Indifference point", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
lines(r_coin_ip, col = rgb(252/255, 141/255, 89/255, 0.9), lwd = 5)
axis(side=1,at=seq(0,4,1), cex.axis = 2)
axis(side=2,at=seq(0,4,2), cex.axis = 2)
polygon(r_sym_ip, col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
polygon(r_coin_ip, col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
legend(2.5,4.1, c("Symbolic","Non-symbolic"), col = c( rgb(55/255, 135/255, 192/255, 0.9),rgb(252/255, 141/255, 89/255, 0.9)),box.lty=0,cex=1.3, pch = c(1,1),pt.cex = 1.4, pt.lwd = 8, bty="n")
abline(v=(1/0.55), lty=3, col="black", lwd=4)

### POST HOC TEST - RISK NEUTRAL PROBABILITY
plot(r_ip_diff, xlim = c(-0.6,0.2), ylim = c(0,5), lwd = 5, main = "", 
     ylab = "Density", xlab = "Indifference point post-hoc test", cex.main = 3, cex.lab =2, cex.axis = 2.4,
     col = rgb(221/255, 52/255 , 151/255, 0.9), axes = F)
polygon(r_ip_diff, col =rgb(221/255, 52/255 , 151/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9) )
axis(side=1,at=seq(-0.8,0.2,0.1), cex.axis = 2)
axis(side=2,at=seq(0,5,1), cex.axis = 2)
hdi1 = HDIofMCMC(ip_sym - ip_coin , credMass=0.95)
x1 <- min(which(r_ip_diff$x >= hdi1[1] ))  
x2 <- max(which(r_ip_diff$x <  hdi1[2]))
with(r_ip_diff, polygon(x=c(x[c(x1,x1:x2,x2)]), y= c(0, y[x1:x2], 0), col=rgb(253/255, 224/255 , 221/255, 0.9), border = rgb(221/255, 52/255 , 151/255, 0.9)))
abline(v=0, lty=3, col="black", lwd=4)

### Check for Outliers in SYMBOLS


riskcomp <- read.csv("riskPrecision_data_new2.csv")

noise_outlier2 <- boxplot.stats (riskcomp$ip_coin, coef = 7)$out
print(noise_outlier2)

### Remove Outliers 
#riskcomp <- riskcomp[-which(riskcomp$mag_noise1 %in% noise_outlier1),]
riskcomp <- riskcomp[-which(riskcomp$ip_coin %in% noise_outlier2),]

df0 <- data.frame(y = riskcomp$ip_sym, x = riskcomp$ip_coin)
mod0 <- (lm(y ~ x, data = df0))
newx0 <- seq(min(df0$x), max(df0$x), length.out = 100000)
preds0 <- predict(mod0, newdata = data.frame(x=newx0),interval='confidence')
plot(df0$x, df0$y, col = rgb(247/255, 104/255 , 161/255, 0.9), pch = 16, cex.main = 3, cex = 3, cex.lab = 2.4, cex.axis = 2.0, 
     main = "Indifference point",xlab = "Symbolic", ylab = "Non-symbolic", xlim = c(min(df0$x),max(df0$x)), ylim = c(min(df0$y),max(df0$y)), axes = F)
axis(side=1,at=seq(round(min(0),0),round(max(df0$x),0),1), cex.axis = 2)
axis(side=2,at=seq(round(min(df0$y),0),round(max(df0$y),0),1), cex.axis = 2)
abline(mod0, lwd = 5, col = rgb(221/255, 52/255 , 151/255, 0.9))
polygon(c(rev(newx0), newx0), c(rev(preds0[ ,3]), preds0[ ,2]), col = rgb(221/255, 52/255 , 151/255, 0.3), border = NA)
cor.test(df0$x,df0$y)
text(5,2.5,"r = 0.703 p < 0.001", cex= 2)

##################################################################################
##################################################################################


#####################################


#,rgb(55/255, 135/255, 192/255, 0.9)

par(mfrow=c(2,2))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### 2.4 COINS
df4 <- data.frame(x = (riskcomp$npc_int_r), y = (riskcomp$rnp_dot))
mod4 <- (lm((y) ~ log(x), data = df4))
newx4 <- (seq(min(df4$x), max(df4$x), length.out = 100000))
preds4 <- predict(mod4, newdata = data.frame(x=newx4),interval='confidence')

### SYMBOLIC
df3 <- data.frame(x = (riskcomp$npc_int_r), y = (riskcomp$rnp_sym))
mod3 <- (lm(y ~ log(x), data = df3))
newx3 <- seq(min(df3$x), max(df3$x), length.out = 100000)
preds3 <- predict(mod3, newdata = data.frame(x=newx3),interval='confidence')

plot(df3$x, df3$y, log = "x", col = rgb(107/255, 174/255, 214/255, 0.5), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "", ylab = "Risk-neutral probability", xlim = c(min(df3$x),max(df3$x)), ylim = c(min(df3$y),max(df3$y)), axes = F)

points(df4$x, df4$y,  col = rgb(253/255, 195/255, 140/255, 0.5), pch = 19, cex = 2.5, lty = 3)

lines(df4$x, 0.48832  + 0.05304*log(df4$x), lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx4), newx4), c(rev(preds4[ ,3]), preds4[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

lines(df3$x, 0.4681 + 0.0170*log(df3$x), lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx3), newx3), c(rev(preds3[ ,3]), preds3[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)


axis(side=1,at=c(0.05,0.1,0.2,0.4), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)

cor.test(log(df4$x),(df4$y))
cor.test(log(df3$x),(df3$y))

legend(0.2,0.2, legend=c("r = 0.244*", "r = 0.079"), bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.7,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 0.9),rgb(55/255, 135/255, 192/255, 0.9)), cex = 2.5)


###########################################################################################################
###########################################################################################################

### 2.4 COINS
df4 <- data.frame(x = (riskcomp$npc_slp_r), y = (riskcomp$rnp_dot))
mod4 <- (lm((y) ~ (x), data = df4))
newx4 <- (seq(min(df4$x), max(df4$x), length.out = 100000))
preds4 <- predict(mod4, newdata = data.frame(x=newx4),interval='confidence')

### SYMBOLIC
df3 <- data.frame(x = (riskcomp$npc_slp_r), y = (riskcomp$rnp_sym))
mod3 <- (lm(y ~ (x), data = df3))
newx3 <- seq(min(df3$x), max(df3$x), length.out = 100000)
preds3 <- predict(mod3, newdata = data.frame(x=newx3),interval='confidence')

plot(df3$x, df3$y, col = rgb(107/255, 174/255, 214/255, 0.5), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "", ylab = "Risk-neutral probability", xlim = c(min(df3$x),max(df3$x)), ylim = c(min(df3$y),max(df3$y)), axes = F)

points(df4$x, df4$y,  col = rgb(253/255, 195/255, 140/255, 0.5), pch = 19, cex = 2.5, lty = 3)

lines(df4$x, 0.4245  -0.3219*(df4$x), lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx4), newx4), c(rev(preds4[ ,3]), preds4[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

lines(df3$x, 0.4550 -0.1928*(df3$x), lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx3), newx3), c(rev(preds3[ ,3]), preds3[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)


axis(side=1,at=c(0,0.1,0.2,0.3,0.4), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)

cor.test((df4$x),(df4$y))
cor.test((df3$x),(df3$y))

legend(0.3,0.2, legend=c("r = -0.224*", "r = -0.136"), bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.7,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 0.9),rgb(55/255, 135/255, 192/255, 0.9)), cex = 2.5)



##################################################################################
##################################################################################


#####################################


par(mfrow=c(2,2))
mar.default <- c(5,3,3,3) + 0.1
par(mar = mar.default + c(0, 3, 2, 0)) 

### 2.4 COINS
df4 <- data.frame(x = (riskcomp$npc_int_r), y = (riskcomp$rnp_dot))
mod4 <- (lm((y) ~ log(x), data = df4))
newx4 <- (seq(min(df4$x), max(df4$x), length.out = 100000))
preds4 <- predict(mod4, newdata = data.frame(x=newx4),interval='confidence')

### SYMBOLIC
df3 <- data.frame(x = (riskcomp$npc_int_r), y = (riskcomp$rnp_sym))
mod3 <- (lm(y ~ log(x), data = df3))
newx3 <- seq(min(df3$x), max(df3$x), length.out = 100000)
preds3 <- predict(mod3, newdata = data.frame(x=newx3),interval='confidence')

plot(df3$x, df3$y, log = "x", col = rgb(107/255, 174/255, 214/255, 0.5), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "", ylab = "Risk-neutral probability", xlim = c(min(df3$x),max(df3$x)), ylim = c(min(df3$y),max(df3$y)), axes = F)

points(df4$x, df4$y,  col = rgb(253/255, 195/255, 140/255, 0.5), pch = 19, cex = 2.5, lty = 3)

lines(df4$x, 0.48832  + 0.05304*log(df4$x), lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx4), newx4), c(rev(preds4[ ,3]), preds4[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

lines(df3$x, 0.4681 + 0.0170*log(df3$x), lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx3), newx3), c(rev(preds3[ ,3]), preds3[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)


axis(side=1,at=c(0.05,0.1,0.2,0.4), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)

cor.test(log(df4$x),(df4$y))
cor.test(log(df3$x),(df3$y))

legend(0.2,0.2, legend=c("r = 0.244*", "r = 0.079"), bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.7,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 0.9),rgb(55/255, 135/255, 192/255, 0.9)), cex = 2.5)


### 2.4 COINS
df4 <- data.frame(x = (riskcomp$npc_slp_r), y = (riskcomp$rnp_dot))
mod4 <- (lm((y) ~ (x), data = df4))
newx4 <- (seq(min(df4$x), max(df4$x), length.out = 100000))
preds4 <- predict(mod4, newdata = data.frame(x=newx4),interval='confidence')

### SYMBOLIC
df3 <- data.frame(x = (riskcomp$npc_slp_r), y = (riskcomp$rnp_sym))
mod3 <- (lm(y ~ (x), data = df3))
newx3 <- seq(min(df3$x), max(df3$x), length.out = 100000)
preds3 <- predict(mod3, newdata = data.frame(x=newx3),interval='confidence')

plot(df3$x, df3$y, col = rgb(107/255, 174/255, 214/255, 0.5), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "", ylab = "Risk-neutral probability", xlim = c(min(df3$x),max(df3$x)), ylim = c(min(df3$y),max(df3$y)), axes = F)

points(df4$x, df4$y,  col = rgb(253/255, 195/255, 140/255, 0.5), pch = 19, cex = 2.5, lty = 3)

lines(df4$x, 0.4245  -0.3219*(df4$x), lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx4), newx4), c(rev(preds4[ ,3]), preds4[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

lines(df3$x, 0.4550 -0.1928*(df3$x), lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx3), newx3), c(rev(preds3[ ,3]), preds3[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)


axis(side=1,at=c(0,0.1,0.2,0.3,0.4), cex.axis = 2)
axis(side=2,at=c(0,0.2,0.4,0.6,0.8), cex.axis = 2)

cor.test((df4$x),(df4$y))
cor.test((df3$x),(df3$y))

legend(0.3,0.2, legend=c("r = -0.224*", "r = -0.136"), bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.7,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 0.9),rgb(55/255, 135/255, 192/255, 0.9)), cex = 2.5)

#################################################################


#####################################


#par(mfrow=c(2,2))
#mar.default <- c(5,3,3,3) + 0.1
#par(mar = mar.default + c(0, 3, 2, 0)) 

### 2.4 COINS
df4 <- data.frame(x = (riskcomp$npc_int_r), y = (riskcomp$riskPrec_dot))
mod4 <- (lm((y) ~ log(x), data = df4))
newx4 <- (seq(min(df4$x), max(df4$x), length.out = 100000))
preds4 <- predict(mod4, newdata = data.frame(x=newx4),interval='confidence')

### SYMBOLIC
df3 <- data.frame(x = (riskcomp$npc_int_r), y = (riskcomp$riskPrec_sym))
mod3 <- (lm(y ~ log(x), data = df3))
newx3 <- seq(min(df3$x), max(df3$x), length.out = 100000)
preds3 <- predict(mod3, newdata = data.frame(x=newx3),interval='confidence')

plot(df3$x, df3$y, log = "x", col = rgb(107/255, 174/255, 214/255, 0.5), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "", ylab = "Risky payoff precision", xlim = c(min(df3$x),max(df3$x)), ylim = c(min(df3$y),max(df3$y)), axes = F)

points(df4$x, df4$y,  col = rgb(253/255, 195/255, 140/255, 0.5), pch = 19, cex = 2.5, lty = 3)

lines(df4$x, 2.9431  + 0.1533*log(df4$x), lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx4), newx4), c(rev(preds4[ ,3]), preds4[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

lines(df3$x, 4.057 + 0.212*log(df3$x), lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx3), newx3), c(rev(preds3[ ,3]), preds3[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)


axis(side=1,at=c(0.05,0.1,0.2,0.4), cex.axis = 2)
axis(side=2,at=c(0,1,2,3,4,5,6), cex.axis = 2)

cor.test(log(df4$x),(df4$y))
cor.test(log(df3$x),(df3$y))

legend(0.2,1, legend=c("r = 0.104", "r = 0.095"), bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.7,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 0.9),rgb(55/255, 135/255, 192/255, 0.9)), cex = 2.5)


### 2.4 COINS
df4 <- data.frame(x = (riskcomp$npc_slp_r), y = (riskcomp$riskPrec_dot))
mod4 <- (lm((y) ~ (x), data = df4))
newx4 <- (seq(min(df4$x), max(df4$x), length.out = 100000))
preds4 <- predict(mod4, newdata = data.frame(x=newx4),interval='confidence')

### SYMBOLIC
df3 <- data.frame(x = (riskcomp$npc_slp_r), y = (riskcomp$riskPrec_sym))
mod3 <- (lm(y ~ (x), data = df3))
newx3 <- seq(min(df3$x), max(df3$x), length.out = 100000)
preds3 <- predict(mod3, newdata = data.frame(x=newx3),interval='confidence')

plot(df3$x, df3$y, col = rgb(107/255, 174/255, 214/255, 0.5), pch = 19, cex.main = 3, cex = 2.5, cex.lab = 2, cex.axis = 2, 
     main = "",xlab = "", ylab = "Risky payoff precision", xlim = c(min(df3$x),max(df3$x)), ylim = c(min(df3$y),max(df3$y)), axes = F)

points(df4$x, df4$y,  col = rgb(253/255, 195/255, 140/255, 0.5), pch = 19, cex = 2.5, lty = 3)

lines(df4$x, 2.852  - 2.063*(df4$x), lwd = 5, col = rgb(252/255, 141/255, 89/255, 0.9))
polygon(c(rev(newx4), newx4), c(rev(preds4[ ,3]), preds4[ ,2]), col = rgb(252/255, 141/255, 89/255, 0.3), border = NA)

lines(df3$x, 3.924 - 2.767*(df3$x), lwd = 5, col = rgb(55/255, 135/255, 192/255, 0.9))
polygon(c(rev(newx3), newx3), c(rev(preds3[ ,3]), preds3[ ,2]), col = rgb(55/255, 135/255, 192/255, 0.3), border = NA)


axis(side=1,at=c(0,0.1,0.2,0.3,0.4), cex.axis = 2)
axis(side=2,at=c(0,1,2,3,4,5,6), cex.axis = 2)

cor.test((df4$x),(df4$y))
cor.test((df3$x),(df3$y))

legend(0.2,1, legend=c("r = -0.211*", "r = -0.188???"), bg="transparent", xjust = 0.5, yjust = 0.5, x.intersp = -0.5, y.intersp = 0.7,adj = c(0, 0.5), text.col =  c(rgb(252/255, 141/255, 89/255, 0.9),rgb(55/255, 135/255, 192/255, 0.9)), cex = 2.5)

#######################################################


### BAYESIAN COMPARISON
##### PRECISION
plot(density(noise_model1), xlim = c(-2,0), ylim = c(0,4), lwd = 5, main = "", 
     ylab = "Density", xlab = "Precision", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
lines(density(noise_model2), col = rgb(252/255, 141/255, 89/255, 0.9), lwd = 5)
axis(side=1,at=seq(-2,0,1), cex.axis = 2)
axis(side=2,at=seq(0,4,1), cex.axis = 2)
#polygon(density(noise_model1), col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
#polygon(density(noise_model2), col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
legend(-1.8,3, c("mean = 0.001","mean = 0"), col = c( rgb(55/255, 135/255, 192/255, 0.9),rgb(252/255, 141/255, 89/255, 0.9)),box.lty=0,cex=1.3, pch = c(1,1),pt.cex = 1.4, pt.lwd = 8, bty="n")



### BAYESIAN COMPARISON
##### PRECISION
plot(density(sigma_model1), xlim = c(-1,0), ylim = c(0,6), lwd = 5, main = "", 
     ylab = "Density", xlab = "Bias", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
lines(density(sigma_model2), col = rgb(252/255, 141/255, 89/255, 0.9), lwd = 5)
axis(side=1,at=seq(-2,0,0.5), cex.axis = 2)
axis(side=2,at=seq(0,6,1), cex.axis = 2)
#polygon(density(noise_model1), col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
#polygon(density(noise_model2), col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
legend(-0.9,3, c("mean = 0.001","mean = 0"), col = c( rgb(55/255, 135/255, 192/255, 0.9),rgb(252/255, 141/255, 89/255, 0.9)),box.lty=0,cex=1.3, pch = c(1,1),pt.cex = 1.4, pt.lwd = 8, bty="n")


### BAYESIAN COMPARISON
##### PRECISION
plot(density(noise_model1 - noise_model2), xlim = c(-1,1), ylim = c(0,4), lwd = 5, main = "", 
     ylab = "Density", xlab = "Precision", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
axis(side=1,at=seq(-1,1,1), cex.axis = 2)
axis(side=2,at=seq(0,4,1), cex.axis = 2)
#polygon(density(noise_model1), col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
#polygon(density(noise_model2), col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
abline(v=0, lty=2, col="black", lwd=3)


### BAYESIAN COMPARISON
##### PRECISION
plot(density(sigma_model1 - sigma_model2), xlim = c(-1,1), ylim = c(0,4), lwd = 5, main = "", 
     ylab = "Density", xlab = "Bias", cex.main = 3.0, cex.lab =2, cex.axis = 2.0,
     col = rgb(55/255, 135/255, 192/255, 0.9), axes = F)
axis(side=1,at=seq(-1,1,1), cex.axis = 2)
axis(side=2,at=seq(0,4,1), cex.axis = 2)
#polygon(density(noise_model1), col =rgb(55/255, 135/255, 192/255, 0.3), border = rgb(55/255, 135/255, 192/255, 0.3) )
#polygon(density(noise_model2), col =rgb(252/255, 141/255, 89/255, 0.3), border = rgb(252/255, 141/255, 89/255, 0.3) )
abline(v=0, lty=2, col="black", lwd=3)
