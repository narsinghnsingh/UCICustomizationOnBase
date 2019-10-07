report 50062 "Cash Book"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Cash Book.rdl';
    Caption = 'Cash Book';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending) WHERE ("Account Type" = FILTER (Posting));
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyInfoName; CompInfo.Name)
            {
            }
            column(BookName; Name + '  ' + 'Book')
            {
            }
            column(GetFilters; GetFilters)
            {
            }
            column(LocationFilter; LocationFilter)
            {
            }
            column(OneEntryRecord; OneEntryRecord)
            {
            }
            column(FirstRecord; FirstRecord)
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(No_GLAccount; "G/L Account"."No.")
            {
            }
            column(OpeningBalanceFormatted; 'Opening Balance As On' + ' ' + Format(GetRangeMin("Date Filter")))
            {
            }
            column(OpeningDRBal; OpeningDRBal)
            {
            }
            column(OpeningCRBal; OpeningCRBal)
            {
            }
            column(OpeningDRCRBal; Abs(OpeningDRBal - OpeningCRBal))
            {
            }
            column(DrCrTextBalance; DrCrTextBalance)
            {
            }
            column(OpeningCRBalGLEntryCreditAmount; OpeningCRBal + "G/L Entry"."Credit Amount")
            {
            }
            column(OpeningDRBalGLEntryDebitAmount; OpeningDRBal + "G/L Entry"."Debit Amount")
            {
            }
            column(OpeningDRCRBalTransDebitsCredits; Abs(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
            {
            }
            column(DrCrTextBalance2; DrCrTextBalance2)
            {
            }
            column(DateFilter_GLAccount; "Date Filter")
            {
            }
            column(GlobalDimension1Filter_GLAccount; "Global Dimension 1 Filter")
            {
            }
            column(GlobalDimension2Filter_GLAccount; "Global Dimension 2 Filter")
            {
            }
            column(PageNoCaption; PageCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocumentNoCaptionLbl)
            {
            }
            column(DebitAmountCaption; DebitAmountCaptionLbl)
            {
            }
            column(CreditAmountCaption; CreditAmountCaptionLbl)
            {
            }
            column(AccountNameCaption; AccountNameCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(VoucherTypeCaption; VoucherTypeCaptionLbl)
            {
            }
            column(LocationCodeCaption; LocationCodeCaptionLbl)
            {
            }
            column(ClosingBalanceCaption; ClosingBalanceCaptionLbl)
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD ("No."), "Posting Date" = FIELD ("Date Filter"), "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter");
                DataItemTableView = SORTING ("G/L Account No.", "Posting Date") ORDER(Ascending);
                column(PostingDateFormatted_GLEntry; Format("Posting Date"))
                {
                }
                column(DocumentNo_GLEntry; "Document No.")
                {
                }
                column(AccountName; AccountName)
                {
                }
                column(DebitAmount_GLEntry; "Debit Amount")
                {
                }
                column(CreditAmount_GLEntry; "Credit Amount")
                {
                }
                column(OpeningDRCRBalTransDebitsCredits1; Abs(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
                {
                }
                column(SourceDesc; SourceDesc)
                {
                }
                column(DrCrTextBalance3; DrCrTextBalance)
                {
                }
                column(TotalCreditAmount; TotalCreditAmount)
                {
                }
                column(TotalDebitAmount; TotalDebitAmount)
                {
                }
                column(EntryNo_GLEntry; "Entry No.")
                {
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING (Number);
                    column(GLEntryPostingDateFormatted; Format(GLEntry."Posting Date"))
                    {
                    }
                    column(GLEntryDocumentNo; GLEntry."Document No.")
                    {
                    }
                    column(GLAccountName; AccountName)
                    {
                    }
                    column(GLEntryDebitAmount; "G/L Entry"."Debit Amount")
                    {
                    }
                    column(GLEntryCreditAmount; "G/L Entry"."Credit Amount")
                    {
                    }
                    column(DetailAmt; Abs(DetailAmt))
                    {
                    }
                    column(OpeningDRCRBalTransDebitsCredits2; Abs(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
                    {
                    }
                    column(SourceDesc1; SourceDesc)
                    {
                    }
                    column(DrCrText; DrCrText)
                    {
                    }
                    column(DrCrTextBalance4; DrCrTextBalance)
                    {
                    }
                    column(IntegerNumber; Integer.Number)
                    {
                    }
                    column(GLEntryAmount; Abs(GLEntry.Amount))
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        DrCrText := '';
                        if Number > 1 then begin
                            FirstRecord := false;
                            GLEntry.Next;
                        end;

                        if FirstRecord then begin
                            DetailAmt := 0;
                            if PrintDetail then
                                DetailAmt := GLEntry.Amount;

                            if DetailAmt > 0 then
                                DrCrText := 'Dr';
                            if DetailAmt < 0 then
                                DrCrText := 'Cr';

                            if not PrintDetail then
                                AccountName := Text16500
                            else
                                AccountName := Daybook.FindGLAccName(GLEntry."Source Type", GLEntry."Entry No.", GLEntry."Source No.", GLEntry."G/L Account No.")
                            ;

                            DrCrTextBalance := '';
                            if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 then
                                DrCrTextBalance := 'Dr';
                            if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 then
                                DrCrTextBalance := 'Cr';
                        end;


                        if (PrintDetail and (not FirstRecord)) then begin
                            if GLEntry.Amount > 0 then
                                DrCrText := 'Dr';
                            if GLEntry.Amount < 0 then
                                DrCrText := 'Cr';
                            AccountName := Daybook.FindGLAccName(GLEntry."Source Type", GLEntry."Entry No.", GLEntry."Source No.", GLEntry."G/L Account No.");
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, GLEntry.Count);
                        FirstRecord := true;

                        if GLEntry.Count = 1 then
                            CurrReport.Break;
                    end;
                }
                dataitem("Posted Narration"; "Posted Narration")
                {
                    DataItemLink = "Entry No." = FIELD ("Entry No.");
                    DataItemTableView = SORTING ("Entry No.", "Transaction No.", "Line No.") ORDER(Ascending);
                    column(Narration_PostedNarration; Narration)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if not PrintLineNarration then
                            CurrReport.Break;
                    end;
                }
                dataitem(PostedNarration1; "Posted Narration")
                {
                    DataItemLink = "Transaction No." = FIELD ("Transaction No.");
                    DataItemTableView = SORTING ("Entry No.", "Transaction No.", "Line No.") WHERE ("Entry No." = FILTER (0));
                    column(Narration_PostedNarration1; Narration)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if not PrintVchNarration then
                            CurrReport.Break;

                        GLEntry2.Reset;
                        GLEntry2.SetCurrentKey("Posting Date", "Source Code", "Transaction No.");
                        GLEntry2.SetRange("Posting Date", "G/L Entry"."Posting Date");
                        GLEntry2.SetRange("Source Code", "G/L Entry"."Source Code");
                        GLEntry2.SetRange("Transaction No.", "G/L Entry"."Transaction No.");
                        GLEntry2.SetRange("G/L Account No.", "G/L Account"."No.");
                        GLEntry2.FindLast;
                        if not (GLEntry2."Entry No." = "G/L Entry"."Entry No.") then
                            CurrReport.Break;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    GLEntry.SetRange("Transaction No.", "Transaction No.");
                    GLEntry.SetFilter("Entry No.", '<>%1', "Entry No.");
                    if GLEntry.FindFirst then;

                    DrCrText := '';
                    OneEntryRecord := true;
                    if GLEntry.Count > 1 then
                        OneEntryRecord := false;

                    if Amount > 0 then
                        TransDebits := TransDebits + Amount;
                    if Amount < 0 then
                        TransCredits := TransCredits - Amount;

                    SourceDesc := '';
                    if "Source Code" <> '' then begin
                        SourceCode.Get("Source Code");
                        SourceDesc := SourceCode.Description;
                    end;

                    AccountName := '';
                    if OneEntryRecord then begin
                        AccountName := Daybook.FindGLAccName(GLEntry."Source Type", GLEntry."Entry No.", GLEntry."Source No.", GLEntry."G/L Account No.");

                        DrCrTextBalance := '';
                        if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 then
                            DrCrTextBalance := 'Dr';
                        if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 then
                            DrCrTextBalance := 'Cr';
                    end;


                    if GLAccNo <> "G/L Account"."No." then
                        GLAccNo := "G/L Account"."No.";

                    if GLAccNo = "G/L Account"."No." then begin
                        DrCrTextBalance2 := '';
                        if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 then
                            DrCrTextBalance2 := 'Dr';
                        if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 then
                            DrCrTextBalance2 := 'Cr';
                    end;

                    TotalDebitAmount += "Debit Amount";
                    TotalCreditAmount += "Credit Amount";
                end;

                trigger OnPostDataItem()
                begin
                    AccountChanged := true;
                end;

                trigger OnPreDataItem()
                begin
                    GLEntry.Reset;
                    GLEntry.SetCurrentKey("Transaction No.");

                    TotalDebitAmount := 0;
                    TotalCreditAmount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                VoucherAccount.SetRange(VoucherAccount."Account No.", "No.");
                if not VoucherAccount.FindFirst then
                    CurrReport.Skip;

                if AccountNo <> "No." then begin
                    AccountNo := "No.";

                    OpeningDRBal := 0;
                    OpeningCRBal := 0;
                    GLEntry2.Reset;
                    GLEntry2.SetCurrentKey("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code",
                    "Global Dimension 2 Code", "Close Income Statement Dim. ID", "Posting Date");
                    GLEntry2.SetRange("G/L Account No.", "No.");
                    GLEntry2.SetFilter("Posting Date", '%1..%2', 0D, NormalDate(GetRangeMin("Date Filter")) - 1);
                    if "Global Dimension 1 Filter" <> '' then
                        GLEntry2.SetFilter("Global Dimension 1 Code", "Global Dimension 1 Filter");
                    if "Global Dimension 2 Filter" <> '' then
                        GLEntry2.SetFilter("Global Dimension 2 Code", "Global Dimension 2 Filter");

                    GLEntry2.CalcSums(Amount);
                    if GLEntry2.Amount > 0 then
                        OpeningDRBal := GLEntry2.Amount;
                    if GLEntry2.Amount < 0 then
                        OpeningCRBal := -GLEntry2.Amount;

                    DrCrTextBalance := '';
                    if OpeningDRBal - OpeningCRBal > 0 then
                        DrCrTextBalance := 'Dr';
                    if OpeningDRBal - OpeningCRBal < 0 then
                        DrCrTextBalance := 'Cr';
                end;
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals(TransDebits, TransCredits, "G/L Entry"."Debit Amount", "G/L Entry"."Credit Amount");
                VoucherAccount.SetFilter("Sub Type", '%1|%2', VoucherAccount."Sub Type"::"Cash Payment Voucher",
                VoucherAccount."Sub Type"::"Cash Receipt Voucher");
                VoucherAccount.SetRange("Account Type", VoucherAccount."Account Type"::"G/L Account");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintDetail; PrintDetail)
                    {
                        Caption = 'Print Detail';
                    }
                    field(PrintLineNarration; PrintLineNarration)
                    {
                        Caption = 'Print Line Narration';
                    }
                    field(PrintVchNarration; PrintVchNarration)
                    {
                        Caption = 'Print Voucher Narration';
                    }
                    field(LocationCode; LocationCode)
                    {
                        Caption = 'Location Code';
                        TableRelation = Location;
                    }
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

    trigger OnPreReport()
    begin
        CompInfo.Get;
    end;

    var
        CompInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        SourceCode: Record "Source Code";
        VoucherAccount: Record "Voucher Account";
        Daybook: Report "Day Book";
        OpeningDRBal: Decimal;
        OpeningCRBal: Decimal;
        TransDebits: Decimal;
        TransCredits: Decimal;
        OneEntryRecord: Boolean;
        FirstRecord: Boolean;
        PrintDetail: Boolean;
        PrintLineNarration: Boolean;
        PrintVchNarration: Boolean;
        DetailAmt: Decimal;
        AccountName: Text[100];
        SourceDesc: Text[50];
        DrCrText: Text[2];
        DrCrTextBalance: Text[2];
        LocationCode: Code[10];
        LocationFilter: Text[100];
        Text16500: Label 'As per Details';
        AccountChanged: Boolean;
        AccountNo: Code[20];
        DrCrTextBalance2: Text[2];
        GLAccNo: Code[20];
        TotalDebitAmount: Decimal;
        TotalCreditAmount: Decimal;
        PageCaptionLbl: Label 'Page';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        DebitAmountCaptionLbl: Label 'Debit Amount';
        CreditAmountCaptionLbl: Label 'Credit Amount';
        AccountNameCaptionLbl: Label 'Account Name';
        BalanceCaptionLbl: Label 'Balance';
        VoucherTypeCaptionLbl: Label 'Voucher Type';
        LocationCodeCaptionLbl: Label 'Location Code';
        ClosingBalanceCaptionLbl: Label 'Closing Balance';
}

