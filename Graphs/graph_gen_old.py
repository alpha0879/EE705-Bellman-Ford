# A denotes our directed graph
A=[[0,1,0,0,0,0,0,0,0,0,0,0,0],
   [0,0,2,0,0,0,0,0,0,0,0,0,0],
   [0,0,0,4,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,7,0,0,0,0,2,4,0,0],
   [0,0,0,0,0,8,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,3,0,0,0,0,0,0,0,0],
   [0,0,0,0,4,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,2,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,1,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0,0,6,3],
   [0,0,0,0,0,0,0,0,0,0,0,0,0],
   [0,0,0,0,0,0,0,0,0,0,0,2,0]]
l=len(A)
get_bin = lambda x, n: format(x, 'b').zfill(n)
edges=0
for j in range(l):
    for i in range(l):
        if A[i][j]!=0:
            dest=j+1
            source=i+1
            weight_edge_btw_ij=A[i][j]
            print(get_bin(weight_edge_btw_ij,4),get_bin(source,4),get_bin(dest,4),sep="")
           # print(weight_edge_btw_ij,source,dest)
            edges=edges+1

zero_rows=32-edges
for i in range(zero_rows):
	print("000000000000")

