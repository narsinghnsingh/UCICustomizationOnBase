pageextension 50027 Ext_143_PostedSalesInvoices extends "Posted Sales Invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer No.")
        {

            field("Sell-to Address"; "Sell-to Address")
            {

            }
            field("Sell-to Address 2"; "Sell-to Address 2")
            {

            }
            field("Sell-to City"; "Sell-to City")
            {

            }
        }
        addafter("Amount Including VAT")
        {
            field("Amount to Customer"; "Amount to Customer")
            {

            }
            field("Posting Time"; "Posting Time")
            {

            }
        }
        addafter("Ship-to Contact")
        {
            field("Ship-to Address"; "Ship-to Address")
            {

            }
            field("Ship-to Address 2"; "Ship-to Address 2")
            {

            }
            field("Ship-to City"; "Ship-to City")
            {

            }
        }
        addafter("Shipment Date")
        {
            field("Driver Name"; "Driver Name")
            {

            }
            field("Vehicle No."; "Vehicle No.")
            {

            }
            field("Document Receiving Received"; "Document Receiving Received")
            {

            }
            field("Document Receiving Remarks"; "Document Receiving Remarks")
            {

            }
            field("Document Received By"; "Document Received By")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
            action("Print Sales Invoice VAT")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETCURRENTKEY(SalesInvHeader."No.");
                    SalesInvHeader.SETRANGE(SalesInvHeader."No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Sales VAT Invoice", TRUE, TRUE, SalesInvHeader);
                end;
            }
        }
        addafter(Navigate)
        {
            action(Action7)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Document Receiving';
                RunObject = Page 50183;
                RunPageView = SORTING ("No.");
                RunPageLink = "No." = FIELD ("No.");
                Promoted = true;
                PromotedIsBig = true;
                Image = Document;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
        }
    }
}