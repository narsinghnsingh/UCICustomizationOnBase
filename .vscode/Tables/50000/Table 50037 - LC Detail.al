table 50037 "LC Detail"
{
    // version LC Detail


    fields
    {
        field(1;"No.";Code[20])
        {
            CaptionML = ENU = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  GLSetup.Get;
                  NoSeriesMgt.TestManual(GLSetup."Detail Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[50])
        {
            CaptionML = ENU = 'Description';
        }
        field(3;"Transaction Type";Option)
        {
            CaptionML = ENU = 'Transaction Type';
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;

            trigger OnValidate()
            begin
                if "Transaction Type" <> xRec."Transaction Type" then begin
                  "Issued To/Received From" := '';
                  "Issuing Bank" := '';
                  "LC Value" := 0;
                end;
            end;
        }
        field(4;"Issued To/Received From";Code[20])
        {
            CaptionML = ENU = 'Issued To/Received From';
            TableRelation = IF ("Transaction Type"=CONST(Sale)) Customer
                            ELSE IF ("Transaction Type"=CONST(Purchase)) Vendor;

            trigger OnValidate()
            begin
                if "Issued To/Received From" <> xRec."Issued To/Received From" then begin
                  "Issuing Bank" := '';
                  "LC Value" := 0;
                end;
            end;
        }
        field(5;"Issuing Bank";Code[20])
        {
            CaptionML = ENU = 'Issuing Bank';

            trigger OnLookup()
            begin
                Clear(Bankform);
                Clear(CustBankform);
                if "Transaction Type" = "Transaction Type"::Sale then begin
                  CustBank.SetRange("Customer No.","Issued To/Received From");
                  CustBankform.LookupMode(true);
                  CustBankform.SetTableView(CustBank);
                  if CustBankform.RunModal = ACTION::LookupOK then begin
                    CustBankform.GetRecord(CustBank);
                    if not Released then
                      "Issuing Bank" := CustBank.Code;
                  end;
                end;
                if "Transaction Type" = "Transaction Type"::Purchase then begin
                  Bankform.LookupMode(true);
                  Bankform.SetTableView(Bank);
                  if Bankform.RunModal = ACTION::LookupOK then begin
                    Bankform.GetRecord(Bank);
                    if not Released then
                      "Issuing Bank" := Bank."No.";
                  end;
                end;
                Validate("Issuing Bank");
            end;

            trigger OnValidate()
            begin
                if "Issuing Bank" <> xRec."Issuing Bank" then
                  "LC Value" := 0;
            end;
        }
        field(6;"Date of Issue";Date)
        {
            CaptionML = ENU = 'Date of Issue';

            trigger OnValidate()
            begin
                if "Expiry Date" <> 0D then
                  if "Date of Issue" > "Expiry Date" then
                    Error(Text13703);
            end;
        }
        field(7;"Expiry Date";Date)
        {
            CaptionML = ENU = 'Expiry Date';

            trigger OnValidate()
            begin
                if "Date of Issue" <> 0D then
                  if "Date of Issue" > "Expiry Date" then
                    Error(Text13700);
            end;
        }
        field(8;"Type of LC";Option)
        {
            CaptionML = ENU = 'Type of LC';
            OptionCaption = 'Inland,Foreign';
            OptionMembers = Inland,Foreign;

            trigger OnValidate()
            begin
                if "Type of LC" = "Type of LC"::Inland then begin
                  "Currency Code" := '';
                  "Exchange Rate" := 0;
                end;
                Validate("LC Value");
            end;
        }
        field(9;"Type of Credit Limit";Option)
        {
            CaptionML = ENU = 'Type of Credit Limit';
            OptionCaption = 'Fixed,Revolving';
            OptionMembers = "Fixed",Revolving;

            trigger OnValidate()
            begin
                if "Type of Credit Limit" = "Type of Credit Limit"::Fixed then
                  "Revolving Cr. Limit Types" := "Revolving Cr. Limit Types"::" ";
            end;
        }
        field(10;"Currency Code";Code[10])
        {
            CaptionML = ENU = 'Currency Code';
            TableRelation = IF ("Type of LC"=CONST(Foreign)) Currency.Code;

            trigger OnValidate()
            begin
                if "Currency Code" <> '' then begin
                  CurrExchRate.SetRange("Currency Code","Currency Code");
                  CurrExchRate.SetRange("Starting Date",0D,"Date of Issue");
                  CurrExchRate.FindLast;
                  "Exchange Rate" := CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount";
                end;
                Validate("LC Value");
            end;
        }
        field(11;"No. Series";Code[10])
        {
            CaptionML = ENU = 'No. Series';
            TableRelation = "No. Series";
        }
        field(12;"LC Value";Decimal)
        {
            CaptionML = ENU = 'LC Value';

            trigger OnValidate()
            var
                Currency: Record Currency;
                TotalAmount: Decimal;
            begin
                Clear(TotalAmount);
                if "Currency Code" <> '' then begin
                  Currency.Get("Currency Code");
                  "LC Value LCY" := Round("LC Value" * "Exchange Rate",Currency."Amount Rounding Precision");
                end else
                  "LC Value LCY" := "LC Value";
                if "Transaction Type" = "Transaction Type"::Purchase then begin
                  BankCrLimit.SetRange("Bank No.","Issuing Bank");
                  BankCrLimit.SetFilter("From Date",'<= %1',"Date of Issue");
                  BankCrLimit.SetFilter("To Date",'>=%1',"Date of Issue");
                  if BankCrLimit.FindLast then begin
                    LCDetails.Reset;
                    LCDetails.SetRange("Transaction Type","Transaction Type");
                    LCDetails.SetRange("Issuing Bank",BankCrLimit."Bank No.");
                    if BankCrLimit."To Date" <> 0D then
                      LCDetails.SetFilter("Date of Issue",'%1..%2',BankCrLimit."From Date",BankCrLimit."To Date")
                    else
                      LCDetails.SetFilter("Date of Issue",'>=%1',BankCrLimit."From Date");
                    LCDetails.SetFilter("No.",'<>%1',"No.");
                    if LCDetails.Find('-') then
                      repeat
                        if LCDetails."Latest Amended Value" = 0 then
                          TotalAmount := TotalAmount + LCDetails."LC Value LCY"
                        else
                          TotalAmount := TotalAmount + LCDetails."Latest Amended Value";
                      until LCDetails.Next = 0;
                    if TotalAmount + "LC Value LCY" > BankCrLimit.Amount then
                      Error(Text13704);
                  end else
                    if "LC Value" <> 0 then
                      Error(Text13705);
                end;
                CalcFields("Value Utilised");
                "Remaining Amount" := "LC Value LCY" - "Value Utilised";
                "Latest Amended Value" := "LC Value LCY";
            end;
        }
        field(13;"Value Utilised";Decimal)
        {
            CalcFormula = Sum("LC Orders"."Order Value" WHERE ("LC No."=FIELD("No.")));
            CaptionML = ENU = 'Value Utilised';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Remaining Amount";Decimal)
        {
            CaptionML = ENU = 'Remaining Amount';
            Editable = false;
        }
        field(15;Closed;Boolean)
        {
            CaptionML = ENU = 'Closed';
            Editable = false;
        }
        field(16;Released;Boolean)
        {
            CaptionML = ENU = 'Released';
        }
        field(17;"Revolving Cr. Limit Types";Option)
        {
            CaptionML = ENU = 'Revolving Cr. Limit Types';
            OptionCaption = ' ,Automatic,Manual';
            OptionMembers = " ",Automatic,Manual;
        }
        field(18;"Latest Amended Value";Decimal)
        {
            CaptionML = ENU = 'Latest Amended Value';
            Editable = false;
        }
        field(21;"Exchange Rate";Decimal)
        {
            CaptionML = ENU = 'Exchange Rate';

            trigger OnValidate()
            begin
                Validate("LC Value");
            end;
        }
        field(22;"LC Value LCY";Decimal)
        {
            CaptionML = ENU = 'LC Value LCY';
            Editable = false;
        }
        field(23;"Receiving Bank";Code[20])
        {
            CaptionML = ENU = 'Receiving Bank';

            trigger OnLookup()
            begin
                Clear(Bankform);
                Clear(VendBankForm);
                if "Transaction Type" = "Transaction Type"::Purchase then begin
                  VendBank.SetRange("Vendor No.","Issued To/Received From");
                  VendBankForm.LookupMode(true);
                  VendBankForm.SetTableView(VendBank);
                  if VendBankForm.RunModal = ACTION::LookupOK then begin
                    VendBankForm.GetRecord(VendBank);
                    if not Released then
                      "Receiving Bank" := VendBank.Code;
                  end;
                end;
                if "Transaction Type" = "Transaction Type"::Sale then begin
                  Bankform.LookupMode(true);
                  Bankform.SetTableView(Bank);
                  if Bankform.RunModal = ACTION::LookupOK then begin
                    Bankform.GetRecord(Bank);
                    if not Released then
                      "Receiving Bank" := Bank."No.";
                  end;
                end;
                Validate("Receiving Bank");
            end;
        }
        field(24;"LC No.";Code[20])
        {
            CaptionML = ENU = 'LC No.';
        }
        field(25;"Renewed Amount";Decimal)
        {
            CalcFormula = Sum("LC Orders"."Order Value" WHERE ("LC No."=FIELD("No."),
                                                               Renewed=CONST(true)));
            CaptionML = ENU = 'Renewed Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001;"LC Charge Posted";Boolean)
        {
        }
        field(50002;"LC G/L Entry Exist";Boolean)
        {
            CalcFormula = Exist("G/L Entry" WHERE ("LC No."=FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50003;"LC Charges";Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE ("LC No."=FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50004;Name;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;"LC No.",Description,"Issued To/Received From","Issuing Bank")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.","LC No.",Description,"Transaction Type","Issued To/Received From","Issuing Bank")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
          LCSetup.Get;
          LCSetup.TestField("Detail Nos.");
          NoSeriesMgt.InitSeries(LCSetup."Detail Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;
        "Date of Issue" := WorkDate;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        LCSetup: Record "General Ledger Setup";
        LCDetails: Record "LC Detail";
        CustBank: Record "Customer Bank Account";
        Bank: Record "Bank Account";
        BankCrLimit: Record "Bank LC Limit Details";
        LCAmendments: Record "LC Amended Details";
        CustBankform: Page "Customer Bank Account List";
        Bankform: Page "Bank Account List";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        VendBank: Record "Vendor Bank Account";
        VendBankForm: Page "Vendor Bank Account List";
        CurrExchRate: Record "Currency Exchange Rate";
        Text13700: Label 'Expiry Date cannot be before Issue Date.';
        Text13701: Label 'You cannot modify.';
        Text13702: Label 'You cannot delete.';
        Text13703: Label 'Issue Date cannot be after Expiry Date.';
        Text13704: Label 'LC(s) value exceeds the credit limit available for this bank.';
        Text13705: Label 'Bank''''s credit limit is zero.';
}

