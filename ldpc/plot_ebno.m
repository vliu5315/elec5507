% Plots coded and uncoded Eb/No given transition probabilities
% and the code rate. Formulas given in project notes
function plot_ebno(transition_prob, bers, code_rate)
    
% Determine Eb/No for coded/uncoded
    ebno_coded = 10*log10(((qfuncinv(transition_prob)).^2)/(code_rate));
    ebno = 20*log10(qfuncinv(transition_prob))

    % Plot Eb/No vs for coded/uncoded
    figure
    semilogy(ebno_coded, bers, 'r');
    hold on
    semilogy(ebno, bers);
    xlabel('Eb/No');
    ylabel('Bit Error Rate') 
    xlim([0 10])
    legend('Coded', 'Uncoded');
    hold off
end
