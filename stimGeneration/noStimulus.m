classdef noStimulus < AuditoryStimulus
    % Basic subclass for making just the pad and no stimulus
    
    properties
        description     = 'No stimulus';
        waveDur         = 6;
    end
    
    properties (Dependent = true, SetAccess = private)
        stimulus
    end
    
    methods
        
        %%------Calculate Dependents-----------------------------------------------------------------
        function stimulus = get.stimulus(obj)
            % Make a zero stimulus that is the length of start pad
            stimulus = zeros(obj.sampleRate*obj.waveDur,1);
            %stimulus = obj.addPad(stimulus);
        end
        

    end
end
