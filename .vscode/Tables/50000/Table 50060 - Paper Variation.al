table 50060 "Paper Variation"
{
    // version Prod. Variation

    CaptionML = ENU = 'Paper Variation';
    DrillDownPageID = "Paper Variation";
    LookupPageID = "Paper Variation";

    fields
    {
        field(1; "Production Order"; Code[50])
        {
            CaptionML = ENU = 'Code';
            Editable = false;
            NotBlank = true;
        }
        field(2; "Prod. Order Line"; Integer)
        {
            CaptionML = ENU = 'Prod. Order Line';
            Editable = false;
        }
        field(3; "Paper Position"; Option)
        {
            CaptionML = ENU = 'Paper Position';
            Editable = false;
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(50001; "Planed GSM"; Decimal)
        {
            Editable = false;
        }
        field(50002; "Actual Avg. GSM"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Variation in GSM"; Decimal)
        {
            Editable = false;
        }
        field(50004; "Planed Deckle Size"; Decimal)
        {
            Editable = false;
        }
        field(50005; "Actual Avg. Deckle Size"; Decimal)
        {
            CalcFormula = Average ("Item Ledger Entry"."Deckle Size (mm)" WHERE ("Entry Type" = CONST (Consumption),
                                                                                "Order Type" = CONST (Production),
                                                                                "Order No." = FIELD ("Production Order"),
                                                                                "Order Line No." = FIELD ("Prod. Order Line"),
                                                                                "Paper Position" = FIELD ("Paper Position")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Variation in Deckle"; Decimal)
        {
            Editable = false;
        }
        field(50007; "Extra Trim"; Decimal)
        {
            Editable = false;
        }
        field(50008; "Expected Consumption Quantity"; Decimal)
        {
            Editable = false;
        }
        field(50009; "Actual Consumption Quantity"; Decimal)
        {
            CalcFormula = - Average ("Item Ledger Entry".Quantity WHERE ("Entry Type" = CONST (Consumption),
                                                                       "Order Type" = CONST (Production),
                                                                       "Order No." = FIELD ("Production Order"),
                                                                       "Order Line No." = FIELD ("Prod. Order Line"),
                                                                       "Paper Position" = FIELD ("Paper Position")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Variation Consumption Quantity"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Production Order", "Prod. Order Line", "Paper Position")
        {
        }
    }

    fieldgroups
    {
    }
}

