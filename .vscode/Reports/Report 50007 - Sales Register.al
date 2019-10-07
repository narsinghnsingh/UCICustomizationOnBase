report 50007 "Sales Register"
{
    // version Sales/ Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Sales Register.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending);
            RequestFilterFields = "Posting Date", "Bill-to Customer No.";
            column(COMPNAME; COMPNAME)
            {
            }
            column(COMADD; COMADD + ',' + COMADD1)
            {
            }
            column(COMCITY; COMCITY + ' - ' + COMPCODE)
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
            {
            }
            column(SLNO; SLNO)
            {
            }
            column(VehicleName; "Sales Invoice Header"."Vehicle No.")
            {
            }
            column(DriverName; "Sales Invoice Header"."Driver Name")
            {
            }
            column(INVDATE; 'Date' + ' ' + INVDATE)
            {
            }
            column(CurrencyCode; "Sales Invoice Header"."Currency Code")
            {
            }
            column(ExternalDocumentNo_SalesInvoiceHeader; "Sales Invoice Header"."External Document No.")
            {
            }
            column(SEGMNET; SEGMNET)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE (Type = FILTER (Item), Quantity = FILTER (<> 0));
                column(PostingDate_SalesInvoiceLine; "Sales Invoice Line"."Posting Date")
                {
                }
                column(DocumentNo_SalesInvoiceLine; "Sales Invoice Line"."Document No.")
                {
                }
                column(ExternalDocNo_SalesInvoiceLine; "Sales Invoice Line"."External Doc. No.")
                {
                }
                column(ProdOrderNo_SalesInvoiceLine; "Sales Invoice Line"."Prod. Order No.")
                {
                }
                column(No_SalesInvoiceLine; "Sales Invoice Line"."No.")
                {
                }
                column(Description_SalesInvoiceLine; "Sales Invoice Line".Description)
                {
                }
                column(UnitofMeasureCode_SalesInvoiceLine; "Sales Invoice Line"."Unit of Measure Code")
                {
                }
                column(Quantity_SalesInvoiceLine; "Sales Invoice Line".Quantity)
                {
                }
                column(UnitPrice_SalesInvoiceLine; "Sales Invoice Line"."Unit Price")
                {
                }
                column(NetWeight; Round("Sales Invoice Line"."Net Weight", 0.01))
                {
                }
                column(CurrencyFactor; "Sales Invoice Header"."Currency Factor")
                {
                }
                column(LineAmount_SalesInvoiceLine; "Sales Invoice Line"."Line Amount" * CurrencyInAED)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //IF ItemNo <> '' THEN
                    //SETRANGE("No.",ItemNo);
                    CurrencyInAED := 1;
                    SalesInvoiceHeader.Reset;
                    SalesInvoiceHeader.SetRange(SalesInvoiceHeader."No.", "Document No.");
                    if SalesInvoiceHeader.FindFirst then begin
                        if SalesInvoiceHeader."Currency Code" <> '' then
                            CurrencyInAED := 1 / SalesInvoiceHeader."Currency Factor";
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if ItemNo <> '' then
                        SetRange("No.", ItemNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.Get;
                COMPNAME := COMINFO.Name;
                COMADD := COMINFO.Address;
                COMADD1 := COMINFO."Address 2";
                COMCITY := COMINFO.City;
                COMPCODE := COMINFO."Post Code";


                SLNO := SLNO + 1;

                CUST.Reset;
                CUST.SetRange(CUST."No.", "Sales Invoice Header"."Sell-to Customer No.");
                if CUST.FindFirst then begin
                    SEGMNET := CUST."Customer Segment";
                end else begin
                    SEGMNET := '';
                end;
            end;

            trigger OnPreDataItem()
            begin
                INVDATE := "Sales Invoice Header".GetFilter("Sales Invoice Header"."Posting Date");
            end;
        }
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending);
            RequestFilterFields = "Bill-to Customer No.", "Posting Date";
            column(PostingDate_SalesCrMemoHeader; "Sales Cr.Memo Header"."Posting Date")
            {
            }
            column(ExternalDocumentNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."External Document No.")
            {
            }
            column(SelltoCustomerName_SalesCrMemoHeader; "Sales Cr.Memo Header"."Sell-to Customer Name")
            {
            }
            column(CurrencyCode_SalesCreditMemo; "Sales Cr.Memo Header"."Currency Code")
            {
            }
            column(CurrencyFactor_SalesCreditMemo; "Sales Cr.Memo Header"."Currency Factor")
            {
            }
            column(SLNO1; SLNO1)
            {
            }
            column(AppliestoDocNo_SalesCrMemoHeader; "Sales Cr.Memo Header"."Applies-to Doc. No.")
            {
            }
            column(CRSEGMNET; "CR.SEGMENT")
            {
            }
            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE (Quantity = FILTER (<> 0));
                column(PostingDate_SalesCrMemoLine; "Sales Cr.Memo Line"."Posting Date")
                {
                }
                column(DocumentNo_SalesCrMemoLine; "Sales Cr.Memo Line"."Document No.")
                {
                }
                column(No_SalesCrMemoLine; "Sales Cr.Memo Line"."No.")
                {
                }
                column(Description_SalesCrMemoLine; "Sales Cr.Memo Line".Description)
                {
                }
                column(UnitofMeasureCode_SalesCrMemoLine; "Sales Cr.Memo Line"."Unit of Measure Code")
                {
                }
                column(Quantity_SalesCrMemoLine; "Sales Cr.Memo Line".Quantity)
                {
                }
                column(UnitPrice_SalesCrMemoLine; "Sales Cr.Memo Line"."Unit Price")
                {
                }
                column(LineAmount_SalesCrMemoLine; "Sales Cr.Memo Line"."Line Amount" * CurrencyInAED1)
                {
                }
                column(NetWeight_SalesCrMemoLine; "Sales Cr.Memo Line"."Net Weight")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    CurrencyInAED1 := 1;
                    SalesCrMemoHeader.Reset;
                    SalesCrMemoHeader.SetRange(SalesCrMemoHeader."No.", "Document No.");
                    if SalesCrMemoHeader.FindFirst then begin
                        if SalesCrMemoHeader."Currency Code" <> '' then
                            CurrencyInAED1 := 1 / SalesCrMemoHeader."Currency Factor";
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Sales Cr.Memo Line".SetFilter("Sales Cr.Memo Line"."Posting Date", INVDATE);
                    if ItemNo <> '' then
                        SetRange("No.", ItemNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SLNO1 := SLNO1 + 1;

                CUST.Reset;
                CUST.SetRange(CUST."No.", "Sell-to Customer No.");
                if CUST.FindFirst then begin
                    "CR.SEGMENT" := CUST."Customer Segment";
                end else begin
                    "CR.SEGMENT" := '';
                end;
            end;

            trigger OnPostDataItem()
            begin
                "Sales Cr.Memo Header".SetFilter("Sales Cr.Memo Header"."Posting Date", INVDATE);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Item No."; ItemNo)
                {
                    TableRelation = Item;
                }
            }
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
        COMPNAME: Text[100];
        COMADD: Text[100];
        COMADD1: Text[100];
        COMCITY: Text[100];
        COMPCODE: Text[50];
        SLNO: Decimal;
        SLNO1: Decimal;
        INVDATE: Text[100];
        CUST: Record Customer;
        SEGMNET: Code[20];
        "CR.SEGMENT": Code[20];
        SalesInvoiceHeader: Record "Sales Invoice Header";
        CurrencyInAED: Decimal;
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        CurrencyInAED1: Decimal;
        ItemNo: Code[20];
}

