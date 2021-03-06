library(grid)
library(ggplot2)
library(plyr)
library(reshape2)
library(gridBase)
library(gplots)
library(R.devices)


textplot2<-function(t_label,t_cex=5){
  
  plot(0,0,bty ="n", xaxt='n', ann=FALSE, yaxt='n',pch=26);
  text(x=0,y=0,labels=t_label,cex=t_cex);
}

setwd("/Users/mengli/Documents/splicingSNP_new/");
source("src/R/abv.r");
source("src/R/feature_alt.r")

wilcox.test(subset(all_data_filter,label=="HGMD"&pfam1!=0)[,"pfam1"],
            subset(all_data_filter,label=="NEUTRAL"&pfam1!=0)[,"pfam1"],
            alternative = "greater");

##prepare for panel a&b
goodFeatures<-all_data_filter[,c("label","phylop","ss_4","asa_1","disorder_2","pfam2","ptm") ];

##prepare for panel c, group features into each category
phylopDataset<-all_data_filter[,c("label","phylop")];

ssDataset<-all_data_filter[,c("label","ss_1","ss_2","ss_3","ss_4","ss_5","ss_6",
                              "ss_7","ss_8","ss_9","ss_10","ss_11","ss_12")];

asaDataset<-all_data_filter[,c("label","asa_1","asa_2","asa_3") ];
disorderDataset<-all_data_filter[,c("label","disorder_1","disorder_2",
                                    "disorder_3","disorder_4","disorder_5",
                                    "disorder_6","disorder_7","disorder_8",
                                    "disorder_9","disorder_10",
                                    "disorder_11","disorder_12")];

pfamDataset<-all_data_filter[,c("label","pfam1","pfam2")];

ptmDataset<-all_data_filter[,c("label","ptm")];

features<-list();features_ks<-list();
features[["phylop"]]<-phylopDataset;features[["ss"]]<-ssDataset;
features[["asa"]]<-asaDataset;features[["disorder"]]<-disorderDataset;
features[["pfam"]]<-pfamDataset;features[["ptm"]]<-ptmDataset;

#for(i in 1:length(features) ){
#  currentFeatures<-features[[i]];
#  
#  ksTestData<-data.frame(p=2:ncol(currentFeatures), d=2:ncol(currentFeatures) );
#  featureIndex<-1;
  
#  for(j in 2:ncol(currentFeatures)){
#    p<-ks.test(currentFeatures[currentFeatures[,1]=="NEUTRAL",j],
#               currentFeatures[currentFeatures[,1]=="HGMD",j])$p.value;
#    d<-ks.test(currentFeatures[currentFeatures[,1]=="NEUTRAL",j],
#               currentFeatures[currentFeatures[,1]=="HGMD",j])$statistic;
    
#    #don't make p-value< e-16
#    p<- -1*log10(p);
#    if(p>16)
#      p<-16;
    
#    ksTestData[featureIndex,]<-c( signif(p,3),signif(d,3) );
#    featureIndex<-featureIndex+1
#  }
#  features_ks[[names(features)[i]]]<-ksTestData;
#}


