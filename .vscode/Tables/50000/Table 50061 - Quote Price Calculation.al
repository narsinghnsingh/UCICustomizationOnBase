table 50061 "Quote Price Calculation"
{
    // version SalesQuotePrice

    CaptionML = ENU = 'Quote Price Calculation';
    DrillDownPageID = "Qualified Employees";
    LookupPageID = "Sales Quote Calculation";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.';
            Editable = false;
            NotBlank = true;
        }
        field(2; "Document Line No."; Integer)
        {
            CaptionML = ENU = 'Document Line No.';
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.';
            Editable = false;
        }
        field(4; "Model Code"; Code[50])
        {
            CaptionML = ENU = 'Model Code';
            TableRelation = "Product Design Model Master"."Model No";
        }
        field(5; "Length (mm)"; Decimal)
        {
            CaptionML = ENU = 'Length (mm)';
        }
        field(6; "Width (mm)"; Decimal)
        {
            CaptionML = ENU = 'Width (mm)';
        }
        field(7; "Height (mm)"; Decimal)
        {
            CaptionML = ENU = 'Height (mm)';
        }
        field(8; "No of Ply"; Integer)
        {
            CaptionML = ENU = 'No of Ply';
        }
        field(9; Flute; Code[10])
        {
            AutoFormatType = 1;
            CaptionML = ENU = 'Flute 1';
        }
        field(10; "Joint Type"; Code[20])
        {
            CaptionML = ENU = 'Joint Type';
        }
        field(11; "GSM (for Calc)"; Decimal)
        {
            CaptionML = ENU = 'GSM (for Calc)';
        }
        field(12; "Sheet length"; Decimal)
        {
            CaptionML = ENU = 'Sheet length';
            Editable = false;
        }
        field(13; "Sheet Width"; Decimal)
        {
            CaptionML = ENU = 'Sheet Width';
            Editable = false;
        }
        field(50001; "Weight per Unit (Kg)"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Editable = false;
        }
        field(50002; "Rate Per KG (Company)"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Customer GSM"; Decimal)
        {
        }
        field(50004; "Per Unit Price"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(50005; "Sales Unit Price"; Decimal)
        {
            CalcFormula = Sum ("Quote Price Calculation"."Per Unit Price" WHERE ("Document No." = FIELD ("Document No."),
                                                                                "Document Line No." = FIELD ("Document Line No.")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Document Line No.", "Line No.")
        {
        }
        key(Key2; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'You cannot delete employee qualification information if there are comments associated with it.';
        Qualification: Record "Paper Variation";
        Employee: Record Employee;
        ManufacturingSetup: Record "Manufacturing Setup";
        SalesPrice: Record "Sales Price";

    procedure CalculateWeightandPrice()
    var
        QuotePriceCalculation: Record "Quote Price Calculation";
    begin
        // Lines added By Deepak Kumar
        QuotePriceCalculation.Reset;
        QuotePriceCalculation.SetRange(QuotePriceCalculation."Document No.", "Document No.");
        QuotePriceCalculation.SetRange(QuotePriceCalculation."Document Line No.", "Document Line No.");
        if QuotePriceCalculation.FindFirst then begin
            repeat
                if QuotePriceCalculation."Model Code" = '0201' then begin
                    QuotePriceCalculation."Sheet length" := 2 * (QuotePriceCalculation."Length (mm)" + QuotePriceCalculation."Width (mm)") + 30;
                    QuotePriceCalculation."Sheet Width" := QuotePriceCalculation."Width (mm)" + QuotePriceCalculation."Height (mm)";
                end;

                if QuotePriceCalculation."Model Code" = '0200' then begin
                    QuotePriceCalculation."Sheet length" := 2 * (QuotePriceCalculation."Length (mm)" + QuotePriceCalculation."Width (mm)") + 30;
                    QuotePriceCalculation."Sheet Width" := (QuotePriceCalculation."Width (mm)" / 2) + QuotePriceCalculation."Height (mm)";
                end;

                if QuotePriceCalculation."Model Code" = '0202' then begin
                    QuotePriceCalculation."Sheet length" := 2 * (QuotePriceCalculation."Length (mm)" + QuotePriceCalculation."Width (mm)") + 30;
                    QuotePriceCalculation."Sheet Width" := (QuotePriceCalculation."Width (mm)" + (QuotePriceCalculation."Width (mm)" / 2)) + QuotePriceCalculation."Height (mm)";
                end;
                if not (QuotePriceCalculation."Model Code" = '0201') or (QuotePriceCalculation."Model Code" = '0200')
                   or (QuotePriceCalculation."Model Code" = '0202') then begin
                    QuotePriceCalculation."Sheet length" := QuotePriceCalculation."Length (mm)";
                    QuotePriceCalculation."Sheet Width" := QuotePriceCalculation."Width (mm)";
                end;
                ManufacturingSetup.Get;
                SalesPrice.Reset;
                SalesPrice.SetRange(SalesPrice."Sales Type", SalesPrice."Sales Type"::"All Customers");
                SalesPrice.SetRange(SalesPrice."No. of Ply", QuotePriceCalculation."No of Ply");
                if SalesPrice.FindFirst then
                    QuotePriceCalculation."Rate Per KG (Company)" := SalesPrice."Unit Price"
                else
                    QuotePriceCalculation."Rate Per KG (Company)" := 0;

                QuotePriceCalculation."Weight per Unit (Kg)" := (QuotePriceCalculation."Sheet length" * QuotePriceCalculation."Sheet Width" * QuotePriceCalculation."GSM (for Calc)" * ManufacturingSetup."Scrap % for Estimation") / 1000000000;

                QuotePriceCalculation."Per Unit Price" := QuotePriceCalculation."Rate Per KG (Company)" * QuotePriceCalculation."Weight per Unit (Kg)";
                QuotePriceCalculation.Modify(true);
            until QuotePriceCalculation.Next = 0;
        end;
    end;
}

