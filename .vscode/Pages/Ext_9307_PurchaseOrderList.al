pageextension 50066 Ext_9307_PurchOrderList extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Vendor Segment"; "Vendor Segment")
            {

            }
        }
        modify(Amount)
        {
            Visible = false;
        }

        modify("Amount Including VAT")
        {
            Visible = false;
        }

        addafter("Posting Description")
        {
            field("Amount Inc. VAT"; "Amount Inc. VAT")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
            action("Print VAT Purchase Order")
            {
                Image = Print;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETCURRENTKEY(PurchaseHeader."No.");
                    PurchaseHeader.SETRANGE(PurchaseHeader."No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Print VAT Order", TRUE, TRUE, PurchaseHeader);
                end;
            }
        }
    }

    var
        myInt: Integer;
}