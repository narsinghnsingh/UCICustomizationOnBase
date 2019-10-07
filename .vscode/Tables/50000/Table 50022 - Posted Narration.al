table 50022 "Posted Narration"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.';
        }
        field(2; "Transaction No."; Integer)
        {
            CaptionML = ENU = 'Transaction No.';
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.';
        }
        field(4; Narration; Text[250])
        {
            CaptionML = ENU = 'Narration';
        }
        field(5; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date';
        }
        field(6; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(7; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Transaction No.", "Line No.")
        {
        }
        key(Key2; "Transaction No.")
        {
        }
        key(Key3; "Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // Deepak\
        Error('');
    end;
}

