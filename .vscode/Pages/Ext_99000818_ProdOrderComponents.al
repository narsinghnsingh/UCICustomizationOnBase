pageextension 50046 Ext_ProdOrderComponents extends "Prod. Order Components"
{
    layout
    {
        modify("Cost Amount")
        {
            Editable = false;
        }
        addafter("Item No.")
        {
            field("Paper Position"; "Paper Position")
            {
            }
            field("Flute Type"; "Flute Type")
            {
            }
            field("Take Up"; "Take Up")
            {
            }


            field("Act. Consumption (Qty)"; "Act. Consumption (Qty)")
            {
            }

            field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
            {
            }

            field("Substitute Item"; "Substitute Item")
            {
            }
            field("Available Inventory"; "Available Inventory")
            {
            }
            field("Quantity in Prod. Schedule"; "Quantity in Prod. Schedule")
            {
            }
            field("Product Design Type"; "Product Design Type")
            {
            }
            field("Product Design No."; "Product Design No.")
            {
            }
            field("Sub Comp No."; "Sub Comp No.")
            {
            }

            field("Prod Schedule No."; "Prod Schedule No.")
            {
            }

            field("Schedule Component"; "Schedule Component")
            {
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}