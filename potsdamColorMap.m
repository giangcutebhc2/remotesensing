function cmap = potsdamColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
    255 255 255; ... % "Building" 
    0 0 255; ... % Road
    0 255 255; ... % "StaticCar"
    0 255 0; ... % "Tree"
    255 255 0; ... % "LowVegetation"
    255 0 0; ... % "Human"
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end