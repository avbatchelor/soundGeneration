function speakerLUT

freqs = [100,140,200,225,300,500,800];

%% Speaker 1
% Amp 3 (SLA), channel 2 
% Calibrated 2018-01-10, exp 13
speaker1 = [1.8577,1.7022,1.2586,1.3741,1.1718,0.98442,0.9702];

%% Speaker 2
% Amp 1 (Crown-D45), channel 1
% Calibrated 2017-10-31, exp 6,3,1
speaker2 = [0.8338,0.6455,0.6008,0.6436,0.6105,0.5752,0.4016];

%% Speaker 3
% Amp 2 (Crown-D45), channel 1
% Calibrated 2018-01-10, exp 12,1,5
speaker3 = [0.63434,0.53965,0.4118,0.40327,0.36399,0.25912,0.2839];

%% Speaker 6
% Amp 3 (SLA), channel 1
% Calibrated 2017-12-07, exp 11,1,1
speaker6 = [1.4127,1.1478,0.92828,0.87775,0.68565,1.0319,0.72535];

%% Create maps 
speaker1Map = containers.Map(freqs,speaker1);
speaker2Map = containers.Map(freqs,speaker2);
speaker3Map = containers.Map(freqs,speaker3);
speaker6Map = containers.Map(freqs,speaker6);

save('C:\Users\Alex\Documents\GitHub\soundGeneration\speakerLUT','speaker1Map','speaker2Map','speaker3Map','speaker6Map')

end
