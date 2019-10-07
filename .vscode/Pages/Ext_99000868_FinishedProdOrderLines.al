pageextension 50052 Ext_Finished_Prod_Order_Lines extends "Finished Prod. Order Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Product Design Type"; "Product Design Type")
            {
            }
            field("Product Design No."; "Product Design No.")
            {
            }
            field("Sales Order No."; "Sales Order No.")
            {
            }
        }
    }

    actions
    {
        addafter("Item &Tracking Lines")
        {
            action("Print Job Card Corrugation")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetCurrentKey(ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Line No.");
                    REPORT.RunModal(REPORT::"JOB CARD CORRUGATION(Finished)", true, true, ProdOrderLine);
                end;
            }
            action("Print Job Card Printing & Finishing")
            {
                Caption = 'Print Job Card Printing and Finishing';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetCurrentKey(ProdOrderLine."Prod. Order No.", ProdOrderLine."Item No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Line No.");
                    if ProdOrderLine.FindFirst then
                        REPORT.RunModal(REPORT::"JOB CARD PRINTING(Finished)", true, true, ProdOrderLine);
                end;
            }
            action("Print SubJOb Corrugation")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetCurrentKey(ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Line No.");
                    REPORT.RunModal(REPORT::"SUB JOBCARD CORRUGATION(Finis)", true, true, ProdOrderLine);
                end;
            }
            action("Print SubJob Printing and Finishing")
            {
                Caption = 'Print SubJob Printing and Finishing';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetCurrentKey(ProdOrderLine."Prod. Order No.", ProdOrderLine."Line No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Line No.");
                    REPORT.RunModal(REPORT::"SUBJOB PRINTING&FINISHING(Fin)", true, true, ProdOrderLine);
                end;
            }
        }
    }

    var
        ProdOrderLine: Record "Prod. Order Line";
}