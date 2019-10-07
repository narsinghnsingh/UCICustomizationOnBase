page 50035 "Gen. Journal Narration"
{
    // version NAVIN7.10| Deepak

    AutoSplitKey = true;
    CaptionML = ENU = 'Line Narration';
    DelayedInsert = true;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Gen. Journal Narration";

    layout
    {
        area(content)
        {
            field("Document No."; "Document No.")
            {
                Editable = false;
            }
            repeater(Control1500000)
            {
                ShowCaption = false;
                field(Narration; Narration)
                {
                }
            }
        }
    }

    actions
    {
    }
}

