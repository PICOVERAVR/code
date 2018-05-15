#include "lib_header.h"
#include "prgm_header.h"
#define MEM_SIZE (128)
#define MAX_SOURCE_SIZE (0x100000)

size_t readSrc(char *path, char *dest) {
	FILE *fp;
	size_t source_size;
	
	fp = fopen(path, "r");
	if (!fp) {
		perror("OpenCL File");
		exit(1);
	}
	source_size = fread(dest, sizeof(char), MAX_SOURCE_SIZE, fp);
	
	fclose(fp);
	return source_size;
}

int main() {
	cl_device_id device_id;
	cl_platform_id platform_id;
	cl_uint num_devices;
	cl_uint num_platforms;
	
	float mem[MEM_SIZE] = {1.0, 2.0, 3.0, 20.5};
	char *source_str = malloc(MAX_SOURCE_SIZE);
	size_t source_size = readSrc("/Users/kneil/Desktop/Tech/OpenCL_Programs/main.cl", source_str);
	
	clGetPlatformIDs(10, &platform_id, &num_platforms);
	
	clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_GPU, 1, &device_id, &num_devices);
	printf("Number of devices available: %d\n", num_devices);
	
	char deviceNameBuffer[100] = {0};
	cl_uint clkSpeed;
	cl_uint cores;
 
	clGetDeviceInfo(device_id, CL_DEVICE_NAME, sizeof(deviceNameBuffer), (void *)deviceNameBuffer, NULL);
	clGetDeviceInfo(device_id, CL_DEVICE_MAX_CLOCK_FREQUENCY, sizeof(deviceNameBuffer), &clkSpeed, NULL);
	clGetDeviceInfo(device_id, CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(deviceNameBuffer), &cores, NULL);
	printf("Using %s at %d MHz with %d cores.\n\n", deviceNameBuffer, clkSpeed, cores);
	
	cl_context context = clCreateContext(NULL, 1, &device_id, NULL, NULL, NULL);
	
	cl_command_queue command_queue = clCreateCommandQueue(context, device_id, 0, NULL);
	
	cl_mem memobj = clCreateBuffer(context, CL_MEM_READ_WRITE, MEM_SIZE * sizeof(float), NULL, NULL);
	cl_mem b = clCreateBuffer(context, CL_MEM_READ_WRITE, MEM_SIZE * sizeof(float), NULL, NULL);
	
	clEnqueueWriteBuffer(command_queue, memobj, CL_TRUE, 0, MEM_SIZE * sizeof(float), mem, 0, NULL, NULL);
	clEnqueueWriteBuffer(command_queue, b, CL_TRUE, 0, MEM_SIZE * sizeof(float), mem, 0, NULL, NULL);
	
	cl_program program = clCreateProgramWithSource(context, 1, (const char **)&source_str, (const size_t *)&source_size, NULL);
	clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);
	
	cl_kernel kernel = clCreateKernel(program, "vecAdd", NULL);
	
	clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&memobj);
	clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&b);
	
	clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, (size_t[]){MEM_SIZE, 0, 0}, (size_t[]){MEM_SIZE/16, 0, 0}, 0, NULL, NULL);
	
	clEnqueueReadBuffer(command_queue, memobj, CL_TRUE, 0, MEM_SIZE * sizeof(float), mem, 0, NULL, NULL);
	
	for (int i=0; i < 10; i++) {
		printf("%f\n", mem[i]);
	}
	
	clFlush(command_queue);
	clFinish(command_queue);
	clReleaseKernel(kernel);
	clReleaseProgram(program);
	clReleaseMemObject(memobj);
	clReleaseMemObject(b);
	clReleaseCommandQueue(command_queue);
	clReleaseContext(context);
	
	free(source_str);
 
	return 0;
}

