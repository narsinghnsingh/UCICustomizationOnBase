page 50022 "Blocked Product Design List"
{
    // version Estimate Samadhan

    CardPageID = "Product Design Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Product Design Header";
    SourceTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                      ORDER(Ascending)
                      WHERE ("Product Design Type" = CONST (Main),
                            Status = FILTER (Blocked));

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
            }
        }
    }

    actions
    {
    }
}

