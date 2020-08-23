# Paper
https://www.ncbi.nlm.nih.gov/pubmed/27604408
ExonImpact: Prioritizing Pathogenic Alternative Splicing Events.

# Web Server
The website and associate databased are nolonger maintained due to the author left from CBCB an HRBEU, all the necessary code and data are list in github or in the published paper.


# ExonImpact

After downloading the source code from this site, we recommand the user integrate the source code in eclipse environment. The next step is building the required database. 
Althought the user can build the database on their own, however, we strongly recommend the users download the database from our website, rather than build it by themself. 
After this, users should open the configuration.txt file to set the path to the download database, if everything goes well, then you have installed our tools. However, although the features extraction part is code in java, but the FIS calculation part is code by R with less than 100 lines code (search 'predict.r' in the source folder). If you are familiar with R, this will be a small cake for you to do prediction. 

So in all, the install procedure include:

# Install
1.douwnload the source code from this website, and download the database from our database:  
wget http://intron-splicing-order.online/db/ensembl.db
wget http://intron-splicing-order.online/db/phylop.tar.gz
wget http://intron-splicing-order.online/db/ens_extern_hg19.bed
wget http://intron-splicing-order.online/db/chrom.tar.gz

The full dataset of phylop can be obtained from UCSC.

2.set the path in 'configuration.txt'  
Unzip the downloaded files and set the path to the download database in the configuration.txt file.  
Users need to donwload some jar libraries which will be used by the tool.  

commons-beanutils-1.9.2.jar  
commons-configuration2-2.0.jar  
commons-io-2.5.jar   
commons-lang3-3.4.jar   
igv.jar   
log4j-1.2.17.jar  
picard-1.119.jar  
sqlite-jdbc-3.8.11.2.jar  
   
The first two steps are enough for feature extracting.
 
3.check the 'predict.r' file to do FIS score calculation. 
The file is in the source folder. 

If you found this tool useful, please cite our paper and star it on the Github. We welcome anyone to improve our tool. 
<ExonImpact: Prioritizing Pathogenic Alternative Splicing Events>

Contact information yunliu@iupui.edu or limeng49631@aliyun.com.

#Some explanation

If the input is Exon_id format and the input contain first and last exon for some transcripts, the first and last exon of each transcript will be removed. ( This part of code is defined in Bed_region_extractor:85 ).

Three inputs format are accept, Inlucde:
1. bed format
2. Miso format
3. Exon Id format

The output is in the usr_input directory, although these can be changed very easily when you set up the tool. 
