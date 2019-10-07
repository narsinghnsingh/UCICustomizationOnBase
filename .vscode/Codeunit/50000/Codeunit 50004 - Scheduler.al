codeunit 50004 Scheduler
{
    // version Prod. Schedule


    trigger OnRun()
    begin
    end;

    var
        ProductionScheduleHeader: Record "Production Schedule";
        ProductionScheduleLine: Record "Production Schedule Line";
        ProductionOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutLine: Record "Prod. Order Routing Line";
        ItemMaster: Record Item;
        ProdOrderCompLine: Record "Prod. Order Component";
        MfgSetup: Record "Manufacturing Setup";
        Sam0001: Label '<>''''';
        ProgressWindow: Dialog;
        SameDaySchedule: Record "Production Schedule";
        SameDayScheduleLine: Record "Production Schedule Line";
        ScheduleAlreadyExist: Boolean;
        Sam0002: Label '<>0';
        ExistingProductionScheduleLine: Record "Production Schedule Line";

    procedure CreateBaseData(ScheduleHeader: Record "Production Schedule")
    var
        FromDate: Date;
        ToDate: Date;
        EstimateHeader: Record "Product Design Header";
        SalesLine: Record "Sales Line";
    begin
        // Lines added By Deepak Kumar
        ProductionScheduleHeader.Reset;
        ProductionScheduleHeader.SetRange(ProductionScheduleHeader."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleHeader.SetRange(ProductionScheduleHeader."Machine No.", ScheduleHeader."Machine No.");
        if ProductionScheduleHeader.FindFirst then begin
            FromDate := WorkDate - 10;
            ToDate := WorkDate + 10;
            ProductionScheduleLine.Reset;
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ProductionScheduleHeader."Schedule No.");
            if ProductionScheduleLine.FindSet then
                ProductionScheduleLine.DeleteAll(true);

            ProductionOrder.Reset;
            ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
            ProductionOrder.SetRange(ProductionOrder."Eliminate in Prod. Schedule", false);
            // ProductionOrder.SETRANGE(ProductionOrder."Due Date",FromDate,ToDate);
            if ProductionOrder.FindFirst then begin
                ProgressWindow.Open('Production Order No. #1#######');
                repeat
                    ProgressWindow.Update(1, ProductionOrder."No.");
                    ProdOrderRoutLine.Reset;
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine.Status, ProductionOrder.Status);
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine."Prod. Order No.", ProductionOrder."No.");
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine.Type, ProdOrderRoutLine.Type::"Machine Center");
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine."No.", ProductionScheduleHeader."Machine No.");
                    if ProdOrderRoutLine.FindFirst then begin

                        repeat
                            ProdOrderLine.Reset;
                            ProdOrderLine.SetRange(ProdOrderLine.Status, ProdOrderRoutLine.Status);
                            ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", ProdOrderRoutLine."Prod. Order No.");
                            ProdOrderLine.SetRange(ProdOrderLine."Line No.", ProdOrderRoutLine."Routing Reference No.");
                            ProdOrderLine.FindFirst;
                            ProdOrderRoutLine.CalcFields(ProdOrderRoutLine."Actual Output Quantity");
                            if (ProdOrderLine."Remaining Quantity" > 0) and (ProdOrderRoutLine."Actual Output Quantity" < ProdOrderLine.Quantity) then begin
                                ItemMaster.Get(ProdOrderLine."Item No.");

                                ProductionScheduleLine.Init;
                                ProductionScheduleLine."Schedule No." := ProductionScheduleHeader."Schedule No.";
                                ProductionScheduleLine."Prod. Order No." := ProductionOrder."No.";
                                ProductionScheduleLine."Prod. Order Line No." := ProdOrderRoutLine."Routing Reference No.";
                                ProductionScheduleLine."Schedule Date" := ProductionScheduleHeader."Schedule Date";
                                ProductionScheduleLine."Requested Delivery Date" := ProductionOrder."Due Date";
                                ProductionScheduleLine."Prod. Order Quanity" := ProdOrderLine.Quantity;
                                ProductionScheduleLine."Operation No" := ProdOrderRoutLine."Operation No.";
                                //ProductionScheduleLine."Quantity To Schedule":=ProdOrderLine."Remaining Quantity";
                                ProductionScheduleLine."Machine No." := ProdOrderRoutLine."No.";
                                ProductionScheduleLine."Item Code" := ProdOrderLine."Item No.";
                                ProductionScheduleLine."Item Description" := ItemMaster.Description;//ProdOrderLine.Description;
                                ProductionScheduleLine."Customer Name" := ProductionOrder."Customer Name";
                                ProductionScheduleLine."No. Of Ply" := ItemMaster."No. of Ply";
                                ProductionScheduleLine.Flute := ItemMaster."Flute Type";
                                ProductionScheduleLine."Flute 1" := ItemMaster."Flute 1";
                                ProductionScheduleLine."Flute 2" := ItemMaster."Flute 2";
                                ProductionScheduleLine."Flute 3" := ItemMaster."Flute 3";
                                ProductionScheduleLine."Top Colour" := ItemMaster."Color Code";
                                ProductionScheduleLine.SchedulerIdentifier := ProductionOrder."No." + Format(ProdOrderRoutLine."Routing Reference No.");
                                //26/03/16 Deepak
                                if ProductionOrder."Source Type" = ProductionOrder."Source Type"::Item then begin
                                    ProductionScheduleLine."FG Item Number" := ProductionOrder."Source No.";
                                    ProductionScheduleLine."FG Item Description" := ProductionOrder.Description;
                                end;


                                ProductionScheduleLine."Product Design No." := ProdOrderLine."Product Design No.";
                                ProductionScheduleLine."Estimation Sub Job No." := ProdOrderLine."Sub Comp No.";
                                EstimateHeader.Reset;
                                EstimateHeader.SetRange(EstimateHeader."Product Design No.", ProdOrderLine."Product Design No.");
                                EstimateHeader.SetRange(EstimateHeader."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                                if EstimateHeader.FindFirst then begin
                                    ProductionScheduleLine."No. Of Ply" := EstimateHeader."No. of Ply";
                                    ProductionScheduleLine."Board Length(mm)" := EstimateHeader."Board Length (mm)- L";
                                    ProductionScheduleLine."Board Width(mm)" := EstimateHeader."Board Width (mm)- W";
                                    ProductionScheduleLine."No. of Ups (Estimated)" := EstimateHeader."Board Ups";
                                    ProductionScheduleLine."Trim Product Design" := EstimateHeader."Trim Size (mm)";
                                    ProductionScheduleLine."Cut Size (mm)" := EstimateHeader."Cut Size (mm)";
                                    ProductionScheduleLine."FG GSM" := EstimateHeader.Grammage;
                                    ProductionScheduleLine."No of Die Cut" := EstimateHeader."No. of Die Cut Ups";
                                    ProductionScheduleLine."No. of Joint" := EstimateHeader."No. of Joint";
                                end;
                                ProductionScheduleLine."Sales Order No" := ProductionOrder."Sales Order No.";
                                SalesLine.Reset;
                                SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
                                SalesLine.SetRange(SalesLine."Document No.", ProductionOrder."Sales Order No.");
                                SalesLine.SetRange(SalesLine."Line No.", ProductionOrder."Sales Order Line No.");
                                if SalesLine.FindFirst then begin
                                    ProductionScheduleLine."Customer Order No." := SalesLine."External Doc. No.";
                                    ProductionScheduleLine."Sales Order Quantity" := SalesLine.Quantity;
                                end;


                                // Lines updated By Deepak
                                ScheduleAlreadyExist := false;
                                SameDayScheduleLine.Reset;
                                SameDayScheduleLine.SetRange(SameDayScheduleLine."Prod. Order No.", ProdOrderLine."Prod. Order No.");
                                SameDayScheduleLine.SetRange(SameDayScheduleLine."Prod. Order Line No.", ProdOrderLine."Line No.");
                                SameDayScheduleLine.SetRange(SameDayScheduleLine."Schedule Line", true);
                                SameDayScheduleLine.SetRange(SameDayScheduleLine.Published, true);
                                SameDayScheduleLine.SetRange(SameDayScheduleLine."Schedule Closed", false);
                                SameDayScheduleLine.SetRange(SameDayScheduleLine."Schedule Date", ProductionScheduleHeader."Schedule Date");
                                if SameDayScheduleLine.FindFirst then begin
                                    // MESSAGE(SameDayScheduleLine.GETFILTERS);
                                    ScheduleAlreadyExist := true;
                                end;


                                ProductionScheduleLine."Board Length(mm)" := ItemMaster."Board Length";
                                ProductionScheduleLine."Board Width(mm)" := ItemMaster."Board Width";
                                ProductionScheduleLine."Product Design No." := ProductionOrder."Estimate Code";
                                if ScheduleAlreadyExist = false then begin
                                    ProductionScheduleLine.Insert(true);
                                    UpdateGSMIdentifier(ProductionScheduleHeader);
                                    ClacUpsDeckleLength(ProductionScheduleHeader);


                                end;
                            end;
                        until ProdOrderRoutLine.Next = 0;
                    end;
                until ProductionOrder.Next = 0;
                ProgressWindow.Close;
            end;
        end;
        CreateScheduleWiseReqQty();
    end;

    procedure UpdateGSMIdentifier(ScheduleHeader: Record "Production Schedule")
    var
        TempGSMTypeIdentifier: Code[200];
        TempDeckleSize: Decimal;
    begin
        // Lines added By Deepak Kumar
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        if ProductionScheduleLine.FindFirst then begin
            repeat
                ProdOrderCompLine.Reset;
                ProdOrderCompLine.SetCurrentKey(Status, "Prod. Order No.", "Paper Position");
                ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Schedule Component", false);
                if ProdOrderCompLine.FindFirst then begin
                    TempGSMTypeIdentifier := '';
                    TempDeckleSize := 5000;
                    repeat
                        ItemMaster.Get(ProdOrderCompLine."Item No.");
                        TempGSMTypeIdentifier := TempGSMTypeIdentifier + Format(ItemMaster."Paper GSM") + ItemMaster."Paper Type";

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Liner1 then begin
                            if ProductionScheduleLine."Top Colour" = '' then
                                ProductionScheduleLine."Top Colour" := ItemMaster."Paper Type";
                        end;
                        if TempDeckleSize > ItemMaster."Deckle Size (mm)" then
                            TempDeckleSize := ItemMaster."Deckle Size (mm)";
                        // Lines for Update Layer Wise paper
                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Liner1 then
                            ProductionScheduleLine."DB Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Flute1 then
                            ProductionScheduleLine."1M Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Liner2 then
                            ProductionScheduleLine."1L Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Flute2 then
                            ProductionScheduleLine."2M Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Liner3 then
                            ProductionScheduleLine."2L Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                    until ProdOrderCompLine.Next = 0;
                    ProductionScheduleLine."Planned Deckle Size(mm)" := TempDeckleSize;
                    ProductionScheduleLine."GSM Identifier" := TempGSMTypeIdentifier;
                    ProductionScheduleLine.Modify(true);
                end;
            until ProductionScheduleLine.Next = 0;
        end;
    end;

    procedure ClacUpsDeckleLength(ScheduleHeader: Record "Production Schedule")
    var
        TempBoardUps: Integer;
        TempExtraTrim: Decimal;
    begin
        // Lines added BY Deepak kumar
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        if ProductionScheduleLine.FindFirst then begin
            repeat
                TempBoardUps := 0;
                if ScheduleHeader."Trim Calculation Type" = ScheduleHeader."Trim Calculation Type"::"Product Design" then begin
                    if ProductionScheduleLine."Board Width(mm)" <> 0 then
                        TempBoardUps := Round((((ScheduleHeader."Machine Max Deckle Size") - ProductionScheduleLine."Trim Product Design") / ProductionScheduleLine."Board Width(mm)"), 1, '<');

                    if TempBoardUps > ScheduleHeader."Machine Max Ups" then begin
                        ProductionScheduleLine."Calculated No. of Ups" := ScheduleHeader."Machine Max Ups";
                    end else begin
                        ProductionScheduleLine."Calculated No. of Ups" := TempBoardUps;
                    end;
                    if ProductionScheduleLine."Calculated No. of Ups" = 0 then
                        ProductionScheduleLine."Calculated No. of Ups" := 1;
                    ProductionScheduleLine."Linear Length(Mtr)" := ((ProductionScheduleLine."Quantity To Schedule" * ProductionScheduleLine."Board Length(mm)") / ProductionScheduleLine."Calculated No. of Ups") / 1000;
                    ProductionScheduleLine."Qty to Schedule Net Weight" := ((ProductionScheduleLine."Board Length(mm)" * ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."FG GSM") / 1000000000) * ProductionScheduleLine."Quantity To Schedule";
                    ProductionScheduleLine."Qty to Schedule M2 Weight" := ((ProductionScheduleLine."Board Length(mm)" * ProductionScheduleLine."Board Width(mm)") / 1000000) * ProductionScheduleLine."Quantity To Schedule";
                    ProductionScheduleLine."Extra Trim(mm)" := ((ScheduleHeader."Machine Max Deckle Size") - ProductionScheduleLine."Trim Product Design") - ((ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups"));
                    ProductionScheduleLine."Trim (mm)" := (ScheduleHeader."Machine Max Deckle Size" - (ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups"));
                    ProductionScheduleLine."Trim Weight" := ((((ProductionScheduleLine."Trim (mm)" * ProductionScheduleLine."Cut Size (mm)") * ProductionScheduleLine."FG GSM") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                    ProductionScheduleLine."Extra Trim Weight" := ((((ProductionScheduleLine."Extra Trim(mm)" * ProductionScheduleLine."Cut Size (mm)") * ProductionScheduleLine."FG GSM") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                    ProductionScheduleLine.Modify(true);

                end else begin
                    if ProductionScheduleLine."Board Width(mm)" <> 0 then
                        TempBoardUps := Round((((ScheduleHeader."Machine Max Deckle Size") - ScheduleHeader."Min Trim") / ProductionScheduleLine."Board Width(mm)"), 1, '<');

                    if TempBoardUps > ScheduleHeader."Machine Max Ups" then begin
                        ProductionScheduleLine."Calculated No. of Ups" := ScheduleHeader."Machine Max Ups";
                    end else begin
                        ProductionScheduleLine."Calculated No. of Ups" := TempBoardUps;
                    end;
                    if ProductionScheduleLine."Calculated No. of Ups" = 0 then
                        ProductionScheduleLine."Calculated No. of Ups" := 1;

                    ProductionScheduleLine."Linear Length(Mtr)" := ((ProductionScheduleLine."Quantity To Schedule" * ProductionScheduleLine."Board Length(mm)") / ProductionScheduleLine."Calculated No. of Ups") / 1000;
                    ProductionScheduleLine."Qty to Schedule Net Weight" := ((ProductionScheduleLine."Board Length(mm)" * ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."FG GSM") / 1000000000) * ProductionScheduleLine."Quantity To Schedule";
                    ProductionScheduleLine."Qty to Schedule M2 Weight" := ((ProductionScheduleLine."Board Length(mm)" * ProductionScheduleLine."Board Width(mm)") / 1000000000) * ProductionScheduleLine."Quantity To Schedule";
                    ProductionScheduleLine."Extra Trim(mm)" := ((ScheduleHeader."Machine Max Deckle Size") - ScheduleHeader."Min Trim") - ((ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups"));
                    ProductionScheduleLine."Trim (mm)" := (ScheduleHeader."Machine Max Deckle Size" - (ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups"));
                    ProductionScheduleLine."Trim Weight" := ((((ProductionScheduleLine."Trim (mm)" * ProductionScheduleLine."Cut Size (mm)") * ProductionScheduleLine."FG GSM") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                    ProductionScheduleLine."Extra Trim Weight" := ((((ProductionScheduleLine."Extra Trim(mm)" * ProductionScheduleLine."Cut Size (mm)") * ProductionScheduleLine."FG GSM") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                    ProductionScheduleLine.Modify(true);
                end;
            until ProductionScheduleLine.Next = 0;
        end;
    end;

    procedure CreateDeckleLine(ScheduleHeader: Record "Production Schedule")
    var
        DeckleMaster: Record "Master Deckle Size";
        BaseTableDeckle: Record "Schedule Base Table 1";
        PaperTypeBaseTable: Record "Schedule Base Table 2";
        PaserGSMBaseTable: Record "Schedule Base Table 3";
        ProductionScheduleLineN: Record "Production Schedule Line";
        TempBoardUps: Integer;
        TempExtraTrim: Decimal;
    begin
        // Lines added By Deepak Kumar

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetFilter(ProductionScheduleLine."Deckle Size Schedule(mm)", Sam0001);//Sam0001=<>''
        if ProductionScheduleLine.FindSet then
            ProductionScheduleLine.DeleteAll(true);

        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        if BaseTableDeckle.FindSet then
            BaseTableDeckle.DeleteAll(true);

        PaperTypeBaseTable.Reset;
        PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        if PaperTypeBaseTable.FindSet then
            PaperTypeBaseTable.DeleteAll(true);

        PaserGSMBaseTable.Reset;
        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        if PaserGSMBaseTable.FindSet then
            PaserGSMBaseTable.DeleteAll(true);



        DeckleMaster.Reset;
        if DeckleMaster.FindFirst then begin
            repeat
                BaseTableDeckle.Init;
                BaseTableDeckle."Schedule No." := ScheduleHeader."Schedule No.";
                BaseTableDeckle."Deckle Size" := DeckleMaster."Deckle Size";
                BaseTableDeckle."Deckle Size(Num)" := DeckleMaster."Deckle Size(Num)";
                BaseTableDeckle.Insert(true);

            until DeckleMaster.Next = 0;
        end;
    end;

    procedure CalculateJobLines(ScheduleHeader: Record "Production Schedule")
    var
        BaseTableDeckle: Record "Schedule Base Table 1";
        ProductionScheduleLineN: Record "Production Schedule Line";
        TempBoardUps: Integer;
        TempExtraTrim: Decimal;
        DeckleMaster: Record "Master Deckle Size";
    begin
        // Lines added BY Deepak Kumar
        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        if BaseTableDeckle.FindFirst then begin
            repeat
                ProductionScheduleLine.Reset;
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", false);
                if ProductionScheduleLine.FindFirst then begin
                    repeat
                        if (ProductionScheduleLine."Board Width(mm)" + ProductionScheduleLine."Trim Product Design") <= BaseTableDeckle."Deckle Size(Num)" then begin
                            ProductionScheduleLineN.Init;
                            ProductionScheduleLineN := ProductionScheduleLine;
                            ProductionScheduleLineN."Deckle Size Schedule(mm)" := BaseTableDeckle."Deckle Size";
                            ProductionScheduleLineN."Schedule Line" := true;
                            ProductionScheduleLineN.Insert(true);

                            TempBoardUps := 0;

                            DeckleMaster.Get(BaseTableDeckle."Deckle Size");
                            if ScheduleHeader."Trim Calculation Type" = ScheduleHeader."Trim Calculation Type"::"Product Design" then begin

                                if ProductionScheduleLineN."Board Width(mm)" <> 0 then
                                    TempBoardUps := Round((((DeckleMaster."Deckle Size(Num)") - ProductionScheduleLineN."Trim Product Design") / ProductionScheduleLineN."Board Width(mm)"), 1, '<');

                                if TempBoardUps > ScheduleHeader."Machine Max Ups" then begin
                                    ProductionScheduleLineN."Calculated No. of Ups" := ScheduleHeader."Machine Max Ups";
                                end else begin
                                    ProductionScheduleLineN."Calculated No. of Ups" := TempBoardUps;
                                end;

                                if ProductionScheduleLineN."Calculated No. of Ups" = 0 then
                                    ProductionScheduleLineN."Calculated No. of Ups" := 1;

                                ProductionScheduleLineN."Linear Length(Mtr)" := ((ProductionScheduleLineN."Quantity To Schedule" * ProductionScheduleLineN."Board Length(mm)") / ProductionScheduleLineN."Calculated No. of Ups") / 1000;
                                ProductionScheduleLineN."Qty to Schedule Net Weight" := ((ProductionScheduleLineN."Board Length(mm)" * ProductionScheduleLineN."Board Width(mm)"
                                           * ProductionScheduleLineN."FG GSM") / 1000000000) * ProductionScheduleLineN."Quantity To Schedule";
                                ProductionScheduleLineN."Qty to Schedule M2 Weight" := ((ProductionScheduleLineN."Board Length(mm)" * ProductionScheduleLineN."Board Width(mm)") / 1000000) * ProductionScheduleLineN."Quantity To Schedule";

                                ProductionScheduleLineN."Extra Trim(mm)" := ((DeckleMaster."Deckle Size(Num)") - ProductionScheduleLineN."Trim Product Design") - ((ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups"));
                                ProductionScheduleLineN."Trim %" := (ProductionScheduleLineN."Extra Trim(mm)" / DeckleMaster."Deckle Size(Num)") * 100;
                                ProductionScheduleLineN."Trim (mm)" := (DeckleMaster."Deckle Size(Num)" - (ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups"));
                                ProductionScheduleLineN."Trim Weight" := (((ProductionScheduleLineN."Trim (mm)" * ProductionScheduleLineN."Cut Size (mm)" * ProductionScheduleLineN."FG GSM") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                                ProductionScheduleLineN."Extra Trim Weight" := (((ProductionScheduleLineN."Extra Trim(mm)" * ProductionScheduleLineN."Cut Size (mm)" * ProductionScheduleLineN."FG GSM") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                            end else begin
                                if ProductionScheduleLineN."Board Width(mm)" <> 0 then
                                    TempBoardUps := Round((((DeckleMaster."Deckle Size(Num)") - ScheduleHeader."Min Trim") / ProductionScheduleLineN."Board Width(mm)"), 1, '<');

                                if TempBoardUps > ScheduleHeader."Machine Max Ups" then begin
                                    ProductionScheduleLineN."Calculated No. of Ups" := ScheduleHeader."Machine Max Ups";
                                end else begin
                                    ProductionScheduleLineN."Calculated No. of Ups" := TempBoardUps;
                                end;
                                if ProductionScheduleLineN."Calculated No. of Ups" = 0 then
                                    ProductionScheduleLineN."Calculated No. of Ups" := 1;
                                ProductionScheduleLineN."Linear Length(Mtr)" := ((ProductionScheduleLineN."Quantity To Schedule" * ProductionScheduleLineN."Board Length(mm)") / ProductionScheduleLineN."Calculated No. of Ups") / 1000;
                                ProductionScheduleLineN."Qty to Schedule Net Weight" := ((ProductionScheduleLineN."Board Length(mm)" * ProductionScheduleLineN."Board Width(mm)"
                                           * ProductionScheduleLineN."FG GSM") / 1000000000) * ProductionScheduleLineN."Quantity To Schedule";
                                ProductionScheduleLineN."Qty to Schedule M2 Weight" := ((ProductionScheduleLineN."Board Length(mm)" * ProductionScheduleLineN."Board Width(mm)") / 1000000) * ProductionScheduleLineN."Quantity To Schedule";

                                ProductionScheduleLineN."Extra Trim(mm)" := ((DeckleMaster."Deckle Size(Num)") - ScheduleHeader."Min Trim") - ((ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups"));
                                ProductionScheduleLineN."Trim %" := (ProductionScheduleLineN."Extra Trim(mm)" / DeckleMaster."Deckle Size(Num)") * 100;
                                ProductionScheduleLineN."Trim (mm)" := (DeckleMaster."Deckle Size(Num)" - (ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups"));
                                ProductionScheduleLineN."Trim Weight" := (((ProductionScheduleLineN."Trim (mm)" * ProductionScheduleLineN."Cut Size (mm)" * ProductionScheduleLineN."FG GSM") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                                ProductionScheduleLineN."Extra Trim Weight" := (((ProductionScheduleLineN."Extra Trim(mm)" * ProductionScheduleLineN."Cut Size (mm)" * ProductionScheduleLineN."FG GSM") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                            end;

                            MfgSetup.Get;

                            if ProductionScheduleLineN."Extra Trim(mm)" > MfgSetup."Extra Trim - Max" then begin
                                ProductionScheduleLineN.Possible := false;
                                ProductionScheduleLineN."Marked for Publication" := false;
                            end else begin
                                ProductionScheduleLineN.Possible := true;
                                ProductionScheduleLineN."Marked for Publication" := true;
                            end;

                            ProductionScheduleLineN.Modify(true);
                        end;
                    until ProductionScheduleLine.Next = 0;
                end;
            until BaseTableDeckle.Next = 0;
        end;
    end;

    procedure CreateTypeGSM(ScheduleHeader: Record "Production Schedule")
    var
        BaseTableDeckle: Record "Schedule Base Table 1";
        PaperTypeBaseTable: Record "Schedule Base Table 2";
        PaserGSMBaseTable: Record "Schedule Base Table 3";
    begin
        // Lines added by deepak Kumar
        PaperTypeBaseTable.Reset;
        PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        if PaperTypeBaseTable.FindSet then
            PaperTypeBaseTable.DeleteAll(true);

        PaserGSMBaseTable.Reset;
        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        if PaserGSMBaseTable.FindSet then
            PaserGSMBaseTable.DeleteAll(true);

        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        if BaseTableDeckle.FindFirst then begin
            repeat
                ProductionScheduleLine.Reset;
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", BaseTableDeckle."Schedule No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Deckle Size Schedule(mm)", BaseTableDeckle."Deckle Size");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
                if ProductionScheduleLine.FindFirst then begin
                    repeat
                        ProdOrderCompLine.Reset;
                        ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
                        ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                        ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                        ProdOrderCompLine.SetRange(ProdOrderCompLine."Schedule Component", false);
                        if ProdOrderCompLine.FindFirst then begin
                            repeat
                                ItemMaster.Get(ProdOrderCompLine."Item No.");
                                // Update Paper Type
                                PaperTypeBaseTable.Reset;
                                PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Schedule No.", ProductionScheduleLine."Schedule No.");
                                PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Deckle Size", BaseTableDeckle."Deckle Size");
                                PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Paper Type", ItemMaster."Paper Type");
                                if not PaperTypeBaseTable.FindFirst then begin
                                    PaperTypeBaseTable.Init;
                                    PaperTypeBaseTable."Schedule No." := BaseTableDeckle."Schedule No.";
                                    PaperTypeBaseTable."Deckle Size" := BaseTableDeckle."Deckle Size";
                                    PaperTypeBaseTable."Deckle Size(Num)" := BaseTableDeckle."Deckle Size(Num)";
                                    PaperTypeBaseTable."Paper Type" := ItemMaster."Paper Type";
                                    PaperTypeBaseTable."Total Requirement (kg)" := ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule";
                                    PaperTypeBaseTable.Insert(true);
                                end else begin
                                    PaperTypeBaseTable."Total Requirement (kg)" := PaperTypeBaseTable."Total Requirement (kg)" + (ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule");
                                    PaperTypeBaseTable.Modify(true);
                                end;
                                // Update Paper GSM
                                PaserGSMBaseTable.Reset;
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Schedule No.", BaseTableDeckle."Schedule No.");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Deckle Size", BaseTableDeckle."Deckle Size");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Paper Type", ItemMaster."Paper Type");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Paper GSM", Format(ItemMaster."Paper GSM"));
                                if not PaserGSMBaseTable.FindFirst then begin
                                    PaserGSMBaseTable.Init;
                                    PaserGSMBaseTable."Schedule No." := BaseTableDeckle."Schedule No.";
                                    PaserGSMBaseTable."Deckle Size" := BaseTableDeckle."Deckle Size";
                                    PaserGSMBaseTable."Deckle Size(Num)" := BaseTableDeckle."Deckle Size(Num)";
                                    PaserGSMBaseTable."Paper Type" := ItemMaster."Paper Type";
                                    PaserGSMBaseTable."Paper GSM" := Format(ItemMaster."Paper GSM");
                                    PaserGSMBaseTable."Paper GSM(Num)" := (ItemMaster."Paper GSM");

                                    PaserGSMBaseTable."Total Requirement (kg)" := ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule";
                                    PaserGSMBaseTable.Insert(true);
                                end else begin
                                    PaserGSMBaseTable."Total Requirement (kg)" := PaserGSMBaseTable."Total Requirement (kg)" + ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule";
                                    PaserGSMBaseTable.Modify(true);
                                end;
                            until ProdOrderCompLine.Next = 0;
                        end;
                    until ProductionScheduleLine.Next = 0;
                end;
            until BaseTableDeckle.Next = 0;
        end;
    end;

    procedure PriorityTheDeckle(ScheduleHeader: Record "Production Schedule")
    var
        BaseTableDeckle: Record "Schedule Base Table 1";
        TempPriority: Integer;
    begin
        // Lines added BY Deepak Kumar
        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        if BaseTableDeckle.FindFirst then begin
            repeat
                BaseTableDeckle.CalcFields(BaseTableDeckle."No. of Jobs(Within Trimlimit)");
                BaseTableDeckle."No Of Job(Internal)" := BaseTableDeckle."No. of Jobs(Within Trimlimit)";
                BaseTableDeckle.Modify(true);
                //for Manage Priority on JOB
                MakePriorityOnJob(ScheduleHeader, BaseTableDeckle."Deckle Size");

            until BaseTableDeckle.Next = 0;
        end;
        TempPriority := 1;
        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        BaseTableDeckle.SetCurrentKey("No Of Job(Internal)");
        BaseTableDeckle.Ascending(false);
        if BaseTableDeckle.FindFirst then begin
            repeat
                BaseTableDeckle."Priority by System" := TempPriority;
                TempPriority += 1;
                BaseTableDeckle.Modify(true);
            until BaseTableDeckle.Next = 0;
        end;
    end;

    procedure UpdateFluteChnage(ScheduleHeader: Record "Production Schedule")
    var
        BaseTableDeckle: Record "Schedule Base Table 1";
        TempFlute: Text;
        ChangeCounter: Integer;
    begin
        // Lines added BY Deepak Kumar
        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        if BaseTableDeckle.FindFirst then begin
            repeat
                ProductionScheduleLine.Reset;
                ProductionScheduleLine.SetCurrentKey("Schedule No.", "No. Of Ply", Flute, "GSM Identifier");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", BaseTableDeckle."Schedule No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
                ProductionScheduleLine.SetFilter(ProductionScheduleLine."Deckle Size Schedule(mm)", BaseTableDeckle."Deckle Size");
                ProductionScheduleLine.SetRange(ProductionScheduleLine.Possible, true);
                if ProductionScheduleLine.FindFirst then begin
                    TempFlute := 'x';
                    ChangeCounter := 0;
                    repeat
                        if TempFlute <> Format(ProductionScheduleLine."Flute 1") then begin
                            TempFlute := Format(ProductionScheduleLine."Flute 1");
                            ChangeCounter += 1;
                        end;

                    until ProductionScheduleLine.Next = 0;
                    BaseTableDeckle."No. of Flute Change" := ChangeCounter;
                    BaseTableDeckle.Modify(true);

                end;
            until BaseTableDeckle.Next = 0;
        end;
    end;

    procedure UpdateInventory(ScheduleHeader: Record "Production Schedule")
    begin
        // Lines added BY Deepak Kumar
    end;

    procedure PublishSchedule(ScheduleHeader: Record "Production Schedule")
    var
        DeckleBaseTable: Record "Schedule Base Table 1";
        ProdOrderComp: Record "Prod. Order Component";
        Sam001: Label '<>''''';
        CompItem: Record Item;
        BOMLine: Integer;
        TempProdComponentLine: Record "Prod. Order Component";
        PaperGSMLine: Record "Schedule Base Table 3";
        TempQtyPer: Decimal;
        ProdOrder: Record "Production Order";
    begin
        // Lines added BY Deepak Kumar

        ScheduleHeader.TestField(ScheduleHeader.Status, ScheduleHeader.Status::Open);
        if ScheduleHeader."Schedule Published" then
            Error('Schedule %1 already published', ScheduleHeader."Schedule No.");

        if ScheduleHeader."Manual Assortment" = true then begin
            ProductionScheduleLine.Reset;
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
            if ProductionScheduleLine.FindFirst then begin
                ProgressWindow.Open('Production Order No. #1#######');
                repeat
                    ProgressWindow.Update(1, ProductionScheduleLine."Prod. Order No.");
                    TempProdComponentLine.Reset;
                    TempProdComponentLine.SetCurrentKey("Prod. Order No.", "Prod. Order Line No.", "Line No.", Status);
                    TempProdComponentLine.SetRange(TempProdComponentLine.Status, TempProdComponentLine.Status::Released);
                    TempProdComponentLine.SetRange(TempProdComponentLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                    TempProdComponentLine.SetRange(TempProdComponentLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                    if TempProdComponentLine.FindLast then
                        BOMLine := TempProdComponentLine."Line No.";

                    ProdOrderComp.Reset;
                    ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                    ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                    ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                    ProdOrderComp.SetFilter(ProdOrderComp."Paper Position", Sam001);
                    ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", '');
                    ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", false);
                    if ProdOrderComp.FindFirst then begin
                        repeat
                            PaperGSMLine.Reset;
                            PaperGSMLine.SetRange(PaperGSMLine."Schedule No.", ProductionScheduleLine."Schedule No.");
                            PaperGSMLine.SetRange(PaperGSMLine."Item No.", ProdOrderComp."Item No.");
                            if PaperGSMLine.FindFirst then begin
                                ProdOrderCompLine.Init;
                                ProdOrderCompLine := ProdOrderComp;
                                BOMLine += 10;
                                ProdOrderCompLine."Line No." := BOMLine;
                                ProdOrderCompLine."Expected Quantity" := 0;
                                ProdOrderCompLine."Remaining Quantity" := 0;
                                ProdOrderCompLine."Remaining Qty. (Base)" := 0;
                                ProdOrderCompLine."Expected Qty. (Base)" := 0;

                                if PaperGSMLine."New Item Number" = '' then
                                    ProdOrderCompLine.Validate(ProdOrderCompLine."Item No.", PaperGSMLine."Item No.")
                                else
                                    ProdOrderCompLine.Validate(ProdOrderCompLine."Item No.", PaperGSMLine."New Item Number");

                                ProdOrderCompLine."Prod Schedule No." := ProductionScheduleLine."Schedule No.";
                                CompItem.Get(ProdOrderComp."Item No.");
                                if CompItem."Paper GSM" <> 0 then
                                    TempQtyPer := (ProdOrderComp."Quantity per" / CompItem."Paper GSM") * PaperGSMLine."Paper GSM(Num)";
                                ProdOrderCompLine."Quantity per" := TempQtyPer;
                                ProdOrderCompLine.Validate("Expected Quantity", ProductionScheduleLine."Quantity To Schedule" * TempQtyPer);
                                ProdOrderCompLine.Validate("Remaining Quantity", ProductionScheduleLine."Quantity To Schedule" * TempQtyPer);
                                ProdOrderCompLine.Validate(ProdOrderCompLine."Unit Cost");
                                ProdOrderCompLine."Schedule Component" := true;
                                ProdOrderCompLine.Insert(true);
                            end else begin
                                ProgressWindow.Close;
                                Error('Item not found with following specification, Deckle Size %1 Paper Type %2 Paper GSM %3');
                            end;

                        until ProdOrderComp.Next = 0;
                    end;
                    ProductionScheduleLine.Published := true;
                    ProductionScheduleLine.Modify(true);
                    //Updated By Deepak Kumar
                    ProdOrder.Reset;
                    ProdOrder.SetRange(ProdOrder.Status, ProdOrder.Status::Released);
                    ProdOrder.SetRange(ProdOrder."No.", ProductionScheduleLine."Prod. Order No.");
                    if ProdOrder.FindFirst then begin
                        ProdOrder."Prod Status" := ProdOrder."Prod Status"::"In process";
                        ProdOrder.Modify(true);
                    end;
                until ProductionScheduleLine.Next = 0;
                ScheduleHeader."Schedule Published" := true;
                ScheduleHeader.Status := ScheduleHeader.Status::Confirmed;
                ScheduleHeader.Modify(true);
                DeleteExtraLines(ScheduleHeader);
                ProgressWindow.Close;
                Message('Corrugation Schedule is Published for Production, Order component also created for schedule %1', DeckleBaseTable."Schedule No.");
            end;
        end else begin

            DeckleBaseTable.Reset;
            DeckleBaseTable.SetRange(DeckleBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
            DeckleBaseTable.SetRange(DeckleBaseTable."Select for Publish", true);
            if DeckleBaseTable.FindFirst then begin

                ProductionScheduleLine.Reset;
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Deckle Size Schedule(mm)", DeckleBaseTable."Deckle Size");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
                if ProductionScheduleLine.FindFirst then begin
                    ProgressWindow.Open('Production Order No. #1#######');
                    repeat
                        ProgressWindow.Update(1, ProductionScheduleLine."Prod. Order No.");
                        TempProdComponentLine.Reset;
                        TempProdComponentLine.SetCurrentKey("Prod. Order No.", "Prod. Order Line No.", "Line No.", Status);
                        TempProdComponentLine.SetRange(TempProdComponentLine.Status, TempProdComponentLine.Status::Released);
                        TempProdComponentLine.SetRange(TempProdComponentLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                        TempProdComponentLine.SetRange(TempProdComponentLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                        if TempProdComponentLine.FindLast then
                            BOMLine := TempProdComponentLine."Line No.";

                        ProdOrderComp.Reset;
                        ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                        ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                        ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                        ProdOrderComp.SetFilter(ProdOrderComp."Paper Position", Sam001);
                        ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", '');
                        ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", false);
                        if ProdOrderComp.FindFirst then begin
                            repeat
                                CompItem.Get(ProdOrderComp."Item No.");

                                ItemMaster.Reset;
                                ItemMaster.SetRange(ItemMaster."Paper Type", CompItem."Paper Type");
                                ItemMaster.SetRange(ItemMaster."Paper GSM", CompItem."Paper GSM");
                                ItemMaster.SetRange(ItemMaster."Deckle Size (mm)", DeckleBaseTable."Deckle Size(Num)");
                                if ItemMaster.FindFirst then begin
                                    ProdOrderCompLine.Init;
                                    ProdOrderCompLine := ProdOrderComp;
                                    BOMLine += 10;
                                    ProdOrderCompLine."Line No." := BOMLine;
                                    ProdOrderCompLine."Expected Quantity" := 0;
                                    ProdOrderCompLine."Remaining Quantity" := 0;
                                    ProdOrderCompLine."Remaining Qty. (Base)" := 0;
                                    ProdOrderCompLine."Expected Qty. (Base)" := 0;

                                    ProdOrderCompLine.Validate("Item No.", ItemMaster."No.");
                                    ProdOrderCompLine."Prod Schedule No." := DeckleBaseTable."Schedule No.";
                                    ProdOrderCompLine.Validate("Expected Quantity", ProductionScheduleLine."Quantity To Schedule" * ProdOrderCompLine."Quantity per");
                                    ProdOrderCompLine.Validate("Remaining Quantity", ProductionScheduleLine."Quantity To Schedule" * ProdOrderCompLine."Quantity per");
                                    ProdOrderCompLine.Validate(ProdOrderCompLine."Unit Cost");
                                    ScheduleHeader.Status := ScheduleHeader.Status::Confirmed;
                                    ProdOrderCompLine."Schedule Component" := true;

                                    ProdOrderCompLine.Insert(true);

                                end else begin
                                    ProgressWindow.Close;
                                    Error('Item not found with following specification, Deckle Size %1 Paper Type %2 Paper GSM %3');
                                end;
                            until ProdOrderComp.Next = 0;
                        end;
                        ProductionScheduleLine.Published := true;
                        ProductionScheduleLine.Modify(true);
                        //Updated By Deepak Kumar
                        ProdOrder.Reset;
                        ProdOrder.SetRange(ProdOrder.Status, ProdOrder.Status::Released);
                        ProdOrder.SetRange(ProdOrder."No.", ProductionScheduleLine."Prod. Order No.");
                        if ProdOrder.FindFirst then begin
                            ProdOrder."Prod Status" := ProdOrder."Prod Status"::"In process";
                            ProdOrder.Modify(true);
                        end;

                    until ProductionScheduleLine.Next = 0;
                    ScheduleHeader."Schedule Published" := true;
                    ScheduleHeader.Modify(true);
                    DeleteExtraLines(ScheduleHeader);
                    ProgressWindow.Close;
                    Message('Corrugation Schedule is Published for Production, Order component also created for schedule %1', DeckleBaseTable."Schedule No.");

                end else begin
                    Message('There is no Production order line selected for Publish');
                end;

            end else begin
                Message(' No Deckle selected for Publish');
            end;
        end;
    end;

    local procedure DeleteExtraLines(ScheduleHeader: Record "Production Schedule")
    var
        DeckleBaseTable: Record "Schedule Base Table 1";
        PaperTypeBaseTable: Record "Schedule Base Table 2";
        PaperGSMBaseTable: Record "Schedule Base Table 3";
    begin
        // Lines added BY Deepak Kumar
        DeckleBaseTable.Reset;
        DeckleBaseTable.SetRange(DeckleBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        DeckleBaseTable.SetRange(DeckleBaseTable."Select for Publish", false);
        if DeckleBaseTable.FindFirst then begin
            repeat

                PaperTypeBaseTable.Reset;
                PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Schedule No.", DeckleBaseTable."Schedule No.");
                PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Deckle Size", DeckleBaseTable."Deckle Size");
                if PaperTypeBaseTable.FindSet then
                    PaperTypeBaseTable.DeleteAll(true);

                PaperGSMBaseTable.Reset;
                PaperGSMBaseTable.SetRange(PaperGSMBaseTable."Schedule No.", DeckleBaseTable."Schedule No.");
                PaperGSMBaseTable.SetRange(PaperGSMBaseTable."Deckle Size", DeckleBaseTable."Deckle Size");
                if PaperGSMBaseTable.FindSet then
                    PaperGSMBaseTable.DeleteAll(true);

                if ScheduleHeader."Manual Assortment" = true then begin
                    ProductionScheduleLine.Reset;
                    ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", DeckleBaseTable."Schedule No.");
                    ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
                    ProductionScheduleLine.SetRange(ProductionScheduleLine.Published, false);
                    if ProductionScheduleLine.FindSet then
                        ProductionScheduleLine.DeleteAll(true);
                end else begin
                    ProductionScheduleLine.Reset;
                    ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", DeckleBaseTable."Schedule No.");
                    ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
                    ProductionScheduleLine.SetRange(ProductionScheduleLine."Deckle Size Schedule(mm)", DeckleBaseTable."Deckle Size");
                    if ProductionScheduleLine.FindSet then
                        ProductionScheduleLine.DeleteAll(true);
                end;
                DeckleBaseTable.Delete(true);
            until DeckleBaseTable.Next = 0;
        end;
    end;

    procedure MakePriorityOnJob(ScheduleHeader: Record "Production Schedule"; DeckleSize: Code[20])
    var
        PriorityNumber: Integer;
    begin
        // Lines added BY Deepak Kumar
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetCurrentKey("Schedule No.", Flute, "Deckle Size Schedule(mm)", "No. Of Ply", "Top Colour", "Qty to Schedule Net Weight");


        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Deckle Size Schedule(mm)", DeckleSize);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        if ProductionScheduleLine.FindFirst then begin

            PriorityNumber := 10;
            repeat
                ProductionScheduleLine."Priority By System" := PriorityNumber;
                ProductionScheduleLine."Modified Priority" := PriorityNumber;
                PriorityNumber += 10;
                ProductionScheduleLine.Modify(true);
            until ProductionScheduleLine.Next = 0;
        end;
    end;

    procedure GetConsumptionLine(ReqNo: Code[20])
    var
        ReqHeader: Record "Requisition Header";
        ReqLine: Record "Requisition Line SAM";
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        TempLine: Integer;
        ProdOrderComp: Record "Prod. Order Component";
        TempLineNumber: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        // Lines added By Deepak Kumar
        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", ReqNo);
        if ReqHeader.FindFirst then begin
            ReqHeader.TestField(ReqHeader."Requisition Type", ReqHeader."Requisition Type"::"Production Schedule");
            ReqHeader.TestField(ReqHeader."Schedule Document No.");
            // Lines for Production Order
            ManufacturingSetup.Get;
            TempLine := 1000;
            ItemLedgerEntry.Reset;
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Requisition No.", ReqHeader."Requisition No.");
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Transfer);
            ItemLedgerEntry.SetRange(ItemLedgerEntry.Positive, true);
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", ManufacturingSetup."Corrugation Location");
            if ItemLedgerEntry.FindFirst then begin
                TempLineNumber := 10000;
                repeat
                    if ItemLedgerEntry."Remaining Quantity" <> 0 then begin
                        SchItemLine.Init;
                        SchItemLine."Prod. Schedule No" := ReqHeader."Schedule Document No.";
                        //SchItemLine."Req. Line Number":=ReqLine."Requisition Line No.";
                        SchItemLine."Line Number" := TempLineNumber;
                        //SchItemLine."Paper Position":=ReqLine."Paper Position";
                        SchItemLine."Requisition No." := ReqHeader."Requisition No.";
                        SchItemLine.Validate("Item Code", ItemLedgerEntry."Item No.");
                        SchItemLine.Validate("Roll ID", ItemLedgerEntry."Variant Code");
                        SchItemLine.Insert(true);
                        TempLineNumber := TempLineNumber + 10000;

                        ProdOrderComp.Reset;
                        ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                        ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", ReqHeader."Schedule Document No.");
                        ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", true);
                        ProdOrderComp.SetRange(ProdOrderComp."Item No.", ItemLedgerEntry."Item No.");
                        //ProdOrderComp.SETFILTER(ProdOrderComp."Remaining Quantity",'>0');
                        if ProdOrderComp.FindFirst then begin
                            //TempLine:=1000;
                            repeat
                                SchProdLine.Init;
                                SchProdLine."Prod. Schedule No" := ProdOrderComp."Prod Schedule No.";
                                SchProdLine."Line No." := TempLine;
                                TempLine += 1000;
                                SchProdLine."Prod. Order No." := ProdOrderComp."Prod. Order No.";
                                SchProdLine."Prod. Order Line No" := ProdOrderComp."Prod. Order Line No.";
                                SchProdLine."Item Code" := ProdOrderComp."Item No.";
                                SchProdLine."Paper Position" := ProdOrderComp."Paper Position";
                                SchProdLine."Take Up" := ProdOrderComp."Take Up";
                                SchProdLine."Flute Type" := ProdOrderComp."Flute Type";
                                SchProdLine."Expected Consumption" := ProdOrderComp."Expected Quantity";
                                ProdOrderComp.CalcFields(ProdOrderComp."Actual Consumed");
                                SchProdLine."Posted Consumption" := ProdOrderComp."Actual Consumed";
                                SchProdLine."Requisition No." := ReqHeader."Requisition No.";
                                SchProdLine."Quantity Per" := ProdOrderComp."Quantity per";
                                SchProdLine."Variant Code/ Reel Number" := ItemLedgerEntry."Variant Code";
                                SchProdLine.Insert(true);
                            until ProdOrderComp.Next = 0;
                        end;
                    end;
                until ItemLedgerEntry.Next = 0;
            end;
            Message('Complete');
        end;
    end;

    procedure AddNewLConsumptionLine(ReqNo: Code[20])
    var
        ReqHeader: Record "Requisition Header";
        ReqLine: Record "Requisition Line SAM";
        SchItemLine: Record "Con. Item Selection N";
        SchBaseLine: Record "Con. Item Selection N";
        TempLine: Integer;
        ProdOrderComp: Record "Prod. Order Component";
        TempLineNumber: Integer;
    begin
        // Lines added By Deepak Kumar
        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", ReqNo);
        if ReqHeader.FindFirst then begin
            ReqHeader.TestField(ReqHeader."Requisition Type", ReqHeader."Requisition Type"::"Production Schedule");
            ReqHeader.TestField(ReqHeader."Schedule Document No.");

            SchItemLine.Reset;
            SchItemLine.SetCurrentKey("Prod. Schedule No", "Req. Line Number", "Line Number");
            SchItemLine.SetRange(SchItemLine."Prod. Schedule No", ReqHeader."Schedule Document No.");
            if SchItemLine.FindLast then
                TempLineNumber := SchItemLine."Line Number";


            SchBaseLine.Reset;
            SchBaseLine.SetRange(SchBaseLine."Requisition No.", ReqNo);
            SchBaseLine.SetRange(SchBaseLine."Additional Line", false);
            if SchBaseLine.FindFirst then begin
                repeat

                    ReqLine.Reset;
                    ReqLine.SetRange(ReqLine."Requisition No.", SchBaseLine."Requisition No.");
                    ReqLine.SetRange(ReqLine."Requisition Line No.", SchBaseLine."Req. Line Number");
                    if ReqLine.FindFirst then begin
                        repeat
                            TempLineNumber += 10000;
                            SchItemLine.Init;
                            SchItemLine."Prod. Schedule No" := ReqHeader."Schedule Document No.";
                            SchItemLine."Req. Line Number" := ReqLine."Requisition Line No.";
                            SchItemLine."Line Number" := TempLineNumber;
                            SchItemLine."Paper Position" := ReqLine."Paper Position";
                            SchItemLine."Requisition No." := ReqHeader."Requisition No.";
                            SchItemLine.Validate("Item Code", ReqLine."Item No.");
                            SchItemLine."Additional Line" := true;
                            SchItemLine.Insert(true);
                        until ReqLine.Next = 0;
                    end;
                until SchBaseLine.Next = 0;
            end else begin
                Error('There is no base line to create an additional new line.');
            end;
            Message('Complete');
        end;
    end;

    procedure CalcPostingLine(RequisitionNumber: Code[20])
    var
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        ItemJnlLine: Record "Item Journal Line";
        TempLineNumber: Integer;
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
        DocNo: Code[50];
        MaterialReqLine: Record "Requisition Line SAM";
        ItemJournalPost: Codeunit "Item Jnl.-Post Batch";
        TotalQtytoPost: Decimal;
    begin
        //Lines added by Deepak Kumar
        SchItemLine.Reset;
        SchItemLine.SetRange(SchItemLine."Requisition No.", RequisitionNumber);
        if SchItemLine.FindFirst then begin
            DocNo := '';
            repeat
                SchItemLine.TestField(SchItemLine."Quantity to Consume");
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Paper Position(Item)", SchItemLine."Paper Position");
                SchProdLine.SetRange(SchProdLine."Item Code", SchItemLine."Item Code");
                SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                SchProdLine.SetRange(SchProdLine."Variant Code/ Reel Number", SchItemLine."Roll ID");
                if SchProdLine.FindFirst then begin
                    repeat
                        //SchProdLine.CALCFIELDS(SchProdLine."Actual Consumption");
                        SchProdLine.CalcFields(SchProdLine."Actual Output Quantity");
                        SchProdLine."Expected Consumption" := (SchProdLine."Actual Output Quantity" * SchProdLine."Quantity Per") - Abs(SchProdLine."Posted Consumption");
                        SchProdLine.Modify(true);
                    until SchProdLine.Next = 0;
                end;
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Paper Position(Item)", SchItemLine."Paper Position");
                SchProdLine.SetRange(SchProdLine."Item Code", SchItemLine."Item Code");
                SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                SchProdLine.SetRange(SchProdLine."Variant Code/ Reel Number", SchItemLine."Roll ID");
                if SchProdLine.FindFirst then begin
                    TotalQtytoPost := 0;
                    repeat
                        SchProdLine.CalcFields(SchProdLine."Total Exp. Consumption");
                        if SchProdLine."Total Exp. Consumption" > 0 then
                            SchProdLine."Consumption Ratio" := (SchProdLine."Expected Consumption" / SchProdLine."Total Exp. Consumption") * 100;
                        SchProdLine."Qty to be Post" := Round(((SchItemLine."Quantity to Consume" * SchProdLine."Consumption Ratio") / 100), 0.01);
                        TotalQtytoPost := TotalQtytoPost + SchProdLine."Qty to be Post";
                        SchProdLine.Modify(true);
                    until SchProdLine.Next = 0;
                    // Manage Rounding Quantity
                    SchProdLine."Qty to be Post" := SchProdLine."Qty to be Post" + (SchItemLine."Quantity to Consume" - TotalQtytoPost);
                    SchProdLine.Modify(true);

                end else begin

                    Error('There are no Prod. Order selected for Item Number %1 %2', SchItemLine."Item Code", SchProdLine.GetFilters);
                end;
            until SchItemLine.Next = 0;
        end;

        // Lines added for Updated Extra Consumtion

        SchItemLine.Reset;
        SchItemLine.SetRange(SchItemLine."Requisition No.", RequisitionNumber);
        if SchItemLine.FindFirst then begin
            repeat
                SchItemLine.TestField(SchItemLine."Quantity to Consume");
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Paper Position(Item)", SchItemLine."Paper Position");
                SchProdLine.SetRange(SchProdLine."Item Code", SchItemLine."Item Code");
                SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                SchProdLine.SetRange(SchProdLine."Variant Code/ Reel Number", SchItemLine."Roll ID");
                if SchProdLine.FindFirst then begin
                    TotalQtytoPost := 0;
                    repeat
                        SchProdLine.CalcFields(SchProdLine."Cumulative Quantity to Post");
                        if SchProdLine."Expected Consumption" = 0 then
                            SchProdLine."Expected Consumption" := 1;

                        if ((SchProdLine."Cumulative Quantity to Post" + Abs(SchProdLine."Posted Consumption")) - SchProdLine."Expected Consumption") > 0 then begin
                            SchProdLine."Extra Consumtpion Quantity" := (SchProdLine."Cumulative Quantity to Post" + Abs(SchProdLine."Posted Consumption")) - SchProdLine."Expected Consumption";
                            SchProdLine."Extra Consumtion Variation(%)" := (((SchProdLine."Cumulative Quantity to Post" + Abs(SchProdLine."Posted Consumption")) - SchProdLine."Expected Consumption") / SchProdLine."Expected Consumption") * 100;
                        end else begin
                            SchProdLine."Extra Consumtpion Quantity" := 0;
                            SchProdLine."Extra Consumtion Variation(%)" := 0;
                        end;
                        SchProdLine.Modify(true);
                    until SchProdLine.Next = 0;
                end;
            until SchItemLine.Next = 0;
        end;
    end;

    procedure PostConsumptionLine(RequisitionNumber: Code[20])
    var
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        ItemJnlLine: Record "Item Journal Line";
        TempLineNumber: Integer;
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
        DocNo: Code[50];
        MaterialReqLine: Record "Requisition Line SAM";
        ItemJournalPost: Codeunit "Item Jnl.-Post Batch";
        ConItemSelection: Record "Con. Item Selection N";
        ConsProdOrderSelection: Record "Cons. Prod. Order Selection";
        TempQtytoPost: Decimal;
    begin
        //Lines added by Deepak Kumar
        if RequisitionNumber = '' then
            Error('Req Number Must Not be Blank');

        MfgSetup.Get;
        MfgSetup.TestField("Paper Consumption Batch");
        ItemJnlLine.Reset;
        ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", 'Item');
        ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", MfgSetup."Paper Consumption Batch");
        if ItemJnlLine.FindSet then
            ItemJnlLine.DeleteAll(true);
        /*

     SchItemLine.RESET;
     SchItemLine.SETRANGE(SchItemLine."Requisition No.",RequisitionNumber);
     IF SchItemLine.FINDFIRST THEN BEGIN
      DocNo:='';
       REPEAT
          // For Create Item Line
           SchProdLine.RESET;
           SchProdLine.SETRANGE(SchProdLine."Requisition No.",SchItemLine."Requisition No.");
           SchProdLine.SETRANGE(SchProdLine."Paper Position",SchItemLine."Paper Position");
           SchProdLine.SETRANGE(SchProdLine."Item Code",SchItemLine."Item Code");
           SchProdLine.SETRANGE(SchProdLine."Marked for Consumption Post",TRUE);
           IF SchProdLine.FINDFIRST THEN BEGIN
             REPEAT
              IF (SchProdLine."Extra Consumtion Variation(%)" > 0) AND (SchProdLine."Extra Quantity Approval"= FALSE) THEN
                ERROR('Extra Consumption Quantity must be approved!,Production Order No. %3 Item No.  %1 Paper Position  %2 ',SchProdLine."Item Code",SchProdLine."Paper Position",SchProdLine."Prod. Order No.");
             UNTIL SchProdLine.NEXT=0;
           END;
     UNTIL SchItemLine.NEXT=0;
     END;
     */


        SchItemLine.Reset;
        SchItemLine.SetRange(SchItemLine."Requisition No.", RequisitionNumber);
        if SchItemLine.FindFirst then begin
            DocNo := '';
            repeat
                // For Create Item Line
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Paper Position(Item)", SchItemLine."Paper Position");
                SchProdLine.SetRange(SchProdLine."Item Code", SchItemLine."Item Code");
                SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                SchProdLine.SetRange(SchProdLine."Variant Code/ Reel Number", SchItemLine."Roll ID");
                SchProdLine.SetFilter(SchProdLine."Qty to be Post", Sam0002);
                if SchProdLine.FindFirst then begin
                    if DocNo = '' then begin
                        ItemJnlBatch.Get('Item', MfgSetup."Paper Consumption Batch");
                        NoSeriesMgt.InitSeries(ItemJnlBatch."Posting No. Series", ItemJnlBatch."Posting No. Series", Today, DocNo, ItemJnlBatch."Posting No. Series");
                        TempLineNumber := 10000;
                    end;
                    TempQtytoPost := 0;
                    repeat

                        ItemJnlLine.Init;
                        ItemJnlLine."Journal Template Name" := 'Item';
                        ItemJnlLine."Journal Batch Name" := MfgSetup."Paper Consumption Batch";
                        ItemJnlLine."Line No." := TempLineNumber;
                        ItemJnlLine."Document No." := DocNo;
                        TempLineNumber += 1;
                        ItemJnlLine.Insert(true);

                        ItemJnlLine.Validate("Order Type", ItemJnlLine."Order Type"::Production);
                        ItemJnlLine.Validate("Order No.", SchProdLine."Prod. Order No.");
                        ItemJnlLine.Validate("Order Line No.", SchProdLine."Prod. Order Line No");


                        ItemJnlLine.Validate("Item No.", SchItemLine."Item Code");
                        ItemJnlLine.Validate("Variant Code", SchItemLine."Roll ID");
                        //ItemJnlLine.VALIDATE(Quantity,(ROUND(((SchItemLine."Quantity to Consume"*SchProdLine."Consumption Ratio")/100),0.01)));
                        ItemJnlLine.Validate(Quantity, SchProdLine."Qty to be Post");
                        //TempQtytoPost:=TempQtytoPost+ItemJnlLine.Quantity;

                        Item.Get(SchItemLine."Item Code");
                        ItemJnlLine."Posting Date" := WorkDate;
                        ItemJnlLine."Paper GSM" := Format(Item."Paper GSM");
                        ItemJnlLine."Paper Type" := Item."Paper Type";
                        ItemJnlLine."Paper Position" := SchProdLine."Paper Position";
                        ItemJnlLine."Take Up" := SchProdLine."Take Up";
                        ItemJnlLine."Flute Type" := SchProdLine."Flute Type";
                        ItemJnlLine."Deckle Size (mm)" := Item."Deckle Size (mm)";
                        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Consumption;
                        ItemJnlLine."Source Code" := 'ITEMJNL';

                        ItemJnlLine."Requisition No." := SchItemLine."Requisition No.";
                        MaterialReqLine.Reset;
                        MaterialReqLine.SetRange(MaterialReqLine."Requisition No.", SchItemLine."Requisition No.");
                        MaterialReqLine.SetRange(MaterialReqLine."Requisition Line No.", SchItemLine."Req. Line Number");
                        if MaterialReqLine.FindFirst then begin
                            ItemJnlLine."Requisition No." := MaterialReqLine."Requisition No.";
                            ItemJnlLine."Requisition Line No." := MaterialReqLine."Requisition Line No.";
                            ItemJnlLine."Requisition Rem. Quantity" := MaterialReqLine."Remaining Quantity";
                        end;
                        ItemJnlLine.Modify(true);
                    until SchProdLine.Next = 0;
                    //ItemJnlLine.VALIDATE(Quantity,(ItemJnlLine.Quantity+(SchItemLine."Quantity to Consume"- TempQtytoPost)));
                    //ItemJnlLine.MODIFY(TRUE);

                end;
            until SchItemLine.Next = 0;
            ItemJnlLine.Reset;
            ItemJnlLine.SetRange(ItemJnlLine."Requisition No.", RequisitionNumber);
            ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", 'Item');
            ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", MfgSetup."Paper Consumption Batch");
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJnlLine);
        end;
        ConItemSelection.Reset;
        if ConItemSelection.FindSet then
            ConItemSelection.DeleteAll(true);

        ConsProdOrderSelection.Reset;
        if ConsProdOrderSelection.FindSet then
            ConsProdOrderSelection.DeleteAll(true);

    end;

    procedure GenerateCPMSData(ScheduleHeader: Record "Production Schedule")
    var
        ProdScheduleCMPS: Record "PROD. CMPS data";
        TempLineNo: Integer;
        EstimationHeader: Record "Product Design Header";
        TempLength: Code[10];
        TempWidth: Code[10];
        TempScorar1: Code[10];
        TempScorar2: Code[10];
        TempScorar3: Code[10];
        textcount: Integer;
        TempCUT: Code[10];
        TempDeckle: Code[10];
    begin
        // Lines added By Deepak kumar
        ProdScheduleCMPS.Reset;
        if ProdScheduleCMPS.FindSet then
            ProdScheduleCMPS.DeleteAll(true);

        ScheduleHeader.TestField(ScheduleHeader."Schedule Published", true);
        ScheduleHeader.TestField(ScheduleHeader."Schedule Closed", false);
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetRange(ProductionScheduleLine.Published, true);
        if ProductionScheduleLine.FindFirst then begin
            TempLineNo := 10000;
            // Create Header
            ProdScheduleCMPS.Init;
            ProdScheduleCMPS."Schedule No." := ScheduleHeader."Schedule No.";
            ProdScheduleCMPS."Line Number" := 9999;
            ProdScheduleCMPS.COMMAND := 'A';
            ProdScheduleCMPS.XXX := 'B';
            ProdScheduleCMPS.SEQUENCE := '00';
            ProdScheduleCMPS.ORDER := 'ORDER';
            ProdScheduleCMPS."CUSTOMER CODE" := 'CUST CODE';
            ProdScheduleCMPS."CUSTOMER NAME" := 'CUSTOMER NAME';
            ProdScheduleCMPS.GAP := 'GAP';
            ProdScheduleCMPS."RUN PAPER" := '';
            ProdScheduleCMPS.FLUTE := '';
            ProdScheduleCMPS."WIDTH mm" := 'W';
            ProdScheduleCMPS."LENGTH mm" := 'L';
            ProdScheduleCMPS.CUT := '';
            ProdScheduleCMPS.STACK := '';
            ProdScheduleCMPS."SC1-1 mm" := 'SC1';
            ProdScheduleCMPS."SC2-1 mm" := 'SC2';
            ProdScheduleCMPS."SC3-1 mm" := 'SC3';
            ProdScheduleCMPS."SC4-1 mm" := 'SC4';
            ProdScheduleCMPS."SC5-1 mm" := 'SC5';
            ProdScheduleCMPS."OUT-1" := '';
            ProdScheduleCMPS."SC6-2 mm" := 'SC6';
            ProdScheduleCMPS."SC7-2" := 'SC7';
            ProdScheduleCMPS."SC8-2" := 'SC8';
            ProdScheduleCMPS."OUT-2" := '';
            ProdScheduleCMPS.REMARK := 'REMARKS';
            ProdScheduleCMPS."DB-PAPER" := 'DB';
            ProdScheduleCMPS."1M-PAPER" := '1M';
            ProdScheduleCMPS."1L-PAPER" := '1L';
            ProdScheduleCMPS."2M-PAPER" := '2M';
            ProdScheduleCMPS."2L-PAPER" := '2L';
            ProdScheduleCMPS."3M-PAPER" := '3M';
            ProdScheduleCMPS."3L-PAPER" := '3L';
            ProdScheduleCMPS.SCORER_TYPE := '';
            ProdScheduleCMPS.DELIVERY := '';
            ProdScheduleCMPS.Insert(true);
            repeat

                //COPYSTR(String, Position[, Length])
                ProdScheduleCMPS.Init;
                ProdScheduleCMPS."Schedule No." := ScheduleHeader."Schedule No.";
                ProdScheduleCMPS."Line Number" := TempLineNo;
                TempLineNo += 100;

                ProdScheduleCMPS.COMMAND := 'A';
                ProdScheduleCMPS.XXX := '';
                ProdScheduleCMPS.SEQUENCE := CopyStr(Format(ProductionScheduleLine."Priority By System"), 1, 4);
                ProdScheduleCMPS.ORDER := CopyStr(ProductionScheduleLine."Prod. Order No.", 1, 10);
                ProdScheduleCMPS."CUSTOMER CODE" := CopyStr(ProductionScheduleLine."Schedule No.", 1, 16);
                ProdScheduleCMPS."CUSTOMER NAME" := CopyStr(ProductionScheduleLine."Customer Name", 1, 40);
                //ProdScheduleCMPS.GAP:=
                //ProdScheduleCMPS."RUN PAPER":=
                ProdScheduleCMPS.FLUTE := CopyStr(Format(ProductionScheduleLine."Flute 1") + Format(ProductionScheduleLine."Flute 2"), 1, 3);

                TempWidth := CopyStr(Format(ProductionScheduleLine."Board Width(mm)"), 1, 5);
                textcount := StrLen(TempWidth);
                if textcount > 3 then
                    TempWidth := DelStr(TempWidth, 2, 1);

                TempLength := CopyStr(Format(ProductionScheduleLine."Board Length(mm)"), 1, 5);
                textcount := StrLen(TempLength);
                if textcount > 3 then
                    TempLength := DelStr(TempLength, 2, 1);

                ProdScheduleCMPS."WIDTH mm" := TempWidth;
                ProdScheduleCMPS."LENGTH mm" := TempLength;

                //ProdScheduleCMPS.STACK:=

                EstimationHeader.Reset;
                EstimationHeader.SetRange(EstimationHeader."Product Design No.", ProductionScheduleLine."Product Design No.");
                EstimationHeader.SetRange(EstimationHeader."Sub Comp No.", ProductionScheduleLine."Estimation Sub Job No.");
                if EstimationHeader.FindFirst then begin

                    TempScorar1 := '';
                    TempScorar2 := '';
                    TempScorar3 := '';

                    TempScorar1 := Format(EstimationHeader."Board Width (mm)- W");

                    if EstimationHeader."Model No" = '0200' then begin
                        TempScorar1 := Format(EstimationHeader."Box Width (mm)- W (OD)" / 2);
                        TempScorar2 := Format(EstimationHeader."Box Height (mm) - D (OD)");
                    end;

                    if EstimationHeader."Model No" = '0201' then begin
                        TempScorar1 := Format(EstimationHeader."Box Width (mm)- W (OD)" / 2);
                        TempScorar2 := Format(EstimationHeader."Box Height (mm) - D (OD)");
                        TempScorar3 := Format(EstimationHeader."Box Width (mm)- W (OD)" / 2);
                    end;

                    if EstimationHeader."Manual Scorer" then begin
                        TempScorar1 := Format(EstimationHeader."Scorer 1");
                        TempScorar2 := Format(EstimationHeader."Scorer 2");
                        TempScorar3 := Format(EstimationHeader."Scorer 3");
                    end;

                    TempDeckle := Format(ProductionScheduleLine."Deckle Size Schedule(mm)");
                    textcount := StrLen(TempDeckle);
                    if textcount > 3 then
                        TempDeckle := DelStr(TempDeckle, 2, 1);

                    ProdScheduleCMPS."RUN PAPER" := TempDeckle;




                    TempCUT := Format(Round(ProductionScheduleLine."Quantity To Schedule" / ProductionScheduleLine."No. of Ups (Estimated)", 1));
                    textcount := StrLen(TempCUT);
                    if textcount > 3 then
                        TempCUT := DelStr(TempCUT, 2, 1);

                    ProdScheduleCMPS.CUT := TempCUT;

                    textcount := StrLen(TempScorar1);
                    if textcount > 3 then
                        TempScorar1 := DelStr(TempScorar1, 2, 1);

                    textcount := StrLen(TempScorar2);
                    if textcount > 3 then
                        TempScorar2 := DelStr(TempScorar2, 2, 1);

                    textcount := StrLen(TempScorar3);
                    if textcount > 3 then
                        TempScorar3 := DelStr(TempScorar3, 2, 1);

                    ProdScheduleCMPS."SC1-1 mm" := CopyStr(TempScorar1, 1, 4);
                    ProdScheduleCMPS."SC2-1 mm" := CopyStr(TempScorar2, 1, 4);
                    ProdScheduleCMPS."SC3-1 mm" := CopyStr(TempScorar3, 1, 4);





                    /*
                       ProdScheduleCMPS."SC1-1 mm":=
                       ProdScheduleCMPS."SC2-1 mm":=
                       ProdScheduleCMPS."SC3-1 mm":=
                       ProdScheduleCMPS."SC4-1 mm":=
                       ProdScheduleCMPS."SC5-1 mm":=
                     */

                    ProdScheduleCMPS."OUT-1" := Format(ProductionScheduleLine."Calculated No. of Ups");
                    if EstimationHeader."Scorer Type" = EstimationHeader."Scorer Type"::"1. Male to Female(3 Point)" then
                        ProdScheduleCMPS.SCORER_TYPE := '1';

                    if EstimationHeader."Scorer Type" = EstimationHeader."Scorer Type"::"2. Point to Flat" then
                        ProdScheduleCMPS.SCORER_TYPE := '2';

                    if EstimationHeader."Scorer Type" = EstimationHeader."Scorer Type"::"3. Point to Point" then
                        ProdScheduleCMPS.SCORER_TYPE := '3';

                end;
                ProdScheduleCMPS.REMARK := ProductionScheduleLine."Prod. Order No." + Format(ProductionScheduleLine."Prod. Order Line No.");
                // ProdScheduleCMPS.DELIVERY:=
                /*

                ProdScheduleCMPS."SC6-2 mm":=
                ProdScheduleCMPS."SC7-2":=
                ProdScheduleCMPS."SC8-2":=
                ProdScheduleCMPS."OUT-2":=

                 */

                ProdScheduleCMPS."DB-PAPER" := ProductionScheduleLine."DB Paper";
                ProdScheduleCMPS."1M-PAPER" := ProductionScheduleLine."1M Paper";
                ProdScheduleCMPS."1L-PAPER" := ProductionScheduleLine."1L Paper";
                ProdScheduleCMPS."2M-PAPER" := ProductionScheduleLine."2M Paper";
                ProdScheduleCMPS."2L-PAPER" := ProductionScheduleLine."2L Paper";
                ProdScheduleCMPS."3M-PAPER" := ProductionScheduleLine."3M Paper";
                ProdScheduleCMPS."3L-PAPER" := ProductionScheduleLine."3L paper";

                //ProdScheduleCMPS.DELIVERY:=
                //ProdScheduleCMPS."INSERT ORDER":=

                ProdScheduleCMPS.Insert(true);
            until ProductionScheduleLine.Next = 0;
        end;

    end;

    procedure ManualAssortment(ScheduleHeader: Record "Production Schedule")
    var
        Answer: Boolean;
        DeckleMaster: Record "Master Deckle Size";
        BaseTableDeckle: Record "Schedule Base Table 1";
        PaperTypeBaseTable: Record "Schedule Base Table 2";
        PaserGSMBaseTable: Record "Schedule Base Table 3";
        ProductionScheduleLineN: Record "Production Schedule Line";
        TempBoardUps: Integer;
        ProductDesignHeader: Record "Product Design Header";
        ProdOrderLine: Record "Prod. Order Line";
        TempDesignTrim: Decimal;
        ExtraTrimActual: Decimal;
        ProdOrderComp: Record "Prod. Order Component";
    begin
        // Lines added By Depak Kumar
        Answer := DIALOG.Confirm('Do you want Manual Assortment of orders?', true, ScheduleHeader."Schedule No.");
        if Answer = false then
            exit;

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", false);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        if not ProductionScheduleLine.FindFirst then
            Error('Noting to calculate or marked for publish is false.');


        ProgressWindow.Open('Deleting Record #1#######');
        ProgressWindow.Update(1, 'Production Schedule Line');

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetFilter(ProductionScheduleLine."Deckle Size Schedule(mm)", Sam0001);//Sam0001=<>''
        if ProductionScheduleLine.FindSet then
            ProductionScheduleLine.DeleteAll(true);

        ProgressWindow.Update(1, 'Base Deckle Table');
        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        if BaseTableDeckle.FindSet then
            BaseTableDeckle.DeleteAll(true);

        ProgressWindow.Update(1, 'Paper Type Base Table');
        PaperTypeBaseTable.Reset;
        PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        if PaperTypeBaseTable.FindSet then
            PaperTypeBaseTable.DeleteAll(true);

        ProgressWindow.Update(1, 'Paper GSM Base Table');
        PaserGSMBaseTable.Reset;
        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        if PaserGSMBaseTable.FindSet then
            PaserGSMBaseTable.DeleteAll(true);

        ProgressWindow.Close;
        //Update Schedule Line

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", false);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        if ProductionScheduleLine.FindFirst then begin
            ProgressWindow.Open('Order No. #1####### ,\Line Number #2#######');
            repeat
                ProgressWindow.Update(1, ProductionScheduleLine."Prod. Order No.");
                ProgressWindow.Update(2, ProductionScheduleLine."Prod. Order Line No.");
                ProductionScheduleLineN.Init;
                ProductionScheduleLineN := ProductionScheduleLine;
                ProductionScheduleLineN."Deckle Size Schedule(mm)" := Format(ProductionScheduleLine."Planned Deckle Size(mm)");
                ProductionScheduleLineN."Schedule Line" := true;
                ProductionScheduleLineN.Insert(true);

                TempBoardUps := 0;
                TempDesignTrim := 0;

                if ScheduleHeader."Trim Calculation Type" = ScheduleHeader."Trim Calculation Type"::"Product Design" then begin

                    if ProductionScheduleLineN."Board Width(mm)" <> 0 then
                        TempBoardUps := Round(((ProductionScheduleLineN."Planned Deckle Size(mm)" - ProductionScheduleLineN."Trim Product Design") / ProductionScheduleLineN."Board Width(mm)"), 1, '<');

                    if TempBoardUps > ScheduleHeader."Machine Max Ups" then begin
                        ProductionScheduleLineN."Calculated No. of Ups" := ScheduleHeader."Machine Max Ups";
                    end else begin
                        ProductionScheduleLineN."Calculated No. of Ups" := TempBoardUps;
                    end;
                    if ProductionScheduleLineN."Calculated No. of Ups" = 0 then
                        ProductionScheduleLineN."Calculated No. of Ups" := 1;
                    ProductionScheduleLineN."Linear Length(Mtr)" := ((ProductionScheduleLineN."Quantity To Schedule" * ProductionScheduleLineN."Board Length(mm)") / ProductionScheduleLineN."Calculated No. of Ups") / 1000;
                    ProductionScheduleLineN."Qty to Schedule Net Weight" := ((ProductionScheduleLineN."Board Length(mm)" * ProductionScheduleLineN."Board Width(mm)"
                               * ProductionScheduleLineN."FG GSM") / 1000000000) * ProductionScheduleLineN."Quantity To Schedule";
                    ProductionScheduleLineN."Qty to Schedule M2 Weight" := ((ProductionScheduleLineN."Board Length(mm)" * ProductionScheduleLineN."Board Width(mm)") / 1000000) * ProductionScheduleLineN."Quantity To Schedule";


                    ProductionScheduleLineN."Extra Trim(mm)" := (ProductionScheduleLineN."Planned Deckle Size(mm)" -
                    ProductionScheduleLineN."Trim Product Design") - ((ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups"));
                    ProductionScheduleLineN."Trim %" := (ProductionScheduleLineN."Extra Trim(mm)" / ProductionScheduleLineN."Planned Deckle Size(mm)") * 100;

                    ProductionScheduleLineN."Trim (mm)" := (ProductionScheduleLineN."Planned Deckle Size(mm)" - ((ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups")));
                    ProductionScheduleLineN."Trim Weight" := (((ProductionScheduleLineN."Trim (mm)" * ProductionScheduleLineN."Cut Size (mm)" * ProductionScheduleLineN."FG GSM") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                    ProductionScheduleLineN."Extra Trim Weight" := (((ProductionScheduleLineN."Extra Trim(mm)" * ProductionScheduleLineN."Cut Size (mm)" * ProductionScheduleLineN."FG GSM") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                    //Mpower 30 Jul 2019--
                    ProdOrderComp.Reset;
                    ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                    ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProductionScheduleLineN."Prod. Order No.");
                    ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProductionScheduleLineN."Prod. Order Line No.");
                    ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", false);
                    if ProdOrderComp.FindFirst then begin
                        ProductionScheduleLineN."Extra Trim Actual" := 0;
                        ProductionScheduleLineN."Extra Trim Wt. Actual" := 0;
                        repeat
                            Clear(ExtraTrimActual);
                            ItemMaster.Get(ProdOrderComp."Item No.");
                            ExtraTrimActual := (ItemMaster."Deckle Size (mm)" -
                            ProductionScheduleLineN."Trim Product Design") - ((ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups"));
                            ProductionScheduleLineN."Extra Trim Actual" += ExtraTrimActual;
                            ProductionScheduleLineN."Extra Trim Wt. Actual" += (((ExtraTrimActual * ProductionScheduleLineN."Cut Size (mm)" * ItemMaster."Paper GSM" * ProdOrderComp."Take Up") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                        until ProdOrderComp.Next = 0;
                    end;
                    //Mpower 30 Jul 2019++

                end else begin
                    if ProductionScheduleLineN."Board Width(mm)" <> 0 then
                        TempBoardUps := Round(((ProductionScheduleLineN."Planned Deckle Size(mm)" - ScheduleHeader."Min Trim") / ProductionScheduleLineN."Board Width(mm)"), 1, '<');

                    if TempBoardUps > ScheduleHeader."Machine Max Ups" then begin
                        ProductionScheduleLineN."Calculated No. of Ups" := ScheduleHeader."Machine Max Ups";
                    end else begin
                        ProductionScheduleLineN."Calculated No. of Ups" := TempBoardUps;
                    end;
                    ProductionScheduleLineN."Linear Length(Mtr)" := ((ProductionScheduleLineN."Quantity To Schedule" * ProductionScheduleLineN."Board Length(mm)") / ProductionScheduleLineN."Calculated No. of Ups") / 1000;
                    ProductionScheduleLineN."Qty to Schedule Net Weight" := ((ProductionScheduleLineN."Board Length(mm)" * ProductionScheduleLineN."Board Width(mm)"
                               * ProductionScheduleLineN."FG GSM") / 1000000000) * ProductionScheduleLineN."Quantity To Schedule";
                    ProductionScheduleLineN."Qty to Schedule M2 Weight" := ((ProductionScheduleLineN."Board Length(mm)" * ProductionScheduleLineN."Board Width(mm)") / 1000000) * ProductionScheduleLineN."Quantity To Schedule";

                    ProductionScheduleLineN."Extra Trim(mm)" := (ProductionScheduleLineN."Planned Deckle Size(mm)" - ScheduleHeader."Min Trim") - ((ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups"));
                    ProductionScheduleLineN."Trim %" := (ProductionScheduleLineN."Extra Trim(mm)" / ProductionScheduleLineN."Planned Deckle Size(mm)") * 100;
                    ProductionScheduleLineN."Trim (mm)" := (ProductionScheduleLineN."Planned Deckle Size(mm)" - ((ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups")));
                    ProductionScheduleLineN."Trim Weight" := (((ProductionScheduleLineN."Trim (mm)" * ProductionScheduleLineN."Cut Size (mm)" * ProductionScheduleLineN."FG GSM") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                    ProductionScheduleLineN."Extra Trim Weight" := (((ProductionScheduleLineN."Extra Trim(mm)" * ProductionScheduleLineN."Cut Size (mm)" * ProductionScheduleLineN."FG GSM") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                    //Mpower 30 Jul 2019--
                    ProdOrderComp.Reset;
                    ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                    ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProductionScheduleLineN."Prod. Order No.");
                    ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProductionScheduleLineN."Prod. Order Line No.");
                    ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", false);
                    if ProdOrderComp.FindFirst then begin
                        ProductionScheduleLineN."Extra Trim Actual" := 0;
                        ProductionScheduleLineN."Extra Trim Wt. Actual" := 0;
                        repeat
                            Clear(ExtraTrimActual);
                            ItemMaster.Get(ProdOrderComp."Item No.");
                            ExtraTrimActual := (ItemMaster."Deckle Size (mm)" -
                            ProductionScheduleLineN."Trim Product Design") - ((ProductionScheduleLineN."Board Width(mm)" * ProductionScheduleLineN."Calculated No. of Ups"));
                            ProductionScheduleLineN."Extra Trim Actual" += ExtraTrimActual;
                            ProductionScheduleLineN."Extra Trim Wt. Actual" += (((ExtraTrimActual * ProductionScheduleLineN."Cut Size (mm)" * ItemMaster."Paper GSM" * ProdOrderComp."Take Up") / (1000000000)) * ProductionScheduleLineN."Quantity To Schedule");
                        until ProdOrderComp.Next = 0;
                    end;
                end;
                ProductionScheduleLineN.Modify(true);

            until ProductionScheduleLine.Next = 0;

            ProgressWindow.Close;
        end else begin
            Error('Noting to calculate or marked for publish is false.');

        end;
        MakePriorityOnJobMannualAsortment(ScheduleHeader);

        ScheduleHeader."Manual Assortment" := true;
        ScheduleHeader.Modify(true);
        Message('Schedule Marked for "Manual Assortment"');
    end;

    procedure GenerateQtyLineMannualAsortment(ScheduleHeader: Record "Production Schedule")
    var
        BaseTableDeckle: Record "Schedule Base Table 1";
        PaperTypeBaseTable: Record "Schedule Base Table 2";
        PaserGSMBaseTable: Record "Schedule Base Table 3";
        TempDeckleSize: Code[20];
    begin
        // Lines added by deepak Kumar
        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        if BaseTableDeckle.FindSet then
            BaseTableDeckle.DeleteAll(true);


        PaperTypeBaseTable.Reset;
        PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        if PaperTypeBaseTable.FindSet then
            PaperTypeBaseTable.DeleteAll(true);

        PaserGSMBaseTable.Reset;
        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Schedule No.", ScheduleHeader."Schedule No.");
        if PaserGSMBaseTable.FindSet then
            PaserGSMBaseTable.DeleteAll(true);

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetCurrentKey("Deckle Size Schedule(mm)");
        if ProductionScheduleLine.FindFirst then begin
            TempDeckleSize := '';
            repeat
                if TempDeckleSize <> ProductionScheduleLine."Deckle Size Schedule(mm)" then begin
                    BaseTableDeckle.Init;
                    BaseTableDeckle."Schedule No." := ProductionScheduleLine."Schedule No.";
                    BaseTableDeckle."Deckle Size" := Format(ProductionScheduleLine."Planned Deckle Size(mm)");
                    BaseTableDeckle."Deckle Size(Num)" := ProductionScheduleLine."Planned Deckle Size(mm)";
                    BaseTableDeckle.Insert(true);
                    TempDeckleSize := ProductionScheduleLine."Deckle Size Schedule(mm)";
                end;
            until ProductionScheduleLine.Next = 0;
        end;


        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange(BaseTableDeckle."Schedule No.", ScheduleHeader."Schedule No.");
        if BaseTableDeckle.FindFirst then begin
            repeat
                ProductionScheduleLine.Reset;
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", BaseTableDeckle."Schedule No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Deckle Size Schedule(mm)", BaseTableDeckle."Deckle Size");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
                if ProductionScheduleLine.FindFirst then begin
                    repeat
                        ProdOrderCompLine.Reset;
                        ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
                        ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                        ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                        ProdOrderCompLine.SetRange(ProdOrderCompLine."Schedule Component", false);
                        if ProdOrderCompLine.FindFirst then begin
                            repeat
                                ItemMaster.Get(ProdOrderCompLine."Item No.");
                                // Update Paper Type
                                PaperTypeBaseTable.Reset;
                                PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Schedule No.", ProductionScheduleLine."Schedule No.");
                                PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Deckle Size", BaseTableDeckle."Deckle Size");
                                PaperTypeBaseTable.SetRange(PaperTypeBaseTable."Paper Type", ItemMaster."Paper Type");
                                if not PaperTypeBaseTable.FindFirst then begin
                                    PaperTypeBaseTable.Init;
                                    PaperTypeBaseTable."Schedule No." := BaseTableDeckle."Schedule No.";
                                    PaperTypeBaseTable."Deckle Size" := BaseTableDeckle."Deckle Size";
                                    PaperTypeBaseTable."Deckle Size(Num)" := BaseTableDeckle."Deckle Size(Num)";
                                    PaperTypeBaseTable."Paper Type" := ItemMaster."Paper Type";
                                    PaperTypeBaseTable."Total Requirement (kg)" := ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule";
                                    PaperTypeBaseTable.Insert(true);
                                end else begin
                                    PaperTypeBaseTable."Total Requirement (kg)" := PaperTypeBaseTable."Total Requirement (kg)" + (ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule");
                                    PaperTypeBaseTable.Modify(true);
                                end;
                                // Update Paper GSM
                                PaserGSMBaseTable.Reset;
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Schedule No.", BaseTableDeckle."Schedule No.");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Deckle Size", BaseTableDeckle."Deckle Size");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Paper Type", ItemMaster."Paper Type");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Paper GSM", Format(ItemMaster."Paper GSM"));
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Item No.", ProdOrderCompLine."Item No.");
                                if not PaserGSMBaseTable.FindFirst then begin
                                    PaserGSMBaseTable.Init;
                                    PaserGSMBaseTable."Schedule No." := BaseTableDeckle."Schedule No.";
                                    PaserGSMBaseTable."Deckle Size" := BaseTableDeckle."Deckle Size";
                                    PaserGSMBaseTable."Deckle Size(Num)" := BaseTableDeckle."Deckle Size(Num)";
                                    PaserGSMBaseTable."Paper Type" := ItemMaster."Paper Type";
                                    PaserGSMBaseTable."Paper GSM" := Format(ItemMaster."Paper GSM");
                                    PaserGSMBaseTable."Paper GSM(Num)" := (ItemMaster."Paper GSM");
                                    PaserGSMBaseTable."Item No." := ProdOrderCompLine."Item No.";
                                    PaserGSMBaseTable."Total Requirement (kg)" := ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule";
                                    PaserGSMBaseTable.Insert(true);
                                end else begin
                                    PaserGSMBaseTable."Total Requirement (kg)" := PaserGSMBaseTable."Total Requirement (kg)" + ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule";
                                    PaserGSMBaseTable.Modify(true);
                                end;
                            until ProdOrderCompLine.Next = 0;
                        end;
                    until ProductionScheduleLine.Next = 0;
                end;
            until BaseTableDeckle.Next = 0;
        end;
    end;

    procedure CalculateIdealDeckleSize(ScheduleHeader: Record "Production Schedule")
    var
        TempUps: Integer;
        TempRollWidth: Decimal;
        MaxDeckleSize: Code[20];
    begin
        // Lines added By Deepak Kumar
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        if ProductionScheduleLine.FindFirst then begin
            repeat
                TempUps := ScheduleHeader."Machine Max Ups";
                TempRollWidth := 0;
                repeat
                    TempRollWidth := (ProductionScheduleLine."Board Width(mm)" * TempUps) + ScheduleHeader."Min Trim";
                    if (TempRollWidth < ScheduleHeader."Machine Max Deckle Size") and (ProductionScheduleLine."Ideal Deckle Size" = 0) then begin
                        MaxDeckleSize := Format(TempRollWidth) + '..' + Format(TempRollWidth + (ScheduleHeader."Maximum Extra Trim" - ScheduleHeader."Min Trim"));
                        ItemMaster.Reset;
                        ItemMaster.SetFilter(ItemMaster."Deckle Size (mm)", MaxDeckleSize);
                        Message(ItemMaster.GetFilters);
                        if ItemMaster.FindFirst then begin
                            ProductionScheduleLine."Ideal Deckle Size" := ItemMaster."Deckle Size (mm)";
                            ProductionScheduleLine.Modify(true);
                        end;
                    end;
                    TempUps := TempUps - 1;
                until TempUps = 0;
            until ProductionScheduleLine.Next = 0;
            Message('Complete');
        end;
    end;

    procedure FinishSchedule(ScheduleHeader: Record "Production Schedule")
    var
        Answer: Boolean;
    begin
        // Lines added By Deepak Kumar
        ScheduleHeader.TestField(ScheduleHeader."Schedule Closed", false);
        ScheduleHeader.TestField(ScheduleHeader."Schedule Published", true);
        Answer := DIALOG.Confirm('Do you want to Close Schedule Order %1 ?', true, ScheduleHeader."Schedule No.");
        if Answer = true then begin
            ProductionScheduleLine.Reset;
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
            if ProductionScheduleLine.FindFirst then begin
                repeat
                    ProductionScheduleLine."Schedule Closed" := true;
                    ProductionScheduleLine.Modify(true);
                until ProductionScheduleLine.Next = 0;
                ScheduleHeader."Schedule Closed" := true;
                ScheduleHeader.Status := ScheduleHeader.Status::Closed;
                ScheduleHeader.Modify(true);
                Message('Schedule Closed');
            end;
        end;
    end;

    procedure GenerateOutputLine(OutputLine: Record "Item Journal Line")
    var
        PRODCMPSdataImport: Record "PROD. CMPS data Import";
        NewItemJournal: Record "Item Journal Line";
        TempLineNo: Integer;
        ProductionScheduleline: Record "Production Schedule Line";
    begin
        // Lines added By Deepak Kumar
        PRODCMPSdataImport.Reset;
        PRODCMPSdataImport.SetRange(PRODCMPSdataImport."CUSTOMER CODE", OutputLine."Schedule Doc. No.");
        if PRODCMPSdataImport.FindFirst then begin
            TempLineNo := 1000;
            repeat
                ProductionScheduleline.Reset;
                ProductionScheduleline.SetRange(ProductionScheduleline.SchedulerIdentifier, PRODCMPSdataImport.REMARK);
                ProductionScheduleline.SetRange(ProductionScheduleline.Published, true);
                ProductionScheduleline.SetRange(ProductionScheduleline."Schedule Closed", false);
                if ProductionScheduleline.FindFirst then begin
                    NewItemJournal.Init;
                    NewItemJournal."Journal Template Name" := OutputLine."Journal Template Name";
                    NewItemJournal."Journal Batch Name" := OutputLine."Journal Batch Name";
                    NewItemJournal."Line No." := TempLineNo;
                    TempLineNo := TempLineNo + 1;

                    //NewItemJournal."Posting Date":=
                    NewItemJournal."Entry Type" := NewItemJournal."Entry Type"::Output;
                    NewItemJournal."Order Type" := NewItemJournal."Order Type"::Production;
                    NewItemJournal.Validate(NewItemJournal."Order No.", ProductionScheduleline."Prod. Order No.");
                    NewItemJournal.Validate(NewItemJournal."Order Line No.", ProductionScheduleline."Prod. Order Line No.");
                    NewItemJournal.Validate(NewItemJournal."Item No.", ProductionScheduleline."Item Code");
                    NewItemJournal.Validate(NewItemJournal."Operation No.", ProductionScheduleline."Operation No");

                end else begin
                    Error('Schedule Line %1 not found in system, Please contact your System Administrator', ProductionScheduleline.GetFilters);
                end;
            until PRODCMPSdataImport.Next = 0;
        end;
    end;

    procedure RemoveUnSelectedLine(ScheduleHeader: Record "Production Schedule")
    var
        ScheduleLine: Record "Production Schedule Line";
    begin
        // Lines added By Deepak Kumar
        ScheduleLine.Reset;
        ScheduleLine.SetRange(ScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ScheduleLine.SetRange(ScheduleLine."Schedule Line", false);
        ScheduleLine.SetRange(ScheduleLine."Marked for Publication", false);
        if ScheduleLine.FindSet then begin
            ScheduleLine.DeleteAll(true);
            Message('Un selected Line removed from Schedule %1', ScheduleLine."Schedule No.");
        end else
            Error('There is no Line to remove');
    end;

    procedure TempCalcPostingLine(RequisitionNumber: Code[20])
    var
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        ItemJnlLine: Record "Item Journal Line";
        TempLineNumber: Integer;
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
        DocNo: Code[50];
        MaterialReqLine: Record "Requisition Line SAM";
        ItemJournalPost: Codeunit "Item Jnl.-Post Batch";
        TotalQtytoPost: Decimal;
    begin
        //Lines added by Deepak Kumar
        SchItemLine.Reset;
        SchItemLine.SetRange(SchItemLine."Requisition No.", RequisitionNumber);
        if SchItemLine.FindFirst then begin
            DocNo := '';
            repeat
                SchItemLine.TestField(SchItemLine."Quantity to Consume");
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                if SchProdLine.FindFirst then begin
                    TotalQtytoPost := 0;
                    repeat
                        SchProdLine.CalcFields(SchProdLine."Actual Output Quantity");
                        SchProdLine."Expected Consumption" := (SchProdLine."Actual Output Quantity" * SchProdLine."Quantity Per");
                        SchProdLine.Modify(true);

                        // Get Consumption ratio
                        SchProdLine.CalcFields(SchProdLine."Temp Total Exp. Consumption");
                        if SchProdLine."Temp Total Exp. Consumption" > 0 then
                            SchProdLine."Consumption Ratio" := (SchProdLine."Expected Consumption" / SchProdLine."Temp Total Exp. Consumption") * 100;
                        SchProdLine."Qty to be Post" := Round(((SchItemLine."Quantity to Consume" * SchProdLine."Consumption Ratio") / 100), 0.01);
                        TotalQtytoPost := TotalQtytoPost + SchProdLine."Qty to be Post";
                        SchProdLine.Modify(true);
                    until SchProdLine.Next = 0;
                    // Manage Rounding Quantity
                    SchProdLine."Qty to be Post" := SchProdLine."Qty to be Post" + (SchItemLine."Quantity to Consume" - TotalQtytoPost);
                    SchProdLine.Modify(true);

                end else begin
                    Error('There are no Prod. Order selected for Item Number %1', SchItemLine."Item Code");
                end;
            until SchItemLine.Next = 0;
        end;
    end;

    procedure TempPostConsumptionLine(RequisitionNumber: Code[20])
    var
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        ItemJnlLine: Record "Item Journal Line";
        TempLineNumber: Integer;
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
        DocNo: Code[50];
        MaterialReqLine: Record "Requisition Line SAM";
        ItemJournalPost: Codeunit "Item Jnl.-Post Batch";
        ConItemSelection: Record "Con. Item Selection N";
        ConsProdOrderSelection: Record "Cons. Prod. Order Selection";
        "TempQtyto Post": Decimal;
    begin
        //Lines added by Deepak Kumar
        if RequisitionNumber = '' then
            Error('Req Number Must Not be Blank');

        ItemJnlLine.Reset;
        ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", 'Item');
        ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", 'Default');
        if ItemJnlLine.FindFirst then begin
            repeat
                ItemJnlLine.DeleteAll(true);
            until ItemJnlLine.Next = 0;
        end;

        SchItemLine.Reset;
        SchItemLine.SetRange(SchItemLine."Requisition No.", RequisitionNumber);
        if SchItemLine.FindFirst then begin
            DocNo := '';
            repeat
                // For Create Item Line
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                if SchProdLine.FindFirst then begin
                    if DocNo = '' then begin
                        ItemJnlBatch.Get('Item', 'Default');
                        NoSeriesMgt.InitSeries(ItemJnlBatch."Posting No. Series", ItemJnlBatch."Posting No. Series", Today, DocNo, ItemJnlBatch."Posting No. Series");
                        TempLineNumber := 10000;
                    end;
                    "TempQtyto Post" := 0;
                    repeat


                        ItemJnlLine.Init;
                        ItemJnlLine."Journal Template Name" := 'Item';
                        ItemJnlLine."Journal Batch Name" := 'Default';
                        ItemJnlLine."Line No." := TempLineNumber;
                        ItemJnlLine."Document No." := DocNo;
                        TempLineNumber += 1;
                        ItemJnlLine.Insert(true);

                        ItemJnlLine.Validate("Order Type", ItemJnlLine."Order Type"::Production);
                        ItemJnlLine.Validate("Order No.", SchProdLine."Prod. Order No.");
                        ItemJnlLine.Validate("Order Line No.", SchProdLine."Prod. Order Line No");


                        ItemJnlLine.Validate("Item No.", SchItemLine."Item Code");
                        ItemJnlLine.Validate("Variant Code", SchItemLine."Roll ID");
                        ItemJnlLine.Validate(Quantity, (Round(((SchItemLine."Quantity to Consume" * SchProdLine."Consumption Ratio") / 100), 0.01)));
                        "TempQtyto Post" := "TempQtyto Post" + ItemJnlLine.Quantity;

                        Item.Get(SchItemLine."Item Code");
                        ItemJnlLine."Posting Date" := WorkDate;
                        ItemJnlLine."Paper GSM" := Format(Item."Paper GSM");
                        ItemJnlLine."Paper Type" := Item."Paper Type";
                        ItemJnlLine."Deckle Size (mm)" := Item."Deckle Size (mm)";
                        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Consumption;
                        ItemJnlLine."Source Code" := 'ITEMJNL';

                        MaterialReqLine.Reset;
                        MaterialReqLine.SetRange(MaterialReqLine."Requisition No.", SchItemLine."Requisition No.");
                        //MaterialReqLine.SETRANGE(MaterialReqLine."Requisition Line No.",SchItemLine."Req. Line Number");
                        if MaterialReqLine.FindFirst then begin
                            ItemJnlLine."Requisition No." := MaterialReqLine."Requisition No.";
                            ItemJnlLine."Requisition Line No." := MaterialReqLine."Requisition Line No.";
                            ItemJnlLine."Requisition Rem. Quantity" := MaterialReqLine."Remaining Quantity";
                        end;

                        ItemJnlLine.Modify(true);
                    until SchProdLine.Next = 0;
                    ItemJnlLine.Validate(Quantity, (ItemJnlLine.Quantity + (SchItemLine."Quantity to Consume" - "TempQtyto Post")));
                    ItemJnlLine.Modify(true);
                end;
            until SchItemLine.Next = 0;
            ItemJnlLine.Reset;
            ItemJnlLine.SetRange(ItemJnlLine."Requisition No.", RequisitionNumber);
            ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", 'Item');
            ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", 'Default');
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJnlLine);
        end;

        ConItemSelection.Reset;
        if ConItemSelection.FindSet then
            ConItemSelection.DeleteAll(true);

        ConsProdOrderSelection.Reset;
        if ConsProdOrderSelection.FindSet then
            ConsProdOrderSelection.DeleteAll(true);
    end;

    procedure TempGetConsumptionLine(ReqNo: Code[20])
    var
        ReqHeader: Record "Requisition Header";
        ReqLine: Record "Requisition Line SAM";
        SchItemLine: Record "Con. Item Selection 1";
        SchProdLine: Record "Cons. Prod. Order Selection";
        TempLine: Integer;
        ProdOrderComp: Record "Prod. Order Component";
        TempLineNumber: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        // Lines added By Deepak Kumar
        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", ReqNo);
        if ReqHeader.FindFirst then begin
            ReqHeader.TestField(ReqHeader."Requisition Type", ReqHeader."Requisition Type"::"Production Schedule");
            ReqHeader.TestField(ReqHeader."Schedule Document No.");
            // Lines for Production Order
            ProdOrderComp.Reset;
            ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
            ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", ReqHeader."Schedule Document No.");
            ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", true);
            //ProdOrderComp.SETFILTER(ProdOrderComp."Remaining Quantity",'>0');
            if ProdOrderComp.FindFirst then begin
                TempLine := 1000;
                repeat
                    SchProdLine.Init;
                    SchProdLine."Prod. Schedule No" := ProdOrderComp."Prod Schedule No.";
                    SchProdLine."Line No." := TempLine;
                    TempLine += 1000;
                    SchProdLine."Prod. Order No." := ProdOrderComp."Prod. Order No.";
                    SchProdLine."Prod. Order Line No" := ProdOrderComp."Prod. Order Line No.";
                    SchProdLine."Item Code" := ProdOrderComp."Item No.";
                    SchProdLine."Paper Position" := ProdOrderComp."Paper Position";
                    SchProdLine."Expected Consumption" := ProdOrderComp."Expected Quantity";
                    ProdOrderComp.CalcFields(ProdOrderComp."Actual Consumed");
                    SchProdLine."Posted Consumption" := ProdOrderComp."Actual Consumed";
                    SchProdLine."Requisition No." := ReqHeader."Requisition No.";
                    SchProdLine."Quantity Per" := ProdOrderComp."Quantity per";
                    SchProdLine.Insert(true);
                until ProdOrderComp.Next = 0;
            end;
            Message('Complete');
        end;
    end;

    procedure NewGetConsumptionLine(ReqNo: Code[20])
    var
        ReqHeader: Record "Requisition Header";
        ReqLine: Record "Requisition Line SAM";
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        TempLine: Integer;
        ProdOrderComp: Record "Prod. Order Component";
        TempLineNumber: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ManufacturingSetup: Record "Manufacturing Setup";
        TempProdOrderNumber: Code[50];
    begin
        // Lines added By Deepak Kumar
        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", ReqNo);
        if ReqHeader.FindFirst then begin
            ReqHeader.TestField(ReqHeader."Requisition Type", ReqHeader."Requisition Type"::"Production Schedule");
            ReqHeader.TestField(ReqHeader."Schedule Document No.");
            // Lines for Production Order
            ProdOrderComp.Reset;
            ProdOrderComp.SetCurrentKey("Prod. Order No.");
            ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
            ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", ReqHeader."Schedule Document No.");
            ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", true);
            if ProdOrderComp.FindFirst then begin
                TempLine := 1000;
                TempProdOrderNumber := '';
                repeat
                    if TempProdOrderNumber <> ProdOrderComp."Prod. Order No." then begin
                        TempProdOrderNumber := ProdOrderComp."Prod. Order No.";
                        SchProdLine.Init;
                        SchProdLine."Prod. Schedule No" := ProdOrderComp."Prod Schedule No.";
                        SchProdLine."Line No." := TempLine;
                        TempLine += 1000;
                        SchProdLine."Prod. Order No." := ProdOrderComp."Prod. Order No.";
                        SchProdLine."Prod. Order Line No" := ProdOrderComp."Prod. Order Line No.";
                        SchProdLine."Item Code" := ProdOrderComp."Item No.";
                        SchProdLine."Paper Position" := ProdOrderComp."Paper Position";
                        SchProdLine."Take Up" := ProdOrderComp."Take Up";
                        SchProdLine."Flute Type" := ProdOrderComp."Flute Type";
                        SchProdLine."Take Up" := ProdOrderComp."Take Up";
                        SchProdLine."Flute Type" := ProdOrderComp."Flute Type";
                        SchProdLine."Expected Consumption" := ProdOrderComp."Expected Quantity";
                        ProdOrderComp.CalcFields(ProdOrderComp."Actual Consumed");
                        SchProdLine."Posted Consumption" := ProdOrderComp."Actual Consumed";
                        SchProdLine."Requisition No." := ReqHeader."Requisition No.";
                        SchProdLine."Quantity Per" := ProdOrderComp."Quantity per";
                        SchProdLine.Insert(true);
                    end;
                until ProdOrderComp.Next = 0;
            end;

            ManufacturingSetup.Get;
            ItemLedgerEntry.Reset;
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Requisition No.", ReqHeader."Requisition No.");
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Transfer);
            ItemLedgerEntry.SetRange(ItemLedgerEntry.Positive, true);
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", ManufacturingSetup."Corrugation Location");
            if ItemLedgerEntry.FindFirst then begin
                TempLineNumber := 10000;
                repeat

                    if ItemLedgerEntry."Remaining Quantity" <> 0 then begin
                        SchItemLine.Init;
                        SchItemLine."Prod. Schedule No" := ReqHeader."Schedule Document No.";
                        SchItemLine."Line Number" := TempLineNumber;
                        SchItemLine."Requisition No." := ReqHeader."Requisition No.";
                        SchItemLine.Validate("Item Code", ItemLedgerEntry."Item No.");
                        SchItemLine.Validate("Roll ID", ItemLedgerEntry."Variant Code");
                        SchItemLine.Insert(true);
                        TempLineNumber := TempLineNumber + 10000;
                    end;
                until ItemLedgerEntry.Next = 0;
            end;
            Message('Complete');
        end;
    end;

    procedure MakePriorityOnJobMannualAsortment(ScheduleHeader: Record "Production Schedule")
    var
        PriorityNumber: Integer;
    begin
        // Lines added BY Deepak Kumar
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetCurrentKey("Schedule No.", Flute, "No. Of Ply", "Deckle Size Schedule(mm)", "Top Colour", "Qty to Schedule Net Weight");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        ProductionScheduleLine.Ascending(false);
        if ProductionScheduleLine.FindFirst then begin
            PriorityNumber := 10;
            repeat
                ProductionScheduleLine."Priority By System" := PriorityNumber;
                ProductionScheduleLine."Modified Priority" := PriorityNumber;
                PriorityNumber += 10;
                ProductionScheduleLine.Modify(true);
            until ProductionScheduleLine.Next = 0;
        end;
    end;

    procedure CreateLoadData()
    var
        FromDate: Date;
        ToDate: Date;
        EstimateHeader: Record "Product Design Header";
        SalesLine: Record "Sales Line";
        LoadSheetLine: Record "Load In Corrugartion";
        MachineCenter: Record "Machine Center";
    begin

        // Lines added By Deepak Kumar
        LoadSheetLine.Reset;
        if LoadSheetLine.FindSet then
            LoadSheetLine.DeleteAll(true);

        ProductionOrder.Reset;
        ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
        ProductionOrder.SetRange(ProductionOrder."Eliminate in Prod. Schedule", false);
        if ProductionOrder.FindFirst then begin
            ProgressWindow.Open('Production Order No. #1#######');
            MachineCenter.Reset;
            MachineCenter.SetRange(MachineCenter."Work Center Category", MachineCenter."Work Center Category"::Corrugation);
            if MachineCenter.FindFirst then

                repeat
                    ProgressWindow.Update(1, ProductionOrder."No.");
                    ProdOrderRoutLine.Reset;
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine.Status, ProductionOrder.Status);
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine."Prod. Order No.", ProductionOrder."No.");
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine.Type, ProdOrderRoutLine.Type::"Machine Center");
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine."No.", MachineCenter."No.");
                    if ProdOrderRoutLine.FindFirst then begin

                        repeat
                            ProdOrderLine.Reset;
                            ProdOrderLine.SetRange(ProdOrderLine.Status, ProdOrderRoutLine.Status);
                            ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", ProdOrderRoutLine."Prod. Order No.");
                            ProdOrderLine.SetRange(ProdOrderLine."Line No.", ProdOrderRoutLine."Routing Reference No.");
                            ProdOrderLine.FindFirst;
                            ProdOrderRoutLine.CalcFields(ProdOrderRoutLine."Actual Output Quantity");
                            if (ProdOrderLine."Remaining Quantity" > 0) and (ProdOrderRoutLine."Actual Output Quantity" < ProdOrderLine.Quantity) then begin
                                ItemMaster.Get(ProdOrderLine."Item No.");

                                LoadSheetLine.Init;
                                LoadSheetLine."Schedule No." := 'LoadSheet';
                                LoadSheetLine."Prod. Order No." := ProductionOrder."No.";
                                LoadSheetLine."Prod. Order Line No." := ProdOrderRoutLine."Routing Reference No.";
                                LoadSheetLine."Schedule Date" := WorkDate;
                                LoadSheetLine."Requested Delivery Date" := ProductionOrder."Due Date";
                                LoadSheetLine."Prod. Order Quanity" := ProdOrderLine.Quantity;
                                LoadSheetLine."Operation No" := ProdOrderRoutLine."Operation No.";

                                //LoadSheetLine."Quantity To Schedule":=ProdOrderLine."Remaining Quantity";
                                LoadSheetLine."Machine No." := ProdOrderRoutLine."No.";
                                LoadSheetLine."Machine Name" := ProdOrderRoutLine.Description;
                                LoadSheetLine."Item Code" := ProdOrderLine."Item No.";
                                LoadSheetLine."Item Description" := ItemMaster.Description;//ProdOrderLine.Description;
                                LoadSheetLine."Customer Name" := ProductionOrder."Customer Name";
                                LoadSheetLine."No. Of Ply" := ItemMaster."No. of Ply";
                                LoadSheetLine.Flute := ItemMaster."Flute Type";
                                LoadSheetLine."Flute 1" := ItemMaster."Flute 1";
                                LoadSheetLine."Flute 2" := ItemMaster."Flute 2";
                                LoadSheetLine."Flute 3" := ItemMaster."Flute 3";
                                LoadSheetLine."Top Colour" := ItemMaster."Color Code";
                                LoadSheetLine.SchedulerIdentifier := ProductionOrder."No." + Format(ProdOrderRoutLine."Routing Reference No.");

                                LoadSheetLine."Product Design No." := ProdOrderLine."Product Design No.";
                                LoadSheetLine."Estimation Sub Job No." := ProdOrderLine."Sub Comp No.";
                                EstimateHeader.Reset;
                                EstimateHeader.SetRange(EstimateHeader."Product Design No.", ProdOrderLine."Product Design No.");
                                EstimateHeader.SetRange(EstimateHeader."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                                if EstimateHeader.FindFirst then begin
                                    LoadSheetLine."No. Of Ply" := EstimateHeader."No. of Ply";
                                    LoadSheetLine."Board Length(mm)" := EstimateHeader."Board Length (mm)- L";
                                    LoadSheetLine."Board Width(mm)" := EstimateHeader."Board Width (mm)- W";
                                    LoadSheetLine."No. of Ups (Estimated)" := EstimateHeader."Board Ups";
                                    LoadSheetLine."Trim Product Design" := EstimateHeader."Trim Size (mm)";
                                    LoadSheetLine."Cut Size (mm)" := EstimateHeader."Cut Size (mm)";
                                    LoadSheetLine."FG GSM" := EstimateHeader.Grammage;
                                    LoadSheetLine."No of Die Cut" := EstimateHeader."No. of Die Cut Ups";
                                    LoadSheetLine."No. of Joint" := EstimateHeader."No. of Joint";
                                end;
                                LoadSheetLine."Sales Order No" := ProductionOrder."Sales Order No.";
                                SalesLine.Reset;
                                SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
                                SalesLine.SetRange(SalesLine."Document No.", ProductionOrder."Sales Order No.");
                                SalesLine.SetRange(SalesLine."Line No.", ProductionOrder."Sales Order Line No.");
                                if SalesLine.FindFirst then begin
                                    LoadSheetLine."Customer Order No." := SalesLine."External Doc. No.";
                                    LoadSheetLine."Sales Order Quantity" := SalesLine.Quantity;
                                end;

                                LoadSheetLine."Board Length(mm)" := ItemMaster."Board Length";
                                LoadSheetLine."Board Width(mm)" := ItemMaster."Board Width";
                                LoadSheetLine."Product Design No." := ProductionOrder."Estimate Code";
                                LoadSheetLine.Insert(true);
                                //END;
                            end;
                        until ProdOrderRoutLine.Next = 0;
                    end;
                until ProductionOrder.Next = 0;
            ClacUpsDeckleLengthLoadSheet;
            UpdateGSMIdentifierOfLoadSheet;
            ProgressWindow.Close;
        end;
    end;

    procedure ClacUpsDeckleLengthLoadSheet()
    var
        TempBoardUps: Integer;
        TempExtraTrim: Decimal;
        ProdLoadSheet: Record "Load In Corrugartion";
    begin

        // Lines added BY Deepak kumar
        ProdLoadSheet.Reset;
        if ProdLoadSheet.FindFirst then begin
            repeat
                TempBoardUps := 0;
                if ProdLoadSheet."Board Width(mm)" <> 0 then
                    TempBoardUps := Round((((1800) - ProdLoadSheet."Trim Product Design") / ProdLoadSheet."Board Width(mm)"), 1, '<');

                if TempBoardUps > 4 then begin
                    ProdLoadSheet."Calculated No. of Ups" := 4;
                end else begin
                    ProdLoadSheet."Calculated No. of Ups" := TempBoardUps;
                end;
                ProdLoadSheet.CalcFields("RPO Finished Quantity", "RPO Remaining Quantity", "Quantity in Other Schedules");

                ProdLoadSheet."Quantity To Schedule" := ProdLoadSheet."Prod. Order Quanity" - (ProdLoadSheet."RPO Finished Quantity" + ProdLoadSheet."Quantity in Other Schedules");
                if ProdLoadSheet."Quantity To Schedule" < 0 then
                    ProdLoadSheet."Quantity To Schedule" := 0;
                ProdLoadSheet."Linear Length(Mtr)" := ((ProdLoadSheet."Quantity To Schedule" * ProdLoadSheet."Board Length(mm)") / ProdLoadSheet."Calculated No. of Ups") / 1000;
                ProdLoadSheet."Net Weight" := ((ProdLoadSheet."Board Length(mm)" * ProdLoadSheet."Board Width(mm)" * ProdLoadSheet."FG GSM") / 1000000000) * ProdLoadSheet."Quantity To Schedule";
                ProdLoadSheet."Net Weight (Other Schedule)" := ((ProdLoadSheet."Board Length(mm)" * ProdLoadSheet."Board Width(mm)" * ProdLoadSheet."FG GSM") / 1000000000) * ProdLoadSheet."Quantity in Other Schedules";
                ProdLoadSheet."M2 Weight" := ((ProdLoadSheet."Board Length(mm)" * ProdLoadSheet."Board Width(mm)") / 1000000) * ProdLoadSheet."Quantity To Schedule";
                ProdLoadSheet."Box Quantity" := Round(((ProdLoadSheet."Quantity To Schedule" * ProdLoadSheet."No of Die Cut") / ProdLoadSheet."No. of Joint"), 1, '>');
                ProdLoadSheet.Modify(true);

            until ProdLoadSheet.Next = 0;
        end;
    end;

    procedure UpdateGSMIdentifierOfLoadSheet()
    var
        TempGSMTypeIdentifier: Code[200];
        TempDeckleSize: Decimal;
        ProdLoadSheet: Record "Load In Corrugartion";
    begin
        // Lines added By Deepak Kumar

        ProdLoadSheet.Reset;
        if ProdLoadSheet.FindFirst then begin
            repeat
                ProdOrderCompLine.Reset;
                ProdOrderCompLine.SetCurrentKey(Status, "Prod. Order No.", "Paper Position");
                ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.", ProdLoadSheet."Prod. Order No.");
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order Line No.", ProdLoadSheet."Prod. Order Line No.");
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Schedule Component", false);
                if ProdOrderCompLine.FindFirst then begin
                    TempGSMTypeIdentifier := '';
                    TempDeckleSize := 5000;
                    repeat
                        ItemMaster.Get(ProdOrderCompLine."Item No.");
                        TempGSMTypeIdentifier := TempGSMTypeIdentifier + Format(ItemMaster."Paper GSM") + ItemMaster."Paper Type";

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Liner1 then begin
                            if ProdLoadSheet."Top Colour" = '' then
                                ProdLoadSheet."Top Colour" := ItemMaster."Paper Type";
                        end;
                        if TempDeckleSize > ItemMaster."Deckle Size (mm)" then
                            TempDeckleSize := ItemMaster."Deckle Size (mm)";
                        // Lines for Update Layer Wise paper
                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Liner1 then
                            ProdLoadSheet."DB Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Flute1 then
                            ProdLoadSheet."1M Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Liner2 then
                            ProdLoadSheet."1L Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Flute2 then
                            ProdLoadSheet."2M Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                        if ProdOrderCompLine."Paper Position" = ProdOrderCompLine."Paper Position"::Liner3 then
                            ProdLoadSheet."2L Paper" := ItemMaster."Paper Type" + Format(ItemMaster."Paper GSM");

                    until ProdOrderCompLine.Next = 0;
                    ProdLoadSheet."Planned Deckle Size(mm)" := TempDeckleSize;
                    ProdLoadSheet."GSM Identifier" := TempGSMTypeIdentifier;
                    ProdLoadSheet.Modify(true);
                end;
            until ProdLoadSheet.Next = 0;
        end;
    end;

    procedure CreateProdOrderCompLine(ScheduleHeader: Record "Production Schedule")
    var
        DeckleBaseTable: Record "Schedule Base Table 1";
        ProdOrderComp: Record "Prod. Order Component";
        Sam001: Label '<>''''';
        CompItem: Record Item;
        BOMLine: Integer;
        TempProdComponentLine: Record "Prod. Order Component";
        PaperGSMLine: Record "Schedule Base Table 3";
        TempQtyPer: Decimal;
        ProdOrder: Record "Production Order";
    begin
        // Lines added BY Deepak Kumar


        if ScheduleHeader."Manual Assortment" = true then begin
            ProductionScheduleLine.Reset;
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
            // ProductionScheduleLine.SETRANGE(ProductionScheduleLine."Re-Publish Component",TRUE);
            if ProductionScheduleLine.FindFirst then begin
                ProgressWindow.Open('Production Order No. #1#######');
                repeat
                    ProductionScheduleLine.CalcFields(ProductionScheduleLine."Prod. Comp Line Aval");
                    if not ProductionScheduleLine."Prod. Comp Line Aval" = true then begin
                        ProgressWindow.Update(1, ProductionScheduleLine."Prod. Order No.");
                        TempProdComponentLine.Reset;
                        TempProdComponentLine.SetCurrentKey("Prod. Order No.", "Prod. Order Line No.", "Line No.", Status);
                        TempProdComponentLine.SetRange(TempProdComponentLine.Status, TempProdComponentLine.Status::Released);
                        TempProdComponentLine.SetRange(TempProdComponentLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                        TempProdComponentLine.SetRange(TempProdComponentLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                        if TempProdComponentLine.FindLast then
                            BOMLine := TempProdComponentLine."Line No.";

                        ProdOrderComp.Reset;
                        ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                        ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                        ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                        ProdOrderComp.SetFilter(ProdOrderComp."Paper Position", Sam001);
                        ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", '');
                        ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", false);
                        if ProdOrderComp.FindFirst then begin
                            repeat
                                ProdOrderCompLine.Init;
                                ProdOrderCompLine := ProdOrderComp;
                                BOMLine += 10;
                                ProdOrderCompLine."Line No." := BOMLine;
                                ProdOrderCompLine."Expected Quantity" := 0;
                                ProdOrderCompLine."Remaining Quantity" := 0;
                                ProdOrderCompLine."Remaining Qty. (Base)" := 0;
                                ProdOrderCompLine."Expected Qty. (Base)" := 0;
                                ProdOrderCompLine.Validate(ProdOrderCompLine."Item No.", ProdOrderComp."Item No.");
                                ProdOrderCompLine."Prod Schedule No." := ProductionScheduleLine."Schedule No.";
                                CompItem.Get(ProdOrderComp."Item No.");
                                // IF CompItem."Paper GSM" <> 0 THEN
                                //   TempQtyPer:=(ProdOrderComp."Quantity per"/CompItem."Paper GSM")*PaperGSMLine."Paper GSM(Num)";
                                // ProdOrderCompLine."Quantity per":=TempQtyPer;
                                ProdOrderCompLine."Quantity per" := ProdOrderComp."Quantity per";
                                ProdOrderCompLine.Validate("Expected Quantity", ProductionScheduleLine."Quantity To Schedule" * TempQtyPer);
                                ProdOrderCompLine.Validate("Remaining Quantity", ProductionScheduleLine."Quantity To Schedule" * TempQtyPer);
                                ProdOrderCompLine.Validate(ProdOrderCompLine."Unit Cost");
                                ProdOrderCompLine."Schedule Component" := true;
                                ProdOrderCompLine.Insert(true);
                            until ProdOrderComp.Next = 0;
                        end;

                        ProductionScheduleLine.Modify(true);
                    end;
                until ProductionScheduleLine.Next = 0;

                ProgressWindow.Close;
                Message('Corrugation Schedule is Published for Production, Order component also created for schedule %1', DeckleBaseTable."Schedule No.");
            end;
        end;
    end;

    procedure CreateLoadDataPrinting()
    var
        FromDate: Date;
        ToDate: Date;
        EstimateHeader: Record "Product Design Header";
        SalesLine: Record "Sales Line";
        LoadSheetLine: Record "Load In Printing";
        MachineCenter: Record "Machine Center";
    begin

        // Lines added By Deepak Kumar
        LoadSheetLine.Reset;
        if LoadSheetLine.FindSet then
            LoadSheetLine.DeleteAll(true);

        ProductionOrder.Reset;
        ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
        if ProductionOrder.FindFirst then begin
            ProgressWindow.Open('Production Order No. #1#######');
            MachineCenter.Reset;
            MachineCenter.SetRange(MachineCenter."Work Center Category", MachineCenter."Work Center Category"::"Printing Guiding");
            if MachineCenter.FindFirst then

                repeat
                    ProgressWindow.Update(1, ProductionOrder."No.");
                    ProdOrderRoutLine.Reset;
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine.Status, ProductionOrder.Status);
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine."Prod. Order No.", ProductionOrder."No.");
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine.Type, ProdOrderRoutLine.Type::"Machine Center");
                    ProdOrderRoutLine.SetRange(ProdOrderRoutLine."No.", MachineCenter."No.");
                    if ProdOrderRoutLine.FindFirst then begin

                        repeat
                            ProdOrderLine.Reset;
                            ProdOrderLine.SetRange(ProdOrderLine.Status, ProdOrderRoutLine.Status);
                            ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", ProdOrderRoutLine."Prod. Order No.");
                            ProdOrderLine.SetRange(ProdOrderLine."Line No.", ProdOrderRoutLine."Routing Reference No.");
                            ProdOrderLine.FindFirst;
                            ProdOrderRoutLine.CalcFields(ProdOrderRoutLine."Actual Output Quantity");
                            if (ProdOrderLine."Remaining Quantity" > 0) and (ProdOrderRoutLine."Actual Output Quantity" < ProdOrderLine.Quantity) then begin
                                ItemMaster.Get(ProdOrderLine."Item No.");

                                LoadSheetLine.Init;
                                LoadSheetLine."Schedule No." := 'LoadSheet';
                                LoadSheetLine."Prod. Order No." := ProductionOrder."No.";
                                LoadSheetLine."Prod. Order Line No." := ProdOrderRoutLine."Routing Reference No.";
                                LoadSheetLine."Schedule Date" := WorkDate;
                                LoadSheetLine."Requested Delivery Date" := ProductionOrder."Due Date";
                                LoadSheetLine."Prod. Order Quanity" := ProdOrderLine.Quantity;
                                LoadSheetLine."Operation No" := ProdOrderRoutLine."Operation No.";

                                //LoadSheetLine."Quantity To Schedule":=ProdOrderLine."Remaining Quantity";
                                LoadSheetLine."Machine No." := ProdOrderRoutLine."No.";
                                LoadSheetLine."Machine Name" := ProdOrderRoutLine.Description;
                                LoadSheetLine."Item Code" := ProdOrderLine."Item No.";
                                LoadSheetLine."Item Description" := ItemMaster.Description;//ProdOrderLine.Description;
                                LoadSheetLine."Customer Name" := ProductionOrder."Customer Name";
                                LoadSheetLine."No. Of Ply" := ItemMaster."No. of Ply";
                                LoadSheetLine.Flute := ItemMaster."Flute Type";
                                LoadSheetLine."Flute 1" := ItemMaster."Flute 1";
                                LoadSheetLine."Flute 2" := ItemMaster."Flute 2";
                                LoadSheetLine."Flute 3" := ItemMaster."Flute 3";
                                LoadSheetLine."Top Colour" := ItemMaster."Color Code";

                                LoadSheetLine."Product Design No." := ProdOrderLine."Product Design No.";
                                LoadSheetLine."Estimation Sub Job No." := ProdOrderLine."Sub Comp No.";
                                EstimateHeader.Reset;
                                EstimateHeader.SetRange(EstimateHeader."Product Design No.", ProdOrderLine."Product Design No.");
                                EstimateHeader.SetRange(EstimateHeader."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                                if EstimateHeader.FindFirst then begin
                                    LoadSheetLine."No. Of Ply" := EstimateHeader."No. of Ply";
                                    LoadSheetLine."Board Length(mm)" := EstimateHeader."Board Length (mm)- L";
                                    LoadSheetLine."Board Width(mm)" := EstimateHeader."Board Width (mm)- W";
                                    LoadSheetLine."No. of Ups (Estimated)" := EstimateHeader."Board Ups";
                                    LoadSheetLine."Trim Product Design" := EstimateHeader."Trim Size (mm)";
                                    LoadSheetLine."Cut Size (mm)" := EstimateHeader."Cut Size (mm)";
                                    LoadSheetLine."FG GSM" := EstimateHeader.Grammage;
                                    LoadSheetLine."No of Die Cut" := EstimateHeader."No. of Die Cut Ups";
                                    LoadSheetLine."No. of Joint" := EstimateHeader."No. of Joint";
                                end;
                                LoadSheetLine."Sales Order No" := ProductionOrder."Sales Order No.";
                                SalesLine.Reset;
                                SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
                                SalesLine.SetRange(SalesLine."Document No.", ProductionOrder."Sales Order No.");
                                SalesLine.SetRange(SalesLine."Line No.", ProductionOrder."Sales Order Line No.");
                                if SalesLine.FindFirst then begin
                                    LoadSheetLine."Customer Order No." := SalesLine."External Doc. No.";
                                    LoadSheetLine."Sales Order Quantity" := SalesLine.Quantity;
                                end;

                                LoadSheetLine."Board Length(mm)" := ItemMaster."Board Length";
                                LoadSheetLine."Board Width(mm)" := ItemMaster."Board Width";
                                LoadSheetLine."Product Design No." := ProductionOrder."Estimate Code";
                                LoadSheetLine.Insert(true);
                                //END;
                            end;
                        until ProdOrderRoutLine.Next = 0;
                    end;
                until ProductionOrder.Next = 0;
            ClacUpsDeckleLengthLoadSheetPrinting();
            ProgressWindow.Close;
        end;
    end;

    procedure ClacUpsDeckleLengthLoadSheetPrinting()
    var
        TempBoardUps: Integer;
        TempExtraTrim: Decimal;
        ProdLoadSheet: Record "Load In Printing";
    begin

        // Lines added BY Deepak kumar
        ProdLoadSheet.Reset;
        if ProdLoadSheet.FindFirst then begin
            repeat
                TempBoardUps := 0;
                if ProdLoadSheet."Board Width(mm)" <> 0 then
                    TempBoardUps := Round((((1800) - ProdLoadSheet."Trim Product Design") / ProdLoadSheet."Board Width(mm)"), 1, '<');

                if TempBoardUps > 4 then begin
                    ProdLoadSheet."Calculated No. of Ups" := 4;
                end else begin
                    ProdLoadSheet."Calculated No. of Ups" := TempBoardUps;
                end;
                ProdLoadSheet.CalcFields("RPO Finished Quantity", "RPO Remaining Quantity");

                ProdLoadSheet."Quantity To Schedule" := ProdLoadSheet."Prod. Order Quanity" - (ProdLoadSheet."RPO Finished Quantity");
                if ProdLoadSheet."Quantity To Schedule" < 0 then
                    ProdLoadSheet."Quantity To Schedule" := 0;

                ProdLoadSheet."Linear Length(Mtr)" := ((ProdLoadSheet."Quantity To Schedule" * ProdLoadSheet."Board Length(mm)") / ProdLoadSheet."Calculated No. of Ups") / 1000;
                ProdLoadSheet."Net Weight" := ((ProdLoadSheet."Board Length(mm)" * ProdLoadSheet."Board Width(mm)" * ProdLoadSheet."FG GSM") / 1000000000) * ProdLoadSheet."Quantity To Schedule";
                ProdLoadSheet."M2 Weight" := ((ProdLoadSheet."Board Length(mm)" * ProdLoadSheet."Board Width(mm)") / 1000000) * ProdLoadSheet."Quantity To Schedule";
                ProdLoadSheet."Box Quantity" := Round(((ProdLoadSheet."Quantity To Schedule" * ProdLoadSheet."No of Die Cut") / ProdLoadSheet."No. of Joint"), 1, '>');
                ProdLoadSheet.Modify(true);

            until ProdLoadSheet.Next = 0;
        end;
    end;

    procedure UpdateExistingSchedule(ScheduleHeader: Record "Production Schedule")
    var
        DeckleBaseTable: Record "Schedule Base Table 1";
        ProdOrderComp: Record "Prod. Order Component";
        Sam001: Label '<>''''';
        CompItem: Record Item;
        BOMLine: Integer;
        TempProdComponentLine: Record "Prod. Order Component";
        PaperGSMLine: Record "Schedule Base Table 3";
        TempQtyPer: Decimal;
        ProdOrder: Record "Production Order";
        PrioritySeries: Integer;
    begin
        // Lines added BY Deepak Kumar
        // Only From manual Asortment


        ScheduleHeader.TestField(ScheduleHeader.Status, ScheduleHeader.Status::Open);
        ScheduleHeader.TestField(ScheduleHeader."Update Existing Schedule", true);
        ScheduleHeader.TestField(ScheduleHeader."Existing Schedule No.");

        if ScheduleHeader."Schedule Published" then
            Error('Schedule %1 already published', ScheduleHeader."Schedule No.");


        // Lines added For maintain the Priotrity
        ExistingProductionScheduleLine.Reset;
        ExistingProductionScheduleLine.SetCurrentKey(ExistingProductionScheduleLine."Modified Priority");
        ExistingProductionScheduleLine.SetRange(ExistingProductionScheduleLine."Schedule No.", ScheduleHeader."Existing Schedule No.");
        ExistingProductionScheduleLine.SetRange(ExistingProductionScheduleLine.Published, true);
        if ExistingProductionScheduleLine.FindLast then begin
            PrioritySeries := ExistingProductionScheduleLine."Modified Priority";

        end;

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        if ProductionScheduleLine.FindFirst then begin
            ProgressWindow.Open('Production Order No. #1#######');
            repeat
                ProgressWindow.Update(1, ProductionScheduleLine."Prod. Order No.");
                TempProdComponentLine.Reset;
                TempProdComponentLine.SetCurrentKey("Prod. Order No.", "Prod. Order Line No.", "Line No.", Status);
                TempProdComponentLine.SetRange(TempProdComponentLine.Status, TempProdComponentLine.Status::Released);
                TempProdComponentLine.SetRange(TempProdComponentLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                TempProdComponentLine.SetRange(TempProdComponentLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                if TempProdComponentLine.FindLast then
                    BOMLine := TempProdComponentLine."Line No.";

                ProdOrderComp.Reset;
                ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                ProdOrderComp.SetFilter(ProdOrderComp."Paper Position", Sam001);
                ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", '');
                ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", false);
                if ProdOrderComp.FindFirst then begin
                    repeat
                        PaperGSMLine.Reset;
                        PaperGSMLine.SetRange(PaperGSMLine."Schedule No.", ProductionScheduleLine."Schedule No.");
                        PaperGSMLine.SetRange(PaperGSMLine."Item No.", ProdOrderComp."Item No.");
                        if PaperGSMLine.FindFirst then begin
                            ProdOrderCompLine.Init;
                            ProdOrderCompLine := ProdOrderComp;
                            BOMLine += 10;
                            ProdOrderCompLine."Line No." := BOMLine;
                            ProdOrderCompLine."Expected Quantity" := 0;
                            ProdOrderCompLine."Remaining Quantity" := 0;
                            ProdOrderCompLine."Remaining Qty. (Base)" := 0;
                            ProdOrderCompLine."Expected Qty. (Base)" := 0;

                            if PaperGSMLine."New Item Number" = '' then
                                ProdOrderCompLine.Validate(ProdOrderCompLine."Item No.", PaperGSMLine."Item No.")
                            else
                                ProdOrderCompLine.Validate(ProdOrderCompLine."Item No.", PaperGSMLine."New Item Number");

                            ProdOrderCompLine."Prod Schedule No." := ScheduleHeader."Existing Schedule No.";//ProductionScheduleLine."Schedule No.";
                            CompItem.Get(ProdOrderComp."Item No.");
                            if CompItem."Paper GSM" <> 0 then
                                TempQtyPer := (ProdOrderComp."Quantity per" / CompItem."Paper GSM") * PaperGSMLine."Paper GSM(Num)";
                            ProdOrderCompLine."Quantity per" := TempQtyPer;

                            ProdOrderCompLine.Validate("Expected Quantity", ProductionScheduleLine."Quantity To Schedule" * TempQtyPer);
                            ProdOrderCompLine.Validate("Remaining Quantity", ProductionScheduleLine."Quantity To Schedule" * TempQtyPer);
                            ProdOrderCompLine.Validate(ProdOrderCompLine."Unit Cost");
                            ProdOrderCompLine."Schedule Component" := true;
                            ProdOrderCompLine.Insert(true);
                        end else begin
                            ProgressWindow.Close;
                            Error('Item not found with following specification, Deckle Size %1 Paper Type %2 Paper GSM %3');
                        end;

                    until ProdOrderComp.Next = 0;
                end;
                //"Schedule No.","Prod. Order No.","Prod. Order Line No.","Deckle Size Schedule(mm)","Schedule Line"
                ProductionScheduleLine."Secondary Updated Line" := true;
                ProductionScheduleLine."Secondary Updated By" := UserId + ' ' + Format(CurrentDateTime);
                ProductionScheduleLine."Priority By System" := PrioritySeries;
                ProductionScheduleLine."Modified Priority" := PrioritySeries;
                PrioritySeries += 1;

                ProductionScheduleLine.Published := true;
                ProductionScheduleLine.Modify(true);

                ProductionScheduleLine.Rename(ScheduleHeader."Existing Schedule No.", ProductionScheduleLine."Prod. Order No.", ProductionScheduleLine."Prod. Order Line No."
                , ProductionScheduleLine."Deckle Size Schedule(mm)", ProductionScheduleLine."Schedule Line");
                //Updated By Deepak Kumar
                ProdOrder.Reset;
                ProdOrder.SetRange(ProdOrder.Status, ProdOrder.Status::Released);
                ProdOrder.SetRange(ProdOrder."No.", ProductionScheduleLine."Prod. Order No.");
                if ProdOrder.FindFirst then begin
                    ProdOrder."Prod Status" := ProdOrder."Prod Status"::"In process";
                    ProdOrder.Modify(true);
                end;
            until ProductionScheduleLine.Next = 0;

            //ScheduleHeader."Schedule Published":=TRUE;
            //ScheduleHeader.Status:=ScheduleHeader.Status::Confirmed;
            //sScheduleHeader.MODIFY(TRUE);
            DeleteExtraLines(ScheduleHeader);
            ProgressWindow.Close;
            Message('Corrugation Schedule is Updated in Published Schedule No %1, Order component also created for the same', ScheduleHeader."Existing Schedule No.");
        end;
    end;

    procedure GetConsumptionLineNew(ReqNo: Code[20])
    var
        ReqHeader: Record "Requisition Header";
        ReqLine: Record "Requisition Line SAM";
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        TempLine: Integer;
        ProdOrderComp: Record "Prod. Order Component";
        TempLineNumber: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ManufacturingSetup: Record "Manufacturing Setup";
        ProductionScheduleLine: Record "Production Schedule Line";
    begin
        // Lines added By Deepak Kumar
        SchProdLine.Reset;
        if SchProdLine.FindSet then begin
            SchProdLine.DeleteAll(true);
        end;
        SchItemLine.Reset;
        if SchItemLine.FindSet then begin
            SchItemLine.DeleteAll(true);
        end;

        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", ReqNo);
        if ReqHeader.FindFirst then begin
            ReqHeader.TestField(ReqHeader."Requisition Type", ReqHeader."Requisition Type"::"Production Schedule");
            ReqHeader.TestField(ReqHeader."Schedule Document No.");
            // Lines for Production Order
            ManufacturingSetup.Get;
            TempLine := 1000;
            ItemLedgerEntry.Reset;
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Requisition No.", ReqHeader."Requisition No.");
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Transfer);
            ItemLedgerEntry.SetRange(ItemLedgerEntry.Positive, true);
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", ManufacturingSetup."Corrugation Location");
            ItemLedgerEntry.SetRange(ItemLedgerEntry.Open, true);
            if ItemLedgerEntry.FindFirst then begin
                TempLineNumber := 10000;
                repeat
                    if ItemLedgerEntry."Remaining Quantity" <> 0 then begin
                        SchItemLine.Init;
                        SchItemLine."Prod. Schedule No" := ReqHeader."Schedule Document No.";
                        SchItemLine."Line Number" := TempLineNumber;
                        SchItemLine."Requisition No." := ReqHeader."Requisition No.";
                        SchItemLine.Validate("Item Code", ItemLedgerEntry."Item No.");
                        SchItemLine.Validate("Roll ID", ItemLedgerEntry."Variant Code");
                        SchItemLine.Insert(true);
                        TempLineNumber := TempLineNumber + 10000;

                        ///_______________________________________________________________
                        ProductionScheduleLine.Reset;
                        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ReqHeader."Schedule Document No.");
                        ProductionScheduleLine.SetRange(ProductionScheduleLine.Published, true);
                        if ProductionScheduleLine.FindFirst then begin
                            repeat
                                ProdOrderComp.Reset;
                                ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                                ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                                ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                                ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", ProductionScheduleLine."Schedule No.");
                                ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", true);
                                if ProdOrderComp.FindFirst then begin
                                    SchProdLine.Init;
                                    SchProdLine."Prod. Schedule No" := ProdOrderComp."Prod Schedule No.";
                                    TempLine += 1000;
                                    SchProdLine."Line No." := TempLine;
                                    SchProdLine."Prod. Order No." := ProdOrderComp."Prod. Order No.";
                                    SchProdLine."Prod. Order Line No" := ProdOrderComp."Prod. Order Line No.";
                                    SchProdLine."No. Of Ply" := ProductionScheduleLine."No. Of Ply";
                                    SchProdLine."Requisition No." := ReqHeader."Requisition No.";
                                    SchProdLine."Item Code" := ItemLedgerEntry."Item No.";
                                    SchProdLine."Variant Code/ Reel Number" := ItemLedgerEntry."Variant Code";
                                    SchProdLine."Take Up" := ProdOrderComp."Take Up";
                                    SchProdLine."Flute Type" := ProdOrderComp."Flute Type";
                                    SchProdLine.Insert(true);
                                end;
                            until ProductionScheduleLine.Next = 0;
                        end;
                        ////_______________________________________________________________________________________________

                    end;
                until ItemLedgerEntry.Next = 0;
            end;

            Message('Complete');
        end;
    end;

    procedure CalcReInitiate(RequisitionNumber: Code[20])
    var
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        ItemJnlLine: Record "Item Journal Line";
        TempLineNumber: Integer;
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
        DocNo: Code[50];
        MaterialReqLine: Record "Requisition Line SAM";
        ItemJournalPost: Codeunit "Item Jnl.-Post Batch";
        TotalQtytoPost: Decimal;
    begin
        //Lines added by Deepak Kumar
        SchItemLine.Reset;
        SchItemLine.SetRange(SchItemLine."Requisition No.", RequisitionNumber);
        if SchItemLine.FindFirst then begin
            DocNo := '';
            repeat
                SchItemLine.TestField(SchItemLine."Quantity to Consume");
                ///-----------------------------------------------------------------------------
                // Lines to Validate the Values Zero
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Paper Position", SchItemLine."Paper Position");
                SchProdLine.SetRange(SchProdLine."Item Code", SchItemLine."Item Code");
                SchProdLine.SetRange(SchProdLine."Variant Code/ Reel Number", SchItemLine."Roll ID");
                if SchProdLine.FindFirst then begin
                    repeat
                        SchProdLine."Qty to be Post" := 0;
                        SchProdLine."Extra Consumtpion Quantity" := 0;
                        SchProdLine."Paper Position" := 0;
                        SchProdLine."Paper Position(Item)" := 0;
                        SchProdLine."Extra Consumtion Variation(%)" := 0;
                        SchProdLine."Extra Quantity Approval" := false;
                        SchProdLine."Extra Quantity Approved By" := '';
                        SchProdLine."Expected Consumption" := 0;
                        SchProdLine."Consumption Ratio" := 0;
                        SchProdLine.Modify(true);
                    until SchProdLine.Next = 0;
                end;

            until SchItemLine.Next = 0;
        end;
    end;

    procedure GetConsumptionLineOnlySubLine(ReqNo: Code[20])
    var
        ReqHeader: Record "Requisition Header";
        ReqLine: Record "Requisition Line SAM";
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        TempLine: Integer;
        ProdOrderComp: Record "Prod. Order Component";
        TempLineNumber: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ManufacturingSetup: Record "Manufacturing Setup";
        ProductionScheduleLine: Record "Production Schedule Line";
    begin
        // Lines added By Deepak Kumar
        SchProdLine.Reset;
        if SchProdLine.FindSet then begin
            SchProdLine.DeleteAll(true);
        end;

        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", ReqNo);
        if ReqHeader.FindFirst then begin
            ReqHeader.TestField(ReqHeader."Requisition Type", ReqHeader."Requisition Type"::"Production Schedule");
            ReqHeader.TestField(ReqHeader."Schedule Document No.");
            // Lines for Production Order
            ManufacturingSetup.Get;
            TempLine := 1000;
            ItemLedgerEntry.Reset;
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Requisition No.", ReqHeader."Requisition No.");
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Transfer);
            ItemLedgerEntry.SetRange(ItemLedgerEntry.Positive, true);
            ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", ManufacturingSetup."Corrugation Location");
            ItemLedgerEntry.SetRange(ItemLedgerEntry.Open, true);
            if ItemLedgerEntry.FindFirst then begin
                TempLineNumber := 10000;
                repeat
                    if ItemLedgerEntry."Remaining Quantity" <> 0 then begin

                        ///_______________________________________________________________
                        ProductionScheduleLine.Reset;
                        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ReqHeader."Schedule Document No.");
                        ProductionScheduleLine.SetRange(ProductionScheduleLine.Published, true);
                        if ProductionScheduleLine.FindFirst then begin
                            repeat
                                ProdOrderComp.Reset;
                                ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                                //ProdOrderComp.SETRANGE(ProdOrderComp."Prod Schedule No.",ProductionScheduleLine."Schedule No.");
                                ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", false);
                                ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                                ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                                if ProdOrderComp.FindFirst then begin
                                    //TempLine:=1000;
                                    repeat
                                        SchProdLine.Init;
                                        SchProdLine."Prod. Schedule No" := ReqHeader."Schedule Document No.";//ProdOrderComp."Prod Schedule No.";
                                        SchProdLine."Line No." := TempLine;
                                        TempLine += 1000;
                                        SchProdLine."Prod. Order No." := ProdOrderComp."Prod. Order No.";
                                        SchProdLine."Prod. Order Line No" := ProdOrderComp."Prod. Order Line No.";
                                        SchProdLine."Paper Position" := ProdOrderComp."Paper Position";
                                        SchProdLine."Expected Consumption" := ProdOrderComp."Expected Quantity";
                                        ProdOrderComp.CalcFields(ProdOrderComp."Actual Consumed");
                                        SchProdLine."Posted Consumption" := ProdOrderComp."Actual Consumed";
                                        SchProdLine."Requisition No." := ReqHeader."Requisition No.";
                                        SchProdLine."Quantity Per" := ProdOrderComp."Quantity per";
                                        SchProdLine."Item Code" := ItemLedgerEntry."Item No.";
                                        SchProdLine."Variant Code/ Reel Number" := ItemLedgerEntry."Variant Code";
                                        SchProdLine.Insert(true);
                                    until ProdOrderComp.Next = 0;
                                end;
                            until ProductionScheduleLine.Next = 0;
                        end;
                        ////_______________________________________________________________________________________________

                    end;
                until ItemLedgerEntry.Next = 0;
            end;

            Message('Complete');
        end;
    end;

    procedure UpdatePaperPosition(RequisitionNumber: Code[20])
    var
        SchItemLine: Record "Con. Item Selection N";
        SchProdLine: Record "Cons. Prod. Order Selection";
        ItemJnlLine: Record "Item Journal Line";
        TempLineNumber: Integer;
        Item1: Record Item;
        Item2: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
        DocNo: Code[50];
        MaterialReqLine: Record "Requisition Line SAM";
        ItemJournalPost: Codeunit "Item Jnl.-Post Batch";
        TotalQtytoPost: Decimal;
        SchProdLineBuffer: Record "Cons. Prod. Order Selection";
        ProdOrderComp: Record "Prod. Order Component";
    begin
        //Lines added by Deepak Kumar
        SchItemLine.Reset;
        SchItemLine.SetRange(SchItemLine."Requisition No.", RequisitionNumber);
        if SchItemLine.FindFirst then begin
            DocNo := '';
            repeat
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Item Code", SchItemLine."Item Code");
                SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                SchProdLine.SetRange(SchProdLine."Variant Code/ Reel Number", SchItemLine."Roll ID");
                if SchProdLine.FindFirst then begin
                    repeat

                        if SchProdLine."No. Of Ply" = 3 then begin
                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Liner1-DL" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Liner1;

                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Flute1-M1" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Flute1;

                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Liner2-L1" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Liner2;

                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Flute2-M2" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Flute1;


                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Liner3-L2" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Liner2;

                            SchProdLine."Paper Position(Item)" := SchItemLine."Paper Position";
                            SchProdLine.Modify(true);
                        end;
                        if SchProdLine."No. Of Ply" = 5 then begin
                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Liner1-DL" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Liner1;

                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Flute1-M1" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Flute1;

                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Liner2-L1" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Liner2;

                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Flute2-M2" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Flute2;


                            if SchItemLine."Paper Position" = SchItemLine."Paper Position"::"Liner3-L2" then
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Liner3;

                            SchProdLine."Paper Position(Item)" := SchItemLine."Paper Position";
                            SchProdLine.Modify(true);
                        end;

                    until SchProdLine.Next = 0;
                end;
            until SchItemLine.Next = 0;
        end;

        // For Update the Liner
        SchItemLine.Reset;
        SchItemLine.SetRange(SchItemLine."Requisition No.", RequisitionNumber);
        if SchItemLine.FindFirst then begin
            DocNo := '';
            repeat
                SchProdLine.Reset;
                SchProdLine.SetRange(SchProdLine."Requisition No.", SchItemLine."Requisition No.");
                SchProdLine.SetRange(SchProdLine."Item Code", SchItemLine."Item Code");
                SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                SchProdLine.SetRange(SchProdLine."Variant Code/ Reel Number", SchItemLine."Roll ID");
                SchProdLine.SetRange(SchProdLine."Paper Position", SchProdLine."Paper Position"::Liner2);
                SchProdLine.SetRange(SchProdLine."Paper Position(Item)", SchProdLine."Paper Position(Item)"::"Liner2-L1");
                if SchProdLine.FindFirst then begin
                    repeat
                        if SchProdLine."No. Of Ply" = 3 then begin
                            SchProdLineBuffer.Reset;
                            SchProdLineBuffer.SetRange(SchProdLineBuffer."Prod. Schedule No", SchProdLine."Prod. Schedule No");
                            SchProdLineBuffer.SetRange(SchProdLineBuffer."Prod. Order No.", SchProdLine."Prod. Order No.");
                            SchProdLineBuffer.SetRange(SchProdLineBuffer."Prod. Order Line No", SchProdLine."Prod. Order Line No");
                            SchProdLineBuffer.SetRange(SchProdLineBuffer."Paper Position(Item)", SchProdLineBuffer."Paper Position(Item)"::"Liner3-L2");
                            if SchProdLineBuffer.FindFirst then begin
                                SchProdLine."Paper Position" := SchProdLine."Paper Position"::Liner1;
                                SchProdLine.Modify(true);
                            end;
                        end;
                    until SchProdLine.Next = 0;
                end;
            until SchItemLine.Next = 0;
        end;

        SchProdLine.Reset;
        SchProdLine.SetRange(SchProdLine."Requisition No.", RequisitionNumber);
        SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
        if SchProdLine.FindFirst then begin
            repeat
                ProdOrderComp.Reset;
                ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", false);
                ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", SchProdLine."Prod. Order No.");
                ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", SchProdLine."Prod. Order Line No");
                ProdOrderComp.SetRange(ProdOrderComp."Paper Position", SchProdLine."Paper Position");
                if ProdOrderComp.FindFirst then begin
                    Item1.Get(ProdOrderComp."Item No.");
                    Item2.Get(SchProdLine."Item Code");
                    if Item1."Paper GSM" <> 0 then
                        SchProdLine."Quantity Per" := (ProdOrderComp."Quantity per" / Item1."Paper GSM") * Item2."Paper GSM"
                    else
                        SchProdLine."Quantity Per" := ProdOrderComp."Quantity per";

                    ProdOrderComp.CalcFields(ProdOrderComp."Actual Consumed");
                    SchProdLine."Posted Consumption" := ProdOrderComp."Actual Consumed";

                    SchProdLine.Modify(true);
                end;
            until SchProdLine.Next = 0;
        end;
    end;

    procedure ValidatePaperPosition(RequisitionNumber: Code[20])
    var
        ReqHeader: Record "Requisition Header";
        SchProdLine: Record "Cons. Prod. Order Selection";
        PostionCounter: Integer;
        FluteCounter: Integer;
        LinerCounter: Integer;
        TempPaperPostion: Option " ","Liner1-DL","Flute1-M1","Liner2-L1","Flute2-M2","Liner3-L2","Flute3-M3","Liner4-L3";
    begin
        //Lines added by Deepak Kumar

        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", RequisitionNumber);
        if ReqHeader.FindFirst then begin
            ReqHeader.TestField(ReqHeader."Requisition Type", ReqHeader."Requisition Type"::"Production Schedule");
            ReqHeader.TestField(ReqHeader."Schedule Document No.");

            ProductionScheduleLine.Reset;
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ReqHeader."Schedule Document No.");
            ProductionScheduleLine.SetRange(ProductionScheduleLine.Published, true);
            if ProductionScheduleLine.FindFirst then begin
                repeat


                    SchProdLine.Reset;
                    SchProdLine.SetCurrentKey(SchProdLine."Paper Position(Item)");
                    SchProdLine.SetRange(SchProdLine."Requisition No.", ReqHeader."Requisition No.");
                    SchProdLine.SetRange(SchProdLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                    SchProdLine.SetRange(SchProdLine."Prod. Order Line No", ProductionScheduleLine."Prod. Order Line No.");
                    SchProdLine.SetRange(SchProdLine."Supplementary Line", false);
                    SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                    if SchProdLine.FindFirst then begin
                        PostionCounter := 0;
                        FluteCounter := 0;
                        LinerCounter := 0;
                        repeat

                            if TempPaperPostion <> SchProdLine."Paper Position(Item)" then begin
                                TempPaperPostion := SchProdLine."Paper Position(Item)";
                                PostionCounter += 1;

                                if (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Flute1-M1") or (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Flute2-M2") then begin
                                    FluteCounter += 1;
                                end;
                                if (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Liner1-DL") or
                                 (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Liner2-L1") or
                                 (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Liner3-L2") then begin
                                    LinerCounter += 1;
                                end;
                            end;
                        until SchProdLine.Next = 0;

                        // MESSAGE('No of Ply %1 Postion Counter %2 Flute  %3 Liner %4',ProductionScheduleLine."No. Of Ply",PostionCounter,FluteCounter,LinerCounter);


                        /*

                        IF (ProductionScheduleLine."No. Of Ply" = 5) THEN BEGIN
                          IF (FluteCounter > 2) OR (FluteCounter < 2) THEN
                           ERROR('Number of Flute must be identical in paper position, Order No. %1 Order Line No %2',ProductionScheduleLine."Prod. Order No.",ProductionScheduleLine."Prod. Order Line No.");

                          IF (LinerCounter > 3) OR (LinerCounter < 3) THEN
                            ERROR('Number of Liner must be identical in paper position, Order No. %1 Order Line No %2',ProductionScheduleLine."Prod. Order No.",ProductionScheduleLine."Prod. Order Line No.");

                          IF (PostionCounter < 5) THEN
                            ERROR('Paper Position not be Less than No of Ply, Order No. %1 Order Line No %2',ProductionScheduleLine."Prod. Order No.",ProductionScheduleLine."Prod. Order Line No.");

                        END;

                        IF (ProductionScheduleLine."No. Of Ply" = 3) THEN BEGIN
                          IF  (FluteCounter > 1) OR (FluteCounter < 1) THEN
                            ERROR('Number of Flute must be identical in paper position, Order No. %1 Order Line No %2',ProductionScheduleLine."Prod. Order No.",ProductionScheduleLine."Prod. Order Line No.");

                          IF (LinerCounter > 2) OR (LinerCounter < 2) AND (LinerCounter <> 0) THEN
                           ERROR('Number of Liner must be identical in paper position, Order No. %1 Order Line No %2',ProductionScheduleLine."Prod. Order No.",ProductionScheduleLine."Prod. Order Line No.");

                          IF (PostionCounter > 3) OR  (PostionCounter < 3) THEN
                            ERROR('Paper Position not be greter than No of Ply, Order No. %1 Order Line No %2',ProductionScheduleLine."Prod. Order No.",ProductionScheduleLine."Prod. Order Line No.");
                        END;
                               */
                    end;
                until ProductionScheduleLine.Next = 0;
            end;
        end;

    end;

    procedure CreatePaperPositionErrorLog(RequisitionNumber: Code[20])
    var
        ReqHeader: Record "Requisition Header";
        SchProdLine: Record "Cons. Prod. Order Selection";
        PostionCounter: Integer;
        FluteCounter: Integer;
        LinerCounter: Integer;
        TempPaperPostion: Option " ","Liner1-DL","Flute1-M1","Liner2-L1","Flute2-M2","Liner3-L2","Flute3-M3","Liner4-L3";
        ProdOrderCommentLine: Record "Prod. Order Comment Line";
        LineNumber: Integer;
    begin
        //Lines added by Deepak Kumar
        ProdOrderCommentLine.Reset;
        ProdOrderCommentLine.SetRange(ProdOrderCommentLine."Req No.", RequisitionNumber);
        if ProdOrderCommentLine.FindFirst then
            ProdOrderCommentLine.DeleteAll;

        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", RequisitionNumber);
        if ReqHeader.FindFirst then begin
            ReqHeader.TestField(ReqHeader."Requisition Type", ReqHeader."Requisition Type"::"Production Schedule");
            ReqHeader.TestField(ReqHeader."Schedule Document No.");

            ProductionScheduleLine.Reset;
            ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ReqHeader."Schedule Document No.");
            ProductionScheduleLine.SetRange(ProductionScheduleLine.Published, true);
            if ProductionScheduleLine.FindFirst then begin
                repeat


                    SchProdLine.Reset;
                    SchProdLine.SetCurrentKey(SchProdLine."Paper Position(Item)");
                    SchProdLine.SetRange(SchProdLine."Requisition No.", ReqHeader."Requisition No.");
                    SchProdLine.SetRange(SchProdLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                    SchProdLine.SetRange(SchProdLine."Prod. Order Line No", ProductionScheduleLine."Prod. Order Line No.");
                    SchProdLine.SetRange(SchProdLine."Supplementary Line", false);
                    SchProdLine.SetRange(SchProdLine."Marked for Consumption Post", true);
                    if SchProdLine.FindFirst then begin
                        PostionCounter := 0;
                        FluteCounter := 0;
                        LinerCounter := 0;
                        repeat

                            if TempPaperPostion <> SchProdLine."Paper Position(Item)" then begin
                                TempPaperPostion := SchProdLine."Paper Position(Item)";
                                PostionCounter += 1;

                                if (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Flute1-M1") or (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Flute2-M2") then begin
                                    FluteCounter += 1;
                                end;
                                if (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Liner1-DL") or
                                 (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Liner2-L1") or
                                 (SchProdLine."Paper Position(Item)" = SchProdLine."Paper Position(Item)"::"Liner3-L2") then begin
                                    LinerCounter += 1;
                                end;
                            end;
                        until SchProdLine.Next = 0;

                        // MESSAGE('No of Ply %1 Postion Counter %2 Flute  %3 Liner %4',ProductionScheduleLine."No. Of Ply",PostionCounter,FluteCounter,LinerCounter);


                        LineNumber := 100;

                        if (ProductionScheduleLine."No. Of Ply" = 5) then begin
                            if (FluteCounter > 2) or (FluteCounter < 2) then begin
                                LineNumber += 1;
                                ProdOrderCommentLine.Init;
                                ProdOrderCommentLine."Prod. Order No." := ProductionScheduleLine."Prod. Order No.";
                                ProdOrderCommentLine."Line No." := LineNumber;
                                ProdOrderCommentLine."Req No." := RequisitionNumber;
                                ProdOrderCommentLine.Comment := 'Number of Flute must be identical in paper position, Order No. ' + ProductionScheduleLine."Prod. Order No." + ' Order Line No' + Format(ProductionScheduleLine."Prod. Order Line No.");
                                ProdOrderCommentLine.Insert(true);
                            end;

                            if (LinerCounter > 3) or (LinerCounter < 3) then begin
                                LineNumber += 1;
                                ProdOrderCommentLine.Init;
                                ProdOrderCommentLine."Prod. Order No." := ProductionScheduleLine."Prod. Order No.";
                                ProdOrderCommentLine."Line No." := LineNumber;
                                ProdOrderCommentLine."Req No." := RequisitionNumber;
                                ProdOrderCommentLine.Comment := 'Number of Liner must be identical in paper position, Order No. ' + ProductionScheduleLine."Prod. Order No." + ' Order Line No' + Format(ProductionScheduleLine."Prod. Order Line No.");
                                ProdOrderCommentLine.Insert(true);
                            end;
                            if (PostionCounter < 5) then begin
                                LineNumber += 1;
                                ProdOrderCommentLine.Init;
                                ProdOrderCommentLine."Prod. Order No." := ProductionScheduleLine."Prod. Order No.";
                                ProdOrderCommentLine."Line No." := LineNumber;
                                ProdOrderCommentLine."Req No." := RequisitionNumber;
                                ProdOrderCommentLine.Comment := 'Paper Position not be Less than No of Ply, Order No. ' + ProductionScheduleLine."Prod. Order No." + ' Order Line No' + Format(ProductionScheduleLine."Prod. Order Line No.");
                                ProdOrderCommentLine.Insert(true);
                            end;
                        end;

                        if (ProductionScheduleLine."No. Of Ply" = 3) then begin
                            if (FluteCounter > 1) or (FluteCounter < 1) then begin
                                LineNumber += 1;
                                ProdOrderCommentLine.Init;
                                ProdOrderCommentLine."Prod. Order No." := ProductionScheduleLine."Prod. Order No.";
                                ProdOrderCommentLine."Line No." := LineNumber;
                                ProdOrderCommentLine."Req No." := RequisitionNumber;
                                ProdOrderCommentLine.Comment := 'Number of Flute must be identical in paper position, Order No. ' + ProductionScheduleLine."Prod. Order No." + ' Order Line No' + Format(ProductionScheduleLine."Prod. Order Line No.");
                                ProdOrderCommentLine.Insert(true);
                            end;

                            if (LinerCounter > 2) or (LinerCounter < 2) then begin
                                LineNumber += 1;
                                ProdOrderCommentLine.Init;
                                ProdOrderCommentLine."Prod. Order No." := ProductionScheduleLine."Prod. Order No.";
                                ProdOrderCommentLine."Line No." := LineNumber;
                                ProdOrderCommentLine."Req No." := RequisitionNumber;
                                ProdOrderCommentLine.Comment := 'Number of Liner must be identical in paper position, Order No. ' + ProductionScheduleLine."Prod. Order No." + ' Order Line No' + Format(ProductionScheduleLine."Prod. Order Line No.");
                                ProdOrderCommentLine.Insert(true);
                            end;

                            if (PostionCounter > 3) or (PostionCounter < 3) then begin
                                LineNumber += 1;
                                ProdOrderCommentLine.Init;
                                ProdOrderCommentLine."Prod. Order No." := ProductionScheduleLine."Prod. Order No.";
                                ProdOrderCommentLine."Line No." := LineNumber;
                                ProdOrderCommentLine."Req No." := RequisitionNumber;
                                ProdOrderCommentLine.Comment := 'Paper Position not be greter than No of Ply, Order No. ' + ProductionScheduleLine."Prod. Order No." + ' Order Line No' + Format(ProductionScheduleLine."Prod. Order Line No.");
                                ProdOrderCommentLine.Insert(true);
                            end;
                        end;

                    end;
                until ProductionScheduleLine.Next = 0;
            end;
        end;
    end;

    procedure CreateScheduleWiseReqQty()
    var
        BaseTableDeckle: Record "Schedule Base Table 1";
        PaperTypeBaseTable: Record "Schedule Base Table 2";
        PaserGSMBaseTable: Record "Schedule Base Table 3";
    begin
        // Lines added by deepak Kumar
        PaserGSMBaseTable.Reset;
        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Schedule Component List", true);
        if PaserGSMBaseTable.FindSet then
            PaserGSMBaseTable.DeleteAll(true);


        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Closed", false);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        if ProductionScheduleLine.FindFirst then begin
            repeat
                ProdOrderCompLine.Reset;
                ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Schedule Component", false);
                if ProdOrderCompLine.FindFirst then begin
                    repeat
                        IF NOT ItemMaster.GET(ProdOrderCompLine."Item No.") THEN
                            ERROR('Item should not be blank in component line for this job no. %1', ProdOrderCompLine."Prod. Order No.");
                        // Update Paper GSM
                        PaserGSMBaseTable.Reset;
                        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Prod. Order Number", ProdOrderCompLine."Prod. Order No.");
                        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Prod. Order Line No.", ProdOrderCompLine."Prod. Order Line No.");
                        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Item Code", ProdOrderCompLine."Item No.");
                        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Paper GSM", Format(ItemMaster."Paper GSM"));
                        if not PaserGSMBaseTable.FindFirst then begin
                            PaserGSMBaseTable.Init;
                            PaserGSMBaseTable."Deckle Size" := Format(ItemMaster."Deckle Size (mm)");
                            PaserGSMBaseTable."Deckle Size(Num)" := ItemMaster."Deckle Size (mm)";
                            PaserGSMBaseTable."Paper Type" := ItemMaster."Paper Type";
                            PaserGSMBaseTable."Paper GSM" := Format(ItemMaster."Paper GSM");
                            PaserGSMBaseTable."Paper GSM(Num)" := (ItemMaster."Paper GSM");
                            PaserGSMBaseTable."Item Code" := ProdOrderCompLine."Item No.";
                            PaserGSMBaseTable."Item Description" := ProdOrderCompLine.Description;
                            PaserGSMBaseTable."Prod. Order Number" := ProdOrderCompLine."Prod. Order No.";
                            PaserGSMBaseTable."Prod. Order Line No." := ProdOrderCompLine."Prod. Order Line No.";
                            PaserGSMBaseTable."Schedule Component List" := true;
                            PaserGSMBaseTable."Total Requirement (kg)" := ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule";
                            PaserGSMBaseTable.Insert(true);
                        end else begin
                            PaserGSMBaseTable."Total Requirement (kg)" := PaserGSMBaseTable."Total Requirement (kg)" + ProdOrderCompLine."Quantity per" * ProductionScheduleLine."Quantity To Schedule";
                            PaserGSMBaseTable.Modify(true);
                        end;

                    until ProdOrderCompLine.Next = 0;
                end;
            until ProductionScheduleLine.Next = 0;
        end;
    end;
}

