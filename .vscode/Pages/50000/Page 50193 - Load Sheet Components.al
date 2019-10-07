page 50193 "Load Sheet Components"
{
    // version NAVW18.00

    CaptionML = ENU = 'Load Sheet Components';
    DataCaptionExpression = Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = "Prod. Order Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item No.";"Item No.")
                {

                    trigger OnValidate()
                    begin
                        ItemNoOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                }
                field("Quantity per";"Quantity per")
                {

                    trigger OnValidate()
                    begin
                        QuantityperOnAfterValidate;
                    end;
                }
                field("Expected Quantity";"Expected Quantity")
                {
                }
                field("Act. Consumption (Qty)";"Act. Consumption (Qty)")
                {
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        ShowReservationEntries(true);
                        CurrPage.Update(false);
                    end;
                }
                field("Available Inventory";"Available Inventory")
                {
                }
                field("Routing Link Code";"Routing Link Code")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
    begin
        Commit;
        if not ReserveProdOrderComp.DeleteLineConfirm(Rec) then
          exit(false);
        ReserveProdOrderComp.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        Text000: Label 'You cannot reserve components with status %1.';
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array [8] of Code[20];

    procedure ReserveComp()
    var
        Item: Record Item;
    begin
        if (xRec."Remaining Qty. (Base)" <> "Remaining Qty. (Base)") or
           (xRec."Item No." <> "Item No.") or
           (xRec."Location Code" <> "Location Code")
        then
          if Item.Get("Item No.") then
            if Item.Reserve = Item.Reserve::Always then begin
              CurrPage.SaveRecord;
              AutoReserve;
              CurrPage.Update(false);
            end;
    end;

    local procedure ItemNoOnAfterValidate()
    begin
        ReserveComp;
    end;

    local procedure Scrap37OnAfterValidate()
    begin
        ReserveComp;
    end;

    local procedure CalculationFormulaOnAfterValid()
    begin
        ReserveComp;
    end;

    local procedure LengthOnAfterValidate()
    begin
        ReserveComp;
    end;

    local procedure WidthOnAfterValidate()
    begin
        ReserveComp;
    end;

    local procedure WeightOnAfterValidate()
    begin
        ReserveComp;
    end;

    local procedure DepthOnAfterValidate()
    begin
        ReserveComp;
    end;

    local procedure QuantityperOnAfterValidate()
    begin
        ReserveComp;
    end;

    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        ReserveComp;
    end;

    local procedure LocationCodeOnAfterValidate()
    begin
        ReserveComp;
    end;
}

