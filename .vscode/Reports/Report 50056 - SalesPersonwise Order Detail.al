report 50056 "SalesPersonwise Order Detail"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/SalesPersonwise Order Detail.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING ("Document Type", "No.") ORDER(Ascending) WHERE ("Document Type" = FILTER (Order));
            RequestFilterFields = "Posting Date";
            column(COMNAME; COMINFO.Name)
            {
            }
            column(SalespersonCode_SalesHeader; "Sales Header"."Salesperson Code" + ' ' + ' ( ' + SALESPERSON_NAME + ' ) ')
            {
            }
            column(SelltoCustomerName_SalesHeader; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(PostingDate_SalesHeader; "Sales Header"."Posting Date")
            {
            }
            column(MINDATE; Format(' FROM  ') + '  ' + Format(MINDATE))
            {
            }
            column(MAXDATE; Format(' TO ') + ' ' + Format(MAXDATE))
            {
            }
            column(CurrencyCode; "Sales Header"."Currency Code")
            {
            }
            column(LCYCurrencyFactor; LCYCurrencyFactor)
            {
            }
            column(CUST_SEGMENT; CUST_SEGMENT)
            {
            }
            column(SALESPERSON_NAME; SALESPERSON_NAME)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE ("Document Type" = FILTER (Order));
                column(No_SalesLine; "Sales Line"."No.")
                {
                }
                column(Description_SalesLine; "Sales Line".Description)
                {
                }
                column(UnitofMeasureCode_SalesLine; "Sales Line"."Unit of Measure Code")
                {
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                }
                column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                {
                }
                column(LineAmount_SalesLine; "Sales Line"."Line Amount")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                MINDATE := "Sales Header".GetRangeMin("Sales Header"."Posting Date");
                MAXDATE := "Sales Header".GetRangeMax("Sales Header"."Posting Date");
                LCYCurrencyFactor := 1 / "Currency Factor";
                COMINFO.Get;

                SALESPERSON_PURCHASER.Reset;
                SALESPERSON_PURCHASER.SetRange(SALESPERSON_PURCHASER.Code, "Salesperson Code");
                if SALESPERSON_PURCHASER.FindFirst then begin
                    SALESPERSON_NAME := SALESPERSON_PURCHASER.Name
                end else begin
                    SALESPERSON_NAME := '';
                end;

                Customer.Reset;
                Customer.SetRange(Customer."No.", "Sell-to Customer No.");
                if Customer.FindFirst then begin
                    CUST_SEGMENT := Customer."Customer Segment";
                end else begin
                    CUST_SEGMENT := '';
                end;
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
        COMINFO: Record "Company Information";
        MINDATE: Date;
        MAXDATE: Date;
        SALESPERSON_PURCHASER: Record "Salesperson/Purchaser";
        SALESPERSON_NAME: Text[50];
        LCYCurrencyFactor: Decimal;
        Customer: Record Customer;
        CUST_SEGMENT: Code[30];
}

