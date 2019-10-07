pageextension 50051 Ext_ReleasedProdOrderLines extends "Released Prod. Order Lines"
{
    layout
    {
        addafter("Production BOM No.")
        {
            field("Item Category Code"; "Item Category Code")
            {
            }
            field("Inventory Posting Group"; "Inventory Posting Group")
            {
            }
            field("Product Design Type"; "Product Design Type")
            {
            }
            field("Product Design No."; "Product Design No.")
            {
            }
            field("Estimate Code"; "Estimate Code")
            {
            }
            field("Sub Comp No."; "Sub Comp No.")
            {
            }
            field("Sales Order No."; "Sales Order No.")
            {
            }
            field("Sales Order Line No."; "Sales Order Line No.")
            {
            }
        }
    }

    actions
    {
        addafter(ProductionJournal)
        {
            action("Print Pallet Tag")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Line No.");
                    if ProdOrderLine.FindFirst then;
                    REPORT.RunModal(REPORT::"RPO WISE Pallet Tag", true, true, ProdOrderLine);
                end;
            }
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
                    REPORT.RunModal(REPORT::"JOB CARD CORRUGATION", true, true, ProdOrderLine);
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
                        REPORT.RunModal(REPORT::"JOB CARD PRINTING", true, true, ProdOrderLine);
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
                    REPORT.RunModal(REPORT::"SUB JOBCARD CORRUGATION", true, true, ProdOrderLine);
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
                    REPORT.RunModal(REPORT::"SUBJOB CARD PRINTING&FINISHING", true, true, ProdOrderLine);
                end;
            }
            action("Print Die Requistion")
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
                    REPORT.RunModal(REPORT::"DIE Requistion", true, true, ProdOrderLine);
                end;
            }
            action("Print Plate Requistion")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetCurrentKey(ProdOrderLine."Prod. Order No.");
                    //ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.","Prod. Order No.");
                    //ProdOrderLine.SETRANGE(ProdOrderLine."Product Design Type","Product Design Type");
                    CurrPage.SetSelectionFilter(ProdOrderLine);
                    REPORT.RunModal(REPORT::"Plate Requistion", true, true, ProdOrderLine);
                end;
            }
        }
    }

    var
        ProdOrderLine: Record "Prod. Order Line";
}