// HelloSpark is the right version
/* Demonstrate matrix operations:
multiply
multiply by scalar
add
transpose
*/
// ##2/2/2018 Calculating error is the bottleneck: test every second time this saves about one third
// broadcast function
package org.sparkexample;

//$example on$
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.lang.Math;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.io.PrintWriter;
import java.io.*;
import java.util.Properties;
//import log4j;
//$example off$

//import org.apache.spark.SparkConf;
import org.apache.spark.SparkContext;
import org.apache.spark.sql.SparkSession;

import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.mllib.linalg.Matrix;
import org.apache.spark.mllib.linalg.Matrices;
import org.apache.spark.mllib.linalg.Vector;
import org.apache.spark.mllib.linalg.Vectors;
import org.apache.spark.mllib.linalg.distributed.RowMatrix;
//import org.apache.spark.mllib.linalg.distributed.IndexedRowMatrix;
import org.apache.spark.mllib.linalg.distributed.BlockMatrix;
import org.apache.spark.mllib.linalg.distributed.MatrixEntry;
import org.apache.spark.mllib.linalg.distributed.CoordinateMatrix;
import org.apache.spark.api.java.function.Function;

 import org.aksw.utils.MatrixUtils;
 //import java.math.BigDecimal;
 //import org.apache.commons.math3.ml.distance.EuclideanDistance;

