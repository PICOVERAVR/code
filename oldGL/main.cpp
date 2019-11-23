#include "header.h"

using namespace std;

// OpenGL ES contexts this old not supported on macOS.  Try this on windows.
int main(int argc, char **argv) {
    int height = 800, width = 600;
    
    //start GLFW section for actually drawing things
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 1);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_ANY_PROFILE);
	
	glfwWindowHint(GLFW_CLIENT_API, GLFW_OPENGL_ES_API);
	
    cout << "Creating an OpenGL window..." << endl;

    //create a window object to hold all the windowing data
    GLFWwindow* window = glfwCreateWindow(height, width, "OpenGL FF ES", NULL, NULL);
    if (window == NULL) {
        cout << "Failed to create a window..." << endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    
	glViewport(0, 0, height, width); //set the rendering dimensions of the window
	
	//figure out what we're running on and what version of OpenGL is supported
    cout << "Manufacturer: " << glGetString(GL_VENDOR) << endl;
    cout << "Version: " << glGetString(GL_VERSION) << ", Shader version: " << glGetString(GL_SHADING_LANGUAGE_VERSION) << endl;
    cout << "Hardware: " << glGetString(GL_RENDERER) << "\n\n";
    
    while (!glfwWindowShouldClose(window)) {
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f); //black background
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        
        glfwSwapBuffers(window);
        glfwPollEvents();
    }
    
    glfwTerminate();
}
