function labelIDs = camvidPixelLabelIDs()
% Return the label IDs corresponding to each class.
%
% The CamVid dataset has 32 classes. Group them into 11 classes following
% the original SegNet training methodology [1].
%
% The 11 classes are:
%   "Sky" "Building", "Pole", "Road", "Pavement", "Tree", "SignSymbol",
%   "Fence", "Car", "Pedestrian",  and "Bicyclist".
%
% CamVid pixel label IDs are provided as RGB color values. Group them into
% 11 classes and return them as a cell array of M-by-3 matrices. The
% original CamVid class names are listed alongside each RGB value. Note
% that the Other/Void class are excluded below.
labelIDs = { ...
    
    % "Building" 
    [
    128 000 000; ... % "Building" 
    ]

    % Road
    [
    128 064 128; ... % Road
    ]
    
    % "StaticCar"
    [
    192 000 192; ... % "StaticCar"
    ]
        
    % "Tree"
    [
    000 128 000; ... % "Tree"
    ]
    
    % "LowVegetation"
    [
    128 128 000; ... % "LowVegetation"
    ]
    
    % "Human"
    [
    064 064 000; ... % "Human"
    ]
    
    % "MovingCar"
    [
    064 000 128; ... % "MovingCar"
    ]
    
    % "BackgroundClutter"
    [
    000 000 000; ... % "BackgroundClutter"
    ]
    
    };
end