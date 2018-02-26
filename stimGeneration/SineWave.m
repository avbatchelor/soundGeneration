classdef SineWave < AuditoryStimulus
    % Basic subclass for making (amplitude modulated) sws
    %
    % SLH 2014
    
    properties
        carrierFreqHz       = 300;
        envelope            = 'cosine';
        sineDur             = 0.3216;
        modulationDepth     = 1;
        LED                 = 'off';
        odor                = 'no odor';
        envelopeRamp        = 10;
    end
    
    properties (Dependent = true, SetAccess = private)
        stimulus
        description
        maxVoltage
    end
    
    methods
       
        %%------Calculate Dependents-----------------------------------------------------------------
    
        function maxVoltage = get.maxVoltage(obj)
            [speaker1Map, speaker2Map, speaker3Map, speaker6Map] = speakerLUT;
            maxVoltage = eval(['speaker',num2str(obj.speaker),'Map(obj.carrierFreqHz)']);
        end
        
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
                    % num samples per ramp can be at most half the number
                    % of samps per pip 
                    if obj.envelopeRamp<2
                        obj.envelopeRamp = 2;
                    end
                    sampsPerRamp = floor(sampsPerPip/obj.envelopeRamp);
                    ramp = sin(linspace(0,pi/2,sampsPerRamp));
                    modEnvelope = ones(size(pip));
                    modEnvelope(1:sampsPerRamp) = ramp;
                    modEnvelope(sampsPerPip-sampsPerRamp+1:sampsPerPip) = fliplr(ramp);
                case {'cosine'}
                    sampsPerPip = round(obj.sampleRate*0.0156);
                    ramp = ((1-cos(linspace(0,pi,sampsPerPip)))/2)';
                    sampsPerRamp = length(ramp);
                    modEnvelope = ones(size(sw));
                    modEnvelope(1:sampsPerRamp) = ramp;
                    modEnvelope(sampsPersw-sampsPerRamp+1:sampsPersw) = flipud(ramp);
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


