classdef AmTone < AuditoryStimulus
    % Basic subclass for making amplitude modulated tones
    
    properties
        modDepth            = 1;
        modFreqHz           = 15;
        carrierFreqHz       = 300;
        envelope            = 'sinusoid';
        waveDur             = 5;
        LED                 = 'off';
    end
    
    properties (Dependent = true, SetAccess = private)
        stimulus
        description
    end
    
    methods
        %%------Calculate Dependents---------------------------------------------------------
        function stimulus = get.stimulus(obj)
            % Use carrier frequency if wanted
            wave = obj.makeSine(obj.carrierFreqHz,obj.waveDur);
            
            % Apply an amplitude modulation (or pass back if not wanted)
            wave = obj.ampModulate(wave);
            
            % Scale the stimulus to the maximum voltage in the amp
            stimulus = wave*obj.maxVoltage;
            
            % Add pause at the beginning of of the stim
            stimulus = obj.addPad(stimulus);
        end
        
        function [wave] = ampModulate(obj,wave)
            switch lower(obj.envelope)
                case {'none',''}
                    % pass back unchanged
                    return
                case {'sinusoid','sin'}
                    % make an envelope that fits the pulse duration
                    modEnvelope = obj.makeSine(obj.modFreqHz/2,obj.waveDur);
                case {'triangle','tri'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[.25:1/(2*obj.waveDur):.75],.5)';
                case {'rampup'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[.5:1/(2*obj.waveDur):1])';
                case {'rampdown'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[0:1/(2*obj.waveDur):.5],0)';
                otherwise
                    error(['Envelope ' obj.Envelope ' not accounted for.']);
            end
            % apply the envelope to all of the modulation bounds          
            wave = modEnvelope.*wave;
        end
        
        function description = get.description(obj)
            description = ['AM Tone, ',num2str(obj.carrierFreqHz),'Hz carrier, ',num2str(obj.modFreqHz),'Hz modulation'];
        end
    end
end