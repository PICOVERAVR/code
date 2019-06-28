//header file to go with this test OpenGL thing
#include <iostream>
#include <cmath>

#include <string>
#include <fstream>
#include <vector>

#include <ctime> //for seeding the random number generator
#include <cstdlib> //for random floats for testing shaders

#define GL_SILENCE_DEPRECATION // since Apple is using Metal now

#include <OpenGL/gl3.h> //for recent OpenGL calls

#define GLFW_INCLUDE_GLCOREARB
#include <GLFW/glfw3.h> //windowing manager

#define STB_IMAGE_IMPLEMENTATION //for PNG image loader
#include "stb_image.h" //header file to make an executable

#include "glm/glm.hpp"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/type_ptr.hpp"

#define SRC_SIZE 4096

using namespace std;

void processInput(GLFWwindow *window);
