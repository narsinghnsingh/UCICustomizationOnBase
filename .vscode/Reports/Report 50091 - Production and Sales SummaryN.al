report 50091 "Production and Sales SummaryN"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Production and Sales SummaryN.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Machine Center"; "Machine Center")
        {
            RequestFilterFields = "Date Filter";
            column(WorkCenterCategory_MachineCenter; "Machine Center"."Work Center Category")
            {
            }
            column(Cap_MachinNo; "Machine Center"."No.")
            {
            }
            column(Cap_MachineDesc; "Machine Center".Name)
            {
            }
            column(DateFilter; DateFilter)
            {
            }
            column(TodayNos; TodayNos)
            {
            }
            column(TodayLM; TodayLM)
            {
            }
            column(TodayM2; TodayM2)
            {
            }
            column(TodaysTons; TodaysTons)
            {
            }
            column(cnt; cnt)
            {
            }
            column(NoofShift; NoofShift)
            {
            }
            column(Nos_TillDate; Nos_TillDate)
            {
            }
            column(LM_TillDate; LM_TillDate)
            {
            }
            column(M2_TillDate; M2_TillDate)
            {
            }
            column(Tons_TillDate; Tons_TillDate)
            {
            }
            column(AmountSalesInvLine; AmountSalesInvLine)
            {
            }
            column(NetWeightSaleInvLine; NetWeightSaleInvLine)
            {
            }
            column(NetWeght_SL; NetWeght_SL)
            {
            }
            column(Amount_SL; Amount_SL)
            {
            }
            column(WITTONS; WITTONS)
            {
            }
            column(FGQTY_ILE; Abs(FGQTY_ILE))
            {
            }
            column(ExtraTrimWeight; ExtraTrimWeight)
            {
            }
            column(TrimWeight; TrimWeight)
            {
            }
            column(Total_Consmp; Abs(Total_Consmp))
            {
            }
            column(ScrapWeight_CLE; ScrapWeight_CLE)
            {
            }
            column(SysDate; WorkDate)
            {
            }
            column(StartDate; StartDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                StartDate := DMY2Date(1, Date2DMY(DateFilter, 2), Date2DMY(DateFilter, 3));
                // Lines Added By Deepak Kumar
                // Calculate Today's Values
                TodayNos := 0;
                TodaysTons := 0;
                TodayM2 := 0;
                TodayLM := 0;

                CapacityLedgerEntry.Reset;
                CapacityLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."No.", "Machine Center"."No.");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Posting Date", DateFilter);
                if CapacityLedgerEntry.FindFirst then begin
                    repeat
                        TodayNos += CapacityLedgerEntry."Output Quantity";
                        TodaysTons += CapacityLedgerEntry."Output Weight (Kg)" / 1000;
                        ProductionOrder.Reset;
                        ProductionOrder.SetRange(ProductionOrder."Prod. Order No.", CapacityLedgerEntry."Order No.");
                        ProductionOrder.SetRange(ProductionOrder."Line No.", CapacityLedgerEntry."Order Line No.");
                        if ProductionOrder.FindFirst then begin
                            ProductDesignHeader.Reset;
                            ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", ProductionOrder."Product Design Type");
                            ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", ProductionOrder."Product Design No.");
                            ProductDesignHeader.SetRange(ProductDesignHeader."Sub Comp No.", ProductionOrder."Sub Comp No.");
                            if ProductDesignHeader.FindFirst then begin
                                TodayLM += ((CapacityLedgerEntry."Output Quantity" * ProductDesignHeader."Board Length (mm)- L") / ProductDesignHeader."Board Ups") / 1000;
                                TodayM2 += CapacityLedgerEntry."Output Quantity" * ((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W") / 1000000);
                            end;
                        end;
                    until CapacityLedgerEntry.Next = 0;
                end;


                if "Machine Center"."Work Center Category" <> "Machine Center"."Work Center Category"::Corrugation then begin
                    TodayLM := 0;
                    TodayM2 := 0;
                end;

                cnt := 0;
                NoofShift := 0;
                ScrapWeight_CLE := 0;
                TotalRunTime := 0;
                Nos_TillDate := 0;
                LM_TillDate := 0;
                M2_TillDate := 0;
                Tons_TillDate := 0;
                PostingDate := 0D;


                // Lines added for Calculate the Till date Values

                CapacityLedgerEntry.Reset;
                CapacityLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."No.", "Machine Center"."No.");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Posting Date", StartDate, EndDate);
                if CapacityLedgerEntry.FindFirst then begin
                    repeat
                        Nos_TillDate += CapacityLedgerEntry."Output Quantity";
                        Tons_TillDate += CapacityLedgerEntry."Output Weight (Kg)" / 1000;
                        ScrapWeight_CLE += CapacityLedgerEntry."Scrap Weight (Kg)";
                        ProductionOrder.Reset;
                        ProductionOrder.SetRange(ProductionOrder."Prod. Order No.", CapacityLedgerEntry."Order No.");
                        ProductionOrder.SetRange(ProductionOrder."Line No.", CapacityLedgerEntry."Order Line No.");
                        if ProductionOrder.FindFirst then begin
                            // IF CapacityLedgerEntry."No." <> 'MC0001' THEN
                            ProductDesignHeader.Reset;
                            ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", ProductionOrder."Product Design Type");
                            ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", ProductionOrder."Product Design No.");
                            ProductDesignHeader.SetRange(ProductDesignHeader."Sub Comp No.", ProductionOrder."Sub Comp No.");
                            if ProductDesignHeader.FindFirst then begin
                                LM_TillDate += ((CapacityLedgerEntry."Output Quantity" * ProductDesignHeader."Board Length (mm)- L") / ProductDesignHeader."Board Ups") / 1000;
                                M2_TillDate += CapacityLedgerEntry."Output Quantity" * ((ProductDesignHeader."Board Length (mm)- L" * ProductDesignHeader."Board Width (mm)- W") / 1000000);
                            end;
                        end;

                    until CapacityLedgerEntry.Next = 0;
                end;

                if "Machine Center"."Work Center Category" <> "Machine Center"."Work Center Category"::Corrugation then begin
                    LM_TillDate := 0;
                    M2_TillDate := 0;
                end;


                CapacityLedgerEntry.Reset;
                CapacityLedgerEntry.SetCurrentKey("Posting Date", "Work Shift Code");
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Posting Date", StartDate, EndDate);
                CapacityLedgerEntry.SetRange(CapacityLedgerEntry."No.", "Machine Center"."No.");
                if CapacityLedgerEntry.FindFirst then begin
                    repeat
                        if (CapacityLedgerEntry."Posting Date" <> PostingDate) then begin
                            cnt += 1;
                        end;
                        // NoofShift+=1 ;
                        if (ShiftCode <> CapacityLedgerEntry."Work Shift Code") then begin
                            ShiftCode := CapacityLedgerEntry."Work Shift Code";
                            NoofShift += 1;
                        end else begin
                            if (CapacityLedgerEntry."Posting Date" <> PostingDate) then
                                NoofShift += 1;
                        end;

                        if (CapacityLedgerEntry."Posting Date" <> PostingDate) then begin
                            PostingDate := CapacityLedgerEntry."Posting Date";
                        end;



                    until CapacityLedgerEntry.Next = 0;
                end;



                //Calculate Sales Inv. Values and Weight
                NetWeightSaleInvLine := 0;
                AmountSalesInvLine := 0;
                SalesInvoiceHeader.Reset;
                SalesInvoiceHeader.SetRange(SalesInvoiceHeader."Posting Date", StartDate, EndDate);
                if SalesInvoiceHeader.FindFirst then begin
                    repeat
                        SalesinvLine.Reset;
                        SalesinvLine.SetRange(SalesinvLine."Document No.", SalesInvoiceHeader."No.");
                        SalesinvLine.SetRange(SalesinvLine.Type, SalesinvLine.Type::Item);
                        SalesinvLine.SetFilter(SalesinvLine.Quantity, '<>0');
                        if SalesinvLine.FindFirst then begin
                            repeat
                                NetWeightSaleInvLine += SalesinvLine."Net Weight" / 1000;
                                if SalesInvoiceHeader."Currency Code" = '' then
                                    AmountSalesInvLine += SalesinvLine.Amount
                                else
                                    AmountSalesInvLine += SalesinvLine.Amount / SalesInvoiceHeader."Currency Factor";
                            until SalesinvLine.Next = 0;
                        end;
                    until SalesInvoiceHeader.Next = 0;
                end;

                // Calculate LPO Values and Weight
                NetWeght_SL := 0;
                Amount_SL := 0;
                OutStandingWeight := 0;

                SalesHeader.Reset;
                SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetRange(SalesHeader."Order Date", StartDate, EndDate);
                if SalesHeader.FindFirst then begin
                    repeat
                        SalesLineR.Reset;
                        SalesLineR.SetRange(SalesLineR."Document Type", SalesHeader."Document Type");
                        SalesLineR.SetRange(SalesLineR."Document No.", SalesHeader."No.");
                        SalesLineR.SetRange(SalesLineR.Type, SalesLineR.Type::Item);
                        if SalesLineR.FindFirst then begin
                            repeat
                                NetWeght_SL += SalesLineR."Order Quantity (Weight)" / 1000;
                                OutStandingWeight += SalesLineR."Outstanding  Quantity (Weight)" / 1000;
                                if SalesHeader."Currency Code" = '' then
                                    Amount_SL += SalesLineR.Amount
                                else
                                    Amount_SL += SalesLineR.Amount / SalesHeader."Currency Factor";
                            until SalesLineR.Next = 0;
                        end;
                    until SalesHeader.Next = 0;
                end;

                // Calculate WIP Value...
                // Lines added by Deepak kumar
                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
                ProductionOrder.SetRange(ProductionOrder."Planning Level Code", 0);
                if ProductionOrder.FindFirst then begin
                    repeat
                        OutputWeight := 0;
                        OutputQuantity := 0;
                        ActualOutoutQuantity := 0;
                        CapacityLedgerEntry.Reset;
                        CapacityLedgerEntry.SetRange(CapacityLedgerEntry."No.", 'MC0001');
                        CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Order Type", CapacityLedgerEntry."Order Type"::Production);
                        CapacityLedgerEntry.SetRange(CapacityLedgerEntry."Order No.", ProductionOrder."Prod. Order No.");
                        if CapacityLedgerEntry.FindFirst then begin
                            repeat
                                OutputWeight += CapacityLedgerEntry."Output Weight (Kg)";
                                OutputQuantity += CapacityLedgerEntry."Output Quantity";
                            until CapacityLedgerEntry.Next = 0;
                        end;
                        if OutputQuantity = 0 then
                            OutputQuantity := 1;

                        ActualOutoutQuantity := (ProductionOrder.Quantity - ProductionOrder."Finished Quantity");

                        if ActualOutoutQuantity < 0 then
                            ActualOutoutQuantity := Abs(ActualOutoutQuantity);
                        WITTONS += (OutputWeight / OutputQuantity) * ActualOutoutQuantity;

                    until ProductionOrder.Next = 0;
                    WITTONS := WITTONS / 1000;
                end;

                //Finished Goods Stock as on Date
                FGQTY_ILE := 0;
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Item Category Code", 'FG');
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Posting Date", 0D, EndDate);
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Remaining Quantity", '<>0');
                if ItemLedgerEntry.FindFirst then begin
                    repeat
                        Netweight := 0;
                        ItemCard.Reset;
                        ItemCard.SetRange(ItemCard."No.", ItemLedgerEntry."Item No.");
                        if ItemCard.FindFirst then
                            Netweight := ItemCard."Net Weight" / 1000000;
                        FGQTY_ILE += (ItemLedgerEntry."Remaining Quantity" * Netweight);
                    until ItemLedgerEntry.Next = 0;
                end;

                Total_Consmp := 0;
                ILE.Reset;
                ILE.SetRange(ILE."Item Category Code", 'PAPER');
                ILE.SetRange(ILE."Entry Type", ILE."Entry Type"::Consumption);
                ILE.SetRange(ILE."Posting Date", StartDate, EndDate);
                if ILE.FindFirst then begin
                    repeat
                        Total_Consmp += (ILE.Quantity) / 1000;
                    until ILE.Next = 0;
                end;
                //MESSAGE(FORMAT(Total_Consmp));
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

    trigger OnPreReport()
    begin
        DateFilter := "Machine Center".GetRangeMin("Machine Center"."Date Filter");
        EndDate := "Machine Center".GetRangeMax("Machine Center"."Date Filter");
    end;

    var
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        ProductionScheduleLine: Record "Production Schedule Line";
        ProductDesignHeader: Record "Product Design Header";
        ProductionOrder: Record "Prod. Order Line";
        TodayNos: Decimal;
        TodayLM: Decimal;
        TodayM2: Decimal;
        DateFilter: Date;
        StartDate: Date;
        EndDate: Date;
        TodaysTons: Decimal;
        BoardLength: Decimal;
        BoardWidth: Decimal;
        CalcNoOfUps: Integer;
        FGGSM: Decimal;
        Nos_TillDate: Decimal;
        LM_TillDate: Decimal;
        M2_TillDate: Decimal;
        Tons_TillDate: Decimal;
        TotalRunTime: Decimal;
        PostingDate: Date;
        cnt: Integer;
        ShiftTime: Duration;
        WorkShiftTab: Record "Work Shift";
        NoofShift: Decimal;
        SalesinvLine: Record "Sales Invoice Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        NetWeightSaleInvLine: Decimal;
        AmountSalesInvLine: Decimal;
        SalesHeader: Record "Sales Header";
        SalesLineR: Record "Sales Line";
        NetWeght_SL: Decimal;
        OutStandingWeight: Decimal;
        Amount_SL: Decimal;
        WITTONS: Decimal;
        ItemLedgerEntry: Record "Item Ledger Entry";
        FGQTY_ILE: Decimal;
        TrimWeight: Decimal;
        SchedulingLine: Record "Production Schedule Line";
        ExtraTrimWeight: Decimal;
        ItemCard: Record Item;
        Netweight: Decimal;
        ILE: Record "Item Ledger Entry";
        Papertype: Code[10];
        PaperGsm: Code[10];
        Weight_ILE: Decimal;
        Total_Consmp: Decimal;
        ScrapWeight_CLE: Decimal;
        NetweightCons: Decimal;
        ShiftCode: Code[50];
        CLE3: Record "Capacity Ledger Entry";
        OutputWeight: Decimal;
        OutputQuantity: Decimal;
        ActualOutoutQuantity: Decimal;
        MachineCenter: Record "Machine Center";
}

