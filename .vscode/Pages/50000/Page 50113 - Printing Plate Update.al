page 50113 "Printing Plate Update"
{
    // version Samadhan Plate

    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Prod. Order Routing Line";
    SourceTableView = WHERE (Status = FILTER (Released),
                            "Printing Plate Applicable" = FILTER (true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("RPO Description"; "RPO Description")
                {
                }
                field("Printing Plate"; "Printing Plate")
                {
                }
                field("Replace Printing Plate"; "Replace Printing Plate")
                {
                }
                field("Mother Job No."; "Mother Job No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Purchase Order")
            {
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }
}

