function E_0 = E_matrix_creat(number_in_a_row,minE,maxE)
    E_0 = zeros(length(number_in_a_row), max(number_in_a_row));
    
    for i = 1:length(number_in_a_row)
        random_numbers = minE + (maxE - minE) * rand(1, number_in_a_row(i));
        E_0(i, 1:number_in_a_row(i)) = random_numbers;
    end
end

