pageextension 50022 Ext_130_PostedSalesShipment extends "Posted Sales Shipment"
{
    actions
    {
        // Add changes to page actions here
        addafter(CertificateOfSupplyDetails)
        {
            action("Gate Pass")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = Print;
                trigger OnAction()
                begin
                    SalesShptHeader.RESET;
                    SalesShptHeader.SETRANGE(SalesShptHeader."No.", "No.");
                    REPORT.RUNMODAL(REPORT::GatePassNew, TRUE, TRUE, SalesShptHeader);
                end;
            }
            action(Action13)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Delivery Challan';
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Report;
                trigger OnAction()
                begin
                    SalesShptHeader.RESET;
                    SalesShptHeader.SETRANGE(SalesShptHeader."No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Delivery Note", TRUE, TRUE, SalesShptHeader);
                end;
            }
        }
        addafter("&Navigate")
        {
            action("Update Prod. order No. in Sales Shipment line.")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Update Prod. order No. in Sales Shipment line.';
                trigger OnAction()
                begin
                    //Lines added by Firoz 13-10-15
                    SaleShipmentLine.RESET;
                    IF SaleShipmentLine.FINDFIRST THEN BEGIN
                        REPEAT
                            PackingListLine.RESET;
                            PackingListLine.SETRANGE(PackingListLine."Sales Shipment No.", SaleShipmentLine."Document No.");
                            PackingListLine.SETRANGE(PackingListLine."Item No.", SaleShipmentLine."No.");
                            IF PackingListLine.FINDFIRST THEN BEGIN
                                SaleShipmentLine."Prod. Order No." := PackingListLine."Prod. Order No.";
                                SaleShipmentLine.MODIFY(TRUE);
                                MESSAGE(PackingListLine."Prod. Order No.");
                            END;
                        UNTIL SaleShipmentLine.NEXT = 0;

                        MESSAGE('Completed');

                    END;
                end;
            }
        }

    }

    var
        SaleShipmentLine: Record "Sales Shipment Line";
        PackingListLine: Record "Packing List Line";
        SalesShptHeader: Record "Sales Shipment Header";
}