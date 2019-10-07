report 50132 BPostion
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/BPostion.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            RequestFilterFields = "Bank Account No.", "Posting Date";
            column(CominfoName; CompanyInformation.Name)
            {
            }
            column(RUNDATE; WorkDate)
            {
            }
            column(Bankfilter; Bankfilter)
            {
            }
            column(MINDATE; MINDATE)
            {
            }
            column(OPENINGBALANCE; OPENINGBALANCE)
            {
            }
            column(RunningBalance; RunningBalance)
            {
            }
            column(ClosingBalance; ClosingBalance)
            {
            }
            column(PostingDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Posting Date")
            {
            }
            column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document No.")
            {
            }
            column(BalAccountType_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Bal. Account Type")
            {
            }
            column(BankAccountNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Bank Account No.")
            {
            }
            column(Description_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column(DebitAmount_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Debit Amount")
            {
            }
            column(CreditAmount_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Credit Amount")
            {
            }
            column(ChequeNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Cheque No.")
            {
            }
            column(ChequeDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Cheque Date")
            {
            }
            column(Amount_BankAccountLedgerEntry; "Bank Account Ledger Entry".Amount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RunningBalance += "Bank Account Ledger Entry".Amount;
            end;

            trigger OnPreDataItem()
            begin
                MINDATE := "Bank Account Ledger Entry".GetRangeMin("Bank Account Ledger Entry"."Posting Date");
                MaxDate := "Bank Account Ledger Entry".GetRangeMax("Bank Account Ledger Entry"."Posting Date");
                Bankfilter := "Bank Account Ledger Entry".GetFilters;

                BankAccount.Reset;
                BankAccount.SetRange(BankAccount."No.", "Bank Account Ledger Entry".GetFilter("Bank Account Ledger Entry"."Bank Account No."));
                BankAccount.SetRange(BankAccount."Date Filter", 0D, MINDATE - 1);
                if BankAccount.FindFirst then begin
                    BankAccount.CalcFields(BankAccount."Net Change");
                    OPENINGBALANCE := BankAccount."Net Change";
                end;

                BankAccount.Reset;
                BankAccount.SetRange(BankAccount."No.", "Bank Account Ledger Entry".GetFilter("Bank Account Ledger Entry"."Bank Account No."));
                BankAccount.SetRange(BankAccount."Date Filter", 0D, MaxDate);
                if BankAccount.FindFirst then begin
                    BankAccount.CalcFields(BankAccount."Net Change");
                    ClosingBalance := BankAccount."Net Change";
                    PDCRunningBalance := BankAccount."Net Change";
                end;

                Message(Format(OPENINGBALANCE));
                RunningBalance := OPENINGBALANCE;
            end;
        }
        dataitem("Post Dated Cheque PDC"; "Post Dated Cheque PDC")
        {
            DataItemTableView = SORTING ("Cheque Date") ORDER(Ascending) WHERE (Presented = CONST (false));
            RequestFilterFields = "Presented Bank", "Cheque Date";
            column(PDCFILTER; PDCFILTER)
            {
            }
            column(PDCRunningBalance; PDCRunningBalance)
            {
            }
            column(PDCNumber_PostDatedChequePDC; "Post Dated Cheque PDC"."PDC Number")
            {
            }
            column(ChequeNo_PostDatedChequePDC; "Post Dated Cheque PDC"."Cheque No")
            {
            }
            column(AccountType_PostDatedChequePDC; "Post Dated Cheque PDC"."Account Type")
            {
            }
            column(AccountNo_PostDatedChequePDC; "Post Dated Cheque PDC"."Account No")
            {
            }
            column(Description_PostDatedChequePDC; "Post Dated Cheque PDC".Description)
            {
            }
            column(ChequeDate_PostDatedChequePDC; "Post Dated Cheque PDC"."Cheque Date")
            {
            }
            column(PresentedBank_PostDatedChequePDC; "Post Dated Cheque PDC"."Presented Bank")
            {
            }
            column(DebitAmount_PostDatedChequePDC; "Post Dated Cheque PDC"."Debit Amount")
            {
            }
            column(CreditAmount_PostDatedChequePDC; "Post Dated Cheque PDC"."Credit Amount")
            {
            }
            column(Presented_PostDatedChequePDC; "Post Dated Cheque PDC".Presented)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PDCRunningBalance += -("Post Dated Cheque PDC".Amount);
            end;

            trigger OnPreDataItem()
            begin
                PDCFILTER := "Post Dated Cheque PDC".GetFilters;
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
        Bankfilter: Text;
        PDCFILTER: Text;
        BankAccount: Record "Bank Account";
        OPENINGBALANCE: Decimal;
        RunningBalance: Decimal;
        ClosingBalance: Decimal;
        MINDATE: Date;
        MaxDate: Date;
        PDCRunningBalance: Decimal;
}

