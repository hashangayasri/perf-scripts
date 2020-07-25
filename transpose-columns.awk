
function errorExit(e){
    print "!!! ERROR !!! - ", e;
    exit 1;
}

BEGIN{
    FS="\t";
    recordHeader[0] = "";
    concatSeperator = "::";
}

$0 == ""{
    newRecord=1;
    print "";
    next;
}
newRecord == 1 && $0 != ""{
    split($0, recordHeader, FS);
    newRecord = 0;
    next;
}
{
    headerPrefix = "";
    if(length($1) > 0)
        headerPrefix = $1 concatSeperator;
    if(NF == length(recordHeader)){
        for(i = 2; i <= NF; i++) {
             print headerPrefix recordHeader[i] FS $i; 
        }
    }else{
        errorExit("record length mismatch: " NF " != " length(recordHeader) " in " $0);
    }
}
