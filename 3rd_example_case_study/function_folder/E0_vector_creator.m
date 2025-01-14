function updatedA = E0_vector_creator(A, address, values)
    updatedA = A;
    
    for i = 1:length(values)
        start_index = address(i, 1);
        end_index = address(i, 2);
        value = values(i);
        
        if start_index < 1 || end_index > length(A)
            error('Address indices are out of bounds.');
        end
        
        updatedA(start_index:end_index) = value;
    end
end
