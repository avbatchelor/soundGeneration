classdef SineWave < AuditoryStimulus
    % Basic subclass for making (amplitude modulated) sws
    %
    % SLH 2014
    
    properties
        carrierFreqHz       = 300;
        envelope            = 'cos-theta';
        sineDur             = 1;
        modulationDepth     = 1;
        LED                 = 'off';
    end
    
    properties (Dependent = true, SetAccess = private)
        stimulus
        description
    end
    
    methods
       
        %%------Calculate Dependents-----------------------------------------------------------------
        function stimulus = get.stimulus(obj)
            
            % Make sw
            sw = obj.makeSine(obj.carrierFreqHz,obj.sineDur);
            
            % Calculate envelope
            sampsPersw = length(sw);
            switch lower(obj.envelope)
                case {'none',''}
                    % pass back unchanged
                    return
                case {'sinusoid','sin'}
                    modEnvelope = obj.modulationDepth*sin(pi*[0:1/(sampsPersw-1):1])';
                case {'triangle','tri'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[.25:1/(2*(sampsPersw-1)):.75],.5)';
                case {'rampup'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[.5:1/(2*(sampsPersw-1)):1])';
                case {'rampdown'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[0:1/(2*(sampsPersw-1)):.5],0)';
                case {'cos-theta'}
                    sampsPerRamp = floor(sampsPersw/10);
                    ramp = sin(linspace(0,pi/2,sampsPerRamp));
                    modEnvelope = [ramp,ones(1,sampsPersw - sampsPerRamp*2),fliplr(ramp)]';
                otherwise
                    error(['Envelope ' obj.Envelope ' not accounted for.']);
            end
            
            % apply the envelope to sw
            sw = modEnvelope.*sw;
            
            % Scale the stim to the maximum voltage in the amp
            stimulus = sw*obj.maxVoltage;
            
            % Add pads
            stimulus = obj.addPad(stimulus);
        end
        
        function description = get.description(obj)
            description = [num2str(obj.carrierFreqHz),'Hz tone'];
        end
        
    end
    
end


