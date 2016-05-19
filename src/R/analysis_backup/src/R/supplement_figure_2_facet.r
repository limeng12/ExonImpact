library(stringr);

d_values<-c();
p_values<-c();

for(i in 2:(ncol(all_data_filter)) ){
  currentFeature<-data.frame(all_data_filter[,1],all_data_filter[,i]);
  d_value<-ks.test(currentFeature[currentFeature[,1]=="HGMD",2],currentFeature[currentFeature[,1]=="NEUTRAL",2] )$statistic;
  p_value<-ks.test(currentFeature[currentFeature[,1]=="HGMD",2],currentFeature[currentFeature[,1]=="NEUTRAL",2] )$p.value;
  d_values<-c(d_values,d_value);
  p_values<-c(p_values,p_value);
}

all_data_stat<-data.frame(name=colnames(all_data_filter)[-1],d_values=d_values,p_values=p_values );

stat_names<-str_c(all_data_stat$name,
                  " (d-value=",signif(all_data_stat$d_values,3),
                  " p-value=",signif(all_data_stat$p_values,3),")" );

all_data_filter_figure2<-all_data_filter;
colnames(all_data_filter_figure2)<-c("label",stat_names);

cbbPalette <- c("#000000", "#AAAAAA","#000000","#E69F00", 
                "#56B4E9", "#009E73", "#F0E442", "#0072B2",
                "#D55E00", "#CC79A7");

all_data_filter_melt<-melt(all_data_filter_figure2,.(label) ); 

a<-ggplot(all_data_filter_melt,mapping=aes(x=value))+
  geom_histogram(mapping=aes(fill=label,y=..density..),position="dodge")+
  xlab("feature")+theme(legend.title=element_blank())+
  theme_minimal()+theme(axis.ticks = element_blank(), axis.text.y = element_blank())+
  
  #ggtitle(paste0("AUC : ",format(aroc$auc,digits=3),"\nKS-test D-value: ",
  #               format(d_value,digits=3),"\nKS-test P-value: ",format(p_value,digits=3) ) )+
  scale_fill_manual(values=cbbPalette)+facet_wrap(~variable,ncol = 2,scales="free")+
  theme(legend.position="top" ,legend.title=element_blank(),text=element_text(size=7) )+
  ggtitle("Supplement Figure 2 Probability density of each feature")+xlab("feature");


pdf("result/Supplement Figure 2 (Distribution for each feature).pdf",width=8,height=20)
print(a);
dev.off();


setEPS();
postscript("result/eps/Supplement Figure 2 (Distribution for each feature).eps",width=8,height=35);
print(a);
dev.off();
