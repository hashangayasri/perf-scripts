BEGIN{OFS=FS="\t"}
{
    rowKey = $1;
    if(truncateKey != "")
        $1 = "";
    if(!(rowKey in rowDef)){
        rowDef[rowKey] = $0;
        next;
    }
    print rowDef[rowKey];
    print $0;
    printf "\n";
}