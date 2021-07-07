
clc ; close all ; clear all

display(newline)
display(newline)
display("---------------------MINTS---------------------")

addpath("../functions/")
addpath("../functions/YAMLMatlab_0.4.3")
mintsDefinitions  = ReadYaml('/home/teamlary/Documents/mintsDefinitions.yaml');

dataFolder = mintsDefinitions.dataFolder;
c1PlusID   = mintsDefinitions.c1PlusID;
airMarID   = mintsDefinitions.airMarID;
timeSpan   = seconds(mintsDefinitions.timeSpan);
sshPW      = mintsDefinitions.sshPW;
nasIP      = mintsDefinitions.nasIP;


referenceFolder          =  dataFolder + "/reference";
referenceDotMatsFolder   =  dataFolder + "/referenceMats";
o3Folder                =  referenceDotMatsFolder + "/o3"  ;


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Reference Data Located @: "+ referenceFolder)
display("Reference DotMat Data Located @ :"+ referenceDotMatsFolder)

display(newline)

%% Syncing Process

% Needs to be connected to AV
syncFromNas(sshPW,nasIP,referenceFolder)


%% Finding Files

o3Files =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_2B-O3','*.csv'));

%% GPSGPGGA File Record
if(length(o3Files) >0)
    
    parfor fileNameIndex = 1: length(o3Files)
        try
            display("Reading: "+o3Files(fileNameIndex).name+"- "+string(fileNameIndex))
            o3Data{fileNameIndex} =  o3Read(strcat(o3Files(fileNameIndex).folder,"/",o3Files(fileNameIndex).name),timeSpan);
        catch
            display("Error With : "+o3Files(fileNameIndex).name+" - "+string(fileNameIndex))
        end
    end
end

display(strcat("Concatinating o3 Data"));

concatStr  =  "mintsDataAll = [";

for fileNameIndex = 1:length(o3Files)
    concatStr = strcat(concatStr,"o3Data{",string(fileNameIndex),"};");
end

%% Filling In the Gaps

concatStr  =  strcat(concatStr,"];");
display(concatStr);
eval(concatStr);

display("Retiming o3 Data");
mintsDataAll   =  sortrows(unique(mintsDataAll));
mintsData      =  rmmissing(retime(mintsDataAll,'regular',@mean,'TimeStep',timeSpan));


%% Getting Save Name
display("Saving o3 Data");
saveName  = strcat(o3Folder,'/o3All.mat');
folderCheck(saveName)
save(saveName,'mintsDataAll');


saveName  = strcat(o3Folder,'/o3.mat');
folderCheck(saveName)
save(saveName,'mintsData');

