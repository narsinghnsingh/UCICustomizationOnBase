table 50027 "Quality Type"
{
    // version Samadhan Quality


    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = 'Purchase Receipt,Output,Sales Order';
            OptionMembers = "Purchase Receipt",Output,"Sales Order";
        }
        field(2;"Document No.";Code[30])
        {
        }
        field(3;"Paper Type";Code[20])
        {
        }
        field(4;"Paper GSM";Code[20])
        {
        }
        field(5;"Document Line No.";Integer)
        {
        }
        field(6;"Item Code";Code[50])
        {
            Editable = false;
        }
        field(7;"Item Description";Text[250])
        {
            Editable = false;
        }
        field(8;Quantity;Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Document Line No.","Paper Type","Paper GSM")
        {
        }
    }

    fieldgroups
    {
    }
}

