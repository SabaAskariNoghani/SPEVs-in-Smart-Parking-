function Big = insertMatrix(Big, small, n)
    % Calculate the row and column indices
    min1 = size(small,1) * n - size(small,1)+1;
    max1 = size(small,1) * n;
    
    % Insert the small matrix into the large matrix
    Big(min1:max1, min1:max1) = small;
end