report 50047 "DIE Requistion"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/DIE Requistion.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING (Status, "Prod. Order No.", "Line No.") ORDER(Ascending);
            RequestFilterFields = "Prod. Order No.", "Line No.";
            column(CUSTNO; CUSTNO)
            {
            }
            column(CUSTNAME; CUSTNAME)
            {
            }
            column(EXTNO; EXTNO)
            {
            }
            column(ORDERDATE; ORDERDATE)
            {
            }
            column(SubJobNo; SubJobNo)
            {
            }
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
            column(RepeatJob; RepeatJob + Modifiedjob)
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
            column(DIE_NOS; DIE_NOS)
            {
            }
            column(NOOFDIE_UPS; NOOFDIE_UPS)
            {
            }
            column(BOX_SIZE; BoxSizeLWH)
            {
            }
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = FIELD ("Prod. Order No.");
                DataItemTableView = SORTING (Status, "No.") WHERE (Status = CONST (Released));
                column(DieDescription; DieDescription)
                {
                }
                column(IssuedDate; IssuedDate)
                {
                }
                column(TotalNetWeight; TotalNetWeight)
                {
                }
                column(BoxUnitWeight; BoxUnitWeight)
                {
                }
                column(EXPECTEDDELDATE; EXPECTEDDELDATE)
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
                column(FGDescription; "Production Order".Description)
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
                    SL.Reset;
                    SL.SetRange(SL."Prod. Order No.", "No.");
                    SL.SetRange(SL."No.", "Source No.");
                    if SL.FindFirst then begin
                        EXPECTEDDELDATE := SL."Requested Delivery Date";
                    end else begin
                        EXPECTEDDELDATE := 0D;
                    end;


                    Item.Reset;
                    Item.SetRange(Item."No.", "Production Order"."Source No.");
                    Item.SetFilter(Item."Inventory Posting Group", 'FG');
                    if Item.FindFirst then begin
                        FG_GSM := Item."FG GSM";
                        PlateItem := Item."Plate Item No.";
                        DieNumber := Item."Die Number";
                    end;



                    ItemCard.Reset;
                    ItemCard.SetRange(ItemCard."No.", EST_HEADER."Item Code");
                    if ItemCard.FindFirst then begin
                        DieDescription := ItemCard.Description;
                        IssuedDate := ItemCard."Last Date Modified";
                        // MESSAGE(DieDescription);
                    end;
                    PlateItemEstimate := EST_HEADER."Plate Item No.";
                    //MESSAGE(DIE_NOS);
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
                    // LinearLengthQty:=EST_HEADER."Linear Length Qty Per";
                    if BOARD_UPS <> 0 then
                        Boardupint := Round(estimateQuantity / BOARD_UPS, 1);
                    //ROUND(CheckLedgEntry.Amount,1,'<');

                    BoxSizeLWH := Format(BoxLength) + ' ' + 'X' + ' ' + Format(BoxWidth) + ' ' + 'X' + ' ' + Format(BoxHeight);
                    //BoxLength+' X '+BoxWidth+' X '+BoxHeight;
                    //MESSAGE(FORMAT(Boardupint));
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
                        SubJobNo := ProdCompLine."Sub Comp No.";
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
                EST_HEADER.SetFilter(EST_HEADER."Product Design Type", 'Main');
                EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Product Design No.");
                if EST_HEADER.FindFirst then begin
                    LinearLengthQty := EST_HEADER."Linear Length Qty Per";
                end;


                TotalNetWeight := 0;
                BoxUnitWeight := 0;
                EST_HEADER.Reset;
                EST_HEADER.SetRange(EST_HEADER."Product Design Type", "Prod. Order Line"."Product Design Type");
                EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Estimate Code");
                EST_HEADER.SetRange(EST_HEADER."Sub Comp No.", "Sub Comp No.");
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
                end;


                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder.Status, Status);
                ProductionOrder.SetRange(ProductionOrder."No.", "Prod. Order No.");
                if ProductionOrder.FindFirst then begin
                    //MESSAGE('Hai, iam inside %1',PROD_ORDER."Sales Order No.");
                    SalesHeader.Reset;
                    SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange(SalesHeader."No.", ProductionOrder."Sales Order No.");
                    if SalesHeader.FindFirst then begin
                        // MESSAGE('i am inside in sales order');
                        CUSTNO := SalesHeader."Sell-to Customer No.";
                        CUSTNAME := SalesHeader."Sell-to Customer Name";
                        EXTNO := SalesHeader."External Document No.";
                        ORDERDATE := SalesHeader."Order Date";
                    end;
                end;
                //MESSAGE(CUSTNO);
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
        SalesHeader: Record "Sales Header";
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
        ItemCard: Record Item;
        DieDescription: Text[250];
        IssuedDate: Date;
        ProductionOrder: Record "Production Order";
}

