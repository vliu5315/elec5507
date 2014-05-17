% Given an array of tranisition probbilities and
% error rates for a code, plot them
function plot_ber(transition_prob, bers)
    % Plot transition probability vs BER
    figure
    semilogy(transition_prob, bers,'r');
    hold on
    xlabel('Transition probability (p)');
    ylabel('Bit error rate (BER)');
    semilogy(transition_prob, transition_prob);
    hold off
end