pageextension 50017 Ext_51_PurchaseInvoice extends "Purchase Invoice"
{
    layout
    {
        moveafter("Posting Date"; "Document Date")
        // Add changes to page layout here
        addafter("Assigned User ID")
        {
            field("Posting No."; "Posting No.")
            {

            }
            field("VAT Registration No."; "VAT Registration No.")
            {
                Editable = false;
            }

        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("LC No."; "LC No.")
            {

            }
        }
    }

}