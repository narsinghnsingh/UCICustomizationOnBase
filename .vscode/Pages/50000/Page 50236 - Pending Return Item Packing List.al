page 50236 "Pending Return Item Pack List"
{
    // version Packing List Samadhan
    Caption = 'Pending Return Item Packing List';
    CardPageID = "Pending Return Item Pack Head";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTable = "Packing List Header";
    SourceTableView = SORTING (No)
                      ORDER(Ascending)
                      WHERE (Type = CONST ("Sales Return"), "Packing List Status" = const ("Pending for Approval"));

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
                field("Packing List Status"; "Packing List Status")
                {

                }
                field("Approved By"; "Approved By")
                {

                }
                field(Remarks; Remarks)
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

