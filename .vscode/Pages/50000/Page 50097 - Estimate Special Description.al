page 50097 "Estimate Special Description"
{
    // version NAVW16.00

    AutoSplitKey = true;
    CaptionML = ENU = 'Estimate Special Description';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Product Design Special Descrip";
    SourceTableView = WHERE (Category = FILTER (<> Cost));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Category; Category)
                {
                }
                field(Comment; Comment)
                {
                }
                field(Date; Date)
                {
                    Editable = false;
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

