page 50165 "Paper Type Additional Cost"
{
    // version Estimation

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Paper Type Price";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Start Date";"Start Date")
                {
                }
                field("Paper Type";"Paper Type")
                {
                }
                field("Add On % for Est. Cost";"Add On % for Est. Cost")
                {
                }
            }
        }
    }

    actions
    {
    }
}

