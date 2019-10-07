page 50180 "Return Item Packing List"
{
    // version Packing List Samadhan

    CardPageID = "Return Item Packing Header";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTable = "Packing List Header";
    SourceTableView = SORTING (No)
                      ORDER(Ascending)
                      WHERE (Type = CONST ("Sales Return"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; No)
                {
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field(Status; Status)
                {
                }
                field("Return Recipt No."; "Return Recipt No.")
                {
                }
                field("Return Recipt Line No."; "Return Recipt Line No.")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Created  By"; "Created  By")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Order Quantity"; "Order Quantity")
                {
                }
                field("Existing Packing List Qty."; "Existing Packing List Qty.")
                {
                }
                field("Available Qty for Packing"; "Available Qty for Packing")
                {
                }
                field("Qty in each pallet"; "Qty in each pallet")
                {
                }
                field("No. of Pallets"; "No. of Pallets")
                {
                }
                field("Total Shipped Quantity"; "Total Shipped Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::"Sales Return";
    end;

    var
        ChangeLog: Record "Change Log Entry";
        PackingHeader: Record "Packing List Header";
        SH: Record "Sales Header";
}

