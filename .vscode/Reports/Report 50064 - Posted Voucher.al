report 50064 "Posted Voucher"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Posted Voucher.rdl';
    Caption = 'Posted Voucher';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING ("Document No.", "Posting Date", Amount) ORDER(Descending);
            RequestFilterFields = "Posting Date", "Document No.";
            column(PDCCustName; PDCCustName)
            {
            }
            column(PDCChequeNo; PDCChequeNo)
            {
            }
            column(PDCChequeDate; PDCChequeDate)
            {
            }
            column(PDCAccountNo; PDCAccountNo)
            {
            }
            column(DetailsCaption; DetailsCaption)
            {
            }
            column(VoucherSourceDesc; SourceDesc)
            {
            }
            column(DocumentNo_GLEntry; "Document No.")
            {
            }
            column(PostingDateFormatted; 'Date: ' + Format("Posting Date"))
            {
            }
            column(CompanyInformationAddress; CompanyInformation.Address)
            {
            }
            column(CompanyInformationAdress1; CompanyInformation."Address 2" + '  ' + CompanyInformation.City)
            {
            }
            column(CompanyInformationName; CompanyInformation.Name)
            {
            }
            column(Companyinfo_Pic; CompanyInformation.Picture)
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
            column(EmployeeName; EmployeeName)
            {
                AutoCalcField = true;
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
            column(ChequeDetail; 'Cheque No: ' + ChequeNo + '  Dated: ' + Format(ChequeDate))
            {
            }
            column(ChequeNo; ChequeNo)
            {
            }
            column(ChequeDate; ChequeDate)
            {
            }
            column(RsNumberText1NumberText2; 'DHS ' + notext[1] + ' ' + notext[2])
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
            column(PAY; PAY)
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
            column(AmountInWordsCaption; AmountInWordsCaptionLbl)
            {
            }
            column(PreparedByCaption; PreparedByCaptionLbl)
            {
            }
            column(CheckedByCaption; CheckedByCaptionLbl)
            {
            }
            column(ApprovedByCaption; ApprovedByCaptionLbl)
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

                trigger OnAfterGetRecord()
                begin

                    if PrintLineNarration then begin
                        PageLoop := PageLoop - 1;
                        LinesPrinted := LinesPrinted + 1;
                    end;
                end;
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
                column(Narration_PostedNarration1; Narration)
                {
                }
                column(NarrationCaption; NarrationCaptionLbl)
                {
                }

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
                CompanyInformation.CalcFields(CompanyInformation.Picture);

                GLAccName := FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                if Amount < 0 then begin
                    //CrText := 'To';
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
                        Currencycode2 := BankAccLedgEntry."Currency Code";
                    end;
                end;

                if (ChequeNo <> '') and (ChequeDate <> 0D) then begin
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
                    FormatNoText(notext, Abs(TotalDebitAmt), Currencycode2);
                    // MESSAGE(FORMAT(ABS(TotalDebitAmt)));
                    // AmttoText.FormatNoTextposted(notext,TotalDebitAmt,'');

                    //  MESSAGE(notext[1]+notext[2]);


                    PageLoop := NUMLines;
                    LinesPrinted := 0;
                end;
                if (PrePostingDate <> "Posting Date") or (PreDocumentNo <> "Document No.") then begin
                    DebitAmountTotal := 0;
                    CreditAmountTotal := 0;
                    PrePostingDate := "Posting Date";
                    PreDocumentNo := "Document No.";
                end;

                DebitAmountTotal := DebitAmountTotal + "Debit Amount";
                CreditAmountTotal := CreditAmountTotal + "Credit Amount";

                if "Dimension Set ID" <> 0 then begin
                    EmployeeName := '';
                    DemesnsionSetId.Reset;
                    DemesnsionSetId.SetRange(DemesnsionSetId."Dimension Set ID", "Dimension Set ID");
                    if DemesnsionSetId.FindFirst then
                        if DemesnsionSetId."Dimension Code" = 'EMPLOYEE' then
                            DemesnsionSetId.CalcFields("Dimension Value Name");
                    EmployeeName := 'Employee Name :  ' + DemesnsionSetId."Dimension Value Name";
                end else begin
                    EmployeeName := '';
                end;


                // PDCCustName:='';
                //PDCChequeNo:='';
                //PDCChequeDate:=0D;
                //PDCAccountNo:='';

                if ("PDC Type" = "PDC Type"::"PDC Receive") or ("PDC Type" = "PDC Type"::"PDC Post") then begin
                    PDCCard.Reset;
                    PDCCard.SetRange(PDCCard."PDC Number", "G/L Entry"."Document No.");
                    if PDCCard.FindFirst then begin
                        PDCCustName := 'Account Name : ' + PDCCard.Description;
                        PDCChequeNo := 'Cheque No. & Date : ' + PDCCard."Cheque No" + ' &';
                        PDCChequeDate := PDCCard."Cheque Date";
                        PDCAccountNo := 'Account No. : ' + PDCCard."Account No";
                        DetailsCaption := 'PDC Details :';
                        //MESSAGE(PDCCustName);
                    end;
                end else begin
                    PDCCustName := '';
                    PDCChequeNo := '';
                    PDCChequeDate := 0D;
                    PDCAccountNo := '';
                    DetailsCaption := '';
                end;
            end;

            trigger OnPreDataItem()
            begin
                NUMLines := 13;
                PageLoop := NUMLines;
                LinesPrinted := 0;
                DebitAmountTotal := 0;
                CreditAmountTotal := 0;
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
        SourceCode: Record "Source Code";
        GLEntry: Record "G/L Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLAccName: Text[50];
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        NumberText1: Text[80];
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ChequeNo: Code[50];
        ChequeDate: Date;
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
        Text16562: Label 'HUNDRED';
        Text16564: Label 'FILS';
        Text16563: Label 'CRORE';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        PrintLineNarration: Boolean;
        PostingDate: Date;
        TotalDebitAmt: Decimal;
        DocumentNo: Code[20];
        DebitAmountTotal: Decimal;
        CreditAmountTotal: Decimal;
        PrePostingDate: Date;
        PreDocumentNo: Code[50];
        VoucherNoCaptionLbl: Label 'Voucher No. :';
        CreditAmountCaptionLbl: Label 'Credit Amount';
        DebitAmountCaptionLbl: Label 'Debit Amount';
        ParticularsCaptionLbl: Label 'Particulars';
        AmountInWordsCaptionLbl: Label 'Amount (in words):';
        PreparedByCaptionLbl: Label 'Prepared by:';
        CheckedByCaptionLbl: Label 'Checked by:';
        ApprovedByCaptionLbl: Label 'Approved by:';
        IntegerOccurcesCaptionLbl: Label 'IntegerOccurces';
        NarrationCaptionLbl: Label 'Narration :';
        PAY: Text;
        AmttoText: Report Check;
        notext: array[2] of Text;
        Currencycode2: Code[10];
        DemesnsionSetId: Record "Dimension Set Entry";
        EmployeeName: Text[100];
        PDCCard: Record "Post Dated Cheque PDC";
        PDCCustName: Text[100];
        PDCChequeNo: Code[60];
        PDCChequeDate: Date;
        PDCAccountNo: Code[100];
        DetailsCaption: Text[20];

    procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50]
    var
        AccName: Text[50];
        VendLedgerEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
        FALedgerEntry: Record "FA Ledger Entry";
        FA: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
    begin
        if "Source Type" = "Source Type"::Vendor then
            if VendLedgerEntry.Get("Entry No.") then begin
                Vend.Get("Source No.");
                AccName := Vend.Name;
            end else begin
                GLAccount.Get("G/L Account No.");
                AccName := GLAccount.Name;
            end
        else
            if "Source Type" = "Source Type"::Customer then
                if CustLedgerEntry.Get("Entry No.") then begin
                    Cust.Get("Source No.");
                    AccName := Cust.Name;
                end else begin
                    GLAccount.Get("G/L Account No.");
                    AccName := GLAccount.Name;
                end
            else
                if "Source Type" = "Source Type"::"Bank Account" then
                    if BankLedgerEntry.Get("Entry No.") then begin
                        Bank.Get("Source No.");
                        AccName := Bank.Name;
                    end else begin
                        GLAccount.Get("G/L Account No.");
                        AccName := GLAccount.Name;
                    end
                else begin
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
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526, '')
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds], '');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527, '');
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens], '');
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], '');
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones], '');
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent], '');
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;

        end;

        if CurrencyCode <> '' then begin
            Currency.Get(CurrencyCode);
            //AddToNoText(NoText,NoTextIndex,PrintExponent,' ' + Currency."Currency Numeric description",''); //new
            AddToNoText(NoText, NoTextIndex, PrintExponent, '', '');
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, '', '');

        if (CurrencyCode <> '') then begin
            Currency.Get(CurrencyCode);  //new
                                         //MESSAGE(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528 + ' ' + Text16564, '');//  new
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528 + ' ' + 'FILS', '');//  new1


        TensDec := ((No * 100) mod 100) div 10;
        OnesDec := (No * 100) mod 10;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec], '');
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec], '');
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec], '')
            else
                //AddToNoText(NoText,NoTextIndex,PrintExponent,'FILS '+Text16526,'');

                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526, '');
        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ONLY', '') //
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'ONLY', '');//
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]; text1: Text[30])
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
        ExponentText[3] := Text16560;
        ExponentText[4] := Text16561;
    end;
}

