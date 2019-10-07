pageextension 50076 Ext_516_SalesLines extends "Sales Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Outstanding Quantity")
        {
            field("Quantity Invoiced"; "Quantity Invoiced")
            {

            }
            field("Quantity Shipped"; "Quantity Shipped")
            {

            }
            field("Order Quantity (Weight)"; "Order Quantity (Weight)")
            {

            }
            field("Outstanding  Quantity (Weight)"; "Outstanding  Quantity (Weight)")
            {

            }
            field("Net Weight"; "Net Weight")
            {

            }
            field("Outstanding Amount (LCY)"; "Outstanding Amount (LCY)")
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