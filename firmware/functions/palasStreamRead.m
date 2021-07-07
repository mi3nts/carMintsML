function  palasStreamRetimed = palasStreamRead(fileName,timeStep)
%SAVEPALASSTREAMFILE Summary of this function goes here
%   Detailed explanation goes here
%% if no file exists 
    display(newline)
    display("---------------------MINTS---------------------")
    display("Reading "+ fileName)
%    palasStream = table2timetable(getPalasStreamFile(fileName));
%     folderCheck(fileNameMat); 
%     save(fileNameMat,'palasStream')       
%     
    if(timeStep>seconds(0))
        palasStream = table2timetable(getPalasStreamFile(fileName));
%         display(strcat("Saving Retimed File as'",fileNameRetimed,"'")) 
        
        if (height(palasStream)>0)
            palasStreamRetimed = ...
            retime(palasStream,'regular',@mean,'TimeStep',seconds(30));
%             save(fileNameRetimed,'palasStreamRetimed') 
        else
            display(strcat("No Data For: '",fileName,"'"))
            palasStreamRetimed = timetable;
        end
        
    end
end

