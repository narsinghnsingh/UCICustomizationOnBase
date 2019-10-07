pageextension 50003 Ext_20_GeneralLedgerEntries extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Parking No."; "Parking No.")
            {

            }
            field("System-Created Entry"; "System-Created Entry")
            {

            }
            field("Cheque No."; "Cheque No.")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast("Ent&ry")
        {
            action("Print Voucher")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Print Voucher';
                RunPageOnRec = true;
                Promoted = true;
                PromotedIsBig = true;
                Image = PrepaymentPostPrint;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    GLEntry: Record 17;
                    PostedVoucher: Report "Posted Voucher";
                begin
                    GLEntry.RESET;
                    GLEntry.SETRANGE(GLEntry."Document No.", "Document No.");
                    GLEntry.SETRANGE(GLEntry."Posting Date", "Posting Date");
                    PostedVoucher.SETTABLEVIEW(GLEntry);
                    PostedVoucher.RUN;
                end;
            }
        }
    }

}