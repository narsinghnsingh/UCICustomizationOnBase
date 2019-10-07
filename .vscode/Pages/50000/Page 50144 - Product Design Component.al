page 50144 "Product Design Component"
{
    // version Estimate Samadhan

    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Product Design Component Table";
    SourceTableView = SORTING("Product Design Type","Product Design No.","Sub Comp No.","Material / Process Link Code")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Design Type";"Product Design Type")
                {
                }
                field("Product Design No.";"Product Design No.")
                {
                }
                field("Sub Comp No.";"Sub Comp No.")
                {
                }
                field("Material / Process Link Code";"Material / Process Link Code")
                {
                }
                field("Item No.";"Item No.")
                {
                }
                field("Item Description";"Item Description")
                {
                }
                field("Component Of";"Component Of")
                {
                }
                field("Routing Link Code";"Routing Link Code")
                {
                }
                field("Date Created";"Date Created")
                {
                }
                field("User ID";"User ID")
                {
                }
                field("Take Up";"Take Up")
                {
                }
                field("Paper Position";"Paper Position")
                {
                }
                field("Flute Type";"Flute Type")
                {
                }
                field("Die Cut Ups";"Die Cut Ups")
                {
                }
                field("No of Joints";"No of Joints")
                {
                }
                field(Quantity;Quantity)
                {
                }
                field("Estimate Quantity";"Estimate Quantity")
                {
                }
            }
        }
    }

    actions
    {
    }
}

