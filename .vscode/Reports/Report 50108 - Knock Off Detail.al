report 50108 "Knock Off Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Knock Off Detail.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date";
            column(SelltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
            {
            }
            column(PostingDate_SalesInvoiceHeader; Format("Sales Invoice Header"."Posting Date"))
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(CompInfo_Name; CompanyInformation.Name)
            {
            }
            column(CompInfo_Address; CompanyInformation.Address)
            {
            }
            column(CompInfo_Address2; CompanyInformation."Address 2")
            {
            }
            column(CompInfo_City; CompanyInformation.City)
            {
            }
            column(CompInfo_PostCode; CompanyInformation."Post Code")
            {
            }
            column(CurrencyCode_SalesInvoiceHeader; "Sales Invoice Header"."Currency Code")
            {
            }
            column(AppliedDocNo; AppliedDocNo)
            {
            }
            column(AppliedAmt; Abs(AppliedAmt))
            {
            }
            column(ChequeNo; ChequeNo)
            {
            }
            column(ChequeDate; Format(ChequeDate))
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(Desc; Desc)
            {
            }
            column(ExDocNo; ExDocNo)
            {
            }
            column(DocType; DocType)
            {
            }
            column(InvoiceAmt; InvoiceAmt)
            {
            }
            column(AppliedAmt1; Abs(AppliedAmt1))
            {
            }

            trigger OnAfterGetRecord()
            begin
                FilterString := "Sales Invoice Header".GetFilters;

                Clear(AppliedDocNo);
                Clear(AppliedAmt);
                Clear(ChequeNo);
                Clear(ChequeDate);
                CustLedgerEntry.Reset;
                CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", "Sales Invoice Header"."No.");
                if CustLedgerEntry.FindSet then begin
                    CustLedgerEntry.CalcFields(CustLedgerEntry.Amount);
                    CustLedgerEntry.CalcFields(CustLedgerEntry."Remaining Amount");
                    ExDocNo := CustLedgerEntry."External Document No.";
                    DocType := Format(CustLedgerEntry."Document Type");
                    Desc := CustLedgerEntry.Description;
                    InvoiceAmt := CustLedgerEntry.Amount;
                    //RemainingAmt := CustLedgerEntry."Remaining Amount";
                    DetailedCustLedgEntry.Reset;
                    DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                    DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Entry Type", DetailedCustLedgEntry."Entry Type"::Application);
                    DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry.Unapplied, false);
                    if DetailedCustLedgEntry.FindSet then begin
                        AppliedDocNo := DetailedCustLedgEntry."Document No.";
                        AppliedAmt1 := DetailedCustLedgEntry.Amount;
                        CustLedgerEntry.Reset;
                        CustLedgerEntry.SetRange(CustLedgerEntry."Document No.", AppliedDocNo);
                        if CustLedgerEntry.FindSet then begin
                            CustLedgerEntry.CalcFields(CustLedgerEntry.Amount);
                            AppliedAmt := CustLedgerEntry."Closed by Amount";
                            ChequeNo := CustLedgerEntry."Cheque No.";
                            ChequeDate := CustLedgerEntry."Cheque Date";
                        end;
                    end;
                end;
                //MESSAGE('%1',AppliedDocNo);
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
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
        FilterString: Text[200];
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ChequeNo: Code[30];
        ChequeDate: Date;
        AppliedDocNo: Code[30];
        AppliedAmt: Decimal;
        GLEntry: Record "G/L Entry";
        ExDocNo: Code[50];
        DocType: Text;
        Desc: Text[100];
        RemainingAmt: Decimal;
        InvoiceAmt: Decimal;
        AppliedAmt1: Decimal;
}

