report 50013 "Daily Production Status"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Daily Production Status.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
        {
            DataItemTableView = SORTING ("Entry No.") ORDER(Ascending);
            RequestFilterFields = "Posting Date", "Work Center No.", "Employee Code";
            column(COMINFO_NAME; COMP_INFO.Name)
            {
            }
            column(COMPINFO_ADD; COMP_INFO.Address)
            {
            }
            column(COMINFO_ADD1; COMP_INFO."Address 2")
            {
            }
            column(RUNDATE; WorkDate)
            {
            }
            column(No_CapacityLedgerEntry; "Capacity Ledger Entry"."No.")
            {
            }
            column(MINDATE; MINDATE)
            {
            }
            column(MAXDATE; MAXDATE)
            {
            }
            column(WorkCenterDescription_CapacityLedgerEntry; "Capacity Ledger Entry"."Work Center Description")
            {
            }
            column(WorkShiftCode_CapacityLedgerEntry; "Capacity Ledger Entry"."Work Shift Code")
            {
            }
            column(Posting_Date; "Capacity Ledger Entry"."Posting Date")
            {
            }
            column(WorkCenterNo_CapacityLedgerEntry; "Capacity Ledger Entry"."Work Center No.")
            {
            }
            column(Category_Code; "Capacity Ledger Entry"."Item Category Code")
            {
            }
            column(RPO; "Capacity Ledger Entry"."Order No.")
            {
            }
            column(Item; "Capacity Ledger Entry"."Item No.")
            {
            }
            column(UOM; "Capacity Ledger Entry"."Unit of Measure Code")
            {
            }
            column(Output; "Capacity Ledger Entry"."Output Quantity")
            {
            }
            column(AllFilters; AllFilters)
            {
            }
            column(Scrap; "Capacity Ledger Entry"."Scrap Quantity")
            {
            }
            column(OutputWeightKg_CapacityLedgerEntry; "Capacity Ledger Entry"."Output Weight (Kg)")
            {
            }
            column(OPERATOR_NAME; OPERATOR_NAME)
            {
            }
            column(CUST_NAME; CUST_NAME)
            {
            }
            column(BOXPERWT; BOXPERWT)
            {
            }
            column(MACHINE_DESC; MACHINE_DESC)
            {
            }
            column(StartingTime_CapacityLedgerEntry; "Capacity Ledger Entry"."Starting Time")
            {
            }
            column(EndingTime_CapacityLedgerEntry; "Capacity Ledger Entry"."Ending Time")
            {
            }
            column(BoxUnitWeight1; BoxUnitWeight1)
            {
            }
            column(BoxUnitWeight2; BoxUnitWeight2)
            {
            }
            column(PROD_QTY; PROD_QTY)
            {
            }
            column(ProducedWgt; "ProducedWgt.")
            {
            }
            column(Noofdie; NOOFDIECUTUP)
            {
            }
            column(TrimWeight; TrimWeight)
            {
            }
            column(planned_consmp; planned_consmp)
            {
            }
            column(EmployeeName_CapacityLedgerEntry; "Capacity Ledger Entry"."Employee Name")
            {
            }
            column(FG_GSM; FG_GSM)
            {
            }
            column(ACTUAL_GSM; ACTUAL_GSM)
            {
            }
            column(LINEAR_LENGTH; LINEAR_LENGTH)
            {
            }
            column(PLANNED_DECKLE; Format(PLANNED_DECKLE))
            {
            }
            column(GSM_DIFFERENCE; GSM_DIFFERENCE)
            {
            }
            column(ITEM_DESC; ITEM_DESC)
            {
            }
            column(GSM_VALUE; GSM_VALUE)
            {
            }
            column(Customer_Wtg; Customer_Wtg)
            {
            }
            column(NetWt; NetWt)
            {
            }
            column(Prod_GSM; Prod_GSM)
            {
            }
            column(JobCard_Weight2; JobCard_Weight2)
            {
            }

            trigger OnAfterGetRecord()
            var
                ProdOrderStatusManagement: Codeunit CodeunitSubscriber;
                ProductDesignHeader: Record "Product Design Header";
            begin
                COMP_INFO.Get;

                EMP.Reset;
                EMP.SetRange(EMP."No.", "Capacity Ledger Entry"."Employee Code");
                if EMP.FindFirst then begin
                    OPERATOR_NAME := EMP."First Name";
                end else begin
                    OPERATOR_NAME := '';
                end;

                PROD_ORDER.Reset;
                PROD_ORDER.SetRange(PROD_ORDER."No.", "Order No.");
                if PROD_ORDER.FindFirst then begin
                    // Lines added By Deepak Kumar
                    ProdOrderStatusManagement.UpdateFGWeight(PROD_ORDER);
                    SO_NO := PROD_ORDER."Sales Order No.";
                    SH.Reset;
                    SH.SetRange(SH."No.", SO_NO);
                    if SH.FindFirst then begin
                        CUST_NAME := SH."Sell-to Customer Name";
                    end;
                end;




                NOOFDIE_UPS := 1;
                ProdOrderRoutingLine.Reset;
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Prod. Order No.", "Order No.");
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Routing Reference No.", "Order Line No.");
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Work Center No.", "Work Center No.");
                if ProdOrderRoutingLine.FindFirst then begin
                    NOOFDIECUTUP := ProdOrderRoutingLine."Die Cut Ups";
                    NOOFJOINTS := ProdOrderRoutingLine."No of Joints";
                end;


                PROD_QTY := 0;
                "PROD.ORDERLINE".Reset;
                "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Prod. Order No.", "Order No.");
                "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Line No.", "Order Line No.");
                if "PROD.ORDERLINE".FindFirst then begin
                    PROD_QTY := "PROD.ORDERLINE".Quantity;
                end;


                "PROD.ORDERLINE".Reset;
                "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Prod. Order No.", "Capacity Ledger Entry"."Order No.");
                "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Line No.", "Capacity Ledger Entry"."Order Line No.");
                if "PROD.ORDERLINE".FindFirst then begin
                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", "PROD.ORDERLINE"."Product Design Type");
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", "PROD.ORDERLINE"."Product Design No.");
                    ProductDesignHeader.SetRange(ProductDesignHeader."Sub Comp No.", "PROD.ORDERLINE"."Sub Comp No.");
                    if ProductDesignHeader.FindFirst then begin
                        BoxUnitWeight := (((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W" * ProductDesignHeader.Grammage) / ProductDesignHeader."No. of Die Cut Ups") / 1000000000);
                        BoxUnitWeight2 := (BoxUnitWeight * PROD_QTY);
                    end;
                end;

                planned_consmp := "Capacity Ledger Entry"."Output Quantity" * BoxUnitWeight;

                TrimWeight := 0;
                "PROD.ORDERLINE".Reset;
                "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Prod. Order No.", "Order No.");
                "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Line No.", "Order Line No.");
                if ProductDesignLine.FindFirst then begin
                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", "PROD.ORDERLINE"."Product Design Type");
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", "PROD.ORDERLINE"."Product Design No.");
                    ProductDesignHeader.SetRange(ProductDesignHeader."Sub Comp No.", "PROD.ORDERLINE"."Sub Comp No.");
                    if ProductDesignHeader.FindFirst then begin
                        ConsItemLedgerEntry.Reset;
                        ConsItemLedgerEntry.SetRange(ConsItemLedgerEntry."Posting Date", "Capacity Ledger Entry"."Posting Date");
                        ConsItemLedgerEntry.SetRange(ConsItemLedgerEntry."Order Type", ConsItemLedgerEntry."Order Type"::Production);
                        ConsItemLedgerEntry.SetRange(ConsItemLedgerEntry."Order No.", "Capacity Ledger Entry"."Order No.");
                        ConsItemLedgerEntry.SetRange(ConsItemLedgerEntry."Order Line No.", "Capacity Ledger Entry"."Order Line No.");
                        ConsItemLedgerEntry.SetRange(ConsItemLedgerEntry."Item Category Code", 'PAPER');
                        if ConsItemLedgerEntry.FindFirst then begin
                            repeat
                                Item.Get(ConsItemLedgerEntry."Item No.");
                                ExtraTrim := Item."Deckle Size (mm)" - ProductDesignHeader."Roll Width (mm)";
                                if (Item."Deckle Size (mm)" <> 0) and (ExtraTrim > 0) then
                                    TrimWeight := TrimWeight + ((-ConsItemLedgerEntry.Quantity) / Item."Deckle Size (mm)") * ExtraTrim;
                                ;
                            until ConsItemLedgerEntry.Next = 0;
                        end;
                    end;
                end;



                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", "Capacity Ledger Entry"."Document No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Order Type", "Capacity Ledger Entry"."Order Type");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Order No.", "Capacity Ledger Entry"."Order No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Order Line No.", "Capacity Ledger Entry"."Order Line No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Posting Date", "Capacity Ledger Entry"."Posting Date");
                if ItemLedgerEntry.FindFirst then begin
                    "ProducedWgt." := ItemLedgerEntry."Actual Output Weight";
                end;

                MachineCenter.Reset;
                MachineCenter.SetRange(MachineCenter."No.", "No.");
                if MachineCenter.FindFirst then begin
                    MACHINE_DESC := MachineCenter.Name;
                end;



                ProductionScheduleLine.Reset;
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Item Code", "Item No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Prod. Order No.", "Order No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Prod. Order Line No.", "Order Line No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
                if ProductionScheduleLine.FindFirst then begin

                    LINEAR_LENGTH := ProductionScheduleLine."Linear Length(Mtr)";
                    PLANNED_DECKLE := ProductionScheduleLine."Planned Deckle Size(mm)";
                end;

                FG_GSM := 0;
                Prod_GSM := 0;
                NetWt := 0;
                Item.Reset;
                Item.SetRange(Item."No.", "Item No.");
                if Item.FindFirst then begin
                    FG_ITEMCODE := Item."FG Item No.";
                    ITEM_DESC := Item.Description;
                    Item2.Reset;
                    Item2.SetRange(Item2."No.", FG_ITEMCODE);
                    if Item2.FindFirst then begin
                        NetWt := Item2."Net Weight";
                        ;
                        //Customer_Wtg :=ROUND((NetWt * "Capacity Ledger Entry"."Output Quantity"),0.01)/1000;
                    end;
                    "PROD.ORDERLINE".Reset;
                    "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Prod. Order No.", "Capacity Ledger Entry"."Order No.");
                    "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Line No.", "Capacity Ledger Entry"."Order Line No.");
                    if "PROD.ORDERLINE".FindFirst then begin
                        ProductDesignHeader.Reset;
                        ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", "PROD.ORDERLINE"."Product Design Type");
                        ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", "PROD.ORDERLINE"."Product Design No.");
                        ProductDesignHeader.SetRange(ProductDesignHeader."Sub Comp No.", "PROD.ORDERLINE"."Sub Comp No.");
                        if ProductDesignHeader.FindFirst then begin
                            BoxUnitNETWeight := (((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W" * ProductDesignHeader."Customer GSM") / ProductDesignHeader."No. of Die Cut Ups") / 1000000000);
                            Customer_Wtg := Round((BoxUnitNETWeight * "Capacity Ledger Entry"."Output Quantity"), 0.01);
                        end;
                    end;

                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetRange(ProductDesignHeader."Item Code", FG_ITEMCODE);
                    if ProductDesignHeader.FindFirst then begin
                        FG_GSM := ProductDesignHeader."Customer GSM";
                        Prod_GSM := ProductDesignHeader.Grammage;
                        MtrSqure := 0;
                        //      1/Grammage :=(("Board Length (mm)- L"* "Board Width (mm)- W"  )/"No. of Die Cut Ups")/(1000000 * Per Bx Weight);
                        // MtrSqure:=((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W")/ProductDesignHeader."No. of Die Cut Ups")/1000000;
                        MtrSqure := ((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W")) / 1000000;

                        //IF  (("ProducedWgt."/ PROD_QTY) >0 ) AND ("Capacity Ledger Entry"."Output Quantity" <> 0) THEN
                        // ACTUAL_GSM := ROUND(((("ProducedWgt."/"Capacity Ledger Entry"."Output Quantity")*1000)/MtrSqure),1)

                        //ELSE
                        //ACTUAL_GSM:=0;

                        ACTUAL_GSM := 0;
                        ITEM_GSM := 0;
                        ItemNum := '';
                        Rec_ILE.Reset;
                        Rec_ILE.SetCurrentKey(Rec_ILE."Item No.");
                        Rec_ILE.SetRange(Rec_ILE."Entry Type", Rec_ILE."Entry Type"::Consumption);
                        Rec_ILE.SetRange(Rec_ILE."Item Category Code", 'PAPER');
                        Rec_ILE.SetRange("Order No.", "Capacity Ledger Entry"."Order No.");
                        Rec_ILE.SetRange(Rec_ILE."Order Line No.", "Capacity Ledger Entry"."Order Line No.");
                        if Rec_ILE.FindSet then
                            repeat
                                if Rec_ILE."Item No." <> ItemNum then begin
                                    ProdOrderComponent.Reset;
                                    ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order No.", Rec_ILE."Order No.");
                                    ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order Line No.", Rec_ILE."Order Line No.");
                                    ProdOrderComponent.SetRange(ProdOrderComponent."Item No.", Rec_ILE."Item No.");
                                    ProdOrderComponent.SetRange(ProdOrderComponent."Substitute Item", false);
                                    //      ProdOrderComponent.SETRANGE(ProdOrderComponent."Schedule Component",FALSE);
                                    if ProdOrderComponent.FindFirst then begin
                                        //IF ProdOrderComponent."Paper Position" = ProdOrderComponent."Paper Position"::liner1 THEN

                                        Item.Reset;
                                        Item.SetRange(Item."No.", ProdOrderComponent."Item No.");
                                        Item.SetFilter(Item."Inventory Posting Group", 'PAPER');
                                        if Item.FindFirst then begin
                                            ITEM_GSM := Item."Paper GSM" * ProdOrderComponent."Take Up";
                                            ACTUAL_GSM += ITEM_GSM;
                                        end;
                                    end;
                                    ItemNum := Rec_ILE."Item No.";
                                end;
                            until Rec_ILE.Next = 0;



                        "PROD.ORDERLINE".Reset;
                        "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Prod. Order No.", "Capacity Ledger Entry"."Order No.");
                        "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Line No.", "Capacity Ledger Entry"."Order Line No.");
                        if "PROD.ORDERLINE".FindFirst then begin
                            ProductDesignHeader.Reset;
                            ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", "PROD.ORDERLINE"."Product Design Type");
                            ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", "PROD.ORDERLINE"."Product Design No.");
                            ProductDesignHeader.SetRange(ProductDesignHeader."Sub Comp No.", "PROD.ORDERLINE"."Sub Comp No.");
                            if ProductDesignHeader.FindFirst then begin
                                JobCard_Weight := (((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W" * ACTUAL_GSM) / ProductDesignHeader."No. of Die Cut Ups") / 1000000000);
                                JobCard_Weight2 := JobCard_Weight * PROD_QTY;
                            end;
                        end;


                    end;
                end;



                GSM_DIFFERENCE := FG_GSM - ACTUAL_GSM;
                if GSM_DIFFERENCE <> 0 then begin
                    GSM_VALUE := (LINEAR_LENGTH * PLANNED_DECKLE * GSM_DIFFERENCE) / 1000000;
                end else begin
                    GSM_VALUE := 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                AllFilters := "Capacity Ledger Entry".GetFilters;

                if "Capacity Ledger Entry".GetFilter("Posting Date") <> '' then begin
                    MINDATE := "Capacity Ledger Entry".GetRangeMin("Capacity Ledger Entry"."Posting Date");
                    MAXDATE := "Capacity Ledger Entry".GetRangeMax("Capacity Ledger Entry"."Posting Date");
                end else begin
                    MINDATE := 0D;
                    MAXDATE := Today;
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
        AllFilters: Text[100];
        EMP: Record Employee;
        OPERATOR_NAME: Text[100];
        PROD_ORDER: Record "Production Order";
        SH: Record "Sales Header";
        CUST_NAME: Text[100];
        SO_NO: Code[20];
        "PROD.ORDERLINE": Record "Prod. Order Line";
        PROD_QTY: Decimal;
        ESTIMATE_CODE: Code[30];
        BOXPERWT: Decimal;
        ProductDesignHeader: Record "Product Design Header";
        MINDATE: Date;
        MAXDATE: Date;
        COMP_INFO: Record "Company Information";
        MachineCenter: Record "Machine Center";
        MACHINE_DESC: Text[100];
        NOOFDIE_UPS: Integer;
        BoxUnitWeight: Decimal;
        BoxUnitWeight1: Decimal;
        BoxUnitWeight2: Decimal;
        "ProducedWgt.": Decimal;
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        NOOFDIECUTUP: Integer;
        NOOFJOINTS: Integer;
        ProductDesignLine: Record "Product Design Line";
        TrimWeight: Decimal;
        ExtraTrim: Decimal;
        ItemLedgerEntry: Record "Item Ledger Entry";
        planned_consmp: Decimal;
        ConsItemLedgerEntry: Record "Item Ledger Entry";
        Item: Record Item;
        FG_ITEMCODE: Code[30];
        ItemS: Record Item;
        FG_GSM: Decimal;
        ItemAttributeEntry: Record "Item Attribute Entry";
        ProductionScheduleLine: Record "Production Schedule Line";
        ACTUAL_GSM: Decimal;
        LINEAR_LENGTH: Decimal;
        PLANNED_DECKLE: Decimal;
        GSM_DIFFERENCE: Decimal;
        ITEM_DESC: Text[250];
        GSM_VALUE: Decimal;
        ITEM_CODE1: Code[20];
        Prod_GSM: Decimal;
        NetWt: Decimal;
        Item2: Record Item;
        Customer_Wtg: Decimal;
        MtrSqure: Decimal;
        ProdOrderComponent: Record "Prod. Order Component";
        ITEM_GSM: Decimal;
        JobCard_Weight: Decimal;
        JobCard_Weight2: Decimal;
        BoxUnitNETWeight: Decimal;
        Rec_ILE: Record "Item Ledger Entry";
        ItemNum: Code[20];
        ActL1: Decimal;
        ActF1: Decimal;
        ActL2: Decimal;
        ActF2: Decimal;
        ActL3: Decimal;
}

