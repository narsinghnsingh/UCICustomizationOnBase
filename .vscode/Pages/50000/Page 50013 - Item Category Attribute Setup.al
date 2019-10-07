page 50013 "Item Category Attribute Setup"
{
    PageType = Worksheet;
    UsageCategory = Administration;
    SourceTable = "Item Cat. Attribute Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Item Attribute"; "Item Attribute")
                {
                }
                field("Item Attribute Caption"; "Item Attribute Caption")
                {
                }
                field("Sorting Order"; "Sorting Order")
                {
                }
                field("Add on Description"; "Add on Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

