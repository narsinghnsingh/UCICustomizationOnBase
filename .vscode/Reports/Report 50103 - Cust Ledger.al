report 50103 "Cust Ledger"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {
            DataItemTableView = WHERE ("Document Type" = FILTER (Invoice));
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                Clear(Customer);
                Customer.Reset;
                Customer.SetRange("No.", "Detailed Cust. Ledg. Entry"."Customer No.");
                if Customer.FindFirst then
                    CustName := Customer.Name;
                Clear(SOno);
                SalesInvoiceHeader.Reset;
                SalesInvoiceHeader.SetRange("No.", "Detailed Cust. Ledg. Entry"."Document No.");
                if SalesInvoiceHeader.FindFirst then
                    SOno := SalesInvoiceHeader."Order No.";

                Clear(ExDoc);
                CustLedgerEntry.Reset;
                CustLedgerEntry.SetRange("Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                CustLedgerEntry.SetRange("Customer No.", "Detailed Cust. Ledg. Entry"."Customer No.");
                if CustLedgerEntry.FindFirst then
                    ExDoc := CustLedgerEntry."External Document No.";

                Clear(CustEntryNo);
                DetailedCustLedgEntry.Reset;
                DetailedCustLedgEntry.SetRange("Document No.", "Document No.");
                DetailedCustLedgEntry.SetRange("Document Type", "Document Type"::Invoice);
                if DetailedCustLedgEntry.FindFirst then
                    CustEntryNo := DetailedCustLedgEntry."Cust. Ledger Entry No.";




                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn("Detailed Cust. Ledg. Entry"."Posting Date", false, '', false, false, true, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn("Detailed Cust. Ledg. Entry"."Document Type", false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Detailed Cust. Ledg. Entry"."Document No.", false, '', false, false, true, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Detailed Cust. Ledg. Entry"."Posting Date", false, '', false, false, true, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn("Detailed Cust. Ledg. Entry"."Customer No.", false, '', false, false, true, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CustName, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(ExDoc, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(SOno, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn("Detailed Cust. Ledg. Entry".Amount, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);

                Clear(AppAmt);
                Clear(AppDoc);
                DetailedCustLedgEntry.Reset;
                DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustEntryNo);
                DetailedCustLedgEntry.SetRange("Entry Type", "Detailed Cust. Ledg. Entry"."Entry Type"::Application);
                DetailedCustLedgEntry.SetRange(DetailedCustLedgEntry."Document Type", DetailedCustLedgEntry."Document Type"::Payment);
                if DetailedCustLedgEntry.FindSet then begin
                    repeat
                        AppAmt := Abs(DetailedCustLedgEntry.Amount);
                        AppDoc := DetailedCustLedgEntry."Document No.";
                        BankAccountLedgerEntry.Reset;
                        BankAccountLedgerEntry.SetRange("Document No.", AppDoc);
                        if BankAccountLedgerEntry.FindFirst then begin
                            CheqNo := BankAccountLedgerEntry."Cheque No.";
                            CheqDate := BankAccountLedgerEntry."Cheque Date";
                            CurrCode := BankAccountLedgerEntry."Currency Code";
                        end;
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Date);
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Date);
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(AppDoc, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(AppAmt, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(CheqNo, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(CheqDate, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Date);
                        ExcelBuffer.AddColumn(CurrCode, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Number);
                    until DetailedCustLedgEntry.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin


                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('Knockoff Details', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(CompanyInformation.Name, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(CompanyInformation.Address, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(CompanyInformation."Address 2", false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(CompanyInformation."Post Code" + '  ' + CompanyInformation.City, false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);

                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('Report Period' + '' + DelStr(PosFilter, 1, 12), false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('Posting Date', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Document Type', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice No.', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Invoice Date', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Code', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Customer Name', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('LPO NO.', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Description', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Amount', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Applied Document', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Applied Amount', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Cheque No.', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Cheque Date', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Currency Code', false, '', false, false, true, '', ExcelBuffer."Cell Type"::Text);
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

    trigger OnPostReport()
    begin
        ExcelBuffer.CreateBookAndOpenExcel('CustLedger', '', '', CompanyName, UserId);
    end;

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        ExcelBuffer.DeleteAll;
        PosFilter := "Detailed Cust. Ledg. Entry".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        ExcelBuffer: Record "Excel Buffer";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ExDoc: Code[20];
        Customer: Record Customer;
        CustName: Text;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SOno: Code[20];
        CustEntryNo: Integer;
        AppAmt: Decimal;
        AppDoc: Code[20];
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PosFilter: Text;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CheqNo: Code[20];
        CheqDate: Date;
        CurrCode: Code[10];
}

