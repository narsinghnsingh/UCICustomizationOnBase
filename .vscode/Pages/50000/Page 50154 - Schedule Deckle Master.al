page 50154 "Schedule Deckle Master"
{
    // version Prod. Schedule

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Master Deckle Size";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Deckle Size"; "Deckle Size")
                {
                }
            }
        }
    }

    actions
    {
    }
}

