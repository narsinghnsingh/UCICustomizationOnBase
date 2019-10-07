page 50225 "Item Ledger Data"
{
    // version FG Report

    Caption = 'Remaining FG Stock Detail';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = "Item Ledger Entry";
    SourceTableView = SORTING ("Item No.", "Posting Date")
                      ORDER(Ascending)
                      WHERE ("Remaining Quantity" = FILTER (<> 0));

    layout
    {
        area(content)
        {
            repeater(Control52)
            {
                ShowCaption = false;
                field("Order No."; "Order No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Invoiced Quantity"; "Invoiced Quantity")
                {
                    Visible = true;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    Visible = true;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Document No."; "Document No.")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Order Type"; "Order Type")
                {
                    Importance = Additional;
                    Visible = false;
                }
                field("Order Line No."; "Order Line No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

