page 50048 "Sales Document CheckList"
{
    // version Delivery Order Samadhan

    AutoSplitKey = true;
    CaptionML = ENU = 'Sales Document CheckList';
    DataCaptionFields = "Document Type", "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Sales Comment Line";
    SourceTableView = SORTING ("Document Type", "No.", "Document Line No.", "Line No.")
                      ORDER(Ascending)
                      WHERE (Type = CONST ("Sales CheckList"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Type"; "Document Type")
                {
                }
                field(Type; Type)
                {
                }
                field("Sub- Type"; "Sub- Type")
                {
                }
                field("Document Code"; "Document Code")
                {
                }
                field(Description; Description)
                {
                }
                field(Attached; Attached)
                {
                }
                field(Mandatory; Mandatory)
                {
                }
                field(Comment; Comment)
                {
                    CaptionML = ENU = 'Remarks';
                }
                field("Marked By"; "Marked By")
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
        Type := Type::"Sales CheckList";
    end;
}

