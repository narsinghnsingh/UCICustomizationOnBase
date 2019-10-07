pageextension 50070 Ext_372_BankAccLegEntry extends "Bank Account Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Remaining Amount")
        {
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
    }

    var
        myInt: Integer;
}