page 50156 "Sub Form Paper Type"
{
    // version Prod. Schedule

    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Schedule Base Table 2";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Deckle Size"; "Deckle Size")
                {
                }
                field("Paper Type"; "Paper Type")
                {
                }
                field("Avl. in Inventory (kg)"; "Avl. in Inventory (kg)")
                {
                }
                field("Total Requirement (kg)"; "Total Requirement (kg)")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Roll Detail")
            {
                RunObject = Page "Roll Details for Prod. Scdule";
                //RunPageLink = "Deckle Size (mm)"=FIELD("Deckle Size"),
                //             "Paper Type"=FIELD("Paper Type");
                RunPageView = SORTING (Code)
                              ORDER(Ascending);
            }
        }
    }
}

