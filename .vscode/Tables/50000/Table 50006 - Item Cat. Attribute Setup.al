table 50006 "Item Cat. Attribute Setup"
{
    // version Item Wizard Samadhan


    fields
    {
        field(1;"Item Category Code";Code[20])
        {
            NotBlank = true;
            TableRelation = "Item Category".Code;
        }
        field(2;"Item Attribute";Code[20])
        {
            TableRelation = "Attribute Master"."Attribute Code";
        }
        field(3;"Item Attribute Caption";Text[100])
        {
            CalcFormula = Lookup("Attribute Master"."Attribute Description" WHERE ("Attribute Code"=FIELD("Item Attribute")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Sorting Order";Code[2])
        {
            Numeric = true;
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
        field(12;"Add on Description";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Item Category Code","Item Attribute")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ItemAttribute: Record "Attribute Master";
        ItemCategoryCode: Record "Item Category";
        "Item attribute entry": Record "Item Attribute Entry";
}

