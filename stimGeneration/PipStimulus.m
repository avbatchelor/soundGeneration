classdef PipStimulus < AuditoryStimulus
    % Basic subclass for making (amplitude modulated) pips
    %
    % SLH 2014
    
    properties
        modulationDepth     = 1;
        modulationFreqHz    = 2;
        carrierFreqHz       = 225;
        envelope            = 'cosine';
        numPips             = 10;
        approxPipDur        = 0.015;
        ipi                 = 0.034;
        odor                = 'none';
        envelopeRamp        = 10;
    end
    
    properties (Dependent = true, SetAccess = private)
        cyclesPerPip
        stimulus
        description 
        maxVoltage
        pipDur
    end
    
    
    methods
        
        function maxVoltage = get.maxVoltage(obj)
            speakerLUT;
            load('C:\Users\Alex\Documents\GitHub\soundGeneration\speakerLUT')
            maxVoltage = eval(['speaker',num2str(obj.speaker),'Map(obj.carrierFreqHz)']);
        end
       
        %%------Calculate Dependents-----------------------------------------------------------------
        function cyclesPerPip = get.cyclesPerPip(obj)
            cyclesPerPip = obj.pipDur / (1/obj.carrierFreqHz);
            if (mod(cyclesPerPip,0.5))~=0
                error('numCyclesPerPip must be divisible by 0.5')
            end
        end
        
        function pipDur = get.pipDur(obj)
            halfWavelength = (1/obj.carrierFreqHz/2);
            pipDur = round(obj.approxPipDur/halfWavelength)*halfWavelength;
        end
        
        function stimulus = get.stimulus(obj)
            
            % Make pip
            pip = obj.makeSine(obj.carrierFreqHz,obj.pipDur);
            
            % Calculate envelope
            sampsPerPip = length(pip);
            switch lower(obj.envelope)
                case {'none',''}
                    % pass back unchanged
                    return
                case {'sinusoid','sin'}
                    modEnvelope = obj.modulationDepth*sin(pi*[0:1/(sampsPerPip-1):1])';
                case {'triangle','tri'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[.25:1/(2*(sampsPerPip-1)):.75],.5)';
                case {'rampup'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[.5:1/(2*(sampsPerPip-1)):1])';
                case {'rampdown'}
                    modEnvelope = obj.modulationDepth*sawtooth(2*pi*[0:1/(2*(sampsPerPip-1)):.5],0)';
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
                    modEnvelope = ((1-cos(linspace(0,2*pi,sampsPerPip)))/2)';
                otherwise
                    error(['Envelope ' obj.Envelope ' not accounted for.']);
            end
            
            % apply the envelope to pip
            pip = modEnvelope.*pip;
            
            % generate pip train
            spacePip = [zeros(round((obj.ipi-obj.pipDur)*obj.sampleRate),1);pip];
            stimulus = [pip;repmat(spacePip,obj.numPips-1,1)];
            
            % Scale the stim to the maximum voltage in the amp
            stimulus = stimulus*obj.maxVoltage;
            
            % Add pause at the beginning of of the stim
            stimulus = obj.addPad(stimulus);
        end
        
        function description = get.description(obj)
            description = [num2str(obj.numPips),' pips, ',num2str(obj.carrierFreqHz), 'Hz carrier, ', 'IPI = ',num2str(obj.ipi)];
        end
             
    end
    
end


