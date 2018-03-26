d:\spark\spark-2.2.0-bin-hadoop2.7\bin\spark-submit --class org.sparkexample.HARE_R --master local[2] C:\Users\Abdelmonem\Dropbox\HARE\HareSparkR\HareSparkR\Java\pca\target\pca-1.0.jar D:\RDF\mats\airports.par

Cluster
spark-submit --class org.sparkexample.HARE_R --master yarn /home/hadoop/abd/HARE/HareSparkR/HareSparkR/Java/pca/target/pca-1.0.jar /home/hadoop/abd/mat/airports.par

spark-submit --class org.sparkexample.HARE_R --master yarn --executor-memory 20g --driver-memory 20g --conf "spark.driver.cores=16" --num-executors 16 --executor-cores 16 /home/hadoop/abd/HARE/HareSparkR/HareSparkR/Java/pca/target/pca-1.0.jar /home/hadoop/abd/mat/uspto.par


Geraldo
spark-submit --master yarn --executor-memory 30g --driver-memory 30g --conf "spark.driver.cores=16" --num-executors 16 --executor-cores 16 --class org.aksw.computations.hare.Hare3 Hare-0.1.jar /geraldo/results_distributed/dbp



spark-submit --class org.sparkexample.HARE_R --master yarn --executor-memory 30g --driver-memory 30g --conf "spark.driver.cores=16" --num-executors 16 --executor-cores 16 --conf spark.network.timeout=600s /home/hadoop/abd/HARE/HareSparkR/HareSparkR/Java/pca/target/pca-1.0.jar /home/hadoop/abd/mat/lubm500fix.par

spark-submit --class org.sparkexample.HARE_R --master yarn --executor-memory 30g --driver-memory 30g --conf "spark.driver.cores=16" --num-executors 16 --executor-cores 16 --conf spark.network.timeout=100s /home/hadoop/abd/HARE/Spark/HareJ_CM.jar /home/hadoop/abd/mat/dbpedia_HARE.par

spark-submit --class org.sparkexample.HARE_R --master yarn --executor-memory 30g --driver-memory 30g --conf "spark.driver.cores=16" --num-executors 16 --executor-cores 16 --conf spark.network.timeout=100s /home/hadoop/abd/HARE/Spark/HareJ_CM.jar /home/hadoop/abd/mat/dbpedia_HARE.par

# more containers, better split of tasks, failed with dbp
--executor-memory 12g --driver-memory 8g  --num-executors 20  --executor-cores 4 --driver-cores 4 

# pagerank
spark-submit --class org.sparkexample.HARE_R --master yarn --executor-memory 30g --driver-memory 30g --conf "spark.driver.cores=16" --num-executors 16 --executor-cores 16 /home/hadoop/abd/HARE/Spark/HareJ_CM.jar /home/hadoop/abd/mat/lubm1000fix_PageRank.par


