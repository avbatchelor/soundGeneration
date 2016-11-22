classdef StepPlusSine < AuditoryStimulus
    % Basic subclass for making (amplitude modulated) sws
    %
    % SLH 2014
    
    properties
        % Sine params 
        carrierFreqHz       = 300;
        envelope            = 'cos-theta';
        sineDur             = 1;
        modulationDepth     = 1;
        % Step params 
        stepSize            = 1;
        stepDur             = 3;
        stepDirection       = 'forward';
        % StepPlusSine params
        stepStartPadDur     = 3;
        stepEndPadDur       = 3;
        sineAmp             = 0.1;
        stepAmp             = 2; 
    end
    
    properties (Dependent = true, SetAccess = private)
        stimulus
        description
    end
    
    methods
       
        %%------Calculate Dependents-----------------------------------------------------------------
        function stimulus = get.stimulus(obj)
            
            stim1 = ForwardStep; 
            stim1.stepSize = obj.stepSize;
            stim1.stepDur = obj.stepDur;
            stim1.stepDirection = obj.stepDirection;
            stim1.startPadDur = obj.stepStartPadDur; 
            stim1.endPadDur = obj.stepEndPadDur; 
            stim1.maxVoltage = obj.stepAmp;
            
            stim2 = SineWave;
            stim2.carrierFreqHz = obj.carrierFreqHz;
            stim2.envelope = obj.envelope;
            stim2.sineDur = obj.sineDur;
            stim2.modulationDepth = obj.modulationDepth;
            stim2.maxVoltage = obj.sineAmp;
            % Make start and end pads the correct length
            stim2.startPadDur = 0;
            stim2.endPadDur = 0;
            stimLengthDiff = length(stim1.stimulus) - length(stim2.stimulus);
            stim2PadLength = 0.5*(stimLengthDiff/obj.sampleRate);
            stim2.startPadDur = stim2PadLength;
            stim2.endPadDur = stim2PadLength;
            
            stimulus = stim1.stimulus + stim2.stimulus;

        end
        
        function description = get.description(obj)
            description = ['Step plus sine, sine carrier = ',num2str(obj.carrierFreqHz),'Hz'];
        end
        
    end
    
end


