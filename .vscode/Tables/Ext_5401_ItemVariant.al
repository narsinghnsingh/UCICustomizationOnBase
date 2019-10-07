tableextension 50042 Ext_ItemVariant extends "Item Variant"
{
    fields
    {
        field(50001; "Document No."; Code[20])
        {
        }
        field(50002; "Document Line No."; Integer)
        {
        }
        field(50003; "Roll Weight"; Decimal)
        {
        }
        field(50004; Remarks; Text[100])
        {
        }
        field(50005; Status; Option)
        {
            Editable = true;
            OptionCaption = ' ,PendingforQA,Open,Closed';
            OptionMembers = " ",PendingforQA,Open,Closed;
        }
        field(50006; "Initial Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(50007; Accepted; Boolean)
        {

            trigger OnValidate()
            var
                Item: Record 27;
                InspectionSheet: Record 50018;
            begin
                // Lines added BY Deepak Kumar
                Item.RESET;
                IF Item.GET("Item No.") THEN BEGIN
                    InspectionSheet.RESET;
                    InspectionSheet.SETRANGE(InspectionSheet."Source Type", InspectionSheet."Source Type"::"Purchase Receipt");
                    InspectionSheet.SETRANGE(InspectionSheet."Source Document No.", "Purchase Receipt No.");
                    InspectionSheet.SETRANGE(InspectionSheet."Paper Type", Item."Paper Type");
                    InspectionSheet.SETRANGE("Paper GSM", FORMAT(Item."Paper GSM"));
                    IF NOT InspectionSheet.FINDFIRST THEN
                        ERROR('You must update item inspection values for Paper type %1 and Paper GSM %2', "Paper Type", "Paper GSM");
                END;

                TestField("Acpt. Under Dev.", false);
            end;
        }
        field(50008; "Select for Purch. Return"; Boolean)
        {
        }
        field(50011; Origin; Code[20])
        {
            Editable = false;
        }
        field(50012; Suppiler; Code[20])
        {
            Editable = false;
        }
        field(50013; "Paper Type"; Code[20])
        {
        }
        field(50014; "Paper GSM"; Code[20])
        {
        }
        field(50015; "Deckle Size (mm)"; Decimal)
        {
        }
        field(50016; CurrentLocation; Code[20])
        {
            CalcFormula = Lookup ("Item Ledger Entry"."Location Code" WHERE ("Item No." = FIELD ("Item No."),
                                                                            "Variant Code" = FIELD (Code),
                                                                            "Remaining Quantity" = FILTER (<> 0)));
            Description = 'Current Location , as a roll can''t be in two different locations';
            Editable = true;
            FieldClass = FlowField;
            TableRelation = Location;
        }
        field(50017; "Current Entry No."; Integer)
        {
            Description = 'the entry no from whih the last entry will be applied, this is to ensure that roll wise costing is appropriate';
        }
        field(50018; "MILL Reel No."; Code[30])
        {
            Description = '//deepak';
        }
        field(50019; "Roll Inventory"; Decimal)
        {
        }
        field(55001; "Purchase Receipt No."; Code[20])
        {
            Editable = true;
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(55002; "Vendor Shipment No."; Code[35])
        {
            Description = 'updated from purch. rcpt header';
        }
        field(55003; "Purch. Receipt Line No."; Integer)
        {
        }
        field(55004; "Purch. Return Order"; Code[10])
        {
            Description = 'Identifies the Purch. Return Order No against which roll has been returned. // Pulak 10-11-2014';
        }
        field(55005; "Purch. Ret. Ord. LNo."; Integer)
        {
            Description = 'Identifies the Purch. Return Order Line No against which roll has been returned. // Pulak 10-11-2014';
        }
        field(55006; "Purchase Price"; Decimal)
        {
            Description = 'Taken from Purchase Receipt Line on the assumption that the rate of receipt & invoice don''t differ';
        }
        field(56000; "Quality Doc No."; Code[20])
        {
            Description = 'Identifies the Doc No of the transfer entry posted when quality was posted';
        }
        field(56001; "Quality Doc Line No."; Integer)
        {
            Description = 'Identifies the Doc Line No of the transfer entry posted when quality was posted. Pulak 11-11-2014';
        }
        field(56002; "Acpt. Under Dev."; Boolean)
        {

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                TestField(Accepted, false);
            end;
        }
        field(56003; "Acpt. Under Dev. Remark"; Text[50])
        {
        }
        field(56004; "Rejection Remark"; Text[50])
        {
        }
        field(56005; "Location after QA"; Code[20])
        {
            Editable = true;
            TableRelation = Location;
        }
        field(56006; "Ret. Ship Doc No"; Code[10])
        {
            Description = 'Idenitifies the Return Shipment Doc No';
        }
        field(56007; "Ret. Ship Doc Line No."; Integer)
        {
            Description = 'Idenitifies the Return Shipment Doc Line No';
        }
        field(56008; "Select for Consumption"; Boolean)
        {
        }
        field(56009; "Remaining Quantity"; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Item No." = FIELD ("Item No."),
                                                                  "Variant Code" = FIELD (Code),
                                                                  "Posting Date" = FIELD ("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(57001; "Active Variant"; Boolean)
        {
        }
        field(57002; "No of Impression"; Decimal)
        {
        }
        field(57003; "Mother Job No."; Code[20])
        {
        }
        field(57004; "1st Prod. Order  No."; Code[20])
        {
        }
        field(57005; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(57006; "Mill Name"; Text[100])
        {
        }
        field(57007; "Item Category Code"; Code[30])
        {
            TableRelation = "Item Category";
        }
    }
    keys
    {
        key(Key4; "MILL Reel No.")
        {
        }

    }
    fieldgroups
    {
        addlast(DropDown; Code, Description, "Item No.", "MILL Reel No.", "Remaining Quantity", CurrentLocation)
        {

        }
    }


}