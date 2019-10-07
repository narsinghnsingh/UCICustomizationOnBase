pageextension 50062 Ext_5401_ItemVariants extends "Item Variants"
{
    layout
    {
        // Add changes to page layout here
        addafter("Description 2")
        {
            field("MILL Reel No."; "MILL Reel No.")
            {

            }
            field("Remaining Quantity"; "Remaining Quantity")
            {

            }
            field(CurrentLocation; CurrentLocation)
            {

            }
            field("Paper GSM"; "Paper GSM")
            {

            }
            field("Paper Type"; "Paper Type")
            {

            }
            field("Purchase Receipt No."; "Purchase Receipt No.")
            {

            }
            field("Roll Weight"; "Roll Weight")
            {

            }
            field("Roll Inventory"; "Roll Inventory")
            {

            }
            field(Origin; Origin)
            {

            }
            field(Suppiler; Suppiler)
            {

            }
            field("Deckle Size (mm)"; "Deckle Size (mm)")
            {

            }
            field("Vendor Shipment No."; "Vendor Shipment No.")
            {

            }
            field("Purchase Price"; "Purchase Price")
            {

            }
            field("Mill Name"; "Mill Name")
            {

            }
            field("Item Category Code"; "Item Category Code")
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