#pragma once
#include <iostream>
#include <string>
#include <fstream>

struct shader_t {
	int shader_type;
	const char* path;
};

std::string readFile(std::string path);
bool compileShaders(shader_t* shaderList);
