function sortedArray = getSortedDirectoryByName(structArray)
    [x,idx]        = sort([structArray.name])
    sortedArray    = structArray(idx)
end