public class HARE_R {
public static void main(String[] args) {
System.out.println("HARE_R main");
/*
	get parameters dataset.par
	read P
	calculate d_ones
	HAARE Loop
	Save results Sn_dataset
*/
// create and load default properties
	FileInputStream in =null;
	try{
		in = new FileInputStream(args[0]);
	 }catch(FileNotFoundException ex)  
			{
				System.out.println("Can not open file for parameters");
				System.exit(1);
			};
	Properties props = new Properties();
	try{
		props.load(in);
		in.close();
	}catch(IOException ex)  
			{
				ex.printStackTrace();
			};
	double damping=Double.parseDouble(props.getProperty("damping","0.85"));
	double epsilon=Double.parseDouble(props.getProperty("epsilon","0.001"));
	int nr=Integer.parseInt(props.getProperty("nr"));
	int maxIterations=Integer.parseInt(props.getProperty("maxIterations","1000"));

		String matpath=props.getProperty("matpath");
		String dataset=props.getProperty("dataset");
		System.out.println(dataset + " " + damping + " " + epsilon + " " + nr);
		// Load matrix from csv file
		String fname= matpath + "P_" + dataset +".csv";// dfs path
		String ofname=  "Sn_" + dataset +".csv";

	SparkSession spark = SparkSession
		  .builder()
		  .appName("HARE_R")
//		  .master("local[2]")
		  .getOrCreate();
		SparkContext sc = spark.sparkContext();
		JavaSparkContext jsc = JavaSparkContext.fromSparkContext(sc);
		
		
// File f = new File(System.getProperty("user.dir")+ File.separator + "src" + File.separator + "main" + File.separator + "resources" + File.separator + "server.properties");
	double[] Sn=PageRankLoop_CM(jsc,fname,nr,epsilon,damping,maxIterations,dataset);
	System.out.println("Writing results to: "+ofname);
	try{
		PrintWriter out = new PrintWriter(new FileWriter(ofname));
		// out.println(Arrays.toString(Sn));
		for(double x:Sn) out.println(x);
		out.close();
	}catch(IOException ex)  
        {
			System.out.println("Error writing results.");
			ex.printStackTrace();
        };
}


// #################################################
public static CoordinateMatrix loadCM(JavaSparkContext jsc,String fname){
  // reads a file in format i,j,value 
JavaRDD<String> data = jsc.textFile(fname);

  JavaRDD<MatrixEntry> entries = data.map(
    new Function<String, MatrixEntry>() {
	   public MatrixEntry call(String line) throws Exception {
		 String[] a = line.split(",");
		 MatrixEntry me=new MatrixEntry(Long.parseLong(a[0]),Long.parseLong(a[1]),Double.parseDouble(a[2]));
		 
		 return me;
        }
    });
CoordinateMatrix coordMat = new CoordinateMatrix(entries.rdd());
// RowMatrix d_P_T_RM = coordMat.toRowMatrix();
return(coordMat);
}
// #################################################
public static double[] PageRankLoop_CM(JavaSparkContext jsc,String fname, int nr,double epsilon,double damping,
										int maxIterations,String ds_name){
		
// Uses MatrixUtils class to sum and multiply
	String fileName = new SimpleDateFormat("yyyyMMddHHmm'.txt'").format(new Date());
	
	PrintWriter writer=null;
	try{
		 writer = new PrintWriter(fileName);
		} catch (FileNotFoundException ex)  
        {
			System.out.println("Can not open file for logging");
        }
	writer.println("Dataset: "+ ds_name);
			
	//long startTime = System.currentTimeMillis();
	
	long tl0 = System.currentTimeMillis();
	CoordinateMatrix d_P_T_CM =loadCM(jsc, fname);// reads representing damping*P^T
	// BlockMatrix d_P_T_BM = d_P_T_CM.toBlockMatrix();
	long tl1 = System.currentTimeMillis();
	writer.println("Loading matrix took: " + (tl1 - tl0)/1000 + " seconds");
	System.out.println("Number of rows: " + d_P_T_CM.numRows());
	writer.println("Number of rows: " + d_P_T_CM.numRows());
	writer.flush();
	System.out.println("Load time:"+(tl1-tl0)/1000 +" Seconds");
// initialize
	long tic=System.currentTimeMillis();
	CoordinateMatrix ones,d_ones;
	ones=initCM(jsc,nr,1.0/nr);
	d_ones=initCM(jsc,nr,(1-damping)/nr);
	CoordinateMatrix previous=ones;

	double[] V1,V2= new double[nr];
	Arrays.fill(V2, 1.0/nr);
	long t_init=System.currentTimeMillis();
	System.out.println("Init time:"+(t_init-tl1)/1000);
	int ni=0;
	double error = 1;
	while (error > epsilon && ni < maxIterations){
		long t_iter1 = System.currentTimeMillis();
		writer.flush();
		ni = ni + 1;
		V1 = Arrays.copyOf(V2,V2.length);// copy matrix
//		previous=d_P_T_BM.multiply(previous).add(d_ones);
		previous =   MatrixUtils.coordinateMatrixMultiply(d_P_T_CM,previous);
		long t_mmul = System.currentTimeMillis();
		previous =  MatrixUtils.coordinateMatrixSum(previous,d_ones);
		long t_msum = System.currentTimeMillis();
		//V2=previous.toBlockMatrix().toLocalMatrix();
		V2= previous.transpose().toRowMatrix().rows().toJavaRDD().collect().get(0).toArray();
		long t_mc = System.currentTimeMillis();
		
		double sum=0, v_sum=0, max=0;
		int max_ind=0;
		for(int i=0; i < previous.numRows(); i++){
			sum+=(V1[i]-V2[i])*(V1[i]-V2[i]);
			v_sum+=V2[i];
			if(V2[i]> max){
				max=V2[i];
				max_ind=i;
			}
		}
		error= Math.sqrt(sum);
		long t_iter3 = System.currentTimeMillis();
		writer.println("ni:"+ ni +" vsum:" + v_sum + " error:" + error +" max_ind:" + max_ind + " max:" + max
				 + " tmul:" +  (t_mmul - t_iter1)/1000  + " tsum:" +  (t_msum - t_mmul)/1000  + 
				 " tcollect:" +  (t_mc - t_msum)/1000  );
//		 t_init=t_iter3;
	}
	long tac=System.currentTimeMillis();
	writer.println("HARE calc took " + (tac - tic)/1000 + " seconds");
	writer.println("Number of iterations:"+ ni);
	
	jsc.stop();
	writer.close();

	return(V2);
} 

// #################################################
public static double[] PageRankLoop_BM(JavaSparkContext jsc,String fname, int nr,double epsilon,double damping,
										int maxIterations,String ds_name){
		
	String fileName = new SimpleDateFormat("yyyyMMddHHmm'.txt'").format(new Date());
	
	PrintWriter writer=null;
	try{
		 writer = new PrintWriter(fileName);
		} catch (FileNotFoundException ex)  
        {
			System.out.println("Can not open file for logging");
        }
	writer.println("Dataset: "+ ds_name);
			
	//long startTime = System.currentTimeMillis();
	
	long tl0 = System.currentTimeMillis();
	CoordinateMatrix d_P_T_CM =loadCM(jsc, fname);
	BlockMatrix d_P_T_BM = d_P_T_CM.toBlockMatrix();
	long tl1 = System.currentTimeMillis();
	writer.println("Loading matrix took: " + (tl1 - tl0)/1000 + " seconds");
	//PrintRowMatrix(d_P_T_RM);
    
	System.out.println("Load time:"+(tl1-tl0)/1000 +" Seconds");

	long tic=System.currentTimeMillis();
	BlockMatrix ones,d_ones;
	ones=initBM(jsc,nr,1.0/nr);
	d_ones=initBM(jsc,nr,(1-damping)/nr);

	BlockMatrix previous=ones;
	Matrix V1,V2=previous.toLocalMatrix();
	int ni=0;
	double error = 1;
	while (error > epsilon && ni < maxIterations){
		ni = ni + 1;
		V1 = previous.toLocalMatrix();// copy matrix
		previous=d_P_T_BM.multiply(previous).add(d_ones);
		V2=previous.toLocalMatrix();
		double sum=0, v_sum=0, max=0;
		int max_ind=0;
		for(int i=0; i < previous.numRows(); i++){
			sum+=(V1.apply(i,0)-V2.apply(i,0))*(V1.apply(i,0)-V2.apply(i,0));
			v_sum+=V2.apply(i,0);
			if(V2.apply(i,0)> max){
				max=V2.apply(i,0);
				max_ind=i;
			}
		}
		error= Math.sqrt(sum);
		writer.println("ni:"+ ni +" vsum:" + v_sum + " error:" + error +" max_ind:" + max_ind + " max:" + max);
	}
	long tac=System.currentTimeMillis();
	writer.println("HARE calc took " + (tac - tic)/1000 + " seconds");
	writer.println("Number of iterations:"+ ni);
	
	jsc.stop();
	writer.close();

	return(V2.toArray());
} 

// #################################################
public static double[] PageRankLoop_RM(JavaSparkContext jsc,String fname, int nr,double epsilon,double damping,
										int maxIterations,String ds_name){
		/* problem:Rows are randomly reordered*/
		
	// send array transposed as @i,@p in R sparse matrix.
	String fileName = new SimpleDateFormat("yyyyMMddHHmm'.txt'").format(new Date());
	
	PrintWriter writer=null;
	try{
		 writer = new PrintWriter(fileName);
		} catch (FileNotFoundException ex)  
        {
			System.out.println("Can not open file for logging");
        }
	writer.println("Dataset: "+ ds_name);
			
	//long startTime = System.currentTimeMillis();
	
	long tl0 = System.currentTimeMillis();
    RowMatrix d_P_T_RM =loadCM(jsc, fname).toRowMatrix();
	// RowMatrix d_P_T_RM = coordMat.toRowMatrix();
	long tl1 = System.currentTimeMillis();
	writer.println("Loading matrix took: " + (tl1 - tl0)/1000 + " seconds");
	PrintRowMatrix(d_P_T_RM);
    
	System.out.println("Load time:"+(tl1-tl0)/1000 +" Seconds");
		long tic=System.currentTimeMillis();
	// calculate d_ones
	double[] d_ones=new double[nr];
	double[] ones=new double[nr];
	Arrays.fill(d_ones, (1-damping)/nr);
	Arrays.fill(ones, 1.0/nr);
	writer.println("d_ones: " + (1-damping)/nr);// testing
	
	Matrix previous = Matrices.dense(ones.length,1,ones);// One column vector
	Matrix d1s= Matrices.dense(d_ones.length,1,d_ones);
	int ni=0;
	double error = 1;
	while (error > epsilon && ni < maxIterations){
		ni = ni + 1;
		Matrix tmp = previous.copy();// copy matrix
		RowMatrix M1=d_P_T_RM.multiply(previous);//multiply by local matrix
		Matrix V1=RM2M(M1);  // get vector from RowMatrix
		previous = AddMat(V1,d1s);
		// error = norm(as.matrix(tmp - previous),"f")
		double sum=0;
		double v_sum=0;
		double max=0;
		int max_ind=0;
		for(int i=0; i < tmp.numRows(); i++){
			sum+=(tmp.apply(i,0)-previous.apply(i,0))*(tmp.apply(i,0)-previous.apply(i,0));
			v_sum+=previous.apply(i,0);
			if(previous.apply(i,0)> max){
				max=previous.apply(i,0);
				max_ind=i;
			}
		}
		error= Math.sqrt(sum);
		writer.println("ni:"+ ni +" vsum:" + v_sum + " error:" + error +" max_ind:" + max_ind + " max:" + max);
	}
	long tac=System.currentTimeMillis();
	writer.println("HARE calc took " + (tac - tic)/1000 + " seconds");
	writer.println("Number of iterations:"+ ni);
	
	jsc.stop();
	writer.close();

	return(previous.toArray());
} 

// #################################################
public static double[] PageRankLoop(int[] ia,int[] p,double[] x, int nr,double[] d_ones,double epsilon,double damping,
										int maxIterations,String ds_name,String sp_cores,String sp_memory){
											
	// send array transposed as @i,@p in R sparse matrix.
	String fileName = new SimpleDateFormat("yyyyMMddHHmm'.txt'").format(new Date());
	
	PrintWriter writer=null;
	try{
		 writer = new PrintWriter(fileName);
		} catch (FileNotFoundException ex)  
        {
			System.out.println("Can not open file for logging");
        }
	writer.println("Dataset: "+ ds_name);
	// "local[2]" 3g
	System.out.println("Conf:"+sp_cores+" "+sp_memory);
	// SparkConf conf = new SparkConf().setAppName("HARE").setMaster(sp_cores).set("spark.executor.memory",sp_memory);
	SparkSession spark = SparkSession
	  .builder()
	  .appName("HARE_R")
	  .master(sp_cores)//yarn-client, yarn-cluster:failed must be from spark_submit
	  // .config("executor-memory","30g")
	  // .config("driver-memory","30g")
	  // .config("spark.driver.cores",16)
	  // .config("num-executors",16)
	  // .config("executor-cores",16)
	  .config("spark.yarn.stagingDir","/user/hadoop/")
	  .getOrCreate();
	// SparkContext sc = new SparkContext(conf);
	SparkContext sc = spark.sparkContext();
	JavaSparkContext jsc = JavaSparkContext.fromSparkContext(sc);
	
			
	long startTime = System.currentTimeMillis();

	List<Vector> newList=new ArrayList<Vector>();
	// int ro=0;
	
	
	int[] ci=new int[nr];
	double[] va=new double[nr];
	for(int r=0;r < nr;r++) {
		System.arraycopy(ia,p[r],ci,0,p[r+1]-p[r]);
		System.arraycopy(x,p[r],va,0,p[r+1]-p[r]);
		int[] ciL=Arrays.copyOf(ci,p[r+1]-p[r]);
		double[] vaL=Arrays.copyOf(va,p[r+1]-p[r]);
		newList.add(Vectors.sparse(nr,ciL,vaL));

		System.out.println(" ro:" + r + " p:" + p[r]);
	}
	
	long endTime = System.currentTimeMillis();

	writer.println("Loading matrix took " + (endTime - startTime)/1000 + " seconds");

	JavaRDD<Vector> rows = jsc.parallelize(newList);
	RowMatrix d_P_T_RM = new RowMatrix(rows.rdd());
	// PrintRowMatrix(d_P_T_RM);

	
		long tic=System.currentTimeMillis();
	Matrix previous = Matrices.dense(d_ones.length,1,d_ones);// One column vector
	Matrix d1s= Matrices.dense(d_ones.length,1,d_ones);
	int ni=0;
	double error = 1;
	while (error > epsilon && ni < maxIterations){
		ni = ni + 1;
		Matrix tmp = previous.copy();// copy matrix
		RowMatrix M1=d_P_T_RM.multiply(previous);//multiply by local matrix
		Matrix V1=RM2M(M1);  // get vector from RowMatrix
		previous = AddMat(V1,d1s);
		// error = norm(as.matrix(tmp - previous),"f")
		double sum=0;
		for(int i=0; i < tmp.numRows(); i++)
			sum+=(tmp.apply(i,0)-previous.apply(i,0))*(tmp.apply(i,0)-previous.apply(i,0));
		error= Math.sqrt(sum);
		
	}
	long tac=System.currentTimeMillis();
	writer.println("HARE calc took " + (tac - tic)/1000 + " seconds");
	writer.println("Number of iterations:"+ ni);
	
	jsc.stop();
	writer.close();

	return(previous.toArray());
} 

// #################################################
public static Matrix RM2M(RowMatrix mat){//special case vector
// double[][] tmp=new double[(int)mat.numRows()][(int)mat.numCols()];
double[] tmp=new double[(int)mat.numRows()];
List<Vector> vs = mat.rows().toJavaRDD().collect();
for(int i=0; i < vs.size(); i++)
	// double[] rr=vs.get(i).toArray();
	// for(int j=0; j < mat.numCols(); j++){
		tmp[i]= vs.get(i).toArray()[0];

Matrix M=  Matrices.dense((int)mat.numRows(),(int)mat.numCols(),tmp);
return(M);
}
// #################################################
public static Matrix AddMat(Matrix m1,Matrix m2){
       Matrix tmp=m1.copy();
	   for(int i=0; i < m1.numRows();i++)
		  for(int j=0; j < m1.numCols();j++)
			tmp.update(i,j,tmp.apply(i,j)+m2.apply(i,j));
	   
	   return(tmp);
}

// ****************** ########### ****************************
public static double[] AddVec(double[] v1, double[] v2){
double[] aa = new double[v1.length];
for(int i=0; i < v1.length; i++)
	aa[i] = v1[i]+v2[i];
return (aa);
}

public static RowMatrix AddRMat(JavaSparkContext jsc, RowMatrix mat1, RowMatrix mat2){
List<Vector> newList=new ArrayList<Vector>();
List<Vector> vs1 = mat1.rows().toJavaRDD().collect();
List<Vector> vs2 = mat2.rows().toJavaRDD().collect();
for(int i=0; i < vs1.size(); i++){
	double[] vn=AddVec(vs1.get(i).toArray(),vs2.get(i).toArray());
	newList.add(Vectors.dense(vn));
}

JavaRDD<Vector> rows2 = jsc.parallelize(newList);
RowMatrix newmat = new RowMatrix(rows2.rdd());
return (newmat);
}

// ****************** ########### ****************************

public static RowMatrix transposeRM(JavaSparkContext jsc, RowMatrix mat){
List<Vector> newList=new ArrayList<Vector>();
List<Vector> vs = mat.rows().toJavaRDD().collect();
double [][] tmp=new double[(int)mat.numCols()][(int)mat.numRows()] ;

for(int i=0; i < vs.size(); i++){
	double[] rr=vs.get(i).toArray();
	for(int j=0; j < mat.numCols(); j++){
		tmp[j][i]=rr[j];
	}
}

for(int i=0; i < mat.numCols();i++)
	newList.add(Vectors.dense(tmp[i]));

JavaRDD<Vector> rows2 = jsc.parallelize(newList);
RowMatrix newmat = new RowMatrix(rows2.rdd());
return (newmat);
}

// ****************** ########### ****************************
static void PrintRowMatrix(RowMatrix mat){
   System.out.println("The Matrix:");
	List<Vector> vs = mat.rows().toJavaRDD().collect();
	for(Vector v: vs) {
		System.out.println(v);
	}
}
	

//****************** ########### ****************************
public static CoordinateMatrix initCM(JavaSparkContext jsc,long nr,double val){
	List<MatrixEntry> mle=new ArrayList<MatrixEntry>();
	System.out.println("initCM: "+nr+" val:"+val);
	for(int i=0; i<nr; i++)
		mle.add(new MatrixEntry((long)i,(long) 0,val));
	
	JavaRDD<MatrixEntry> meRDD = jsc.parallelize(mle);
	CoordinateMatrix tmp= new CoordinateMatrix(meRDD.rdd());

	return(tmp);
}
//****************** ########### ****************************
public static BlockMatrix initBM(JavaSparkContext jsc,long nr,double val){
	List<MatrixEntry> mle=new ArrayList<MatrixEntry>();
	for(int i=0; i<nr; i++)
		mle.add(new MatrixEntry((long)i,(long) 0,val));
	
	JavaRDD<MatrixEntry> meRDD = jsc.parallelize(mle);
	CoordinateMatrix tmp= new CoordinateMatrix(meRDD.rdd());
	BlockMatrix bm=tmp.toBlockMatrix();

	return(bm);
}
//****************** ########### ****************************
}