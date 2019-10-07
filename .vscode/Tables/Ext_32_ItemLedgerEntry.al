tableextension 50010 Ext_ItemLedgerEntry extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "Requisition No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50001; "Requisition Line No."; Integer)
        {
            Description = 'Deepak';
        }
        field(50002; "Origin Purch. Rcpt No."; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(50003; "Origin Purch. Rcpt L No."; Integer)
        {
            Description = 'Deepak';
        }
        field(50011; "Final Location"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = Location;
        }
        field(50012; "Prod. Order (Sale)"; Code[40])
        {
            Description = 'Deepak';
        }
        field(50013; "Paper Position"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(50014; "Quantity In PCS"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50015; "Make Ready Qty"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50016; "Item Weight"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50018; "Custom's Reference No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Purch. Rcpt. Header"."Custom's Reference No." WHERE ("No." = FIELD ("Document No.")));
            Description = 'Deepak';
            Editable = true;

        }
        field(50019; "Additional Output"; Boolean)
        {
            Description = 'Deepak';
        }
        field(50020; "Currency Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Purch. Rcpt. Header"."Currency Code" WHERE ("No." = FIELD ("Document No."),
            "Buy-from Vendor No." = FIELD ("Source No.")));
            Description = 'Deepak';

        }
        field(50021; "Paper Type"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50022; "Paper GSM"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50023; "Deckle Size (mm)"; Decimal)
        {
            Description = 'Deepak';
            Editable = true;
            MinValue = 0;
        }
        field(50024; ORIGIN; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50029; "Duplex Length"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50030; "Duplex Width"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50031; "Subcontracting Order No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50032; "Schedule Doc. No."; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Production Schedule"."Schedule No."
            WHERE ("Schedule Published" = CONST (true), "Schedule Closed" = CONST (false));
        }
        field(50033; "Standard Output Weight"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50034; "Actual Output Weight"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50036; "Scrap Code"; Code[20])
        {
            Description = '//Firoz 16-07-16';
        }
        field(50039; "Mark for Re-Application"; Boolean)
        {
            Description = 'Binay 01/12/17';
        }
        field(50040; "Cost Amount (Actual) Sam"; Decimal)
        {
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = Sum ("Value Entry"."Cost Amount (Actual)"
            WHERE ("Item Ledger Entry No." = FIELD ("Entry No."),
            "Posting Date" = FIELD ("Date Filter")));
            CaptionML = ENU = 'Cost Amount (Actual)1';
            Description = 'Deepak';
            Editable = false;

        }
        field(50041; "Date Filter"; Date)
        {
            Description = 'Deepak';
            FieldClass = FlowFilter;
        }
        field(50042; "Entry Type D"; Option)
        {
            CaptionML = ENU = 'Entry Type D';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        }
        field(50043; "Exception D"; Boolean)
        {
        }
        field(50044; "Transfer From Entry No D"; Integer)
        {
        }
        field(50045; "OutBound Entry No"; Integer)
        {
        }
        field(50046; "Other Consumption Type"; Option)
        {
            OptionCaption = ' ,Other Consumption,Negative Adjustment';
            OptionMembers = " ","Other Consumption","Negative Adjustment";
        }
        field(50047; "Salesperson Code"; Code[10])
        {
            CaptionML = ENU = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50048; "Sales Order No."; Code[20])
        {
        }
        field(50049; "Cost per Unit"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = Lookup ("Value Entry"."Cost per Unit" WHERE ("Item Ledger Entry No." = FIELD ("Entry No.")));
            AutoFormatType = 2;
        }
        field(50050; "Take Up"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50051; "Flute Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,A,B,C,E,F';
            OptionMembers = " ",A,B,C,E,F;
        }
        field(50052; "Old Production Order No."; code[20])
        {
            Editable = false;
        }
        field(50053; "Old Prod. Order Line No."; Integer)
        {
            Editable = false;
        }
        field(50054; "Old Prod. Order Item No."; Code[20])
        {
            Editable = false;
        }
        field(62001; "Employee Code"; Code[20])
        {
            Description = '//deepak';
            TableRelation = "Employee_B2B"."No.";

        }
        field(62002; "Employee Name"; Text[150])
        {
            Description = '//deepak';
            Editable = false;
        }

    }

    keys
    {
        key(Key21; "Deckle Size (mm)", "Paper Type", "Paper GSM")
        {
        }
        key(Key22; "Paper Type")
        {
        }
        key(Key23; "Requisition No.")
        {

        }
        key(Key25; "Paper GSM")
        { }
    }
}