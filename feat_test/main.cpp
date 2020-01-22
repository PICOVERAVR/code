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

	cout << endl;
	
	GLint max_texture_units;
	glGetIntegerv(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, &max_texture_units);
	cout << "Maximum texture units available: " << max_texture_units << endl;

	GLint max_tex_size;
	glGetIntegerv(GL_MAX_TEXTURE_SIZE, &max_tex_size);
	cout << "Maximum texture size: " << max_tex_size << endl;
	
	int max_compressed_formats;
	glGetIntegerv(GL_NUM_COMPRESSED_TEXTURE_FORMATS, &max_compressed_formats);
	cout << "Number of compressed texture formats: " << max_compressed_formats << endl;
	
	glfwTerminate();
    return 0;
}
