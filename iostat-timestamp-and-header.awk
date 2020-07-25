BEGIN{
    RS="\n";
    recordCount=0;
}
$0 ~ /^[0-9]{4}-[0-9]{2}/{
    if(++recordCount <= 1)
        next;
    gsub(/-|T|:/, " ");
    gsub(/\+[0-9]*/, "");
    print "\n\n";
    print "time timestamp";
    print " " mktime($0);
    print "";
    next;
}
{
    if(recordCount <= 1)
        next;
    print;
}
