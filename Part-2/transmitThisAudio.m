% This code is to "transmit" an audio. The "transmission" process will add noise to the original audio.
% Three new audio files will be generated and saved.
% DO NOT CHANGE/EDIT this code.

clc

disp('Input only numbers. Press ENTER to cancel.');
prompt = 'Send to ID number: ';
id = input(prompt);

if isempty(id)
    disp('User cancelled transmission.');
else
    [file,path] = uigetfile(...
        {'*.wav; *.mp3; *.m4a; *.mp4; *.ogg; *.flac; *.au; *.aiff; *.aif; *.aifc', ...
        'Audio Files';
        '*.*', 'All Files (*.*)'}, ...
        'Select an audio file to transmit...');
    if isequal(file,0)
        disp('User selected Cancel');
    else
        load data.mat
        disp(['User selected ', fullfile(path,file)]);
        [x,Fs] = audioread(fullfile(path,file));
        x = x(:,1);
                
        %Add Transmission Artifacts
        id_string = num2str(100000+id);
        len = length(id_string);
        mor = [];
        for i=len-3:len
            mor = [mor getfield(mcode, ['n', num2str(id_string(i))])];
            mor = [mor ' '];
        end

        t = 0.3;
        N = t*Fs;
        n = 0:N-1;
        dash = 0.03*sin(2*pi*(830+rand*150)/Fs*n);
        
        t = 0.1;
        N = t*Fs;
        n = 0:N-1;
        dot = 0.03*sin(2*pi*(1710+rand*1000)/Fs*n);
        
        ssp = zeros(1,N);
        lsp = zeros(1,N*4);
        
        quad = [];
        for i=1:length(mor)
            if strcmp(mor(i), '.')
                quad = [quad dot ssp];
            elseif strcmp(mor(i), '-')
                quad = [quad dash ssp];
            elseif strcmp(mor(i), ' ')
                quad = [quad lsp ssp];
            end
        end
        
        x = x';
        if numel(x) < numel(quad)
            g = quad + padarray(x,[0, numel(quad)-numel(x)],0,'post');
        else
            cycle = floor(numel(x)/numel(quad));
            reps = [];
            for i=1:cycle
                reps = [reps quad];
            end
            g = x + padarray(reps,[0, numel(x)-numel(reps)],0,'post');
        end
        
%         helperFrequencyAnalysisPlot1(g, Fs);
        %Transmit and save
        disp(['Transmitting Audio file ', file, ' to ', num2str(id), '...']);
        disp('...');
        sound(real(g), Fs);
        disp('bzzzjjtsddyadgg!?');
        savename = 'receivedAudio.wav';
        disp('...');
        audiowrite(savename,real(g),Fs)        
        audiowrite('noise1.wav',real(dot),Fs)
        audiowrite('noise2.wav',real(dash),Fs)
        disp(['Received audio file saved as ', savename]);
        disp('Detected noise saved as noise1.wav and noise2.wav');
%         clear
    end
end
