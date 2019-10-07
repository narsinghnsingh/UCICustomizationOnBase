page 50040 "Bank Payment Voucher"
{
    // version NAVIN7.10| Deepak

    AutoSplitKey = true;
    Caption = 'Bank Payment Voucher';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SaveValues = true;
    SourceTable = "Gen. Journal Line";
    SourceTableView = WHERE ("Approval Due" = FILTER (= false));

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Account Type"; "Account Type")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Account No."; "Account No.")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; Description)
                {
                }
                field("Debit Amount"; "Debit Amount")
                {
                }
                field("Credit Amount"; "Credit Amount")
                {
                }
                field(Amount; Amount)
                {
                    Visible = false;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                }
                field("Bal. Account No."; "Bal. Account No.")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Cheque No."; "Cheque No.")
                {
                    Visible = true;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Visible = false;
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Currency Factor"; "Currency Factor")
                {
                }
                field(PAY; PAY)
                {
                }
                field("Created By"; "Created By")
                {
                }
                field("Select for Approval"; "Select for Approval")
                {
                }
                field(Approved; Approved)
                {
                }
                field("LC No."; "LC No.")
                {
                }
                field("Approver ID"; "Approver ID")
                {
                }
                field("Approval Due"; "Approval Due")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = true;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = true;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
            group(Control1500025)
            {
                ShowCaption = false;
                fixed(Control1900261201)
                {
                    ShowCaption = false;
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName; AccName)
                        {
                            Caption = 'Account Name';
                            Editable = false;
                        }
                    }
                    group("Bank Charge Amount")
                    {
                        Caption = 'Bank Charge Amount';
                        field(BankChrgAmt; BankChrgAmt)
                        {
                            Caption = 'Bank Charge Amount';
                            Editable = false;
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        field(BalAccName; BalAccName)
                        {
                            Caption = 'Bal. Account Name';
                            Editable = false;
                        }
                    }
                    group(Control1902835001)
                    {
                        Caption = 'Cheque No.';
                        field("Cheque No.2"; "Cheque No.")
                        {
                            Caption = 'Cheque No.';
                            Editable = false;
                        }
                    }
                    group(Control1906659201)
                    {
                        Caption = 'Debit Amount';
                        field("Debit Amount2"; "Debit Amount")
                        {
                            Editable = false;
                        }
                    }
                    group("Total Debit Amount")
                    {
                        Caption = 'Total Debit Amount';
                        field(TotalDebitAmount; TotalDebitAmount)
                        {
                            Editable = false;
                        }
                    }
                    group(Control1905128201)
                    {
                        Caption = 'Credit Amount';
                        field("Credit Amount2"; "Credit Amount")
                        {
                            Editable = false;
                        }
                    }
                    group(Control1903770101)
                    {
                        Caption = 'Balance';
                        field(Balance; Balance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            Visible = BalanceVisible;
                        }
                        field(TotalCreditAmount; TotalCreditAmount)
                        {
                            Editable = false;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field(TotalBalance; TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
            part(Control24; "Voucher Narration New")
            {
                ShowFilter = false;
                SubPageLink = "Journal Template Name" = FIELD ("Journal Template Name"),
                              "Journal Batch Name" = FIELD ("Journal Batch Name"),
                              "Document No." = FIELD ("Document No.");
                SubPageView = SORTING ("Journal Template Name", "Journal Batch Name", "Document No.", "Gen. Journal Line No.", "Line No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Narration")
            {
                Caption = '&Narration';
                Image = Description;
                action("Line Narration")
                {
                    Caption = 'Line Narration';
                    Image = LineDescription;
                    RunObject = Page "Gen. Journal Voucher Narration";
                    RunPageLink = "Journal Template Name" = FIELD ("Journal Template Name"),
                                  "Journal Batch Name" = FIELD ("Journal Batch Name"),
                                  "Gen. Journal Line No." = FIELD ("Line No."),
                                  "Document No." = FIELD ("Document No.");
                    ShortCutKey = 'Shift+Ctrl+N';
                }
                action("Voucher Narration")
                {
                    Caption = 'Voucher Narration';
                    Image = VoucherDescription;
                    RunObject = Page "Gen. Journal Voucher Narration";
                    RunPageLink = "Journal Template Name" = FIELD ("Journal Template Name"),
                                  "Journal Batch Name" = FIELD ("Journal Batch Name"),
                                  "Document No." = FIELD ("Document No."),
                                  "Gen. Journal Line No." = CONST (0);
                    ShortCutKey = 'Shift+Ctrl+V';
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group("&Payments")
            {
                Caption = '&Payments';
                Image = Payment;
                action("Suggest Vendor Payments")
                {
                    Caption = 'Suggest Vendor Payments';
                    Ellipsis = true;
                    Image = SuggestVendorPayments;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CreateVendorPmtSuggestion.SetGenJnlLine(Rec);
                        CreateVendorPmtSuggestion.RunModal;
                        Clear(CreateVendorPmtSuggestion);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Send for Approval")
                {
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        GenJnlBatch: Record "Gen. Journal Batch";
                    begin
                        GenJnlBatch.Get("Journal Template Name", "Journal Batch Name");
                        GenJnlBatch.TestField(GenJnlBatch."Approver User Id");
                        ModifyAll("Approver ID", GenJnlBatch."Approver User Id");
                        ModifyAll("Approval Due", true);
                    end;
                }
                action("Apply Entries")
                {
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.Run;
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        TempDocNo := "Document No.";
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);

                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."Document No.", TempDocNo);
                        REPORT.RunModal(REPORT::"Posted Voucher", true, true, GLEntry);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        OnAfterGetCurrRecords;
    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance;
        UpdateDebitCreditAmount;
        SetUpNewLine(xRec, Balance, BelowxRec);
        Clear(ShortcutDimCode);
        OnAfterGetCurrRecords;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        BalAccName := '';
        OpenedFromBatch := ("Journal Batch Name" <> '') and ("Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := "Journal Batch Name";
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        SubsCribs.TemplateSelectionForVouchers(PAGE::"Bank Payment Voucher", false, 4, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        GLSetup.Get;
    end;

    var
        Text000: Label 'Void Check %1?';
        Text001: Label 'Void all printed checks?';
        ChangeExchangeRate: Page "Change Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GLReconcile: Page Reconciliation;
        CreateVendorPmtSuggestion: Report "Suggest Vendor Payments";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        CheckManagement: Codeunit CheckManagement;
        GLSetup: Record "General Ledger Setup";
        CurrentJnlBatchName: Code[10];
        AccName: Text[150];
        BalAccName: Text[150];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        TotalCreditAmount: Decimal;
        TotalDebitAmount: Decimal;
        OpenedFromBatch: Boolean;
        BankChrgAmt: Decimal;
        [InDataSet]
        BalanceVisible: Boolean;
        [InDataSet]
        TotalBalanceVisible: Boolean;
        GLEntry: Record "G/L Entry";
        TempDocNo: Code[50];
        SubsCribs: Codeunit CodeunitSubscriber;

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(
          Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure UpdateDebitCreditAmount()
    begin
        SubsCribs.CalcTotDebitTotCreditAmount(Rec, TotalDebitAmount, TotalCreditAmount, false);
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecords()
    begin
        xRec := Rec;
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        UpdateBalance;
        UpdateDebitCreditAmount;
    end;
}

