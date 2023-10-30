function cmap = camvidColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
    128 0 0; ... % "Building" 
    128 64 128; ... % Road
    192 0 192; ... % "StaticCar"
    0 128 0; ... % "Tree"
    128 128 0; ... % "LowVegetation"
    64 64 0; ... % "Human"
    64 0 128; ... % "MovingCar"
    0 0 0; ... % "BackgroundClutter"
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end