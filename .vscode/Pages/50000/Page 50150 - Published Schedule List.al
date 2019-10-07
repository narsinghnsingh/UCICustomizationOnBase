page 50150 "Published Schedule List"
{
    // version Prod. Schedule

    CardPageID = "Corr. Schedule Card";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Production Schedule";
    SourceTableView = SORTING ("Schedule No.")
                      ORDER(Ascending)
                      WHERE ("Schedule Published" = CONST (true),
                            "Schedule Closed" = CONST (false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule No."; "Schedule No.")
                {
                }
                field("Schedule Date"; "Schedule Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Linear Length (mm)"; "Linear Length (mm)")
                {
                }
                field("Shift Code"; "Shift Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

