
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
np2Folder                =  referenceDotMatsFolder + "/np2"  ;


display(newline)
display("Data Folder Located @:"+ dataFolder)
display("Reference Data Located @: "+ referenceFolder)
display("Reference DotMat Data Located @ :"+ referenceDotMatsFolder)

display(newline)

%% Syncing Process

% Needs to be connected to AV
% syncFromNas(sshPW,nasIP,referenceFolder)


%% Finding Files

np2Files =  dir(strcat(referenceFolder,'/*/*/*/*/MINTS_',c1PlusID,'_NP2','*.csv'));

%% GPSGPGGA File Record
if(length(np2Files) >0)
    
    parfor fileNameIndex = 1: length(np2Files)
        try
            display("Reading: "+np2Files(fileNameIndex).name+"- "+string(fileNameIndex))
            np2Data{fileNameIndex} =  np2Read(strcat(np2Files(fileNameIndex).folder,"/",np2Files(fileNameIndex).name),timeSpan);
        catch
            display("Error With : "+np2Files(fileNameIndex).name+" - "+string(fileNameIndex))
        end
    end
end

display(strcat("Concatinating np2 Data"));

concatStr  =  "mintsDataAll = [";

for fileNameIndex = 1:length(np2Files)
    concatStr = strcat(concatStr,"np2Data{",string(fileNameIndex),"};");
end

%% Filling In the Gaps

concatStr  =  strcat(concatStr,"];");
display(concatStr);
eval(concatStr);

display("Retiming np2 Data");
mintsDataAll   =  sortrows(unique(mintsDataAll));
mintsData      =  rmmissing(retime(mintsDataAll,'regular',@mean,'TimeStep',timeSpan));


%% Getting Save Name
display("Saving np2 Data");
saveName  = strcat(np2Folder,'/np2All.mat');
folderCheck(saveName)
save(saveName,'mintsDataAll');


saveName  = strcat(np2Folder,'/np2.mat');
folderCheck(saveName)
save(saveName,'mintsData');

