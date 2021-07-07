function [] = syncFromCloudPalas(driveTokenName,palasStreamFolder,backUpFolder)
    folderCheck(backUpFolder)
    folderCheck(palasStreamFolder)
    display("Syncing from Google Drive")
    system(strcat("rclone -v sync ",driveTokenName,":palasData/ ",backUpFolder));
    system(strcat("rsync -avzrtu ",backUpFolder," ",palasStreamFolder));

end

