page 50042 "RPO Finished List"
{
    // version NAVW18.00

    CaptionML = ENU = 'Released Production Orders';
    CardPageID = "Released Production Order";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Production Order";
    SourceTableView = WHERE ("Finished Quantity" = FILTER (<> 0),
                            "Remaining Quantity" = CONST (0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    Lookup = false;
                }
                field("Prev. Job No."; "Prev. Job No.")
                {
                }
                field("Repeat Job"; "Repeat Job")
                {
                }
                field(Description; Description)
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Routing No."; "Routing No.")
                {
                }
                field("Finished Quantity"; "Finished Quantity")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field("Sales Order Line No."; "Sales Order Line No.")
                {
                }
                field("Estimate Code"; "Estimate Code")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Starting Time"; "Starting Time")
                {
                    Visible = false;
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                    Visible = false;
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Prod Status"; "Prod Status")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field("Finished Date"; "Finished Date")
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    Visible = false;
                }
                field("Bin Code"; "Bin Code")
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
                Visible = true;
            }
            part(Control19; "Prod. Order ListPart")
            {
                SubPageLink = "Prod. Order No." = FIELD ("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Pro&d. Order")
            {
                CaptionML = ENU = 'Pro&d. Order';
                Image = "Order";
                group("E&ntries")
                {
                    CaptionML = ENU = 'E&ntries';
                    Image = Entries;
                    action("Item Ledger E&ntries")
                    {
                        CaptionML = ENU = 'Item Ledger E&ntries';
                        Image = ItemLedger;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("Capacity Ledger Entries")
                    {
                        CaptionML = ENU = 'Capacity Ledger Entries';
                        Image = CapacityLedger;
                        RunObject = Page "Capacity Ledger Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
                    }
                    action("Value Entries")
                    {
                        CaptionML = ENU = 'Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
                    }
                    action("&Warehouse Entries")
                    {
                        CaptionML = ENU = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Source Type" = FILTER ('83' | '5407'),
                                      "Source Subtype" = FILTER ("3" | "4" | "5"),
                                      "Source No." = FIELD ("No.");
                        RunPageView = SORTING ("Source Type", "Source Subtype", "Source No.");
                    }
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Prod. Order Comment Sheet";
                    RunPageLink = Status = FIELD (Status),
                                  "Prod. Order No." = FIELD ("No.");
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }
                separator(Separator31)
                {
                }
                action(Statistics)
                {
                    CaptionML = ENU = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Production Order Statistics";
                    RunPageLink = Status = FIELD (Status),
                                  "No." = FIELD ("No."),
                                  "Date Filter" = FIELD ("Date Filter");
                    ShortCutKey = 'F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions';
                Image = "Action";
                action("Change &Status")
                {
                    CaptionML = ENU = 'Change &Status';
                    Ellipsis = true;
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Prod. Order Status Management";
                }
                action("&Update Unit Cost")
                {
                    CaptionML = ENU = '&Update Unit Cost';
                    Ellipsis = true;
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ProdOrder: Record "Production Order";
                    begin
                        ProdOrder.SetRange(Status, Status);
                        ProdOrder.SetRange("No.", "No.");

                        REPORT.RunModal(REPORT::"Update Unit Cost", true, true, ProdOrder);
                    end;
                }
                action("Create Inventor&y Put-away/Pick/Movement")
                {
                    CaptionML = ENU = 'Create Inventor&y Put-away/Pick/Movement';
                    Ellipsis = true;
                    Image = CreatePutAway;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CreateInvtPutAwayPick;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Prod. Order - Detail Calc.")
            {
                CaptionML = ENU = 'Prod. Order - Detail Calc.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Detailed Calc.";
            }
            action("Prod. Order - Precalc. Time")
            {
                CaptionML = ENU = 'Prod. Order - Precalc. Time';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Precalc. Time";
            }
            action("Production Order - Comp. and Routing")
            {
                CaptionML = ENU = 'Production Order - Comp. and Routing';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Prod. Order Comp. and Routing";
            }
            action("Production Order Job Card")
            {
                CaptionML = ENU = 'Production Order Job Card';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Job Card";
            }
            action("Production Order - Picking List")
            {
                CaptionML = ENU = 'Production Order - Picking List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Picking List";
            }
            action("Production Order - Material Requisition")
            {
                CaptionML = ENU = 'Production Order - Material Requisition';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Mat. Requisition";
            }
            action("Production Order List")
            {
                CaptionML = ENU = 'Production Order List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Prod. Order - List";
            }
            action("Production Order - Shortage List")
            {
                CaptionML = ENU = 'Production Order - Shortage List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Prod. Order - Shortage List";
            }
            action("Production Order Statistics")
            {
                CaptionML = ENU = 'Production Order Statistics';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Production Order Statistics";
            }
        }
    }
}

