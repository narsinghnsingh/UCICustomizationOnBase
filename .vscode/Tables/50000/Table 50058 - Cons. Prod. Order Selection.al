table 50058 "Cons. Prod. Order Selection"
{
    // version Prod. Schedule

    CaptionML = ENU = 'Cons. Prod. Order Selection';
    DrillDownPageID = "Cons. Prod. Order Selection";
    LookupPageID = "Cons. Prod. Order Selection";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.';
            TableRelation = "Job Planning Line"."Job No.";
        }
        field(2; "Job Task No."; Code[20])
        {
            CaptionML = ENU = 'Job Task No.';
            TableRelation = "Job Planning Line"."Job Task No.";
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.';
            TableRelation = "Job Planning Line"."Line No.";
        }
        field(4; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.';
        }
        field(50000; "Prod. Schedule No"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
            TableRelation = "Production Schedule"."Schedule No." WHERE ("Schedule Published" = CONST (true));
        }
        field(50001; "Prod. Order No."; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50002; "Prod. Order Line No"; Integer)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50003; "Actual Output Quantity"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Order Type" = CONST (Production),
                                                                               "Order No." = FIELD ("Prod. Order No."),
                                                                               "Order Line No." = FIELD ("Prod. Order Line No")));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Expected Consumption"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50005; "Posted Consumption"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50006; "Marked for Consumption Post"; Boolean)
        {
            Description = 'Deepak';
        }
        field(50007; "Item Code"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
            TableRelation = Item."No." WHERE (Blocked = FILTER (false));
        }
        field(50008; "Paper Position"; Option)
        {
            Description = 'Deepak';
            Editable = false;
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(50009; "Requisition No."; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
            TableRelation = "Requisition Header"."Requisition No." WHERE (Status = CONST (Released),
                                                                          "Requisition Type" = CONST ("Production Schedule"));
        }
        field(50010; "Consumption Ratio"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50011; "Quantity Per"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Description = 'Deepak';
            Editable = false;
        }
        field(50012; "Total Exp. Consumption"; Decimal)
        {
            CalcFormula = Sum ("Cons. Prod. Order Selection"."Expected Consumption" WHERE ("Requisition No." = FIELD ("Requisition No."),
                                                                                          "Paper Position" = FIELD ("Paper Position"),
                                                                                          "Item Code" = FIELD ("Item Code"),
                                                                                          "Variant Code/ Reel Number" = FIELD ("Variant Code/ Reel Number"),
                                                                                          "Marked for Consumption Post" = CONST (true)));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Qty to be Post"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50014; "Temp Total Exp. Consumption"; Decimal)
        {
            CalcFormula = Sum ("Cons. Prod. Order Selection"."Expected Consumption" WHERE ("Requisition No." = FIELD ("Requisition No."),
                                                                                          "Paper Position" = FIELD ("Paper Position"),
                                                                                          "Marked for Consumption Post" = CONST (true)));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "Extra Consumtpion Quantity"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50016; "Extra Consumtion Variation(%)"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50017; "Extra Quantity Approval"; Boolean)
        {
            Description = 'Deepak';

            trigger OnValidate()
            begin
                // Lines added By Deepak Kumar
                UserSetup.Reset;
                UserSetup.SetRange(UserSetup."User ID", UserId);
                UserSetup.SetRange(UserSetup."Approval Authority Extra Cons", true);
                if UserSetup.FindFirst then begin
                    "Extra Quantity Approved By" := UserId + ' ' + Format(CurrentDateTime);
                end else begin
                    Error('You are not an authorized user to approve the extra Item consumption material.');
                end;
            end;
        }
        field(50018; "Extra Quantity Approved By"; Text[100])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50019; "Variant Code/ Reel Number"; Code[50])
        {
            Description = 'Deepak';
            Editable = false;
            TableRelation = "Item Variant".Code;
        }
        field(50020; "Cumulative Quantity to Post"; Decimal)
        {
            CalcFormula = Sum ("Cons. Prod. Order Selection"."Qty to be Post" WHERE ("Requisition No." = FIELD ("Requisition No."),
                                                                                    "Paper Position" = FIELD ("Paper Position"),
                                                                                    "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                                    "Prod. Order Line No" = FIELD ("Prod. Order Line No"),
                                                                                    "Marked for Consumption Post" = CONST (true)));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "No. Of Ply"; Integer)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50022; "Paper Position(Item)"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,Liner1-DL,Flute1-M1,Liner2-L1,Flute2-M2,Liner3-L2,Flute3-M3,Liner4-L3';
            OptionMembers = " ","Liner1-DL","Flute1-M1","Liner2-L1","Flute2-M2","Liner3-L2","Flute3-M3","Liner4-L3";

            trigger OnValidate()
            var
                RequisitionLineSAM: Record "Requisition Line SAM";
            begin
            end;
        }
        field(50023; "Line Counter"; Integer)
        {
            CalcFormula = Count ("Cons. Prod. Order Selection" WHERE ("Prod. Schedule No" = FIELD ("Prod. Schedule No"),
                                                                     "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                     "Prod. Order Line No" = FIELD ("Prod. Order Line No"),
                                                                     "Marked for Consumption Post" = CONST (true)));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "Supplementary Line"; Boolean)
        {
            Description = 'Deepak';

            trigger OnValidate()
            begin
                // Lines added By Deepak Kumar
                UserSetup.Reset;
                UserSetup.SetRange(UserSetup."User ID", UserId);
                UserSetup.SetRange(UserSetup."Approval Authority Extra Cons", true);
                if UserSetup.FindFirst then begin
                    "Extra Quantity Approved By" := UserId + ' ' + Format(CurrentDateTime);
                end else begin
                    Error('You are not an authorized user for Supplementary Line.');
                end;
            end;
        }
        field(50025; "Take Up"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 1;
        }
        field(50026; "Flute Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,A,B,C,E,F';
            OptionMembers = " ",A,B,C,E,F;
        }
    }

    keys
    {
        key(Key1; "Prod. Schedule No", "Line No.")
        {
        }
        key(Key2; "Marked for Consumption Post")
        {
        }
    }

    fieldgroups
    {
    }

    var
        UserSetup: Record "User Setup";

    procedure Create(JobPlanningLine: Record "Job Planning Line"; JobLedgerEntry: Record "Job Ledger Entry")
    begin
        if Get(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", JobPlanningLine."Line No.", JobLedgerEntry."Entry No.") then
            exit;

        Validate("Job No.", JobPlanningLine."Job No.");
        Validate("Job Task No.", JobPlanningLine."Job Task No.");
        Validate("Line No.", JobPlanningLine."Line No.");
        Validate("Entry No.", JobLedgerEntry."Entry No.");
        Insert(true);
    end;
}

