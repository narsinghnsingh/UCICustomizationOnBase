report 50060 "Plate Requistion"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Plate Requistion.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING (Status, "Prod. Order No.", "Line No.") ORDER(Ascending);
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
            column(ColorsDetails11; ItemColorDescription[1])
            {
            }
            column(ColorsDetails22; ItemColorDescription[2])
            {
            }
            column(ColorsDetails33; ItemColorDescription[3])
            {
            }
            column(ColorsDetails44; ItemColorDescription[4])
            {
            }
            column(ColorsDetails55; ItemColorDescription[5])
            {
            }
            column(ColorsDetails66; ItemColorDescription[6])
            {
            }
            column(IssuedDate; IssuedDate)
            {
            }
            column(NoOfColor; NoOfColor)
            {
            }
            column(BlockDescription; BlockDescription)
            {
            }
            column(PlateItemEstimate; PlateItemEstimate)
            {
            }
            column(PlateItemEstimateClient; PlateItemEstimateClient)
            {
            }
            column(ColorsDetails1; ColorsDetails[1])
            {
            }
            column(ColorsDetails2; ColorsDetails[2])
            {
            }
            column(ColorsDetails3; ColorsDetails[3])
            {
            }
            column(ColorsDetails4; ColorsDetails[4])
            {
            }
            column(ColorsDetails5; ColorsDetails[5])
            {
            }
            column(ColorsDetails6; ColorsDetails[6])
            {
            }
            column(COLOR1; COLOR1)
            {
            }
            column(COLOR2; COLOR2)
            {
            }
            column(COLOR3; COLOR3)
            {
            }
            column(COLOR4; COLOR4)
            {
            }
            column(COLOR5; COLOR5)
            {
            }
            column(COLOR6; COLOR6)
            {
            }
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = FIELD ("Prod. Order No.");
                DataItemTableView = SORTING (Status, "No.") WHERE (Status = CONST (Released));
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
                column(Repeatjob; RepeatJob)
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
                column(RepeatJob1; RepeatJob + Modifiedjob)
                {
                }
                column(FG_GSM; FG_GSM)
                {
                }
                column(PlateItem; PlateItemEstimate)
                {
                }
                column(PlateItemClient; PlateItemEstimateClient)
                {
                }
                column(PaperDeckleSize; PaperDeckleSize)
                {
                }
                column(DieNumber; DIE_NOS)
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
                dataitem("Product Design Special Descrip"; "Product Design Special Descrip")
                {
                    DataItemLink = "No." = FIELD ("No.");
                    DataItemTableView = SORTING ("No.", "Line No.") ORDER(Ascending) WHERE (Category = CONST ("Special Instruction"));
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
                        ORDERDATE := SH."Order Date";
                        CUST.Reset;
                        CUST.SetRange(CUST."No.", CUSTNO);
                        if CUST.FindFirst then begin
                            CUSTCONTACTNO := CUST."Phone No."
                        end;
                    end;



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


                    // LinearLengthQty:=EST_HEADER."Linear Length Qty Per";
                    if BOARD_UPS <> 0 then begin
                        Boardupint := Round(estimateQuantity / BOARD_UPS, 1);
                        //ROUND(CheckLedgEntry.Amount,1,'<');
                    end;
                    BoxSizeLWH := Format(BoxLength) + ' ' + 'X' + ' ' + Format(BoxWidth) + ' ' + 'X' + ' ' + Format(BoxHeight);
                end;
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
                EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Product Design No.");
                EST_HEADER.SetRange(EST_HEADER."Product Design Type", "Product Design Type");
                if EST_HEADER.FindFirst then begin
                    LinearLengthQty := EST_HEADER."Linear Length Qty Per";
                    PlateItemEstimate := EST_HEADER."Plate Item No.";
                    PlateItemEstimateClient := EST_HEADER."Plate Item Client";

                end;



                TotalNetWeight := 0;
                BoxUnitWeight := 0;
                BlockDescription := '';
                EST_HEADER.Reset;
                EST_HEADER.SetRange(EST_HEADER."Product Design Type", "Product Design Type");
                EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Estimate Code");
                EST_HEADER.SetRange(EST_HEADER."Item Code", "Prod. Order Line"."Item No.");
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
                    PlateItemEstimate := EST_HEADER."Plate Item No.";
                    PlateItemEstimateClient := EST_HEADER."Plate Item Client";
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
                    NoOfColor := EST_HEADER."No. of Colour";
                    Topcolor := EST_HEADER."Top Colour";
                    estimateQuantity := EST_HEADER.Quantity;
                    BoardLength := EST_HEADER."Board Length (mm)- L";
                    BoardWidth := EST_HEADER."Board Width (mm)- W";
                    BoxLength := EST_HEADER."Box Length (mm)- L (OD)";
                    BoxWidth := EST_HEADER."Box Width (mm)- W (OD)";
                    BoxHeight := EST_HEADER."Box Height (mm) - D (OD)";
                    TotalTrim := EST_HEADER."Trim Size (mm)";
                    PaperDeckleSize := EST_HEADER."Paper Deckle Size (mm)";
                end;


                ColorsDetails[1] := EST_HEADER."Printing Colour 1";
                ColorsDetails[2] := EST_HEADER."Printing Colour 2";
                ColorsDetails[3] := EST_HEADER."Printing Colour 3";
                ColorsDetails[4] := EST_HEADER."Printing Colour 4";
                ColorsDetails[5] := EST_HEADER."Printing Colour 5";
                ColorsDetails[6] := EST_HEADER."Printing Colour 6";



                Item.Reset;
                Item.SetRange(Item."No.", EST_HEADER."Printing Colour 1");
                if Item.FindFirst then
                    COLOR1 := Item.Description;
                Item.SetRange(Item."No.", EST_HEADER."Printing Colour 2");
                if Item.FindFirst then
                    COLOR2 := Item.Description;
                Item.SetRange(Item."No.", EST_HEADER."Printing Colour 3");
                if Item.FindFirst then
                    COLOR3 := Item.Description;
                Item.SetRange(Item."No.", EST_HEADER."Printing Colour 4");
                if Item.FindFirst then
                    COLOR4 := Item.Description;
                Item.SetRange(Item."No.", EST_HEADER."Printing Colour 5");
                if Item.FindFirst then
                    COLOR5 := Item.Description;
                Item.SetRange(Item."No.", EST_HEADER."Printing Colour 6");
                if Item.FindFirst then
                    COLOR6 := Item.Description;





                Item.Reset;
                Item.SetRange(Item."No.", "Prod. Order Line"."Item No.");
                if Item.FindFirst then begin
                    FG_GSM := Item."FG GSM";
                    PlateItem := Item."Plate Item No.";
                    DieNumber := Item."Die Number";
                    If Rec_Item.GET(Item."Plate Item No.") then
                        PlateItemClient := Rec_Item."No. 2";
                end;


                /* ItemCard.RESET;
                 ItemCard.SETRANGE(ItemCard."No.",ColorsDetails[1]);
                 IF ItemCard.FINDFIRST THEN
                 ItemColorDescription[1]:=ItemCard.Description;

                 ItemCard.RESET;
                 ItemCard.SETRANGE(ItemCard."No.",ColorsDetails[2]);
                 IF ItemCard.FINDFIRST THEN
                 ItemColorDescription[2]:=ItemCard.Description;

                 ItemCard.RESET;
                 ItemCard.SETRANGE(ItemCard."No.",ColorsDetails[3]);
                 IF ItemCard.FINDFIRST THEN
                 ItemColorDescription[3]:=ItemCard.Description;

                 ItemCard.RESET;
                 ItemCard.SETRANGE(ItemCard."No.",ColorsDetails[4]);
                 IF ItemCard.FINDFIRST THEN
                 ItemColorDescription[4]:=ItemCard.Description;

                 ItemCard.RESET;
                 ItemCard.SETRANGE(ItemCard."No.",ColorsDetails[5]);
                 IF ItemCard.FINDFIRST THEN
                 ItemColorDescription[5]:=ItemCard.Description;

                 ItemCard.RESET;
                 ItemCard.SETRANGE(ItemCard."No.",ColorsDetails[6]);
                 IF ItemCard.FINDFIRST THEN
                 ItemColorDescription[6]:=ItemCard.Description;






                ItemCard.RESET;
                ItemCard.SETRANGE(ItemCard."No.",PlateItemEstimate);
                IF ItemCard.FINDFIRST THEN BEGIN
                BlockDescription:=ItemCard.Description;
                IssuedDate:=ItemCard."Last Date Modified";
               END; */

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
        Rec_Item: Record Item;
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        CUSTNO: Code[20];
        CUSTNAME: Text[150];
        CUSTADD: Text[150];
        CUSTADD1: Text[150];
        CUSTCITY: Text[150];
        EXPECTEDDELDATE: Date;
        ORDERDATE: Date;
        SALESCODE: Code[25];
        "S/PCONTACT": Record "Salesperson/Purchaser";
        SALESPERSONNAME: Text[100];
        SHIP_TO_POSTCODE: Code[20];
        AREA_NO: Code[25];
        AREA_CODE: Record "Area";
        AREA_DESC: Text[30];
        CUST: Record Customer;
        CUSTCONTACTNO: Code[50];
        EXTNO: Code[50];
        ARTXT: Boolean;
        ARTXT1: Text[25];
        PROFTXT: Boolean;
        PROFTXT1: Text[25];
        CLNTTXT: Boolean;
        CLNTTXT1: Text[25];
        PRNTTXT: Boolean;
        PRNTTXT1: Text[25];
        COLRTXT: Boolean;
        COLRTXT1: Text[25];
        STITXT: Boolean;
        STITXT1: Text[25];
        GLUTXT: Boolean;
        GLUTXT1: Text[25];
        DIETXT: Boolean;
        DIETXT1: Text[25];
        DIENUMTXT: Text[25];
        LAMTXT: Boolean;
        LAMTXT1: Text[25];
        ITEMATTRIBUATE_ENTRY: Record "Item Attribute Entry";
        SIZE_LENGTH: Code[25];
        SIZE_WIDTH: Code[25];
        SIZE_HEIGHT: Code[25];
        BoxSize1: Code[50];
        SIDETXT: Text[25];
        FA: Record "Fixed Asset";
        KDLNO: Integer;
        PRODORDERCOMMNET: Record "Prod. Order Comment Line";
        SPECDESC: Text[250];
        CORRDESC: Text[250];
        ITEM_ATTRIBUTEENTRY: Record "Item Attribute Entry";
        ITME_DECSIZE: Code[25];
        ITEM_GSM1: Decimal;
        EST_HEADER: Record "Product Design Header";
        FG_GSM: Code[25];
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
        ODID: Code[25];
        Topcolor: Code[60];
        Score1: Decimal;
        Score2: Decimal;
        Score3: Decimal;
        Score4: Decimal;
        Scoretyp: Option;
        Score5: Decimal;
        LinearLengthQty: Decimal;
        Topcolor1: Code[30];
        RepeatJob: Text[25];
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
        PlateItemClient: Code[20];
        DieNumber: Code[20];
        TotalTrim: Integer;
        PaperDeckleSize: Decimal;
        EstimateLine: Record "Product Design Line";
        CustomerGSM: Decimal;
        ProdCompLine: Record "Prod. Order Line";
        SubJobNo: Code[20];
        TotalNetWeight: Decimal;
        BoxUnitWeight: Decimal;
        PlateItemEstimate: Code[25];

        PlateItemEstimateClient: Code[20];
        ItemCard: Record Item;
        BlockDescription: Text[250];
        ColorsDetails: array[6] of Text[100];
        IssuedDate: Date;
        ItemColorDescription: array[6] of Text[250];
        NoOfColor: Integer;
        COLOR1: Text;
        COLOR2: Text;
        COLOR3: Text;
        COLOR4: Text;
        COLOR5: Text;
        COLOR6: Text;
}

