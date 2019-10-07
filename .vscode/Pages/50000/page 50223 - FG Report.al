page 50223 "FG Report"
{
    // version FG Report

    Caption = 'FG Report';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    ShowFilter = false;
    SourceTable = Item;
    SourceTableView = SORTING ("No.")
                      ORDER(Ascending)
                      WHERE ("Item Category Code" = CONST ('FG'));

    layout
    {
        area(content)
        {
            grid(Control5)
            {
                ShowCaption = false;
                repeater(Control12)
                {
                    ShowCaption = false;
                    field("No."; "No.")
                    {
                    }
                    field(Description; Description)
                    {
                    }
                    field("Estimate No."; "Estimate No.")
                    {
                        Importance = Additional;
                    }
                    field(Inventory; Inventory)
                    {
                    }
                    field("Qty. on Sales Order"; "Qty. on Sales Order")
                    {
                        Caption = 'Outstanding Quantity on Sales Order';
                    }
                    field("Qty. on Prod. Order"; "Qty. on Prod. Order")
                    {
                        Caption = 'Unfinished Quantity on Prod. Order';
                    }
                    field("Qty. on Sales Return"; "Qty. on Sales Return")
                    {
                    }
                    field("Qty. on Sales Order(Weight)"; "Qty. on Sales Order(Weight)")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    field("Outstanding Qty SO (Weight)"; "Outstanding Qty SO (Weight)")
                    {
                        DecimalPlaces = 0 : 0;
                    }
                    field("Customer No."; "Customer No.")
                    {
                        Importance = Additional;
                    }
                    field("Customer Name"; "Customer Name")
                    {
                    }
                }
                group(Control13)
                {
                    ShowCaption = false;
                    part(Control3; "Sales Line")
                    {
                        SubPageLink = "No." = FIELD ("No.");
                    }
                    part(Control4; "Item Ledger Data")
                    {
                        SubPageLink = "Item No." = FIELD ("No.");
                    }
                    part(Control6; "Prod. Order Line")
                    {
                        SubPageLink = "Estimate Code" = FIELD ("Estimate No.");
                    }
                }
            }
        }
    }

    actions
    {
    }

    var
        VATReportMediator: Codeunit "VAT Report Mediator";
}

