pageextension 50026 Ext_142_PostedSaleShipments extends "Posted Sales Shipments"
{
    layout
    {
        // Add changes to page layout here
        addafter("Posting Date")
        {
            field("Posting Time"; "Posting Time")
            {

            }
            // field("Order No."; "Order No.")
            // {

            // }
            field("Vehicle No."; "Vehicle No.")
            {

            }
            field("Driver Name"; "Driver Name")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Track Package")
        {
            action("Delivery Order Detail")
            {
                ApplicationArea = All;
                RunObject = Page 50205;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
            action("Print Delivery Note")
            {
                ApplicationArea = All;
                Ellipsis = true;
                Caption = 'Print Delivery Note';
                Promoted = true;
                Image = Print;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    SalesShptHeader: Record "Sales Shipment Header";
                begin
                    SalesShptHeader.RESET;
                    SalesShptHeader.SETRANGE(SalesShptHeader."No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Delivery Note", TRUE, TRUE, SalesShptHeader);
                end;
            }
            action("Print VAT  Delivery Note")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader.RESET;
                    SalesShipmentHeader.SETCURRENTKEY(SalesShipmentHeader."No.");
                    SalesShipmentHeader.SETRANGE(SalesShipmentHeader."No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Delivery Note VAT", TRUE, TRUE, SalesShipmentHeader);
                end;
            }
            action("Print VAT Delivery Note Consolidate")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Print VAT Delivery Note Consolidate';
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    SalesShipmentHeader1: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader1.RESET;
                    SalesShipmentHeader1.SETCURRENTKEY(SalesShipmentHeader1."No.");
                    SalesShipmentHeader1.SETRANGE(SalesShipmentHeader1."No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Delivery Note VAT Consolidate", TRUE, TRUE, SalesShipmentHeader1);
                end;
            }
        }
    }

}