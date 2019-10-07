report 50095 "Orderwise Short/Excess Del."
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Orderwise ShortExcess Del.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING ("Document Type", "No.") ORDER(Ascending) WHERE ("Document Type" = FILTER (Order));
            RequestFilterFields = "Order Date";
            column(CompInfo_Name; CompanyInformation.Name)
            {
            }
            column(ALLFILTER; ALLFILTER)
            {
            }
            column(SelltoCustomerNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesHeader; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(OrderDate_SalesHeader; "Sales Header"."Order Date")
            {
            }
            column(Rundate; WorkDate)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                column(DocumentNo_SalesLine; "Sales Line"."Document No.")
                {
                }
                column(ExternalDocNo_SalesLine; "Sales Line"."External Doc. No.")
                {
                }
                column(No_SalesLine; "Sales Line"."No.")
                {
                }
                column(Description_SalesLine; "Sales Line".Description)
                {
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                }
                column(Dispatchedqty; Dispatchedqty)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Dispatchedqty := 0;

                    SalesShipmentLine.Reset;
                    SalesShipmentLine.SetRange(SalesShipmentLine."No.", "No.");
                    SalesShipmentLine.SetRange(SalesShipmentLine."Order No.", "Document No.");
                    SalesShipmentLine.SetRange(SalesShipmentLine."Line No.", "Line No.");
                    if SalesShipmentLine.FindFirst then begin
                        repeat
                            Dispatchedqty := SalesShipmentLine.Quantity;
                        until SalesShipmentLine.Next = 0;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;
                ALLFILTER := "Sales Header".GetFilters;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
        SalesShipmentLine: Record "Sales Shipment Line";
        Dispatchedqty: Decimal;
        ALLFILTER: Text;
}

