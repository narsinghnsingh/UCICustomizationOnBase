pageextension 50060 Ext_ItemLookup extends "Item Lookup"
{
    layout
    {
        addafter("Unit Price")
        {
            field(Inventory; Inventory)
            {

            }
        }
        addafter("No.")
        {
            field("No. 2"; "No. 2")
            {

            }
        }
    }
}
