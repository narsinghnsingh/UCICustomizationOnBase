page 50227 "FG Item List"
{
    // version FG Report

    Caption = 'FG Item List';
    Editable = false;
    PageType = CardPart;
    SourceTable = Item;
    SourceTableView = SORTING ("No.")
                      ORDER(Ascending)
                      WHERE ("Item Category Code" = CONST ('FG'));

    layout
    {
        area(content)
        {
            repeater(Control7)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Estimate No."; "Estimate No.")
                {
                    Importance = Additional;
                }
                field(Inventory; Inventory)
                {
                }
                field("Customer No."; "Customer No.")
                {
                    Importance = Additional;
                }
                field("Customer Name"; "Customer Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

