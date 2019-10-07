pageextension 50035 Ext_573_DetailedCustLedgEntrie extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Reason Code")
        {
            field("Applied Cust. Ledger Entry No."; "Applied Cust. Ledger Entry No.")
            {

            }
        }
    }

}