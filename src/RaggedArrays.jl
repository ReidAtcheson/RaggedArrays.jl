module RaggedArrays

export RaggedArray , getindex, setindex!, getsubarraysize, getsubarray, length, size

import Base.length
import Base.size

type RaggedArray{T} 
    data::Array{T,1};

    #To avoid unnecessary branching on corner cases:
    #offs[0] = 0
    #offs[n_columns+1] = length(data)
    offs::Array{Int64,1};
end



#Create initialized RaggedArray from regular array.
function RaggedArray{T}(A::Array{T,2})
    (m,n) = size(A);
    sizes = Array(Int64,(n,));
    sizes[:] = m;
    out = RaggedArray(T,sizes);
    out.data=copy(A[:]);

    return out;
end

#Create RaggedArray from Array{Array{T}}.
#Note: This will transpose indices, so that A[i][j] = ragged_A[j][i].
function RaggedArray{T}(A::Array{Array{T},1})
    n = length(A);
    sizes = Array(Int64,(n,));
    for i = 1 : n
        sizes[i] = length(A[i]);
    end

    ragged_A = RaggedArray(T,sizes);
    for i = 1 : n
        J = length(A[i]);
        for j = 1 : J
            ragged_A[j,i] = A[i][j];
        end
    end


    return ragged_A;
end

#Create uninitialized RaggedArray of subarrays with sizes given in 
#"sizes" array.
function RaggedArray(T::Type,sizes::Array{Int64,1})
    totallen = sum(sizes);
    J = length(sizes);
    
    #Offsets array.
    offs=Array(Int64,(J+1,));
    #Contiguous data array.
    data=Array(T,(totallen,));


    #Compute offsets.
    offs[1]=0;
    for j = 1 : J
        offs[j+1]=offs[j]+sizes[j];
    end

    return RaggedArray(data,offs);
end

#Return number of columns.
function length{T}(A::RaggedArray{T})
    return length(A.offs)-1;
end

#Return (sizes,ncols) where sizes is array of column lengths.
function size{T}(A::RaggedArray{T})
    #Compute sizes array.
    n = length(A);
    sizes = Array(Int64,(n,));
    for i = 1 : n
        sizes[i] = getsubarraysize(A,i);
    end

    return (sizes,n);
end

#Convenience 2D array getter notation.
function getindex{T}(A::RaggedArray{T},i::Int64,j::Int64)
    check2dbounds(A,i,j);
    return A.data[A.offs[j]+i];
end



#Convenience 2D array setter notation.
function setindex!{T}(A::RaggedArray{T},val::T,i::Int64,j::Int64)
    check2dbounds(A,i,j);
    A.data[A.offs[j]+i]=val;
end


#Get j-th subarray
function getsubarray{T}(A::RaggedArray{T},j::Int64)
    check1dbounds(A,j);
    return (sub(A.data,(A.offs[j]+1):(A.offs[j+1])));
end

#Get the length of subarray j of RaggedArray A.
function getsubarraysize{T}(A::RaggedArray{T},j::Int64)
    check1dbounds(A,j);
    return (A.offs[j+1]-A.offs[j]);
end


function check1dbounds{T}(A::RaggedArray{T},j::Int64)
    if(j==length(A.offs))
        throw(BoundsError());
    end
end


function check2dbounds{T}(A::RaggedArray{T},i::Int64,j::Int64)
    jcolsz = getsubarraysize(A,j);
    if i > jcolsz
        throw(BoundsError());
    end
end

end
