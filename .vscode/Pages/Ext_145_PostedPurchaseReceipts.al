pageextension 50029 Ext_145_PostedPurchaseReceipts extends "Posted Purchase Receipts"
{
    layout
    {
        // Add changes to page layout here
        addafter("Buy-from Vendor Name")
        {
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {

            }
            field("Vendor Posting Group"; "Vendor Posting Group")
            {

            }
            field("Order No."; "Order No.")
            {

            }
            field(LineQty; LineQty)
            {
                CaptionML = ENU = 'Total Quantity';
            }
        }
        addafter("Ship-to Code")
        {
            field("Applies-to Doc. Type"; "Applies-to Doc. Type")
            {

            }
            field("Vendor Order No."; "Vendor Order No.")
            {

            }
        }
        addafter("Ship-to Post Code")
        {
            field("Vendor Segment"; "Vendor Segment")
            {

            }
        }
        addafter("Shipment Method Code")
        {
            field("Vendor Shipment No."; "Vendor Shipment No.")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Navigate")
        {
            action("Print GRN")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Report;
                trigger OnAction()
                begin
                    PREC_HEADER.RESET;
                    PREC_HEADER.SETCURRENTKEY(PREC_HEADER."No.");
                    PREC_HEADER.SETRANGE(PREC_HEADER."No.", "No.");
                    REPORT.RUNMODAL(REPORT::GRN, TRUE, TRUE, PREC_HEADER);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CLEAR(LineQty);
        PurchRcptLine.RESET;
        PurchRcptLine.SETRANGE("Document No.", "No.");
        IF PurchRcptLine.FIND('-') THEN
            REPEAT
                LineQty := LineQty + PurchRcptLine.Quantity;
            UNTIL PurchRcptLine.NEXT = 0;
    end;


    var
        PREC_HEADER: Record "Purch. Rcpt. Header";
        LineQty: Decimal;
        PurchRcptLine: Record "Purch. Rcpt. Line";
}