page 50215 "Material Status ListPart"
{
    // version NAVW17.00

    AutoSplitKey = true;
    CaptionML = ENU = 'Prod. Order Components';
    DataCaptionExpression = Caption;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Prod. Order Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Quantity per"; "Quantity per")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Flushing Method"; "Flushing Method")
                {
                }
                field("Expected Quantity"; "Expected Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field("Actual Consumed"; "Actual Consumed")
                {
                    CaptionML = ENU = 'Actual Consumption';
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions';
                Image = "Action";
                action(Reserve)
                {
                    CaptionML = ENU = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        if Status in [Status::Simulated, Status::Planned] then
                            Error(Text000, Status);

                        CurrPage.SaveRecord;
                        ShowReservation;
                    end;
                }
                action(OrderTracking)
                {
                    CaptionML = ENU = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    var
                        TrackingForm: Page "Order Tracking";
                    begin
                        TrackingForm.SetProdOrderComponent(Rec);
                        TrackingForm.RunModal;
                    end;
                }
            }
            action("&Print")
            {
                CaptionML = ENU = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ProdOrderComp: Record "Prod. Order Component";
                begin
                    ProdOrderComp.Copy(Rec);
                    REPORT.RunModal(REPORT::"Prod. Order - Picking List", true, true, ProdOrderComp);
                end;
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
}

