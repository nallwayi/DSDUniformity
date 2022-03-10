% -------------------------------------------------------------------------
% Function to generate sample from the main distribution

function sampleDist = generateRandomSample(mainDist,sampleLngth)

% Generating random sample from the given dist
sampleDist = datasample(mainDist,sampleLngth,'Replace',false);

end

%--------------------------------------------------------------------------