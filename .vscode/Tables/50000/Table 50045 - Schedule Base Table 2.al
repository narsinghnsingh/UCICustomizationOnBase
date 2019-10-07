table 50045 "Schedule Base Table 2"
{
    // version Prod. Schedule


    fields
    {
        field(1; "Schedule No."; Code[50])
        {
        }
        field(2; "Deckle Size"; Code[20])
        {

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                AttributeValue.Reset;
                AttributeValue.SetRange(AttributeValue."Attribute Code", 'DeckleSize');
                AttributeValue.SetRange(AttributeValue."Attribute Value", "Deckle Size");
                if AttributeValue.FindFirst then begin
                    "Deckle Size(Num)" := AttributeValue."Attribute Value Numreric";
                end;
            end;
        }
        field(3; "Paper Type"; Code[20])
        {
        }
        field(10; "Deckle Size(Num)"; Decimal)
        {
        }
        field(21; "Avl. in Inventory (kg)"; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Deckle Size (mm)" = FIELD ("Deckle Size(Num)"),
                                                                  "Paper Type" = FIELD ("Paper Type")));
            FieldClass = FlowField;
        }
        field(22; "Total Requirement (kg)"; Decimal)
        {
        }
        field(23; "Prod. Order Number"; Code[50])
        {
        }
        field(24; "Prod. Order Line No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Schedule No.", "Deckle Size", "Paper Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AttributeValue: Record "Attribute Value";
}

