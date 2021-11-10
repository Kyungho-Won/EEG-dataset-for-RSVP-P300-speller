function out = detect_letter_P3speller(mdl, word_len, feature, label, letter_ind, markers_seq, params)

for n_repeat = 1:params.full_repeat
    for n_letter = 1:word_len
        
        begin_trial = length(params.seq_code) * params.full_repeat * (n_letter-1) + 1;
        end_trial = begin_trial -1 + n_repeat * length(params.seq_code);
        
        unknown_speller_code = zeros(1, length(params.seq_code));
        for j=begin_trial:end_trial
            unknown_letter = feature(j, :);
            lda_score = predictSWLDA(mdl, unknown_letter, 'score');
            unknown_speller_code( markers_seq(letter_ind(j))) = ...
                unknown_speller_code(markers_seq(letter_ind(j))) + lda_score;
        end
        
        try
            [~, row] = max(unknown_speller_code(1:6));
            [~, col] = max(unknown_speller_code(7:12));
            user_answer(n_letter) = params.spellermatrix((row-1) * 6 + col);
        catch
            warning('Opps!');
        end
        
    end
    
    acc_on_repetition(n_repeat) = sum(user_answer == label) / length(label);
    correct_on_repetition(n_repeat) = sum(user_answer == label); 
end

out.text_result = user_answer;
out.acc_on_repetition = acc_on_repetition;
out.correct_on_repetition = correct_on_repetition;

end