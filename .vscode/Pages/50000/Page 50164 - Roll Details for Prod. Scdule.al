page 50164 "Roll Details for Prod. Scdule"
{
    // version Prod. Schedule

    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = "Item Variant";
    SourceTableView = SORTING(Code)
                      ORDER(Ascending)
                      WHERE("Remaining Quantity"=FILTER(<>0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field(Status;Status)
                {
                }
                field(Origin;Origin)
                {
                }
                field(Suppiler;Suppiler)
                {
                }
                field("Paper Type";"Paper Type")
                {
                }
                field("Paper GSM";"Paper GSM")
                {
                }
                field("Deckle Size (mm)";"Deckle Size (mm)")
                {
                }
                field("MILL Reel No.";"MILL Reel No.")
                {
                }
                field("Roll Weight";"Roll Weight")
                {
                    CaptionML = ENU = 'Initial Roll Weight';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }
}

