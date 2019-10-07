page 50226 "Prod. Order Line"
{
    // version FG Report

    Caption = 'Prod. Order Details';
    Editable = false;
    PageType = CardPart;
    SourceTable = "Prod. Order Line";
    SourceTableView = SORTING (Status, "Prod. Order No.", "Line No.")
                      ORDER(Ascending)
                      WHERE (Status = CONST (Released));

    layout
    {
        area(content)
        {
            repeater(Control37)
            {
                IndentationControls = Description;
                ShowCaption = false;
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Planning Flexibility"; "Planning Flexibility")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Production BOM No."; "Production BOM No.")
                {
                    Visible = false;
                }
                field("Routing No."; "Routing No.")
                {
                    Visible = false;
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
                field("Estimate Code"; "Estimate Code")
                {
                    Visible = false;
                }
                field("Sub Comp No."; "Sub Comp No.")
                {
                    Visible = false;
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field("Sales Order Line No."; "Sales Order Line No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

