function getTimePrefix(){
    if(length(timePrf) == 0){
        timePrf = strftime("%Y %m %d ", systime());
        if(length(dPref) != 0)
            timePrf = dPref " "; # override date
    }
    return timePrf;
}

function printEpochTime(time){
    #system("date -d "time" +%s"); # same result
    gsub(":", " ", time);
    print(mktime(getTimePrefix() time));
}

function errorExit(e){
    print "!!! ERROR !!! - ", e;
    exit 1;
}

function readHeader(){
    if(headerProcessed != 1 ){
        split(capturedFields, requiredColumns, "\t");
        for (c in requiredColumns)
            requiredColumnIndex[requiredColumns[c]] = c;
        for(i = 1; i <= NF; i++)
            if($i in requiredColumnIndex)
                column[$i] = i;
        headerProcessed = 1;
    }

    if(validateAllHeaders == 1)
        for(c in column)
            if(c != $(column[c]))
                errorExit("expected column: " c ", got: " $(column[c]));
}

function printDetails(name){
    for(c in column){
        printf("%s%s%s\t%s", name, headerSeperator, c, $(column[c]));
        print("");
    }
}

BEGIN{
    if(length(capturedFields) == 0)
        capturedFields="%CPU";  #tab separated
    headerSeperator="-";
    validateAllHeaders=1;
    split(args, argsa, "\t");
    for(i = 1; i < length(args); i+=2){
        pattern = argsa[i + 1];
        if(pattern == "-")
            pattern = argsa[i];
        if(pattern != "")
            monitored[pattern] = argsa[i];
    }
}
$1 ~ /^[0-9]/{
    #matched=false;
    for(pattern in monitored){
        if(match($0, pattern)){
            printDetails(monitored[pattern]);        
            next;
        }
    }
    printDetails("Unmonitored");

}
$1 == "top" && $2 == "-"{
    printf "\ntimestamp\t";
    printEpochTime($3);
    next;
}
$1 == "PID" {
    readHeader();
}
END{

}
