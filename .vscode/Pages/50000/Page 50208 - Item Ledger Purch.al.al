page 50208 "Item Ledger Purch"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "Item Ledger Entry";
    SourceTableView = SORTING ("Entry No.") ORDER(Descending) WHERE ("Entry Type" = FILTER (Purchase | "Positive Adjmt."));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Cost per Unit"; "Cost per Unit")
                {
                }
            }
        }
    }

    actions
    {
    }
}

