page 50087 "Schedule Requisition Subform"
{
    // version Requisition

    PageType = CardPart;
    SourceTable = "Requisition Line SAM";

    layout
    {
        area(content)
        {
            repeater(Control10)
            {
                ShowCaption = false;
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Requisition Line No."; "Requisition Line No.")
                {
                }
                field("Paper Position"; "Paper Position")
                {
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                }
                field("Prod. Order No"; "Prod. Order No")
                {
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                }
                field("Prod. Order Comp. Line No"; "Prod. Order Comp. Line No")
                {
                }
                field("Production Schedule No."; "Production Schedule No.")
                {
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Unit Of Measure"; "Unit Of Measure")
                {
                    Editable = false;
                }
                field("Requested Date"; "Requested Date")
                {
                }
                field("Issued Quantity"; "Issued Quantity")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
                field("Transfer Quantity"; "Transfer Quantity")
                {
                }
                field("Available Inventory"; "Available Inventory")
                {
                    Editable = false;
                }
                field("Validate Origin"; "Validate Origin")
                {
                }
                field("Short Closed Quantity"; "Short Closed Quantity")
                {
                }
                field("Short Closed"; "Short Closed")
                {
                }
                field("Offset Printing"; "Offset Printing")
                {
                }
                field("Paper GSM"; "Paper GSM")
                {
                    Editable = "Offset Printing";
                }
                field("Length of Board (CM)"; "Length of Board (CM)")
                {
                    Editable = "Offset Printing";
                    Visible = false;
                }
                field("Width of Board (CM)"; "Width of Board (CM)")
                {
                    Editable = "Offset Printing";
                    Visible = false;
                }
                field("Extra Material"; "Extra Material")
                {
                }
                field("Quantity In PCS"; "Quantity In PCS")
                {
                    Editable = "Offset Printing";
                    Visible = false;
                }
                field("Make Ready Qty"; "Make Ready Qty")
                {
                    Editable = "Offset Printing";
                    Visible = false;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    Visible = false;
                }
                field("Alternative item by Store"; "Alternative item by Store")
                {
                }
                field("Alt. Item Store Description"; "Alt. Item Store Description")
                {
                }
                field("Alternative item by Prod."; "Alternative item by Prod.")
                {
                }
                field("Alt. item by Prod. Description"; "Alt. item by Prod. Description")
                {
                }
                field("Approved by Store"; "Approved by Store")
                {
                }
                field("Approved by Prod."; "Approved by Prod.")
                {
                }
                field("Previous Item No"; "Previous Item No")
                {
                }
                field("Previous Item Description"; "Previous Item Description")
                {
                }
                field("Published by"; "Published by")
                {
                }
                field(Published; Published)
                {
                }
                field("Part Code"; "Part Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Lines added bY Deepak Kumar

        ReqLine.Reset;
        ReqLine.SetRange(ReqLine."Requisition No.", "Requisition No.");
        if ReqLine.FindLast then begin
            "Requisition Line No." := ReqLine."Requisition Line No." + 1;
        end else begin
            "Requisition Line No." := 1000;
        end;
    end;

    var
        ReqLine: Record "Requisition Line SAM";
}

