page 50046 "Delivery Order Subform"
{
    // version Delivery Order Samadhan

    AutoSplitKey = true;
    CaptionML = ENU = 'Lines';
    DelayedInsert = true;
    DeleteAllowed = true;
    LinksAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type"=FILTER("Delivery Order"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type;Type)
                {

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                        NoOnAfterValidate;
                    end;
                }
                field("No.";"No.")
                {

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                    QuickEntry = false;
                }
                field("Location Code";"Location Code")
                {
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate;
                    end;
                }
                field(Quantity;Quantity)
                {
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida;
                    end;
                }
                field("Unit Price";"Unit Price")
                {
                    BlankZero = true;
                }
                field("Estimation No.";"Estimation No.")
                {
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                }
                field("Ref. Sales Order No.";"Ref. Sales Order No.")
                {
                }
                field("Ref. Sales Order Line No.";"Ref. Sales Order Line No.")
                {
                }
                field("Profit Margin %";"Profit Margin %")
                {
                }
                field("LPO(Order) Date";"LPO(Order) Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                CaptionML = ENU = '&Line';
                Image = Line;
                action("Select Pallets")
                {
                    Image = UpdateShipment;
                    RunObject = Page "Select Pallets";
                    RunPageLink = "Sales Order No."=FIELD("Ref. Sales Order No."),
                                  "Document Line No"=FIELD("Line No."),
                                  "Item No."=FIELD("No."),
                                  "Delivery Order No."=FIELD("Document No."),
                                  "Prod. Order No."=FIELD("Prod. Order No.");
                    RunPageView = SORTING("Packing List No.","Pallet No.")
                                  ORDER(Ascending)
                                  WHERE("Sales Shipment No."=FILTER(=''),
                                        Posted=CONST(false),
                                        "Type Of Packing"=FILTER(Pallet));

                    trigger OnAction()
                    begin
                        // lines added bY Deepak kumar
                        TempDeliveryOrder:="Document No.";
                    end;
                }
                action("Box & Bundle Entry")
                {
                    CaptionML = ENU = 'Box & Bundle Entry';
                    Image = UpdateShipment;
                    RunObject = Page "Box and Bundle Entry";
                    RunPageLink = "Packing List No."=FIELD("Document No."),
                                  "Sales Order No."=FIELD("Document No."),
                                  "Document Line No"=FIELD("Line No.");
                    RunPageView = SORTING("Packing List No.","Pallet No.")
                                  ORDER(Ascending)
                                  WHERE("Sales Shipment No."=FILTER(=''),
                                        Posted=CONST(false),
                                        "Type Of Packing"=FILTER(Box|Bundle));
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin

                        ShowLineComments;
                    end;
                }
                action("Shipment Schedule Lines")
                {
                    CaptionML = ENU = 'Shipment Schedule Lines';
                    Image = ShipmentLines;
                    Promoted = true;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+S';

                    trigger OnAction()
                    begin
                        // Lines added By Deepak kumar
                        ShowShipmentScheduleLines;
                    end;
                }
            }
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions';
                Image = "Action";
                action(GetPrice)
                {
                    CaptionML = ENU = 'Get Price';
                    Ellipsis = true;
                    Image = Price;

                    trigger OnAction()
                    begin
                        ShowPrices;
                    end;
                }
                action("Get Li&ne Discount")
                {
                    CaptionML = ENU = 'Get Li&ne Discount';
                    Ellipsis = true;
                    Image = LineDiscount;

                    trigger OnAction()
                    begin
                        ShowLineDisc
                    end;
                }
                action(ExplodeBOM_Functions)
                {
                    CaptionML = ENU = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin
                        ExplodeBOM;
                    end;
                }
                action("Insert Ext. Texts")
                {
                    CaptionML = ENU = 'Insert &Ext. Text';
                    Image = Text;

                    trigger OnAction()
                    begin
                        InsertExtendedText(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
          Commit;
          if not ReserveSalesLine.DeleteLineConfirm(Rec) then
            exit(false);
          ReserveSalesLine.DeleteLine(Rec);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        InitType;
        Clear(ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array [8] of Code[20];
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        [InDataSet]
        ItemPanelVisible: Boolean;
        TempDeliveryOrder: Code[100];

    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    end;

    procedure CalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount",Rec);
    end;

    procedure ExplodeBOM()
    begin
        if "Prepmt. Amt. Inv." <> 0 then
          Error(Text001);
        CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM",Rec);
    end;

    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
    begin
        TestField("Purchase Order No.");
        PurchHeader.SetRange("No.","Purchase Order No.");
        PurchOrder.SetTableView(PurchHeader);
        PurchOrder.Editable := false;
        PurchOrder.Run;
    end;

    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
    begin
        TestField("Special Order Purchase No.");
        PurchHeader.SetRange("No.","Special Order Purchase No.");
        if not PurchHeader.IsEmpty then begin
          PurchOrder.SetTableView(PurchHeader);
          PurchOrder.Editable := false;
          PurchOrder.Run;
        end else begin
          PurchRcptHeader.SetRange("Order No.","Special Order Purchase No.");
          if PurchRcptHeader.Count = 1 then
            PAGE.Run(PAGE::"Posted Purchase Receipt",PurchRcptHeader)
          else
            PAGE.Run(PAGE::"Posted Purchase Receipts",PurchRcptHeader);
        end;
    end;

    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          Commit;
          TransferExtendedText.InsertSalesExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          UpdateForm(true);
    end;

    procedure ShowNonstockItems()
    begin
        ShowNonstock;
    end;

    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetSalesLine(Rec);
        TrackingForm.RunModal;
    end;

    procedure ItemChargeAssgnt()
    begin
        ShowItemChargeAssgnt;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    procedure ShowPrices()
    begin
        SalesHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
    end;

    procedure ShowLineDisc()
    begin
        SalesHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
    end;

    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
        OrderPromisingLines: Page "Order Promising Lines";
    begin
        OrderPromisingLine.SetRange("Source Type","Document Type");
        OrderPromisingLine.SetRange("Source ID","Document No.");
        OrderPromisingLine.SetRange("Source Line No.","Line No.");

        OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Sales);
        OrderPromisingLines.SetTableView(OrderPromisingLine);
        OrderPromisingLines.RunModal;
    end;

    local procedure TypeOnAfterValidate()
    begin
        ItemPanelVisible := Type = Type::Item;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
        if (Type = Type::"Charge (Item)") and ("No." <> xRec."No.") and
           (xRec."No." <> '')
        then
          CurrPage.SaveRecord;

        SaveAndAutoAsmToOrder;

        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("No." <> xRec."No.")
        then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure CrossReferenceNoOnAfterValidat()
    begin
        InsertExtendedText(false);
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder;

        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Location Code" <> xRec."Location Code")
        then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure ReserveOnAfterValidate()
    begin
        if (Reserve = Reserve::Always) and ("Outstanding Qty. (Base)" <> 0) then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure QuantityOnAfterValidate()
    var
        UpdateIsDone: Boolean;
    begin
        if Type = Type::Item then
          case Reserve of
            Reserve::Always:
              begin
                CurrPage.SaveRecord;
                AutoReserve;
                CurrPage.Update(false);
                UpdateIsDone := true;
              end;
            Reserve::Optional:
              if (Quantity < xRec.Quantity) and (xRec.Quantity > 0) then begin
                CurrPage.SaveRecord;
                CurrPage.Update(false);
                UpdateIsDone := true;
              end;
          end;

        if (Type = Type::Item) and
           (Quantity <> xRec.Quantity) and
           not UpdateIsDone
        then
          CurrPage.Update(true);
    end;

    local procedure QtyToAsmToOrderOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        if Reserve = Reserve::Always then
          AutoReserve;
        CurrPage.Update(true);
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        if Reserve = Reserve::Always then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        if (Reserve = Reserve::Always) and
           ("Outstanding Qty. (Base)" <> 0) and
           ("Shipment Date" <> xRec."Shipment Date")
        then begin
          CurrPage.SaveRecord;
          AutoReserve;
          CurrPage.Update(false);
        end;
    end;

    local procedure SaveAndAutoAsmToOrder()
    begin
        if (Type = Type::Item) and IsAsmToOrderRequired then begin
          CurrPage.SaveRecord;
          AutoAsmToOrder;
          CurrPage.Update(false);
        end;
    end;
}

