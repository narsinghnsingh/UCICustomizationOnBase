page 50064 "Roll Weight Purch. QA"
{
    // version Samadhan Quality

    DataCaptionFields = Description;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = false;
    UsageCategory = Lists;
    SourceTable = "Item Variant";
    SourceTableView = WHERE (Status = FILTER (PendingforQA | Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                    Editable = false;
                }
                field("Roll Weight"; "Roll Weight")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field(Accepted; Accepted)
                {
                }
                field("Acpt. Under Dev."; "Acpt. Under Dev.")
                {
                }
                field("Acpt. Under Dev. Remark"; "Acpt. Under Dev. Remark")
                {
                }
                field("Rejection Remark"; "Rejection Remark")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(CurrentLocation; CurrentLocation)
                {
                    Editable = false;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Accept All")
            {
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added bY deepak Kumar
                    Item.Reset;
                    if Item.Get("Item No.") then begin
                        //Message('%1', Item."No.");
                        InspectionSheet.Reset;
                        InspectionSheet.SetRange(InspectionSheet."Source Type", InspectionSheet."Source Type"::"Purchase Receipt");
                        InspectionSheet.SetRange(InspectionSheet."Source Document No.", "Purchase Receipt No.");
                        InspectionSheet.SetRange(InspectionSheet."Paper Type", Item."Paper Type");
                        InspectionSheet.SetRange("Paper GSM", Format(Item."Paper GSM"));
                        if not InspectionSheet.FindFirst then
                            Error('You must update item %1 inspection values for Paper type %2 and Paper GSM %3', Item."No.", "Paper Type", "Paper GSM");
                    end;

                    repeat
                        Validate(Accepted, true);
                        Modify(true);
                    until Next = 0;
                    Message('Complete');
                end;
            }
        }
    }

    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PaperRollDetail: Record "Attribute Master";
        TempQty: Decimal;
        DocNo: Code[20];
        DocLineNo: Integer;
        Item: Record Item;
        InspectionSheet: Record "Inspection Sheet";
}

