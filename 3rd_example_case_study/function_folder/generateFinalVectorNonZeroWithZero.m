function finalVector = generateFinalVectorNonZeroWithZero(vectorSet,Horizon)
    % Filter out nonzero vectors from vectorSet
    nonZeroVectors = vectorSet(~cellfun('isempty', vectorSet));

    % Determine the total length of the final vector
    totalLength = sum(cellfun(@numel, nonZeroVectors));

    % Calculate the number of zeros needed to reach a total length of 24*7
    numZeros = max(0, Horizon - totalLength);

    % Initialize the final vector
    finalVector = [];

    % Add at least one zero
    finalVector = [finalVector, 0];

    % Randomly shuffle the indices for nonZeroVectors
    shuffledIndices = randperm(numel(nonZeroVectors));

    % Add nonzero vectors to the final vector
    for i = 1:numel(nonZeroVectors)
        % Get the current vector from nonZeroVectors
        currentVector = nonZeroVectors{shuffledIndices(i)};
        
        % Convert currentVector to a numeric array
        currentVector = currentVector(:).';

        % Add the current vector to the final vector
        finalVector = [finalVector, currentVector];

        % Add a zero array if there are more vectors to add
        if i < numel(nonZeroVectors)
            finalVector = [finalVector, 0];
        end
    end

    % Pad with additional zeros to make the length 24
    finalVector = [finalVector, zeros(1, numZeros)];
    
    % Ensure the final vector has a length of 24
    finalVector = finalVector(1:Horizon);
end
