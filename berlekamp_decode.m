function [data, decoded_data, error_locations] = ...
                    berlekamp_decode(data_to_decode)
                    
% Parameters of n = 31, k = 16, t = 3 BCH
n = 31;
t = 3;
k = 16;
m = 5; % 2^5 = 32

% GF field vars
zero = gf(0, m);
one = gf(1, m);
alpha = gf(2, m);

codeword = gf(data_to_decode, m);

% compute the syndromes
S =  codeword*(alpha.^([1:2*t]'*fliplr(0:30)))';

L = 0;
k = -1;
sigma = [one gf(zeros(1,(2*t - 1)), m)];
D = [zero one gf(zeros(1,(2*t - 2)), m)];

for n = 0:(2*t - 1)
    discrepency = fliplr(S((n-L + 1):(n + 1)))*sigma(1:(L + 1))';
    if discrepency ~= 0
        sigma_star = sigma - discrepency*D;
        if L < n - k
            L_star = n - k;
            k = n - L;
            D = sigma/discrepency;
            L = L_star;
        end
        sigma = sigma_star;
    end
    D = [zero D(1:(end-1))];
end


% Find roots of sigma
rootsOfSigma = [];
rootToTry = alpha.^(1:31);
for index = 1:length(rootToTry)
    % if sum is zero then is root
    if sigma*(rootToTry(index).^(0:(length(sigma) - 1)))' == zero
        rootsOfSigma = [rootsOfSigma index];
    end
end
degree = find(sigma ~= zero);
degree = degree(end) - 1;
error_locations = zeros(1,length(data_to_decode));
if length(rootsOfSigma) < degree
    % disp('WARNING: Cannot correct more than 3 errors')
    decoded_data = data_to_decode;
    data = decoded_data(16:end); % assuming a systematic code
    return
end
error_locations(rootsOfSigma) = ones(1,length(rootsOfSigma));
decoded_data = mod(data_to_decode + error_locations,2);
data = decoded_data(16:end); % assuming a systematic code
