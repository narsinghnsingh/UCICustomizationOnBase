page 50036 "Gen. Journal Voucher Narration"
{
    // version NAVIN7.10| Deepak

    AutoSplitKey = true;
    CaptionML = ENU = 'Voucher Narration';
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Gen. Journal Narration";

    layout
    {
        area(content)
        {
            field("Document No.";"Document No.")
            {
                Editable = false;
            }
            repeater(Control1500000)
            {
                ShowCaption = false;
                field(Narration;Narration)
                {
                }
            }
        }
    }

    actions
    {
    }
}

