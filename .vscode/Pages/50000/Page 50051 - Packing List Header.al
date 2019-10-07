page 50051 "Packing List Header"
{
    // version Packing List Samadhan

    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Packing List Header";
    SourceTableView = SORTING (Type, No)
                      ORDER(Ascending)
                      WHERE (Type = CONST (Production));

    layout
    {
        area(content)
        {
            group(Header)
            {
                field(No; No)
                {
                }
                field("Creation Date"; "Creation Date")
                {
                    Editable = true;
                }
                field("Created  By"; "Created  By")
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Editable = ProdOrdEditable;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                    Editable = ProdOrdEditable;
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field("Sales Order Line No."; "Sales Order Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Ledger Entry Number"; "Item Ledger Entry Number")
                {
                    Importance = Additional;
                }
                field("Item Description"; "Item Description")
                {
                }
                field(Status; Status)
                {
                }
                field("Order Quantity"; "Order Quantity")
                {
                }
                field("Total Finished Quantity"; "Total Finished Quantity")
                {
                }
                field("Total Shipped Quantity"; "Total Shipped Quantity")
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
                field("Total Pallet Quantity"; "Total Pallet Quantity")
                {
                }
                field("No. of Pallets"; "No. of Pallets")
                {
                }
            }
            part(Control13; "Packing List Line")
            {
                SubPageLink = "Packing List No." = FIELD (FILTER (No)),
                              "Prod. Order No." = FIELD (FILTER ("Prod. Order No.")),
                              "Sales Order No." = FIELD (FILTER ("Sales Order No."));
                SubPageView = SORTING ("Packing List No.", "Pallet No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate Pallets")
            {
                Image = ResourcePrice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+P';

                trigger OnAction()
                begin

                    TestField(Status, Status::Open);
                    TestField("Qty in each pallet");
                    if "Available Qty for Packing" < "Qty in each pallet" then
                        Error('Available Qty for Packing must not be less then "Qty in each pallet"');

                    NoofPallet := Round("Available Qty for Packing" / "Qty in each pallet", 1, '<');
                    //MESSAGE(FORMAT(NoofPallet));
                    I := 1;
                    PackingLine.Reset;
                    for I := 1 to NoofPallet do begin
                        PackingLine.Reset;
                        PackingLine."Packing List No." := No;
                        PackingLine."Pallet No." := I;
                        //MESSAGE(FORMAT(I));
                        PackingLine.Quantity := "Qty in each pallet";
                        PackingLine."Prod. Order No." := "Prod. Order No.";
                        PackingLine."Sales Order No." := "Sales Order No.";
                        PackingLine."Sales Order Line No." := "Sales Order Line No.";
                        PackingLine."Item No." := "Item No.";
                        PackingLine."Document Type" := PackingLine."Document Type"::Order;
                        PackingLine.Insert(true);
                    end;
                    CalcFields("Total Pallet Quantity", "Prod. Order Pallet Quantity");
                    Item.Get("Item No.");
                    Item.CalcFields(Item.Inventory);

                    if CompanyName <> 'Maple Leaf Packaging L.L.C' then
                        "Available Qty for Packing" := "Available Qty for Packing" - "Total Pallet Quantity"
                    else
                        "Available Qty for Packing" := Item.Inventory - "Total Pallet Quantity";

                    if "Available Qty for Packing" <> 0 then begin
                        PackingLine.Reset;
                        PackingLine."Packing List No." := No;
                        PackingLine."Pallet No." := I + 1;
                        //MESSAGE(FORMAT(I));
                        PackingLine.Quantity := "Available Qty for Packing";
                        PackingLine."Prod. Order No." := "Prod. Order No.";
                        PackingLine."Sales Order No." := "Sales Order No.";
                        PackingLine."Sales Order Line No." := "Sales Order Line No.";
                        PackingLine."Item No." := "Item No.";
                        PackingLine."Document Type" := PackingLine."Document Type"::Order;
                        PackingLine.Insert(true);
                    end;
                    CalcFields("Total Pallet Quantity", "Prod. Order Pallet Quantity");
                    Clear(PosQty);
                    if CompanyName <> 'Maple Leaf Packaging L.L.C' then begin
                        ItemLE.Reset;
                        ItemLE.SetFilter(ItemLE."Entry Type", '%1|%2', ItemLE."Entry Type"::"Positive Adjmt.", ItemLE."Entry Type"::Purchase);
                        ItemLE.SetRange("Order No.", "Prod. Order No.");
                        ItemLE.SetRange("Item No.", "Item No.");
                        ItemLE.SetRange("Order Line No.", "Prod. Order Line No.");
                        if ItemLE.FindFirst then
                            repeat
                                PosQty += ItemLE.Quantity;
                            until ItemLE.Next = 0;
                        "Available Qty for Packing" := ("Total Finished Quantity" + PosQty) - ("Prod. Order Pallet Quantity");
                    end else begin
                        "Available Qty for Packing" := Item.Inventory - "Total Pallet Quantity";
                    end;


                    Modify(true);
                end;
            }
            action("Item Card")
            {
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD ("Item No.");
                RunPageView = SORTING ("No.");
            }
            action("Print Pallet Tag")
            {
                Caption = 'Print Pallet Tag';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added bY deepak kumar
                    PackingLine.Reset;
                    PackingLine.SetRange(PackingLine."Packing List No.", No);
                    PackingListReport.SetTableView(PackingLine);
                    PackingListReport.Run;
                end;
            }
            action(Release)
            {
                Caption = 'Release';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    ReleasePackingList;
                end;
            }
            action("Re-Open")
            {
                Caption = 'Re-Open';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    ReOpenPackingList;
                end;
            }
            action("Refresh Packing")
            {
                Image = Recalculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if CompanyName <> 'Maple Leaf Packaging L.L.C' then
                        Validate("Prod. Order No.", "Prod. Order No.")
                    else
                        Validate("Sales Order Line No.", "Sales Order Line No.");
                    Modify(true);
                end;
            }
            action("Return Item Packing List")
            {
                Caption = 'Return Item Packing List';
                Image = ReturnReceipt;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Return Item Packing List";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if CompanyName = 'Maple Leaf Packaging L.L.C' then
            ProdOrdEditable := false
        else
            ProdOrdEditable := true;
        CalcFields("Total Pallet Quantity");
        Validate("Remaining Qty to Pack", ("Available Qty for Packing" - "Total Pallet Quantity"));
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if CompanyName = 'Maple Leaf Packaging L.L.C' then
            ProdOrdEditable := false
        else
            ProdOrdEditable := true;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        CalcFields("Total Pallet Quantity");
        Validate("Remaining Qty to Pack", ("Available Qty for Packing" - "Total Pallet Quantity"));
    end;

    trigger OnOpenPage()
    begin
        /*
        CALCFIELDS("Total Pallet Quantity");
        VALIDATE("Remaining Qty to Pack",("Available Qty for Packing" - "Total Pallet Quantity"));
         */

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CalcFields("Total Pallet Quantity");
        Validate("Remaining Qty to Pack", ("Available Qty for Packing" - "Total Pallet Quantity"));
    end;

    var
        NoofPallet: Integer;
        I: Integer;
        PackingLine: Record "Packing List Line";
        PackingListReport: Report "Pallet Tag";
        PackingListReport2: Report "JobWise Costing";
        PosQty: Decimal;
        ItemLE: Record "Item Ledger Entry";
        ProdOrdEditable: Boolean;
        Item: Record Item;
}

