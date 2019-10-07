page 50186 "Production Order wise status"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    PromotedActionCategories = 'New,Process,Report,Production Order,Item';
    SourceTable = "Prod. Order Line";
    SourceTableView = SORTING (Status, "Prod. Order No.", "Line No.")
                      ORDER(Ascending)
                      WHERE (Status = FILTER (Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Sales Order No.1"; "Sales Order No.")
                {
                }
                field("Sales Order Line No."; "Sales Order Line No.")
                {
                }
                field("Estimate Code"; "Estimate Code")
                {
                }
                field(LPONo; "LPO No.")
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                }
                field("Die Cut Ups"; "Die Cut Ups")
                {
                }
                field("No of Joints"; "No of Joints")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Finished Quantity"; "Finished Quantity")
                {
                }
                field("Dispatch Quantity"; "Dispatch Quantity")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Remaining Finish Qty."; "Remaining Finish Qty.")
                {
                }
                field("Corrugation Quantity"; "Corrugation Quantity")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Corrugation Scrap"; "Corrugation Scrap")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Corrugation WIP Quantity"; "Corrugation WIP Quantity")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Printing Quantity"; "Printing Quantity")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Printing Scrap"; "Printing Scrap")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Printing WIP Quantity"; "Printing WIP Quantity")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Die Cut Quantity"; "Die Cut Quantity")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Die Punching Scrap"; "Die Punching Scrap")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Die Cut WIP Quantity"; "Die Cut WIP Quantity")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Finishing Quantity"; "Finishing Quantity")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Finishing Scrap"; "Finishing Scrap")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Finishing WIP Quantity"; "Finishing WIP Quantity")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Packing Quantity"; "Packing Quantity")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Packing Scrap"; "Packing Scrap")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Packing WIP Quantity"; "Packing WIP Quantity")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Packing List Qty"; "Packing List Qty")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("SO Line Type"; "SO Line Type")
                {
                }
                field("Total Scrap"; "Total Scrap")
                {
                }
            }
            group(Control29)
            {
                ShowCaption = false;
                grid(Control27)
                {
                    ShowCaption = false;
                    group(Control31)
                    {
                        ShowCaption = false;
                        field("Sales Order No."; "Sales Order No.")
                        {
                        }
                    }
                    group(Control8)
                    {
                        ShowCaption = false;
                        field("LPO No."; "LPO No.")
                        {
                        }
                    }
                    group(Control9)
                    {
                        ShowCaption = false;
                        field("Sales Requested Delivery Date"; "Sales Requested Delivery Date")
                        {
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Update WIP Quantity")
            {
                Image = Refresh;

                trigger OnAction()
                begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetRange(ProdOrderLine.Status, ProdOrderLine.Status::Released);
                    if ProdOrderLine.FindFirst then begin
                        repeat
                            ProdOrderRoutingLine.UpdateWIPQuantity(ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.");
                        until ProdOrderLine.Next = 0;
                        Message('Complete');
                    end;
                end;
            }
            group("Pro&d. Order")
            {
                Caption = 'Pro&d. Order';
                Image = "Order";
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Released Production Order";
                    RunPageLink = Status = FIELD (Status),
                                  "No." = FIELD ("Prod. Order No.");
                    ShortCutKey = 'Shift+F7';
                }
                group("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = Entries;
                    action("Item Ledger E&ntries")
                    {
                        Caption = 'Item Ledger E&ntries';
                        Image = ItemLedger;
                        Promoted = true;
                        PromotedCategory = Category4;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("Prod. Order No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("Capacity Ledger Entries")
                    {
                        Caption = 'Capacity Ledger Entries';
                        Image = CapacityLedger;
                        Promoted = true;
                        PromotedCategory = Category4;
                        RunObject = Page "Capacity Ledger Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("Prod. Order No.");
                    }
                }
            }
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
                action(Action49)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD ("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Action48)
                {
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No." = FIELD ("Item No.");
                    RunPageView = SORTING ("Item No.");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }

    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderLine: Record "Prod. Order Line";
}

