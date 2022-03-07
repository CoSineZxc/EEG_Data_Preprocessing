function num=searchfilenumber(FileNameList,Name) 
   for i=1:size(FileNameList)
       if strcmp(FileNameList(i,:), Name)
           num=i;
       end
   end
end

