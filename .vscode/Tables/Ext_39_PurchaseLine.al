tableextension 50014 Ext_PurchaseLine extends "Purchase Line"
{
    fields
    {
        field(50001; "Receiving Location"; Code[10])
        {
            Description = 'Deepak';
            TableRelation = Location.Code WHERE ("Use As In-Transit" = CONST (false), "Available in Purchase" = CONST (true));

            trigger OnValidate()
            begin
                IF Type = Type::Item THEN BEGIN
                    QASetup.GET();
                    QAItem.GET("No.");
                    IF QAItem."QA Enable" THEN
                        "Location Code" := QASetup."Quality Inspection Location"
                    ELSE
                        "Location Code" := "Receiving Location";
                END;
            end;
        }
        field(50006; ORIGIN; Code[20])
        {
            Description = 'Deepak';
            Editable = true;
        }
        field(50007; MILL; Code[20])
        {
            Description = 'Deepak';
            Editable = true;
        }
        field(50010; "Plate Item"; Boolean)
        {
            Description = 'Deepak';
        }
        field(50011; "Purch. Rcpt No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50012; "Purch. Rcpt. Line No."; Integer)
        {
            Description = 'Deepak';
        }
        field(50501; "Short Closed Document"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50502; "Short Closed Quantity"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50503; "Short Closed Amount"; Decimal)
        {
            Description = 'Deepak';
        }
        field(60002; "QA Enabled"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(62000; Paper; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(62001; "Paper Type"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(62002; "Paper GSM"; Code[30])
        {
            Description = 'Deepak';

        }
        field(62006; "FSC Category"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(64000; "For Location Roll Entry"; Option)
        {
            Description = 'Deepak';
            OptionCaption = 'Mother,Child';
            OptionMembers = Mother,Child;
        }
        field(64002; "Line Ref. No"; Integer)
        {
            Description = 'Deepak';
        }
        field(64003; "Roll Quantity to Receive"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Purchase Line"."Qty. to Receive" WHERE ("Document Type" = FIELD ("Document Type"),
            "Document No." = FIELD ("Document No."),
            "Line Ref. No" = FIELD ("Line No.")));
            Description = 'Deepak';
            Editable = false;

        }
        field(64004; "No of Roll to Recive"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("Purchase Line" WHERE ("Document Type" = FIELD ("Document Type"),
            "Document No." = FIELD ("Document No."),
            "Line Ref. No" = FIELD ("Line No."),
            "Qty. to Receive" = FILTER (<> 0)));
            Description = 'Deepak';
            Editable = false;

        }
        field(64005; "Requisition No."; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Requisition Header"."Requisition No.";
        }
    }

    trigger OnDelete()
    begin
        // Lines added BY Deepak Kumar
        RollMaster.RESET;
        RollMaster.SETRANGE(RollMaster."Document No.", "Document No.");
        RollMaster.SETRANGE(RollMaster."Document Line No.", "Line No.");
        RollMaster.SETRANGE(RollMaster.Status, RollMaster.Status::" ");
        IF RollMaster.FINDFIRST THEN
            RollMaster.DELETEALL(TRUE);
    end;

    var

        QASetup: Record "Manufacturing Setup";
        QAItem: Record Item;
        Question: Text[150];
        Answer: Boolean;
        RollMaster: Record "Item Variant";
}