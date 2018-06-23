# 3D-Model-Reconstruction

Using images captured by 2 cameras, created a 3D model of the scanned object.
Used structured light scanning to decode and triangulate points of the object.
Created meshes with those triangulated points and performed mesh cleaning by:
  1. Bounding box pruning
  2. Removing triangles with edges that are too long
  3. Removing points with neighbors that are too far away
Used meshlab to create the final mesh.
