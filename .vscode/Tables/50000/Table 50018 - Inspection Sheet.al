table 50018 "Inspection Sheet"
{
    // version Samadhan Quality


    fields
    {
        field(1; "Source Type"; Option)
        {
            CaptionML = ENU = 'Source Type';
            NotBlank = true;
            OptionCaption = 'Purchase Receipt,Output,Sales Order,Open';
            OptionMembers = "Purchase Receipt",Output,"Sales Order",Open;
        }
        field(2; "Source Document No."; Code[20])
        {
            CaptionML = ENU = 'Source Document No.';
            Editable = false;
        }
        field(3; "Entry No."; Integer)
        {
            AutoIncrement = true;
            InitValue = 0;
        }
        field(4; "Source Document Line No."; Integer)
        {
            CaptionML = ENU = 'Source Document Line No.';
            Editable = false;
        }
        field(5; "Inspection No."; Code[20])
        {
        }
        field(6; "Document Date"; Date)
        {
            CaptionML = ENU = 'Document Date';
        }
        field(13; "Item No."; Code[20])
        {
            CaptionML = ENU = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(14; "Item Description"; Text[250])
        {
            CaptionML = ENU = 'Item Description';
            Editable = false;
        }
        field(16; "Spec ID"; Code[20])
        {
            CaptionML = ENU = 'Spec ID';
            Editable = false;
        }
        field(22; "Created By"; Code[50])
        {
            CaptionML = ENU = 'Created By';
            Editable = false;
            TableRelation = User;
        }
        field(23; "Created Date"; Date)
        {
            CaptionML = ENU = 'Created Date';
            Editable = false;
        }
        field(24; "Created Time"; Time)
        {
            CaptionML = ENU = 'Created Time';
            Editable = false;
        }
        field(30; "Item Type"; Option)
        {
            OptionCaption = 'Box,Board,Both';
            OptionMembers = Box,Board,Both;
        }
        field(41; "Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(43; "Qty. per Unit of Measure"; Decimal)
        {
            CaptionML = ENU = 'Qty. per Unit of Measure';
            Editable = false;
        }
        field(50; "Prod. Order No."; Code[20])
        {
            CaptionML = ENU = 'Prod. Order No.';
            Editable = false;
            TableRelation = "Production Order"."No." WHERE (Status = FILTER (<> Finished));
        }
        field(51; "Prod. Order Line No."; Integer)
        {
            CaptionML = ENU = 'Prod. Order Line';
            TableRelation = "Prod. Order Line"."Line No." WHERE ("Prod. Order No." = FIELD ("Prod. Order No."));
        }
        field(52; "Routing No."; Code[20])
        {
            CaptionML = ENU = 'Routing No.';
            Editable = false;
            TableRelation = "Routing Header"."No.";
        }
        field(53; "Routing Reference No."; Integer)
        {
            CaptionML = ENU = 'Routing Reference No.';
            Editable = false;
        }
        field(54; "Operation No."; Code[20])
        {
            CaptionML = ENU = 'Operation No.';
            Editable = false;
        }
        field(55; "Prod. Description"; Text[30])
        {
            CaptionML = ENU = 'Prod. Description';
            Editable = false;
        }
        field(56; "Operation Description"; Text[30])
        {
            CaptionML = ENU = 'Operation Description';
            Editable = false;
        }
        field(57; "Production Batch No."; Code[20])
        {
            CaptionML = ENU = 'Production Batch No.';
            Editable = false;
        }
        field(61; "Base Unit of Measure"; Code[10])
        {
            CaptionML = ENU = 'Base Unit of Measure';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(62; "Quantity (Base)"; Decimal)
        {
            CaptionML = ENU = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(1003; "QA Characteristic Code"; Code[20])
        {
            CaptionML = ENU = 'Character Code';
            Editable = false;
            TableRelation = "Quality Parameters".Code;
        }
        field(1004; "QA Characteristic Description"; Text[50])
        {
            CaptionML = ENU = 'Description';
            Editable = false;
        }
        field(1006; "Normal Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Normal Value (Num)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1007; "Min. Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Min. Value (Num)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1008; "Max. Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Max. Value (Num)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1009; "Actual Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Actual Value (Num)';
            DecimalPlaces = 0 : 5;
            Description = 'Please do not make editable';
            Editable = false;

            trigger OnLookup()
            begin
                //TESTFIELD(Qualitative,FALSE);
            end;

            trigger OnValidate()
            begin
                /*
                IF "Actual Value (Num)" <> 0 THEN BEGIN
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

                if "Actual  Value (Text)" <> '' then begin
                    TestField(Qualitative, true);
                end;
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
        }
        field(1023; Remarks; Text[250])
        {
            CaptionML = ENU = 'Remarks';
        }
        field(1024; "Inspection Persons"; Text[100])
        {
            CaptionML = ENU = 'Inspection Persons';
        }
        field(1027; Qualitative; Boolean)
        {
            CaptionML = ENU = 'Qualitative';
            Editable = false;
        }
        field(1028; "Roll Number"; Code[20])
        {
            TableRelation = "Attribute Master"."Attribute Description";
            // WHERE ("Modification Date and Time"=FIELD("Source Document No."),
            //                                                                   Field50013=FIELD("Paper Type"),
            //                                                                   Field50014=FIELD("Paper GSM"));
        }
        field(1029; "Sample Code"; Code[50])
        {
            Editable = false;
        }
        field(1030; Quantitative; Boolean)
        {
            Editable = false;
        }
        field(1031; "Sequence No"; Integer)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(2000; "Paper Type"; Code[20])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code" = FILTER ('PAPERTYPE'));
        }
        field(2001; "Paper GSM"; Code[20])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code" = FILTER ('PAPERGSM'));
        }
        field(3001; "Observation 1 (Num)"; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                UpdateActualValue;
            end;
        }
        field(3002; "Observation 2 (Num)"; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                UpdateActualValue;
            end;
        }
        field(3003; "Observation 3 (Num)"; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                UpdateActualValue;
            end;
        }
        field(3004; "Observation 4 (Num)"; Decimal)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                UpdateActualValue;
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Source Type", "Source Document No.", "Source Document Line No.")
        {
        }
        key(Key3; "Sample Code", "QA Characteristic Code")
        {
        }
        key(Key4; "Sequence No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        TempValue: array[5] of Integer;

    procedure UpdateActualValue()
    begin
        // Lines added by Deepak Kumar

        TempValue[1] := 0;
        TempValue[2] := 0;
        TempValue[3] := 0;
        TempValue[4] := 0;

        if "Observation 1 (Num)" <> 0 then begin
            TempValue[1] := 1;
        end;
        if "Observation 2 (Num)" <> 0 then begin
            TempValue[2] := 1;
        end;
        if "Observation 3 (Num)" <> 0 then begin
            TempValue[3] := 1;
        end;
        if "Observation 4 (Num)" <> 0 then begin
            TempValue[4] := 1;
        end;
        TempValue[5] := TempValue[1] + TempValue[2] + TempValue[3] + TempValue[4];

        "Actual Value (Num)" := ("Observation 1 (Num)" + "Observation 2 (Num)" + "Observation 3 (Num)" + "Observation 4 (Num)") / TempValue[5];
    end;
}

