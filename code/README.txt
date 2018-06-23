1. alignment.m – performs SVD to find the optimal rotation and translation to minimize distance between user chosen points
2. align_script.m – script written to align each grab of data
3. select2d.m – finds the closest point in left camera's points to the user's click measured by euclidean distance
4. mesh_all.m – creates meshes for all 7 grabs of scans
5. reconstruct_all.m – decodes all 7 scans with background masking and saves color data of good pixels
6. icp.m – attempts to close the distance between 3D triangulated points during alignment
7. nbr_error.m – finds the distance between all points and their neighbors from delaunay
8. nbr_smooth.m – moves points to the averages of its neighbors in N iterations
9. tri_error.m – finds triangles edge lengths from delaunay
10. triangulate.m – finds points that can be seen in both the left and right images and converts them into 3D space
11. decode.m – uses gray code and masking to find good pixels in the 7 grabs of scans
12. mesh2ply.m – saves the mesh data into .ply files for poisson reconstruction
