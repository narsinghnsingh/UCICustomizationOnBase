codeunit 50007 "Prod.Variation Calculation"
{
    // version Prod. Variation


    trigger OnRun()
    begin
        // Lines added By Deepak Kumar
        FromDate := CalcDate('CM-1m+1d', Today);
        Todate := CalcDate('CM', Today);

        ProductionOrder.Reset;
        ProductionOrder.SetRange(ProductionOrder."Creation Date", FromDate, Todate);
        if ProductionOrder.FindFirst then begin
            repeat
                OrderWiseVariationDetails(ProductionOrder);
            until ProductionOrder.Next = 0;
        end;
    end;

    var
        FromDate: Date;
        Todate: Date;
        ProductionOrder: Record "Production Order";

    procedure UpdatePapervariationDetails(ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdDesignLine: Record "Product Design Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PaperVariation: Record "Paper Variation";
        TempGSM: Decimal;
        TempDeckle: Decimal;
        ILELineCounter: Integer;
        ItemM: Record Item;
        ProductDesignHeader: Record "Product Design Header";
        SalesOrderHeader: Record "Sales Header";
    begin
        // Lines added By Deepak Kumar
        PaperVariation.Reset;
        PaperVariation.SetRange(PaperVariation."Production Order", ProdOrder."No.");
        if PaperVariation.FindFirst then
            PaperVariation.DeleteAll(true);

        ProdOrderLine.Reset;
        ProdOrderLine.SetRange(ProdOrderLine.Status, ProdOrder.Status);
        ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", ProdOrder."No.");
        ProdOrderLine.SetFilter(ProdOrderLine."Inventory Posting Group", 'BOARD');
        if ProdOrderLine.FindFirst then begin

            repeat
                ProdDesignLine.Reset;
                ProdDesignLine.SetRange(ProdDesignLine."Product Design Type", ProdOrderLine."Product Design Type");
                ProdDesignLine.SetRange(ProdDesignLine."Product Design No.", ProdOrderLine."Product Design No.");
                ProdDesignLine.SetRange(ProdDesignLine."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                ProdDesignLine.SetRange(ProdDesignLine.Type, ProdDesignLine.Type::Item);
                if ProdDesignLine.FindFirst then begin
                    repeat
                        PaperVariation.Init;
                        PaperVariation."Production Order" := ProdOrderLine."Prod. Order No.";
                        PaperVariation."Prod. Order Line" := ProdOrderLine."Line No.";
                        PaperVariation."Paper Position" := ProdDesignLine."Paper Position";
                        PaperVariation."Planed GSM" := ProdDesignLine.GSM;
                        PaperVariation."Planed Deckle Size" := ProdDesignLine."Deckle Size";
                        ProductDesignHeader.Reset;
                        ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", ProdOrderLine."Product Design Type");
                        ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", ProdOrderLine."Product Design No.");
                        ProductDesignHeader.SetRange(ProductDesignHeader."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                        if ProductDesignHeader.FindFirst then begin
                            //IF ProdOrderLine."Finished Quantity" > ProdOrderLine.Quantity THEN BEGIN
                            PaperVariation."Expected Consumption Quantity" := ProdOrderLine."Finished Quantity" * (ProdDesignLine.Quantity / (ProductDesignHeader.Quantity / ProductDesignHeader."No. of Die Cut Ups" * ProductDesignHeader."No. of Joint"));
                            //END ELSE BEGIN
                            //  PaperVariation."Expected Consumption Quantity":=ProdOrderLine.Quantity* (ProdDesignLine.Quantity/(ProductDesignHeader.Quantity/ProductDesignHeader."No. of Die Cut Ups"*ProductDesignHeader."No. of Joint"));
                            //END;
                        end;


                        PaperVariation.Insert(true);

                        ItemLedgerEntry.Reset;
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Order Type", ItemLedgerEntry."Order Type"::Production);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Order No.", ProdOrderLine."Prod. Order No.");
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Order Line No.", ProdOrderLine."Line No.");
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Paper Position", ProdDesignLine."Paper Position");
                        if ItemLedgerEntry.FindFirst then begin
                            ILELineCounter := 0;
                            TempGSM := 0;
                            TempDeckle := 0;
                            repeat
                                ILELineCounter += 1;
                                ItemM.Get(ItemLedgerEntry."Item No.");
                                TempGSM += ItemM."Paper GSM";
                                //TempDeckle+=ItemM."Deckle Size (mm)";
                            until ItemLedgerEntry.Next = 0;
                            PaperVariation."Actual Avg. GSM" := TempGSM / ILELineCounter;
                            //PaperVariation."Actual Avg. Deckle Size":=TempDeckle/ILELineCounter;
                            PaperVariation."Variation in GSM" := (PaperVariation."Actual Avg. GSM" - PaperVariation."Planed GSM") / PaperVariation."Planed GSM" * 100;
                            PaperVariation.CalcFields(PaperVariation."Actual Avg. Deckle Size", PaperVariation."Actual Consumption Quantity");
                            PaperVariation."Variation Consumption Quantity" := ((PaperVariation."Actual Consumption Quantity" - PaperVariation."Expected Consumption Quantity") / PaperVariation."Expected Consumption Quantity") * 100;
                            PaperVariation."Variation in Deckle" := (PaperVariation."Actual Avg. Deckle Size" - PaperVariation."Planed Deckle Size") / PaperVariation."Planed Deckle Size" * 100;
                            PaperVariation.Modify(true);
                        end;
                    until ProdDesignLine.Next = 0;
                end;
            until ProdOrderLine.Next = 0;
        end;
    end;

    procedure OrderWiseVariationDetails(ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdDesignLine: Record "Product Design Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PaperVariation: Record "Production Variation Report";
        TempGSM: Decimal;
        TempDeckle: Decimal;
        ILELineCounter: Integer;
        ItemM: Record Item;
        ProductDesignHeader: Record "Product Design Header";
        TempActualCost: Decimal;
        SalesOrderHeader: Record "Sales Header";
    begin
        // Lines added By Deepak Kumar
        PaperVariation.Reset;
        PaperVariation.SetRange(PaperVariation."Prod. Order No.", ProdOrder."No.");
        if PaperVariation.FindFirst then
            PaperVariation.DeleteAll(true);

        ProdOrderLine.Reset;
        ProdOrderLine.SetRange(ProdOrderLine.Status, ProdOrder.Status);
        ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", ProdOrder."No.");
        ProdOrderLine.SetFilter(ProdOrderLine."Inventory Posting Group", 'BOARD');
        ProdOrderLine.SetFilter(ProdOrderLine."Finished Quantity", '<>0');
        if ProdOrderLine.FindFirst then begin

            repeat
                ProductDesignHeader.Reset;
                ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", ProdOrderLine."Product Design Type");
                ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", ProdOrderLine."Product Design No.");
                ProductDesignHeader.SetRange(ProductDesignHeader."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                if ProductDesignHeader.FindFirst then begin
                    PaperVariation.Init;
                    PaperVariation."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                    PaperVariation."Prod. Order Line No." := ProdOrderLine."Line No.";
                    PaperVariation."Item Code" := ProdOrderLine."Item No.";
                    PaperVariation."Item Description" := ProdOrderLine.Description;
                    SalesOrderHeader.Reset;
                    SalesOrderHeader.SetRange(SalesOrderHeader."Document Type", SalesOrderHeader."Document Type"::Order);
                    SalesOrderHeader.SetRange(SalesOrderHeader."No.", ProdOrder."Sales Order No.");
                    if SalesOrderHeader.FindFirst then begin
                        PaperVariation."LPO No." := SalesOrderHeader."External Document No.";
                        PaperVariation."Customer Code" := SalesOrderHeader."Sell-to Customer No.";
                    end;
                    PaperVariation."Job Creation Date" := ProdOrder."Creation Date";

                    PaperVariation."Customer Name" := ProdOrder."Customer Name";
                    if ProdOrder."Source Type" = ProdOrder."Source Type"::Item then
                        ItemM.Get(ProdOrder."Source No.");
                    PaperVariation."Customer Weight (Kg)" := Round((ItemM."Net Weight" * ProdOrderLine."Finished Quantity"), 0.01) / 1000;
                    ProdOrderLine.CalcFields(ProdOrderLine."Total Scrap");
                    PaperVariation."Scrap Quantity" := ProdOrderLine."Total Scrap";
                    PaperVariation."Scrap Weight (Kg)" := Round((ItemM."Net Weight" * ProdOrderLine."Total Scrap"), 0.01) / 1000;
                    PaperVariation."Planed Weight (Kg)" := Round((ProductDesignHeader."Per Box Weight (Gms)" * ProdOrderLine."Finished Quantity"), 0.01) / 1000;
                    PaperVariation."Product Design Type" := ProdOrderLine."Product Design Type";
                    PaperVariation."Product Design No." := ProdOrderLine."Product Design No.";
                    PaperVariation."Sub Comp No." := ProdOrderLine."Sub Comp No.";
                    PaperVariation."Order Quantity" := ProdOrder.Quantity;
                    PaperVariation."Board Order Quantity" := ProdOrderLine.Quantity;
                    PaperVariation."Finished Order Quantity" := ProdOrderLine."Finished Quantity";
                    PaperVariation.Insert(true);

                    //PaperVariation."Actual Weight":=

                    ProdDesignLine.Reset;
                    ProdDesignLine.SetRange(ProdDesignLine."Product Design Type", ProdOrderLine."Product Design Type");
                    ProdDesignLine.SetRange(ProdDesignLine."Product Design No.", ProdOrderLine."Product Design No.");
                    ProdDesignLine.SetRange(ProdDesignLine."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                    if ProdDesignLine.FindFirst then begin
                        repeat
                            if ProdDesignLine.Type = ProdDesignLine.Type::Item then begin
                                PaperVariation."Planed Cost Material (Amt)" += ProdDesignLine."Line Amount";
                            end;
                            if ProdDesignLine.Type = ProdDesignLine.Type::"Machine Center" then begin
                                PaperVariation."Planed Cost Process (Amt)" += ProdDesignLine."Line Amount";
                            end;
                        until ProdDesignLine.Next = 0;
                        PaperVariation."Planed Cost Process (Amt)" := (PaperVariation."Planed Cost Process (Amt)" / ProductDesignHeader.Quantity) * ProdOrderLine."Finished Quantity";
                        PaperVariation."Planed Cost Material (Amt)" := (PaperVariation."Planed Cost Material (Amt)" / ProductDesignHeader.Quantity) * ProdOrderLine."Finished Quantity";
                        PaperVariation.Modify(true);
                    end;

                    PaperVariation.CalcFields(PaperVariation."Actual Weight (Kg)", PaperVariation."Actual Cost Process (Amt)", PaperVariation."Actual Cost Material (Amt)");
                    TempActualCost := (PaperVariation."Actual Cost Process (Amt)" + PaperVariation."Actual Cost Material (Amt)");
                    if TempActualCost = 0 then
                        TempActualCost := 1;
                    PaperVariation."Variation in Cost (%)" := (((TempActualCost) - (PaperVariation."Planed Cost Process (Amt)" + PaperVariation."Planed Cost Material (Amt)")) /
                    (PaperVariation."Planed Cost Process (Amt)" + PaperVariation."Planed Cost Material (Amt)")) * 100;
                    PaperVariation."Variation Planed vs Actual (%)" := ((PaperVariation."Actual Weight (Kg)" - PaperVariation."Planed Weight (Kg)") / PaperVariation."Planed Weight (Kg)") * 100;
                    PaperVariation."Variation in Produces Quantity" := ((PaperVariation."Finished Order Quantity" - PaperVariation."Board Order Quantity") / PaperVariation."Board Order Quantity") * 100;

                    PaperVariation.Modify(true);
                    //PaperVariation."Scrap Weight":=


                end;
            until ProdOrderLine.Next = 0;
        end;
    end;
}

