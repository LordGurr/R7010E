clear all
clc
close all
addpath(genpath('./'));


% map1.txt and map2.txt are the complex enviroments
map = load_map('maps/map2.txt', 0.1, 2, 0.25);
plot_path(map);
grid on
box on

