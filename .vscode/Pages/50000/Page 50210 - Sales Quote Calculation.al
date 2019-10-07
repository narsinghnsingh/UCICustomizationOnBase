page 50210 "Sales Quote Calculation"
{
    // version SalesQuotePrice

    AutoSplitKey = true;
    CaptionML = ENU = 'Sales Quote Calculation';
    DataCaptionFields = "Document No.";
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Quote Price Calculation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Line No."; "Line No.")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Length (mm)"; "Length (mm)")
                {
                }
                field("Width (mm)"; "Width (mm)")
                {
                }
                field("Height (mm)"; "Height (mm)")
                {
                }
                field("No of Ply"; "No of Ply")
                {
                }
                field(Flute; Flute)
                {
                }
                field("Joint Type"; "Joint Type")
                {
                }
                field("GSM (for Calc)"; "GSM (for Calc)")
                {
                }
                field("Sheet length"; "Sheet length")
                {
                }
                field("Sheet Width"; "Sheet Width")
                {
                }
                field("Weight per Unit (Kg)"; "Weight per Unit (Kg)")
                {
                }
                field("Per Unit Price"; "Per Unit Price")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Rate Per KG (Company)"; "Rate Per KG (Company)")
                {
                }
                field("Sales Unit Price"; "Sales Unit Price")
                {
                }
                field("Customer GSM"; "Customer GSM")
                {
                }
            }
            group(Control15)
            {
                ShowCaption = false;
                field("SalesQuoteLine.Description"; SalesQuoteLine.Description)
                {
                    Editable = false;
                }
                field("SalesQuoteLine.Quantity"; SalesQuoteLine.Quantity)
                {
                    Editable = false;
                }
                field("SalesQuoteLine.""Salesperson Code"""; SalesQuoteLine."Salesperson Code")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Price")
            {
                CaptionML = ENU = 'Calculate Price';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CalculateWeightandPrice;
                end;
            }
            action(GetLine)
            {
                CaptionML = ENU = 'GetLine';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    EnquiryLineAttributeEntry.Reset;
                    EnquiryLineAttributeEntry.SetRange(EnquiryLineAttributeEntry."Document Type", EnquiryLineAttributeEntry."Document Type"::Quote);
                    EnquiryLineAttributeEntry.SetRange(EnquiryLineAttributeEntry."Document No.", GetFilter("Document No."));
                    EnquiryLineAttributeEntry.SetFilter(EnquiryLineAttributeEntry."Line No.", GetFilter("Line No."));
                    if EnquiryLineAttributeEntry.FindFirst then begin

                        repeat

                            if EnquiryLineAttributeEntry."Item Attribute Code" = 'MODEL' then begin
                                "Model Code" := EnquiryLineAttributeEntry."Item Attribute Value";
                            end;
                            if EnquiryLineAttributeEntry."Item Attribute Code" = 'FG_GSM' then begin
                                "Customer GSM" := EnquiryLineAttributeEntry."Attribute Value Numeric";
                            end;
                            if EnquiryLineAttributeEntry."Item Attribute Code" = 'FLUTE' then begin
                                Flute := EnquiryLineAttributeEntry."Item Attribute Value";

                            end;
                            if EnquiryLineAttributeEntry."Item Attribute Code" = 'HEIGHT' then begin
                                "Height (mm)" := EnquiryLineAttributeEntry."Attribute Value Numeric";
                            end;
                            if EnquiryLineAttributeEntry."Item Attribute Code" = 'LENGTH' then begin
                                "Length (mm)" := EnquiryLineAttributeEntry."Attribute Value Numeric";

                            end;
                            if EnquiryLineAttributeEntry."Item Attribute Code" = 'WIDTH' then begin
                                "Width (mm)" := EnquiryLineAttributeEntry."Attribute Value Numeric";

                            end;

                            if EnquiryLineAttributeEntry."Item Attribute Code" = 'PLY' then begin
                                "No of Ply" := EnquiryLineAttributeEntry."Attribute Value Numeric";
                            end;

                            if EnquiryLineAttributeEntry."Item Attribute Code" = 'JOINT_TYPE' then begin
                                "Joint Type" := EnquiryLineAttributeEntry."Item Attribute Value";
                            end;
                            Modify(true);



                        until EnquiryLineAttributeEntry.Next = 0;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SalesQuoteLine.Reset;
        SalesQuoteLine.SetRange(SalesQuoteLine."Document Type", SalesQuoteLine."Document Type"::Quote);
        SalesQuoteLine.SetRange(SalesQuoteLine."Document No.", "Document No.");
        SalesQuoteLine.SetRange(SalesQuoteLine."Line No.", "Document Line No.");
        SalesQuoteLine.FindFirst;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        EnquiryLineAttributeEntry: Record "Enquiry Line Attribute Entry";
    begin
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // Lines added By Deepak Kumar
        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Quote);
        SalesLine.SetRange(SalesLine."Document No.", "Document No.");
        SalesLine.SetRange(SalesLine."Line No.", "Document Line No.");
        if SalesLine.FindFirst then begin
            CalcFields("Sales Unit Price");

            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
            if SalesHeader."Currency Code" <> '' then begin
                Currency.TestField("Unit-Amount Rounding Precision");
                TempSalesPrice := 0;
                TempSalesPrice :=
                  Round(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      WorkDate, SalesHeader."Currency Code",
                      "Sales Unit Price", SalesHeader."Currency Factor"),
                    Currency."Unit-Amount Rounding Precision");
                SalesLine."Sales Price per Unit (Company)" := TempSalesPrice;
                SalesLine.Validate("Unit Price", TempSalesPrice);

            end else begin
                SalesLine."Sales Price per Unit (Company)" := "Sales Unit Price";
                SalesLine.Validate("Unit Price", "Sales Unit Price");
            end;
            SalesLine.Modify(true);
        end;
    end;

    var
        SalesLine: Record "Sales Line";
        SalesQuoteLine: Record "Sales Line";
        EnquiryLineAttributeEntry: Record "Enquiry Line Attribute Entry";
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
        TempSalesPrice: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
}

