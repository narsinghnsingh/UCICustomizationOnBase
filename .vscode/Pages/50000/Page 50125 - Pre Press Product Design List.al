page 50125 "Pre Press Product Design List"
{
    // version Estimate Samadhan

    CardPageID = "Pre Press Product Details";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Product Design Header";
    SourceTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                      ORDER(Ascending)
                      WHERE ("Product Design Type" = CONST (Main),
                            Status = FILTER (Open | Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Design No."; "Product Design No.")
                {
                }
                field("Product Design Date"; "Product Design Date")
                {
                }
                field("Model No"; "Model No")
                {
                }
                field("Model Description"; "Model Description")
                {
                }
                field(Customer; Customer)
                {
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Sales Person Code"; "Sales Person Code")
                {
                }
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Quantity to Job Order"; "Quantity to Job Order")
                {
                }
                field("Per Box Weight (Gms)"; "Per Box Weight (Gms)")
                {
                }
                field("Amount Per Unit"; "Amount Per Unit")
                {
                }
                field("Amount Per KG"; "Amount Per KG")
                {
                }
                field("Pre-Press Status"; "Pre-Press Status")
                {
                }
                field("Pre-Press Confirmed By"; "Pre-Press Confirmed By")
                {
                    Caption = 'Pre-Press Confirmed/ Request Date';
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Product Development Details")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetCurrentKey(ProductDesignHeader."Product Design No.");
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", "Product Design No.");
                    REPORT.RunModal(REPORT::"Product Dev. Details", true, true, ProductDesignHeader);
                end;
            }
        }
    }

    var
        ProductDesignHeader: Record "Product Design Header";
}

