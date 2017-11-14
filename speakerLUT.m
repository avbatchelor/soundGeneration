
freqs = [100,140,200,225,300,500,800];
speaker1 = [0.93413, 0.72322, 0.67311, 0.72111, 0.684, 0.64445, 0.4499];
speaker2 = [0.8338,0.6455,0.6008,0.6436,0.6105,0.5752,0.4016];
speaker3 = [0.92103,0.6480,0.5598,0.5997,0.5689,0.5360,0.3742];
speaker4 = [0.9732,0.72674,0.6284,0.6732,0.6386,0.6017,0.4519];

speaker1Map = containers.Map(freqs,speaker1);
speaker2Map = containers.Map(freqs,speaker2);
speaker3Map = containers.Map(freqs,speaker3);
speaker4Map = containers.Map(freqs,speaker4);

save('C:\Users\Alex\Documents\GitHub\soundGeneration\speakerLUT','speaker1Map','speaker2Map','speaker3Map','speaker4Map')