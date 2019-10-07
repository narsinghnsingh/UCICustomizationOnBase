page 50009 "Product Design Model List"
{
    // version Estimate Samadhan

    CardPageID = "Product Design Model Master";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Product Design Model Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Model No"; "Model No")
                {
                }
                field(Description; Description)
                {
                }
                field("Picture Diagram"; "Picture Diagram")
                {
                }
                field(Picture; Picture)
                {
                }
                field("Die Cut"; "Die Cut")
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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Model Wise Process Setup";
                RunPageLink = "Model Code" = FIELD ("Model No");
                RunPageView = SORTING ("Model Code", Code)
                              ORDER(Ascending);
            }
        }
    }
}

