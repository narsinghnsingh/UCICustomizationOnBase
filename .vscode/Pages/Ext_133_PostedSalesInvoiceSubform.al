pageextension 50023 Ext_132_PostedSalesInvoice extends "Posted Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Prod. Order No."; "Prod. Order No.")
            {

            }

        }
        addafter(Quantity)
        {
            field("Prod. Order Line No."; "Prod. Order Line No.")
            {

            }
        }
        addafter("Job No.")
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {

            }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
            {

            }
        }
    }

}