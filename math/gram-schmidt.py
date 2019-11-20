#!/usr/bin/env python3
import numpy

# takes in a list of (possibly) non-orthogonal vectors
# returns a list of orthogonal vectors covering the same subspace.
def gram_schmidt(blist):
	if len(blist) <= 1:
		return blist # every vector is orthogonal to itself, or there are no vectors in the list
	else:
		klist = [blist[0]]
		for i in range(1, len(blist)):
			newvec = blist[i]
			for j in range(0, i):
				newvec = newvec - (numpy.dot(blist[i], klist[j]) / numpy.dot(klist[j], klist[j])) * klist[j] # remove orthogonal component
			klist.append(newvec)
		return klist

# two test cases, both pass
#basis = [numpy.array([2, 2, 2]), numpy.array([1, 0, -1]), numpy.array([0, 3, 1])]
basis = [numpy.array([1, 1, 1]), numpy.array([0, 2, 0]), numpy.array([1, 0, 3])]

print("basis vectors: " + str(basis))
print("orthogonal vectors: " + str(gram_schmidt(basis)))
