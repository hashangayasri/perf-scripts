function parseDate(parsedDate, format){ #NOTE: format changes do not invalidate the cache
    if(parsedDate != _cache_parsedDate){
        dateCmd = "date -d \"" parsedDate "\" \"+" format "\"";
        _cache_parsedDate = parsedDate;
        dateCmd | getline _cache_parsedDateResult;
        close(dateCmd);
    }
    return _cache_parsedDateResult;
}

function parseDateDMY(parsedDate){
    return parseDate(parsedDate, "%Y %m %d");
}

BEGIN{
    OFS=FS="\t";
    if(length(descriptions) > 0)
        printf "" > descriptions;   # truncate file
}
$1 == "ZZZZ" && $3 == "Time" && $4 == "Date"{
    next;
}
$1 == "ZZZZ"{

    print "\n\n";
    print "time\ttimestamp";
    gsub(/:/, " ", $3);
    print(OFS OFS mktime(parseDateDMY($4) " " $3));
    print "";
    next;
}
{
    if(length(descriptions) > 0 && (!($1 in printed))){
            printed[$1] = $2;
            print $1 FS $2 >> descriptions;
    }

    $2=$1;
    $1="";
    print $0;
}