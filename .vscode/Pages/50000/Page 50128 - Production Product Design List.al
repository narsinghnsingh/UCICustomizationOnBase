page 50128 "Production Product Design List"
{
    // version Estimate Samadhan

    CardPageID = "Product Design Card";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Product Design Header";
    SourceTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                      ORDER(Ascending)
                      WHERE ("Product Design Type" = CONST (Main),
                            Status = FILTER (Open | Approved),
                            "Production Status" = CONST ("Update Pending from Production "));

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
                field("Production Status"; "Production Status")
                {
                }
                field("Production Confirmed By"; "Production Confirmed By")
                {
                }
            }
        }
    }

    actions
    {
    }
}

