CC := clang++
CFLAGS := -Wall -O3 -o OpenGL.out

SRC := main.cpp

PKGSRC := `pkg-config glfw3 --cflags`
PKGLIB := `pkg-config glfw3 --libs`

opengl: 
	@$(CC) $(PKGSRC) $(SRC) $(CFLAGS) -framework OpenGL  $(PKGLIB)
	@echo "build completed."

