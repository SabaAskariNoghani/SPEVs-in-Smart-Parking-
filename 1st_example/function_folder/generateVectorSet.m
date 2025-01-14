function vectorSet = generateVectorSet(Horizon,number_in_a_row)
    % Generate a random integer between 1 and 8
    
    % Initialize variables
    vectorSet = cell(1, number_in_a_row);
    remainingHorizon = Horizon-number_in_a_row+1;
    
    % Generate vectors while sum of lengths is less than or equal to Horizon
    for i = 1:number_in_a_row
        % Generate a random vector length between 3 and remainingHorizon
        if remainingHorizon >= 3
            vectorLength = randi([3, remainingHorizon]);
        else
            vectorLength = 3; % Minimum length of 3 if remainingHorizon is too small
        end
        
        % Create a vector of zeros with the specified length
        vectorSet{i} = ones(vectorLength, 1);
        
        % Update the remainingHorizon
        remainingHorizon = remainingHorizon - vectorLength;
        
        % Check if remainingHorizon is less than 1, break the loop
        if remainingHorizon < 1
            break;
        end
    end
end
