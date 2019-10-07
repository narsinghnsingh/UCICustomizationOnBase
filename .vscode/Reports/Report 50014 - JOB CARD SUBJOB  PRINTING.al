report 50014 "JOB CARD SUBJOB  PRINTING"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/JOB CARD SUBJOB  PRINTING.rdl';
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
            column(PRNTTXT1; PRNTTXT1)
            {
            }
            column(STITXT1; STITXT1)
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
            column(ItemNo_ProdOrderLine; "Prod. Order Line"."Item No.")
            {
            }
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = FIELD ("Prod. Order No.");
                DataItemTableView = SORTING (Status, "No.") WHERE (Status = CONST (Released));
                column(CreationDate_ProductionOrder; "Production Order"."Creation Date")
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
                    SH.SetRange(SH."No.", "Production Order"."Sales Order No.");
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
                    SL.SetRange(SL."Prod. Order No.", "Production Order"."No.");
                    SL.SetRange(SL."No.", "Production Order"."Source No.");
                    if SL.FindFirst then begin
                        EXPECTEDDELDATE := SL."Requested Delivery Date";
                    end else begin
                        EXPECTEDDELDATE := 0D;
                    end;
                end;
            }
            dataitem("Product Design Special Descrip"; "Product Design Special Descrip")
            {
                DataItemLink = "No." = FIELD ("Product Design No.");
                DataItemTableView = SORTING ("No.", "Line No.") ORDER(Ascending) WHERE (Category = FILTER ("Sub Job Detail"));
                column(Category_EstimateSpecialDescription; "Product Design Special Descrip".Category)
                {
                }
                column(Comment_EstimateSpecialDescription; "Product Design Special Descrip".Comment)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                EST_HEADER.Reset;
                EST_HEADER.SetFilter(EST_HEADER."Product Design Type", 'Sub');
                EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Estimate Code");
                EST_HEADER.SetRange(EST_HEADER."Item Code", "Item No.");
                EST_HEADER.SetRange(EST_HEADER."Sub Comp No.", "Sub Comp No.");
                if EST_HEADER.FindFirst then begin
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
                    BOXSIZE := EST_HEADER."Box Size";
                    COLOR1 := EST_HEADER."Printing Colour 1";
                    COLOR2 := EST_HEADER."Printing Colour 2";
                    COLOR3 := EST_HEADER."Printing Colour 3";
                    COLOR4 := EST_HEADER."Printing Colour 4";
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
        LASTJOBNO: Code[20];
        Item: Record Item;
        "FG GSM": Decimal;
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
        COLRTXT: Boolean;
        COLRTXT1: Text[10];
        STITXT: Boolean;
        STITXT1: Text[10];
        GLUTXT: Boolean;
        GLUTXT1: Text[10];
        DIETXT: Boolean;
        DIETXT1: Text[10];
        DIENUMTXT: Boolean;
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
        ITEM_GSM: Code[10];
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
        USERS: Record User;
        USER_FULLNAME: Text[50];
        EST_HEADER: Record "Product Design Header";
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
        BOXSIZE: Text[20];
        COLOR1: Code[50];
        COLOR2: Code[50];
        COLOR3: Code[50];
        COLOR4: Code[50];
}

