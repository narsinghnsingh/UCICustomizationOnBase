page 50085 "Schedule Requisition List"
{
    // version Requisition

    CardPageID = "Schedule Requisition Header";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Requisition Header";
    SourceTableView = SORTING ("Requisition No.")
                      ORDER(Ascending)
                      WHERE ("Requisition Type" = FILTER ("Production Schedule"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Requisition Type"; "Requisition Type")
                {
                }
                field("Schedule Document No."; "Schedule Document No.")
                {
                }
                field("Prod. Order No"; "Prod. Order No")
                {
                }
                field("Requisition Quantity"; "Requisition Quantity")
                {
                }
                field("Ref. Document Number"; "Ref. Document Number")
                {
                }
                field(Description; Description)
                {
                }
                field("Requisition Date"; "Requisition Date")
                {
                }
                field("Offset Printing"; "Offset Printing")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Material Issue")
            {
                Caption = 'Material Issue';
                Image = TransferToLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Material Transfer";
            }
            action("Material Return to Store")
            {
                Caption = 'Material Return to Store';
                Image = TransferToLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Material Return to Store";
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Requisition Type" := "Requisition Type"::"Production Schedule";
    end;
}

