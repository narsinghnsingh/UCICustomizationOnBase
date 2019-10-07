page 50168 "Closed Schedule List"
{
    // version Prod. Schedule

    CardPageID = "Corr. Schedule Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Production Schedule";
    SourceTableView = SORTING ("Schedule No.")
                      ORDER(Ascending)
                      WHERE ("Schedule Closed" = CONST (true));

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

