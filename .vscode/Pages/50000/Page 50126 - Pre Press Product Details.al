page 50126 "Pre Press Product Details"
{
    // version Estimate Samadhan

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Action';
    SourceTable = "Product Design Header";

    layout
    {
        area(content)
        {
            group(Control101)
            {
                ShowCaption = false;
                group(Control98)
                {
                    Editable = false;
                    ShowCaption = false;
                    field(Name; Name)
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
            part(Control97; "Pre Press PD Line")
            {
                SubPageLink = "Product Design No." = FIELD ("Product Design No.");
                SubPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Approve Pre-Press")
            {
                Image = RegisterPick;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    ApproveFromPrePress(Rec);
                end;
            }
            action("Calculate Details")
            {
                Caption = 'Calculate Details';
                Image = CalculateConsumption;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    CalcDetail("Product Design No.");
                end;
            }
            action("Special Description ")
            {
                Image = AdjustItemCost;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Estimate Special Description";
                RunPageLink = "No." = FIELD ("Product Design No.");
                RunPageView = SORTING ("No.", "Line No.")
                              ORDER(Ascending);
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // Lines added BY Deepak Kumar
        if (Printing) and (Status = Status::Open) then
            TestField("No. of Colour");
    end;
}

