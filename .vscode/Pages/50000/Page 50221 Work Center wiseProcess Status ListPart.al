page 50221 "Work Cen Process Stat ListPart"
{
    // version NAVW17.00

    CaptionML = ENU = 'Prod. Order Routing';
    DataCaptionExpression = Caption;
    PageType = ListPart;
    SourceTable = "Prod. Order Routing Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Status; Status)
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Operation No."; "Operation No.")
                {
                }
                field("Previous Operation No."; "Previous Operation No.")
                {
                    Visible = false;
                }
                field("Next Operation No."; "Next Operation No.")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(ExpectedOutputQuantity; ExpectedOutputQuantity)
                {
                    CaptionML = ENU = 'Expected Output Quantity';
                }
                field("Actual Output Quantity"; "Actual Output Quantity")
                {
                }
                field("WIP Quantity"; "WIP Quantity")
                {
                }
                field("WIP Process Value"; "WIP Process Value")
                {
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
                action("Order &Tracking")
                {
                    CaptionML = ENU = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction()
                    var
                        ProdOrderLine: Record "Prod. Order Line";
                        TrackingForm: Page "Order Tracking";
                    begin
                        ProdOrderLine.SetRange(Status, Status);
                        ProdOrderLine.SetRange("Prod. Order No.", "Prod. Order No.");
                        ProdOrderLine.SetRange("Routing No.", "Routing No.");
                        if ProdOrderLine.FindFirst then begin
                            TrackingForm.SetProdOrderLine(ProdOrderLine);
                            TrackingForm.RunModal;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Lines added BY Deepak Kumar
        ProdOrder.Reset;
        ProdOrder.SetRange(ProdOrder.Status, Status);
        ProdOrder.SetRange(ProdOrder."Prod. Order No.", "Prod. Order No.");
        ProdOrder.SetRange(ProdOrder."Line No.", "Routing Reference No.");
        if ProdOrder.FindFirst then begin
            if ("Die Cut Ups" > 1) or ("No of Joints" > 1) then begin
                if "Die Cut Ups" = 0 then
                    "Die Cut Ups" := 1;
                if "No of Joints" = 0 then
                    "No of Joints" := 1;

                ExpectedOutputQuantity := ProdOrder.Quantity / "Die Cut Ups" * "No of Joints";
            end else begin
                ExpectedOutputQuantity := ProdOrder.Quantity;
            end;
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CheckPreviousAndNext();
    end;

    trigger OnInit()
    begin
        "Prod. Order No.Visible" := true;
    end;

    trigger OnOpenPage()
    begin
        "Prod. Order No.Visible" := true;
        if GetFilter("Prod. Order No.") <> '' then
            "Prod. Order No.Visible" := GetRangeMin("Prod. Order No.") <> GetRangeMax("Prod. Order No.");
    end;

    var
        [InDataSet]
        "Prod. Order No.Visible": Boolean;
        ProdOrder: Record "Prod. Order Line";
        ExpectedOutputQuantity: Decimal;

    local procedure ExpCapacityNeed(): Decimal
    var
        WorkCenter: Record "Work Center";
        CalendarMgt: Codeunit CalendarManagement;
    begin
        if "Work Center No." = '' then
            exit(1);
        WorkCenter.Get("Work Center No.");
        exit(CalendarMgt.TimeFactor(WorkCenter."Unit of Measure Code"));
    end;

    local procedure StartingTimeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure StartingDateOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure EndingTimeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure EndingDateOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

