page 50095 "Product Design Additional Cost"
{
    // version Estimate Samadhan

    AutoSplitKey = true;
    Caption = 'Estimate Special Description';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Product Design Special Descrip";
    SourceTableView = SORTING ("No.", "Line No.") ORDER(Ascending) WHERE (Category = CONST (Cost));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Cost Code"; "Cost Code")
                {
                }
                field("Cost Description"; "Cost Description")
                {
                }
                field(Occurrence; Occurrence)
                {
                }
                field(Amount; Amount)
                {
                }
                field(Category; Category)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN BEGIN
            IF NOT UserSetup."Delete PDI Additional" THEN
                ERROR('You do not have permission to delete, kindly check with Administrator');
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
        Category := Category::Cost;
    end;

    var
        UserSetup: Record "User Setup";
}

