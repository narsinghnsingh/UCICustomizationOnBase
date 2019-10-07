table 50064 "Paper Type Price"
{
    // version Estimate

    CaptionML = ENU = 'Paper Type Price';
    // DrillDownPageID = "Paper Type Additional Cost";
    // LookupPageID = "Paper Type Additional Cost";

    fields
    {
        field(1; "No."; Integer)
        {
            CaptionML = ENU = 'No.';
        }
        field(2; "From Entry No."; Integer)
        {
            CaptionML = ENU = 'From Entry No.';
            TableRelation = "Job Ledger Entry";
        }
        field(3; "To Entry No."; Integer)
        {
            CaptionML = ENU = 'To Entry No.';
            TableRelation = "Job Ledger Entry";
        }
        field(4; "Creation Date"; Date)
        {
            CaptionML = ENU = 'Creation Date';
        }
        field(5; "Source Code"; Code[10])
        {
            CaptionML = ENU = 'Source Code';
            TableRelation = "Source Code";
        }
        field(6; "User ID"; Code[50])
        {
            CaptionML = ENU = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
            end;
        }
        field(7; "Journal Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name';
        }
        field(50000; "Start Date"; Date)
        {
        }
        field(50001; "Paper Type"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code" = CONST ('PAPERTYPE'));
        }
        field(50002; "Add On % for Est. Cost"; Decimal)
        {
            Description = '//Deepak';
        }
    }

    keys
    {
        key(Key1; "No.", "Paper Type", "Start Date")
        {
        }
        key(Key2; "Creation Date")
        {
        }
        key(Key3; "Source Code", "Journal Batch Name", "Creation Date")
        {
        }
    }

    fieldgroups
    {
    }
}

