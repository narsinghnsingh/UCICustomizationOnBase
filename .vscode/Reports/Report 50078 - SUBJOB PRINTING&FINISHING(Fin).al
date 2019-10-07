report 50078 "SUBJOB PRINTING&FINISHING(Fin)"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/SUBJOB PRINTING&FINISHING(Fin).rdl';
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
            column(ORDERED_QTY; ORDERED_QTY)
            {
            }
            column(DO_NO; DO_NO)
            {
            }
            column(DO_DATE; DO_DATE)
            {
            }
            column(DESPATCHED_QTY; DESPATCHED_QTY)
            {
            }
            column(Quantity_ProdOrderLine; "Prod. Order Line".Quantity)
            {
            }
            column(SCARP_QTY; SCARP_QTY)
            {
            }
            column(FINISHED_QTY; FINISHED_QTY)
            {
            }
            dataitem("Production Order"; "Production Order")
            {
                DataItemLink = "No." = FIELD ("Prod. Order No."), "Estimate Code" = FIELD ("Estimate Code");
                DataItemTableView = SORTING (Status, "No.") WHERE (Status = CONST (Finished));
                column(UnitCost_ProductionOrder; "Production Order"."Unit Cost")
                {
                }
                column(No_ProductionOrder; "Production Order"."No.")
                {
                }
                column(CreationDate_ProductionOrder; "Production Order"."Creation Date")
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
                column(TotalNetWeight; TotalNetWeight)
                {
                }
                column(BoxUnitWeight; BoxUnitWeight)
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
                column(RepeatJob; RepeatJob + Modifiedjob)
                {
                }
                column(RepeatJobNo; RepeatJobNo)
                {
                }
                column(Modifiedjob; Modifiedjob)
                {
                }
                column(PRINTDESC; PRINTDESC)
                {
                }
                column(STICTHDESC; STICTHDESC)
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
                column(FG_GSM1; FG_GSM)
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
                column(GLUTXT1; GLUTXT1)
                {
                }
                column(DIETXT1; DIETXT1)
                {
                }
                column(LAMTXT1; LAMTXT1)
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
                column(TopColor; TopColor)
                {
                }
                column(COLOR4; COLOR4)
                {
                }
                column(BOX_SIZE; BOX_SIZE)
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


                    ITEMATTRIBUATE_ENTRY.Reset;
                    ITEMATTRIBUATE_ENTRY.SetRange(ITEMATTRIBUATE_ENTRY."Item No.", "Source No.");
                    ITEMATTRIBUATE_ENTRY.SetRange(ITEMATTRIBUATE_ENTRY."Item Category Code", 'FG');
                    ITEMATTRIBUATE_ENTRY.SetFilter(ITEMATTRIBUATE_ENTRY."Item Attribute Code", 'LENGTH');
                    if ITEMATTRIBUATE_ENTRY.FindFirst then begin
                        SIZE_LENGTH := ITEMATTRIBUATE_ENTRY."Item Attribute Value";
                    end else begin
                        SIZE_LENGTH := '';
                    end;

                    ITEMATTRIBUATE_ENTRY.Reset;
                    ITEMATTRIBUATE_ENTRY.SetRange(ITEMATTRIBUATE_ENTRY."Item No.", "Source No.");
                    ITEMATTRIBUATE_ENTRY.SetRange(ITEMATTRIBUATE_ENTRY."Item Category Code", 'FG');
                    ITEMATTRIBUATE_ENTRY.SetFilter(ITEMATTRIBUATE_ENTRY."Item Attribute Code", 'WIDTH');
                    if ITEMATTRIBUATE_ENTRY.FindFirst then begin
                        SIZE_WIDTH := ITEMATTRIBUATE_ENTRY."Item Attribute Value";
                    end else begin
                        SIZE_WIDTH := '';
                    end;

                    ITEMATTRIBUATE_ENTRY.Reset;
                    ITEMATTRIBUATE_ENTRY.SetRange(ITEMATTRIBUATE_ENTRY."Item No.", "Source No.");
                    ITEMATTRIBUATE_ENTRY.SetRange(ITEMATTRIBUATE_ENTRY."Item Category Code", 'FG');
                    ITEMATTRIBUATE_ENTRY.SetFilter(ITEMATTRIBUATE_ENTRY."Item Attribute Code", 'HEIGHT');
                    if ITEMATTRIBUATE_ENTRY.FindFirst then begin
                        SIZE_HEIGHT := ITEMATTRIBUATE_ENTRY."Item Attribute Value";
                    end else begin
                        SIZE_HEIGHT := '';
                    end;
                    BoxSize1 := SIZE_LENGTH + ' ' + 'X' + ' ' + SIZE_WIDTH + ' ' + 'X' + ' ' + SIZE_HEIGHT;


                    Item.Reset;
                    Item.SetRange(Item."No.", "Production Order"."Source No.");
                    Item.SetFilter(Item."Inventory Posting Group", 'FG');
                    if Item.FindFirst then begin
                        FG_GSM := Item."FG GSM";
                    end;




                    EST_HEADER.Reset;
                    EST_HEADER.SetFilter(EST_HEADER."Product Design Type", 'Sub');
                    EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Estimate Code");
                    EST_HEADER.SetRange(EST_HEADER."Sub Comp No.", "Prod. Order Line"."Sub Comp No.");
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
                        BOX_SIZE := EST_HEADER."Box Size";
                        TopColor := EST_HEADER."Top Colour";
                        BoxUnitWeight := ((EST_HEADER."Board Length (mm)- L" * EST_HEADER."Board Width (mm)- W" * EST_HEADER.Grammage) / 1000000000);
                        TotalNetWeight := BoxUnitWeight;//*EST_HEADER.Quantity;



                        /*
                        COLOR1 := EST_HEADER."Printing Colour 1";
                        COLOR2 := EST_HEADER."Printing Colour 2";
                        COLOR3 := EST_HEADER."Printing Colour 3";
                        COLOR4 := EST_HEADER."Printing Colour 4";
                        */

                        COLOR1 := '';
                        COLOR2 := '';
                        COLOR3 := '';
                        COLOR4 := '';

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
                        PRNTTXT1 := 'YES';
                        PRINTDESC := 'PRINTING'
                    end else begin
                        PRNTTXT1 := 'NO';
                        PRINTDESC := '';
                    end;

                    if STITXT = true then begin
                        STITXT1 := 'YES';
                        STICTHDESC := 'STITCHING'

                    end else begin
                        STITXT1 := 'NO';
                        STICTHDESC := 'GLUING'
                    end;
                    //MESSAGE(PRINTDESC);
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
                        // MESSAGE( Modifiedjob);
                    end else begin
                        Modifiedjob := '';
                    end;

                end;
            }
            dataitem("Product Design Special Descrip"; "Product Design Special Descrip")
            {
                DataItemLink = "No." = FIELD ("Product Design No.");
                DataItemTableView = SORTING ("No.", "Line No.") ORDER(Ascending) WHERE (Category = CONST ("Special Instruction"));
                column(Category_EstimateSpecialDescription; "Product Design Special Descrip".Category)
                {
                }
                column(Comment_EstimateSpecialDescription; "Product Design Special Descrip".Comment)
                {
                }
            }
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = "Item No." = FIELD ("Item No."), "Prod. Order No." = FIELD ("Prod. Order No.");
                DataItemTableView = SORTING (Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") ORDER(Ascending) WHERE (Description = FILTER (<> ''));
                column(WorkCenterCategory; "Prod. Order Routing Line".Description)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin



                SALES_LINE.Reset;
                SALES_LINE.SetRange(SALES_LINE."Document No.", "Sales Order No.");
                SALES_LINE.SetRange(SALES_LINE."Line No.", "Sales Order Line No.");
                SALES_LINE.SetRange(SALES_LINE."Prod. Order No.", "Prod. Order No.");
                SALES_LINE.SetRange(SALES_LINE."Estimation No.", "Estimate Code");
                SALES_LINE.SetRange(SALES_LINE."No.", "Item No.");
                if SALES_LINE.FindFirst then begin
                    ORDERED_QTY := SALES_LINE.Quantity;
                end else begin
                    ORDERED_QTY := 0;
                end;

                //MESSAGE(FORMAT(ORDERED_QTY));


                SALE_SHIPMNETL.Reset;
                SALE_SHIPMNETL.SetRange(SALE_SHIPMNETL."Order No.", "Sales Order No.");
                SALE_SHIPMNETL.SetRange(SALE_SHIPMNETL."Order Line No.", "Sales Order Line No.");
                if SALE_SHIPMNETL.FindFirst then begin
                    DO_NO := SALE_SHIPMNETL."Document No.";
                    DO_DATE := SALE_SHIPMNETL."Posting Date";
                    DESPATCHED_QTY := SALE_SHIPMNETL.Quantity;
                end;


                CapacityLedgerEntry.Reset;
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Order No.", "Prod. Order No.");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Order Line No.", "Line No.");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Item No.", "Item No.");
                if CapacityLedgerEntry.FindFirst then begin
                    SCARP_QTY := CapacityLedgerEntry."Scrap Quantity";
                end;

                ProdOrderRoutingLine.Reset;
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Prod. Order No.", "Prod. Order No.");
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Routing Reference No.", "Line No.");
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Item No.", "Item No.");
                if ProdOrderRoutingLine.FindLast then begin
                    ProdOrderRoutingLine.CalcFields(ProdOrderRoutingLine."Actual Output Quantity");
                    FINISHED_QTY := ProdOrderRoutingLine."Actual Output Quantity";
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
        LASTJOBNO: Code[30];
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
        COLRTXT: Boolean;
        COLRTXT1: Text[10];
        STITXT: Boolean;
        STITXT1: Text[10];
        GLUTXT: Boolean;
        GLUTXT1: Boolean;
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
        ITEM_ATTRIBUTEENTRY: Record "Item Attribute Entry";
        FG_DECSIZE: Code[10];
        FG_GSM1: Code[10];
        USERS: Record User;
        USER_FULLNAME: Text[50];
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
        COLOR1: Code[100];
        COLOR2: Code[100];
        COLOR3: Code[100];
        COLOR4: Code[100];
        BOX_SIZE: Code[100];
        RepeatJob: Text[20];
        RepeatJobNo: Code[20];
        Modifiedjob: Text[20];
        SALES_LINE: Record "Sales Line";
        SALE_SHIPMNETL: Record "Sales Shipment Line";
        ORDERED_QTY: Decimal;
        DO_NO: Code[20];
        DO_DATE: Date;
        DESPATCHED_QTY: Decimal;
        PRINTDESC: Text[20];
        STICTHDESC: Text[20];
        TopColor: Text[20];
        BoxUnitWeight: Decimal;
        TotalNetWeight: Decimal;
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        SCARP_QTY: Decimal;
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        FINISHED_QTY: Decimal;
}

