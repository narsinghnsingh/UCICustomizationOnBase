report 50068 "Day Book"
{
    // version Sadaf

    // <changelog>
    //     <change releaseversion="IN6.00"/>
    //     <change id="IN0090" dev="AUGMENTUM" date="2008-05-07" area="Finance"
    //       baseversion="IN6.00" releaseversion="IN6.00" feature="NAVCORS20452">
    //       Report Transformation - local Report Layout
    //       Format all the dates to make NNC consistent with old client
    //     </change>
    //     <change id="PS42497" dev="suneethg" date="2009-10-07" area="Financial" releaseversion="IN7.00" feature="NAVCORS42497"
    //     >Incorrect Total amounts in RTC corrected.</change>
    // </changelog>
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Day Book.rdl';

    Caption = 'Day Book';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING ("Transaction No.");
            RequestFilterFields = "Posting Date", "Document No.", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(Time; Time)
            {
            }
            column(CompinfoName; Compinfo.Name)
            {
            }
            column(GetFilters; GetFilters)
            {
            }
            column(DebitAmount_GLEntry; "Debit Amount")
            {
            }
            column(CreditAmount_GLEntry; "Credit Amount")
            {
            }
            column(GLAccName; GLAccName)
            {
            }
            column(DocNo; DocNo)
            {
            }
            column(PostingDate_GLEntry; Format(PostingDate))
            {
            }
            column(SourceDesc; SourceDesc)
            {
            }
            column(EntryNo_GLEntry; "Entry No.")
            {
            }
            column(TransactionNo_GLEntry; "Transaction No.")
            {
            }
            column(DayBookCaption; DayBookCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocumentNoCaptionLbl)
            {
            }
            column(AccountNameCaption; AccountNameCaptionLbl)
            {
            }
            column(DebitAmountCaption; DebitAmountCaptionLbl)
            {
            }
            column(CreditAmountCaption; CreditAmountCaptionLbl)
            {
            }
            column(VoucherTypeCaption; VoucherTypeCaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
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
                    if not LineNarration then
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
                    if not VoucherNarration then
                        CurrReport.Break;

                    GLEntry.SetCurrentKey("Posting Date", "Source Code", "Transaction No.");
                    GLEntry.SetRange("Posting Date", "G/L Entry"."Posting Date");
                    GLEntry.SetRange("Source Code", "G/L Entry"."Source Code");
                    GLEntry.SetRange("Transaction No.", "G/L Entry"."Transaction No.");
                    GLEntry.FindLast;
                    if not (GLEntry."Entry No." = "G/L Entry"."Entry No.") then
                        CurrReport.Break;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                DocNo := '';
                PostingDate := 0D;
                SourceDesc := '';

                GLAccName := FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");

                // IN0090.begin
                if TransNo = 0 then begin
                    TransNo := "Transaction No.";
                    DocNo := "Document No.";
                    PostingDate := "Posting Date";
                    if "Source Code" <> '' then begin
                        SourceCode.Get("Source Code");
                        SourceDesc := SourceCode.Description;
                    end;
                end else
                    if TransNo <> "Transaction No." then begin
                        TransNo := "Transaction No.";
                        DocNo := "Document No.";
                        PostingDate := "Posting Date";
                        if "Source Code" <> '' then begin
                            SourceCode.Get("Source Code");
                            SourceDesc := SourceCode.Description;
                        end;
                    end;
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
                    field(LineNarration; LineNarration)
                    {
                        Caption = 'Line Narration';
                    }
                    field(VoucherNarration; VoucherNarration)
                    {
                        Caption = 'Voucher Narration';
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
        Compinfo.Get;
    end;

    var
        Compinfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        SourceCode: Record "Source Code";
        GLAccName: Text[50];
        SourceDesc: Text[50];
        PostingDate: Date;
        LineNarration: Boolean;
        VoucherNarration: Boolean;
        DocNo: Code[20];
        TransNo: Integer;
        DayBookCaptionLbl: Label 'Day Book';
        DocumentNoCaptionLbl: Label 'Document No.';
        AccountNameCaptionLbl: Label 'Account Name';
        DebitAmountCaptionLbl: Label 'Debit Amount';
        CreditAmountCaptionLbl: Label 'Credit Amount';
        VoucherTypeCaptionLbl: Label 'Voucher Type';
        DateCaptionLbl: Label 'Date';
        TotalCaptionLbl: Label 'Total';

    procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[100]
    var
        AccName: Text[100];
        VendLedgEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        BankLedgEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
        FALedgEntry: Record "FA Ledger Entry";
        FA: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
    begin
        if "Source Type" = "Source Type"::Vendor then
            if VendLedgEntry.Get("Entry No.") then begin
                Vend.Get("Source No.");
                AccName := Vend.Name;
            end else begin
                GLAccount.Get("G/L Account No.");
                AccName := GLAccount.Name;
            end
        else
            if "Source Type" = "Source Type"::Customer then
                if CustLedgEntry.Get("Entry No.") then begin
                    Cust.Get("Source No.");
                    AccName := Cust.Name;
                end else begin
                    GLAccount.Get("G/L Account No.");
                    AccName := GLAccount.Name;
                end
            else
                if "Source Type" = "Source Type"::"Bank Account" then
                    if BankLedgEntry.Get("Entry No.") then begin
                        Bank.Get("Source No.");
                        AccName := Bank.Name;
                    end else begin
                        GLAccount.Get("G/L Account No.");
                        AccName := GLAccount.Name;
                    end
                else
                    if "Source Type" = "Source Type"::"Fixed Asset" then begin
                        FALedgEntry.Reset;
                        FALedgEntry.SetCurrentKey("G/L Entry No.");
                        FALedgEntry.SetRange("G/L Entry No.", "Entry No.");
                        if FALedgEntry.FindFirst then begin
                            FA.Get("Source No.");
                            AccName := FA.Description;
                        end else begin
                            GLAccount.Get("G/L Account No.");
                            AccName := GLAccount.Name;
                        end;
                    end else begin
                        GLAccount.Get("G/L Account No.");
                        AccName := GLAccount.Name;
                    end;

        if "Source Type" = "Source Type"::" " then begin
            GLAccount.Get("G/L Account No.");
            AccName := GLAccount.Name;
        end;

        exit(AccName);
    end;
}

