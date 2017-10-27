classdef OptoStimulus < AuditoryStimulus
    % Basic subclass for making square waves
    %
    % AVB 2015
    
    properties
        optoDur             = 5;
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
            time = 0:1/obj.sampleRate:obj.optoDur-(1/obj.sampleRate);
            sw = zeros(length(time),1);
            sw(1:100) = 1; 
            sw(end-100:end) = 1;

            % Scale the stim to the maximum voltage in the amp
            stimulus = sw*obj.commandVoltage;
            
            % Add pads
            stimulus = obj.addPad(stimulus);
        end
        
        function description = get.description(obj)
            description = ['Opto stimulus, ',num2str(obj.optoDur),' (s) long'];
        end
        
    end
    
end


