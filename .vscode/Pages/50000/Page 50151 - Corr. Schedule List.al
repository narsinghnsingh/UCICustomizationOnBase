page 50151 "Corr. Schedule List"
{
    // version Prod. Schedule

    CardPageID = "Corr. Schedule Card";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Production Schedule";
    SourceTableView = SORTING("Schedule No.")
                      ORDER(Ascending)
                      WHERE(Status=FILTER(Open),
                            "Schedule Published"=CONST(false),
                            "Schedule Closed"=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule No.";"Schedule No.")
                {
                }
                field("Schedule Date";"Schedule Date")
                {
                }
                field(Status;Status)
                {
                }
                field("Linear Length (mm)";"Linear Length (mm)")
                {
                }
                field("Shift Code";"Shift Code")
                {
                }
                field("Manual Assortment";"Manual Assortment")
                {
                }
                field("Machine Name";"Machine Name")
                {
                }
                field("Avg. Machine Speed Per Min";"Avg. Machine Speed Per Min")
                {
                }
                field("Total Linear Capacity";"Total Linear Capacity")
                {
                }
                field("Linear Cap.Marked for Publish";"Linear Cap.Marked for Publish")
                {
                }
                field("Linear Capacity Published";"Linear Capacity Published")
                {
                }
            }
        }
    }

    actions
    {
    }
}

