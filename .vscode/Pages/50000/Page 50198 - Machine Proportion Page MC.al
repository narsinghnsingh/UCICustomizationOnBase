page 50198 "Machine Proportion Page MC"
{
    PageType = CardPart;
    SourceTable = "Machine Cost Sheet";

    layout
    {
        area(content)
        {
            field("Machine Name";"Machine Name")
            {
            }
            repeater(Control8)
            {
                ShowCaption = false;
                field("No.";"No.")
                {
                }
                field(Name;Name)
                {
                }
                field("Machine Percentage";"Machine Percentage")
                {
                }
                field("Unit Amount";"Unit Amount")
                {
                }
                field("Unit Amount Total";"Unit Amount Total")
                {
                }
            }
        }
    }

    actions
    {
    }
}

