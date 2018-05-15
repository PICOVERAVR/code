kernel void vecAdd(global float *a, global float *b) {
	int gid = get_global_id(0);
	a[gid] = a[gid] * b[gid];
}
