pageextension 50006 Ext_25_CustomerLedgerEntries extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {

            field("Applies-to Doc. Type"; "Applies-to Doc. Type")
            {

            }
            field("Applies-to Doc. No."; "Applies-to Doc. No.")
            {

            }
            field("Document Date"; "Document Date")
            {

            }
            field("Customer  Name"; "Customer  Name")
            {

            }
            field("Cheque No."; "Cheque No.")
            {

            }
            field("Cheque Date"; "Cheque Date")
            {

            }
            //    field("Sales (LCY)"; "Sales (LCY)")
            //    {

            //  }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast("Ent&ry")
        {
            action("Receipt Voucher")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE(CustLedgerEntry."Document No.", "Document No.");
                    CustLedgerEntry.SETRANGE(CustLedgerEntry."Posting Date", "Posting Date");
                    REPORT.RUNMODAL(REPORT::"Customer - Payment Receipt", TRUE, TRUE, CustLedgerEntry);
                end;
            }
        }
    }

    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
}