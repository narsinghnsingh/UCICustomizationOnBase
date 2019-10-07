page 50019 "Quick Product Design Routing"
{
    // version Estimate Samadhan

    PageType = CardPart;
    SourceTable = "Quick Entry Process";
    SourceTableView = SORTING("Product Design Type","Product Design No.","Sub Comp No.","Process Code","Paper Position")
                      ORDER(Ascending)
                      WHERE("Work Center Category"=FILTER(<>Materials));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Process Code";"Process Code")
                {
                }
                field("Process Description";"Process Description")
                {
                }
                field(Required;Required)
                {
                }
                field("Unit Cost";"Unit Cost")
                {
                }
                field("Line Amount";"Line Amount")
                {
                }
                field(Type;Type)
                {
                    Editable = false;
                }
                field("No.";"No.")
                {
                }
                field(Description;Description)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

