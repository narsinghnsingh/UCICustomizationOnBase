pageextension 50038 Ext_5802_ValueEntries extends "Value Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Item Ledger Entry Type")
        {
            field("Item Ledger Entry Date"; "Item Ledger Entry Date")
            {

            }
        }
        addafter("Document No.")
        {
            field("Order Line No."; "Order Line No.")
            {

            }
        }
        addafter("Item Charge No.")
        {
            field("Inventory Posting Group"; "Inventory Posting Group")
            {

            }
        }
    }


}