page 50192 "Load In Printing"
{
    Editable = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Load In Printing";
    SourceTableView = SORTING ("Machine No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule No."; "Schedule No.")
                {
                    Visible = false;
                }
                field("Schedule Date"; "Schedule Date")
                {
                    Visible = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                    Visible = false;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                }
                field("Machine No."; "Machine No.")
                {
                    Visible = false;
                }
                field("Machine Name"; "Machine Name")
                {
                }
                field("Operation No"; "Operation No")
                {
                    Visible = false;
                }
                field("Prod. Order Quanity"; "Prod. Order Quanity")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Quantity To Schedule"; "Quantity To Schedule")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("RPO Finished Quantity"; "RPO Finished Quantity")
                {
                }
                field("RPO Remaining Quantity"; "RPO Remaining Quantity")
                {
                }
                field("Box Quantity"; "Box Quantity")
                {
                }
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("No. Of Ply"; "No. Of Ply")
                {
                }
                field("Top Colour"; "Top Colour")
                {
                }
                field("Board Length(mm)"; "Board Length(mm)")
                {
                }
                field("Board Width(mm)"; "Board Width(mm)")
                {
                }
                field("Product Design No."; "Product Design No.")
                {
                }
                field("Trim %"; "Trim %")
                {
                    Visible = false;
                }
                field("No of Die Cut"; "No of Die Cut")
                {
                }
                field("No. of Joint"; "No. of Joint")
                {
                }
                field(Flute; Flute)
                {
                    Visible = false;
                }
                field("Flute 1"; "Flute 1")
                {
                    Visible = false;
                }
                field("Flute 2"; "Flute 2")
                {
                    Visible = false;
                }
                field("Flute 3"; "Flute 3")
                {
                    Visible = false;
                }
                field("Linear Length(Mtr)"; "Linear Length(Mtr)")
                {
                    Visible = false;
                }
                field("FG GSM"; "FG GSM")
                {
                }
            }
            group(Control28)
            {
                Editable = false;
                ShowCaption = false;
                part(Control36; "Load Sheet Components")
                {
                    SubPageLink = "Prod. Order No." = FIELD ("Prod. Order No."),
                                  "Prod. Order Line No." = FIELD ("Prod. Order Line No.");
                    SubPageView = SORTING (Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.")
                                  ORDER(Ascending)
                                  WHERE ("Schedule Component" = CONST (false));
                }
            }
            group(Control40)
            {
                ShowCaption = false;
                fixed(Control39)
                {
                    ShowCaption = false;
                    group(Control38)
                    {
                        CaptionML = ENU = 'MachineName';
                        field(MachineName; "Machine Name")
                        {
                        }
                    }
                    group(Control43)
                    {
                        CaptionML = ENU = 'Total Box Quantity';
                        field("Total Box Quantity"; "Total Box Quantity")
                        {
                        }
                    }
                    group(Control45)
                    {
                        CaptionML = ENU = 'Customer Name';
                        field("Customer Name"; "Customer Name")
                        {
                        }
                    }
                    group("Sales Order Details")
                    {
                        CaptionML = ENU = 'Sales Order Details';
                        field("Sales Order No"; "Sales Order No")
                        {
                        }
                    }
                    group(Control42)
                    {
                        CaptionML = ENU = 'Customer Order No.';
                        field("Customer Order No."; "Customer Order No.")
                        {
                        }
                    }
                    group(Control16)
                    {
                        CaptionML = ENU = 'Sales Order Quantity';
                        field("Sales Order Quantity"; "Sales Order Quantity")
                        {
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Load")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    ProductionSchedule.CreateLoadDataPrinting;
                end;
            }
        }
    }

    var
        ProductionSchedule: Codeunit Scheduler;
}

