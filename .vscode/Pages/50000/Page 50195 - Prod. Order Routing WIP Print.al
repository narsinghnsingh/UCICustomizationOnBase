page 50195 "Prod. Order Routing WIP Print"
{
    // version NAVW17.00

    CaptionML = ENU = 'Prod. Order Routing';
    DataCaptionExpression = Caption;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Prod. Order Routing Line";
    SourceTableView = WHERE ("Routing Link Code" = CONST ('SHEET'),
                            "Work Center No." = CONST ('WC0002'));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Visible = "Prod. Order No.Visible";
                }
                field("Schedule Manually"; "Schedule Manually")
                {
                    Visible = false;
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
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Flushing Method"; "Flushing Method")
                {
                    Visible = false;
                }
                field("Starting Date-Time"; "Starting Date-Time")
                {
                }
                field("Starting Time"; "Starting Time")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        StartingTimeOnAfterValidate;
                    end;
                }
                field("Starting Date"; "Starting Date")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        StartingDateOnAfterValidate;
                    end;
                }
                field("Ending Date-Time"; "Ending Date-Time")
                {
                }
                field("Print Load Qty"; "Print Load Qty")
                {
                }
                field("Corr. Output Qty."; "Corr. Output Qty.")
                {
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
                field("Die Cut Ups"; "Die Cut Ups")
                {
                }
                field("No of Joints"; "No of Joints")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        EndingTimeOnAfterValidate;
                    end;
                }
                field("Ending Date"; "Ending Date")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        EndingDateOnAfterValidate;
                    end;
                }
                field("Setup Time"; "Setup Time")
                {
                }
                field("Run Time"; "Run Time")
                {
                }
                field("Estimate Type"; "Estimate Type")
                {
                }
                field("Estimation No."; "Estimation No.")
                {
                }
                field("Sub Comp No."; "Sub Comp No.")
                {
                }
                field("Wait Time"; "Wait Time")
                {
                }
                field("Move Time"; "Move Time")
                {
                }
                field("Fixed Scrap Quantity"; "Fixed Scrap Quantity")
                {
                    Visible = false;
                }
                field("Routing Link Code"; "Routing Link Code")
                {
                    Visible = false;
                }
                field("Work Center No."; "Work Center No.")
                {
                }
                field("Work Center Category"; "Work Center Category")
                {
                }
                field("Scrap Factor %"; "Scrap Factor %")
                {
                    Visible = false;
                }
                field("Send-Ahead Quantity"; "Send-Ahead Quantity")
                {
                    Visible = false;
                }
                field("Concurrent Capacities"; "Concurrent Capacities")
                {
                    Visible = false;
                }
                field("Unit Cost per"; "Unit Cost per")
                {
                    Visible = false;
                }
                field("Expected Operation Cost Amt."; "Expected Operation Cost Amt.")
                {
                    Visible = false;
                }
                field("Expected Capacity Ovhd. Cost"; "Expected Capacity Ovhd. Cost")
                {
                    Visible = false;
                }
                field("Expected Capacity Need"; "Expected Capacity Need" / ExpCapacityNeed)
                {
                    CaptionML = ENU = 'Expected Capacity Need';
                    DecimalPlaces = 0 : 5;
                    Visible = false;
                }
                field("Routing Status"; "Routing Status")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Open Shop Floor Bin Code"; "Open Shop Floor Bin Code")
                {
                    Visible = false;
                }
                field("To-Production Bin Code"; "To-Production Bin Code")
                {
                    Visible = false;
                }
                field("Scrap Output Qty"; "Scrap Output Qty")
                {
                }
                field("From-Production Bin Code"; "From-Production Bin Code")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
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
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Prod. Order Rtng. Cmt. Sh.";
                    RunPageLink = Status = FIELD (Status),
                                  "Prod. Order No." = FIELD ("Prod. Order No."),
                                  "Routing Reference No." = FIELD ("Routing Reference No."),
                                  "Routing No." = FIELD ("Routing No."),
                                  "Operation No." = FIELD ("Operation No.");
                }
                action(Tools)
                {
                    CaptionML = ENU = 'Tools';
                    Image = Tools;
                    RunObject = Page "Prod. Order Routing Tools";
                    RunPageLink = Status = FIELD (Status),
                                  "Prod. Order No." = FIELD ("Prod. Order No."),
                                  "Routing Reference No." = FIELD ("Routing Reference No."),
                                  "Routing No." = FIELD ("Routing No."),
                                  "Operation No." = FIELD ("Operation No.");
                }
                action(Personnel)
                {
                    CaptionML = ENU = 'Personnel';
                    Image = User;
                    RunObject = Page "Prod. Order Routing Personnel";
                    RunPageLink = Status = FIELD (Status),
                                  "Prod. Order No." = FIELD ("Prod. Order No."),
                                  "Routing Reference No." = FIELD ("Routing Reference No."),
                                  "Routing No." = FIELD ("Routing No."),
                                  "Operation No." = FIELD ("Operation No.");
                }
                action("Quality Measures")
                {
                    CaptionML = ENU = 'Quality Measures';
                    Image = TaskQualityMeasure;
                    RunObject = Page "Prod. Order Rtng Qlty Meas.";
                    RunPageLink = Status = FIELD (Status),
                                  "Prod. Order No." = FIELD ("Prod. Order No."),
                                  "Routing Reference No." = FIELD ("Routing Reference No."),
                                  "Routing No." = FIELD ("Routing No."),
                                  "Operation No." = FIELD ("Operation No.");
                }
                separator(Separator56)
                {
                }
                action("Allocated Capacity")
                {
                    CaptionML = ENU = 'Allocated Capacity';
                    Image = AllocatedCapacity;

                    trigger OnAction()
                    var
                        ProdOrderCapNeed: Record "Prod. Order Capacity Need";
                    begin
                        if Status = Status::Finished then
                            exit;
                        ProdOrderCapNeed.SetCurrentKey(Type, "No.", "Starting Date-Time");
                        ProdOrderCapNeed.SetRange(Type, Type);
                        ProdOrderCapNeed.SetRange("No.", "No.");
                        ProdOrderCapNeed.SetRange(Date, "Starting Date", "Ending Date");
                        ProdOrderCapNeed.SetRange("Prod. Order No.", "Prod. Order No.");
                        ProdOrderCapNeed.SetRange(Status, Status);
                        ProdOrderCapNeed.SetRange("Routing Reference No.", "Routing Reference No.");
                        ProdOrderCapNeed.SetRange("Operation No.", "Operation No.");

                        PAGE.RunModal(0, ProdOrderCapNeed);
                    end;
                }
            }
        }
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
                action(UpdateWIPPrint)
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CalcWIPPrint();
                    end;
                }
            }
        }
    }

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

    local procedure "-------------------------------------------Samadhan-------------------------------------------"()
    begin
    end;

    local procedure CalcWIPPrint()
    var
        Prod_r_line: Record "Prod. Order Routing Line";
    begin
        //Function to calculate Printing Load Machine Wise (Added By Anurag)
        //"Print Load Qty": = "Corr. Output Qty." - "Actual Output Quantity";
        Prod_r_line.Reset;
        Prod_r_line.SetRange(Prod_r_line."Work Center No.", 'WC0002');
        Prod_r_line.SetFilter(Prod_r_line.Status, 'Released');
        if Prod_r_line.FindFirst
         then begin
            repeat
                Prod_r_line.CalcFields(Prod_r_line."Corr. Output Qty.");
                Prod_r_line.CalcFields(Prod_r_line."Actual Output Quantity");
                Prod_r_line.CalcFields(Prod_r_line."Scrap Output Qty");

                Prod_r_line."Print Load Qty" := (Prod_r_line."Corr. Output Qty." - Prod_r_line."Actual Output Quantity") - Prod_r_line."Scrap Output Qty";
                Prod_r_line.Modify(true);
            until Prod_r_line.Next = 0;
            Message('Updated Successfully');
        end
    end;
}

