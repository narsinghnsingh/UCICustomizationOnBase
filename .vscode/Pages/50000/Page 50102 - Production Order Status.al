page 50102 "Production Order Status"
{
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Production Order";
    SourceTableView = SORTING (Status, "No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field(Status; Status)
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Due Date"; "Due Date")
                {
                }
                field(Blocked; Blocked)
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Customer Name"; "Customer Name")
                {
                }
            }
            part(Control1000000014; "Process Status ListPart")
            {
                Editable = false;
                SubPageLink = Status = FIELD (Status),
                              "Prod. Order No." = FIELD ("No.");
            }
        }
        area(factboxes)
        {
            part("BOM Material Status"; "Material Status ListPart")
            {
                CaptionML = ENU = 'BOM Material Status';
                SubPageLink = Status = FIELD (Status),
                              "Prod. Order No." = FIELD ("No.");
            }
            part("Consumption Posted"; "Posted ILE for Prod ListPart")
            {
                CaptionML = ENU = 'Consumption Posted';
                SubPageLink = "Order No." = FIELD ("No.");
                SubPageView = SORTING ("Item No.", "Posting Date")
                              ORDER(Ascending)
                              WHERE ("Order Type" = CONST (Production),
                                    "Entry Type" = CONST (Consumption));
            }
            part(OutputPosted; "Posted ILE for Prod ListPart")
            {
                CaptionML = ENU = 'Output Posted';
                SubPageLink = "Order No." = FIELD ("No.");
                SubPageView = SORTING ("Item No.", "Posting Date")
                              ORDER(Ascending)
                              WHERE ("Order Type" = CONST (Production),
                                    "Entry Type" = CONST (Output));
            }
        }
    }

    actions
    {
    }
}

