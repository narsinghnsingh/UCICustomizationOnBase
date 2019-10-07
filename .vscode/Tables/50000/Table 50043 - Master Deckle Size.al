table 50043 "Master Deckle Size"
{
    // version Prod. Schedule


    fields
    {
        field(1;"Deckle Size";Code[10])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=CONST('DECKLESIZE'));

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                AttributeValue.Reset;
                AttributeValue.SetRange(AttributeValue."Attribute Code",'DeckleSize');
                AttributeValue.SetRange(AttributeValue."Attribute Value","Deckle Size");
                if AttributeValue.FindFirst then begin
                  "Deckle Size(Num)":=AttributeValue."Attribute Value Numreric";
                end;
            end;
        }
        field(2;"Deckle Size(Num)";Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Deckle Size")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AttributeValue: Record "Attribute Value";
}

