function errorExit(e){
    print "!!! ERROR !!! - ", e;
    exit 1;
}

function savePrev(){
    $1 = seq + 1;
    prev = $0;
}

BEGIN{
    OFS=FS="\t";
}
NR == 1{    #can be changed to support multiple sequences seperated by headers
    if(match($1, /[^0-9]/)) #skip header if available
    {
        print;
        initialized = 0;
        next;
    }
}
initialized != 1{
    initialized = 1;
    print;
    seq = $1;
    savePrev();
    next;
}
{
    ++seq;
    if($1 == seq){
        print;
    }
    else if($1 >  seq){  #missing
        print prev; #repeat previous record once
        recordSeq = $1;
        while(recordSeq >= ++seq){
            $1 = seq;
            print;  #print current record to fill
        }
        --seq;
    }
    else if($1 == seq - 1){ 
        #duplicate #save and drop
        --seq;
    }
    else{
        errorExit("sequence out of order - expected: " seq ", actual: " $1);
    }
    
    savePrev(); #for all
}