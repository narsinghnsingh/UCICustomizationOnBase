page 50143 "Document CheckList"
{
    // version Document Check List

    AutoSplitKey = true;
    CaptionML = ENU = 'Comment Sheet';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Code"; "Document Code")
                {
                }
                field(Description; Description)
                {
                }
                field(Mandatory; Mandatory)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
    end;
}

