pageextension 50025 Ext_139_PostedPurchInvoiceSubf extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Line Discount %")
        {
            field(Amount; Amount)
            {

            }
            field("Amount Including VAT"; "Amount Including VAT")
            {

            }
            field("VAT %"; "VAT %")
            {

            }
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {

            }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
            {

            }
        }
    }

}