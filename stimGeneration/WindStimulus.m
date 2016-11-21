classdef WindStimulus < AuditoryStimulus
    % Basic subclass for making square waves
    %
    % AVB 2015
    
    properties
        windDur             = 5;
    end
    
    properties (SetAccess = private)
        commandVoltage = 1
    end

    properties (Dependent = true, SetAccess = private)
        stimulus
        description
    end
    
    methods
       
        %%------Calculate Dependents-----------------------------------------------------------------
        function stimulus = get.stimulus(obj)
            
            % Make sw
            time = 0:1/obj.sampleRate:obj.windDur-(1/obj.sampleRate);
            sw = ones(length(time),1);

            % Scale the stim to the maximum voltage in the amp
            stimulus = sw*obj.commandVoltage;
            
            % Add pads
            obj.startPadDur         = 10; % seconds
            obj.endPadDur           = 10; % seconds
            stimulus = obj.addPad(stimulus);
        end
        
        function description = get.description(obj)
            description = ['Wind stimulus, ',num2str(obj.windDur),' (s) long'];
        end
        
    end
    
end


