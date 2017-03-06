classdef AuditoryStimulus < handle
    % Basic superclass for auditory stimuli that holds samplerate and a plotting function
    %
    % SLH 2014ed
    
    properties
        sampleRate      = 4E4;
        startPadDur     = 0.5; % seconds
        endPadDur       = 0.5; % seconds
        maxVoltage      = .05;
        speakerOrder    = {'L','M','R'}; % From fly's point of view
        speaker         = 2;
        probe           = 'off';
    end
    
    properties (Dependent = true, SetAccess = private)
        totalDur
        stimDur
        timeVec
    end
    
    methods       
        
        %%------Calculate Dependents-----------------------------------------------------------------
        function totalDur = get.totalDur(obj)
            totalDur = length(obj.stimulus)/obj.sampleRate;
        end
        
        function stimDur = get.stimDur(obj)
            stimDur = obj.totalDur - obj.startPadDur - obj.endPadDur;
        end
        
        function timeVec = get.timeVec(obj) 
            timeVec = (1/obj.sampleRate):(1/obj.sampleRate):(1*length(obj.stimulus)/obj.sampleRate);
        end
            
        %%------Common Utilities---------------------------------------------------------
        function carrier = makeSine(obj,frequency,dur)
            ts = (1/obj.sampleRate):(1/obj.sampleRate):(dur);
            carrier = sin(2*pi*frequency*ts)';
        end
        
        function static = makeStatic(obj,dur)
            static = ones(obj.sampleRate*dur,1);
        end
        
        function stimulus = addPad(obj,stimulus)
            startPad = zeros(obj.sampleRate*obj.startPadDur,1);
            endPad = zeros(obj.sampleRate*obj.endPadDur,1);
            stimulus = [startPad;stimulus;endPad];
        end
        
        
        %%------Plotting--------------------------------------------------------------------
        function [figHandle,plotHandle] = plot(obj,varargin)
            fontSize = 14;
            lineWidth = 1; 
            figHandle = figure('Color',[1 1 1],'Name','AuditoryStimulus');
            plotHandle = plot(obj.timeVec,obj.stimulus);
            set(plotHandle,'LineWidth',lineWidth)
            
            box off; axis on;
            set(gca,'TickDir','Out')
            title('Current Auditory Stimulus','FontSize',fontSize)
            ylabel('Amplitude (V)','FontSize',fontSize)
            xlabel('Time (seconds)','FontSize',fontSize)
        end
    end
    
end
