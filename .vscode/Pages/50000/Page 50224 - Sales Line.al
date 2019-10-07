page 50224 "Sales Line"
{
    // version FG Report

    Caption = 'Sales Order Details';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = SORTING ("Document Type", "Document No.", "Line No.")
                      ORDER(Ascending)
                      WHERE ("Short Closed Document" = CONST (false),
                            "Outstanding Quantity" = FILTER (> 0));

    layout
    {
        area(content)
        {
            repeater(Control56)
            {
                ShowCaption = false;
                field("External Doc. No."; "External Doc. No.")
                {
                }
                field(Type; Type)
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    QuickEntry = false;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    QuickEntry = false;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                    BlankZero = true;
                    QuickEntry = false;
                }
                field("Outstanding Qty. (Base)"; "Outstanding Qty. (Base)")
                {
                    Caption = 'Outstanding Qty';
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    BlankZero = true;
                }
                field("Order Quantity (Weight)"; "Order Quantity (Weight)")
                {
                }
                field("Outstanding  Quantity (Weight)"; "Outstanding  Quantity (Weight)")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Salesperson Code"; "Salesperson Code")
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
}

