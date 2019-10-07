page 50129 "Estimate Fact Box"
{
    Editable = false;
    PageType = CardPart;
    SourceTable = "Production Order";
    SourceTableView = SORTING(Status,"No.")
                      ORDER(Ascending)
                      WHERE(Status=CONST(Released));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Sales Requested Delivery Date";"Sales Requested Delivery Date")
                {
                }
                field("Customer Name";"Customer Name")
                {
                }
                field("Sales Order No.";"Sales Order No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

