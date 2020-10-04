# spark-pointclouds
Attempt to use pyspark for point clouds processing

## Goals

- Load large point clouds (100 Gb)
- Run knn queries
- Apply tf models
- Compute diff between clouds 
- Deploy to k8s

## Tools

1. [spark3D](https://github.com/astrolabsoftware/spark3D) Apache 2 license
2. [spark-iqmulus](https://github.com/IGNF/spark-iqmulus) Apache 2 license. Pretty old code base with only Scala support

## Spark3D

Generally looks good for partition data using octree, however uses linear search
for knn queries, which is very complex for large clouds.

Possible solution using spark3D can be following:
1. Load cloud
2. Partition
3. Split whole cloud bounding box to 4x4x4 grid
4. Query each grid box and process it using UDFs as non distributed cloud

Cons:
1. Window query take approx 8s for 1M points this means that work 4x4x4 grid it takes roughly 12min
to process relatively small cloud.

## Spark.ml + LHS

Looks like exact KNN is a hard task for distributed computing. 
However ANN is already solved using different algorithms for large dimensions.
Typical solutions is to first cluster data of use locally-sensitive hashing (LSH).

Fortunately spark.ml module already has an implementation of ANN. So possible solution is
1. Load cloud
2. Partition it (?)
3. Fit on subsampled cloud
4. Use fitted model for ANN queries

## spark-iqmulus
Use very old spark version and also it can be a good idea to first convert las files to parquet files
and load it to hdfs.

## Spark Annoy

TODO

## TODOs

- [x] Provision spark for k8s
- [x] Install spark3D
- [x] Check is spark-iqmulus works for modern spark version
- [x] Load and partition large cloud
- [x] Run knn queries
- [ ] Compute clouds diff using knn or window functions
- [ ] Cloud diffs using similarityJoin and LSH
