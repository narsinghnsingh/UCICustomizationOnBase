page 50118 "Machine Center Prices"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "M/W Price List";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Price Based Condition"; "Price Based Condition")
                {
                    Editable = false;
                }
                field("Condition Value"; "Condition Value")
                {
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Maximum Quantity"; "Maximum Quantity")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Work Center Category"; "Work Center Category")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

