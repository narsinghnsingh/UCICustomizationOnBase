pageextension 50024 Ext_136_PostedPurchaseRecipt extends "Posted Purchase Receipt"
{
    layout
    {
        // Add changes to page layout here
        addafter("Responsibility Center")
        {
            field("Quality Applicable"; "Quality Applicable")
            {

            }
            field("Quality Posted"; "Quality Posted")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Navigate")
        {
            action(Action3)
            {
                ApplicationArea = All;
                CaptionML = ENU = '&Print GRN';
                Promoted = true;
                Image = Print;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    PurchRcptHeader.RESET;
                    PurchRcptHeader.SETCURRENTKEY(PurchRcptHeader."No.");
                    PurchRcptHeader.SETRANGE(PurchRcptHeader."No.", "No.");
                    REPORT.RUNMODAL(REPORT::GRN, TRUE, TRUE, PurchRcptHeader);
                end;
            }
            action("Reel Details")
            {
                ApplicationArea = All;
                RunObject = Report "GRV Details";
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Report;
                trigger OnAction()
                begin

                end;
            }
            action("Print Label")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Report;
                trigger OnAction()
                begin
                    ITEM_VARIANT.RESET;
                    ITEM_VARIANT.SETCURRENTKEY("Purchase Receipt No.");
                    ITEM_VARIANT.SETRANGE(ITEM_VARIANT."Purchase Receipt No.", "No.");
                    REPORT.RUNMODAL(REPORT::Label, TRUE, TRUE, ITEM_VARIANT);
                end;
            }
        }

    }

    var
        ITEM_VARIANT: Record "Item Variant";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
}