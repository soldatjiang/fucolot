function setup_paths()

% Add the neccesary paths
[pathstr, name, ext] = fileparts(mfilename('fullpath'));

% add paths
addpath([pathstr, 'scale']);
addpath(genpath([pathstr, 'CSRDCF']));

