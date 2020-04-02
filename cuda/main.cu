#include <iostream>
using namespace std;

__global__ void matmul(float* Md, float* Nd, float* outd, int width) {
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	int y = blockIdx.y * blockDim.y + threadIdx.y;
	
	float outval = 0.0;
	for (int n = 0; n < width; n++) {
		float Melem = Md[y * width + n];
		float Nelem = Nd[x + width * n];
		outval += Melem * Nelem;
	}
	outd[y * width + x] = outval;
}

void printDeviceInfo() {
    int device;
    cudaGetDevice(&device);

    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, device);
    
    int driver;
    cudaDriverGetVersion(&driver);
    
    int runtime;
    cudaRuntimeGetVersion(&runtime);
    
    cout << "GPU: " << prop.name << endl;
    cout << "Driver Version: " << driver << endl;
    cout << "Runtime Version: " << runtime << endl << endl;
}

int main(int argc, char **argv) {
	printDeviceInfo();
	
	const float A[] = {
		1.0, 0.0, 0.0, 0.0,
		0.0, 1.0, 0.0, 0.0,
		0.0, 0.0, 1.0, 0.0,
		0.0, 0.0, 0.0, 1.0,
	};

	const float B[] = {
		1.0, 0.0, 0.0, 0.0,
		0.0, 1.0, 0.0, 0.0,
		0.0, 0.0, 1.0, 0.0,
		0.0, 0.0, 0.0, 1.0,
	};
	
	float C[16] = { 0.0 };
	
	float* Ad;
	float* Bd;
	float* Cd;
	
	const unsigned int width = 4;	
	const unsigned int size = width * width * sizeof(float);
	
	cudaMalloc((void**) &Ad, size);
	cudaMalloc((void**) &Bd, size);
	cudaMalloc((void**) &Cd, size);

	cudaMemcpy(Ad, A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(Bd, B, size, cudaMemcpyHostToDevice);
	
	dim3 dimBlock(width, width, 1);
	dim3 dimGrid(1, 1, 1); // dim3 = vec3, 1 for final element because grids have to be 2D
	
	matmul<<<dimGrid, dimBlock>>>(Ad, Bd, Cd, width);
	
	cudaMemcpy(C, Cd, size, cudaMemcpyDeviceToHost);
	
	for (size_t i = 0; i < 16; i++) {
		if ((i % 4 == 0) && (i > 0)) {
			cout << endl;
		}
		cout << C[i] << " ";
	}
	cout << endl;
	
	cudaFree(Ad);
	cudaFree(Bd);
	cudaFree(Cd);
}
