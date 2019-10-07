pageextension 50034 Ext_518_PurchaseLines extends "Purchase Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Amt. Rcd. Not Invoiced (LCY)")
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {

            }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
            {

            }
            field(Amount; Amount)
            {

            }
            field("Amount Including VAT"; "Amount Including VAT")
            {

            }
        }
    }
    trigger OnOpenPage()
    begin
        SetRange("Short Closed Document", false);
    end;

}