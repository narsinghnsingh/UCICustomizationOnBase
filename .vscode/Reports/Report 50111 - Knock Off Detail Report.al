report 50111 "Knock Off Detail Report"
{
    // version NAVW18.00

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Knock Off Detail Report.rdl';
    Caption = 'Knock Off Detail Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING ("Document Type", "Customer No.", "Posting Date", "Currency Code") WHERE ("Document Type" = FILTER ('' | Payment | Refund | "Credit Memo"));
            RequestFilterFields = "Customer No.", "Posting Date", "Document No.";
            column(EntryNo_CustLedgEntry; "Entry No.")
            {
            }
            column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
            {
            }
            column(SelltoCustomerNo_CustLedgerEntry; "Cust. Ledger Entry"."Sell-to Customer No.")
            {
            }
            column(ChequeNo_CustLedgerEntry; "Cust. Ledger Entry"."Cheque No.")
            {
            }
            column(ChequeDate_CustLedgerEntry; Format("Cust. Ledger Entry"."Cheque Date"))
            {
            }
            column(OriginalAmount_CustLedgerEntry; "Cust. Ledger Entry"."Original Amount")
            {
            }
            column(Description_CustLedgerEntry; "Cust. Ledger Entry".Description)
            {
            }
            column(CompInfo_nAME; CompInfo1.Name)
            {
            }
            column(Add1; CompInfo1.Address)
            {
            }
            column(Add2; CompInfo1."Address 2")
            {
            }
            column(City; CompInfo1.City)
            {
            }
            column(PostCode; CompInfo1."Post Code")
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(CustName; CustName)
            {
            }
            column(Bal__Account_No_; "Bal. Account No.")
            {
            }
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CustomerNo_CustLedgEntry; "Cust. Ledger Entry"."Customer No.")
                {
                    IncludeCaption = true;
                }
                column(DocDate_CustLedgEntry; Format("Cust. Ledger Entry"."Document Date", 0, 4))
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CompanyAddr5; CompanyAddr[5])
                {
                }
                column(CompanyAddr6; CompanyAddr[6])
                {
                }
                column(CompanyInfoEMail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                {
                }
                column(CompanyInfoBankName; CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                {
                }
                column(ReportTitle; ReportTitle)
                {
                }
                column(DocumentNo_CustLedgEntry; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(PaymentDiscountTitle; PaymentDiscountTitle)
                {
                }
                column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                {
                }
                column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                {
                }
                column(CompanyInfoBankNameCptn; CompanyInfoBankNameCptnLbl)
                {
                }
                column(CompanyInfoBankAccNoCptn; CompanyInfoBankAccNoCptnLbl)
                {
                }
                column(ReceiptNoCaption; ReceiptNoCaptionLbl)
                {
                }
                column(CompanyInfoVATRegNoCptn; CompanyInfoVATRegNoCptnLbl)
                {
                }
                column(CustLedgEntry1PostDtCptn; CustLedgEntry1PostDtCptnLbl)
                {
                }
                column(AmountCaption; AmountCaptionLbl)
                {
                }
                column(PaymAmtSpecificationCptn; PaymAmtSpecificationCptnLbl)
                {
                }
                column(PmtTolInvCurrCaption; PmtTolInvCurrCaptionLbl)
                {
                }
                column(DocumentDateCaption; DocumentDateCaptionLbl)
                {
                }
                column(CompanyInfoEMailCaption; CompanyInfoEMailCaptionLbl)
                {
                }
                column(CompanyInfoHomePageCptn; CompanyInfoHomePageCptnLbl)
                {
                }
                dataitem(DetailedCustLedgEntry1; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Applied Cust. Ledger Entry No." = FIELD ("Entry No.");
                    DataItemLinkReference = "Cust. Ledger Entry";
                    DataItemTableView = SORTING ("Applied Cust. Ledger Entry No.", "Entry Type") WHERE (Unapplied = CONST (false));
                    dataitem(CustLedgEntry1; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Entry No." = FIELD ("Cust. Ledger Entry No.");
                        DataItemLinkReference = DetailedCustLedgEntry1;
                        DataItemTableView = SORTING ("Entry No.");
                        column(PostDate_CustLedgEntry1; Format("Posting Date"))
                        {
                        }
                        column(DocType_CustLedgEntry1; "Document Type")
                        {
                            IncludeCaption = true;
                        }
                        column(DocumentNo_CustLedgEntry1; "Document No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Desc_CustLedgEntry1; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(CurrCode_CustLedgEntry1; CurrencyCode("Currency Code"))
                        {
                        }
                        column(ShowAmount; ShowAmount)
                        {
                        }
                        column(PmtDiscInvCurr; PmtDiscInvCurr)
                        {
                        }
                        column(PmtTolInvCurr; PmtTolInvCurr)
                        {
                        }
                        column(CurrencyCodeCaption; FieldCaption("Currency Code"))
                        {
                        }
                        column(ExternalDocumentNo_CustLedgEntry1; CustLedgEntry1."External Document No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "Entry No." = "Cust. Ledger Entry"."Entry No." then
                                CurrReport.Skip;

                            PmtDiscInvCurr := 0;
                            PmtTolInvCurr := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            ShowAmount := -DetailedCustLedgEntry1.Amount;

                            if "Cust. Ledger Entry"."Currency Code" <> "Currency Code" then begin
                                PmtDiscInvCurr := Round("Pmt. Disc. Given (LCY)" * "Original Currency Factor");
                                PmtTolInvCurr := Round("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                                AppliedAmount :=
                                  Round(
                                    -DetailedCustLedgEntry1.Amount / "Original Currency Factor" *
                                    "Cust. Ledger Entry"."Original Currency Factor", Currency."Amount Rounding Precision");
                            end else begin
                                PmtDiscInvCurr := Round("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                                PmtTolInvCurr := Round("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                                AppliedAmount := -DetailedCustLedgEntry1.Amount;
                            end;

                            PmtDiscPmtCurr := Round("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            PmtTolPmtCurr := Round("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");

                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                        end;
                    }
                }
                dataitem(DetailedCustLedgEntry2; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No." = FIELD ("Entry No.");
                    DataItemLinkReference = "Cust. Ledger Entry";
                    DataItemTableView = SORTING ("Cust. Ledger Entry No.", "Entry Type", "Posting Date") WHERE (Unapplied = CONST (false));
                    dataitem(CustLedgEntry2; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Entry No." = FIELD ("Applied Cust. Ledger Entry No.");
                        DataItemLinkReference = DetailedCustLedgEntry2;
                        DataItemTableView = SORTING ("Entry No.");
                        column(AppliedAmount; AppliedAmount)
                        {
                        }
                        column(Desc_CustLedgEntry2; Description)
                        {
                        }
                        column(DocumentNo_CustLedgEntry2; "Document No.")
                        {
                        }
                        column(DocType_CustLedgEntry2; "Document Type")
                        {
                        }
                        column(PostDate_CustLedgEntry2; Format("Posting Date"))
                        {
                        }
                        column(PmtDiscInvCurr1; PmtDiscInvCurr)
                        {
                        }
                        column(PmtTolInvCurr1; PmtTolInvCurr)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "Entry No." = "Cust. Ledger Entry"."Entry No." then
                                CurrReport.Skip;

                            PmtDiscInvCurr := 0;
                            PmtTolInvCurr := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            ShowAmount := DetailedCustLedgEntry2.Amount;

                            if "Cust. Ledger Entry"."Currency Code" <> "Currency Code" then begin
                                PmtDiscInvCurr := Round("Pmt. Disc. Given (LCY)" * "Original Currency Factor");
                                PmtTolInvCurr := Round("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                            end else begin
                                PmtDiscInvCurr := Round("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                                PmtTolInvCurr := Round("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            end;

                            PmtDiscPmtCurr := Round("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            PmtTolPmtCurr := Round("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");

                            AppliedAmount := DetailedCustLedgEntry2.Amount;
                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                        end;
                    }
                }
                dataitem(Total; "Integer")
                {
                    DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
                    column(RemainingAmount; RemainingAmount)
                    {
                    }
                    column(CurrCode_CustLedgEntry; CurrencyCode("Cust. Ledger Entry"."Currency Code"))
                    {
                    }
                    column(OriginalAmt_CustLedgEntry; "Cust. Ledger Entry"."Original Amount")
                    {
                    }
                    column(ExtDocNo_CustLedgEntry; "Cust. Ledger Entry"."External Document No.")
                    {
                    }
                    column(PaymAmtNotAllocatedCptn; PaymAmtNotAllocatedCptnLbl)
                    {
                    }
                    column(CustLedgEntryOrgAmtCptn; CustLedgEntryOrgAmtCptnLbl)
                    {
                    }
                    column(ExternalDocumentNoCaption; ExternalDocumentNoCaptionLbl)
                    {
                    }
                    column(CHQNO; "Chq.No.")
                    {
                    }
                    column(CHQDATE; "Chq.date")
                    {
                    }
                    column(Bank_Name; Bank_Name)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Chq.No." := '';
                        "Chq.date" := 0D;
                        Bank_Name := '';
                        BankAccountLedgerEntry.Reset;
                        BankAccountLedgerEntry.SetRange(BankAccountLedgerEntry."Document No.", CustLedgEntry2."Document No.");
                        if BankAccountLedgerEntry.FindFirst then begin
                            "Chq.No." := BankAccountLedgerEntry."Cheque No.";
                            "Chq.date" := BankAccountLedgerEntry."Cheque Date";
                            BankCode := BankAccountLedgerEntry."Bank Account No.";
                            BankAccount.Reset;
                            BankAccount.SetRange(BankAccount."No.", BankCode);
                            if BankAccount.FindFirst then begin
                                Bank_Name := BankAccount.Name;
                            end;
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                Cust.Get("Customer No.");
                FormatAddr.Customer(CustAddr, Cust);

                "Cust. Ledger Entry".CalcFields("Cust. Ledger Entry"."Customer  Name");
                CustName := "Cust. Ledger Entry"."Customer  Name";

                if not Currency.Get("Currency Code") then
                    Currency.InitRoundingPrecision;

                if "Document Type" = "Document Type"::Payment then begin
                    ReportTitle := Text003;
                    PaymentDiscountTitle := Text006;
                end else begin
                    ReportTitle := Text004;
                    PaymentDiscountTitle := Text007;
                end;

                CalcFields("Original Amount");
                RemainingAmount := -"Original Amount";
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                GLSetup.Get;

                CompInfo1.Get;

                FilterString := "Cust. Ledger Entry".GetFilters;
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
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Cust: Record Customer;
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        ReportTitle: Text[30];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array[8] of Text[50];
        CustAddr: array[8] of Text[50];
        RemainingAmount: Decimal;
        AppliedAmount: Decimal;
        PmtDiscInvCurr: Decimal;
        PmtTolInvCurr: Decimal;
        PmtDiscPmtCurr: Decimal;
        Text003: Label 'Receipt Voucher';
        Text004: Label 'Payment Voucher';
        Text006: Label 'Pmt. Disc. Given';
        Text007: Label 'Pmt. Disc. Rcvd.';
        PmtTolPmtCurr: Decimal;
        ShowAmount: Decimal;
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCptnLbl: Label 'Bank';
        CompanyInfoBankAccNoCptnLbl: Label 'Account No.';
        ReceiptNoCaptionLbl: Label 'Receipt No.';
        CompanyInfoVATRegNoCptnLbl: Label 'GST Reg. No.';
        CustLedgEntry1PostDtCptnLbl: Label 'Posting Date';
        AmountCaptionLbl: Label 'Amount';
        PaymAmtSpecificationCptnLbl: Label 'Payment Amount Specification';
        PmtTolInvCurrCaptionLbl: Label 'Pmt Tol.';
        DocumentDateCaptionLbl: Label 'Document Date';
        CompanyInfoEMailCaptionLbl: Label 'E-Mail';
        CompanyInfoHomePageCptnLbl: Label 'Home Page';
        PaymAmtNotAllocatedCptnLbl: Label 'Payment Amount Not Allocated';
        CustLedgEntryOrgAmtCptnLbl: Label 'Payment Amount';
        ExternalDocumentNoCaptionLbl: Label 'External Document No.';
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        "Chq.No.": Code[30];
        "Chq.date": Date;
        BankCode: Code[30];
        BankAccount: Record "Bank Account";
        Bank_Name: Text;
        CompInfo1: Record "Company Information";
        FilterString: Text;
        CustName: Text[200];

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
            exit(GLSetup."LCY Code");
        exit(SrcCurrCode);
    end;
}

