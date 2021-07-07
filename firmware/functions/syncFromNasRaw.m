%% Functions Used 
function [] = syncFromNasRaw(sshPW,nasIP,rawFolder)

    %% Setup the Import Options and import the data
%     strcat("sshpass -p ",sshPW,' rsync -avzrtu -e ssh --include="*.csv" --include="*/" --exclude="*" mintsdata@',nasIP,':/volume1/MINTSNASCAR/reference/ '," ",referenceFolder)
    system(strcat("sshpass -p ",sshPW,' rsync -avzrtu -e ssh --include="*.csv" --include="*/" --exclude="*" mintsdata@',nasIP,':/volume1/MINTSNASCAR/raw/ '," ",rawFolder))

end
