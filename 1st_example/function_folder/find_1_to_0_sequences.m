function sequences = find_1_to_0_sequences(AD)
    start_idx = 0;
    end_idx = 0;
    sequences = [];

    for i = 1:length(AD)
        if AD(i) == 1
            if start_idx == 0
                start_idx = i;
            end
        elseif AD(i) == 0 && start_idx > 0
            end_idx = i - 1;
            sequences = [sequences; start_idx end_idx];
            start_idx = 0;
        end
    end

    % Check for a sequence ending at the end of the array
    if start_idx > 0
        end_idx = length(AD);
        sequences = [sequences; start_idx end_idx];
    end
end
