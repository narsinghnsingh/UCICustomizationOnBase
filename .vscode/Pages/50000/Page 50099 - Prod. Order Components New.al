page 50099 "Prod. Order Components New"
{
    // version Samadhan|DK

    AutoSplitKey = true;
    CaptionML = ENU = 'Prod. Order Components';
    DelayedInsert = true;
    DeleteAllowed = false;
    ModifyAllowed = true;
    MultipleNewLines = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = "Prod. Order Component";
    SourceTableView = WHERE ("Schedule Component" = CONST (false));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Paper Position"; "Paper Position")
                {
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        ItemNoOnAfterValidate;
                    end;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate;
                    end;
                }
                field("Available Inventory"; "Available Inventory")
                {
                }
                field("Quantity in Prod. Schedule"; "Quantity in Prod. Schedule")
                {
                }
                field("Expected Quantity"; "Expected Quantity")
                {
                    Editable = false;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field("Act. Consumption (Qty)"; "Act. Consumption (Qty)")
                {
                }
                field("Alternative item by Store"; "Alternative item by Store")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Alt. Item Store Description"; "Alt. Item Store Description")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Alternative item by Prod."; "Alternative item by Prod.")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Alt. item by Prod. Description"; "Alt. item by Prod. Description")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Approved by Store"; "Approved by Store")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Approved by Prod."; "Approved by Prod.")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Previous Item No"; "Previous Item No")
                {
                }
                field("Previous Item Description"; "Previous Item Description")
                {
                }
                field(Published; Published)
                {
                }
                field("Substitute Item"; "Substitute Item")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Force Avail. for Requisition"; "Force Avail. for Requisition")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Approve by Store / Printing")
            {
                Caption = 'Approve by Store / Printing';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    ProductionOrder.ApprovebyStore("Prod. Order No.", "Prod. Order Line No.");
                end;
            }
            action("Approve by Production")
            {
                Caption = 'Approve by Production';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added by deepak kUmar
                    ProductionOrder.ApprovebyProduction("Prod. Order No.", "Prod. Order Line No.");
                end;
            }

            action("Approve by Store / Printing Confirm Sch.")
            {
                Caption = 'Approve by Store / Printing Confirm Sch.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    ProductionOrder.ApprovebyStoreConfirmSch("Prod. Order No.", "Prod. Order Line No.");
                end;
            }
            action("Approve by Production Confirm Sch.")
            {
                Caption = 'Approve by Production Confirm Sch.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added by deepak kUmar
                    ProductionOrder.ApprovebyProductionConfirmSch("Prod. Order No.", "Prod. Order Line No.");
                end;
            }
            action("Release for Production")
            {
                Caption = 'Release for Production';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    // Lines added BY deepak kumar
                    ProductionOrder.PublishProductionOrder("Prod. Order No.", "Prod. Order Line No.");
                end;
            }
            group(Availability)
            {
                Caption = 'Availability';
                Image = ItemAvailability;
                action(ItemsByLocation)
                {
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;

                    trigger OnAction()
                    var
                        ItemsByLocation: Page "Items by Location";
                    begin
                        /*Item.reset;
                        Item.setrange(Item."No.",
                        ItemsByLocation.SETRECORD();
                        ItemsByLocation.RUN;
                         */

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
        ShortcutDimCode: array[8] of Code[20];
        ProductionOrder: Record "Production Order";
        Item: Record Item;

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

