page 50175 "Packing List Quantity"
{
    // version Dispatch

    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Prod. Order Line";
    SourceTableView = SORTING(Status,"Prod. Order No.","Line No.")
                      ORDER(Ascending)
                      WHERE(Status=CONST(Released),
                            "Item Category Code"=CONST('FG'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prod. Order No.";"Prod. Order No.")
                {
                    Editable = false;
                }
                field("Line No.";"Line No.")
                {
                    Editable = false;
                }
                field("Item No.";"Item No.")
                {
                    Editable = false;
                }
                field(Description;Description)
                {
                    Editable = false;
                }
                field(Quantity;Quantity)
                {
                    Editable = false;
                }
                field("Finished Quantity";"Finished Quantity")
                {
                    Editable = false;
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                }
                field("Packing List Qty";"Packing List Qty")
                {
                }
                field("Sales Order No.";"Sales Order No.")
                {
                    Editable = false;
                }
                field("LPO No.";"LPO No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

