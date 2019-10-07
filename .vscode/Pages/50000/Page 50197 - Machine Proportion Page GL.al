page 50197 "Machine Proportion Page GL"
{
    PageType = StandardDialog;
    SourceTable = "Machine Cost Sheet";

    layout
    {
        area(content)
        {
            repeater(Control8)
            {
                ShowCaption = false;
                field("No.";"No.")
                {
                    Visible = false;
                }
                field("Machine No.";"Machine No.")
                {
                }
                field("Machine Name";"Machine Name")
                {
                }
                field("Machine Percentage";"Machine Percentage")
                {
                }
            }
            field(Name;Name)
            {
            }
        }
    }

    actions
    {
    }
}

