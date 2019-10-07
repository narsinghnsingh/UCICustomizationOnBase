table 50017 "Gen. Journal Narration"
{
    // version GL Narration


    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name" = FIELD ("Journal Template Name"));
        }
        field(3; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.';
            Editable = false;
        }
        field(4; "Gen. Journal Line No."; Integer)
        {
            CaptionML = ENU = 'Gen. Journal Line No.';
        }
        field(5; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.';
        }
        field(6; Narration; Text[250])
        {
            CaptionML = ENU = 'Narration';

            trigger OnLookup()
            begin
                if PAGE.RunModal(0, StdTxt) = ACTION::LookupOK then
                    Narration := StdTxt.Description;
            end;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Document No.", "Gen. Journal Line No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        StdTxt: Record "Standard Text";
}

