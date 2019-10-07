page 50069 "Paper Type Buffer"
{
    // version Samadhan Quality

    PageType = CardPart;
    SourceTable = "Quality Type";

    layout
    {
        area(content)
        {
            repeater(Control6)
            {
                ShowCaption = false;
                field("Paper Type"; "Paper Type")
                {
                }
                field("Paper GSM"; "Paper GSM")
                {
                }
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Roll Entry QA")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Roll Weight Purch. QA";
                RunPageLink = "Purchase Receipt No." = FIELD ("Document No."),
                              "Paper Type" = FIELD ("Paper Type"),
                              "Paper GSM" = FIELD ("Paper GSM");
                RunPageView = SORTING ("Item No.", Code)
                              ORDER(Ascending)
                              WHERE (Status = FILTER (PendingforQA | Open));
            }
        }
    }
}

