report 50071 "Product Dev. Details"
{
    // version Sales/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Product Dev. Details.rdl';
    Caption = 'Product Development Details';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Product Design Header"; "Product Design Header")
        {
            DataItemTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.") ORDER(Ascending);
            RequestFilterFields = "Product Design No.";
            column(REP_CAP; REP_CAP)
            {
            }
            column(RUN_DATE; WorkDate)
            {
            }
            column(COMINFO_NAME; CompanyInformation.Name)
            {
            }
            column(COMINFO_PIC; CompanyInformation.Picture)
            {
            }
            column(ProductDesignType_ProductDesignHeader; "Product Design Header"."Product Design Type")
            {
            }
            column(ProductDesignDate_ProductDesignHeader; "Product Design Header"."Product Design Date")
            {
            }
            column(ProductDesignNo_ProductDesignHeader; "Product Design Header"."Product Design No.")
            {
            }
            column(Customer_ProductDesignHeader; "Product Design Header".Customer)
            {
            }
            column(Name_ProductDesignHeader; "Product Design Header".Name)
            {
            }
            column(DEL_PLACE; DEL_PLACE)
            {
            }
            column(ItemDescription_ProductDesignHeader; "Product Design Header"."Item Description")
            {
            }
            column(ItemUnitofMeasure_ProductDesignHeader; "Product Design Header"."Item Unit of Measure")
            {
            }
            column(FluteType_ProductDesignHeader; "Product Design Header"."Flute Type")
            {
            }
            column(NoofPly_ProductDesignHeader; "Product Design Header"."No. of Ply")
            {
            }
            column(PackingMethod_ProductDesignHeader; "Product Design Header"."Packing Method")
            {
            }
            column(TopColour_ProductDesignHeader; "Product Design Header"."Top Colour")
            {
            }
            column(BottomLinear_ProductDesignHeader; "Product Design Header"."Bottom Linear")
            {
            }
            column(BoxLengthmmLOD_ProductDesignHeader; "Product Design Header"."Box Length (mm)- L (OD)")
            {
            }
            column(BoxWidthmmWOD_ProductDesignHeader; "Product Design Header"."Box Width (mm)- W (OD)")
            {
            }
            column(BoxHeightmmDOD_ProductDesignHeader; "Product Design Header"."Box Height (mm) - D (OD)")
            {
            }
            column(FG_GSM; FG_GSM)
            {
            }
            column(CustomerGSM_ProductDesignHeader; "Product Design Header"."Customer GSM")
            {
            }
            column(FG_FLUTE; FG_FLUTE)
            {
            }
            column(RefSampleAvailable_ProductDesignHeader; "Product Design Header"."Ref. Sample Available")
            {
            }
            column(RefSampleApprovedbyCustom_ProductDesignHeader; "Product Design Header"."Ref. Sample Approved by Custom")
            {
            }
            column(LPO_NO; LPO_NO)
            {
            }
            column(DieNumber_ProductDesignHeader; "Product Design Header"."Die Number")
            {
            }
            column(PrintingColour1_ProductDesignHeader; "Product Design Header"."Printing Colour 1")
            {
            }
            column(PrintingColour2_ProductDesignHeader; "Product Design Header"."Printing Colour 2")
            {
            }
            column(PrintingColour3_ProductDesignHeader; "Product Design Header"."Printing Colour 3")
            {
            }
            column(PrintingColour4_ProductDesignHeader; "Product Design Header"."Printing Colour 4")
            {
            }
            column(PlateItemNo_ProductDesignHeader; "Product Design Header"."Plate Item Client")
            {
            }
            column(PrintingColour5_ProductDesignHeader; "Product Design Header"."Printing Colour 5")
            {
            }
            column(PrintingColour6_ProductDesignHeader; "Product Design Header"."Printing Colour 6")
            {
            }
            column(ScorerType_ProductDesignHeader; "Product Design Header"."Scorer Type")
            {
            }
            column(REF_SAMLE; REF_SAMLE)
            {
            }
            column(REF_APP; REF_APP)
            {
            }
            column(DEEP_CREASING; DEEP_CREASING)
            {
            }
            column(PRINT_LOGO; PRINT_LOGO)
            {
            }
            column(STITCH; STITCH)
            {
            }
            column(ModelNo_ProductDesignHeader; "Product Design Header"."Model No")
            {
            }
            column(ModelDescription_ProductDesignHeader; "Product Design Header"."Model Description")
            {
            }
            column(BoxSize_ProductDesignHeader; "Product Design Header"."Box Size")
            {
            }
            column(RollWidthmm_ProductDesignHeader; "Product Design Header"."Roll Width (mm)")
            {
            }
            column(BoardLengthmmL_ProductDesignHeader; Format("Product Design Header"."Board Length (mm)- L") + 'X' + Format("Product Design Header"."Board Width (mm)- W"))
            {
            }
            column(BoardWidthmmW_ProductDesignHeader; "Product Design Header"."Board Width (mm)- W")
            {
            }
            column(PalletSize_ProductDesignHeader; "Product Design Header"."Pallet Size")
            {
            }
            column(QtyPallet_ProductDesignHeader; "Product Design Header"."Qty / Pallet")
            {
            }
            column(DIE_COST; DIE_COST)
            {
            }
            column(BLOCK_COST; BLOCK_COST)
            {
            }
            column(SHIP_ADD; SHIP_ADD + ',' + SHIP_ADD1)
            {
            }
            column(NoofDieCutUps_ProductDesignHeader; "Product Design Header"."No. of Die Cut Ups")
            {
            }
            column(SHIP_ADD1; SHIP_ADD1)
            {
            }
            column(PAPER_TYPE; PAPER_TYPE)
            {
            }
            column(FLUTE_TYPE; FLUTE_TYPE)
            {
            }
            column(PaperComb_ProductDesignHeader; "Product Design Header"."Paper Comb.")
            {
            }
            column(Remarks_ProductDesignHeader; "Product Design Header".Remarks)
            {
            }
            column(DisptachDetails_ProductDesignHeader; "Product Design Header"."Disptach Details")
            {
            }
            column(PAP_POS; PAP_POS)
            {
            }
            column(Grammage_ProductDesignHeader; "Product Design Header".Grammage)
            {
            }
            dataitem("Product Design Special Descrip"; "Product Design Special Descrip")
            {
                DataItemLink = "No." = FIELD ("Product Design No.");
                DataItemTableView = SORTING ("No.", "Line No.") ORDER(Ascending);
                column(Comment_ProductDesignSpecialDescrip; "Product Design Special Descrip".Comment)
                {
                }
                column(Category_ProductDesignSpecialDescrip; "Product Design Special Descrip".Category)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;
                CompanyInformation.CalcFields(CompanyInformation.Picture);

                Item.Reset;
                Item.SetRange(Item."No.", "Item Code");
                if Item.FindFirst then begin
                    FG_GSM := Item."FG GSM";
                    FG_FLUTE := Item."Flute Type";
                end;

                LPO_NO := '';
                SalesHeader.Reset;
                SalesHeader.SetRange(SalesHeader."No.", "Sales Order No.");
                if SalesHeader.FindFirst then begin
                    LPO_NO := SalesHeader."External Document No.";
                end;


                if "Product Design Header"."Print UCI Logo" = true then begin
                    PRINT_LOGO := 'YES';
                end else begin
                    PRINT_LOGO := 'NO';
                end;

                if "Product Design Header"."Ref. Sample Available" = true then begin
                    REF_SAMLE := 'YES';
                end else begin
                    REF_SAMLE := 'NO';
                end;

                if "Product Design Header"."Ref. Sample Approved by Custom" = true then begin
                    REF_APP := 'YES';
                end else begin
                    REF_APP := 'NO';
                end;

                if "Product Design Header"."Deep Creasing" = true then begin
                    DEEP_CREASING := 'YES'
                end else begin
                    DEEP_CREASING := 'NO'
                end;

                if "Product Design Header"."No. of Die Cut Ups" < 0 then begin
                    if "Product Design Header".Stitching = true then begin
                        STITCH := 'STITCH';
                    end else begin
                        STITCH := 'GLUE';
                    end;
                end else begin
                    if "Product Design Header".Stitching = true then begin
                        STITCH := 'STITCH';
                    end else begin
                        STITCH := '';
                    end;
                end;



                BLOCK_COST := 0;
                ProductDesignSpecialDescrip.Reset;
                ProductDesignSpecialDescrip.SetRange(ProductDesignSpecialDescrip."No.", "Product Design No.");
                ProductDesignSpecialDescrip.SetFilter(ProductDesignSpecialDescrip."Cost Code", 'BLOCK COST');
                if ProductDesignSpecialDescrip.FindFirst then begin
                    BLOCK_COST := ProductDesignSpecialDescrip.Amount
                end;


                DIE_COST := 0;
                ProductDesignSpecialDescrip.Reset;
                ProductDesignSpecialDescrip.SetRange(ProductDesignSpecialDescrip."No.", "Product Design No.");
                ProductDesignSpecialDescrip.SetFilter(ProductDesignSpecialDescrip."Cost Code", 'DIE');
                if ProductDesignSpecialDescrip.FindFirst then begin
                    DIE_COST := ProductDesignSpecialDescrip.Amount
                end;
                PAP_POS := '';

                ProductDesignLine.Reset;
                ProductDesignLine.SetRange(ProductDesignLine."Product Design Type", "Product Design Type");
                ProductDesignLine.SetRange(ProductDesignLine."Product Design No.", "Product Design No.");
                ProductDesignLine.SetRange(ProductDesignLine.Type, ProductDesignLine.Type::Item);
                if ProductDesignLine.FindFirst then begin
                    repeat
                        ProductDesignLine.CalcFields(ProductDesignLine."Paper Type");
                        PAP_POS := PAP_POS + ',' + Format(ProductDesignLine."Paper Position") + ' ' + ProductDesignLine."Paper GSM Filter" + ' ' + Format(ProductDesignLine."Flute Type") + ' ' + ProductDesignLine."Paper Type";
                    until ProductDesignLine.Next = 0;
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
        CompanyInformation: Record "Company Information";
        REP_CAP: Label 'PRODUCT DEVELOPMENT DETAILS';
        Item: Record Item;
        FG_GSM: Code[30];
        FG_FLUTE: Code[20];
        SalesHeader: Record "Sales Header";
        LPO_NO: Code[30];
        DEL_PLACE: Text;
        REF_SAMLE: Text;
        REF_APP: Text;
        DEEP_CREASING: Text;
        PRINT_LOGO: Text;
        STITCH: Text;
        ProductDesignSpecialDescrip: Record "Product Design Special Descrip";
        DIE_COST: Decimal;
        BLOCK_COST: Decimal;
        ProductDesignLine: Record "Product Design Line";
        PAP_POS: Text;
        SHIP_ADD: Text;
        SHIP_ADD1: Text;
        ITEM_NO: Code[30];
        PAPER_GSM: Decimal;
        PAPER_TYPE: Code[30];
        FLUTE_TYPE: Code[30];
        SPL_INST: Text;
}

