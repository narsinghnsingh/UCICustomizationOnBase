pageextension 50039 Ext_5832_CapacityLedgerEntries extends "Capacity Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Order No.")
        {
            field("Order Line No."; "Order Line No.")
            {

            }
        }
        addafter("Work Shift Code")
        {
            field("Start Date"; "Start Date")
            {

            }
            field("End Date"; "End Date")
            {

            }
        }
        addafter("Concurrent Capacity")
        {
            field("Last Output Line"; "Last Output Line")
            {

            }
        }
    }

}