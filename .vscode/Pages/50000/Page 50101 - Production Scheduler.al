page 50101 "Production Scheduler"
{
    Caption = 'Production Scheduler ';
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Production Order";
    SourceTableView = SORTING (Status, "No.")
                      ORDER(Ascending)
                      WHERE (Status = CONST (Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Status)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Starting Date-Time"; "Starting Date-Time")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Ending Date-Time"; "Ending Date-Time")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Production Approval Status"; "Production Approval Status")
                {
                }
                field("Prod Status"; "Prod Status")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Sales Requested Delivery Date"; "Sales Requested Delivery Date")
                {
                }
                field("No. of Ply"; "No. of Ply")
                {
                }
                field("Color Code"; "Color Code")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("Estimate Code"; "Estimate Code")
                {
                }
                field(Priority; Priority)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                group("E&ntries")
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action("Item Ledger E&ntries")
                    {
                        Caption = 'Item Ledger E&ntries';
                        Image = ItemLedger;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("Capacity Ledger Entries")
                    {
                        Caption = 'Capacity Ledger Entries';
                        Image = CapacityLedger;
                        RunObject = Page "Capacity Ledger Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
                    }
                    action("Value Entries")
                    {
                        Caption = 'Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
                    }
                }
            }
            action("Generate Priority")
            {

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    PROD_ORDER.Reset;
                    PROD_ORDER.SetCurrentKey("Due Date");
                    PROD_ORDER.SetRange(PROD_ORDER.Status, PROD_ORDER.Status::Released);
                    if PROD_ORDER.FindFirst then begin
                        TempPriority := 1;
                        repeat
                            PROD_ORDER.Priority := TempPriority;
                            PROD_ORDER.Modify(true);
                            TempPriority += 1;
                        until PROD_ORDER.Next = 0;
                    end;
                end;
            }
            action("Publish Schedule")
            {

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    if capacityPlanTable.FindFirst then begin
                        capacityPlanTable.DeleteAll(true);
                    end;
                    PROD_ORDER.Reset;
                    PROD_ORDER.SetCurrentKey(Priority, "Due Date");
                    if PROD_ORDER.FindFirst then begin
                        repeat
                            REPORT.Run(REPORT::"Replan Production Order", true, true, PROD_ORDER);
                            //    REPORT.RUN(REPORT::"Replan Production Order Sam",TRUE,TRUE,PROD_ORDER);
                        until PROD_ORDER.Next = 0;
                    end;
                end;
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Re&plan")
                {
                    Caption = 'Re&plan';
                    Ellipsis = true;
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ProdOrder: Record "Production Order";
                    begin
                        ProdOrder.SetRange(Status, Status);
                        ProdOrder.SetRange("No.", "No.");
                        REPORT.RunModal(REPORT::"Replan Production Order", true, true, ProdOrder);
                    end;
                }
                action("<Special Instruction>")
                {
                    Caption = 'Special Instruction';
                    Promoted = true;
                    RunObject = Page "Estimate Special Description";
                    RunPageLink = "No." = FIELD ("Estimate Code");
                    RunPageView = SORTING ("No.", "Line No.");
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Work Order")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PROD_ORDER.Reset;
                        PROD_ORDER.SetCurrentKey(PROD_ORDER."No.");
                        PROD_ORDER.SetRange(PROD_ORDER."No.", "No.");
                        REPORT.RunModal(REPORT::"JOB CARD CORRUGATION", true, true, PROD_ORDER);
                    end;
                }
            }
        }
    }

    var
        PROD_ORDER: Record "Production Order";
        TempPriority: Integer;
        capacityPlanTable: Record "Prod. Order Capacity Need";
}

