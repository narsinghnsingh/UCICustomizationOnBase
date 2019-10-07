page 50146 "Voucher Narration New"
{
    // version NAVIN7.10| Deepak

    AutoSplitKey = true;
    CaptionML = ENU = 'Voucher Narration';
    DelayedInsert = true;
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Gen. Journal Narration";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                ShowCaption = false;
                field(Narration;Narration)
                {
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
    }
}

