page 50071 "Sampling Code"
{
    // version Samadhan Quality

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Sampling Plan QA";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Status; Status)
                {
                }
                field("Sampling Type"; "Sampling Type")
                {
                }
                field("Fixed Quantity"; "Fixed Quantity")
                {
                }
                field("Lot Percentage"; "Lot Percentage")
                {
                }
            }
        }
    }

    actions
    {
    }
}

