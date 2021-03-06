% simulations section 1) part 8)
% Find the BER over a BCH code
pValues = 0.001:0.001:0.35;
snrValues = -5:0.001:10;
repetitions = 500;

msg = rand(length(pValues)*repetitions, 16) > 0.5;
errors = rand(length(msg), 31) < ...
        repmat(reshape(repmat(pValues,repetitions,1),1,[])',1,31);
bch_encoded = encoder(msg);

bch_decoded = matlabBCHdecode(mod(bch_encoded + errors, 2));
bitErrs = reshape((sum(mod(bch_decoded' + msg',2))/16)', repetitions, []);
BER = sum(bitErrs)/length(bitErrs); % take the average

figure()
plot(pValues, BER);
title('Plot of BER in BCH codes in a BSC');
xlabel('P values');
ylabel('BER');

% Q(x) = 0.5 * ( 1 - erf(x/sqrt(2)))
% Q^(-1)(x) = sqrt(2)*erfinv(1 - 2x)

Xuncoded = 20.*log10(sqrt(2).*erfinv(1 - 2.*pValues));
Xcoded = Xuncoded - 10.*log10(16/31); % R = code Rate = k/n

figure()
plot([Xuncoded; Xcoded], BER);
title('Plot of BER in BCH codes in a BSC');
legend('Uncoded', 'Coded');
xlabel('SNR');
ylabel('BER');

% section 1) q 8)b)

% SNR = 10*log10((1/ampl)^2), ampl = 10^(-SNR/20)
msg = rand(length(snrValues)*repetitions, 16) > 0.5;
bch_encoded = encoder(msg);
noise = randn(length(bch_encoded), 31).* ...
      repmat(reshape(repmat(10.^(-snrValues./20),repetitions,1) ...
             ,1,[])',1,31); 
signal = 1 - 2.*bch_encoded;
bch_decoded = matlabBCHdecode((signal + noise) < 0); % Hard decision on 0
bitErrs = reshape((sum(mod(bch_decoded' + msg',2))./16)', repetitions, []);
BER = sum(bitErrs)/length(bitErrs); % take the average

noise = randn(length(msg), 16).* ...
      repmat(reshape(repmat(10.^(-snrValues./20),repetitions,1) ...
             ,1,[])',1,16); 
signal = 1 - 2.*msg;
decoded = (signal + noise) < 0;
bitErrs = reshape((sum(mod(decoded' + msg',2))./16)', repetitions, []);
BER2 = sum(bitErrs)/length(bitErrs); % take the average

figure()
plot(snrValues, [BER2; BER]);
title('Plot of BER in BCH codes in an AWGN BPSK');
legend('Uncoded', 'Coded');
xlabel('SNR');
ylabel('BER');

