page 50142 "Company Sales Price"
{
    // version Sales Price

    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Sales Price";
    SourceTableView = SORTING ("Sales Type", "Sales Code", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
                      ORDER(Ascending)
                      WHERE ("Sales Type" = CONST ("All Customers"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Starting Date"; "Starting Date")
                {
                }
                field("No. of Ply"; "No. of Ply")
                {
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                    CaptionML = ENU = 'Unit Price per KG';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Sales Type" := "Sales Type"::"All Customers";
    end;
}

