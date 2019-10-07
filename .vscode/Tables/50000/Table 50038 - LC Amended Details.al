table 50038 "LC Amended Details"
{
    // version LC Detail

    CaptionML = ENU = 'LC Amended Details';
    DataCaptionFields = "No.",Description;
    //DrillDownPageID = 16320;
    //LookupPageID = 16320;

    fields
    {
        field(1;"No.";Code[20])
        {
            CaptionML = ENU = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  LCSetup.Get;
                  NoSeriesMgt.TestManual(LCSetup."Amended Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"LC No.";Code[20])
        {
            CaptionML = ENU = 'LC No.';
        }
        field(3;Description;Text[50])
        {
            CaptionML = ENU = 'Description';
        }
        field(4;"Transaction Type";Option)
        {
            CaptionML = ENU = 'Transaction Type';
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;
        }
        field(5;"Issued To/Received From";Code[20])
        {
            CaptionML = ENU = 'Issued To/Received From';
            TableRelation = IF ("Transaction Type"=CONST(Sale)) Customer
                            ELSE IF ("Transaction Type"=CONST(Purchase)) Vendor;
        }
        field(6;"Issuing Bank";Code[20])
        {
            CaptionML = ENU = 'Issuing Bank';
            TableRelation = "Bank Account";
        }
        field(7;"Date of Issue";Date)
        {
            CaptionML = ENU = 'Date of Issue';
        }
        field(8;"Expiry Date";Date)
        {
            CaptionML = ENU = 'Expiry Date';

            trigger OnValidate()
            begin
                if "Date of Issue" <> 0D then
                  if "Date of Issue" > "Expiry Date" then
                    Error(Text003);
                LCDetails.Get("LC No.");
                LCDetails."Expiry Date" := "Expiry Date";
                LCDetails.Modify;
            end;
        }
        field(9;"Type of LC";Option)
        {
            CaptionML = ENU = 'Type of LC';
            OptionCaption = 'Inland,Foreign';
            OptionMembers = Inland,Foreign;
        }
        field(10;"Type of Credit Limit";Option)
        {
            CaptionML = ENU = 'Type of Credit Limit';
            OptionCaption = 'Fixed,Revolving';
            OptionMembers = "Fixed",Revolving;
        }
        field(11;"Currency Code";Code[10])
        {
            CaptionML = ENU = 'Currency Code';
            TableRelation = IF ("Type of LC"=CONST(Foreign)) Currency;
        }
        field(12;"No. Series";Code[10])
        {
            CaptionML = ENU = 'No. Series';
            TableRelation = "No. Series";
        }
        field(13;"LC Value";Decimal)
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
                    LCDetails.SetFilter("No.",'<>%1',"LC No.");
                    if LCDetails.Find('-') then
                      repeat
                        if LCDetails."Latest Amended Value" = 0 then
                          TotalAmount := TotalAmount + LCDetails."LC Value LCY"
                        else
                          TotalAmount := TotalAmount + LCDetails."Latest Amended Value";
                      until LCDetails.Next = 0;
                    if TotalAmount + "LC Value LCY" > BankCrLimit.Amount then
                      Error(Text004);
                  end else
                    if "LC Value" <> 0 then
                      Error(Text005);
                end;

                CalcFields("Value Utilised");
                if "LC Value LCY" < "Value Utilised" then
                  Error(Text006);
                "Remaining Amount" := "LC Value LCY" - "Value Utilised";
                LCDetails.Get("LC No.");
                LCDetails."Latest Amended Value" := "LC Value LCY";
                if "LC Value" <> 0 then
                  LCDetails."LC Value" := "LC Value";
                LCDetails."Remaining Amount" := "LC Value LCY" - "Value Utilised";
                LCDetails."LC Value LCY" := "LC Value LCY";
                LCDetails.Modify;
            end;
        }
        field(14;"Value Utilised";Decimal)
        {
            CalcFormula = Sum("LC Orders"."Order Value" WHERE ("LC No."=FIELD("LC No.")));
            CaptionML = ENU = 'Value Utilised';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15;"Remaining Amount";Decimal)
        {
            CaptionML = ENU = 'Remaining Amount';
            Editable = false;
        }
        field(16;"LC Amended Date";Date)
        {
            CaptionML = ENU = 'LC Amended Date';
        }
        field(17;Released;Boolean)
        {
            CaptionML = ENU = 'Released';
            Editable = false;
        }
        field(18;Closed;Boolean)
        {
            CaptionML = ENU = 'Closed';
            Editable = false;
        }
        field(21;"Exchange Rate";Decimal)
        {
            CaptionML = ENU = 'Exchange Rate';
        }
        field(22;"LC Value LCY";Decimal)
        {
            CaptionML = ENU = 'LC Value LCY';
            Editable = false;
        }
        field(23;"Receiving Bank";Code[20])
        {
            CaptionML = ENU = 'Receiving Bank';
        }
        field(24;"Bank LC No.";Code[20])
        {
            CaptionML = ENU = 'Bank LC No.';
        }
        field(25;"Bank Amended No.";Code[20])
        {
            CaptionML = ENU = 'Bank Amended No.';
        }
        field(26;"Revolving Cr. Limit Types";Option)
        {
            CaptionML = ENU = 'Revolving Cr. Limit Types';
            OptionCaption = ' ,Automatic,Manual';
            OptionMembers = " ",Automatic,Manual;
        }
        field(27;"Previous LC Value";Decimal)
        {
            CaptionML = ENU = 'Previous LC Value';
        }
        field(28;"Previous Expiry Date";Date)
        {
            CaptionML = ENU = 'Previous Expiry Date';
        }
    }

    keys
    {
        key(Key1;"No.","LC No.")
        {
        }
        key(Key2;Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Released then
          Error(Text002);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
          LCSetup.Get;
          LCSetup.TestField("Amended Nos.");
          NoSeriesMgt.InitSeries(LCSetup."Amended Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;
    end;

    trigger OnModify()
    begin
        if Closed then
          Error(Text001);
    end;

    var
        LCSetup: Record "General Ledger Setup";
        LCDetails: Record "LC Detail";
        LCADetails: Record "LC Amended Details";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: Label 'You cannot modify the Document.';
        Text002: Label 'You cannot delete the document.';
        Text003: Label 'Expiry Date cannot be before Issue Date.';
        Text004: Label 'LC(s) value exceeds the credit limit available for this bank.';
        Text005: Label 'Banks credit limit is Zero.';
        Text006: Label 'LC Value cannot be lower than the Value Utilised.';
        BankCrLimit: Record "Bank LC Limit Details";

    procedure AssistEdit(OldLCADetails: Record "LC Amended Details"): Boolean
    begin
        with LCADetails do begin
          LCADetails := Rec;
          LCSetup.Get;
          LCSetup.TestField("Amended Nos.");
          if NoSeriesMgt.SelectSeries(LCSetup."Amended Nos.",OldLCADetails."No. Series","No. Series") then begin
            LCSetup.Get;
            LCSetup.TestField("Amended Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := LCADetails;
            exit(true);
          end;
        end;
    end;
}

