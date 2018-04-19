# 19/4/2018
*Two limits on sparse matrices in R
	1- The number of rows/columns must be less than(2^31)
	2- The number of nonzeros must be less than (2^31)
The order of operations:
1-ParseNT.JAR in three iterations

2-wd_FW.R: finds P=F*W(Alpha x Alpha) in forms of chuncks (105*25M), Alpha~=479M

3-wd_FW20.R: combines(adds) each 20 chuncks together from two combined 10 chuncks.

4-wd_FW40+0.1R: combines(adds) each 40 chuncks together from two combined 20 chuncks from previous step.
			Used different sizes of chunks because the density of P differs(higher density at start)
			divide P into two parts: P1 and P2 with P1 more dense(1 - 100M, 100M+1 to end) 

5-wd_FW105p1.R: P1 into 10 chunks(10M each)

6-wd_FW105p2.R: P2(379M) in 4 chuncks (11 to 14, 100M each)

7-wd_calc_P_T.R: calculate transpose of P, into 10 chunks
				each of the 14 chunks is read to calc each chunk.

8-wd_hare.R: the matrix multiplication of P^T is done in chunks and mapped to ranges in Sn.

