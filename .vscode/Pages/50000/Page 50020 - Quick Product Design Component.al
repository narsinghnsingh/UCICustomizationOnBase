page 50020 "Quick Product Design Component"
{
    // version Estimate Samadhan

    PageType = CardPart;
    SourceTable = "Quick Entry Process";
    SourceTableView = SORTING("Product Design Type","Product Design No.","Sub Comp No.","Process Code","Paper Position")
                      ORDER(Ascending)
                      WHERE("Work Center Category"=CONST(Materials));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Paper Position";"Paper Position")
                {
                    Editable = false;
                }
                field("Deckle Size";"Deckle Size")
                {
                }
                field("BF (Burst Factor)";"BF (Burst Factor)")
                {
                }
                field("Paper GSM";"Paper GSM")
                {
                }
                field("Flute Type";"Flute Type")
                {
                }
                field("Take Up";"Take Up")
                {
                }
                field("Item Code";"Item Code")
                {
                }
                field("Item Description";"Item Description")
                {
                }
                field("Unit Cost";"Unit Cost")
                {
                }
            }
        }
    }

    actions
    {
    }
}

