table 50062 "Production Variation Report"
{
    // version Prod. Variation

    CaptionML = ENU = 'Production Variation Report';

    fields
    {
        field(1; "Prod. Order No."; Code[50])
        {
            CaptionML = ENU = 'Code';
            Editable = false;
            NotBlank = true;
        }
        field(2; "Prod. Order Line No."; Integer)
        {
            CaptionML = ENU = 'Description';
            Editable = false;
        }
        field(50001; "Item Code"; Code[50])
        {
            Editable = false;
        }
        field(50002; "Item Description"; Text[250])
        {
            Editable = false;
        }
        field(50003; "LPO No."; Code[50])
        {
            Editable = false;
        }
        field(50004; "Customer Code"; Code[50])
        {
            Editable = false;
        }
        field(50005; "Customer Name"; Text[250])
        {
            Editable = false;
        }
        field(50006; "Product Design Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;
        }
        field(50007; "Product Design No."; Code[50])
        {
            Editable = false;
        }
        field(50008; "Sub Comp No."; Code[20])
        {
            Editable = false;
        }
        field(50009; "Job Creation Date"; Date)
        {
            Editable = false;
        }
        field(50010; "Order Quantity"; Decimal)
        {
        }
        field(50011; "Board Order Quantity"; Decimal)
        {
        }
        field(50012; "Finished Order Quantity"; Decimal)
        {
        }
        field(50013; "Variation in Produces Quantity"; Decimal)
        {
            Editable = false;
        }
        field(60001; "Customer Weight (Kg)"; Decimal)
        {
            Editable = false;
        }
        field(60002; "Planed Weight (Kg)"; Decimal)
        {
            Editable = false;
        }
        field(60003; "Actual Weight (Kg)"; Decimal)
        {
            CalcFormula = - Sum ("Item Ledger Entry".Quantity WHERE ("Entry Type" = CONST (Consumption),
                                                                   "Order Type" = CONST (Production),
                                                                   "Order No." = FIELD ("Prod. Order No."),
                                                                   "Order Line No." = FIELD ("Prod. Order Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60004; "Variation Planed vs Actual (%)"; Decimal)
        {
            Editable = false;
        }
        field(60005; "Planed Cost Process (Amt)"; Decimal)
        {
            Editable = false;
        }
        field(60006; "Planed Cost Material (Amt)"; Decimal)
        {
            Editable = false;
        }
        field(60007; "Actual Cost Process (Amt)"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Cost Amount (Actual)" WHERE ("Item Ledger Entry No." = CONST (0),
                                                                          "Order Type" = CONST (Production),
                                                                          "Order No." = FIELD ("Prod. Order No."),
                                                                          "Order Line No." = FIELD ("Prod. Order Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60008; "Actual Cost Material (Amt)"; Decimal)
        {
            CalcFormula = - Sum ("Value Entry"."Cost Amount (Actual)" WHERE ("Item Ledger Entry Type" = CONST (Consumption),
                                                                           "Order Type" = CONST (Production),
                                                                           "Order No." = FIELD ("Prod. Order No."),
                                                                           "Order Line No." = FIELD ("Prod. Order Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60009; "Variation in Cost (%)"; Decimal)
        {
            Editable = false;
        }
        field(60010; "Scrap Weight (Kg)"; Decimal)
        {
            Editable = false;
        }
        field(60011; "Scrap Quantity"; Decimal)
        {
            Editable = false;
        }
        field(60012; "From Date"; Date)
        {
        }
        field(60013; "To Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Prod. Order No.", "Prod. Order Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;
}

