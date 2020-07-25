$0==""{
    counter +=1;
    next;
}
{
    if(counter > newLines)
    {
        print "";
    }
    counter=0;
    print;
}
