classdef PulseSong < AuditoryStimulus
    % Basic subclass for courtship song
    %
    % AVB 2015
    
    properties
        description     = 'Pulse song';
        LED             = 'off';
    end
    
    properties (Dependent = true, SetAccess = private)
        stimulus
    end
    
    methods
        %%------Constructor-----------------------------------------------------------------
        function stimulus = get.stimulus(obj)
            % Read in courtship song recording
            [stimulus, obj.sampleRate] = audioread('C:\Users\Alex\Documents\GitHub\soundGeneration\stimGeneration\courtshipSamps\PulseSongRepeat_Standard.wav');
            
            % Make stimulus a normal length
            stimToAdd = obj.sampleRate - rem(length(stimulus),40000);
            stimulus = [stimulus;zeros(stimToAdd,1)];
            
            voltagePeak = max(abs(stimulus));
            scalingFactor = obj.maxVoltage/voltagePeak; 
            stimulus = stimulus.*scalingFactor;
            
            % Add pause at the beginning of of the stim
            stimulus = obj.addPad(stimulus);
        end
        
    end
    
end