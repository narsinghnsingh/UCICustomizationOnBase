report 50033 "Sales Quotation"
{
    // version Sales/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Sales Quotation.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING ("Document Type", "No.") ORDER(Ascending) WHERE ("Document Type" = CONST (Quote));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Proforma Invoice';
            column(COMPNAME1; COMPNAME)
            {
            }
            column(COMPNAME; COMPNAME)
            {
            }
            column(BankName; 'Bank Name :' + BankName)
            {
            }
            column(SwiftCode; 'Swift: ' + SwiftCode)
            {
            }
            column(BankAccNo; 'Account No. :' + BankAccNo)
            {
            }
            column(ADD; ADDRESS)
            {
            }
            column(ADD1; ADDRESS1)
            {
            }
            column(CITY; CITY)
            {
            }
            column(MOBNO; 'Phone No.  -  ' + MOBNO)
            {
            }
            column(WEB; 'Website  - ' + WEB)
            {
            }
            column(MAIL; 'E-mail  - ' + MAIL)
            {
            }
            column(Pic; CompanyInfo.Picture)
            {
            }
            column(your_Reference; "Sales Header"."Your Reference")
            {
            }
            column(No_SalesHeader; "Sales Header"."No.")
            {
            }
            column(OrderDate_SalesHeader; "Sales Header"."Order Date")
            {
            }
            column(ExternalDocumentNo_SalesHeader; "Sales Header"."External Document No.")
            {
            }
            column(SelltoCustomerName_SalesHeader; "Sales Header"."Sell-to Customer Name")
            {
            }
            column(ContactPerson; 'Kind Attn. :' + '  ' + "Sales Header"."Sell-to Contact")
            {
            }
            column(SelltoAddress_SalesHeader; "Sales Header"."Sell-to Address" + ',' + "Sales Header"."Sell-to Address 2")
            {
            }
            column(SelltoAddress2_SalesHeader; "Sales Header"."Sell-to Address 2")
            {
            }
            column(SelltoCity_SalesHeader; "Sales Header"."Sell-to City" + ' ( ' + "Sales Header"."Sell-to County" + ' ) ')
            {
            }
            column(SelltoPostCode_SalesHeader; "Sales Header"."Sell-to Post Code")
            {
            }
            column(BilltoName_SalesHeader; "Sales Header"."Bill-to Name")
            {
            }
            column(BilltoAddress_SalesHeader; "Sales Header"."Bill-to Address")
            {
            }
            column(BilltoAddress2_SalesHeader; "Sales Header"."Bill-to Address 2")
            {
            }
            column(BilltoCity_SalesHeader; "Sales Header"."Bill-to City" + '( ' + "Sales Header"."Sell-to County" + ')')
            {
            }
            column(BilltoPostCode_SalesHeader; "Sales Header"."Bill-to Post Code")
            {
            }
            column(proforma_date; "Sales Header"."Document Date")
            {
            }
            column(Amount_SalesHeader; "Sales Header".Amount)
            {
            }
            column(Headr_currency_code; "Sales Header"."Currency Code")
            {
            }
            column(Selltocountry; "Sales Header"."Sell-to County")
            {
            }
            column(PAYMENTDES; PAYMENTDES)
            {
            }
            column(METHODDESC; METHODDESC)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE ("Document Type" = CONST (Quote));
                column(SLNO; SLNO)
                {
                }
                column(No_SalesLine; "Sales Line"."No.")
                {
                }
                column(Description_SalesLine; "Sales Line".Description)
                {
                }
                column(UnitofMeasureCode_SalesLine; "Sales Line"."Unit of Measure Code")
                {
                }
                column(QtytoShip_SalesLine; "Sales Line".Quantity)
                {
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                }
                column(LineDiscount_SalesLine; "Sales Line"."Line Discount %")
                {
                }
                column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                {
                }
                column(LineAmount_SalesLine; "Sales Line"."Line Amount")
                {
                }
                column(Amount_Caption; '(' + "Sales Header"."Currency Code" + ')' + NumberText[1] + ' ' + NumberText[2])
                {
                }
                column(subtype1; subtype)
                {
                }
                column(Currency_Code; Curr_Code)
                {
                }
                column(BoxSize1; BoxSize1)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SLNO := SLNO + 1;
                    if "Sales Line"."Currency Code" <> '' then begin
                        Curr_Code := "Sales Line"."Currency Code"
                    end else
                        Curr_Code := 'AED';




                    //updated

                    lenght := '';
                    EnquiryLineAttribute.Reset;
                    EnquiryLineAttribute.SetRange(EnquiryLineAttribute."Document No.", "Document No.");
                    EnquiryLineAttribute.SetRange(EnquiryLineAttribute."Line No.", "Line No.");
                    EnquiryLineAttribute.SetFilter(EnquiryLineAttribute."Item Attribute Code", 'LENGTH');
                    if EnquiryLineAttribute.FindFirst then begin
                        repeat
                            lenght := EnquiryLineAttribute."Item Attribute Value";
                        until EnquiryLineAttribute.Next = 0;
                    end;

                    height := '';
                    EnquiryLineAttribute.Reset;
                    EnquiryLineAttribute.SetRange(EnquiryLineAttribute."Document No.", "Document No.");
                    EnquiryLineAttribute.SetRange(EnquiryLineAttribute."Line No.", "Line No.");
                    EnquiryLineAttribute.SetFilter(EnquiryLineAttribute."Item Attribute Code", 'HEIGHT');
                    if EnquiryLineAttribute.FindFirst then begin
                        repeat
                            height := EnquiryLineAttribute."Item Attribute Value";
                        until EnquiryLineAttribute.Next = 0;
                    end;
                    width := '';
                    EnquiryLineAttribute.Reset;
                    EnquiryLineAttribute.SetRange(EnquiryLineAttribute."Document No.", "Document No.");
                    EnquiryLineAttribute.SetRange(EnquiryLineAttribute."Line No.", "Line No.");

                    EnquiryLineAttribute.SetFilter(EnquiryLineAttribute."Item Attribute Code", 'WIDTH');
                    if EnquiryLineAttribute.FindFirst then begin
                        repeat
                            width := EnquiryLineAttribute."Item Attribute Value";
                        until EnquiryLineAttribute.Next = 0;
                    end;


                    BoxSize1 := lenght + ' ' + 'X' + ' ' + width + ' ' + 'X' + ' ' + height;
                    //MESSAGE( BoxSize1);
                end;
            }
            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemLink = "Document Type" = FIELD ("Document Type"), "No." = FIELD ("No.");
                DataItemTableView = SORTING (Type, "Sub- Type") ORDER(Ascending) WHERE ("Document Type" = CONST (Quote));
                column(Comments; "Sales Comment Line".Comment)
                {
                }
                column(sl; Format(sl) + '.')
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //IF  TermsGroup <> "Sales Comment Line"."Sub- Type" THEN BEGIN
                    //   sl:=0;
                    //   TermsGroup:="Sales Comment Line"."Sub- Type";
                    //END;
                    sl := sl + 1;
                    //MESSAGE("Sales Comment Line".Comment);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get;
                COMPNAME := CompanyInfo.Name;
                ADDRESS := CompanyInfo.Address;
                ADDRESS1 := CompanyInfo."Address 2";
                CITY := CompanyInfo.City;
                POSTCODE := CompanyInfo."Post Code";
                MOBNO := CompanyInfo."Phone No.";
                MAIL := CompanyInfo."E-Mail";
                WEB := CompanyInfo."Home Page";
                BankName := CompanyInfo."Bank Name";
                BankAccNo := CompanyInfo."Bank Account No.";
                SwiftCode := CompanyInfo."SWIFT Code";
                CompanyInfo.CalcFields(CompanyInfo.Picture);



                InitTextVariable;
                "Sales Header".CalcFields("Sales Header".Amount);
                TotalDebitAmt += "Sales Header".Amount;
                FormatNoText(NumberText, Abs(TotalDebitAmt), '');

                PT.Reset;
                PT.SetRange(PT.Code, "Payment Terms Code");
                if PT.FindFirst then begin
                    PAYMENTDES := PT.Description;
                end;

                PM.Reset;
                PM.SetRange(PM.Code, "Payment Method Code");
                if PM.FindFirst then begin
                    METHODDESC := PM.Description;
                end;
                /*
               lenght :='';
              EnquiryLineAttribute.RESET;
              EnquiryLineAttribute.SETRANGE(EnquiryLineAttribute."Document No.","No.");
              EnquiryLineAttribute.SETFILTER(EnquiryLineAttribute."Item Attribute Code", 'LENGTH');
              IF EnquiryLineAttribute.FINDFIRST THEN BEGIN
                REPEAT
                  lenght := EnquiryLineAttribute."Item Attribute Value";
                UNTIL EnquiryLineAttribute.NEXT= 0;
              END;

              height :='';
              EnquiryLineAttribute.RESET;
              EnquiryLineAttribute.SETRANGE(EnquiryLineAttribute."Document No.","No.");
              EnquiryLineAttribute.SETFILTER(EnquiryLineAttribute."Item Attribute Code",'HEIGHT');
              IF EnquiryLineAttribute.FINDFIRST THEN BEGIN
                REPEAT
                  height := EnquiryLineAttribute."Item Attribute Value";
                UNTIL EnquiryLineAttribute.NEXT= 0;
              END;
              width :='';
              EnquiryLineAttribute.RESET;
              EnquiryLineAttribute.SETRANGE(EnquiryLineAttribute."Document No.","No.");
              EnquiryLineAttribute.SETFILTER(EnquiryLineAttribute."Item Attribute Code", 'WIDTH');
              IF EnquiryLineAttribute.FINDFIRST THEN BEGIN
                REPEAT
                  width := EnquiryLineAttribute."Item Attribute Value";
                UNTIL EnquiryLineAttribute.NEXT= 0;
              END;


              BoxSize1:=lenght+' '+'X'+' '+width+' '+'X'+' '+height;
              //MESSAGE( BoxSize1);


               */

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
        COMPNAME: Text[50];
        ADDRESS: Text[50];
        ADDRESS1: Text[50];
        CITY: Text[50];
        MOBNO: Text;
        MAIL: Text[50];
        WEB: Text[50];
        POSTCODE: Code[20];
        SLNO: Integer;
        NumberText: array[2] of Text[80];
        NumberText1: array[2] of Text[100];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        Tens1: Integer;
        Ones1: Integer;
        Text026: Label 'Zero';
        Text027: Label 'Hundred';
        Text028: Label 'and';
        Text029: Label '%1 results in a written number that is too long.';
        Text032: Label 'One';
        Text033: Label 'Two';
        Text034: Label 'Three';
        Text035: Label 'Four';
        Text036: Label 'Five';
        Text037: Label 'Six';
        Text038: Label 'Seven';
        Text039: Label 'Eight';
        Text040: Label 'Nine';
        Text041: Label 'Ten';
        Text042: Label 'Eleven';
        Text043: Label 'Twelve';
        Text044: Label 'Thirteen';
        Text045: Label 'Fourteen';
        Text046: Label 'Fifteen';
        Text047: Label 'Sixteen';
        Text048: Label 'Seventeen';
        Text049: Label 'Eighteen';
        Text050: Label 'Nineteen';
        Text051: Label 'Twenty';
        Text052: Label 'Thirty';
        Text053: Label 'Forty';
        Text054: Label 'Fifty';
        Text055: Label 'Sixty';
        Text056: Label 'Seventy';
        Text057: Label 'Eighty';
        Text058: Label 'Ninety';
        Text059: Label 'Thousand';
        Text060: Label 'Lakh';
        Text061: Label 'Crore';
        TotalDebitAmt: Decimal;
        PT: Record "Payment Terms";
        PAYMENTDES: Text[30];
        PM: Record "Payment Method";
        METHODDESC: Text[30];
        BankAccNo: Code[20];
        BankName: Text[50];
        SwiftCode: Code[20];
        EstimateHeader: Record "Product Design Header";
        Boxsize: Text[50];
        SalesComment: Record "Sales Comment Line";
        comments: Text[30];
        type: Code[30];
        subtype: Code[30];
        Desc: Text[50];
        sl: Integer;
        TermsGroup: Option Shipment,Delivery,"Variation Quantity vs Actual",Payment,Validity;
        CheckList: Option Comment,"Sales CheckList",Terms;
        TypeDesc: Option Comment,"Sales CheckList",Terms;
        Desc1: Text[50];
        EnquiryLineAttribute: Record "Enquiry Line Attribute Entry";
        lenght: Code[30];
        height: Code[30];
        width: Code[30];
        BoxSize1: Code[50];
        AttributeValueEntry: Record "Product Design Component Table";
        salesLine: Record "Sales Line";
        Curr_Code: Code[10];

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Curr: Record Currency;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';
        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else
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
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
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

        if CurrencyCode <> '' then begin
            Curr.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, Curr.Description);
        end;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);

        Tens1 := ((No * 100) mod 100) div 10;
        Ones1 := (No * 100) mod 10;
        if Tens1 >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens1]);
            if Ones1 > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones1]);
        end else
            if (Tens1 * 10 + Ones1) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens1 * 10 + Ones1])
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text026);

        if CurrencyCode <> '' then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Curr.Description + ' ONLY')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'Fils Only');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;
}

