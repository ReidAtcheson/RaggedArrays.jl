
module TestRaggedArrays

using FactCheck
using RaggedArrays 

Adata = [1.0,2.0,
         3.0,4.0,5.0,
         6.0,
         7.0,8.0,9.0,10.0];
Aoffs = [0,2,5,6,10];
A = RaggedArray(Adata,Aoffs);

facts("Testing length(A)") do
    @fact length(A) => 4;
end

facts("Testing size(A)") do
    (sizes,n) = size(A);
    @fact n => 4;
    @fact sizes => [2,3,1,4];
end

facts("Testing index getters") do
    @fact A[2,1] => 2.0
    @fact_throws A[3,1];
    @fact_throws A[5,4];
    @fact_throws A[1,10];

end

facts("Testing index setters") do
    A[2,1] = 2.5;
    @fact A[2,1] => 2.5;
    A[2,1]=2.0;

    @fact_throws A[3,1]=1.0;
    @fact_throws A[5,4]=1.0;
    @fact_throws A[1,10]=1.0;
end

facts("Testing subarray lengths") do
    @fact getsubarraysize(A,1) => 2
    @fact getsubarraysize(A,2) => 3
    @fact getsubarraysize(A,3) => 1
    @fact getsubarraysize(A,4) => 4

    @fact_throws getsubarraysize(A,5)
end


facts("Testing subarray getter") do
    @fact getsubarray(A,1)=>[1.0,2.0];
    @fact getsubarray(A,2)=>[3.0,4.0,5.0];
    @fact getsubarray(A,3)=>[6.0];
    @fact getsubarray(A,4)=>[7.0,8.0,9.0,10.0];

    @fact_throws getsubarraysize(A,5);

end


facts("Testing sizes array constructor") do
    B=RaggedArray(Float64,[2,3,1,4]);
    @fact B.offs=>A.offs
end


facts("Testing regular array constructor") do
    nrows = 53;
    ncols = 101;
    A = rand(nrows,ncols);
    B = RaggedArray(A);
    b::Bool = true;
    for r = 1 : nrows
        for c = 1 : ncols
            b = b && (A[r,c]==B[r,c]);
        end
    end


    @fact b => true;
end


end





