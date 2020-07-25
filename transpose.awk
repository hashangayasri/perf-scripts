
function errorExit(e){
    print "!!! ERROR !!! - ", e;
    exit 1;
}

function aggregateN(a, b){
    return a + b;
}

function aggregate(a, b,    a_,     b_,     s_,     ia_,    ib_){
    ia_ = match(a, /[^0-9.]/);
    if(ia_ == 0){    #does not report errors if 'b' is not numeric when 'a' is numeric
        return aggregateN(a, b);
    }else{
        s_ = substr(a, ia_);
        ib_ = match(b, /[^0-9]/);
        if(substr(b, ib_) != s_)
            errorExit("suffix mismatch: " s_ "->" a ":" b);
        return aggregateN(substr(a, 1, ia_ - 1), substr(b, 1, ib_ - 1));
    }
}

function dumpRecord(rec){
    for(i in rec){recordPresent=1; break;}
    if(recordPresent != 1)
        return;
    if(headerDumped != 1 || emptyRecordsAllowed != 1)   #only an optimization to skip the loop
        for(i = 1; i <= length(idx); ++i){
            if(headerDumped != 1)
                printf "%s\t", idx[i];
            if(emptyRecordsAllowed != 1 && (!(idx[i] in rec)))
                errorExit(idx[i]);
        }
    if(headerDumped != 1 && length(idx)){
        printf "\n";
        headerDumped=1;
    }

    for(i = 1; i <= length(idx); ++i)
        printf "%s\t", rec[idx[i]];
    if(length(idx))
        printf "\n";
        
    delete rec;
}

function indexField(field){
    if(!(field in indexed)){
        if(headerDumped == 1)
            if(newFieldIntroductionAllowed != 1)
                errorExit("new unindexed field found: " field);
                
        headerDumped = 0;

        indexed[field] = 1;
        idx[nextIndex] = field;
        nextIndex++;
    }
}

BEGIN{
    FS="\t";
    nextIndex=1;
    headerDumped=0;
    emptyRecordsAllowed=1;
    newFieldIntroductionAllowed=1;
    split(fields, fieldsa, "\t");
    for(i = 1; i <= length(fieldsa); ++i){
        if(length(fieldsa[i]) > 0)
            indexField(fieldsa[i]);
    }
}
$1 == ""{
        dumpRecord(rec);
        next;
}
{
    if($1 in rec){
        newValue = aggregate(rec[$1], $2);
    }else{
        indexField($1);
        newValue = $2;
    }
    rec[$1] = newValue;
}
END{
    if(length(rec) > 0)
       dumpRecord(rec);
}
