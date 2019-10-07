page 50059 "Quality Parameters"
{
    // version Samadhan Quality

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Quality Parameters";

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
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field(Quantitative; Quantitative)
                {
                }
                field(Qualitative; Qualitative)
                {
                }
                field("Work Center Group"; "Work Center Group")
                {
                }
            }
        }
    }

    actions
    {
    }
}

