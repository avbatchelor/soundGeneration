classdef noStimulus < AuditoryStimulus
    % Basic subclass for making just the pad and no stimulus
    
    properties
        description     = 'No stimulus';
        LED             = 'off';
    end
    
    properties (Dependent = true, SetAccess = private)
        stimulus
        waveDur
    end
    
    methods
        
        %%------Calculate Dependents-----------------------------------------------------------------
        function waveDur = get.waveDur(obj)
            waveDur = obj.startPadDur + obj.endPadDur;
        end
        
        function stimulus = get.stimulus(obj)
            % Make a zero stimulus that is the length of waveDur
            stimulus = zeros(obj.sampleRate*obj.waveDur,1);
        end
        

    end
end
