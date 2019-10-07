report 50109 "Knock Off Summary Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Knock Off Summary Detail.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Document No.") WHERE ("Document Type" = FILTER (Payment));
            RequestFilterFields = "Customer No.", "Posting Date";
            column(CustomerNo_CustLedgerEntry; "Cust. Ledger Entry"."Customer No.")
            {
            }
            column(PostingDate_CustLedgerEntry; Format("Cust. Ledger Entry"."Posting Date"))
            {
            }
            column(DocumentType_CustLedgerEntry; "Cust. Ledger Entry"."Document Type")
            {
            }
            column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
            {
            }
            column(Amount_CustLedgerEntry; "Cust. Ledger Entry".Amount)
            {
            }
            column(EntryNo_CustLedgerEntry; "Cust. Ledger Entry"."Entry No.")
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
            column(ChequeNo_CustLedgerEntry; "Cust. Ledger Entry"."Cheque No.")
            {
            }
            column(ChequeDate_CustLedgerEntry; Format("Cust. Ledger Entry"."Cheque Date"))
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(CustName; CustName)
            {
            }
            column(DocType; DocType)
            {
            }
            column(PostingDate; Format(PostingDate))
            {
            }
            column(InvNo; InvNo)
            {
            }
            column(CurrencyCode_CustLedgerEntry; "Cust. Ledger Entry"."Currency Code")
            {
            }
            column(ExternalDocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."External Document No.")
            {
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Document No." = FIELD ("Document No.");
                DataItemTableView = SORTING ("Cust. Ledger Entry No.", "Entry Type", "Posting Date") WHERE ("Initial Document Type" = CONST (Invoice), "Entry Type" = CONST (Application));
                column(CustLedgerEntryNo_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.")
                {
                }
                column(EntryNo_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Entry No.")
                {
                }
                column(Amount_DetailedCustLedgEntry; Abs("Detailed Cust. Ledg. Entry".Amount))
                {
                }
                column(DocumentType_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Document Type")
                {
                }
                column(DocumentNo_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Document No.")
                {
                }
                column(PostingDate_DetailedCustLedgEntry; Format("Detailed Cust. Ledg. Entry"."Posting Date"))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                FilterString := "Cust. Ledger Entry".GetFilters;

                Customer.Reset;
                Customer.SetRange(Customer."No.", "Cust. Ledger Entry"."Customer No.");
                if Customer.FindSet then begin
                    CustName := Customer.Name;
                end;

                DetailedCustLedgEntry.Reset;
                DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document No.", "Cust. Ledger Entry"."Document No.");
                DetailedCustLedgEntry.SetRange("Entry Type", DetailedCustLedgEntry."Entry Type"::Application);
                DetailedCustLedgEntry.SetRange("Initial Document Type", DetailedCustLedgEntry."Initial Document Type"::Invoice);
                if DetailedCustLedgEntry.FindSet then begin
                    repeat
                        EntryNo := DetailedCustLedgEntry."Cust. Ledger Entry No.";
                        CustLedgerEntry.Reset;
                        CustLedgerEntry.SetRange(CustLedgerEntry."Entry No.", EntryNo);
                        if CustLedgerEntry.FindSet then begin
                            repeat
                                DocType := Format(CustLedgerEntry."Document Type");
                                PostingDate := CustLedgerEntry."Posting Date";
                                InvNo := CustLedgerEntry."Document No.";
                                //Desc := CustLedgerEntry.Description;
                            until CustLedgerEntry.Next = 0;
                        end;
                    until DetailedCustLedgEntry.Next = 0;
                end;
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
        CustName: Text;
        Customer: Record Customer;
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        EntryNo: Integer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DocType: Text;
        PostingDate: Date;
        InvNo: Code[50];
        Desc: Text;
        SalesInvoiceHeader: Record "Sales Invoice Header";
}

