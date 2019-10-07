page 50166 "Confidential Information "
{
    // version Confidential Information

    PageType = Card;
    SourceTable = "Company Information";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Name; Name)
                {
                    Editable = false;
                }
                field("Estimate Margin %"; "Estimate Margin %")
                {
                }
                field(Picture; Picture)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Paper Type Wise Additional  Cost")
            {
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Paper Type Additional Cost";
                RunPageView = SORTING ("No.", "Paper Type", "Start Date")
                              ORDER(Ascending);
            }
        }
    }
}

