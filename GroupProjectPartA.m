% Generate audio tone
time = 1;                               % length of clip in seconds
Fs = 20e3;                              % sampling frequency
Ts = 1/Fs;                              % sampling time period
n = 1 : round(time/Ts);                 % n-index 
t = n * Ts;                             % time scale
f_C = 261.625565;                       % frequency of tone (middle C note)
x = 0.5 * cos(2*pi*f_C*n*Ts);           % time domain tone

% [x,Fs] = audioread('C_chord.m4a');      %read the audio file

f0 = 30;                                % frequency (Hz) to shift by
y = freqShift(x, Fs, f0);               % apply frequency shift

%-----------------------------------------------------------------
% Task 1A: Adjust all plots so that they display meaningful graphs.
% For example, the time domain plot displays too many cycles. 
subplot(221);
plot(x);
% xlim([0 0.05e4])
subplot(223);
plot(y);
subplot(222);
plot(abs(fft(x)));
% xlim([0 0.2e4])
subplot(224);
plot(abs(fft(y)));
%-----------------------------------------------------------------

% Display on command window
disp('Playing audio. Press any key (such as Enter) to continue...')
sound(x,Fs)
pause
text = ['Playing audio shifted by ', num2str(freq), ' Hz.'];
disp(text)
sound(y,Fs)

function shifted = freqShift(xt,Fs,f0)
    Xk = fft(xt);                                   % convert to frequency domain
    N = length(Xk);                                 % get the sequence length
                                       % shift by this frequency value
    shift = round( f0 / (Fs/N) );                   % shift by this many points

    shiftRight = zeros( 1, N/2 );                   % empty array to store right values
    shiftLeft  = zeros( 1, N/2 );                   % empty array to store left values
    if shift >= 0
        shiftRight(shift+1:end) = Xk(1:N/2-shift);  % right shift
        shiftLeft(1:N/2-shift) = Xk(N/2+shift+1:N); % left shift
        shiftAll = [shiftRight shiftLeft];          % concatenate both sequences
    else
        %-------------------------------------------
        % Task 1B: write codes for shift < 0
        % place your codes here

        %-------------------------------------------
    end

    shifted = ifft(shiftAll,'symmetric');           % inverse fft
end

