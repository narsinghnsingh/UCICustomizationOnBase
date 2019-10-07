pageextension 50020 Ext_98_PurchCrMemoSubform extends "Purch. Cr. Memo Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Nonstock)
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {

            }
        }
        addafter("Unit Price (LCY)")
        {
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {

            }
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {

            }
        }
    }

}