RaggedArrays.jl
-----------
This library handles the case of "array of arrays" where each subarray may have different lengths - but enforces
contiguity of data for ease of passing to outside linear algebra packages.


Usage
======

    #Create array of subarray sizes
    sizes = [5,6,3,8,10,2];

    #Allocate uninitialized nonuniform array "NArray"
    A = RArray(Float64,sizes);

    #Set 2nd value in 3rd subarray
    A[2,3] = 1.0;

    #Whoops, error! 3rd subarray has length 3
    A[4,3] = 1.0;


		#Get 3rd subarray as indexable object:
    Asub = getsubarray(A,3);

    #But if we want to operate on NArrays using e.g. BLAS we can, because all data is contiguous.
    B = NArray(Float64,sizes);
    AdotB = dot(A.data,B.data);

    #This is useful if you have a complicated indexing 
    #of an array from say an adaptive
    #finite element computation, but at a high level 
    #want to pass these arrays to a black-box Krylov solver.
    
    






Further Reasoning
=====


Typically a 2D array will have *fixed* dimensions, for example in Julia we may write:

    A = Array(Float64,(m,n));


and it has the meaning: "Create a 2D array A of Float64s with m rows and n columns."

It could also be read to mean: 
"Create a 2D array A of Float64s with n columns, and each column has length m - while enforcing that data be contiguous
in memory."

The contiguity part is important, because one often needs to pass blocks of memory to linear algebra routines which
assume contiguity.


Data structures such as meshes in scientific computation are often held in tabular format rather than with 
built in language features such as structs - there are many good (and bad) reasons for this, but for now
let's just take this as a given. 

This presents a challenge for complicated data structures however. Typically this is overcome by maintaining
two arrays: one array holds contiguous data, the other array tells the user how to index the first array - usually
in the form of offset values. This is an error prone process, so I have created a simple library to handle this common
situation.
