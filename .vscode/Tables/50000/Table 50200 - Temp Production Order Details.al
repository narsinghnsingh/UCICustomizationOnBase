table 50200 "Temp Production Order Details"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
        }
        field(2;"Prod. Order No.";Code[50])
        {
        }
        field(3;"Prod. Order Line No.";Integer)
        {
        }
        field(4;"Paper Position";Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(5;"Expected Quantity";Decimal)
        {
        }
        field(6;"Qty Per";Decimal)
        {
        }
        field(7;"Actual Quantity";Decimal)
        {
        }
        field(8;"ILE Actual Quantity";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE ("Order Type"=CONST(Production),
                                                                  "Order No."=FIELD("Prod. Order No."),
                                                                  "Order Line No."=FIELD("Prod. Order Line No."),
                                                                  "Paper Position"=FIELD("Paper Position"),
                                                                  "Item Category Code"=CONST('PAPER')));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

