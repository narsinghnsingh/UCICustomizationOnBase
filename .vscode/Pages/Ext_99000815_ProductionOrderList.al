pageextension 50065 Ext_99000815_ProdOrderList extends "Production Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Search Description")
        {
            field("Customer Name"; "Customer Name")
            {

            }
            field("Repeat Job"; "Repeat Job")
            {

            }
            field("Prev. Job No."; "Prev. Job No.")
            {

            }
            field("Finished Quantity"; "Finished Quantity")
            {

            }
            field("Remaining Quantity"; "Remaining Quantity")
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