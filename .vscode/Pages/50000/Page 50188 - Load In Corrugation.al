page 50188 "Load In Corrugation"
{
    Editable = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Load In Corrugartion";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
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
                field("Quantity in Other Schedules"; "Quantity in Other Schedules")
                {
                }
                field("Sales Order Quantity"; "Sales Order Quantity")
                {
                }
                field("Schedule No."; "Schedule No.")
                {
                }
                field("Net Weight"; "Net Weight")
                {
                    Caption = 'Net Weight (to Be Scheduled)';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Net Weight (Other Schedule)"; "Net Weight (Other Schedule)")
                {
                }
                field("M2 Weight"; "M2 Weight")
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
                field("Customer Name"; "Customer Name")
                {
                }
                field("Planned Deckle Size(mm)"; "Planned Deckle Size(mm)")
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
                field("GSM Identifier"; "GSM Identifier")
                {
                }
                field("Extra Trim(mm)"; "Extra Trim(mm)")
                {
                }
                field("Trim %"; "Trim %")
                {
                }
                field("No of Die Cut"; "No of Die Cut")
                {
                }
                field("No. of Joint"; "No. of Joint")
                {
                }
                field(Flute; Flute)
                {
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
                }
                field("Calculated No. of Ups"; "Calculated No. of Ups")
                {
                    Visible = false;
                }
                field("No. of Ups (Estimated)"; "No. of Ups (Estimated)")
                {
                    Visible = false;
                }
                field("Estimation Sub Job No."; "Estimation Sub Job No.")
                {
                    Visible = false;
                }
                field("Trim Product Design"; "Trim Product Design")
                {
                    Visible = false;
                }
                field("Trim (mm)"; "Trim (mm)")
                {
                    Visible = false;
                }
                field("Trim Weight"; "Trim Weight")
                {
                }
                field("Extra Trim Weight"; "Extra Trim Weight")
                {
                    Visible = false;
                }
                field("Cut Size (mm)"; "Cut Size (mm)")
                {
                    Visible = false;
                }
                field("FG GSM"; "FG GSM")
                {
                }
                field("Sales Order No"; "Sales Order No")
                {
                    Visible = false;
                }
                field("Customer Order No."; "Customer Order No.")
                {
                    Visible = false;
                }
                field("DB Paper"; "DB Paper")
                {
                    Visible = false;
                }
                field("1M Paper"; "1M Paper")
                {
                    Visible = false;
                }
                field("1L Paper"; "1L Paper")
                {
                    Visible = false;
                }
                field("2M Paper"; "2M Paper")
                {
                    Visible = false;
                }
                field("2L Paper"; "2L Paper")
                {
                    Visible = false;
                }
                field("3M Paper"; "3M Paper")
                {
                    Visible = false;
                }
                field("3L paper"; "3L paper")
                {
                    Visible = false;
                }
                field(SchedulerIdentifier; SchedulerIdentifier)
                {
                    Visible = false;
                }
            }
            group(Control63)
            {
                Editable = false;
                ShowCaption = false;
                part(Control62; "Load Sheet Components")
                {
                    SubPageLink = "Prod. Order No." = FIELD ("Prod. Order No."),
                                  "Prod. Order Line No." = FIELD ("Prod. Order Line No.");
                    SubPageView = SORTING (Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.")
                                  ORDER(Ascending)
                                  WHERE ("Schedule Component" = CONST (false));
                }
            }
            group(Control73)
            {
                ShowCaption = false;
                fixed(Control72)
                {
                    ShowCaption = false;
                    group(Control16)
                    {
                        ShowCaption = false;
                        field(MachineName; "Machine Name")
                        {
                        }
                    }
                    group(Date)
                    {
                        Caption = 'Date';
                        field("Schedule Date"; "Schedule Date")
                        {
                        }
                    }
                    group(Control65)
                    {
                        Caption = 'Total Linear Length(Mtr)';
                        field("Total Linear Length(Mtr)"; "Total Linear Length(Mtr)")
                        {
                        }
                    }
                    group(Control50)
                    {
                        Caption = 'Total Net Weight';
                        field("Total Net Weight"; "Total Net Weight")
                        {
                        }
                    }
                    group(Control70)
                    {
                        Caption = 'Total M2 Weight';
                        field("Total M2 Weight"; "Total M2 Weight")
                        {
                        }
                    }
                    group(Control71)
                    {
                        Caption = 'Total Box Quantity';
                        field("Total Box Quantity"; "Total Box Quantity")
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
                    ProductionSchedule.CreateLoadData;
                end;
            }
        }
    }

    var
        ProductionSchedule: Codeunit Scheduler;
}

