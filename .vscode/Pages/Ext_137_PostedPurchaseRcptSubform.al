pageextension 50071 PostedPurchRctSubform extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        addfirst(Control1)
        {
            field("Posting Date"; "Posting Date")
            {

            }
            field("Document No."; "Document No.")
            {

            }
            field("Line No."; "Line No.")
            {

            }
            field("Item Category Code"; "Item Category Code")
            {

            }
            field("Buy-from Vendor Name"; "Buy-from Vendor Name")
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