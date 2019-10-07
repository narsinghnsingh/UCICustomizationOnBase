page 50196 "Sales  Order wise status"
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
                      WHERE (Status = CONST (Released),
                            "Line No." = CONST (10000));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field("Customer Name"; CustomerName)
                {
                }
                field("Estimate Code"; "Estimate Code")
                {
                }
                field("Sales Ordered Qty."; Orderqty)
                {
                }
                field(LPONo; "LPO No.")
                {
                }
                field("LPO Date"; LPODate)
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Item No."; "Item No.")
                {
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
                field("Last Production Date"; "Ending Date")
                {
                }
                field("Dispatch Quantity"; "Dispatch Quantity")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Last Despatch Date"; "Last Despatch Date")
                {
                }
                field("Remaining Finish Qty."; "Remaining Finish Qty.")
                {
                }
                field("Corrugation Quantity"; "Corrugation Quantity")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Printing Quantity"; "Printing Quantity")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Last Printing Date"; "Last Printing Date")
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
                        field("SO. No."; "Sales Order No.")
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
                CaptionML = ENU = 'Pro&d. Order';
                Image = "Order";
                action(Card)
                {
                    CaptionML = ENU = 'Card';
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
                    CaptionML = ENU = 'Ledger E&ntries';
                    Image = Entries;
                    action("Item Ledger E&ntries")
                    {
                        CaptionML = ENU = 'Item Ledger E&ntries';
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
                        CaptionML = ENU = 'Capacity Ledger Entries';
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
                CaptionML = ENU = '&Item';
                Image = Item;
                action(Action49)
                {
                    CaptionML = ENU = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD ("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Action48)
                {
                    CaptionML = ENU = 'Ledger E&ntries';
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

    trigger OnAfterGetRecord()
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", "Sales Order No.");
        SalesLine.SetRange("Line No.", "Sales Order Line No.");
        if SalesLine.Find('-') then begin
            LPODate := SalesLine."LPO(Order) Date";
            Orderqty := SalesLine.Quantity;
        end;

        SalesHeader.Reset;
        SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(SalesHeader."No.", "Sales Order No.");
        if SalesHeader.FindFirst then begin
            CustomerName := SalesHeader."Sell-to Customer Name";
        end;
    end;

    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderLine: Record "Prod. Order Line";
        SalesLine: Record "Sales Line";
        LPODate: Date;
        Orderqty: Decimal;
        SalesHeader: Record "Sales Header";
        CustomerName: Text;
}

