pageextension 50041 Ext_ItemJournal extends "Item Journal"
{
    layout
    {
        addafter("Reason Code")
        {
            field("Order Type"; "Order Type")
            {
            }
            field("Order No."; "Order No.")
            {
            }
            field("Order Line No."; "Order Line No.")
            {
            }
            field("Production Order Sam"; "Production Order Sam")
            {
                Caption = 'Production Order-New';
            }
            field("Prod. Order Line No. Sam"; "Prod. Order Line No. Sam")
            {
                Caption = 'Prod. Order Line No.-New';
            }
            field("Other Consumption Type"; "Other Consumption Type")
            {
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


}