for(i in 1:length(features) ){
  currentFeatures<-features[[i]];
  
  ksTestData<-data.frame(p=2:ncol(currentFeatures), d=2:ncol(currentFeatures) );
  featureIndex<-1;
  
  for(j in 2:ncol(currentFeatures)){
    current_name<-names(currentFeatures)[j];
    p<-wilcox.test(currentFeatures[currentFeatures[,1]=="NEUTRAL",j],
               currentFeatures[currentFeatures[,1]=="HGMD",j],
               alternative=feature_alternative[[current_name]])$p.value;
    #d<-ks.test(currentFeatures[currentFeatures[,1]=="NEUTRAL",j],
    #           currentFeatures[currentFeatures[,1]=="HGMD",j])$statistic;
    d<-0.03;
    #don't make p-value< e-16
    p<- -1*log10(p);
    
    if(p>16)
      p<-16;
    
    p<-p+rnorm(1,0,0.2);
    
    ksTestData[featureIndex,]<-c( signif(p,3),signif(d,3) );
    featureIndex<-featureIndex+1
  }
  features_ks[[names(features)[i]]]<-ksTestData;
}

  
##the plot function
plotFigure2<-function(){
  
  cbbPalette <- c("#000000", "#AAAAAA","#000000","#E69F00", 
                  "#56B4E9", "#009E73", "#F0E442", "#0072B2",
                  "#D55E00", "#CC79A7");
  plot.new();
  
  gl <- grid.layout(nrow=4, ncol=7, heights=c(0.1,1,1,0.4), widths=c(0.6,1,1,1,1,1,1) );
  
  vp.title <- viewport(layout.pos.row=1, layout.pos.col=1:7);
  
  vp.10 <- viewport(layout.pos.row=2, layout.pos.col=1);
  vp.20 <- viewport(layout.pos.row=3, layout.pos.col=1);
  vp.30 <- viewport(layout.pos.row=4, layout.pos.col=1);
  
  t<-1;vps<-list();
  for(i in 2:4){
	  for(j in 2:7){
	  	vps[[t]]<-viewport(layout.pos.row=i, layout.pos.col=j);
		  t<-t+1;
	  }
  }
  
  pushViewport(viewport(layout=gl)  );
  
  ##plot panel labels
  pushViewport(vp.title);
  par(new=TRUE, fig=gridFIG(),mar=c(0.0,0.1,0.1,0.1));  
  textplot2("Each feature's distribution and Wilcoxon test statistic",0.7); 
  popViewport();
  
  
  pushViewport(vp.10);  
  par(new=TRUE, fig=gridFIG(),mar=c(0.2,0.2,0.1,0.1),cex=0.5);  
  textplot2("(pdf)",1); 
  text(-0.8,0,labels="a",font=2 ,cex=1);
  legend(x="bottom",legend=c("HGMD","NEUTRAL"),col=c(cbbPalette[1],cbbPalette[2]),lty=c(1,1),bt="n" );
  popViewport();
  
  
  pushViewport(vp.20);
  par(new=TRUE, fig=gridFIG(),mar=c(0.2,0.2,0.1,0.1) ); 
  textplot2("(cdf)" ,1); 
  text(-0.8,0,labels="b",font=2,cex=1 );
  popViewport();
  
  
  pushViewport(vp.30);
  par(new=TRUE, fig=gridFIG(),mar=c(0.2,0.2,0.2,0.2));  
  textplot2("(Wilcoxon)",1); 
  text(-0.8,0,labels="c",font=2,cex=1 );
  popViewport();
  
  ##selected features for each feature category
  
  #plot panel a
  for(i in 2:ncol(goodFeatures)){
    
    pushViewport(vps[[i-1]]);    
    par(new=TRUE, fig=gridFIG(),mar=c(2,2,4,1),cex=0.5);
    cat(paste(colnames(goodFeatures)[i],"\n" ,sep="") )
    densityNeutral<-density(goodFeatures[goodFeatures[,"label"]=="NEUTRAL",i],na.rm=TRUE );
    densityHGMD<-density(goodFeatures[goodFeatures[,"label"]=="HGMD",i],na.rm=TRUE );
    
    xMax<-max(c(densityNeutral$x,densityHGMD$x ) );xMin<-min(c(densityNeutral$x,densityHGMD$x));
    yMax<-max(c(densityNeutral$y,densityHGMD$y)  );yMin<-min(c(densityNeutral$y,densityHGMD$y));
    
    yMax<-yMax*(1.2);
    
    plot(densityNeutral$x,densityNeutral$y ,type="l",axes = FALSE,
         ylim=c(yMin,yMax),xlim=c(xMin,xMax),col=cbbPalette[2]);
    
    lines(densityHGMD$x,densityHGMD$y,col=cbbPalette[1]) ;
    
    axis(1,cex.axis=0.7,mgp=c(0.5,0.5,0.5));
    axis(2,cex.axis=0.7,mgp=c(0.5,0.5,0.5));
    
    #plot(density(goodFeatures[goodFeatures[,"label"]=="HGMD",i],na.rm=TRUE ) ,add=TRUE);
    axisPos<-par("usr");
    start<-(axisPos[2]-axisPos[1])/200+axisPos[1];
    #start<-axisPos[1]-(axisPos[2]-axisPos[1])/10;
    
    end<-axisPos[4]-(axisPos[4]-axisPos[3])/20;
    #text(start,end,labels=abv(colnames(goodFeatures)[i] ) ,cex=0.7,pos=4);
    #mtext(text=abv(colnames(goodFeatures)[i] ),sid=3,cex=0.7,pos=4);
    text(start,end,labels=abv(names(goodFeatures)[i] ) ,cex=0.7,pos=4);
    
    popViewport();
    
  }
  
  ##plot panel b
  for(i in 2:ncol(goodFeatures) ){
    
    pushViewport(vps[[i-1+6]]);
    par(new=TRUE, fig=gridFIG(),mar=c(2,3,1,1),cex=0.5 );
    #plot(c(1,2,3,4));
    
    plot(ecdf(goodFeatures[goodFeatures[,1]=="HGMD",i]  ) ,col=cbbPalette[1],
         pch=20,cex=0.5,axes = FALSE,main="",ylim=c(0,1.4) );
    
    plot(ecdf(goodFeatures[goodFeatures[,1]=="NEUTRAL",i]  ) ,add=TRUE ,
         col=cbbPalette[2] ,pch=20,cex=0.5 ,axes = FALSE,ylim=c(0,1.4) );
    
    axis(side=1, cex.axis=0.7, mgp=c(0.5,0.5,0.5) );
    axis(side=2, cex.axis=0.7, mgp=c(0.5,0.5,0.5) );
    
    axisPos<-par("usr");
    start<-(axisPos[2]-axisPos[1])/20+axisPos[1];
    text(start,axisPos[4]-0.25,labels=abv(names(goodFeatures)[i] ) ,cex=0.7,pos=4);
    #mtext(text=abv(names(goodFeatures)[i] ) ,cex=0.7,pos=4,side=3);
    
    popViewport();
  }
  

  #plot panel c
  for(i in 1:length(features_ks) ){
    #currentFeatures<-features[[i]];
    ksTestData<-features_ks[[i]];
    
    currentName<-names(features_ks)[i];
    currentName<- abv(currentName);
    
    pushViewport(vps[[i+6+6]]);
    
    par(new=TRUE, fig=gridFIG(), cex.lab=0.5, mar=c(3,2,1,1) );#);
    plot(ksTestData[,"p"],ksTestData[,"d"],
         axes=FALSE,xlim=c(0,16),ylim=c(0,0.1),xlab="p-value -10log10",yaxt='n',pch=4);
    #,ylim=c(0,0.5) ,ylab="d-value"  );
    
    axis(1,cex.axis=0.7,mgp=c(0.2,0.5,0.5));
    #axis(2,cex.axis=0.7,mgp=c(0.5,0.5,0.5));
    
    axisPos<-par("usr");
    start<-(axisPos[2]-axisPos[1])/20+axisPos[1];
    text(start,axisPos[4]-0.02,labels=currentName ,cex=0.7,pos=4);
    #title(xlab="p-value",ylab="d-value")
    
    popViewport();
  }
}


pdf("result/Figure-2 (evaluate each feature).pdf",width=8,height=4);
plotFigure2();
dev.off();


setEPS();
postscript("result/eps/Figure-2 (evaluate each feature).eps",width=8,height=4,fonts=c("mono") );
plotFigure2();
dev.off();

