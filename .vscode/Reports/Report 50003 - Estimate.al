report 50003 Estimate
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Estimate.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Product Design Header"; "Product Design Header")
        {
            DataItemTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.") ORDER(Ascending) WHERE (Name = FILTER (<> ''));
            RequestFilterFields = "Product Design No.";
            column(Name_Comp; CompanyInfo.Name)
            {
            }
            column(Add_Comp; CompanyInfo.Address)
            {
            }
            column(Add2_Comp; CompanyInfo."Address 2")
            {
            }
            column(City_Comp; CompanyInfo.City)
            {
            }
            column(Phone_Comp; CompanyInfo."Phone No.")
            {
            }
            column(Fax_Comp; CompanyInfo."Fax No.")
            {
            }
            column(Picture_Comp; CompanyInfo.Picture)
            {
            }
            column(Loc_Cpmp; CompanyInfo."Location Code")
            {
            }
            column(Postcode_Comp; CompanyInfo."Post Code")
            {
            }
            column(Country_Comp; CompanyInfo.County)
            {
            }
            column(Emai_Comp; CompanyInfo."E-Mail")
            {
            }
            column(Home_Comp; CompanyInfo."Home Page")
            {
            }
            column(CoutryCode_Comp; CompanyInfo."Country/Region Code")
            {
            }
            column(EstimationNo_EstimateHeader; "Product Design Header"."Product Design No.")
            {
            }
            column(EstimationDate_EstimateHeader; "Product Design Header"."Product Design Date")
            {
            }
            column(Name_EstimateHeader; "Product Design Header".Name)
            {
            }
            column(QuantitytoJobOrder_EstimateHeader; "Product Design Header"."Quantity to Job Order")
            {
            }
            column(MODEL_DESC; MODEL_DESC)
            {
            }
            column(SIZEOFBOX; SIZEOFBOX)
            {
            }
            column(GRAMMAGE; Grammage)
            {
            }
            column(WTOFBOX; WTOFBOX)
            {
            }
            column(NOOFPLY; NOOFPLY)
            {
            }
            column(NOOFCOL; NOOFCOL)
            {
            }
            column(TOP; TOP)
            {
            }
            column(FLUTE; FLUTE)
            {
            }
            column(BOARDSIZE; BOARDSIZE)
            {
            }
            column(MAINQTY; MAINQTY)
            {
            }
            column(OtherCharges_EstimateHeader; "Product Design Header"."Other Charges")
            {
            }
            column(MarginAmount_EstimateHeader; "Product Design Header"."Margin Amount")
            {
            }
            column(AmountPerUnit_EstimateHeader; "Product Design Header"."Amount Per Unit")
            {
            }
            column(TotalAmount_EstimateHeader; "Product Design Header"."Total Amount")
            {
            }
            dataitem("Product Design Line"; "Product Design Line")
            {
                DataItemLink = "Product Design No." = FIELD ("Product Design No.");
                DataItemTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.", "Line No.") ORDER(Ascending);
                column(SubCompNo_EstimateLine; "Product Design Line"."Sub Comp No.")
                {
                }
                column(SLNO1; SLNO1)
                {
                }
                column(TOTALAMT; TOTALAMT)
                {
                }
                column(LineNo_EstimateLine; "Product Design Line"."Line No.")
                {
                }
                column(EstimateType_EstimateLine; "Product Design Line"."Product Design Type")
                {
                }
                column(Type_EstimateLine; "Product Design Line".Type)
                {
                }
                column(EstimationNo_EstimateLine; "Product Design Line"."Product Design No.")
                {
                }
                column(Description_EstimateLine; "Product Design Line".Description)
                {
                }
                column(Quantity_EstimateLine; "Product Design Line".Quantity)
                {
                }
                column(UnitOfMeasure_EstimateLine; "Product Design Line"."Unit Of Measure")
                {
                }
                column(UnitCost_EstimateLine; "Product Design Line"."Unit Cost")
                {
                }
                column(LineAmount_EstimateLine; "Product Design Line"."Line Amount")
                {
                }
                column(WorkCenterCategory_EstimateLine; "Product Design Line"."Work Center Category")
                {
                }
                column(MATERIALAMT; MATERIALAMT)
                {
                }
                column(ORIGINATEDAMT; ORIGINATEDAMT)
                {
                }
                column(CORRUGTAEDAMT; CORRUGTAEDAMT)
                {
                }
                column(PRINTINGAMT; PRINTINGAMT)
                {
                }
                column(FINISHINGAMT; FINISHINGAMT)
                {
                }
                column(SUBJOBDESC; SUBJOBDESC)
                {
                }
                column(SUBJOBQTY; SUBJOBQTY)
                {
                }
                column(SUBJOB_BOARD; SUBJOB_BOARD)
                {
                }
                column(SUBJOB_GRAMMAGE; SUBJOB_GRAMMAGE)
                {
                }
                column(MATERIALAMT1; MATERIALAMT1)
                {
                }
                column(SubMATERIALAMT; SubMATERIALAMT)
                {
                }
                column(SubCORRUGTAEDAMT; SubCORRUGTAEDAMT)
                {
                }
                column(SubORIGINATEDAMT; SubORIGINATEDAMT)
                {
                }
                column(SubPRINTINGAMT; SubPRINTINGAMT)
                {
                }
                column(SubFINISHINGAMT; SubFINISHINGAMT)
                {
                }
                column(SUBJOBQTY1; SUBJOBQTY1)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    EST_HEADER.Reset;
                    EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Product Design No.");
                    EST_HEADER.SetRange(EST_HEADER."Sub Comp No.", "Sub Comp No.");
                    EST_HEADER.SetFilter(EST_HEADER."Product Design Type", 'Sub');
                    if EST_HEADER.FindFirst then begin
                        repeat
                            SUBJOBDESC := EST_HEADER."Item Description";
                            SUBJOBQTY := EST_HEADER.Quantity;
                            SUBJOB_BOARD := EST_HEADER."Board Size";
                            SUBJOB_GRAMMAGE := EST_HEADER.Grammage;
                        until EST_HEADER.Next = 0;
                    end;

                    SUBJOBQTY1 := 0;
                    EST_HEADER.Reset;
                    EST_HEADER.SetFilter(EST_HEADER."Product Design Type", 'Sub');
                    EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Product Design No.");
                    if EST_HEADER.FindFirst then begin
                        repeat
                            SUBJOBQTY1 += EST_HEADER.Quantity;
                            //MESSAGE(FORMAT(SUBJOBQTY1));
                        until EST_HEADER.Next = 0;
                    end;






                    ESTIMATE_LINE.Reset;
                    ESTIMATE_LINE.SetRange(ESTIMATE_LINE."Product Design No.", "Product Design No.");
                    ESTIMATE_LINE.SetFilter(ESTIMATE_LINE."Product Design Type", 'Main |Sub');
                    ESTIMATE_LINE.SetFilter(ESTIMATE_LINE."Work Center Category", 'Materials');
                    if ESTIMATE_LINE.FindFirst then begin
                        repeat
                            TOTALAMT := TOTALAMT + ESTIMATE_LINE."Line Amount";

                        until ESTIMATE_LINE.Next = 0;
                    end;

                    //For Main
                    MATERIALAMT := 0;
                    ORIGINATEDAMT := 0;
                    CORRUGTAEDAMT := 0;
                    PRINTINGAMT := 0;
                    FINISHINGAMT := 0;
                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Main');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Materials');
                    if EST_LINE.FindFirst then begin
                        repeat
                            MATERIALAMT := MATERIALAMT + EST_LINE."Line Amount";

                            //MESSAGE(FORMAT(MATERIALAMT));
                        until EST_LINE.Next = 0;
                        MATERIALAMT1 := MATERIALAMT1 + MATERIALAMT;
                    end;

                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Main');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Origination Cost');
                    if EST_LINE.FindFirst
                     then begin
                        repeat
                            ORIGINATEDAMT := ORIGINATEDAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;


                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Main');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Corrugation');
                    if EST_LINE.FindFirst then begin
                        repeat
                            CORRUGTAEDAMT := CORRUGTAEDAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;


                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Main');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Printing Guiding');
                    if EST_LINE.FindFirst then begin
                        repeat
                            PRINTINGAMT := PRINTINGAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;



                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Main');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Finishing Packing');
                    if EST_LINE.FindFirst then begin
                        repeat
                            FINISHINGAMT := FINISHINGAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;


                    //For Sub

                    SubMATERIALAMT := 0;
                    SubCORRUGTAEDAMT := 0;
                    SubORIGINATEDAMT := 0;
                    SubPRINTINGAMT := 0;
                    SubFINISHINGAMT := 0;
                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Sub');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Materials');
                    if EST_LINE.FindFirst then begin
                        repeat
                            SubMATERIALAMT := SubMATERIALAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;


                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Sub');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Origination Cost');
                    if EST_LINE.FindFirst
                     then begin
                        repeat
                            SubORIGINATEDAMT := SubORIGINATEDAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;


                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Sub');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Corrugation');
                    if EST_LINE.FindFirst then begin
                        repeat
                            SubCORRUGTAEDAMT := SubCORRUGTAEDAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;


                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Sub');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Printing Guiding');
                    if EST_LINE.FindFirst then begin
                        repeat
                            SubPRINTINGAMT := SubPRINTINGAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;



                    EST_LINE.Reset;
                    EST_LINE.SetRange(EST_LINE."Product Design No.", "Product Design No.");
                    EST_LINE.SetFilter(EST_LINE."Product Design Type", 'Sub');
                    EST_LINE.SetFilter(EST_LINE."Work Center Category", 'Finishing Packing');
                    if EST_LINE.FindFirst then begin
                        repeat
                            SubFINISHINGAMT := SubFINISHINGAMT + EST_LINE."Line Amount";
                        until EST_LINE.Next = 0;
                    end;



                    if "Product Design Line"."Work Center Category" = "Product Design Line"."Work Center Category"::Materials then begin
                        SLNO1 := 1;
                    end;

                    if "Product Design Line"."Work Center Category" = "Product Design Line"."Work Center Category"::"Origination Cost" then begin
                        SLNO1 := 2;
                    end;

                    if "Product Design Line"."Work Center Category" = "Product Design Line"."Work Center Category"::Corrugation then begin
                        SLNO1 := 3;
                    end;

                    if "Product Design Line"."Work Center Category" = "Product Design Line"."Work Center Category"::"Printing Guiding" then begin
                        SLNO1 := 4;
                    end;

                    if "Product Design Line"."Work Center Category" = "Product Design Line"."Work Center Category"::"Finishing Packing" then begin
                        SLNO1 := 5;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);

                EST_HEADER.Reset;
                EST_HEADER.SetFilter(EST_HEADER."Product Design Type", 'Main');
                EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Product Design No.");
                if EST_HEADER.FindFirst then begin
                    MODEL_DESC := EST_HEADER."Model Description";
                    SIZEOFBOX := EST_HEADER."Box Size";
                    Grammage := EST_HEADER.Grammage;
                    WTOFBOX := EST_HEADER."Per Box Weight (Gms)";
                    NOOFPLY := EST_HEADER."No. of Ply";
                    NOOFCOL := EST_HEADER."No. of Colour";
                    TOP := EST_HEADER."Top Colour";
                    FLUTE := EST_HEADER."Flute Type";
                    BOARDSIZE := EST_HEADER."Board Size";
                    MAINQTY := EST_HEADER.Quantity;
                end;





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
        Language: Record Language;
        Location: Record Location;
        CompanyInfo: Record "Company Information";
        SLNo: Integer;
        ProdBOMHDR: Record "Production BOM Header";
        Amount: Decimal;
        ESTIMATE_LINE: Record "Product Design Line";
        TOTALAMT: Decimal;
        CUST: Record Customer;
        CUST_NAME: Text[100];
        EST_HEADER: Record "Product Design Header";
        MODEL_DESC: Text[250];
        SIZEOFBOX: Code[50];
        GRAMMAGE: Code[20];
        WTOFBOX: Decimal;
        NOOFPLY: Decimal;
        NOOFCOL: Integer;
        TOP: Code[10];
        FLUTE: Code[10];
        BOARDSIZE: Text[100];
        EST_LINE: Record "Product Design Line";
        MATERIALAMT: Decimal;
        CORRUGTAEDAMT: Decimal;
        ORIGINATEDAMT: Decimal;
        PRINTINGAMT: Decimal;
        FINISHINGAMT: Decimal;
        MAINQTY: Decimal;
        SUBJOBDESC: Text[250];
        SUBJOBQTY: Decimal;
        SUBJOBQTY1: Decimal;
        SUBJOB_BOARD: Text[100];
        SUBJOB_GRAMMAGE: Decimal;
        SLNO1: Integer;
        MATERIALAMT1: Decimal;
        SubMATERIALAMT: Decimal;
        SubCORRUGTAEDAMT: Decimal;
        SubORIGINATEDAMT: Decimal;
        SubPRINTINGAMT: Decimal;
        SubFINISHINGAMT: Decimal;
}

