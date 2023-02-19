% 
clear all;

% load in data (from folder called "Data")
load('Data/pvtSD_acti_overlap.mat')
load('Data/acti1_cropped_overlap.mat')

% outputs pvt.mat file.
data_setup(pvtSD_acti_overlap, acti1_cropped_overlap)
load('Data/pvt.mat')


% outputs clean_act.mat
acti_preprocess(pvt, acti1_cropped_overlap)

% outputs sleep_acti.mat and awake_acti.mat
awake_and_sleep_setup(pvt, acti1_cropped_overlap)

% init hctsa package
% go to Toolboxes/catch22 and run mexAll()  
startup()
mexAll() 

all_data_plot() % hctsa analysis of all timing data midnight to midnight
awake_plot() % " " but with awake data
asleep_plot()% " " but with asleep data
