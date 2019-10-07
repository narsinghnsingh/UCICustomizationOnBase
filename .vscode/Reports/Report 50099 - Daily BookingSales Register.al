report 50099 "Daily Booking/Sales Register"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Daily BookingSales Register.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
        {
            DataItemTableView = WHERE (Type = CONST ("Sales Person"));
            RequestFilterFields = "Code";
            column(SalesPersonCode; Code)
            {
            }
            column(SalesPersonName; Name)
            {
            }
            column(PreviousDayVal; PreviousDayVal)
            {
            }
            column(InvoiceTillDateVal; InvoiceTillDateVal)
            {
            }
            column(EndTotalPreviousValue; EndTotalPreviousValue)
            {
            }
            column(CURRENCYRATE2; CURRENCYRATE2)
            {
            }
            column(EndTotaltodayinvoice; EndTotaltodayinvoice)
            {
            }
            column(Sysdate; WorkDate)
            {
            }
            column(EndTotalTillInvoice; EndTotalTillInvoice)
            {
            }
            column(TodayInvValue; TodayInvValue)
            {
            }
            column(DateFilter; DateFilter1)
            {
            }
            column(prePreviousDayVal; prePreviousDayVal)
            {
            }
            column(PreviousDayweight; PreviousDayweight)
            {
            }
            column(TodaysInvWeight; TodaysInvWeight)
            {
            }
            column(InvoiceTillDateWeight; InvoiceTillDateWeight)
            {
            }
            column(EndTotalTodayinvWeight; EndTotalTodayinvWeight)
            {
            }
            column(EndTotalPreviousWeght; EndTotalPreviousWeght)
            {
            }
            column(EndTotalInvoiceWeght; EndTotalInvoiceWeght)
            {
            }
            column(CURRENCYRATE1; CURRENCYRATE1)
            {
            }
            column(CURRENCYRATE3; CURRENCYRATE3)
            {
            }
            column(CURRENCYRATE4; CURRENCYRATE4)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Salesperson Code" = FIELD (Code);
                DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE ("Document Type" = FILTER (Order | "Blanket Order"));
                RequestFilterFields = "Order Date";
                column(DocumentType_SalesLine; "Sales Line"."Document Type")
                {
                }
                column(ProdOrdNo; JObNo)
                {
                }
                column(Amount; TodayVal)
                {
                }
                column(quantity; Qty)
                {
                }
                column(UnitPrice; UnitCost)
                {
                }
                column(ExternalDocNo_SalesLine; "Sales Line"."External Doc. No.")
                {
                }
                column(Description; ItemDescription)
                {
                }
                column(CustName; CustName)
                {
                }
                column(CompName; CompName)
                {
                }
                column(TodayWeght; TodayWeght)
                {
                }
                column(CUST_SEGMENT; CUST_SEGMENT)
                {
                }
                column(sRnO; sRnO)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TodayVal := 0;
                    JObNo := '';
                    TodayWeght := 0;
                    ItemDescription := '';
                    SalesPersoncode := '';
                    SalesLineR.Reset;
                    UnitCost := 0;
                    Qty := 0;

                    sRnO += 1;
                    SalesHeder.Get("Document Type", "Document No.");
                    if SalesHeder."Currency Code" <> '' then
                        CURRENCYRATE1 := 1 / SalesHeder."Currency Factor"
                    else
                        CURRENCYRATE1 := 1;

                    TodayVal := "Line Amount" * CURRENCYRATE1;
                    TodayWeght := ("Net Weight" * "Sales Line".Quantity) / 1000;
                    JObNo := "Prod. Order No.";
                    ItemDescription := Description;
                    SalesPersoncode := "Salesperson Code";
                    UnitCost := "Unit Price";
                    Qty := Quantity;

                    CustName := SalesHeder."Bill-to Name";

                    Customer.Reset;
                    Customer.SetRange(Customer."No.", "Sell-to Customer No.");
                    if Customer.FindFirst then begin
                        CUST_SEGMENT := Customer."Customer Segment";
                    end else begin
                        CUST_SEGMENT := '';
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompInfo.Get;
                CompName := CompInfo.Name;
                StartDate := DMY2Date(1, Date2DMY(DateFilter1, 2), Date2DMY(DateFilter1, 3));




                //Previous Day Booking
                PreviousDayVal := 0;
                PreviousDayweight := 0;
                CURRENCYRATE2 := 1;
                SalesLineR.Reset;
                //SalesLineR.SETFILTER(SalesLineR."Document Type",'%1|%2',SalesLineR."Document Type"::Order,"Sales Line"."Document Type"::"Blanket Order");
                SalesLineR.SetRange(SalesLineR."Document Type", SalesLineR."Document Type"::Order);
                SalesLineR.SetRange(SalesLineR.Type, SalesLineR.Type::Item);
                SalesLineR.SetRange(SalesLineR."Order Date", StartDate, DateFilter1 - 1);
                SalesLineR.SetRange(SalesLineR."Salesperson Code", Code);
                if SalesLineR.FindFirst then begin
                    repeat
                        SalesHeder.Get(SalesLineR."Document Type", SalesLineR."Document No.");
                        if SalesHeder."Currency Code" <> '' then begin
                            CURRENCYFACTOR2 := SalesHeder."Currency Factor";
                            CURRENCYRATE2 := 1 / CURRENCYFACTOR2;
                        end else
                            CURRENCYRATE2 := 1;

                        PreviousDayVal := PreviousDayVal + (SalesLineR."Line Amount" * CURRENCYRATE2);
                        PreviousDayweight := PreviousDayweight + (SalesLineR."Net Weight" * SalesLineR.Quantity) / 1000;
                    until SalesLineR.Next = 0;
                    EndTotalPreviousValue := EndTotalPreviousValue + PreviousDayVal;
                    EndTotalPreviousWeght := EndTotalPreviousWeght + PreviousDayweight;
                end;


                // Today sales Value
                CURRENCYRATE3 := 1;
                TodayInvValue := 0;
                TodaysInvWeight := 0;
                SalesInvLine.Reset;
                //SalesInvLine.SETRANGE(SalesInvLine.Type,SalesInvLine.Type::Item);
                SalesInvLine.SetRange(SalesInvLine."Salesperson Code", Code);
                SalesInvLine.SetRange(SalesInvLine."Posting Date", DateFilter1);
                if SalesInvLine.FindFirst then begin
                    repeat
                        SaleInvHeader.Get(SalesInvLine."Document No.");
                        CURRENCY_CODE3 := SaleInvHeader."Currency Code";
                        if SaleInvHeader."Currency Code" <> '' then
                            CURRENCYRATE3 := 1 / SaleInvHeader."Currency Factor"
                        else
                            CURRENCYRATE3 := 1;

                        TodayInvValue := TodayInvValue + (SalesInvLine."Line Amount" * CURRENCYRATE3);
                        TodaysInvWeight := TodaysInvWeight + SalesInvLine."Net Weight";
                    until SalesInvLine.Next = 0;
                    EndTotaltodayinvoice := EndTotaltodayinvoice + TodayInvValue;
                    EndTotalTodayinvWeight := EndTotalTodayinvWeight + TodaysInvWeight;
                end;

                CURRENCYRATE4 := 1;
                InvoiceTillDateVal := 0;
                InvoiceTillDateWeight := 0;
                SalesInvLine.Reset;
                SalesInvLine.SetRange(SalesInvLine."Salesperson Code", Code);
                SalesInvLine.SetRange(SalesInvLine."Posting Date", StartDate, DateFilter1);
                if SalesInvLine.FindFirst then begin
                    repeat

                        SaleInvHeader.Get(SalesInvLine."Document No.");
                        if SaleInvHeader."Currency Code" <> '' then
                            CURRENCYRATE4 := 1 / SaleInvHeader."Currency Factor"
                        else
                            CURRENCYRATE4 := 1;

                        InvoiceTillDateVal := InvoiceTillDateVal + (SalesInvLine."Line Amount" * CURRENCYRATE4);
                        InvoiceTillDateWeight := InvoiceTillDateWeight + SalesInvLine."Net Weight";
                    until SalesInvLine.Next = 0;
                    EndTotalTillInvoice := EndTotalTillInvoice + InvoiceTillDateVal;
                    EndTotalInvoiceWeght := EndTotalInvoiceWeght + InvoiceTillDateWeight;


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

    trigger OnPreReport()
    begin
        "Sales Line".CalcFields("Sales Line"."Order Date");
        DateFilter1 := "Sales Line".GetRangeMin("Order Date");
    end;

    var
        PreviousDayVal: Decimal;
        TodayVal: Decimal;
        EndDate: Date;
        StartDate: Date;
        SalesLineR: Record "Sales Line";
        SaleInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        InvoiceTillDateVal: Decimal;
        TodayInvValue: Decimal;
        SalesPersonPurch: Record "Salesperson/Purchaser";
        DateFilter1: Date;
        CustName: Text[60];
        SalesPersoncode: Code[30];
        JObNo: Code[30];
        Price: Decimal;
        SalesHeder: Record "Sales Header";
        CompInfo: Record "Company Information";
        CompName: Text[60];
        prePreviousDayVal: Decimal;
        ItemDescription: Text[250];
        SalesPersonName: Code[20];
        UnitCost: Decimal;
        Qty: Decimal;
        EndTotalPreviousValue: Decimal;
        EndTotaltodayinvoice: Decimal;
        EndTotalTillInvoice: Decimal;
        PreviousDayweight: Decimal;
        TodaysInvWeight: Decimal;
        InvoiceTillDateWeight: Decimal;
        EndTotalTodayinvWeight: Decimal;
        EndTotalInvoiceWeght: Decimal;
        TodayWeght: Decimal;
        EndTotalPreviousWeght: Decimal;
        Customer: Record Customer;
        CUST_SEGMENT: Code[30];
        CURRENCYFACTOR: Decimal;
        CURRENCYRATE1: Decimal;
        CURRENCY_CODE: Code[30];
        CURRENCYFACTOR2: Decimal;
        CURRENCYRATE2: Decimal;
        CURRENCY_CODE2: Code[30];
        CURRENCYFACTOR3: Decimal;
        CURRENCYRATE3: Decimal;
        CURRENCY_CODE3: Code[30];
        CURRENCYFACTOR4: Decimal;
        CURRENCYRATE4: Decimal;
        CURRENCY_CODE4: Code[30];
        CR: Decimal;
        sRnO: Integer;
}

