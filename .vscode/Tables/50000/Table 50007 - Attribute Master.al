table 50007 "Attribute Master"
{
    // version Item Wizard Samadhan


    fields
    {
        field(1;"Attribute Code";Code[20])
        {
            Editable = true;
            NotBlank = true;
        }
        field(3;"Attribute Description";Text[100])
        {
        }
        field(5;Master;Boolean)
        {
        }
        field(6;"Master List";Option)
        {
            OptionCaption = ' ,Vendor,Product Group Code,Base Unit Of Measure,ItemCrossReference,Model';
            OptionMembers = " ",Vendor,"Product Group Code","Base Unit Of Measure",ItemCrossReference,Model;
        }
        field(7;"Attribute UID";Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(8;"Created by";Code[30])
        {
            Editable = false;
        }
        field(9;"Creation Date and Time";DateTime)
        {
            Editable = false;
        }
        field(10;"Modified By";Code[30])
        {
            Editable = false;
        }
        field(11;"Modification Date and Time";DateTime)
        {
            Editable = false;
        }
        field(12;"Field Type";Option)
        {
            OptionCaption = 'Text ,Numeric ';
            OptionMembers = "Text ","Numeric ";
        }
        field(13;"Suffix Add on Description";Boolean)
        {
        }
        field(14;"Add on Des. (Postfix)";Code[10])
        {
        }
        field(15;"Add on Des. (Prefix)";Code[10])
        {
        }
    }

    keys
    {
        key(Key1;"Attribute Code")
        {
        }
    }

    fieldgroups
    {
    }
}

