report 50006 "JOB CARD SUBJOB Corrugation"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/JOB CARD SUBJOB Corrugation.rdl';
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
            column(Estimate_Code; "Prod. Order Line"."Estimate Code")
            {
            }
            column(Description_ProdOrderLine; "Prod. Order Line".Description)
            {
            }
            column(Quantity_ProdOrderLine; "Prod. Order Line".Quantity)
            {
            }
            column(NOOFPLY; NOOFPLY)
            {
            }
            column(BOARD_SIZE; BOARD_SIZE)
            {
            }
            column(BOARD_UPS; BOARD_UPS)
            {
            }
            column(FLUTE_TYPE; FLUTE_TYPE)
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
            column(ARTXT1; ARTXT1)
            {
            }
            column(PROFTXT1; PROFTXT1)
            {
            }
            column(CLNTTXT1; CLNTTXT1)
            {
            }
            column(TotalNetWeight; TotalNetWeight)
            {
            }
            column(BoxUnitWeight; BoxUnitWeight)
            {
            }
            column(PRNTTXT1; PRNTTXT1)
            {
            }
            column(STITXT1; STITXT1)
            {
            }
            column(DIENUMTXT1; DIENUMTXT1)
            {
            }
            column(DIETXT1; DIETXT1)
            {
            }
            column(LAMTXT1; LAMTXT1)
            {
            }
            column(BOXSIZE; BOXSIZE)
            {
            }
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = FIELD ("Prod. Order No.");
                DataItemTableView = SORTING (Status, "No.") WHERE (Status = CONST (Released));
                column(CreationDate_ProductionOrder; Format("Production Order"."Creation Date"))
                {
                }
                column(Description_ProductionOrder; "Production Order".Description)
                {
                }
                column(Quantity_ProductionOrder; "Production Order".Quantity)
                {
                }
                column(SalesOrderNo_ProductionOrder; "Production Order"."Sales Order No.")
                {
                }
                column(EXTNO; EXTNO)
                {
                }
                column(CUSTNO; CUSTNO)
                {
                }
                column(CUSTNAME; CUSTNAME)
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
                end;
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = "Prod. Order No." = FIELD ("Prod. Order No."), "Prod. Order Line No." = FIELD ("Line No.");
                DataItemTableView = SORTING (Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") ORDER(Ascending);
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
                column(Quantityper_ProdOrderComponent; "Prod. Order Component"."Quantity per")
                {
                }
                column(ExpectedQuantity_ProdOrderComponent; "Prod. Order Component"."Expected Quantity")
                {
                }
                column(ITEMGSM; ITEM_GSM)
                {
                }
                column(ITEMDECKLE; ITEM_DECKLE)
                {
                }
                dataitem("Product Design Special Descrip"; "Product Design Special Descrip")
                {
                    DataItemLink = "No." = FIELD ("Product Design No.");
                    DataItemTableView = SORTING ("No.", "Line No.") ORDER(Ascending) WHERE (Category = FILTER ("Sub Job Detail"));
                    column(Comment_EstimateSpecialDescription; "Product Design Special Descrip".Comment)
                    {
                    }
                    column(Category_EstimateSpecialDescription; "Product Design Special Descrip".Category)
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin

                    ITEM_ATTRIBUTEENTRY.Reset;
                    ITEM_ATTRIBUTEENTRY.SetRange(ITEM_ATTRIBUTEENTRY."Item No.", "Item No.");
                    ITEM_ATTRIBUTEENTRY.SetRange(ITEM_ATTRIBUTEENTRY."Item Category Code", 'PAPER');
                    ITEM_ATTRIBUTEENTRY.SetRange(ITEM_ATTRIBUTEENTRY."Item Attribute Code", 'DECKLESIZE');
                    if ITEM_ATTRIBUTEENTRY.FindFirst then begin
                        ITEM_DECKLE := ITEM_ATTRIBUTEENTRY."Item Attribute Value";
                    end;


                    ITEM_ATTRIBUTEENTRY.Reset;
                    ITEM_ATTRIBUTEENTRY.SetRange(ITEM_ATTRIBUTEENTRY."Item No.", "Item No.");
                    ITEM_ATTRIBUTEENTRY.SetRange(ITEM_ATTRIBUTEENTRY."Item Category Code", 'PAPER');
                    ITEM_ATTRIBUTEENTRY.SetRange(ITEM_ATTRIBUTEENTRY."Item Attribute Code", 'PAPERGSM');
                    if ITEM_ATTRIBUTEENTRY.FindFirst then begin
                        ITEM_GSM := ITEM_ATTRIBUTEENTRY."Item Attribute Value";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //EST_HEADER.RESET;EST_HEADER.SETFILTER(EST_HEADER."Estimate Type",'Sub');
                EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Estimate Code");
                //EST_HEADER.SETRANGE(EST_HEADER."Item Code","Item No.");
                EST_HEADER.SetRange(EST_HEADER."Sub Comp No.", "Sub Comp No.");
                if EST_HEADER.FindFirst then begin
                    NOOFPLY := EST_HEADER."No. of Ply";
                    BOARD_SIZE := EST_HEADER."Board Size";
                    BOARD_UPS := EST_HEADER."Board Ups";
                    FLUTE_TYPE := EST_HEADER."Flute Type";
                    ROLL_WIDTH := EST_HEADER."Roll Width (mm)";
                    NOOFCOLORS := EST_HEADER."No. of Colour";
                    DIE_NOS := EST_HEADER."Die Number";
                    BoxUnitWeight := ((EST_HEADER."Board Length (mm)- L" * EST_HEADER."Board Width (mm)- W" * EST_HEADER.Grammage) / 1000000000);
                    TotalNetWeight := BoxUnitWeight;
                    NOOFDIE_UPS := EST_HEADER."No. of Die Cut Ups";
                    ARTXT := EST_HEADER."Artwork Available";
                    PROFTXT := EST_HEADER."Proof Required";
                    CLNTTXT := EST_HEADER."Client Sample";
                    PRNTTXT := EST_HEADER.Printing;
                    DIETXT := EST_HEADER."Die Punching";
                    STITXT := EST_HEADER.Stitching;
                    BOXSIZE := EST_HEADER."Box Size";
                end;

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
        DEC_SIZE: Decimal;
        ESTLINE: Record "Product Design Line";
        WORK_CENTER: array[20] of Option ,Materials,"Origination Cost",Corrugation,"Printing Guiding","Finishing Packing","Sub Job";
        MACHINE_CENTER: array[12] of Text[100];
        WORK_CENTER1: Option ,Materials,"Origination Cost",Corrugation,"Printing Guiding","Finishing Packing","Sub Job";
        MACHINE_CENTER1: Text;
        ROWNO: Integer;
        CATERORY: Option;
        EXTNO: Code[50];
        ARTXT: Boolean;
        ARTXT1: Text[10];
        PROFTXT: Boolean;
        PROFTXT1: Text[10];
        CLNTTXT: Boolean;
        CLNTTXT1: Text[10];
        PRNTTXT: Boolean;
        PRNTTXT1: Text[10];
        STITXT: Boolean;
        STITXT1: Text[10];
        GLUTXT: Boolean;
        GLUTXT1: Boolean;
        DIETXT: Boolean;
        DIENUMTXT: Boolean;
        DIENUMTXT1: Text[10];
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
        TOTOALNOCUT: Decimal;
        PRODORDERCOMMNET: Record "Prod. Order Comment Line";
        SPECDESC: Text[250];
        CORRDESC: Text[250];
        BOARDSIZE: Text[50];
        EH: Record "Product Design Header";
        TOTOALNOCUTNEW: Decimal;
        W_CENTER: Record "Work Center";
        WORK_DESC: Text[30];
        SubJobSize: Text[100];
        SubJobItem: Record Item;
        DECKLESIZE: Decimal;
        PAPERWT: Decimal;
        SUBGSM: Decimal;
        ITEM_ATTRIBUTEENTRY: Record "Item Attribute Entry";
        FG_GSM1: Code[10];
        ITEM_GSM: Code[10];
        ITEM_DECKLE: Code[10];
        EST_HEADER: Record "Product Design Header";
        FG_GSM: Code[10];
        NOOFPLY: Integer;
        BOARD_SIZE: Text[20];
        BOARD_UPS: Integer;
        FLUTE_TYPE: Text[20];
        ROLL_WIDTH: Decimal;
        NOOFCOLORS: Integer;
        DIE_NOS: Code[20];
        NOOFDIE_UPS: Integer;
        SPECIALINST: Record "Product Design Special Descrip";
        SPECIALCORRUGATION: Text[250];
        DIETXT1: Text[10];
        BOXSIZE: Text[20];
        BoxUnitWeight: Decimal;
        TotalNetWeight: Decimal;
}

