page 50008 "Product Design Model Master"
{
    // version Estimate Samadhan

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Product Design Model Master";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Model No";"Model No")
                {
                }
                field(Description;Description)
                {
                }
                field("Picture Diagram";"Picture Diagram")
                {
                }
                field(Picture;Picture)
                {
                }
                field("Detail Description";"Detail Description")
                {
                }
                field("Die Cut";"Die Cut")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Model Process")
            {
                Image = Production;
                RunObject = Page "Model Wise Process Setup";
                RunPageLink = "Model Code"=FIELD("Model No");
                RunPageView = SORTING("Model Code",Code)
                              ORDER(Ascending);
            }
        }
    }
}

