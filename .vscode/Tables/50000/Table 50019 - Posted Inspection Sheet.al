table 50019 "Posted Inspection Sheet"
{
    // version Samadhan Quality


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Transfer,Output,Sales Shipment';
            OptionMembers = Transfer,Output,"Sales Shipment";
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Document Line No."; Integer)
        {
        }
        field(5; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date';
        }
        field(6; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date';
        }
        field(7; "Vendor No./Customer No."; Code[20])
        {
            CaptionML = ENU = 'Vendor No./Customer No.';
        }
        field(13; "Item No."; Code[20])
        {
            CaptionML = ENU = 'Item No.';
            TableRelation = Item;
        }
        field(14; "Item Description"; Text[250])
        {
            CaptionML = ENU = 'Item Description';
        }
        field(15; Quantity; Decimal)
        {
            CaptionML = ENU = 'Quantity';
        }
        field(16; "Spec ID"; Code[20])
        {
            CaptionML = ENU = 'Spec ID';
            TableRelation = Item."Search Description";
        }
        field(17; "No. Series"; Code[20])
        {
            CaptionML = ENU = 'No. Series';
        }
        field(22; "Created By"; Code[50])
        {
            CaptionML = ENU = 'Created By';
            TableRelation = User;
        }
        field(23; "Created Date"; Date)
        {
            CaptionML = ENU = 'Created Date';
        }
        field(24; "Created Time"; Time)
        {
            CaptionML = ENU = 'Created Time';
        }
        field(25; "Posted Date"; Date)
        {
            CaptionML = ENU = 'Posted Date';
        }
        field(26; "Posted Time"; Time)
        {
            CaptionML = ENU = 'Posted Time';
        }
        field(27; "Posted By"; Code[100])
        {
            CaptionML = ENU = 'Posted By';
            TableRelation = User;
        }
        field(29; "Inspection Receipt No."; Code[20])
        {
            CaptionML = ENU = 'Inspection Receipt No.';
        }
        field(30; "Item Type"; Option)
        {
            OptionCaption = 'Box,Board,Both';
            OptionMembers = Box,Board,Both;
        }
        field(41; "Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(43; "Qty. per Unit of Measure"; Decimal)
        {
            CaptionML = ENU = 'Qty. per Unit of Measure';
        }
        field(50; "Prod. Order No."; Code[20])
        {
            CaptionML = ENU = 'Prod. Order No.';
            TableRelation = "Production Order"."No." WHERE (Status = FILTER (Released));
        }
        field(51; "Prod. Order Line No."; Integer)
        {
            CaptionML = ENU = 'Prod. Order Line';
        }
        field(52; "Routing No."; Code[20])
        {
            CaptionML = ENU = 'Routing No.';
        }
        field(53; "Routing Reference No."; Integer)
        {
            CaptionML = ENU = 'Routing Reference No.';
        }
        field(54; "Operation No."; Code[20])
        {
            CaptionML = ENU = 'Operation No.';
        }
        field(55; "Prod. Description"; Text[100])
        {
            CaptionML = ENU = 'Prod. Description';
        }
        field(56; "Operation Description"; Text[30])
        {
            CaptionML = ENU = 'Operation Description';
        }
        field(57; "Production Batch No."; Code[20])
        {
            CaptionML = ENU = 'Production Batch No.';
        }
        field(61; "Base Unit of Measure"; Code[10])
        {
            CaptionML = ENU = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(62; "Quantity (Base)"; Decimal)
        {
            CaptionML = ENU = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(1000; "Source Type"; Option)
        {
            OptionCaption = 'Purchase Receipt,Output,Sales Order';
            OptionMembers = "Purchase Receipt",Output,"Sales Order";
        }
        field(1001; "Source Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.';
            NotBlank = true;
        }
        field(1002; "Source Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.';
        }
        field(1003; "QA Characteristic Code"; Code[20])
        {
            CaptionML = ENU = 'Character Code';
            TableRelation = "Quality Parameters".Code;
        }
        field(1004; "QA Characteristic Description"; Text[50])
        {
            CaptionML = ENU = 'Description';
        }
        field(1006; "Normal Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Normal Value (Num)';
            DecimalPlaces = 0 : 5;
        }
        field(1007; "Min. Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Min. Value (Num)';
            DecimalPlaces = 0 : 5;
        }
        field(1008; "Max. Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Max. Value (Num)';
            DecimalPlaces = 0 : 5;
        }
        field(1009; "Actual Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Actual Value (Num)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                /*
                IF "Actual Value (Num)" <> 0 THEN BEGIN
                  TESTFIELD("Character Type","Character Type" :: "0");
                  TESTFIELD(Qualitative,FALSE);
                END;
                
                IF ("Normal Value (Text)" = '') AND ("Min. Value (Text)" = '') AND ("Max. Value (Text)" = '') THEN
                  IF ("Actual Value (Num)" <= "Max. Value (Num)") AND ("Actual Value (Num)" >= "Min. Value (Num)")  THEN BEGIN
                    IF ("Normal Value (Num)"<>0.0) AND ("Max. Value (Num)"<>0.0)  THEN
                      Accept := TRUE
                    ELSE
                      Accept := FALSE;
                  END ELSE
                    Accept := FALSE;
                
                IF "Actual Value (Num)" = 0 THEN
                  Accept  := FALSE;
                
                */

            end;
        }
        field(1010; "Normal Value (Text)"; Code[20])
        {
            CaptionML = ENU = 'Normal Value (Text)';
        }
        field(1011; "Min. Value (Text)"; Code[20])
        {
            CaptionML = ENU = 'Min. Value (Text)';
        }
        field(1012; "Max. Value (Text)"; Code[20])
        {
            CaptionML = ENU = 'Max. Value (Text)';
        }
        field(1013; "Actual  Value (Text)"; Code[20])
        {
            CaptionML = ENU = 'Actual  Value (Text)';

            trigger OnValidate()
            begin
                /*
                IF "Actual  Value (Text)" <> '' THEN BEGIN
                  TESTFIELD("Character Type","Character Type" :: "0");
                  TESTFIELD(Qualitative,TRUE);
                END;
                */

            end;
        }
        field(1014; "Unit of Measure"; Code[20])
        {
            CaptionML = ENU = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(1022; "Reason Code"; Code[20])
        {
            CaptionML = ENU = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(1023; Remarks; Text[250])
        {
            CaptionML = ENU = 'Remarks';
            Description = '//firoz length 250';
        }
        field(1024; "Inspection Persons"; Text[100])
        {
            CaptionML = ENU = 'Inspection Persons';
        }
        field(1027; Qualitative; Boolean)
        {
            CaptionML = ENU = 'Qualitative';
        }
        field(1028; "Roll No"; Code[20])
        {
        }
        field(1029; "Sample Code"; Code[50])
        {
        }
        field(1030; Quantitative; Boolean)
        {
        }
        field(1031; "Sequence No"; Integer)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(2000; "Paper Type"; Code[20])
        {
            TableRelation = "Material / Process Link Code".Description WHERE (Code = FILTER ('PAPERTYPE'));
        }
        field(2001; "Paper GSM"; Code[20])
        {
            TableRelation = "Material / Process Link Code".Description WHERE (Code = FILTER ('PAPERGSM'));
        }
        field(3001; "Observation 1 (Num)"; Decimal)
        {
            MinValue = 0;
        }
        field(3002; "Observation 2 (Num)"; Decimal)
        {
            MinValue = 0;
        }
        field(3003; "Observation 3 (Num)"; Decimal)
        {
            MinValue = 0;
        }
        field(3004; "Observation 4 (Num)"; Decimal)
        {
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; "Inspection Receipt No.", "Item No.", "QA Characteristic Code")
        {
        }
        key(Key2; "Sequence No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('');
    end;
}

