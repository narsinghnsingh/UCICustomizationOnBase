page 50024 "Paper Inventory"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = Item;
    SourceTableView = SORTING ("No.")
                      ORDER(Ascending)
                      WHERE ("Roll ID Applicable" = CONST (true));

    layout
    {
        area(content)
        {
            repeater(Control8)
            {
                ShowCaption = false;
                field("Bursting factor(BF)"; "Bursting factor(BF)")
                {
                }
                field("Deckle Size (mm)"; "Deckle Size (mm)")
                {
                }
                field("Paper GSM"; "Paper GSM")
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Paper Type"; "Paper Type")
                {
                }
                field(Inventory; Inventory)
                {
                }
                field("FSC Category"; "FSC Category")
                {
                }
            }
        }
    }

    actions
    {
    }
}

