page 50072 "Inspection List"
{
    // version Samadhan Quality

    CardPageID = "Inspection Header";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Inspection Header";
    SourceTableView = SORTING ("No.")
                      WHERE (Posted = CONST (false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Job No."; "Job No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Specification ID"; "Specification ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

