table 50044 "Schedule Base Table 1"
{
    // version Prod. Schedule


    fields
    {
        field(1; "Schedule No."; Code[50])
        {
        }
        field(2; "Deckle Size"; Code[50])
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
        field(10; "Deckle Size(Num)"; Decimal)
        {
        }
        field(20; "No. of Jobs(Within Trimlimit)"; Integer)
        {
            CalcFormula = Count ("Production Schedule Line" WHERE ("Schedule No." = FIELD ("Schedule No."),
                                                                  "Deckle Size Schedule(mm)" = FIELD ("Deckle Size"),
                                                                  Possible = CONST (true)));
            FieldClass = FlowField;
        }
        field(21; "No. of Jobs(Outside TrimLimit)"; Integer)
        {
            CalcFormula = Count ("Production Schedule Line" WHERE ("Schedule No." = FIELD ("Schedule No."),
                                                                  "Deckle Size Schedule(mm)" = FIELD ("Deckle Size"),
                                                                  Possible = CONST (false)));
            FieldClass = FlowField;
        }
        field(22; "Marked for Publish"; Integer)
        {
            CalcFormula = Count ("Production Schedule Line" WHERE ("Schedule No." = FIELD ("Schedule No."),
                                                                  "Deckle Size Schedule(mm)" = FIELD ("Deckle Size"),
                                                                  "Marked for Publication" = FILTER (true)));
            FieldClass = FlowField;
        }
        field(23; "No. of Flute Change"; Integer)
        {
        }
        field(24; "No Of Job(Internal)"; Integer)
        {
        }
        field(25; "Force Marked for Publish"; Integer)
        {
            CalcFormula = Count ("Production Schedule Line" WHERE ("Schedule No." = FIELD ("Schedule No."),
                                                                  "Deckle Size Schedule(mm)" = FIELD ("Deckle Size"),
                                                                  "Marked for Publication" = FILTER (true),
                                                                  Possible = FILTER (false)));
            FieldClass = FlowField;
        }
        field(50; "Priority by System"; Integer)
        {
            Editable = false;
        }
        field(51; "Select for Publish"; Boolean)
        {
        }
        field(52; "Prod. Order Number"; Code[50])
        {
        }
        field(53; "Prod. Order Line No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Schedule No.", "Deckle Size")
        {
        }
        key(Key2; "No Of Job(Internal)")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AttributeValue: Record "Attribute Value";
}

