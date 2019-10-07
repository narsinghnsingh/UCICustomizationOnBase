page 50011 "Item Attribute "
{
    PageType = List;
    SourceTable = "Attribute Master";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Attribute Code"; "Attribute Code")
                {
                }
                field("Attribute Description"; "Attribute Description")
                {
                }
                field(Master; Master)
                {
                }
                field("Master List"; "Master List")
                {
                }
                field("Field Type"; "Field Type")
                {
                }
                field("Suffix Add on Description"; "Suffix Add on Description")
                {
                }
                field("Add on Des. (Postfix)"; "Add on Des. (Postfix)")
                {
                }
                field("Add on Des. (Prefix)"; "Add on Des. (Prefix)")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Attribute Value")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                RunObject = Page "Item Attribute Value";
                RunPageLink = "Attribute Code" = FIELD ("Attribute Code"),
                              "Field Type" = FIELD ("Field Type");
                RunPageView = SORTING ("Attribute Code")
                              ORDER(Ascending);
            }
        }
    }
}

