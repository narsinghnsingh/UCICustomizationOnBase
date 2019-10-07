page 50055 "RM Item Quality Specification"
{
    // version Samadhan Quality

    CardPageID = "RM Quality Specification";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Quality Spec Header";
    SourceTableView = SORTING ("Spec ID")
                      WHERE (Type = CONST ("Other RM"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Spec ID"; "Spec ID")
                {
                }
                field("Estimation No."; "Estimation No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

