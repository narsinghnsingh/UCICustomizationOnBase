report 50063 "Bank Book"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Bank Book.rdl';
    Caption = 'Bank Book';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(CompInfo_Name; CompInfo.Name)
            {
            }
            column(CurrReport_PAGENO; 0)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Bank_Account_Name; Name)
            {
            }
            column(GETFILTERS; GetFilters)
            {
            }
            column(LocationFilter; LocationFilter)
            {
            }
            column(Bank_Book_; 'Bank Book')
            {
            }
            column(Opening_Balance_As_On_______FORMAT_GETRANGEMIN__Date_Filter___; 'Opening Balance As On' + ' ' + Format(GetRangeMin("Date Filter")))
            {
            }
            column(OpeningDRBal; OpeningDRBal)
            {
            }
            column(OpeningCRBal; OpeningCRBal)
            {
            }
            column(ABS_OpeningDRBal_OpeningCRBal_; Abs(OpeningDRBal - OpeningCRBal))
            {
            }
            column(DrCrTextBalance; DrCrTextBalance)
            {
            }
            column(OpeningCRBal_TransCredits; OpeningCRBal + TransCredits)
            {
            }
            column(OpeningDRBal_TransDebits; OpeningDRBal + TransDebits)
            {
            }
            column(ABS_OpeningDRBal_OpeningCRBal_TransDebits_TransCredits_; Abs(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
            {
            }
            column(DrCrTextBalance_Control1500007; DrCrTextBalance)
            {
            }
            column(TransDebits; TransDebits)
            {
            }
            column(TransCredits; TransCredits)
            {
            }
            column(Bank_Account_No_; "No.")
            {
            }
            column(Bank_Account_Date_Filter; "Date Filter")
            {
            }
            column(Bank_Account_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Bank_Account_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Debit_AmountCaption; Debit_AmountCaptionLbl)
            {
            }
            column(Credit_AmountCaption; Credit_AmountCaptionLbl)
            {
            }
            column(Account_NameCaption; Account_NameCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Voucher_TypeCaption; Voucher_TypeCaptionLbl)
            {
            }
            column(Location_CodeCaption; Location_CodeCaptionLbl)
            {
            }
            column(Cheque_NoCaption; Cheque_NoCaptionLbl)
            {
            }
            column(Cheque_DateCaption; Cheque_DateCaptionLbl)
            {
            }
            column(Closing_BalanceCaption; Closing_BalanceCaptionLbl)
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD ("No."), "Posting Date" = FIELD ("Date Filter"), "Global Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD ("Global Dimension 2 Filter");
                DataItemTableView = SORTING ("Bank Account No.", "Posting Date") ORDER(Ascending);
                column(Bank_Account_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Bank_Account_No_; "Bank Account No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Posting_Date; "Posting Date")
                {
                }
                column(Bank_Account_Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Bank_Account_Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "Entry No." = FIELD ("Entry No.");
                    DataItemTableView = SORTING ("G/L Account No.", "Posting Date") ORDER(Ascending);
                    column(G_L_Entry__Posting_Date_; Format("Posting Date"))
                    {
                    }
                    column(G_L_Entry__Document_No__; "Document No.")
                    {
                    }
                    column(AccountName; AccountName)
                    {
                    }
                    column(G_L_Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(G_L_Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(ABS_OpeningDRBal_OpeningCRBal_TransDebits_TransCredits__Control1500026; Abs(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
                    {
                    }
                    column(SourceDesc; SourceDesc)
                    {
                    }
                    column(DrCrTextBalance_Control1500065; DrCrTextBalance)
                    {
                    }
                    column(Bank_Account_Ledger_Entry___Cheque_No__; "Bank Account Ledger Entry"."Cheque No.")
                    {
                    }
                    column(Bank_Account_Ledger_Entry___Cheque_Date_; Format("Bank Account Ledger Entry"."Cheque Date"))
                    {
                    }
                    column(OneEntryRecord; OneEntryRecord)
                    {
                    }
                    column(G_L_Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(G_L_Entry_Transaction_No_; "Transaction No.")
                    {
                    }
                    dataitem("Integer"; "Integer")
                    {
                        DataItemTableView = SORTING (Number);
                        column(GLEntry__Posting_Date_; Format(GLEntry."Posting Date"))
                        {
                        }
                        column(GLEntry__Document_No__; GLEntry."Document No.")
                        {
                        }
                        column(AccountName_Control1500018; AccountName)
                        {
                        }
                        column(G_L_Entry___Debit_Amount_; "G/L Entry"."Debit Amount")
                        {
                        }
                        column(G_L_Entry___Credit_Amount_; "G/L Entry"."Credit Amount")
                        {
                        }
                        column(ABS_DetailAmt_; Abs(DetailAmt))
                        {
                        }
                        column(ABS_OpeningDRBal_OpeningCRBal_TransDebits_TransCredits__Control1500049; Abs(OpeningDRBal - OpeningCRBal + TransDebits - TransCredits))
                        {
                        }
                        column(SourceDesc_Control1500036; SourceDesc)
                        {
                        }
                        column(DrCrText; DrCrText)
                        {
                        }
                        column(DrCrTextBalance_Control1500067; DrCrTextBalance)
                        {
                        }
                        column(Bank_Account_Ledger_Entry___Cheque_No___Control1500021; "Bank Account Ledger Entry"."Cheque No.")
                        {
                        }
                        column(Bank_Account_Ledger_Entry___Cheque_Date__Control1500023; Format("Bank Account Ledger Entry"."Cheque Date"))
                        {
                        }
                        column(AccountName_Control1500042; AccountName)
                        {
                        }
                        column(ABS_GLEntry_Amount_; Abs(GLEntry.Amount))
                        {
                        }
                        column(DrCrText_Control1500056; DrCrText)
                        {
                        }
                        column(FirstRecord; FirstRecord)
                        {
                        }
                        column(PrintDetail; PrintDetail)
                        {
                        }
                        column(Integer_Number; Number)
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
                                    DrCrText := Text16501;
                                if DetailAmt < 0 then
                                    DrCrText := Text16502;

                                if not PrintDetail then
                                    AccountName := Text16500
                                else
                                    AccountName := Daybook.FindGLAccName(GLEntry."Source Type", GLEntry."Entry No.", GLEntry."Source No.", GLEntry."G/L Account No.")
                                      ;

                                DrCrTextBalance := '';
                                if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 then
                                    DrCrTextBalance := Text16501;
                                if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 then
                                    DrCrTextBalance := Text16502;
                            end else
                                if PrintDetail and (not FirstRecord) then begin
                                    if GLEntry.Amount > 0 then
                                        DrCrText := Text16501;
                                    if GLEntry.Amount < 0 then
                                        DrCrText := Text16502;
                                    AccountName :=
                                      Daybook.FindGLAccName(GLEntry."Source Type", GLEntry."Entry No.", GLEntry."Source No.", GLEntry."G/L Account No.");
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
                        DataItemLinkReference = "G/L Entry";
                        DataItemTableView = SORTING ("Entry No.", "Transaction No.", "Line No.") ORDER(Ascending) WHERE ("Entry No." = FILTER (<> 0));
                        column(Posted_Narration_Narration; Narration)
                        {
                        }
                        column(Posted_Narration_Entry_No_; "Entry No.")
                        {
                        }
                        column(Posted_Narration_Transaction_No_; "Transaction No.")
                        {
                        }
                        column(Posted_Narration_Line_No_; "Line No.")
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
                        column(PostedNarration1_Narration; Narration)
                        {
                        }
                        column(PostedNarration1_Entry_No_; "Entry No.")
                        {
                        }
                        column(PostedNarration1_Transaction_No_; "Transaction No.")
                        {
                        }
                        column(PostedNarration1_Line_No_; "Line No.")
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
                            GLEntry2.SetRange("G/L Account No.", "G/L Entry"."G/L Account No.");
                            GLEntry2.FindLast;
                            if not (GLEntry2."Entry No." = "G/L Entry"."Entry No.") then
                                CurrReport.Break;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GLEntry.SetRange("Transaction No.", "Transaction No.");
                        GLEntry.SetFilter("Entry No.", '<>%1', "Entry No.");
                        if GLEntry.Find('-') then;

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
                                DrCrTextBalance := Text16501;
                            if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 then
                                DrCrTextBalance := Text16502;
                        end;

                        if BankAccountNo = "Bank Account"."No." then begin
                            DrCrTextBalance := '';
                            if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits > 0 then
                                DrCrTextBalance := Text16501;
                            if OpeningDRBal - OpeningCRBal + TransDebits - TransCredits < 0 then
                                DrCrTextBalance := Text16502;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLEntry.Reset;
                        GLEntry.SetCurrentKey("Transaction No.");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                TransDebits := 0;
                TransCredits := 0;

                VoucherAccount.SetRange("Account No.", "No.");
                if not VoucherAccount.FindFirst then
                    CurrReport.Skip;

                if BankAccountNo <> "No." then begin
                    OpeningDRBal := 0;
                    OpeningCRBal := 0;

                    BankAccLedgEntry.Reset;
                    BankAccLedgEntry.SetCurrentKey("Bank Account No.", "Global Dimension 1 Code",
                      "Global Dimension 2 Code", "Posting Date");
                    BankAccLedgEntry.SetRange("Bank Account No.", "No.");
                    BankAccLedgEntry.SetFilter("Posting Date", '%1..%2', 0D, NormalDate(GetRangeMin("Date Filter")) - 1);
                    if "Global Dimension 1 Filter" <> '' then
                        BankAccLedgEntry.SetFilter("Global Dimension 1 Code", "Global Dimension 1 Filter");
                    if "Global Dimension 2 Filter" <> '' then
                        BankAccLedgEntry.SetFilter("Global Dimension 2 Code", "Global Dimension 2 Filter");

                    BankAccLedgEntry.CalcSums("Amount (LCY)");
                    if BankAccLedgEntry."Amount (LCY)" > 0 then
                        OpeningDRBal := BankAccLedgEntry."Amount (LCY)";
                    if BankAccLedgEntry."Amount (LCY)" < 0 then
                        OpeningCRBal := -BankAccLedgEntry."Amount (LCY)";

                    DrCrTextBalance := '';
                    if OpeningDRBal - OpeningCRBal > 0 then
                        DrCrTextBalance := Text16501;
                    if OpeningDRBal - OpeningCRBal < 0 then
                        DrCrTextBalance := Text16502;

                    BankAccountNo := "No.";
                end;
            end;

            trigger OnPreDataItem()
            begin
                VoucherAccount.SetFilter("Sub Type", '%1|%2',
                  VoucherAccount."Sub Type"::"Bank Payment Voucher",
                  VoucherAccount."Sub Type"::"Bank Receipt Voucher");
                VoucherAccount.SetRange("Account Type", VoucherAccount."Account Type"::"Bank Account");
            end;
        }
    }

    requestpage
    {

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

    trigger OnInitReport()
    begin
        BankAccountNo := '';
    end;

    trigger OnPreReport()
    begin
        CompInfo.Get;
    end;

    var
        CompInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        VoucherAccount: Record "Voucher Account";
        SourceCode: Record "Source Code";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
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
        SourceDesc: Text[100];
        DrCrText: Text[2];
        DrCrTextBalance: Text[2];
        LocationCode: Code[10];
        LocationFilter: Text[100];
        Text16500: Label 'As per Details';
        BankAccountNo: Code[50];
        Text16501: Label 'Dr';
        Text16502: Label 'Cr';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Posting_DateCaptionLbl: Label 'Posting Date';
        Document_No_CaptionLbl: Label 'Document No.';
        Debit_AmountCaptionLbl: Label 'Debit Amount';
        Credit_AmountCaptionLbl: Label 'Credit Amount';
        Account_NameCaptionLbl: Label 'Account Name';
        BalanceCaptionLbl: Label 'Balance';
        Voucher_TypeCaptionLbl: Label 'Voucher Type';
        Location_CodeCaptionLbl: Label 'Location Code';
        Cheque_NoCaptionLbl: Label 'Cheque No';
        Cheque_DateCaptionLbl: Label 'Cheque Date';
        Closing_BalanceCaptionLbl: Label 'Closing Balance';
}

