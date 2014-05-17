% simulations section 1) part 8)
% Find the BER over a BCH code
pValues = 0.001:0.001:10;
snrValues = 0.001:0.001:10;
repetitions = 100;
messageLength = 1000;

BER = [];

for p = pValues
    averageBerrs = 0;
    for r = 1:repetitions
        msg = (rand(1, messageLength) > 0.5);
        bch_encoded = 0; % TODO: BCH encode
        errors = (rand(1,length(bch_encoded)) < p);
        bch_decode = decodeMsg(mod(bch_encoded + errors, 2)); % TODO: BCH decode
        bitErrs = sum(mod(bch_decode + msg,2))/length(msg);
        averageBerrs = averageBerrs + bitErrs;
    end
    BER = [BER (averageBerrs/repetitions)];
end

figure()
plot(pValues, BER);
title('Plot of BER in BCH codes in a BSC');
xaxis('P values');
yaxis('BER');

% Q(x) = 0.5 * ( 1 - erf(x/sqrt(2)))
% Q^(-1)(x) = sqrt(2)*erfinv(1 - 2x)

Xuncoded = 20*log10(1/(sqrt(2)*erfinv(1 - 2.*pValues)));
Xcoded = Xuncoded - 10*log10(R); % R = code Rate = k/n

figure()
plot(Xuncoded, BER, Xcoded, BER, '-r');
title('Plot of BER in BCH codes in a BSC');
xaxis('SNR');
yaxis('BER');

% section 1) q 8)b)

BER = [];

for s = snrValues
    averageBerrs = 0;
    for r = 1:repetitions
        msg = (rand(1, messageLength) > 0.5);
        bch_encoded = 0; % TODO: BCH encode
	signal = 1 - 2*bch_encoded;
        noise = randn(length(signal))*sqrt(1/s); % TODO: check conversion to snr, put in dB?
	hard_dec = (signal + noise) < 0; % Hard decision on 0
        bch_decode = decodeMsg(hard_dec); % TODO: BCH decode
        bitErrs = sum(mod(bch_decode + msg,2))/length(msg);
        averageBerrs = averageBerrs + bitErrs;
    end
    BER = [BER (averageBerrs/repetitions)];
end

figure()
plot(snrValues, BER);
title('Plot of BER in BCH codes in an AWGN BPSK');
xaxis('SNR');
yaxis('BER');

