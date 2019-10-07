table 50031 "Post Dated Cheque PDC"
{
    // version Samadhan PDC
    LookupPageId = "Received PDC";
    DrillDownPageId = "Received PDC";


    fields
    {
        field(1; "PDC Number"; Code[20])
        {
            Editable = false;
        }
        field(2; "Account Type"; Option)
        {
            OptionCaption = 'Customer,Vendor';
            OptionMembers = Customer,Vendor;
        }
        field(3; "Account No"; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST (Customer)) Customer."No."
            ELSE
            IF ("Account Type" = CONST (Vendor)) Vendor."No.";

            trigger OnValidate()
            begin
                // Lines added by deepak Kumar
                if "Account Type" = 0 then begin
                    Customer.Reset;
                    Customer.SetRange(Customer."No.", "Account No");
                    if Customer.FindFirst then begin
                        Description := Customer.Name;
                    end else begin
                        Description := '';
                    end;
                end;

                if "Account Type" = 1 then begin
                    Vendor.Reset;
                    Vendor.SetRange(Vendor."No.", "Account No");
                    if Vendor.FindFirst then begin
                        Description := Vendor.Name;
                    end else begin
                        Description := '';
                    end;
                end;
                /*
                GLSetup.GET;
                IF "Account Type" = 0 THEN
                  VALIDATE("Receiving Account",GLSetup."Bill Receivable Account");
                IF "Account Type" = 1 THEN
                    VALIDATE("Receiving Account",GLSetup."Bill Payable Account");
                 */

            end;
        }
        field(4; Description; Text[100])
        {
        }
        field(5; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                "Update Amount";
                if "Currency Factor" <> 0 then
                    "Amount LCY" := Amount * "Currency Factor";
            end;
        }
        field(6; "Cheque No"; Code[10])
        {
        }
        field(7; "Cheque Date"; Date)
        {

            trigger OnValidate()
            begin
                // Lines add by deepak kumar

                Month := Date2DMY("Cheque Date", 2);
            end;
        }
        field(8; "Cheque Bank Name"; Text[30])
        {
        }
        field(9; "Posting Date"; Date)
        {
        }
        field(10; "Amount LCY"; Decimal)
        {
            Editable = false;
        }
        field(12; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if "Currency Code" <> '' then begin
                    if ("Currency Code" <> xRec."Currency Code") or
                       ("Posting Date" <> xRec."Posting Date") or
                       (CurrFieldNo = FieldNo("Currency Code")) or
                       ("Currency Factor" = 0)
                    then
                        "Currency Factor" := 1 /
                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                end else
                    "Currency Factor" := 1;
                Validate("Currency Factor");
                Validate(Amount);
            end;
        }
        field(18; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            InitValue = 1;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Currency Code" = '') and ("Currency Factor" <> 0) then
                    FieldError("Currency Factor", StrSubstNo(Text002, FieldCaption("Currency Code")));
                Validate(Amount);
            end;
        }
        field(100; "Receiving Account"; Code[10])
        {
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                // Lines added by Deepak kumar
                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.", "Receiving Account");
                if GLAccount.FindFirst then begin
                    "Receiving Acc. Name" := GLAccount.Name;
                end else begin
                    "Receiving Acc. Name" := '';
                end;
            end;
        }
        field(101; "Receiving Acc. Name"; Text[30])
        {
        }
        field(102; "Presented Bank"; Code[10])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                // Lines added by deepak kUmar
                Bank.Reset;
                Bank.SetRange(Bank."No.", "Presented Bank");
                if Bank.FindFirst then begin
                    "Presented Bank Name" := Bank.Name;
                end else begin
                    "Presented Bank Name" := '';
                end;
            end;
        }
        field(103; "Presented Bank Name"; Text[50])
        {
        }
        field(104; "User ID"; Text[50])
        {
            Editable = false;
        }
        field(105; Received; Boolean)
        {
            Editable = false;
        }
        field(106; Presented; Boolean)
        {
            Editable = false;
        }
        field(107; "Void Cheque"; Boolean)
        {
            Editable = false;
        }
        field(2000; "Debit Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                Validate(Amount, "Debit Amount");
            end;
        }
        field(2001; "Credit Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                Validate(Amount, -"Credit Amount");
            end;
        }
        field(2002; Narration; Text[150])
        {
        }
        field(10001; Month; Option)
        {
            Editable = false;
            OptionCaption = ',January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = ,January,February,March,April,May,June,July,August,September,October,November,December;
        }
    }

    keys
    {
        key(Key1; "PDC Number")
        {
        }
        key(Key2; "Cheque Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if (Received = true) and (Presented = false) then Error('You can not delete Received PDC');
    end;

    trigger OnInsert()
    begin
        // Lines added by deepak Kumar

        if "PDC Number" = '' then begin
            GLSetup.Get;
            GLSetup.TestField(GLSetup."PDC No. Series");
            NoSeriesMgt.InitSeries(GLSetup."PDC No. Series", '', 0D, "PDC Number", GLSetup."PDC No. Series");
        end;
        "User ID" := UserId;
        "Posting Date" := WorkDate;
    end;

    trigger OnModify()
    begin

        //IF (Received = TRUE) AND (Presented = FALSE) THEN ERROR('You can not Modify Received PDC');
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        Bank: Record "Bank Account";
        GLSetup: Record "General Ledger Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlLineN: Record "Gen. Journal Line";
        PDCTable: Record "Post Dated Cheque PDC";
        CurrExchRate: Record "Currency Exchange Rate";
        Text002: Label 'cannot be specified without %1';

    procedure "--Samadhan"()
    begin
    end;

    procedure PostRecipt(PDCNumber: Code[20])
    begin
        // Lines added by Deepak kumar
        PDCTable.Reset;
        PDCTable.SetRange(PDCTable."PDC Number", PDCNumber);
        if PDCTable.FindFirst then begin
            PDCTable.TestField(PDCTable.Amount);
            PDCTable.TestField(PDCTable."Account No");
            PDCTable.TestField(PDCTable."Cheque No");
            PDCTable.TestField(PDCTable."Cheque Date");
            PDCTable.TestField(PDCTable."Posting Date");
            PDCTable.TestField(PDCTable.Received, false);
            PDCTable.TestField(PDCTable.Presented, false);
            //PDCTable.TESTFIELD(PDCTable."Receiving Account");

            // Lines Updated BY Deepak kumar on 05.01.15
            GenJnlLineN.Init;
            GLSetup.Get;
            GLSetup.TestField(GLSetup."Bill Receivable Account");
            GLSetup.TestField(GLSetup."Bill Payable Account");
            GLSetup.TestField(GLSetup."Bill Receivable PDC Interim");
            GLSetup.TestField(GLSetup."Bill Payable PDC Interim");

            GenJnlLineN."Document Type" := GenJnlLineN."Document Type"::Payment;

            if GLSetup."PDC Posting Date" = 0 then begin
                GenJnlLineN."Posting Date" := WorkDate;
                GenJnlLineN."Document Date" := WorkDate;
            end;

            if GLSetup."PDC Posting Date" = 1 then begin
                GenJnlLineN."Posting Date" := PDCTable."Cheque Date";
                GenJnlLineN."Document Date" := PDCTable."Cheque Date";
            end;

            GenJnlLineN."Cheque No." := PDCTable."Cheque No";
            GenJnlLineN."Cheque Date" := PDCTable."Cheque Date";
            GenJnlLineN.Description := PDCTable.Description;
            GenJnlLineN."Document No." := PDCTable."PDC Number";
            GenJnlLineN."PDC Type" := 1;
            GenJnlLineN."External Document No." := PDCTable."PDC Number";
            GenJnlLineN."Post Dated Cheque" := true;

            if PDCTable."Account Type" = 0 then begin
                GenJnlLineN."Source Type" := GenJnlLineN."Source Type"::Customer;
                GenJnlLineN."Source No." := PDCTable."Account No";
                GenJnlLineN."Account Type" := GenJnlLineN."Account Type"::"G/L Account";
                GenJnlLineN.Validate("Account No.", GLSetup."Bill Receivable Account");
            end;

            if PDCTable."Account Type" = 1 then begin
                GenJnlLineN."Source Type" := GenJnlLineN."Source Type"::Vendor;
                GenJnlLineN."Source No." := PDCTable."Account No";
                GenJnlLineN."Account Type" := GenJnlLineN."Account Type"::"G/L Account";
                GenJnlLineN.Validate("Account No.", GLSetup."Bill Payable Account");
            end;

            GenJnlLineN."Currency Code" := PDCTable."Currency Code";
            if PDCTable."Currency Code" = '' then
                GenJnlLineN."Currency Factor" := 1
            else
                GenJnlLineN."Currency Factor" := PDCTable."Currency Factor";

            GenJnlLineN.Validate(Amount, PDCTable.Amount);
            if PDCTable."Account Type" = 0 then begin
                GenJnlLineN."Bal. Account Type" := GenJnlLineN."Bal. Account Type"::"G/L Account";
                GenJnlLineN.Validate("Bal. Account No.", GLSetup."Bill Receivable PDC Interim");
            end;

            if PDCTable."Account Type" = 1 then begin
                GenJnlLineN."Bal. Account Type" := GenJnlLineN."Bal. Account Type"::"G/L Account";
                GenJnlLineN.Validate("Bal. Account No.", GLSetup."Bill Payable PDC Interim");
            end;

            GenJnlPostLine.Run(GenJnlLineN);
            PDCTable.Received := true;
            PDCTable.Modify(true);

            Message('Complete');

        end;
    end;

    procedure PostReciptBank(PDCNumber: Code[20])
    begin
        // Lines added by Deepak kumar
        PDCTable.Reset;
        PDCTable.SetRange(PDCTable."PDC Number", PDCNumber);
        if PDCTable.FindFirst then begin


            PDCTable.TestField(PDCTable."Presented Bank");
            PDCTable.TestField(PDCTable."Void Cheque", false);
            PDCTable.TestField(PDCTable.Received, true);

            GenJnlLineN.Init;
            GLSetup.Get;
            GLSetup.TestField(GLSetup."Bill Receivable Account");
            GLSetup.TestField(GLSetup."Bill Payable Account");
            GLSetup.TestField(GLSetup."Bill Receivable PDC Interim");
            GLSetup.TestField(GLSetup."Bill Payable PDC Interim");

            GenJnlLineN."Document Type" := GenJnlLineN."Document Type"::Payment;
            if GLSetup."PDC Posting Date" = 0 then begin
                GenJnlLineN."Posting Date" := WorkDate;
                GenJnlLineN."Document Date" := WorkDate;
            end;

            if GLSetup."PDC Posting Date" = 1 then begin
                GenJnlLineN."Posting Date" := PDCTable."Cheque Date";
                GenJnlLineN."Document Date" := PDCTable."Cheque Date";
            end;

            GenJnlLineN."Cheque No." := PDCTable."Cheque No";
            GenJnlLineN."Cheque Date" := PDCTable."Cheque Date";
            GenJnlLineN.Description := PDCTable.Description;
            GenJnlLineN."Document No." := PDCTable."PDC Number";
            GenJnlLineN."PDC Type" := 2;
            GenJnlLineN."External Document No." := PDCTable."PDC Number";
            GenJnlLineN."Post Dated Cheque" := true;

            if PDCTable."Account Type" = 0 then begin
                GenJnlLineN."Account Type" := GenJnlLineN."Account Type"::"G/L Account";
                GenJnlLineN.Validate("Account No.", GLSetup."Bill Receivable PDC Interim");
            end;

            if PDCTable."Account Type" = 1 then begin
                GenJnlLineN."Account Type" := GenJnlLineN."Account Type"::"G/L Account";
                GenJnlLineN.Validate("Account No.", GLSetup."Bill Payable PDC Interim");
            end;


            GenJnlLineN."Currency Code" := PDCTable."Currency Code";
            if PDCTable."Currency Code" = '' then
                GenJnlLineN."Currency Factor" := 1
            else
                GenJnlLineN."Currency Factor" := PDCTable."Currency Factor";

            GenJnlLineN.Validate(Amount, PDCTable.Amount);

            if PDCTable."Account Type" = 0 then begin
                GenJnlLineN."Source Type" := GenJnlLineN."Source Type"::Customer;
                GenJnlLineN."Source No." := PDCTable."Account No";
                GenJnlLineN.Validate(GenJnlLineN."Bal. Account No.", GLSetup."Bill Receivable Account");
            end;

            if PDCTable."Account Type" = 1 then begin
                GenJnlLineN."Source Type" := GenJnlLineN."Source Type"::Vendor;
                GenJnlLineN."Source No." := PDCTable."Account No";
                GenJnlLineN.Validate(GenJnlLineN."Bal. Account No.", GLSetup."Bill Payable Account");
            end;


            GenJnlPostLine.Run(GenJnlLineN);
            // Post Customer Entry
            GenJnlLineN.Init;
            GLSetup.Get;
            GenJnlLineN."Document Type" := GenJnlLineN."Document Type"::Payment;
            if GLSetup."PDC Posting Date" = 0 then begin
                GenJnlLineN."Posting Date" := WorkDate;
                GenJnlLineN."Document Date" := WorkDate;
            end;

            if GLSetup."PDC Posting Date" = 1 then begin
                GenJnlLineN."Posting Date" := PDCTable."Cheque Date";
                GenJnlLineN."Document Date" := PDCTable."Cheque Date";
            end;

            GenJnlLineN."Cheque No." := PDCTable."Cheque No";
            GenJnlLineN."Cheque Date" := PDCTable."Cheque Date";

            GenJnlLineN.Description := PDCTable.Description;
            GenJnlLineN."Document No." := PDCTable."PDC Number";
            GenJnlLineN."PDC Type" := 2;
            GenJnlLineN."External Document No." := PDCTable."PDC Number";
            GenJnlLineN."Post Dated Cheque" := true;


            if PDCTable."Account Type" = 0 then begin
                GenJnlLineN."Account Type" := GenJnlLineN."Account Type"::Customer;
                GenJnlLineN.Validate(GenJnlLineN."Account No.", PDCTable."Account No");
            end;

            if PDCTable."Account Type" = 1 then begin
                GenJnlLineN."Account Type" := GenJnlLineN."Account Type"::Vendor;
                GenJnlLineN.Validate(GenJnlLineN."Account No.", PDCTable."Account No");
            end;
            GenJnlLineN."Currency Code" := PDCTable."Currency Code";
            if PDCTable."Currency Code" = '' then
                GenJnlLineN."Currency Factor" := 1
            else
                GenJnlLineN."Currency Factor" := PDCTable."Currency Factor";

            GenJnlLineN.Validate(Amount, PDCTable.Amount);
            GenJnlLineN."Bal. Account Type" := GenJnlLineN."Bal. Account Type"::"Bank Account";
            GenJnlLineN."Bal. Account No." := PDCTable."Presented Bank";

            //  COMMIT;

            GenJnlPostLine.Run(GenJnlLineN);

            Message('Complete');
            PDCTable.Presented := true;
            PDCTable.Modify(true);

        end;
    end;

    procedure "Update Amount"()
    begin
        if (Amount > 0) then begin
            "Debit Amount" := Amount;
            "Credit Amount" := 0
        end else begin
            "Debit Amount" := 0;
            "Credit Amount" := Amount;
        end;
    end;

    procedure VoidCheque(PDCNumber: Code[20])
    begin
        // Lines added by Deepak kumar
        PDCTable.Reset;
        PDCTable.SetRange(PDCTable."PDC Number", PDCNumber);
        if PDCTable.FindFirst then begin
            PDCTable.TestField(PDCTable.Received, true);
            PDCTable.TestField(PDCTable.Presented, false);
            PDCTable.TestField(PDCTable."Void Cheque", false);
            PDCTable.TestField(PDCTable.Amount);
            PDCTable.TestField(PDCTable."Account No");
            PDCTable.TestField(PDCTable."Cheque No");
            PDCTable.TestField(PDCTable."Cheque Date");
            PDCTable.TestField(PDCTable."Posting Date");

            // Lines Updated BY Deepak kumar on 05.01.15
            GenJnlLineN.Init;
            GLSetup.Get;
            GLSetup.TestField(GLSetup."Bill Receivable Account");
            GLSetup.TestField(GLSetup."Bill Payable Account");
            GLSetup.TestField(GLSetup."Bill Receivable PDC Interim");
            GLSetup.TestField(GLSetup."Bill Payable PDC Interim");

            GenJnlLineN."Document Type" := GenJnlLineN."Document Type"::Payment;

            if GLSetup."PDC Posting Date" = 0 then begin
                GenJnlLineN."Posting Date" := WorkDate;
                GenJnlLineN."Document Date" := WorkDate;
            end;

            if GLSetup."PDC Posting Date" = 1 then begin
                GenJnlLineN."Posting Date" := PDCTable."Cheque Date";
                GenJnlLineN."Document Date" := PDCTable."Cheque Date";
            end;

            GenJnlLineN."Cheque No." := PDCTable."Cheque No";
            GenJnlLineN."Cheque Date" := PDCTable."Cheque Date";
            GenJnlLineN.Description := PDCTable.Description;
            GenJnlLineN."Document No." := PDCTable."PDC Number";
            GenJnlLineN."PDC Type" := GenJnlLineN."PDC Type"::"Void Cheque";
            GenJnlLineN."External Document No." := PDCTable."PDC Number";
            GenJnlLineN."Post Dated Cheque" := true;

            if PDCTable."Account Type" = 0 then begin
                GenJnlLineN."Source Type" := GenJnlLineN."Source Type"::Customer;
                GenJnlLineN."Source No." := PDCTable."Account No";
                GenJnlLineN."Account Type" := GenJnlLineN."Account Type"::"G/L Account";
                GenJnlLineN.Validate("Account No.", GLSetup."Bill Receivable Account");
            end;

            if PDCTable."Account Type" = 1 then begin
                GenJnlLineN."Source Type" := GenJnlLineN."Source Type"::Vendor;
                GenJnlLineN."Source No." := PDCTable."Account No";
                GenJnlLineN."Account Type" := GenJnlLineN."Account Type"::"G/L Account";
                GenJnlLineN.Validate("Account No.", GLSetup."Bill Payable Account");
            end;

            GenJnlLineN."Currency Code" := PDCTable."Currency Code";
            if PDCTable."Currency Code" = '' then
                GenJnlLineN."Currency Factor" := 1
            else
                GenJnlLineN."Currency Factor" := PDCTable."Currency Factor";

            GenJnlLineN.Validate(Amount, -PDCTable.Amount);
            if PDCTable."Account Type" = 0 then begin
                GenJnlLineN."Bal. Account Type" := GenJnlLineN."Bal. Account Type"::"G/L Account";
                GenJnlLineN.Validate("Bal. Account No.", GLSetup."Bill Receivable PDC Interim");
            end;

            if PDCTable."Account Type" = 1 then begin
                GenJnlLineN."Bal. Account Type" := GenJnlLineN."Bal. Account Type"::"G/L Account";
                GenJnlLineN.Validate("Bal. Account No.", GLSetup."Bill Payable PDC Interim");
            end;

            GenJnlPostLine.Run(GenJnlLineN);
            PDCTable."Void Cheque" := true;
            PDCTable.Modify(true);

            Message('Complete');

        end;
    end;
}

