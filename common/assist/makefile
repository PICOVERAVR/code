CC = gcc

LIBFLAGS = -fPIC -Wall -c -O3 # generate PIC, don't run linker
LIBLINKERFLAGS = -shared -Wl,-soname,libassist.so.1 # make shared, pass -soname to linker

lib: pre
	@$(CC) $(LIBFLAGS) libassist.c
	@$(CC) $(LIBLINKERFLAGS) -o libassist.so.1.0.0 libassist.o
	@echo "Build completed."

install: lib
	@ldconfig -n ./ # configure soname and create softlink to libassist.so.1...?
	@ln -s libassist.so.1 libassist.so 	# link specific version to generic libassist.so
	@									# not strictly necessary, just good practice
	@mv libassist.so* /usr/local/lib 	# install to usr/local/lib
	@ldconfig 						 	# reload cache
	@echo "Installed in /usr/local/lib."

pre:
	@echo "Building on $(UNAME), user params: $(USER_FLAGS)"
	@echo "This only works on x64 Linux."

clean:
	@rm /usr/local/lib/libassist.so*
	@rm -f *.out
	@rm -f *.o
	
