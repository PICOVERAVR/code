#include <iostream>

#ifdef __APPLE__
#define GL_SILENCE_DEPRECATION // since Apple is using Metal now
#endif

#include <OpenGL/gl3.h>
#define GLFW_INCLUDE_GLCOREARB
#include <GLFW/glfw3.h>
using namespace std;

#define MAJ_VERSION 4
#define MIN_VERSION 1

int main(int argc, char **argv) {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, MAJ_VERSION);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, MIN_VERSION);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    
	GLFWwindow* window = glfwCreateWindow(1, 1, "OpenGL", NULL, NULL);
    if (window == NULL) {
        cout << "Failed to create a window..." << endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
	
    cout << "Manufacturer: " << glGetString(GL_VENDOR) << endl;
    cout << "OpenGL version: " << glGetString(GL_VERSION) << endl;
	cout << "GLSL version: " << glGetString(GL_SHADING_LANGUAGE_VERSION) << endl;
    cout << "Hardware: " << glGetString(GL_RENDERER) << "\n\n";
	
	cout << "Extensions supported: " << endl;
	int max_extensions;
	glGetIntegerv(GL_NUM_EXTENSIONS, &max_extensions);
	for (int i = 0; i < max_extensions; i++) {
		cout << glGetStringi(GL_EXTENSIONS, i) << endl;
	}
	
	glfwTerminate();
    return 0;
}
