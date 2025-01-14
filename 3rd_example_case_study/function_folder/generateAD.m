function AD = generateAD(Horizon, number_in_a_row)

AD=zeros(size(number_in_a_row,1),Horizon);

for i=1:size(number_in_a_row,1)
    vectorSet = generateVectorSet(Horizon,number_in_a_row(i));
    nonZeroVectors = vectorSet(~cellfun('isempty', vectorSet));
    combinedVector = generateFinalVectorNonZeroWithZero(nonZeroVectors,Horizon);

    AD(i,:)=combinedVector;
end

end