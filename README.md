NonuniformArray.jl
-----------
This library handles the case of "array of arrays" where each subarray may have different lengths - but enforces
contiguity of data for ease of passing to outside linear algebra packages.





Typically a 2D array will have *fixed* dimensions, for example in Julia we may write:

    A = Array(Float64,(m,n));


and it has the meaning: "Create a 2D array A of Float64s with m rows and n columns."

It could also be read to mean: 
"Create a 2D array A of Float64s with n columns, and each column has length m - while enforcing that data be contiguous
in memory."

The contiguity part is important, because one often needs to pass blocks of memory to linear algebra routines which
assumes contiguity.


Data structures such as meshes in scientific computation are often held in tabular format rather than with 
built in language features such as classes - there are many good (and bad) reasons for this, but for now
let's just take this as a given. 

This presents a challenge for complicated data structures however. Typically this is overcome by maintaining
two arrays: one array holds contiguous data, the other array tells the user how to index the first array - usually
in the form of offset values. This is an error prone process, so I have created a simple library to handle this common
situation.
