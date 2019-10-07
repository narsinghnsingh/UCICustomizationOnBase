report 50008 "Bank unreconcile statement"
{
    // version Account/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Bank unreconcile statement.rdl';
    Caption = 'BANK UNRECONCILE STATEMENT';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = SORTING ("Bank Account No.", "Posting Date") ORDER(Ascending) WHERE ("Statement Status" = FILTER (Open));
            RequestFilterFields = "Bank Account No.", "Statement No.", "Posting Date";
            column(COMPNAME; COMPNAME)
            {
            }
            column(COMADD; COMADD + ',' + COMADD1)
            {
            }
            column(COMCITY; COMCITY + ' - ' + COMPCODE)
            {
            }
            column(PostingDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Posting Date")
            {
            }
            column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document No.")
            {
            }
            column(Description_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column(StatementNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Statement No.")
            {
            }
            column(CreditAmount_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Credit Amount")
            {
            }
            column(DebitAmount_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Debit Amount")
            {
            }
            column(KJTEXT; Format(Text))
            {
            }
            column(DAmt; DebitAmount)
            {
            }
            column(CAmt; CreditAmount)
            {
            }
            column(BRs_Month; BrsMonth)
            {
            }
            column(BRs_Year; BrsYear)
            {
            }
            column(Value_Date; BRSline."Value Date")
            {
            }
            column(Balance_Amount; Abs(BalanceAmount))
            {
            }
            column(Sign; Sign)
            {
            }
            column(Statement; "Bank Account Ledger Entry"."Statement Status")
            {
            }
            dataitem("Check Ledger Entry"; "Check Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD ("Bank Account No."), "Bank Account Ledger Entry No." = FIELD ("Entry No.");
                column(CheckDate_CheckLedgerEntry; "Check Ledger Entry"."Check Date")
                {
                }
                column(CheckNo_CheckLedgerEntry; "Check Ledger Entry"."Check No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                COMINFO.Get;
                COMPNAME := COMINFO.Name;
                COMADD := COMINFO.Address;
                COMADD1 := COMINFO."Address 2";
                COMCITY := COMINFO.City;
                COMPCODE := COMINFO."Post Code";
            end;

            trigger OnPreDataItem()
            begin
                Text := '';
                Text := "Bank Account Ledger Entry".GetFilter("Bank Account Ledger Entry"."Posting Date");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
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
        BRS: Record "Bank Acc. Reconciliation";
        BankBalance: Decimal;
        MBSBalance: Decimal;
        udr: Decimal;
        ucr: Decimal;
        BRSline: Record "Bank Account Statement Line";
        BrsMonth: Option January,February,March,April,May,June,July,August,September,October,November,December;
        BrsYear: Integer;
        Month: Integer;
        StartingDate: Date;
        EndingDate: Date;
        Date1: Date;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        DebitTotal: Decimal;
        CreditTotal: Decimal;
        BalanceAmount: Decimal;
        Sign: Text[30];
        str: Text[30];
        Text001: Label 'Please Insert the Year';
        Text: Text[40];
        COMINFO: Record "Company Information";
        COMPNAME: Text[100];
        COMADD: Text[100];
        COMADD1: Text[100];
        COMCITY: Text[100];
        COMPCODE: Text[50];
}

