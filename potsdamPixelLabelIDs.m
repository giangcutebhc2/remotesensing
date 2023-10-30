function labelIDs = potsdamPixelLabelIDs()
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
    255 255 255; ... % "Building" 
    ]

    % Road
    [
    000 000 255; ... % Road
    ]
    
    % "StaticCar"
    [
    000 255 255; ... % "StaticCar"
    ]
        
    % "Tree"
    [
    000 255 000; ... % "Tree"
    ]
    
    % "LowVegetation"
    [
    255 255 000; ... % "LowVegetation"
    ]
    
    % "Human"
    [
    255 000 000; ... % "Human"
    ]

    
    };
end