pageextension 50077 Ext_9038_ProdPlannerAct extends "Production Planner Activities"
{
    layout
    {
        // Add changes to page layout here
        addafter("Production Orders")
        {
            cuegroup("Product Design List")
            {
                field("Open Product Designs"; "Open Product Designs")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Product Design List";

                }
                field("Approved Product Designs"; "Approved Product Designs")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Product Design List";
                }
                field("Blocked Product Designs"; "Blocked Product Designs")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Product Design List";
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}