pageextension 50030 Ext_146_PostedPurchaseInvoices extends "Posted Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Buy-from Vendor No.")
        {
            field("Vendor Posting Group"; "Vendor Posting Group")
            {

            }
            field("Vendor Segment"; "Vendor Segment")
            {

            }
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {

            }
        }
    }


}