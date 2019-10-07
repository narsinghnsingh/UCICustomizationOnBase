pageextension 50009 Ext_29_VendorLedgerEntries extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Vendor Posting Group"; "Vendor Posting Group")
            {

            }
            field("Document Date"; "Document Date")
            {

            }
            field("Vendor Name"; "Vendor Name")
            {

            }
            field("Cheque No."; "Cheque No.")
            {

            }
            field("Cheque Date"; "Cheque Date")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast("Ent&ry")
        {
            action("Payment voucher")
            {
                ApplicationArea = All;
                Image = Print;

                trigger OnAction()
                begin
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Document No.", "Document No.");
                    VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Posting Date", "Posting Date");
                    REPORT.RUNMODAL(REPORT::"Vendor - Payment Receipt", TRUE, TRUE, VendorLedgerEntry);
                end;
            }
        }
    }

    var

        VendorLedgerEntry: Record "Vendor Ledger Entry";
}