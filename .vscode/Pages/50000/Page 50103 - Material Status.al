page 50103 "Material Status"
{
    // version NAVW17.00

    AutoSplitKey = true;
    CaptionML = ENU = 'Prod. Order Components';
    DataCaptionExpression = Caption;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    UsageCategory = Lists;
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
        area(navigation)
        {
            group("&Line")
            {
                CaptionML = ENU = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    CaptionML = ENU = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        CaptionML = ENU = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec, ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        CaptionML = ENU = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec, ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        CaptionML = ENU = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec, ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        CaptionML = ENU = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec, ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        CaptionML = ENU = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec, ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Prod. Order Comp. Cmt. Sheet";
                    RunPageLink = Status = FIELD (Status),
                                  "Prod. Order No." = FIELD ("Prod. Order No."),
                                  "Prod. Order Line No." = FIELD ("Prod. Order Line No."),
                                  "Prod. Order BOM Line No." = FIELD ("Line No.");
                }
                action(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action(ItemTrackingLines)
                {
                    CaptionML = ENU = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
                action("Bin Contents")
                {
                    CaptionML = ENU = 'Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Contents List";
                    RunPageLink = "Location Code" = FIELD ("Location Code"),
                                  "Item No." = FIELD ("Item No."),
                                  "Variant Code" = FIELD ("Variant Code");
                    RunPageView = SORTING ("Location Code", "Bin Code", "Item No.", "Variant Code");
                }
                action("&Select Item Substitution")
                {
                    CaptionML = ENU = '&Select Item Substitution';
                    Image = SelectItemSubstitution;

                    trigger OnAction()
                    begin
                        CurrPage.SaveRecord;

                        ShowItemSub;

                        CurrPage.Update(true);

                        AutoReserve;
                    end;
                }
                action("Put-away/Pick Lines/Movement Lines")
                {
                    CaptionML = ENU = 'Put-away/Pick Lines/Movement Lines';
                    Image = PutawayLines;
                    RunObject = Page "Warehouse Activity Lines";
                    RunPageLink = "Source Type" = CONST (5407),
                                  "Source Subtype" = CONST ("3"),
                                  "Source No." = FIELD ("Prod. Order No."),
                                  "Source Line No." = FIELD ("Prod. Order Line No."),
                                  "Source Subline No." = FIELD ("Line No.");
                    RunPageView = SORTING ("Source Type", "Source Subtype", "Source No.", "Source Line No.", "Source Subline No.", "Unit of Measure Code", "Action Type", "Breakbulk No.", "Original Breakbulk");
                }
            }
        }
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

