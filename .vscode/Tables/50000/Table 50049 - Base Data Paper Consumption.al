table 50049 "Base Data Paper Consumption"
{
    CaptionML = ENU = 'Base Data Paper Consumption';
    DrillDownPageID = "Base Data for Paper Consumptio";
    LookupPageID = "Base Data for Paper Consumptio";

    fields
    {
        field(1;"Requisition No.";Code[50])
        {
            Description = '// Deepak Kumar';
        }
        field(2;"Req. Line Number";Integer)
        {
            Description = '// Deepak Kumar';
        }
        field(3;"Paper Position";Option)
        {
            Description = '// Deepak Kumar';
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(4;"Posting Date";Date)
        {
            Description = '// Deepak Kumar';
        }
        field(5;"Item Code";Code[10])
        {
            Description = '// Deepak Kumar';
        }
        field(6;"Roll ID";Code[10])
        {
            Description = '// Deepak Kumar';
        }
        field(7;"Item Description";Text[250])
        {
            Description = '// Deepak Kumar';
        }
        field(8;Quantity;Decimal)
        {
            Description = '// Deepak Kumar';
        }
        field(9;"Prod. Order No.";Code[10])
        {
            Description = '// Deepak Kumar';
        }
        field(10;"Prod. Order Line No.";Integer)
        {
            Description = '// Deepak Kumar';
        }
        field(11;"Ref Line Number";Integer)
        {
            Description = '// Deepak Kumar';
        }
    }

    keys
    {
        key(Key1;"Requisition No.","Req. Line Number")
        {
        }
    }

    fieldgroups
    {
    }
}

