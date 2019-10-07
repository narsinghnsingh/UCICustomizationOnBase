table 50009 "Item Attribute Entry"
{
    // version Item Wizard Samadhan


    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Item Category Code";Code[10])
        {
        }
        field(3;"Item Attribute Code";Code[30])
        {
        }
        field(4;"Item Attribute Value";Code[250])
        {
            TableRelation = IF ("Item Attribute Code"=FILTER('CUSTOMER')) Customer."No." WHERE (Blocked=FILTER(" "))
                            ELSE IF ("Item Attribute Code"=FILTER('GROUP')) "Product Group".Code
                            ELSE IF ("Item Attribute Code"=FILTER(<>'CUSTOMER'),
                                     "Item Attribute Code"=FILTER(<>'GROUP')) "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=FIELD("Item Attribute Code"));
        }
        field(5;"Item No.";Code[20])
        {
        }
        field(6;"User ID";Code[30])
        {
        }
        field(8;ItemCode;Code[50])
        {
        }
        field(10;"Modified By";Text[200])
        {
        }
        field(11;"Item Category UID";Code[10])
        {
        }
        field(12;"Attribute UID";Code[10])
        {
        }
        field(13;"Attribute Value UID";Code[10])
        {
        }
        field(14;"Value Exits";Boolean)
        {
            CalcFormula = Exist("Attribute Value" WHERE ("Attribute Value"=FIELD("Item Attribute Value")));
            FieldClass = FlowField;
        }
        field(15;"Item Attribute Value NUm";Decimal)
        {
            CalcFormula = Lookup("Attribute Value"."Attribute Value Numreric" WHERE ("Attribute Code"=FIELD("Item Attribute Code"),
                                                                                     "Attribute Value"=FIELD("Item Attribute Value")));
            FieldClass = FlowField;
        }
        field(16;"Add on Des. (Postfix)";Code[10])
        {
        }
        field(17;"Add on Des. (Prefix)";Code[10])
        {
        }
        field(18;"Add on Description";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

