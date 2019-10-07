table 50057 "Con. Item Selection 1"
{
    // version Prod. Schedule

    CaptionML = ENU = 'Con. Item Selection ';
    PasteIsValid = false;

    fields
    {
        field(1; "Document No."; Code[10])
        {
            CaptionML = ENU = 'Document No.';
            Description = 'deepak';
            Editable = false;
        }
        field(2; "Req. Line Number"; Integer)
        {
            CaptionML = ENU = 'Entry No.';
            Description = 'deepak';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
        }
    }

}

