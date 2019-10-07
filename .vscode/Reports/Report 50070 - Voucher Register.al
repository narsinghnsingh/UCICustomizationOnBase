report 50070 "Voucher Register"
{
    // version NAVIN7.10

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Voucher Register.rdl';
    Caption = 'Voucher Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.";
            column(No_GLReg; "No.")
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemTableView = SORTING ("Document No.", "Posting Date", Amount) ORDER(Descending);
                column(VoucherSourceDesc; SourceDesc + ' Voucher')
                {
                }
                column(DocumentNo_GLEntry; "Document No.")
                {
                }
                column(PostingDateFormatted; 'Date: ' + Format("Posting Date"))
                {
                }
                column(CompanyInformationAddress; CompanyInformation.Address + ' ' + CompanyInformation."Address 2" + '  ' + CompanyInformation.City)
                {
                }
                column(CompanyInformationName; CompanyInformation.Name)
                {
                }
                column(CreditAmount_GLEntry; "Credit Amount")
                {
                }
                column(DebitAmount_GLEntry; "Debit Amount")
                {
                }
                column(DrText; DrText)
                {
                }
                column(GLAccName; GLAccName)
                {
                }
                column(CrText; CrText)
                {
                }
                column(DebitAmountTotal; DebitAmountTotal)
                {
                }
                column(CreditAmountTotal; CreditAmountTotal)
                {
                }
                column(ChequeNoDateFormatted; 'Cheque No: ' + ChequeNo + '  Dated: ' + Format(ChequeDate))
                {
                }
                column(ChequeNo; ChequeNo)
                {
                }
                column(ChequeDate; ChequeDate)
                {
                }
                column(RsNumberText1NumberText2; 'Rs. ' + NumberText[1] + ' ' + NumberText[2])
                {
                }
                column(EntryNo_GLEntry; "Entry No.")
                {
                }
                column(PostingDate_GLEntry; "Posting Date")
                {
                }
                column(TransactionNo_GLEntry; "Transaction No.")
                {
                }
                column(VoucherNoCaption; VoucherNoCaptionLbl)
                {
                }
                column(CreditAmountCaption; CreditAmountCaptionLbl)
                {
                }
                column(DebitAmountCaption; DebitAmountCaptionLbl)
                {
                }
                column(ParticularsCaption; ParticularsCaptionLbl)
                {
                }
                column(AmountinwordsCaption; AmountinwordsCaptionLbl)
                {
                }
                column(PreparedbyCaption; PreparedbyCaptionLbl)
                {
                }
                column(CheckedbyCaption; CheckedbyCaptionLbl)
                {
                }
                column(ApprovedbyCaption; ApprovedbyCaptionLbl)
                {
                }
                dataitem(LineNarration; "Posted Narration")
                {
                    DataItemLink = "Transaction No." = FIELD ("Transaction No."), "Entry No." = FIELD ("Entry No.");
                    DataItemTableView = SORTING ("Entry No.", "Transaction No.", "Line No.");
                    column(Narration_LineNarration; Narration)
                    {
                    }
                    column(PrintLineNarration; PrintLineNarration)
                    {
                    }
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING (Number);
                    column(IntegerOccurcesCaption; IntegerOccurcesCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        PageLoop := PageLoop - 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLEntry.SetCurrentKey("Document No.", "Posting Date", Amount);
                        GLEntry.Ascending(false);
                        GLEntry.SetRange("Posting Date", "G/L Entry"."Posting Date");
                        GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                        GLEntry.SetRange("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                        GLEntry.FindLast;
                        if not (GLEntry."Entry No." = "G/L Entry"."Entry No.") then
                            CurrReport.Break;

                        SetRange(Number, 1, PageLoop)
                    end;
                }
                dataitem(PostedNarration1; "Posted Narration")
                {
                    DataItemLink = "Transaction No." = FIELD ("Transaction No.");
                    DataItemTableView = SORTING ("Entry No.", "Transaction No.", "Line No.") WHERE ("Entry No." = FILTER (0));
                    column(Narration_PostedNarration; Narration)
                    {
                    }
                    column(NarrationCaption; NarrationCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        PostedNarrationOne := Narration <> '';
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLEntry.SetCurrentKey("Document No.", "Posting Date", Amount);
                        GLEntry.Ascending(false);
                        GLEntry.SetRange("Posting Date", "G/L Entry"."Posting Date");
                        GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                        GLEntry.FindLast;
                        if not (GLEntry."Entry No." = "G/L Entry"."Entry No.") then
                            CurrReport.Break;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    GLAccName := FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                    if Amount < 0 then begin
                        CrText := 'To';
                        DrText := '';
                    end else begin
                        CrText := '';
                        DrText := 'Dr';
                    end;
                    SourceDesc := '';
                    if "Source Code" <> '' then begin
                        SourceCode.Get("Source Code");
                        SourceDesc := SourceCode.Description;
                    end;

                    PageLoop := PageLoop - 1;
                    LinesPrinted := LinesPrinted + 1;

                    ChequeNo := '';
                    ChequeDate := 0D;
                    if ("Source No." <> '') and ("Source Type" = "Source Type"::"Bank Account") then begin
                        if BankAccLedgEntry.Get("Entry No.") then begin
                            ChequeNo := BankAccLedgEntry."Cheque No.";
                            ChequeDate := BankAccLedgEntry."Cheque Date";
                        end;
                    end;

                    PrintBody5 := (ChequeNo <> '') and (ChequeDate <> 0D);
                    if PrintBody5 or PrintLineNarration then begin
                        PageLoop := PageLoop - 1;
                        LinesPrinted := LinesPrinted + 1;
                    end;


                    if PostingDate <> "Posting Date" then begin
                        PostingDate := "Posting Date";
                        TotalDebitAmt := 0;
                    end;
                    if DocumentNo <> "Document No." then begin
                        DocumentNo := "Document No.";
                        TotalDebitAmt := 0;
                    end;

                    if PostingDate = "Posting Date" then begin
                        InitTextVariable;
                        TotalDebitAmt += "Debit Amount";
                        FormatNoText(NumberText, Abs(TotalDebitAmt), '');
                        PageLoop := NUMLines;
                        LinesPrinted := 0;
                    end;

                    if (PrePostingDate <> "Posting Date") or (PreDocumentNo <> "Document No.") then begin
                        DebitAmountTotal := 0;
                        CreditAmountTotal := 0;
                        PrePostingDate := "Posting Date";
                        PreDocumentNo := "Document No.";
                        PageLoop := NUMLines;
                        LinesPrinted := 0;
                        PageLoop := PageLoop - 1;
                    end;
                    DebitAmountTotal := DebitAmountTotal + "Debit Amount";
                    CreditAmountTotal := CreditAmountTotal + "Credit Amount";

                    LinesPrinted := LinesPrinted + 1;

                    InitTextVariable();
                    FormatNoText(NumberText, Abs(DebitAmountTotal), '');
                end;

                trigger OnPreDataItem()
                begin
                    NUMLines := 13;
                    PageLoop := NUMLines;
                    LinesPrinted := 0;
                    TotalDebitAmt := 0;
                    SetRange("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                end;
            }
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
                    field(PrintLineNarration; PrintLineNarration)
                    {
                        Caption = 'PrintLineNarration';
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
        CompanyInformation.Get;
    end;

    var
        CompanyInformation: Record "Company Information";
        GLEntry: Record "G/L Entry";
        SourceCode: Record "Source Code";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLAccName: Text[50];
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        NumberText: array[2] of Text[80];
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ChequeNo: Code[20];
        ChequeDate: Date;
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        Text16526: Label 'ZERO';
        Text16527: Label 'HUNDRED';
        Text16528: Label 'AND';
        Text16529: Label '%1 results in a written number that is too long.';
        Text16532: Label 'ONE';
        Text16533: Label 'TWO';
        Text16534: Label 'THREE';
        Text16535: Label 'FOUR';
        Text16536: Label 'FIVE';
        Text16537: Label 'SIX';
        Text16538: Label 'SEVEN';
        Text16539: Label 'EIGHT';
        Text16540: Label 'NINE';
        Text16541: Label 'TEN';
        Text16542: Label 'ELEVEN';
        Text16543: Label 'TWELVE';
        Text16544: Label 'THIRTEEN';
        Text16545: Label 'FOURTEEN';
        Text16546: Label 'FIFTEEN';
        Text16547: Label 'SIXTEEN';
        Text16548: Label 'SEVENTEEN';
        Text16549: Label 'EIGHTEEN';
        Text16550: Label 'NINETEEN';
        Text16551: Label 'TWENTY';
        Text16552: Label 'THIRTY';
        Text16553: Label 'FORTY';
        Text16554: Label 'FIFTY';
        Text16555: Label 'SIXTY';
        Text16556: Label 'SEVENTY';
        Text16557: Label 'EIGHTY';
        Text16558: Label 'NINETY';
        Text16559: Label 'THOUSAND';
        Text16560: Label 'MILLION';
        Text16561: Label 'BILLION';
        Text16562: Label 'LAKH';
        Text16563: Label 'CRORE';
        PrintLineNarration: Boolean;
        PrePostingDate: Date;
        PreDocumentNo: Code[30];
        DebitAmountTotal: Decimal;
        CreditAmountTotal: Decimal;
        PrintBody5: Boolean;
        PostedNarrationOne: Boolean;
        PostingDate: Date;
        TotalDebitAmt: Decimal;
        DocumentNo: Code[20];
        VoucherNoCaptionLbl: Label 'Voucher No. :';
        CreditAmountCaptionLbl: Label 'Credit Amount';
        DebitAmountCaptionLbl: Label 'Debit Amount';
        ParticularsCaptionLbl: Label 'Particulars';
        AmountinwordsCaptionLbl: Label 'Amount (in words):';
        PreparedbyCaptionLbl: Label 'Prepared by:';
        CheckedbyCaptionLbl: Label 'Checked by:';
        ApprovedbyCaptionLbl: Label 'Approved by:';
        IntegerOccurcesCaptionLbl: Label 'IntegerOccurcesCaption';
        NarrationCaptionLbl: Label 'Narration :';

    procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50]
    var
        AccName: Text[50];
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

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                if No > 99999 then begin
                    Ones := No div(Power(100, Exponent - 1) * 10);
                    Hundreds := 0;
                end else begin
                    Ones := No div Power(1000, Exponent - 1);
                    Hundreds := Ones div 100;
                end;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                if No > 99999 then
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(100, Exponent - 1) * 10
                else
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if CurrencyCode <> '' then begin
            Currency.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Currency Numeric description");
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528);

        TensDec := ((No * 100) mod 100) div 10;
        OnesDec := (No * 100) mod 10;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526);
        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Currency Decimal description" + ' ONLY')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text16529, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
    end;
}

