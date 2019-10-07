report 50081 "SUB JOBCARD CORRUGATION(Finis)"
{
    // version Production/Sadaf/Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/SUB JOBCARD CORRUGATION(Finis).rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING (Status, "Prod. Order No.", "Line No.") ORDER(Ascending) WHERE ("Product Design Type" = FILTER (Sub));
            RequestFilterFields = "Prod. Order No.", "Line No.";
            column(EstimateCode_ProdOrderLine; "Prod. Order Line"."Estimate Code")
            {
            }
            column(ProdOrderNo_ProdOrderLine; "Prod. Order Line"."Prod. Order No.")
            {
            }
            column(Description_ProdOrderLine; "Prod. Order Line".Description)
            {
            }
            column(Quantity_ProdOrderLine; "Prod. Order Line".Quantity)
            {
            }
            column(ODID; ODID)
            {
            }
            column(Topcolor; Topcolor)
            {
            }
            column(LinearQty; LinearLengthQty * "Prod. Order Line".Quantity)
            {
            }
            column(SPECIALCORRUGATION; SPECIALCORRUGATION)
            {
            }
            column(FINISHED_QTY; FINISHED_QTY)
            {
            }
            column(SCRAP_QTY; SCRAP_QTY)
            {
            }
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = FIELD ("Prod. Order No."), "Estimate Code" = FIELD ("Estimate Code");
                DataItemTableView = SORTING (Status, "No.") WHERE (Status = CONST (Finished));
                RequestFilterFields = "No.";
                column(EXTNO; EXTNO)
                {
                }
                column(SubJobNo; SubJobNo)
                {
                }
                column(CUSTNO; CUSTNO)
                {
                }
                column(CUSTNAME; CUSTNAME)
                {
                }
                column(TotalNetWeight; TotalNetWeight)
                {
                }
                column(BoxUnitWeight; BoxUnitWeight)
                {
                }
                column(CUSTADD; CUSTADD + ', ' + CUSTADD1)
                {
                }
                column(CUSTADD1; CUSTADD1)
                {
                }
                column(CUSTCITY; CUSTCITY)
                {
                }
                column(EXPECTEDDELDATE; EXPECTEDDELDATE)
                {
                }
                column(SHIP_TO_POSTCODE; SH."Ship-to Post Code")
                {
                }
                column(ORDERDATE; Format(ORDERDATE))
                {
                }
                column(DELIVERY_PLACE; AREA_CODE.Text)
                {
                }
                column(SALESPERSONNAME; SALESPERSONNAME)
                {
                }
                column(CUSTCONTACTNO; CUSTCONTACTNO)
                {
                }
                column(BoxSize1; BoxSize1)
                {
                }
                column(JobModified; "Production Order".Modified)
                {
                }
                column(CreationDate_ProductionOrder; "Production Order"."Creation Date")
                {
                }
                column(Boardupint; Format(Boardupint))
                {
                }
                column(Repeatjob; RepeatJob + Modifiedjob)
                {
                }
                column(FGDescription; "Production Order".Description)
                {
                }
                column(Modifiedjob; Modifiedjob)
                {
                }
                column(RepeatJobNo; RepeatJobNo)
                {
                }
                column(FG_GSM; FG_GSM)
                {
                }
                column(PlateItem; PlateItem)
                {
                }
                column(PaperDeckleSize; PaperDeckleSize)
                {
                }
                column(DieNumber; DieNumber)
                {
                }
                column(NOOFPLY; NOOFPLY)
                {
                }
                column(TotalTrim; TotalTrim)
                {
                }
                column(BOARD_SIZE; BOARD_SIZE)
                {
                }
                column(BOARD_UPS; BOARD_UPS)
                {
                }
                column(DeckleUtilize; BoardWidth * BOARD_UPS)
                {
                }
                column(FLUTE_TYPE; FLUTE_TYPE)
                {
                }
                column(BoardLength; BoardLength)
                {
                }
                column(BoardWidth; BoardWidth)
                {
                }
                column(ROLL_WIDTH; ROLL_WIDTH)
                {
                }
                column(NOOFCOLORS; NOOFCOLORS)
                {
                }
                column(Score1; Format(Score1) + '  +  ' + Format(Score2) + '  +  ' + Format(Score3))
                {
                }
                column(Score2; Score2)
                {
                }
                column(Score3; Score3)
                {
                }
                column(Score4; Score4)
                {
                }
                column(Score5; Score5)
                {
                }
                column(Scoretyp; Scoretyp)
                {
                    OptionMembers = " ","1. Male to Female(3 Point)","2. Point to Flat","3. Point to Point";
                }
                column(DIE_NOS; DIE_NOS)
                {
                }
                column(NOOFDIE_UPS; NOOFDIE_UPS)
                {
                }
                column(ARTXT1; ARTXT1)
                {
                }
                column(PROFTXT1; PROFTXT1)
                {
                }
                column(CLNTTXT1; CLNTTXT1)
                {
                }
                column(PRNTTXT1; PRNTTXT1)
                {
                }
                column(STITXT1; STITXT1)
                {
                }
                column(GLUTXT1; GLUTXT1)
                {
                }
                column(DIETXT1; DIETXT1)
                {
                }
                column(LAMTXT1; LAMTXT1)
                {
                }
                column(BOX_SIZE; BoxSizeLWH)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SH.Reset;
                    SH.SetRange(SH."No.", "Sales Order No.");
                    if SH.FindFirst then begin
                        EXTNO := SH."External Document No.";
                        CUSTNO := SH."Sell-to Customer No.";
                        CUSTNAME := SH."Sell-to Customer Name";
                        CUSTADD := SH."Sell-to Address";
                        CUSTADD1 := SH."Sell-to Address 2";
                        CUSTCITY := SH."Sell-to City";
                        SHIP_TO_POSTCODE := SH."Ship-to Post Code";
                        //EXPECTEDDELDATE := SH."Requested Delivery Date";
                        ORDERDATE := SH."Order Date";
                        CUST.Reset;
                        CUST.SetRange(CUST."No.", CUSTNO);
                        if CUST.FindFirst then begin
                            CUSTCONTACTNO := CUST."Phone No."
                        end;

                        SALESCODE := SH."Salesperson Code";
                        "S/PCONTACT".Reset;
                        "S/PCONTACT".SetRange("S/PCONTACT".Code, SALESCODE);
                        if "S/PCONTACT".FindFirst then begin
                            SALESPERSONNAME := "S/PCONTACT".Name;
                        end else begin
                            SALESPERSONNAME := '';
                        end;
                    end;

                    SL.Reset;
                    SL.SetRange(SL."Prod. Order No.", "No.");
                    SL.SetRange(SL."No.", "Production Order"."Source No.");
                    if SL.FindFirst then begin
                        EXPECTEDDELDATE := SL."Requested Delivery Date";
                    end else begin
                        EXPECTEDDELDATE := 0D;
                    end;


                    /*ITEMATTRIBUATE_ENTRY.RESET;
                    ITEMATTRIBUATE_ENTRY.SETRANGE(ITEMATTRIBUATE_ENTRY."Item No.","Source No.");
                    ITEMATTRIBUATE_ENTRY.SETRANGE(ITEMATTRIBUATE_ENTRY."Item Category Code",'FG');
                    ITEMATTRIBUATE_ENTRY.SETFILTER(ITEMATTRIBUATE_ENTRY."Item Attribute Code",'LENGTH');
                    IF ITEMATTRIBUATE_ENTRY.FINDFIRST THEN BEGIN
                      SIZE_LENGTH := ITEMATTRIBUATE_ENTRY."Item Attribute Value";
                    END ELSE BEGIN
                      SIZE_LENGTH := '';
                    END;
                    
                    ITEMATTRIBUATE_ENTRY.RESET;
                    ITEMATTRIBUATE_ENTRY.SETRANGE(ITEMATTRIBUATE_ENTRY."Item No.","Source No.");
                    ITEMATTRIBUATE_ENTRY.SETRANGE(ITEMATTRIBUATE_ENTRY."Item Category Code",'FG');
                    ITEMATTRIBUATE_ENTRY.SETFILTER(ITEMATTRIBUATE_ENTRY."Item Attribute Code",'WIDTH');
                    IF ITEMATTRIBUATE_ENTRY.FINDFIRST THEN BEGIN
                      SIZE_WIDTH := ITEMATTRIBUATE_ENTRY."Item Attribute Value";
                    END ELSE BEGIN
                      SIZE_WIDTH := '';
                    END;
                    
                    ITEMATTRIBUATE_ENTRY.RESET;
                    ITEMATTRIBUATE_ENTRY.SETRANGE(ITEMATTRIBUATE_ENTRY."Item No.","Source No.");
                    ITEMATTRIBUATE_ENTRY.SETRANGE(ITEMATTRIBUATE_ENTRY."Item Category Code",'FG');
                    ITEMATTRIBUATE_ENTRY.SETFILTER(ITEMATTRIBUATE_ENTRY."Item Attribute Code",'HEIGHT');
                    IF ITEMATTRIBUATE_ENTRY.FINDFIRST THEN BEGIN
                      SIZE_HEIGHT := ITEMATTRIBUATE_ENTRY."Item Attribute Value";
                    END ELSE BEGIN
                      SIZE_HEIGHT := '';
                    END;*/
                    //BoxSize1 := SIZE_LENGTH+' '+'X'+' '+SIZE_WIDTH+' '+'X'+' '+SIZE_HEIGHT;


                    Item.Reset;
                    Item.SetRange(Item."No.", "Production Order"."Source No.");
                    Item.SetFilter(Item."Inventory Posting Group", 'FG');
                    if Item.FindFirst then begin
                        FG_GSM := Item."FG GSM";
                    end;


                    TotalNetWeight := 0;
                    BoxUnitWeight := 0;
                    EST_HEADER.Reset;
                    EST_HEADER.SetFilter(EST_HEADER."Product Design Type", 'sub');
                    EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Estimate Code");
                    EST_HEADER.SetRange(EST_HEADER."Sub Comp No.", "Prod. Order Line"."Sub Comp No.");
                    if EST_HEADER.FindFirst then begin
                        BoxUnitWeight := ((EST_HEADER."Board Length (mm)- L" * EST_HEADER."Board Width (mm)- W" * EST_HEADER.Grammage) / 1000000000);
                        TotalNetWeight := BoxUnitWeight * EST_HEADER.Quantity;
                        NOOFPLY := EST_HEADER."No. of Ply";
                        BOARD_SIZE := EST_HEADER."Board Size";
                        BOARD_UPS := EST_HEADER."Board Ups";
                        FLUTE_TYPE := EST_HEADER."Flute Type";
                        ROLL_WIDTH := EST_HEADER."Roll Width (mm)";
                        NOOFCOLORS := EST_HEADER."No. of Colour";
                        DIE_NOS := EST_HEADER."Die Number";
                        NOOFDIE_UPS := EST_HEADER."No. of Die Cut Ups";
                        ARTXT := EST_HEADER."Artwork Available";
                        PROFTXT := EST_HEADER."Proof Required";
                        CLNTTXT := EST_HEADER."Client Sample";
                        PRNTTXT := EST_HEADER.Printing;
                        DIETXT := EST_HEADER."Die Punching";
                        STITXT := EST_HEADER.Stitching;
                        BOX_SIZE := EST_HEADER."Box Size";
                        Score1 := Round(EST_HEADER."Scorer 1", 2);
                        Score2 := EST_HEADER."Scorer 2";
                        Score3 := Round(EST_HEADER."Scorer 3", 2);
                        Score4 := EST_HEADER."Scorer 4";
                        Score5 := EST_HEADER."Scorer 5";
                        Scoretyp := EST_HEADER."Scorer Type";
                        Topcolor := EST_HEADER."Top Colour";
                        estimateQuantity := EST_HEADER.Quantity;
                        BoardLength := EST_HEADER."Board Length (mm)- L";
                        BoardWidth := EST_HEADER."Board Width (mm)- W";
                        BoxLength := EST_HEADER."Box Length (mm)- L (OD)";
                        BoxWidth := EST_HEADER."Box Width (mm)- W (OD)";
                        BoxHeight := EST_HEADER."Box Height (mm) - D (OD)";
                        TotalTrim := EST_HEADER."Trim Size (mm)";
                        PaperDeckleSize := EST_HEADER."Paper Deckle Size (mm)";

                        PlateItem := EST_HEADER."Plate Item Client";
                        DieNumber := EST_HEADER."Die Number";

                        // LinearLengthQty:=EST_HEADER."Linear Length Qty Per";
                        if BOARD_UPS <> 0 then
                            Boardupint := Round(estimateQuantity / BOARD_UPS, 1);
                        //ROUND(CheckLedgEntry.Amount,1,'<');
                    end;
                    BoxSizeLWH := Format(BoxLength) + ' ' + 'X' + ' ' + Format(BoxWidth) + ' ' + 'X' + ' ' + Format(BoxHeight);
                    //BoxLength+' X '+BoxWidth+' X '+BoxHeight;
                    //MESSAGE(FORMAT(Boardupint));
                    if ARTXT = true then begin
                        ARTXT1 := 'YES'
                    end else begin
                        ARTXT1 := 'NO'
                    end;

                    if PROFTXT = true then begin
                        PROFTXT1 := 'YES'
                    end else begin
                        PROFTXT1 := 'NO'
                    end;

                    if CLNTTXT = true then begin
                        CLNTTXT1 := 'YES'
                    end else begin
                        CLNTTXT1 := 'NO'
                    end;

                    if PRNTTXT = true then begin
                        PRNTTXT1 := 'YES'
                    end else begin
                        PRNTTXT1 := 'NO'
                    end;

                    if STITXT = true then begin
                        STITXT1 := 'YES'
                    end else begin
                        STITXT1 := 'NO'
                    end;

                    if DIETXT = true then begin
                        DIETXT1 := 'YES'
                    end else begin
                        DIETXT1 := 'NO'
                    end;

                    if LAMTXT = true then begin
                        LAMTXT1 := 'YES'
                    end else begin
                        LAMTXT1 := 'NO'
                    end;

                    //Repeat Job

                    if "Repeat Job" = true and Modified = false then begin
                        RepeatJob := 'REPEAT';
                        RepeatJobNo := "Production Order"."Prev. Job No.";
                    end else begin
                        RepeatJob := 'NEW';
                        RepeatJobNo := '';
                        //MESSAGE( RepeatJob);
                    end;
                    if Modified = true then begin
                        Modifiedjob := 'MODIFIED';
                        RepeatJob := '';
                    end else begin
                        Modifiedjob := '';
                    end;


                    ProdCompLine.Reset;
                    ProdCompLine.SetRange(ProdCompLine."Prod. Order No.", "No.");
                    ProdCompLine.SetRange(ProdCompLine."Product Design Type", ProdCompLine."Product Design Type"::Sub);
                    if ProdCompLine.FindFirst then

                        //IF "Estimate Type"="Estimate Type"::Sub THEN
                        SubJobNo := ProdCompLine."Sub Comp No.";
                    // MESSAGE(SubJobNo);

                end;
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = "Prod. Order No." = FIELD ("Prod. Order No."), "Prod. Order Line No." = FIELD ("Line No."), "Product Design Type" = FIELD ("Product Design Type"), "Product Design No." = FIELD ("Product Design No.");
                DataItemTableView = SORTING (Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") ORDER(Ascending) WHERE ("Schedule Component" = CONST (false));
                column(EstimateType_ProdOrderComponent; "Prod. Order Component"."Product Design Type")
                {
                }
                column(PaperPosition_ProdOrderComponent; "Prod. Order Component"."Paper Position")
                {
                }
                column(ItemCategoryCode_ProdOrderComponent; "Prod. Order Component"."Item Category Code")
                {
                }
                column(ItemNo_ProdOrderComponent; "Prod. Order Component"."Item No.")
                {
                }
                column(Description_ProdOrderComponent; "Prod. Order Component".Description)
                {
                }
                column(Quantity_ProdOrderComponent; "Prod. Order Component".Quantity)
                {
                }
                column(UnitofMeasureCode_ProdOrderComponent; "Prod. Order Component"."Unit of Measure Code")
                {
                }
                column(Quantityper_ProdOrderComponent; "Prod. Order Component"."Expected Quantity")
                {
                }
                column(ITME_DECSIZE; ITME_DECSIZE)
                {
                }
                column(CustomerGSM; CustomerGSM)
                {
                }
                column(Takeupfactor; "Prod. Order Component"."Take Up")
                {
                }
                column(ITEM_GSM1; ITEM_GSM1 * "Prod. Order Component"."Take Up")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ITEM_ATTRIBUTEENTRY.Reset;
                    ITEM_ATTRIBUTEENTRY.SetRange(ITEM_ATTRIBUTEENTRY."Item No.", "Item No.");
                    ITEMATTRIBUATE_ENTRY.SetRange(ITEMATTRIBUATE_ENTRY."Item Category Code", 'PAPER');
                    ITEM_ATTRIBUTEENTRY.SetRange(ITEM_ATTRIBUTEENTRY."Item Attribute Code", 'DECKLESIZE');
                    if ITEM_ATTRIBUTEENTRY.FindFirst then begin
                        ITME_DECSIZE := ITEM_ATTRIBUTEENTRY."Item Attribute Value";
                    end;


                    /*
                    ITEM_ATTRIBUTEENTRY.RESET;
                    ITEM_GSM1 :=0;
                    ITEM_ATTRIBUTEENTRY.SETRANGE(ITEM_ATTRIBUTEENTRY."Item No.","Item No.");
                    ITEMATTRIBUATE_ENTRY.SETRANGE(ITEMATTRIBUATE_ENTRY."Item Category Code",'PAPER');
                    ITEM_ATTRIBUTEENTRY.SETRANGE(ITEM_ATTRIBUTEENTRY."Item Attribute Code",'PAPERGSM');
                    IF ITEM_ATTRIBUTEENTRY.FINDFIRST THEN BEGIN
                      ITEMATTRIBUATE_ENTRY.CALCFIELDS("Item Attribute Value NUm");
                      ITEM_GSM1 :=ITEMATTRIBUATE_ENTRY."Item Attribute Value NUm";
                      //MESSAGE(FORMAT(ITEM_GSM1));
                    END;
                    
                    */
                    Item.Reset;
                    Item.SetRange(Item."No.", "Item No.");
                    Item.SetFilter(Item."Inventory Posting Group", 'PAPER');
                    if Item.FindFirst then begin
                        ITEM_GSM1 := Item."Paper GSM";
                        //MESSAGE(FORMAT(ITEM_GSM1));
                    end;




                    EstimateLine.Reset;
                    EstimateLine.SetRange(EstimateLine."Product Design Type", EstimateLine."Product Design Type"::Sub);
                    EstimateLine.SetRange(EstimateLine."Product Design No.", "Product Design No.");
                    EstimateLine.SetRange(EstimateLine."Paper Position", "Paper Position");
                    if EstimateLine.FindFirst then begin
                        repeat
                            CustomerGSM := EstimateLine."Customer GSM";
                            //MESSAGE(EstimateLine."No.","Item No.");
                        until EstimateLine.Next = 0;
                    end;

                end;
            }
            dataitem("Product Design Special Descrip"; "Product Design Special Descrip")
            {
                DataItemLink = "No." = FIELD ("Product Design No.");
                DataItemTableView = SORTING ("No.", "Line No.") ORDER(Ascending) WHERE (Category = CONST ("Special Instruction Corrugation"));
                column(Category_EstimateSpecialDescription; "Product Design Special Descrip".Category)
                {
                }
                column(Comment_EstimateSpecialDescription; "Product Design Special Descrip".Comment)
                {
                }
                column(categary; "Product Design Special Descrip".Category)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                AttributeEntry.Reset;
                AttributeEntry.SetRange(AttributeEntry."Item No.", "Item No.");
                if AttributeEntry.FindFirst then begin
                    repeat
                        if AttributeEntry."Item Attribute Code" = 'OD-ID' then
                            ODID := AttributeEntry."Item Attribute Value";
                        if AttributeEntry."Item Attribute Code" = 'COLOUR' then
                            Topcolor1 := AttributeEntry."Item Attribute Value";
                    until AttributeEntry.Next = 0;
                end;
                LinearLengthQty := 0;
                EST_HEADER.Reset;
                EST_HEADER.SetFilter(EST_HEADER."Product Design Type", 'Sub');
                EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Product Design No.");
                if EST_HEADER.FindFirst then begin
                    LinearLengthQty := EST_HEADER."Linear Length Qty Per";
                end;


                ProdOrderLine.Reset;
                ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Line No.");
                ProdOrderLine.SetRange(ProdOrderLine."Item No.", "Item No.");
                if ProdOrderLine.FindFirst then begin
                    FINISHED_QTY := ProdOrderLine."Finished Quantity";
                end;

                CapacityLedgerEntry.Reset;
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Order No.", "Prod. Order No.");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Order Line No.", "Line No.");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Item No.", "Item No.");
                if CapacityLedgerEntry.FindFirst then begin
                    SCRAP_QTY := CapacityLedgerEntry."Scrap Quantity";
                end;

                //IF "Prod. Order Line".Quantity<>0 THEN
                //Boardupint:="Prod. Order Line".Quantity/BOARD_UPS;
                //MESSAGE(FORMAT(Boardupint));
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
        PROD_ORDER: Record "Production Order";
        Item: Record Item;
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        CUSTNO: Code[20];
        CUSTNAME: Text[150];
        CUSTADD: Text[150];
        CUSTADD1: Text[150];
        CUSTCITY: Text[150];
        EXPECTEDDELDATE: Date;
        ORDERDATE: Date;
        SALESCODE: Code[10];
        "S/PCONTACT": Record "Salesperson/Purchaser";
        SALESPERSONNAME: Text[100];
        SHIP_TO_POSTCODE: Code[20];
        AREA_NO: Code[10];
        AREA_CODE: Record "Area";
        AREA_DESC: Text[30];
        CUST: Record Customer;
        CUSTCONTACTNO: Code[50];
        EXTNO: Code[50];
        ARTXT: Boolean;
        ARTXT1: Text[10];
        PROFTXT: Boolean;
        PROFTXT1: Text[10];
        CLNTTXT: Boolean;
        CLNTTXT1: Text[10];
        PRNTTXT: Boolean;
        PRNTTXT1: Text[10];
        COLRTXT: Boolean;
        COLRTXT1: Text[10];
        STITXT: Boolean;
        STITXT1: Text[10];
        GLUTXT: Boolean;
        GLUTXT1: Text[10];
        DIETXT: Boolean;
        DIETXT1: Text[10];
        DIENUMTXT: Text[10];
        LAMTXT: Boolean;
        LAMTXT1: Text[10];
        ITEMATTRIBUATE_ENTRY: Record "Item Attribute Entry";
        SIZE_LENGTH: Code[10];
        SIZE_WIDTH: Code[10];
        SIZE_HEIGHT: Code[10];
        BoxSize1: Code[50];
        SIDETXT: Text[10];
        FA: Record "Fixed Asset";
        KDLNO: Integer;
        PRODORDERCOMMNET: Record "Prod. Order Comment Line";
        SPECDESC: Text[250];
        CORRDESC: Text[250];
        ITEM_ATTRIBUTEENTRY: Record "Item Attribute Entry";
        ITME_DECSIZE: Code[10];
        ITEM_GSM1: Decimal;
        EST_HEADER: Record "Product Design Header";
        FG_GSM: Code[10];
        NOOFPLY: Integer;
        BOARD_SIZE: Text[30];
        BOARD_UPS: Integer;
        FLUTE_TYPE: Text[20];
        ROLL_WIDTH: Decimal;
        NOOFCOLORS: Integer;
        DIE_NOS: Code[20];
        NOOFDIE_UPS: Integer;
        SPECIALINST: Record "Product Design Special Descrip";
        SPECIALCORRUGATION: Text[250];
        BOX_SIZE: Text[50];
        AttributeEntry: Record "Item Attribute Entry";
        ODID: Code[10];
        Topcolor: Code[60];
        Score1: Decimal;
        Score2: Decimal;
        Score3: Decimal;
        Score4: Decimal;
        Scoretyp: Option;
        Score5: Decimal;
        LinearLengthQty: Decimal;
        Topcolor1: Code[30];
        RepeatJob: Text[10];
        Modifiedjob: Text[20];
        RepeatJobNo: Code[20];
        Boardupint: Decimal;
        estimateQuantity: Decimal;
        BoardLength: Decimal;
        BoardWidth: Decimal;
        BoxLength: Decimal;
        BoxWidth: Decimal;
        BoxHeight: Decimal;
        BoxSizeLWH: Text[60];
        PlateItem: Code[20];
        DieNumber: Code[20];
        TotalTrim: Integer;
        PaperDeckleSize: Decimal;
        EstimateLine: Record "Product Design Line";
        CustomerGSM: Decimal;
        ProdCompLine: Record "Prod. Order Line";
        SubJobNo: Code[20];
        TotalNetWeight: Decimal;
        BoxUnitWeight: Decimal;
        ProdOrderLine: Record "Prod. Order Line";
        FINISHED_QTY: Decimal;
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        SCRAP_QTY: Decimal;
}

