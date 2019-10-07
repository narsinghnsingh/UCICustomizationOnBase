report 50092 "Daily Production Printing"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Daily Production Printing.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Capacity Ledger Entry"; "Capacity Ledger Entry")
        {
            DataItemTableView = SORTING ("Entry No.") ORDER(Ascending) WHERE ("No." = FILTER (<> 'MC0001'));
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
            column(Extratrim; Extratrim)
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
            column(SetupTime; "Capacity Ledger Entry"."Setup Time")
            {
            }
            column(Cap_No; "Capacity Ledger Entry"."No.")
            {
            }
            column(RunTime; "Capacity Ledger Entry"."Run Time")
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
            column(Corrugation_QTY; Corrugation_QTY)
            {
            }
            column(Corrugation_Weight; Corrugation_Weight)
            {
            }
            column(UNITWT; UNITWT)
            {
            }
            column(EmployeeName_CapacityLedgerEntry; "Capacity Ledger Entry"."Employee Name")
            {
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = FIELD ("Item No.");
                column(Item_Desc; Item.Description)
                {
                }
            }

            trigger OnAfterGetRecord()
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
                    SO_NO := PROD_ORDER."Sales Order No.";
                    SH.Reset;
                    SH.SetRange(SH."No.", SO_NO);
                    if SH.FindFirst then begin
                        CUST_NAME := SH."Sell-to Customer Name";
                    end;
                end;

                NOOFJOINTS := 1;
                NOOFDIE_UPS := 1;
                ProdOrderRoutingLine.Reset;
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Prod. Order No.", "Order No.");
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Routing Reference No.", "Order Line No.");
                ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Work Center No.", "Work Center No.");
                if ProdOrderRoutingLine.FindFirst then begin
                    if ProdOrderRoutingLine."Die Cut Ups" <> 0 then;
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
                        BoxUnitWeight := ((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W" * ProductDesignHeader.Grammage) / 1000000000);
                        BoxUnitWeight2 := BoxUnitWeight * PROD_QTY;

                    end;
                end;

                TrimWeight := 0;
                "PROD.ORDERLINE".Reset;
                "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Prod. Order No.", "Order No.");
                "PROD.ORDERLINE".SetRange("PROD.ORDERLINE"."Line No.", "Order Line No.");
                if ProductDesignLine.FindFirst then begin
                    ProductDesignLine.SetRange(ProductDesignLine."Product Design Type", "PROD.ORDERLINE"."Product Design Type");
                    ProductDesignLine.SetRange(ProductDesignLine."Product Design No.", "PROD.ORDERLINE"."Product Design No.");
                    ProductDesignLine.SetRange(ProductDesignLine."Sub Comp No.", "PROD.ORDERLINE"."Sub Comp No.");
                    if ProductDesignLine.FindFirst then begin
                        repeat
                            TrimWeight := TrimWeight + ProductDesignLine."Extra Trim Weight (KG)";
                        until ProductDesignLine.Next = 0;
                    end;
                end;

                //"ProducedWgt." := "Capacity Ledger Entry"."Output Weight (Kg)" * NOOFDIECUTUP/NOOFJOINTS;



                MachineCenter.Reset;
                MachineCenter.SetRange(MachineCenter."No.", "No.");
                if MachineCenter.FindFirst then begin
                    MACHINE_DESC := MachineCenter.Name;
                end;

                Corrugation_QTY := 0;
                Corrugation_Weight := 0;
                CLE.Reset;
                CLE.SetCurrentKey(CLE."No.");
                CLE.SetRange(CLE."Order No.", "Order No.");
                CLE.SetRange(CLE."Work Center No.", 'WC0001');
                if CLE.FindFirst then begin
                    repeat
                        Corrugation_QTY := Corrugation_QTY + CLE."Output Quantity";
                    until CLE.Next = 0;
                end;
                // MESSAGE(FORMAT(Corrugation_QTY));

                Extratrim := 0;
                BoardWidth := 0;
                BoardLength := 0;
                DeckleSize := 0;
                BoardUp := 1;
                LeftTrim := 0;
                RightTrim := 0;
                ProdDesign.Reset;
                ProdDesign.SetRange(ProdDesign."Item Code", "Item No.");
                if ProdDesign.FindFirst then begin
                    BoardWidth := ProdDesign."Board Width (mm)- W";
                    BoardLength := ProdDesign."Board Length (mm)- L";
                    DeckleSize := ProdDesign."Paper Deckle Size (mm)";
                    BoardUp := ProdDesign."Board Ups";
                    LeftTrim := ProdDesign."Left Trim Size (mm)";
                    RightTrim := ProdDesign."Right Trim Size (mm)";
                    Extratrim := DeckleSize - (BoardWidth * BoardUp) - (LeftTrim + RightTrim);
                end;

                /*"PROD.ORDERLINE".RESET;
                "PROD.ORDERLINE".SETRANGE("PROD.ORDERLINE"."Prod. Order No.","Capacity Ledger Entry"."Order No.");
                "PROD.ORDERLINE".SETRANGE("PROD.ORDERLINE"."Line No.","Capacity Ledger Entry"."Order Line No.");
                "PROD.ORDERLINE".SETRANGE("PROD.ORDERLINE"."Item Category Code",'BOARD');
                IF "PROD.ORDERLINE".FINDFIRST THEN BEGIN
                  BOARD_NO :="PROD.ORDERLINE"."Item No.";
                  ItemLedgerEntry.RESET;
                  ItemLedgerEntry.SETFILTER(ItemLedgerEntry."Entry Type",'Output');
                  ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item No.", BOARD_NO);
                  ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Order Type","Capacity Ledger Entry"."Order Type");
                  ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Order No.","Capacity Ledger Entry"."Order No.");
                  ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Order Line No.","Capacity Ledger Entry"."Order Line No.");
                  IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                  REPEAT
                  Corrugation_Weight :=ItemLedgerEntry."Actual Output Weight";
                  UNTIL ItemLedgerEntry.NEXT=0;
                END;
                END;
                //MESSAGE(FORMAT(Corrugation_Weight));*/




                ILE.Reset;
                ILE.SetFilter(ILE."Entry Type", 'Output');
                ILE.SetRange(ILE."Item Category Code", 'BOARD');
                ILE.SetRange(ILE."Order No.", "Order No.");
                if ILE.FindFirst then begin
                    Corrugation_Weight := ILE."Actual Output Weight";
                end;
                //MESSAGE(FORMAT(Corrugation_Weight));
                if Corrugation_QTY = 0
                 then Corrugation_QTY := 1;
                UNITWT := Corrugation_Weight / Corrugation_QTY;

            end;

            trigger OnPreDataItem()
            begin
                AllFilters := "Capacity Ledger Entry".GetFilters;
                MINDATE := "Capacity Ledger Entry".GetRangeMin("Capacity Ledger Entry"."Posting Date");
                MAXDATE := "Capacity Ledger Entry".GetRangeMax("Capacity Ledger Entry"."Posting Date");
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
        CLE: Record "Capacity Ledger Entry";
        Corrugation_QTY: Decimal;
        ProdDesign: Record "Product Design Header";
        Extratrim: Decimal;
        BoardWidth: Decimal;
        BoardLength: Decimal;
        DeckleSize: Integer;
        BoardUp: Integer;
        LeftTrim: Decimal;
        RightTrim: Decimal;
        ItemLedgerEntry: Record "Item Ledger Entry";
        Corrugation_Weight: Decimal;
        UNITWT: Decimal;
        BOARD_NO: Code[20];
        ILE: Record "Item Ledger Entry";
}

