module RaggedArrays

export RaggedArray, getindex, setindex!, getsubarraysize, getsubarray

type RaggedArray{T} 
    data::Array{T,1};

    #To avoid unnecessary branching on corner cases:
    #offs[0] = 0
    #offs[n_columns+1] = length(data)
    offs::Array{Int64,1};
end


function RaggedArray(T::Type,sizes::Array{Int64})
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
