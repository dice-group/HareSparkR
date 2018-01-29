 library(SparkR)

sc <- sparkR.init()
#sqlContext <- sparkRSQL.init(sc)
# df <- createDataFrame(sqlContext, faithful)

createDataFrame


Path:
D:\spark\spark-2.2.0-bin-hadoop2.7\D:\spark\spark-2.2.0-bin-hadoop2.7\sbin;D:\spark\spark-2.2.0-bin-hadoop2.7\bin

C:\Users\Abdelmonem\AppData\Local\GitHubDesktop\bin

D:\spark\spark-2.2.0-bin-hadoop2.7\;D:\spark\spark-2.2.0-bin-hadoop2.7\sbin;D:\spark\spark-2.2.0-bin-hadoop2.7\bin;C:\Program Files\R\R-3.3.0\bin\x64\;C:\orant\bin;C:\ProgramData\Oracle\Java\javapath;%CPLEX_STUDIO_BINARIES1261%;c:\Rtools\bin;c:\Rtools\gcc-4.6.3\bin;E:\gurobi562\win32\bin;E:\gurobi562\win64\bin;E:\oracle\product\10.2.0\db_1\bin;E:\app\Abdelmonem\product\12.1.0\dbhome_1\bin;C:\Program Files\Common Files\Microsoft Shared\Windows Live;C:\Program Files (x86)\Common Files\Microsoft Shared\Windows Live;C:\Program Files (x86)\AMD APP\bin\x86_64;C:\Program Files (x86)\AMD APP\bin\x86;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static;C:\Program Files (x86)\Windows Live\Shared;C:\Program Files (x86)\MiKTeX 2.9\miktex\bin\;%CPLEX_STUDIO_BINARIES125%;C:\Program Files\MATLAB\R2013a\bin;C:\orant\jdk\bin;C:\Program Files\OpenVPN\bin;C:\Program Files (x86)\Skype\Phone\;C:\Program Files\Git\cmd

"C:\Program Files\R\R-3.3.0\bin\x64\Rgui.exe"

Error in handleErrors(returnStatus, conn) :
  java.lang.IllegalArgumentException: Error while instantiating 'org.apache.spark.sql.hive.HiveSessionStateBuilder':
        at org.apache.spark.sql.SparkSession$.org$apache$spark$sql$SparkSession$$instantiateSessionState(SparkSession.scala:1053)
        at org.apache.spark.sql.SparkSession$$anonfun$sessionState$2.apply(SparkSession.scala:130)
        at org.apache.spark.sql.SparkSession$$anonfun$sessionState$2.apply(SparkSession.scala:130)
        at scala.Option.getOrElse(Option.scala:121)
        at org.apache.spark.sql.SparkSession.sessionState$lzycompute(SparkSession.scala:129)
        at org.apache.spark.sql.SparkSession.sessionState(SparkSession.scala:126
)
        at org.apache.spark.sql.api.r.SQLUtils$$anonfun$setSparkContextSessionConf$2.apply(SQLUtils.scala:71)
        at org.apache.spark.sql.api.r.SQLUtils$$anonfun$setSparkContextSessionConf$2.apply(SQLUtils.scala:70)
        at scala.collection.TraversableLike$WithFilter$$anonfun$foreach$1.apply(TraversableLike.scala:733)
        at scala.collection.Iterator$class.foreach(It
		
		
		ctChannelHandlerContext.java:336)
        at io.netty.handler.timeout.IdleStateHandler.channelRead(IdleStateHandle
r.java:287)
        at io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:357)
        at io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:343)
        at io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:336)
        at io.netty.handler.codec.MessageToMessageDecoder.channelRead(MessageToMessageDecoder.java:102)
        at io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:357)
        at io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:343)
        at io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:336)
        at io.netty.handler.codec.ByteToMessageDecoder.fireChannelRead(ByteToMessageDecoder.java:293)
        at io.netty.handler.codec.ByteToMessageDecoder.channelRead(ByteToMessageDecoder.java:267)
        at io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:357)
        at io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:343)
        at io.netty.channel.AbstractChannelHandlerContext.fireChannelRead(AbstractChannelHandlerContext.java:336)
        at io.netty.channel.DefaultChannelPipeline$HeadContext.channelRead(DefaultChannelPipeline.java:1294)
        at io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:357)
        at io.netty.channel.AbstractChannelHandlerContext.invokeChannelRead(AbstractChannelHandlerContext.java:343)
        at io.netty.channel.DefaultChannelPipeline.fireChannelRead(DefaultChannelPipeline.java:911)
        at io.netty.channel.nio.AbstractNioByteChannel$NioByteUnsafe.read(AbstractNioByteChannel.java:131)
        at io.netty.channel.nio.NioEventLoop.processSelectedKey(NioEventLoop.java:643)
        at io.netty.channel.nio.NioEventLoop.processSelectedKeysOptimized(NioEventLoop.java:566)
        at io.netty.channel.nio.NioEventLoop.processSelectedKeys(NioEventLoop.java:480)
        at io.netty.channel.nio.NioEventLoop.run(NioEventLoop.java:442)
        at io.netty.util.concurrent.SingleThreadEventExecutor$2.run(SingleThreadEventExecutor.java:131)
        at io.netty.util.concurrent.DefaultThreadFactory$DefaultRunnableDecorator.run(DefaultThreadFactory.java:144)
        at java.lang.Thread.run(Unknown Source)

        at org.apache.hadoop.fs.RawLocalFileSystem$DeprecatedRawLocalFileStatus.loadPermissionInfo(RawLocalFileSystem.java:699)
        at org.apache.hadoop.fs.RawLocalFileSystem$DeprecatedRawLocalFileStatus.getPermission(RawLocalFileSystem.java:634)
        at org.apache.hadoop.hive.ql.session.SessionState.createRootHDFSDir(SessionState.java:599)
        at org.apache.hadoop.hive.ql.session.SessionState.createSessionDirs(SessionState.java:554)
        at org.apache.hadoop.hive.ql.session.SessionState.start(SessionState.java:508)
        ... 75 more
Error in handleErrors(returnStatus, conn) :
  java.lang.IllegalArgumentException: Error while instantiating 'org.apache.spark.sql.hive.HiveSessionStateBuilder':
        at org.apache.spark.sql.SparkSession$.org$apache$spark$sql$SparkSession$$instantiateSessionState(SparkSession.scala:1053)
        at org.apache.spark.sql.SparkSession$$anonfun$sessionState$2.apply(SparkSession.scala:130)
        at org.apache.spark.sql.SparkSession$$anonfun$sessionState$2.apply(SparkSession.scala:130)
        at scala.Option.getOrElse(Option.scala:121)
        at org.apache.spark.sql.SparkSession.sessionState$lzycompute(SparkSession.scala:129)
        at org.apache.spark.sql.SparkSession.sessionState(SparkSession.scala:126)
        at org.apache.spark.sql.api.r.SQLUtils$$anonfun$setSparkContextSessionConf$2.apply(SQLUtils.scala:71)
        at org.apache.spark.sql.api.r.SQLUtils$$anonfun$setSparkContextSessionConf$2.apply(SQLUtils.scala:70)
        at scala.collection.TraversableLike$WithFilter$$anonfun$foreach$1.apply(TraversableLike.scala:733)
        at scala.collection.Iterator$class.foreach(It