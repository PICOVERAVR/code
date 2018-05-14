CC := clang++
CFLAGS := -Wall -o OpenGL.out

SRC := main.cpp # fix this eventually please

PKGSRC := `pkg-config glfw3 --cflags`
PKGLIB := `pkg-config glfw3 --libs`

opengl: 
	@$(CC) $(PKGSRC) $(SRC) $(CFLAGS) -framework OpenGL  $(PKGLIB)
	@echo "OpenGL build completed."

clean:
	@rm -f *.out
	@rm -f *.o
