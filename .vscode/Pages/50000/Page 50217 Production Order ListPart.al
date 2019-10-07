page 50217 "Production Order ListPart"
{
    // version NAVW18.00

    Caption = 'Production Order List';
    DataCaptionFields = Status;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Production Order";

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
                field(Description; Description)
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Routing No."; "Routing No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Finished Quantity"; "Finished Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
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
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field("Finished Date"; "Finished Date")
                {
                    Visible = false;
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Repeat Job"; "Repeat Job")
                {
                }
                field("Prev. Job No."; "Prev. Job No.")
                {
                }
                field(Status; Status)
                {
                }
                field("Search Description"; "Search Description")
                {
                }
            }
        }

    }

}

