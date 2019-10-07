codeunit 50013 "Estimate Code Unit"
{
    TableNo = "Product Design Header";

    trigger OnRun()
    begin
    end;

    var
        EstimateHeader: Record "Product Design Header";
        Estimateline: Record "Product Design Line";
        MfgSetup: Record "Manufacturing Setup";
        TempItemNumber: Code[50];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemNew: Record Item;
        MainEstimate: Record "Product Design Header";
        ItemTable: Record Item;
        ProductionBomheader: Record "Production BOM Header";
        ProductionBomLine: Record "Production BOM Line";
        routing: Record "Routing Header";
        "routing line": Record "Routing Line";
        "Operation No.": Integer;
        Sam001: Label '<>''''';
        TempProductionOrder: Code[20];
        ProductionOrder: Record "Production Order";
        RefreshProdOrder: Codeunit "Refresh Production Order";
        ProdOrder: Record "Production Order";
        ReleasedProductionOrder: Page "Released Production Order";
        SalesLines: Record "Sales Line";
        ItemMaster: Record Item;
        ProgressWindow: Dialog;

    procedure CreateProdOrder(var EstimateNo: Code[50])
    var
        EstimateHeaderM: Record "Product Design Header";
        Customer: Record Customer;
    begin
        // Lines added By Deepak Kumar

        EstimateHeaderM.Reset;
        EstimateHeaderM.SetRange(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design Type"::Main);
        EstimateHeaderM.SetRange(EstimateHeaderM."Product Design No.", EstimateNo);
        if EstimateHeaderM.FindFirst then begin
            ProgressWindow.Open('#1##############');
            MfgSetup.Get;
            EstimateHeaderM.TestField("Quantity to Job Order");
            EstimateHeaderM.TestField(EstimateHeaderM."Item Code");
            ItemMaster.Get(EstimateHeaderM."Item Code");
            ItemMaster.TestField(ItemMaster."Marked For Enq/Quote", false);

            ProgressWindow.Update(1, 'Creating Component Item');
            CreateComponentItem(EstimateHeaderM."Product Design No.");

            ProgressWindow.Update(1, 'Creating Sub Component Item');
            CreateSubItem(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");

            ProgressWindow.Update(1, 'Creating Sub Component BOM');
            CreateSubCompBOM(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");

            ProgressWindow.Update(1, 'Creating Sub Component Routing');
            CreateSubCompRoute(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");

            ProgressWindow.Update(1, 'Creating Prod. BOM');
            CreateProdBom(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");

            ProgressWindow.Update(1, 'Creating Prod. Routing');
            CreateProdRouting(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");

            ProgressWindow.Update(1, 'Updating Sub component BOM Details');
            UpdateSubCompBOMDetails(EstimateHeaderM."Product Design No.");


            if EstimateHeaderM."Production Order No." = '' then begin
                MfgSetup.TestField(MfgSetup."Released Order Nos.");
                NoSeriesMgt.InitSeries(MfgSetup."Released Order Nos.", '', 0D, TempProductionOrder, MfgSetup."Released Order Nos.");
                EstimateHeaderM."Production Order No." := TempProductionOrder;
                EstimateHeaderM.Modify(true);
            end else begin
                TempProductionOrder := EstimateHeaderM."Production Order No.";
            end;

            //   MESSAGE(TempProductionOrder);
            ProgressWindow.Update(1, 'Creating Production Order');
            ProductionOrder.Init;
            ProductionOrder.Validate(Status, ProductionOrder.Status::Released);
            ProductionOrder."No." := TempProductionOrder;
            ProductionOrder.Insert(true);

            ProductionOrder.Validate(ProductionOrder."Source Type", ProductionOrder."Source Type"::Item);
            ProductionOrder.Validate(ProductionOrder."Source No.", EstimateHeaderM."Item Code");
            ProductionOrder.Validate(ProductionOrder.Quantity, EstimateHeaderM."Quantity to Job Order");
            ProductionOrder."Location Code" := MfgSetup."Def. Location for Production";
            ProductionOrder."Sales Order No." := EstimateHeaderM."Sales Order No.";
            ProductionOrder."Estimate Code" := EstimateHeaderM."Product Design No.";
            ProductionOrder."Salesperson Code" := EstimateHeaderM."Sales Person Code";
            ProductionOrder."Customer Name" := EstimateHeaderM.Name;
            ProductionOrder."Sales Order Line No." := EstimateHeaderM."Sales Order Line No.";
            ProductionOrder."Flute Type" := EstimateHeaderM."Flute Type";
            ProductionOrder."No. of Ply" := EstimateHeaderM."No. of Ply";
            ProductionOrder."No. of Ups" := EstimateHeaderM."Board Ups";
            if Customer.Get(EstimateHeaderM.Customer) then
                ProductionOrder."Production Tolerance %" := Customer."Production Tolerance %";
            ProductionOrder.Modify(true);
            Commit;

            RefreshProdOrder.Run(ProductionOrder);


            ProdOrder.Reset;
            ProdOrder.SetRange(ProdOrder.Status, ProductionOrder.Status);
            ProdOrder.SetRange(ProdOrder."No.", ProductionOrder."No.");
            ProdOrder.FindFirst;


            if EstimateHeaderM."Sales Order No." <> '' then begin
                ProgressWindow.Update(1, 'Updating Sales Line');
                SalesLines.Reset;
                SalesLines.SetRange(SalesLines."Document Type", SalesLines."Document Type"::Order);
                SalesLines.SetRange(SalesLines."Document No.", EstimateHeaderM."Sales Order No.");
                SalesLines.SetRange(SalesLines.Type, SalesLines.Type::Item);
                //SalesLines.SETRANGE(SalesLines."No.",EstimateHeaderM."Item Code");
                SalesLines.SetRange(SalesLines."Line No.", EstimateHeaderM."Sales Order Line No.");
                if SalesLines.FindFirst then begin
                    SalesLines."Prod. Order No." := ProductionOrder."No.";
                    SalesLines.Modify(true);
                    ProdOrder."Sales Requested Delivery Date" := SalesLines."Requested Delivery Date";
                    ProdOrder.Modify(true);
                end;
            end;
            ProgressWindow.Close;
            ReleasedProductionOrder.SetTableView(ProdOrder);
            ReleasedProductionOrder.Run;

        end;
    end;

    procedure CreateComponentItem(EstimateNo: Code[50])
    begin
        // Lines added BY Deepak Kumar
        EstimateHeader.Reset;
        EstimateHeader.SetRange(EstimateHeader."Product Design Type", EstimateHeader."Product Design Type"::Sub);
        EstimateHeader.SetRange(EstimateHeader."Product Design No.", EstimateNo);
        if EstimateHeader.FindFirst then begin
            repeat
                if (EstimateHeader."Item Code" = '') then begin
                    MfgSetup.Get;
                    TempItemNumber := '';
                    MfgSetup.TestField(MfgSetup."Component Series");
                    MfgSetup.TestField(MfgSetup."Component Category");
                    NoSeriesMgt.InitSeries(MfgSetup."Component Series", '', 0D, TempItemNumber, MfgSetup."Component Series");

                    ItemNew.Init;
                    ItemNew."No." := TempItemNumber;
                    ItemNew.Description := EstimateHeader."Item Description" + ' ' + EstimateNo + ' ' + EstimateHeader."Sub Comp No.";
                    ItemNew.Insert(true);

                    ItemNew.Validate("Base Unit of Measure", EstimateHeader."Item Unit of Measure");
                    ItemNew.Validate("Item Category Code", MfgSetup."Component Category");

                    ItemNew."Model No" := EstimateHeader."Model No";
                    ItemNew."Model Description" := EstimateHeader."Model Description";
                    ItemNew."No. of Ply" := EstimateHeader."No. of Ply";
                    ItemNew."Flute Type" := EstimateHeader."Flute Type";
                    ItemNew."Color Code" := EstimateHeader."Top Colour";
                    ItemNew."Flute 1" := EstimateHeader."Flute 1";
                    ItemNew."Flute 2" := EstimateHeader."Flute 2";
                    ItemNew."Flute 3" := EstimateHeader."Flute 3";
                    ItemNew."Board Length" := EstimateHeader."Board Length (mm)- L";
                    ItemNew."Board Width" := EstimateHeader."Board Width (mm)- W";
                    ItemNew."FG GSM" := Format(EstimateHeader.Grammage);


                    MainEstimate.Reset;
                    MainEstimate.SetRange(MainEstimate."Product Design Type", MainEstimate."Product Design Type"::Main);
                    MainEstimate.SetRange(MainEstimate."Product Design No.", EstimateNo);
                    if MainEstimate.FindFirst then begin
                        ItemNew."FG Item No." := MainEstimate."Item Code";
                    end;

                    ItemNew."Manufacturing Policy" := 1;
                    ItemNew."Replenishment System" := 1;
                    ItemNew."Flushing Method" := ItemNew."Flushing Method"::Backward;
                    ItemNew.Blocked := false;
                    ItemNew.Status := 1;
                    ItemNew.Modify(true);

                    EstimateHeader."Item Code" := ItemNew."No.";
                    EstimateHeader.Modify(true);
                end;
                MfgSetup.Get;
                if MfgSetup."Board Required for Sub Job" = true then begin
                    CreateSubItem(EstimateHeader."Product Design Type", EstimateHeader."Product Design No.", EstimateHeader."Sub Comp No.");
                    CreateSubCompBOM(EstimateHeader."Product Design Type", EstimateHeader."Product Design No.", EstimateHeader."Sub Comp No.");
                    CreateSubCompRoute(EstimateHeader."Product Design Type", EstimateHeader."Product Design No.", EstimateHeader."Sub Comp No.");
                    CreateProdBom(EstimateHeader."Product Design Type", EstimateHeader."Product Design No.", EstimateHeader."Sub Comp No.");
                    CreateProdRouting(EstimateHeader."Product Design Type", EstimateHeader."Product Design No.", EstimateHeader."Sub Comp No.");
                end else begin
                    CreateProdBomSub(EstimateHeader."Product Design Type", EstimateHeader."Product Design No.", EstimateHeader."Sub Comp No.");
                    CreateProdRoutingSub(EstimateHeader."Product Design Type", EstimateHeader."Product Design No.", EstimateHeader."Sub Comp No.");
                end;
            until EstimateHeader.Next = 0;
        end;
    end;

    procedure CreateSubItem(EstimateType: Option; EstimateNo: Code[50]; EstimateSubJob: Code[50])
    var
        ConsumeProcessFor: Code[50];
        ProcessLinkCode: Record "Material / Process Link Code";
        EstimateComponentTable: Record "Product Design Component Table";
        EstimateComponent: Record "Product Design Component Table";
        MainEstimate1: Record "Product Design Header";
    begin
        // Lines added BY Deepak Kumar
        Estimateline.Reset;
        Estimateline.SetCurrentKey("Consume / Process For", "Component Of");
        Estimateline.SetRange(Estimateline."Product Design Type", EstimateType);
        Estimateline.SetRange(Estimateline."Product Design No.", EstimateNo);
        Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateSubJob);
        Estimateline.SetFilter(Estimateline."Consume / Process For", '<>%1', '');
        Estimateline.SetFilter(Estimateline.Type, '<>Item');
        if Estimateline.FindFirst then begin
            repeat
                ConsumeProcessFor := '';
                if ConsumeProcessFor <> Estimateline."Consume / Process For" then begin
                    EstimateComponentTable.Reset;
                    EstimateComponentTable.SetRange(EstimateComponentTable."Product Design Type", Estimateline."Product Design Type");
                    EstimateComponentTable.SetRange(EstimateComponentTable."Product Design No.", Estimateline."Product Design No.");
                    EstimateComponentTable.SetRange(EstimateComponentTable."Sub Comp No.", Estimateline."Sub Comp No.");
                    EstimateComponentTable.SetRange(EstimateComponentTable."Material / Process Link Code", Estimateline."Consume / Process For");
                    if not EstimateComponentTable.FindFirst then begin
                        ProcessLinkCode.Reset;
                        ProcessLinkCode.SetRange(ProcessLinkCode.Code, Estimateline."Consume / Process For");
                        if ProcessLinkCode.FindFirst then begin
                            TempItemNumber := '';
                            ProcessLinkCode.TestField(ProcessLinkCode."No Series");
                            ProcessLinkCode.TestField(ProcessLinkCode."Default Item Category");
                            ProcessLinkCode.TestField(ProcessLinkCode."Base Unit of Measure");
                            ProcessLinkCode.TestField(ProcessLinkCode."Routing Link Code");

                            NoSeriesMgt.InitSeries(ProcessLinkCode."No Series", '', WorkDate, TempItemNumber, ProcessLinkCode."No Series");

                            ItemNew.Init;
                            ItemNew."No." := TempItemNumber;
                            ItemNew.Insert(true);

                            ItemNew.Validate("Base Unit of Measure", ProcessLinkCode."Base Unit of Measure");
                            ItemNew.Validate("Item Category Code", ProcessLinkCode."Default Item Category");
                            ItemNew."Model No" := EstimateHeader."Model No";
                            ItemNew."Model Description" := EstimateHeader."Model Description";
                            ItemNew."No. of Ply" := EstimateHeader."No. of Ply";
                            ItemNew."Flute Type" := EstimateHeader."Flute Type";
                            ItemNew."Color Code" := EstimateHeader."Top Colour";
                            ItemNew."Flute 1" := EstimateHeader."Flute 1";
                            ItemNew."Flute 2" := EstimateHeader."Flute 2";
                            ItemNew."Flute 3" := EstimateHeader."Flute 3";
                            ItemNew."Board Length" := EstimateHeader."Board Length (mm)- L";
                            ItemNew."Board Width" := EstimateHeader."Board Width (mm)- W";
                            ItemNew."FG GSM" := Format(EstimateHeader.Grammage);


                            MainEstimate.Reset;
                            MainEstimate.SetRange(MainEstimate."Product Design Type", Estimateline."Product Design Type");
                            MainEstimate.SetRange(MainEstimate."Product Design No.", Estimateline."Product Design No.");
                            MainEstimate.SetRange(MainEstimate."Sub Comp No.", Estimateline."Sub Comp No.");
                            if MainEstimate.FindFirst then begin
                                ItemNew.Description := ProcessLinkCode.Description + ' ' + MainEstimate."Item Description" +
                                Format(Estimateline."Product Design Type") + '  ' + Format(Estimateline."Product Design No.") + ' ' + Estimateline."Sub Comp No.";

                                ItemNew."FG Item No." := MainEstimate."Item Code";
                            end;


                            ItemNew."Manufacturing Policy" := 1;
                            ItemNew."Replenishment System" := 1;
                            ItemNew."Flushing Method" := ItemNew."Flushing Method"::Backward;
                            ItemNew.Blocked := false;
                            ItemNew.Status := 1;
                            ItemNew.Modify(true);
                            EstimateComponent.Init;
                            EstimateComponent."Product Design Type" := Estimateline."Product Design Type";
                            EstimateComponent."Product Design No." := Estimateline."Product Design No.";
                            EstimateComponent."Sub Comp No." := Estimateline."Sub Comp No.";
                            EstimateComponent."Material / Process Link Code" := Estimateline."Consume / Process For";
                            EstimateComponent."Item No." := ItemNew."No.";
                            EstimateComponent."Item Description" := ItemNew.Description;
                            EstimateComponent."Component Of" := Estimateline."Component Of";
                            EstimateComponent."Take Up" := Estimateline."Take Up";
                            EstimateComponent."Paper Position" := Estimateline."Paper Position";
                            EstimateComponent."Flute Type" := Estimateline."Flute Type";
                            EstimateComponent."Routing Link Code" := ProcessLinkCode."Routing Link Code";
                            EstimateComponent."Die Cut Ups" := Estimateline."Die Cut Ups";
                            EstimateComponent."No of Joints" := Estimateline."No of Joints";
                            EstimateComponent.Quantity := (MainEstimate.Quantity / Estimateline."Die Cut Ups") * Estimateline."No of Joints";

                            EstimateComponent.Insert(true);
                        end;
                    end;
                    ConsumeProcessFor := Estimateline."Consume / Process For";
                end;
            until Estimateline.Next = 0;
        end;
    end;

    procedure CreateSubCompBOM(EstimateType: Option; EstimateNo: Code[50]; EstimateSubJob: Code[50])
    var
        EstimateComponent: Record "Product Design Component Table";
        EstimateHeaderSubBom: Record "Product Design Header";
    begin
        // Lines added by Deepak Kumar
        EstimateHeaderSubBom.Reset;
        EstimateHeaderSubBom.SetCurrentKey("Product Design Type", "Product Design No.", "Sub Comp No.");
        EstimateHeaderSubBom.SetRange(EstimateHeaderSubBom."Product Design Type", EstimateType);
        EstimateHeaderSubBom.SetRange(EstimateHeaderSubBom."Product Design No.", EstimateNo);
        EstimateHeaderSubBom.SetRange(EstimateHeaderSubBom."Sub Comp No.", EstimateSubJob);
        if EstimateHeaderSubBom.FindFirst then begin
            repeat
                EstimateComponent.Reset;
                EstimateComponent.SetRange(EstimateComponent."Product Design Type", EstimateHeaderSubBom."Product Design Type");
                EstimateComponent.SetRange(EstimateComponent."Product Design No.", EstimateHeaderSubBom."Product Design No.");
                EstimateComponent.SetRange(EstimateComponent."Sub Comp No.", EstimateHeaderSubBom."Sub Comp No.");
                if EstimateComponent.FindFirst then begin
                    repeat
                        EstimateComponent.TestField(EstimateComponent."Item No.");
                        ItemTable.Reset;
                        ItemTable.SetRange(ItemTable."No.", EstimateComponent."Item No.");
                        if ItemTable.FindFirst then begin
                            if ItemTable."Production BOM No." = '' then begin

                                ProductionBomheader.Init;
                                ProductionBomheader."No." := EstimateComponent."Item No.";
                                ProductionBomheader.Insert(true);

                                ProductionBomheader.Validate(ProductionBomheader."Item No.", ItemTable."No.");
                                ProductionBomheader.Validate(ProductionBomheader.Description, ItemTable.Description);
                                ProductionBomheader.Validate(ProductionBomheader."Unit of Measure Code", ItemTable."Base Unit of Measure");
                                ProductionBomheader.Modify(true);

                                Estimateline.Reset;
                                Estimateline.SetRange(Estimateline."Product Design Type", EstimateComponent."Product Design Type");
                                Estimateline.SetRange(Estimateline."Product Design No.", EstimateComponent."Product Design No.");
                                Estimateline.SetRange(Estimateline.Type, Estimateline.Type::Item);
                                Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateComponent."Sub Comp No.");
                                Estimateline.SetRange(Estimateline."Consume / Process For", EstimateComponent."Material / Process Link Code");
                                Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                                if Estimateline.FindFirst then begin
                                    repeat
                                        ProductionBomLine.Init;
                                        ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                        ProductionBomLine.Validate(ProductionBomLine."Line No.", Estimateline."Line No.");
                                        ProductionBomLine.Insert(true);

                                        ProductionBomLine.Validate(ProductionBomLine.Type, Estimateline.Type);
                                        ProductionBomLine.Validate(ProductionBomLine."No.", Estimateline."No.");
                                        ProductionBomLine.Validate(ProductionBomLine.Description, Estimateline.Description);
                                        ProductionBomLine.Validate(ProductionBomLine."Unit of Measure Code", Estimateline."Unit Of Measure");

                                        //ProductionBomLine.VALIDATE(ProductionBomLine."Quantity per",(Estimateline.Quantity/EstimateHeaderSubBom.Quantity));
                                        ProductionBomLine.Validate(ProductionBomLine."Quantity per", (Estimateline.Quantity / EstimateComponent.Quantity));
                                        ProductionBomLine.Validate(ProductionBomLine."Take Up", Estimateline."Take Up");
                                        ProductionBomLine.Validate(ProductionBomLine."Paper Position", Estimateline."Paper Position");
                                        ProductionBomLine.Validate(ProductionBomLine."Flute Type", Estimateline."Flute Type");
                                        // Lines Updated By Deepak Kumar //23 11 15
                                        ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                        ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                        ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";
                                        ProductionBomLine.Modify(true);
                                    until Estimateline.Next = 0;
                                end;
                                ProductionBomheader.Status := ProductionBomheader.Status::Certified;
                                ProductionBomheader.Modify(true);
                                ItemTable.Validate(ItemTable."Production BOM No.", ProductionBomheader."No.");
                                ItemTable.Modify(true);
                            end else begin
                                ProductionBomheader.Reset;
                                ProductionBomheader.SetRange(ProductionBomheader."No.", ItemTable."Production BOM No.");
                                if ProductionBomheader.FindFirst then begin
                                    ProductionBomheader.Status := ProductionBomheader.Status::"Under Development";
                                    ProductionBomheader.Modify(true);
                                    ProductionBomLine.Reset;
                                    ProductionBomLine.SetRange(ProductionBomLine."Production BOM No.", ProductionBomheader."No.");
                                    if ProductionBomLine.FindFirst then begin
                                        ProductionBomLine.DeleteAll(true);
                                    end;

                                    Estimateline.Reset;
                                    Estimateline.SetRange(Estimateline."Product Design Type", EstimateComponent."Product Design Type");
                                    Estimateline.SetRange(Estimateline."Product Design No.", EstimateComponent."Product Design No.");
                                    Estimateline.SetRange(Estimateline.Type, Estimateline.Type::Item);
                                    Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateComponent."Sub Comp No.");
                                    Estimateline.SetRange(Estimateline."Consume / Process For", EstimateComponent."Material / Process Link Code");
                                    Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                                    if Estimateline.FindFirst then begin
                                        repeat
                                            ProductionBomLine.Init;
                                            ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                            ProductionBomLine.Validate(ProductionBomLine."Line No.", Estimateline."Line No.");
                                            ProductionBomLine.Insert(true);
                                            ProductionBomLine.Validate(ProductionBomLine.Type, Estimateline.Type);
                                            ProductionBomLine.Validate(ProductionBomLine."No.", Estimateline."No.");
                                            ProductionBomLine.Validate(ProductionBomLine.Description, Estimateline.Description);
                                            ProductionBomLine.Validate(ProductionBomLine."Unit of Measure Code", Estimateline."Unit Of Measure");
                                            //ProductionBomLine.VALIDATE(ProductionBomLine."Quantity per",(Estimateline.Quantity/EstimateHeaderSubBom.Quantity));
                                            ProductionBomLine.Validate(ProductionBomLine."Quantity per", (Estimateline.Quantity / EstimateComponent.Quantity));

                                            ProductionBomLine.Validate(ProductionBomLine."Take Up", Estimateline."Take Up");
                                            ProductionBomLine.Validate(ProductionBomLine."Paper Position", Estimateline."Paper Position");
                                            ProductionBomLine.Validate(ProductionBomLine."Flute Type", Estimateline."Flute Type");
                                            ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                            ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                            ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";

                                            ProductionBomLine.Modify(true);
                                        until Estimateline.Next = 0;
                                    end;
                                    ProductionBomheader.Status := ProductionBomheader.Status::Certified;
                                    ProductionBomheader.Modify(true);
                                end;
                            end;
                        end;
                        ;
                    until EstimateComponent.Next = 0;
                end;
            until EstimateHeaderSubBom.Next = 0;
        end;
    end;

    procedure CreateSubCompRoute(EstimateType: Option; EstimateNo: Code[50]; EstimateSubJob: Code[50])
    var
        EstimateComponent: Record "Product Design Component Table";
        EstimateHeaderSubRout: Record "Product Design Header";
    begin

        // Lines added by Deepak Kumar
        EstimateHeaderSubRout.Reset;
        EstimateHeaderSubRout.SetCurrentKey("Product Design Type", "Product Design No.", "Sub Comp No.");
        EstimateHeaderSubRout.SetRange(EstimateHeaderSubRout."Product Design Type", EstimateType);
        EstimateHeaderSubRout.SetRange(EstimateHeaderSubRout."Product Design No.", EstimateNo);
        EstimateHeaderSubRout.SetRange(EstimateHeaderSubRout."Sub Comp No.", EstimateSubJob);
        if EstimateHeaderSubRout.FindFirst then begin
            repeat
                EstimateComponent.Reset;
                EstimateComponent.SetRange(EstimateComponent."Product Design Type", EstimateHeaderSubRout."Product Design Type");
                EstimateComponent.SetRange(EstimateComponent."Product Design No.", EstimateHeaderSubRout."Product Design No.");
                EstimateComponent.SetRange(EstimateComponent."Sub Comp No.", EstimateHeaderSubRout."Sub Comp No.");
                if EstimateComponent.FindFirst then begin
                    repeat
                        EstimateComponent.TestField(EstimateComponent."Item No.");
                        ItemTable.Reset;
                        ItemTable.SetRange(ItemTable."No.", EstimateComponent."Item No.");
                        if ItemTable.FindFirst then begin

                            if ItemTable."Routing No." = '' then begin
                                routing.Init;
                                routing."No." := EstimateComponent."Item No.";
                                routing.Insert(true);

                                routing.Validate(routing."Item No.", EstimateComponent."Item No.");
                                routing.Validate(routing.Description, ItemTable.Description);
                                routing."Estimate No." := EstimateHeaderSubRout."Product Design No.";
                                routing.Modify(true);

                                "Operation No." := 10;
                                Estimateline.Reset;
                                Estimateline.SetCurrentKey("Work Center Category", "Line No.");
                                Estimateline.SetRange(Estimateline."Product Design Type", EstimateComponent."Product Design Type");
                                Estimateline.SetRange(Estimateline."Product Design No.", EstimateComponent."Product Design No.");
                                Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateComponent."Sub Comp No.");
                                Estimateline.SetRange(Estimateline."Consume / Process For", EstimateComponent."Material / Process Link Code");
                                Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                                if Estimateline.FindFirst then begin
                                    repeat
                                        if (Estimateline.Type = Estimateline.Type::"Work Center") or (Estimateline.Type = Estimateline.Type::"Machine Center") then begin
                                            "routing line".Init;
                                            "routing line"."Routing No." := routing."No.";
                                            "routing line"."Operation No." := Format("Operation No.");
                                            "routing line".Insert(true);
                                            "routing line".Validate("Operation No.");
                                            "Operation No." := "Operation No." + 5;

                                            if Estimateline.Type = 2 then
                                                "routing line".Validate("routing line".Type, 0);
                                            if Estimateline.Type = 3 then
                                                "routing line".Validate("routing line".Type, 1);

                                            "routing line".Validate("routing line"."No.", Estimateline."No.");
                                            "routing line".Validate("routing line".Description, Estimateline.Description);
                                            "routing line".Validate("routing line"."Unit Cost per", Estimateline."Unit Cost");
                                            "routing line".Validate("routing line"."Work Center Group Code", Estimateline."Work Centor Group");
                                            "routing line".Validate("Setup Time", (Estimateline."Setup Time(Min)" / EstimateHeaderSubRout.Quantity));
                                            "routing line".Validate("Run Time", (Estimateline."Run Time (Min)" / EstimateHeaderSubRout.Quantity));
                                            "routing line"."Die Cut Ups" := Estimateline."Die Cut Ups";
                                            "routing line"."No of Joints" := Estimateline."No of Joints";
                                            // Lines updated bY Deepak kUmar 23 11 15
                                            "routing line"."Estimate Type" := Estimateline."Product Design Type";
                                            "routing line"."Estimation No." := Estimateline."Product Design No.";
                                            "routing line"."Sub Comp No." := Estimateline."Sub Comp No.";
                                            "routing line".Modify(true);
                                        end;
                                    until Estimateline.Next = 0;
                                end;
                                routing.Status := routing.Status::"Under Development";
                                routing.Validate(Status, routing.Status::Certified);
                                routing.Modify(true);
                                ItemTable.Validate(ItemTable."Routing No.", routing."No.");
                                ItemTable.Modify(true);
                            end else begin
                                routing.Reset;
                                routing.SetRange(routing."No.", ItemTable."Routing No.");
                                if routing.FindFirst then begin
                                    routing.Status := routing.Status::"Under Development";
                                    routing.Modify(true);

                                    "routing line".Reset;
                                    "routing line".SetRange("routing line"."Routing No.", routing."No.");
                                    if "routing line".FindFirst then begin
                                        "routing line".DeleteAll;
                                    end;

                                    "Operation No." := 10;
                                    Estimateline.Reset;
                                    Estimateline.SetCurrentKey("Work Center Category", "Line No.");
                                    Estimateline.SetRange(Estimateline."Product Design Type", EstimateComponent."Product Design Type");
                                    Estimateline.SetRange(Estimateline."Product Design No.", EstimateComponent."Product Design No.");
                                    Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateComponent."Sub Comp No.");
                                    Estimateline.SetRange(Estimateline."Consume / Process For", EstimateComponent."Material / Process Link Code");
                                    Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                                    if Estimateline.FindFirst then begin
                                        repeat
                                            if (Estimateline.Type = Estimateline.Type::"Work Center") or (Estimateline.Type = Estimateline.Type::"Machine Center") then begin
                                                "routing line".Init;
                                                "routing line"."Routing No." := routing."No.";
                                                "routing line"."Operation No." := Format("Operation No.");
                                                "routing line".Insert(true);
                                                "routing line".Validate("Operation No.");
                                                "Operation No." := "Operation No." + 5;

                                                if Estimateline.Type = 2 then
                                                    "routing line".Validate("routing line".Type, 0);
                                                if Estimateline.Type = 3 then
                                                    "routing line".Validate("routing line".Type, 1);

                                                "routing line".Validate("routing line"."No.", Estimateline."No.");
                                                "routing line".Validate("routing line".Description, Estimateline.Description);
                                                "routing line".Validate("routing line"."Unit Cost per", Estimateline."Unit Cost");
                                                "routing line".Validate("routing line"."Work Center Group Code", Estimateline."Work Centor Group");
                                                "routing line".Validate("Setup Time", (Estimateline."Setup Time(Min)" / EstimateHeaderSubRout.Quantity));
                                                "routing line".Validate("Run Time", (Estimateline."Run Time (Min)" / EstimateHeaderSubRout.Quantity));
                                                "routing line"."Die Cut Ups" := Estimateline."Die Cut Ups";
                                                "routing line"."No of Joints" := Estimateline."No of Joints";
                                                // Lines updated bY Deepak kUmar 23 11 15
                                                "routing line"."Estimate Type" := Estimateline."Product Design Type";
                                                "routing line"."Estimation No." := Estimateline."Product Design No.";
                                                "routing line"."Sub Comp No." := Estimateline."Sub Comp No.";
                                                "routing line".Modify(true);


                                                "routing line".Modify(true);
                                            end;
                                        until Estimateline.Next = 0;
                                    end;
                                    routing.Validate(Status, routing.Status::Certified);
                                    routing.Modify(true);
                                end;
                            end;
                            // Update Item Details
                            ItemTable."Model No" := EstimateHeaderSubRout."Model No";
                            ItemTable."Model Description" := EstimateHeaderSubRout."Model Description";
                            ItemTable."No. of Ply" := EstimateHeaderSubRout."No. of Ply";
                            ItemTable."Flute Type" := EstimateHeaderSubRout."Flute Type";
                            ItemTable."Color Code" := EstimateHeaderSubRout."Top Colour";
                            ItemTable."Flute 1" := EstimateHeaderSubRout."Flute 1";
                            ItemTable."Flute 2" := EstimateHeaderSubRout."Flute 2";
                            ItemTable."Flute 3" := EstimateHeaderSubRout."Flute 3";
                            ItemTable."Board Length" := EstimateHeaderSubRout."Board Length (mm)- L";
                            ItemTable."Board Width" := EstimateHeaderSubRout."Board Width (mm)- W";

                            ItemTable."Estimate No." := EstimateHeaderSubRout."Product Design No.";
                            ItemTable.Blocked := false;
                            ItemTable.Modify(true);

                        end;
                    until EstimateComponent.Next = 0;
                end;
            until EstimateHeaderSubRout.Next = 0;
        end;
    end;

    procedure CreateProdBom(EstimateType: Option Main,Sub; EstimateNo: Code[50]; SubCompNo: Code[50])
    var
        EstimateComponent: Record "Product Design Component Table";
        LineNo: Integer;
        EstimateHeaderBOM: Record "Product Design Header";
        TempQtyPer: Decimal;
    begin

        // Lines added by Deepak Kumar
        EstimateHeaderBOM.Reset;
        EstimateHeaderBOM.SetCurrentKey("Product Design Type", "Product Design No.", "Sub Comp No.");
        EstimateHeaderBOM.SetRange(EstimateHeaderBOM."Product Design Type", EstimateType);
        EstimateHeaderBOM.SetRange(EstimateHeaderBOM."Product Design No.", EstimateNo);
        EstimateHeaderBOM.SetRange(EstimateHeaderBOM."Sub Comp No.", SubCompNo);
        if EstimateHeaderBOM.FindFirst then begin
            repeat

                ItemTable.Reset;
                ItemTable.SetRange(ItemTable."No.", EstimateHeaderBOM."Item Code");
                if ItemTable.FindFirst then begin


                    if ItemTable."Production BOM No." = '' then begin

                        ProductionBomheader.Init;
                        ProductionBomheader."No." := EstimateHeaderBOM."Item Code";
                        ProductionBomheader.Insert(true);

                        ProductionBomheader.Validate(ProductionBomheader."Item No.", ItemTable."No.");
                        ProductionBomheader.Validate(ProductionBomheader.Description, ItemTable.Description);
                        ProductionBomheader.Validate(ProductionBomheader."Unit of Measure Code", ItemTable."Base Unit of Measure");
                        ProductionBomheader.Modify(true);

                        Estimateline.Reset;
                        Estimateline.SetRange(Estimateline."Product Design Type", EstimateHeaderBOM."Product Design Type");
                        Estimateline.SetRange(Estimateline."Product Design No.", EstimateHeaderBOM."Product Design No.");
                        Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateHeaderBOM."Sub Comp No.");
                        Estimateline.SetRange(Estimateline."Consume / Process For", '');
                        Estimateline.SetRange(Estimateline.Type, Estimateline.Type::Item);
                        Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                        if Estimateline.FindFirst then begin
                            repeat
                                ProductionBomLine.Init;
                                ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                ProductionBomLine.Validate(ProductionBomLine."Line No.", Estimateline."Line No.");
                                ProductionBomLine.Insert(true);

                                ProductionBomLine.Validate(ProductionBomLine.Type, Estimateline.Type);
                                ProductionBomLine.Validate(ProductionBomLine."No.", Estimateline."No.");
                                ProductionBomLine.Validate(ProductionBomLine.Description, Estimateline.Description);
                                ProductionBomLine.Validate(ProductionBomLine."Unit of Measure Code", Estimateline."Unit Of Measure");
                                ProductionBomLine.Validate(ProductionBomLine."Quantity per", (Estimateline.Quantity / EstimateHeaderBOM.Quantity));
                                ProductionBomLine.Validate(ProductionBomLine."Take Up", Estimateline."Take Up");
                                ProductionBomLine.Validate(ProductionBomLine."Paper Position", Estimateline."Paper Position");
                                ProductionBomLine.Validate(ProductionBomLine."Flute Type", Estimateline."Flute Type");
                                // Lines Updated by Deepak Kumar // 23 11 15
                                ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";
                                ProductionBomLine.Modify(true);
                            until Estimateline.Next = 0;
                        end;
                        // Lines updated for add Component Item
                        EstimateComponent.Reset;
                        EstimateComponent.SetRange(EstimateComponent."Product Design Type", EstimateHeaderBOM."Product Design Type");
                        EstimateComponent.SetRange(EstimateComponent."Product Design No.", EstimateHeaderBOM."Product Design No.");
                        EstimateComponent.SetRange(EstimateComponent."Sub Comp No.", EstimateHeaderBOM."Sub Comp No.");
                        EstimateComponent.SetRange(EstimateComponent."Component Of", '');
                        if EstimateComponent.FindFirst then begin
                            LineNo := 4500;
                            repeat
                                ProductionBomLine.Init;
                                ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                ProductionBomLine.Validate(ProductionBomLine."Line No.", LineNo);
                                LineNo := LineNo + 1;
                                ProductionBomLine.Insert(true);

                                ProductionBomLine.Validate(ProductionBomLine.Type, ProductionBomLine.Type::Item);
                                ProductionBomLine.Validate(ProductionBomLine."No.", EstimateComponent."Item No.");
                                ProductionBomLine.Validate(ProductionBomLine.Description, EstimateComponent."Item Description");
                                ProductionBomLine.Validate(ProductionBomLine."Take Up", EstimateComponent."Take Up");
                                ProductionBomLine.Validate(ProductionBomLine."Paper Position", EstimateComponent."Paper Position");
                                ProductionBomLine.Validate(ProductionBomLine."Flute Type", EstimateComponent."Flute Type");
                                //ProductionBomLine.VALIDATE(ProductionBomLine."Unit of Measure Code",Estimateline."Unit Of Measure");
                                if EstimateComponent."Die Cut Ups" > 0 then
                                    TempQtyPer := 1 / EstimateComponent."Die Cut Ups"
                                else
                                    TempQtyPer := 1;

                                if EstimateComponent."No of Joints" > 1 then
                                    TempQtyPer := TempQtyPer * EstimateComponent."No of Joints";

                                ProductionBomLine.Validate(ProductionBomLine."Quantity per", TempQtyPer);
                                ProductionBomLine."Routing Link Code" := EstimateComponent."Routing Link Code";
                                // Lines Updated by Deepak Kumar // 23 11 15
                                ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";

                                ProductionBomLine.Modify(true);
                            until EstimateComponent.Next = 0;
                        end;
                        //If for Main Component
                        if EstimateHeaderBOM."Product Design Type" = EstimateHeaderBOM."Product Design Type"::Main then begin
                            MainEstimate.SetRange(MainEstimate."Product Design Type", MainEstimate."Product Design Type"::Sub);
                            MainEstimate.SetRange(MainEstimate."Product Design No.", EstimateHeaderBOM."Product Design No.");
                            MainEstimate.SetFilter(MainEstimate."Item Code", Sam001);
                            if MainEstimate.FindFirst then begin
                                LineNo := 5500;
                                repeat
                                    ProductionBomLine.Init;
                                    ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                    ProductionBomLine.Validate(ProductionBomLine."Line No.", LineNo);
                                    LineNo := LineNo + 1;
                                    ProductionBomLine.Insert(true);
                                    ProductionBomLine.Validate(ProductionBomLine.Type, ProductionBomLine.Type::Item);
                                    ProductionBomLine.Validate(ProductionBomLine."No.", MainEstimate."Item Code");
                                    ProductionBomLine.Validate(ProductionBomLine.Description, MainEstimate."Item Description");
                                    ProductionBomLine.Validate(ProductionBomLine."Unit of Measure Code", MainEstimate."Item Unit of Measure");
                                    ProductionBomLine.Validate(ProductionBomLine."Quantity per", (MainEstimate.Quantity / EstimateHeaderBOM.Quantity));
                                    // Lines Updated by Deepak Kumar // 23 11 15
                                    ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                    ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                    ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";
                                    //  MESSAGE(FORMAT(MainEstimate."Separate Sales Lines"));
                                    if MainEstimate."Separate Sales Lines" = false then begin
                                        MfgSetup.Get;
                                        MfgSetup.TestField(MfgSetup."Component Routing Link");
                                        ProductionBomLine."Routing Link Code" := MfgSetup."Component Routing Link";
                                    end;

                                    ProductionBomLine.Modify(true);
                                until MainEstimate.Next = 0;
                            end;
                        end;

                        ProductionBomheader.Status := ProductionBomheader.Status::Certified;
                        ProductionBomheader.Modify(true);
                        ItemTable.Validate(ItemTable."Production BOM No.", ProductionBomheader."No.");
                        ItemTable."Model No" := EstimateHeaderBOM."Model No";
                        ItemTable."Model Description" := EstimateHeaderBOM."Model Description";
                        ItemTable."No. of Ply" := EstimateHeaderBOM."No. of Ply";
                        ItemTable."Flute Type" := EstimateHeaderBOM."Flute Type";
                        ItemTable."Color Code" := EstimateHeaderBOM."Top Colour";
                        ItemTable."Flute 1" := EstimateHeaderBOM."Flute 1";
                        ItemTable."Flute 2" := EstimateHeaderBOM."Flute 2";
                        ItemTable."Flute 3" := EstimateHeaderBOM."Flute 3";
                        ItemTable."Board Length" := EstimateHeaderBOM."Board Length (mm)- L";
                        ItemTable."Board Width" := EstimateHeaderBOM."Board Width (mm)- W";

                        ItemTable."Estimate No." := EstimateHeaderBOM."Product Design No.";
                        ItemTable.Modify(true);
                    end else begin
                        ProductionBomheader.Reset;
                        ProductionBomheader.SetRange(ProductionBomheader."No.", ItemTable."Production BOM No.");
                        if ProductionBomheader.FindFirst then begin
                            ProductionBomheader.Status := ProductionBomheader.Status::"Under Development";
                            ProductionBomheader.Modify(true);
                            ProductionBomLine.Reset;
                            ProductionBomLine.SetRange(ProductionBomLine."Production BOM No.", ProductionBomheader."No.");
                            if ProductionBomLine.FindFirst then begin
                                ProductionBomLine.DeleteAll(true);
                            end;
                            Estimateline.Reset;
                            Estimateline.SetRange(Estimateline."Product Design Type", EstimateHeaderBOM."Product Design Type");
                            Estimateline.SetRange(Estimateline."Product Design No.", EstimateHeaderBOM."Product Design No.");
                            Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateHeaderBOM."Sub Comp No.");
                            Estimateline.SetRange(Estimateline."Consume / Process For", '');
                            Estimateline.SetRange(Estimateline.Type, Estimateline.Type::Item);
                            Estimateline.SetFilter(Estimateline."No.", '<>%1', '');

                            if Estimateline.FindFirst then begin
                                repeat
                                    ProductionBomLine.Init;
                                    ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                    ProductionBomLine.Validate(ProductionBomLine."Line No.", Estimateline."Line No.");
                                    ProductionBomLine.Insert(true);
                                    ProductionBomLine.Validate(ProductionBomLine.Type, Estimateline.Type);
                                    ProductionBomLine.Validate(ProductionBomLine."No.", Estimateline."No.");
                                    ProductionBomLine.Validate(ProductionBomLine.Description, Estimateline.Description);
                                    ProductionBomLine.Validate(ProductionBomLine."Unit of Measure Code", Estimateline."Unit Of Measure");
                                    ProductionBomLine.Validate(ProductionBomLine."Quantity per", (Estimateline.Quantity / EstimateHeaderBOM.Quantity));
                                    ProductionBomLine.Validate(ProductionBomLine."Take Up", Estimateline."Take Up");
                                    ProductionBomLine.Validate(ProductionBomLine."Paper Position", Estimateline."Paper Position");
                                    ProductionBomLine.Validate(ProductionBomLine."Flute Type", Estimateline."Flute Type");
                                    // Lines Updated by Deepak Kumar // 23 11 15
                                    ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                    ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                    ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";

                                    ProductionBomLine.Modify(true);
                                until Estimateline.Next = 0;
                            end;
                            // Lines updated for add Component Item
                            EstimateComponent.Reset;
                            EstimateComponent.SetRange(EstimateComponent."Product Design Type", EstimateHeaderBOM."Product Design Type");
                            EstimateComponent.SetRange(EstimateComponent."Product Design No.", EstimateHeaderBOM."Product Design No.");
                            EstimateComponent.SetRange(EstimateComponent."Sub Comp No.", EstimateHeaderBOM."Sub Comp No.");
                            EstimateComponent.SetRange(EstimateComponent."Component Of", '');
                            if EstimateComponent.FindFirst then begin
                                LineNo := 4500;
                                repeat
                                    ProductionBomLine.Init;
                                    ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                    ProductionBomLine.Validate(ProductionBomLine."Line No.", LineNo);
                                    LineNo := LineNo + 1;
                                    ProductionBomLine.Insert(true);

                                    ProductionBomLine.Validate(ProductionBomLine.Type, ProductionBomLine.Type::Item);
                                    ProductionBomLine.Validate(ProductionBomLine."No.", EstimateComponent."Item No.");
                                    ProductionBomLine.Validate(ProductionBomLine.Description, EstimateComponent."Item Description");
                                    ProductionBomLine.Validate(ProductionBomLine."Take Up", EstimateComponent."Take Up");
                                    ProductionBomLine.Validate(ProductionBomLine."Paper Position", EstimateComponent."Paper Position");
                                    ProductionBomLine.Validate(ProductionBomLine."Flute Type", EstimateComponent."Flute Type");
                                    //ProductionBomLine.VALIDATE(ProductionBomLine."Unit of Measure Code",Estimateline."Unit Of Measure");
                                    if EstimateComponent."Die Cut Ups" > 0 then
                                        TempQtyPer := 1 / EstimateComponent."Die Cut Ups"
                                    else
                                        TempQtyPer := 1;

                                    if EstimateComponent."No of Joints" > 1 then
                                        TempQtyPer := TempQtyPer * EstimateComponent."No of Joints";

                                    ProductionBomLine.Validate(ProductionBomLine."Quantity per", TempQtyPer);
                                    ProductionBomLine."Routing Link Code" := EstimateComponent."Routing Link Code";
                                    // Lines Updated by Deepak Kumar // 23 11 15
                                    ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                    ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                    ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";

                                    ProductionBomLine.Modify(true);
                                    //     MESSAGE('I am Here %1',EstimateComponent."Item No.");
                                until EstimateComponent.Next = 0;
                            end;
                            //If for Main Component
                            if EstimateHeaderBOM."Product Design Type" = EstimateHeaderBOM."Product Design Type"::Main then begin
                                MainEstimate.Reset;
                                MainEstimate.SetRange(MainEstimate."Product Design Type", MainEstimate."Product Design Type"::Sub);
                                MainEstimate.SetRange(MainEstimate."Product Design No.", EstimateHeaderBOM."Product Design No.");
                                MainEstimate.SetFilter(MainEstimate."Item Code", Sam001);
                                if MainEstimate.FindFirst then begin
                                    LineNo := 5500;
                                    repeat
                                        ProductionBomLine.Init;
                                        ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                        ProductionBomLine.Validate(ProductionBomLine."Line No.", LineNo);
                                        LineNo := LineNo + 1;
                                        ProductionBomLine.Insert(true);
                                        ProductionBomLine.Validate(ProductionBomLine.Type, ProductionBomLine.Type::Item);
                                        ProductionBomLine.Validate(ProductionBomLine."No.", MainEstimate."Item Code");
                                        ProductionBomLine.Validate(ProductionBomLine.Description, MainEstimate."Item Description");
                                        ProductionBomLine.Validate(ProductionBomLine."Unit of Measure Code", MainEstimate."Item Unit of Measure");
                                        ProductionBomLine.Validate(ProductionBomLine."Quantity per", (MainEstimate.Quantity / EstimateHeaderBOM.Quantity));
                                        // Lines Updated by Deepak Kumar // 23 11 15
                                        ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                        ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                        ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";
                                        if MainEstimate."Separate Sales Lines" = false then begin
                                            MfgSetup.Get;
                                            MfgSetup.TestField(MfgSetup."Component Routing Link");
                                            ProductionBomLine."Routing Link Code" := MfgSetup."Component Routing Link";
                                        end;


                                        ProductionBomLine.Modify(true);
                                    until MainEstimate.Next = 0;
                                end;
                            end;


                            ProductionBomheader.Status := ProductionBomheader.Status::Certified;
                            ProductionBomheader.Modify(true);

                            ItemTable."Model No" := EstimateHeaderBOM."Model No";
                            ItemTable."Model Description" := EstimateHeaderBOM."Model Description";
                            ItemTable."No. of Ply" := EstimateHeaderBOM."No. of Ply";
                            ItemTable."Flute Type" := EstimateHeaderBOM."Flute Type";
                            ItemTable."Color Code" := EstimateHeaderBOM."Top Colour";
                            ItemTable."Flute 1" := EstimateHeaderBOM."Flute 1";
                            ItemTable."Flute 2" := EstimateHeaderBOM."Flute 2";
                            ItemTable."Flute 3" := EstimateHeaderBOM."Flute 3";
                            ItemTable."Board Length" := EstimateHeaderBOM."Board Length (mm)- L";
                            ItemTable."Board Width" := EstimateHeaderBOM."Board Width (mm)- W";


                            ItemTable."Estimate No." := EstimateHeaderBOM."Product Design No.";
                            ItemTable.Modify(true);

                        end;
                    end;
                end;
                ;
            until EstimateHeaderBOM.Next = 0;
        end;
    end;

    procedure CreateProdRouting(EstimateType: Option Main,Sub; EstimateNo: Code[50]; SubCompNo: Code[50])
    var
        EstimateHeaderRout: Record "Product Design Header";
        EstimateLinkCode: Record "Material / Process Link Code";
    begin

        // Lines added by Deepak Kumar
        EstimateHeaderRout.Reset;
        EstimateHeaderRout.SetCurrentKey("Product Design Type", "Product Design No.", "Sub Comp No.");
        EstimateHeaderRout.SetRange(EstimateHeaderRout."Product Design Type", EstimateType);
        EstimateHeaderRout.SetRange(EstimateHeaderRout."Product Design No.", EstimateNo);
        EstimateHeaderRout.SetRange(EstimateHeaderRout."Sub Comp No.", SubCompNo);
        if EstimateHeaderRout.FindFirst then begin
            repeat
                ItemTable.Reset;
                ItemTable.SetRange(ItemTable."No.", EstimateHeaderRout."Item Code");
                if ItemTable.FindFirst then begin

                    if ItemTable."Routing No." = '' then begin
                        routing.Init;
                        routing."No." := EstimateHeaderRout."Item Code";
                        routing.Insert(true);

                        routing.Validate(routing."Item No.", ItemTable."No.");
                        routing.Validate(routing.Description, ItemTable.Description);
                        routing."Estimate No." := EstimateHeaderRout."Product Design No.";
                        routing.Modify(true);

                        "Operation No." := 10;
                        Estimateline.Reset;
                        Estimateline.SetCurrentKey("Work Center Category", "Line No.");
                        Estimateline.SetRange(Estimateline."Product Design Type", EstimateHeaderRout."Product Design Type");
                        Estimateline.SetRange(Estimateline."Product Design No.", EstimateHeaderRout."Product Design No.");
                        Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateHeaderRout."Sub Comp No.");
                        Estimateline.SetRange(Estimateline."Consume / Process For", '');
                        Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                        if Estimateline.FindFirst then begin
                            repeat
                                if (Estimateline.Type = Estimateline.Type::"Work Center") or (Estimateline.Type = Estimateline.Type::"Machine Center") then begin
                                    "routing line".Init;
                                    "routing line"."Routing No." := routing."No.";
                                    "routing line"."Operation No." := Format("Operation No.");
                                    "routing line".Insert(true);
                                    "routing line".Validate("Operation No.");
                                    "Operation No." := "Operation No." + 5;

                                    if Estimateline.Type = 2 then
                                        "routing line".Validate("routing line".Type, 0);
                                    if Estimateline.Type = 3 then
                                        "routing line".Validate("routing line".Type, 1);

                                    "routing line".Validate("routing line"."No.", Estimateline."No.");
                                    "routing line".Validate("routing line".Description, Estimateline.Description);
                                    "routing line".Validate("routing line"."Unit Cost per", Estimateline."Unit Cost");
                                    "routing line".Validate("routing line"."Work Center Group Code", Estimateline."Work Centor Group");
                                    "routing line".Validate("Setup Time", (Estimateline."Setup Time(Min)" / EstimateHeaderRout.Quantity));
                                    "routing line".Validate("Run Time", (Estimateline."Run Time (Min)" / EstimateHeaderRout.Quantity));
                                    "routing line"."Die Cut Ups" := Estimateline."Die Cut Ups";
                                    "routing line"."No of Joints" := Estimateline."No of Joints";

                                    // lines Updated by Deepak Kumar  23 11 15
                                    "routing line"."Estimate Type" := Estimateline."Product Design Type";
                                    "routing line"."Estimation No." := Estimateline."Product Design No.";
                                    "routing line"."Sub Comp No." := Estimateline."Sub Comp No.";

                                    if "routing line"."Operation No." = '10' then begin
                                        EstimateLinkCode.Reset;
                                        EstimateLinkCode.SetRange(EstimateLinkCode.Default, true);
                                        if EstimateLinkCode.FindFirst then begin
                                            EstimateLinkCode.TestField(EstimateLinkCode."Routing Link Code");
                                            "routing line"."Routing Link Code" := EstimateLinkCode."Routing Link Code";
                                        end;
                                    end;
                                    "routing line".Modify(true);
                                end;
                            until Estimateline.Next = 0;
                        end;
                        routing.Status := routing.Status::"Under Development";
                        routing.Validate(Status, routing.Status::Certified);
                        routing.Modify(true);
                        ItemTable.Validate(ItemTable."Routing No.", routing."No.");
                        ItemTable.Modify(true);
                    end else begin
                        routing.Reset;
                        routing.SetRange(routing."No.", ItemTable."Routing No.");
                        if routing.FindFirst then begin
                            routing.Status := routing.Status::"Under Development";
                            routing.Modify(true);

                            "routing line".Reset;
                            "routing line".SetRange("routing line"."Routing No.", routing."No.");
                            if "routing line".FindFirst then begin
                                "routing line".DeleteAll;
                            end;

                            "Operation No." := 10;
                            Estimateline.Reset;
                            Estimateline.SetCurrentKey("Work Center Category", "Line No.");
                            Estimateline.SetRange(Estimateline."Product Design Type", EstimateHeaderRout."Product Design Type");
                            Estimateline.SetRange(Estimateline."Product Design No.", EstimateHeaderRout."Product Design No.");
                            Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateHeaderRout."Sub Comp No.");
                            Estimateline.SetRange(Estimateline."Consume / Process For", '');
                            Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                            if Estimateline.FindFirst then begin
                                repeat
                                    if (Estimateline.Type = Estimateline.Type::"Work Center") or (Estimateline.Type = Estimateline.Type::"Machine Center") then begin
                                        "routing line".Init;
                                        "routing line"."Routing No." := routing."No.";
                                        "routing line"."Operation No." := Format("Operation No.");
                                        "routing line".Insert(true);
                                        "routing line".Validate("Operation No.");
                                        "Operation No." := "Operation No." + 5;

                                        if Estimateline.Type = 2 then
                                            "routing line".Validate("routing line".Type, 0);
                                        if Estimateline.Type = 3 then
                                            "routing line".Validate("routing line".Type, 1);

                                        "routing line".Validate("routing line"."No.", Estimateline."No.");
                                        "routing line".Validate("routing line".Description, Estimateline.Description);
                                        "routing line".Validate("routing line"."Unit Cost per", Estimateline."Unit Cost");
                                        "routing line".Validate("routing line"."Work Center Group Code", Estimateline."Work Centor Group");
                                        "routing line".Validate("Setup Time", (Estimateline."Setup Time(Min)" / EstimateHeaderRout.Quantity));
                                        "routing line".Validate("Run Time", (Estimateline."Run Time (Min)" / EstimateHeaderRout.Quantity));
                                        "routing line"."Die Cut Ups" := Estimateline."Die Cut Ups";
                                        "routing line"."No of Joints" := Estimateline."No of Joints";
                                        // lines Updated by Deepak Kumar  23 11 15
                                        "routing line"."Estimate Type" := Estimateline."Product Design Type";
                                        "routing line"."Estimation No." := Estimateline."Product Design No.";
                                        "routing line"."Sub Comp No." := Estimateline."Sub Comp No.";


                                        if "routing line"."Operation No." = '10' then begin
                                            EstimateLinkCode.Reset;
                                            EstimateLinkCode.SetRange(EstimateLinkCode.Default, true);
                                            if EstimateLinkCode.FindFirst then begin
                                                EstimateLinkCode.TestField(EstimateLinkCode."Routing Link Code");
                                                "routing line"."Routing Link Code" := EstimateLinkCode."Routing Link Code";
                                            end;
                                        end;

                                        "routing line".Modify(true);
                                    end;
                                until Estimateline.Next = 0;
                            end;

                            routing.Validate(Status, routing.Status::Certified);
                            routing.Modify(true);
                        end;
                    end;
                    // Update Item Details
                    ItemTable."Model No" := EstimateHeaderRout."Model No";
                    ItemTable."Model Description" := EstimateHeaderRout."Model Description";
                    ItemTable."No. of Ply" := EstimateHeaderRout."No. of Ply";
                    ItemTable."Flute Type" := EstimateHeaderRout."Flute Type";
                    ItemTable."Color Code" := EstimateHeaderRout."Top Colour";
                    ItemTable."Flute 1" := EstimateHeaderRout."Flute 1";
                    ItemTable."Flute 2" := EstimateHeaderRout."Flute 2";
                    ItemTable."Flute 3" := EstimateHeaderRout."Flute 3";
                    ItemTable."Board Length" := EstimateHeaderRout."Board Length (mm)- L";
                    ItemTable."Board Width" := EstimateHeaderRout."Board Width (mm)- W";

                    ItemTable."Estimate No." := EstimateHeaderRout."Product Design No.";
                    ItemTable.Blocked := false;
                    ItemTable.Modify(true);

                end;
                ;
            until EstimateHeaderRout.Next = 0;
        end;
    end;

    procedure UpdateSubCompBOMDetails(EstimateNo: Code[50])
    var
        EstimateComponent: Record "Product Design Component Table";
        EstimateComponentX: Record "Product Design Component Table";
        LineNumber: Integer;
    begin
        // Lines added by Deepak Kumar
        EstimateComponent.Reset;
        EstimateComponent.SetRange(EstimateComponent."Product Design No.", EstimateNo);
        EstimateComponent.SetRange(EstimateComponent."Component Of", Sam001);
        if EstimateComponent.FindFirst then begin
            repeat
                EstimateComponentX.Reset;
                EstimateComponentX.SetRange(EstimateComponentX."Product Design Type", EstimateComponent."Product Design Type");
                EstimateComponentX.SetRange(EstimateComponentX."Product Design No.", EstimateComponent."Product Design No.");
                EstimateComponentX.SetRange(EstimateComponentX."Material / Process Link Code", EstimateComponent."Component Of");
                if EstimateComponentX.FindFirst then begin
                    LineNumber := 6500;
                    repeat
                        ProductionBomheader.Reset;
                        ProductionBomheader.SetRange(ProductionBomheader."No.", EstimateComponentX."Item No.");
                        if ProductionBomheader.FindFirst then begin
                            ProductionBomheader.Status := ProductionBomheader.Status::"Under Development";
                            ProductionBomheader.Modify(true);


                            ProductionBomLine.Init;
                            ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                            ProductionBomLine.Validate(ProductionBomLine."Line No.", LineNumber);
                            LineNumber := LineNumber + 1;
                            ProductionBomLine.Insert(true);

                            ProductionBomLine.Validate(ProductionBomLine.Type, ProductionBomLine.Type::Item);
                            ProductionBomLine.Validate(ProductionBomLine."No.", EstimateComponentX."Item No.");
                            ProductionBomLine.Validate(ProductionBomLine.Description, EstimateComponentX."Item Description");
                            ProductionBomLine.Validate(ProductionBomLine."Take Up", EstimateComponentX."Take Up");
                            ProductionBomLine.Validate(ProductionBomLine."Paper Position", EstimateComponentX."Paper Position");
                            ProductionBomLine.Validate(ProductionBomLine."Flute Type", EstimateComponentX."Flute Type");
                            ProductionBomLine."Routing Link Code" := EstimateComponentX."Routing Link Code";
                            //ProductionBomLine.VALIDATE(ProductionBomLine."Unit of Measure Code",Estimateline."Unit Of Measure");

                            ProductionBomLine.Validate(ProductionBomLine."Quantity per", 1);
                            ProductionBomLine."Estimate Type" := EstimateComponentX."Product Design Type";
                            ProductionBomLine."Estimation No." := EstimateComponentX."Product Design No.";
                            ProductionBomLine."Sub Comp No." := EstimateComponentX."Sub Comp No.";
                            ProductionBomLine.Modify(true);
                            ProductionBomheader.Status := ProductionBomheader.Status::Certified;
                            ProductionBomheader.Modify(true);
                        end;
                    until EstimateComponentX.Next = 0;
                end;
            until EstimateComponent.Next = 0;
        end;
    end;

    procedure QuickEstimate(EstimateNo: Code[30])
    var
        QuickEstimateProcess: Record "Quick Entry Process";
        EstimateLine: Record "Product Design Line";
        LineNumber: Integer;
    begin
        // Lines added by Deepak kumar
        QuickEstimateProcess.Reset;
        QuickEstimateProcess.SetCurrentKey("Product Design Type", "Product Design No.", "Sub Comp No.", "Process Code", "Paper Position");
        QuickEstimateProcess.SetRange(QuickEstimateProcess."Product Design No.", EstimateNo);
        if QuickEstimateProcess.FindFirst then begin
            EstimateLine.Reset;
            EstimateLine.SetRange(EstimateLine."Product Design No.", EstimateNo);
            if EstimateLine.FindFirst then begin
                EstimateLine.DeleteAll(true);
            end;
            LineNumber := 10000;
            repeat
                if QuickEstimateProcess."Work Center Category" = QuickEstimateProcess."Work Center Category"::Materials then begin
                    EstimateLine.Init;
                    EstimateLine."Product Design Type" := QuickEstimateProcess."Product Design Type";
                    EstimateLine."Product Design No." := QuickEstimateProcess."Product Design No.";
                    EstimateLine."Sub Comp No." := QuickEstimateProcess."Sub Comp No.";
                    EstimateLine."Line No." := LineNumber;
                    EstimateLine.Insert(true);
                    EstimateLine."Work Center Category" := EstimateLine."Work Center Category"::Materials;
                    EstimateLine."Paper Position" := QuickEstimateProcess."Paper Position";
                    EstimateLine.Type := EstimateLine.Type::Item;
                    EstimateLine.Validate("No.", QuickEstimateProcess."Item Code");
                    if (QuickEstimateProcess."Paper Position" = 2) or (QuickEstimateProcess."Paper Position" = 4) or (QuickEstimateProcess."Paper Position" = 6) then begin
                        EstimateLine.Validate("Flute Type", QuickEstimateProcess."Flute Type");
                    end;
                    EstimateLine.Validate("Unit Cost", QuickEstimateProcess."Unit Cost");
                    EstimateLine.Modify(true);


                end;
                if (QuickEstimateProcess."Work Center Category" <> QuickEstimateProcess."Work Center Category"::Materials) and (QuickEstimateProcess.Required = true) then begin
                    EstimateLine.Init;
                    EstimateLine."Product Design Type" := QuickEstimateProcess."Product Design Type";
                    EstimateLine."Product Design No." := QuickEstimateProcess."Product Design No.";
                    EstimateLine."Sub Comp No." := QuickEstimateProcess."Sub Comp No.";
                    EstimateLine."Line No." := LineNumber;
                    EstimateLine.Insert(true);

                    EstimateLine."Work Center Category" := QuickEstimateProcess."Work Center Category";
                    if QuickEstimateProcess.Type = QuickEstimateProcess.Type::"Work Center" then
                        EstimateLine.Type := EstimateLine.Type::"Work Center";

                    if QuickEstimateProcess.Type = QuickEstimateProcess.Type::"Machine Center" then
                        EstimateLine.Type := EstimateLine.Type::"Machine Center";

                    EstimateLine.Validate("No.", QuickEstimateProcess."No.");
                    EstimateLine.Validate("Unit Cost", QuickEstimateProcess."Unit Cost");
                    EstimateLine.Modify(true);
                end;
                LineNumber += 1000;
            until QuickEstimateProcess.Next = 0;
        end;
    end;

    procedure PublishBOMRouting(var EstimateNo: Code[50])
    var
        EstimateHeaderM: Record "Product Design Header";
    begin
        // Lines added BY Deepak Kumar

        EstimateHeaderM.Reset;
        EstimateHeaderM.SetRange(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design Type"::Main);
        EstimateHeaderM.SetRange(EstimateHeaderM."Product Design No.", EstimateNo);
        if EstimateHeaderM.FindFirst then begin

            EstimateHeaderM.TestField(EstimateHeaderM."Item Code");
            ItemMaster.Get(EstimateHeaderM."Item Code");
            ItemMaster.TestField(ItemMaster."Marked For Enq/Quote", false);
            CreateComponentItem(EstimateHeaderM."Product Design No.");
            CreateSubItem(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");
            CreateSubCompBOM(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");
            CreateSubCompRoute(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");
            CreateProdBom(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");
            CreateProdRouting(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");
            UpdateSubCompBOMDetails(EstimateHeaderM."Product Design No.");
            EstimateHeaderM."BOM Published" := true;
            EstimateHeaderM.Modify();
            Message('Production BOM & Routing Updated');
        end;
    end;

    procedure CreateProdBomSub(EstimateType: Option Main,Sub; EstimateNo: Code[50]; SubCompNo: Code[50])
    var
        EstimateComponent: Record "Product Design Component Table";
        LineNo: Integer;
        EstimateHeaderBOM: Record "Product Design Header";
    begin

        // Lines added by Deepak Kumar
        EstimateHeaderBOM.Reset;
        EstimateHeaderBOM.SetCurrentKey("Product Design Type", "Product Design No.", "Sub Comp No.");
        EstimateHeaderBOM.SetRange(EstimateHeaderBOM."Product Design Type", EstimateType);
        EstimateHeaderBOM.SetRange(EstimateHeaderBOM."Product Design No.", EstimateNo);
        EstimateHeaderBOM.SetRange(EstimateHeaderBOM."Sub Comp No.", SubCompNo);
        if EstimateHeaderBOM.FindFirst then begin

            ItemTable.Reset;
            ItemTable.SetRange(ItemTable."No.", EstimateHeaderBOM."Item Code");
            if ItemTable.FindFirst then begin
                if ItemTable."Production BOM No." = '' then begin

                    ProductionBomheader.Init;
                    ProductionBomheader."No." := EstimateHeaderBOM."Item Code";
                    ProductionBomheader.Insert(true);

                    ProductionBomheader.Validate(ProductionBomheader."Item No.", ItemTable."No.");
                    ProductionBomheader.Validate(ProductionBomheader.Description, ItemTable.Description);
                    ProductionBomheader.Validate(ProductionBomheader."Unit of Measure Code", ItemTable."Base Unit of Measure");
                    ProductionBomheader.Modify(true);

                    Estimateline.Reset;
                    Estimateline.SetRange(Estimateline."Product Design Type", EstimateHeaderBOM."Product Design Type");
                    Estimateline.SetRange(Estimateline."Product Design No.", EstimateHeaderBOM."Product Design No.");
                    Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateHeaderBOM."Sub Comp No.");
                    Estimateline.SetRange(Estimateline.Type, Estimateline.Type::Item);
                    Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                    if Estimateline.FindFirst then begin
                        repeat
                            ProductionBomLine.Init;
                            ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                            ProductionBomLine.Validate(ProductionBomLine."Line No.", Estimateline."Line No.");
                            ProductionBomLine.Insert(true);

                            ProductionBomLine.Validate(ProductionBomLine.Type, Estimateline.Type);
                            ProductionBomLine.Validate(ProductionBomLine."No.", Estimateline."No.");
                            ProductionBomLine.Validate(ProductionBomLine.Description, Estimateline.Description);
                            ProductionBomLine.Validate(ProductionBomLine."Unit of Measure Code", Estimateline."Unit Of Measure");
                            ProductionBomLine.Validate(ProductionBomLine."Quantity per", (Estimateline.Quantity / EstimateHeaderBOM.Quantity));
                            ProductionBomLine.Validate(ProductionBomLine."Take Up", Estimateline."Take Up");
                            ProductionBomLine.Validate(ProductionBomLine."Paper Position", Estimateline."Paper Position");
                            ProductionBomLine.Validate(ProductionBomLine."Flute Type", Estimateline."Flute Type");
                            // LInes updated by deepak kUmar // 23 11 15
                            ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                            ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                            ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";
                            ProductionBomLine.Modify(true);
                        until Estimateline.Next = 0;
                    end;

                    ProductionBomheader.Status := ProductionBomheader.Status::Certified;
                    ProductionBomheader.Modify(true);
                    ItemTable.Validate(ItemTable."Production BOM No.", ProductionBomheader."No.");
                    ItemTable.Modify(true);
                end else begin
                    ProductionBomheader.Reset;
                    ProductionBomheader.SetRange(ProductionBomheader."No.", ItemTable."Production BOM No.");
                    if ProductionBomheader.FindFirst then begin
                        ProductionBomheader.Status := ProductionBomheader.Status::"Under Development";
                        ProductionBomheader.Modify(true);
                        ProductionBomLine.Reset;
                        ProductionBomLine.SetRange(ProductionBomLine."Production BOM No.", ProductionBomheader."No.");
                        if ProductionBomLine.FindFirst then begin
                            ProductionBomLine.DeleteAll(true);
                        end;

                        Estimateline.Reset;
                        Estimateline.SetRange(Estimateline."Product Design Type", EstimateHeaderBOM."Product Design Type");
                        Estimateline.SetRange(Estimateline."Product Design No.", EstimateHeaderBOM."Product Design No.");
                        Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateHeaderBOM."Sub Comp No.");
                        Estimateline.SetRange(Estimateline.Type, Estimateline.Type::Item);
                        Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                        if Estimateline.FindFirst then begin
                            repeat
                                ProductionBomLine.Init;
                                ProductionBomLine."Production BOM No." := ProductionBomheader."No.";
                                ProductionBomLine.Validate(ProductionBomLine."Line No.", Estimateline."Line No.");
                                ProductionBomLine.Insert(true);
                                ProductionBomLine.Validate(ProductionBomLine.Type, Estimateline.Type);
                                ProductionBomLine.Validate(ProductionBomLine."No.", Estimateline."No.");
                                ProductionBomLine.Validate(ProductionBomLine.Description, Estimateline.Description);
                                ProductionBomLine.Validate(ProductionBomLine."Unit of Measure Code", Estimateline."Unit Of Measure");
                                ProductionBomLine.Validate(ProductionBomLine."Quantity per", (Estimateline.Quantity / EstimateHeaderBOM.Quantity));
                                ProductionBomLine.Validate(ProductionBomLine."Take Up", Estimateline."Take Up");
                                ProductionBomLine.Validate(ProductionBomLine."Paper Position", Estimateline."Paper Position");
                                ProductionBomLine.Validate(ProductionBomLine."Flute Type", Estimateline."Flute Type");
                                // LInes updated by deepak kUmar // 23 11 15
                                ProductionBomLine."Estimate Type" := Estimateline."Product Design Type";
                                ProductionBomLine."Estimation No." := Estimateline."Product Design No.";
                                ProductionBomLine."Sub Comp No." := Estimateline."Sub Comp No.";

                                ProductionBomLine.Modify(true);
                            until Estimateline.Next = 0;
                        end;
                        ProductionBomheader.Status := ProductionBomheader.Status::Certified;
                        ProductionBomheader.Modify(true);
                    end;
                end;

            end;
            ;
        end;
    end;

    procedure CreateProdRoutingSub(EstimateType: Option Main,Sub; EstimateNo: Code[50]; SubCompNo: Code[50])
    var
        EstimateHeaderRout: Record "Product Design Header";
        EstimateLinkCode: Record "Material / Process Link Code";
    begin

        // Lines added by Deepak Kumar
        EstimateHeaderRout.Reset;
        EstimateHeaderRout.SetCurrentKey("Product Design Type", "Product Design No.", "Sub Comp No.");
        EstimateHeaderRout.SetRange(EstimateHeaderRout."Product Design Type", EstimateType);
        EstimateHeaderRout.SetRange(EstimateHeaderRout."Product Design No.", EstimateNo);
        EstimateHeaderRout.SetRange(EstimateHeaderRout."Sub Comp No.", SubCompNo);
        if EstimateHeaderRout.FindFirst then begin
            ItemTable.Reset;
            ItemTable.SetRange(ItemTable."No.", EstimateHeaderRout."Item Code");
            if ItemTable.FindFirst then begin

                if ItemTable."Routing No." = '' then begin
                    routing.Init;
                    routing."No." := EstimateHeaderRout."Item Code";
                    routing.Insert(true);

                    routing.Validate(routing."Item No.", ItemTable."No.");
                    routing.Validate(routing.Description, ItemTable.Description);
                    routing."Estimate No." := EstimateHeaderRout."Product Design No.";
                    routing.Modify(true);

                    "Operation No." := 10;
                    Estimateline.Reset;
                    Estimateline.SetCurrentKey("Work Center Category", "Line No.");
                    Estimateline.SetRange(Estimateline."Product Design Type", EstimateHeaderRout."Product Design Type");
                    Estimateline.SetRange(Estimateline."Product Design No.", EstimateHeaderRout."Product Design No.");
                    Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateHeaderRout."Sub Comp No.");
                    Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                    if Estimateline.FindFirst then begin
                        repeat
                            if (Estimateline.Type = Estimateline.Type::"Work Center") or (Estimateline.Type = Estimateline.Type::"Machine Center") then begin
                                "routing line".Init;
                                "routing line"."Routing No." := routing."No.";
                                "routing line"."Operation No." := Format("Operation No.");
                                "routing line".Insert(true);
                                "routing line".Validate("Operation No.");
                                "Operation No." := "Operation No." + 5;

                                if Estimateline.Type = 2 then
                                    "routing line".Validate("routing line".Type, 0);
                                if Estimateline.Type = 3 then
                                    "routing line".Validate("routing line".Type, 1);

                                "routing line".Validate("routing line"."No.", Estimateline."No.");
                                "routing line".Validate("routing line".Description, Estimateline.Description);
                                "routing line".Validate("routing line"."Unit Cost per", Estimateline."Unit Cost");
                                "routing line".Validate("routing line"."Work Center Group Code", Estimateline."Work Centor Group");
                                "routing line".Validate("Setup Time", (Estimateline."Setup Time(Min)" / EstimateHeaderRout.Quantity));
                                "routing line".Validate("Run Time", (Estimateline."Run Time (Min)" / EstimateHeaderRout.Quantity));
                                "routing line"."Die Cut Ups" := Estimateline."Die Cut Ups";
                                "routing line"."No of Joints" := Estimateline."No of Joints";
                                // Lines updated bY Deepak KUmar 23 11 15
                                "routing line"."Estimate Type" := Estimateline."Product Design Type";
                                "routing line"."Estimation No." := Estimateline."Product Design No.";
                                "routing line"."Sub Comp No." := Estimateline."Sub Comp No.";

                                if "routing line"."Operation No." = '10' then begin
                                    EstimateLinkCode.Reset;
                                    EstimateLinkCode.SetRange(EstimateLinkCode.Default, true);
                                    if EstimateLinkCode.FindFirst then begin
                                        EstimateLinkCode.TestField(EstimateLinkCode."Routing Link Code");
                                        "routing line"."Routing Link Code" := EstimateLinkCode."Routing Link Code";
                                    end;
                                end;

                                "routing line".Modify(true);
                            end;
                        until Estimateline.Next = 0;
                    end;
                    routing.Status := routing.Status::"Under Development";
                    routing.Validate(Status, routing.Status::Certified);
                    routing.Modify(true);
                    ItemTable.Validate(ItemTable."Routing No.", routing."No.");
                    ItemTable.Modify(true);
                end else begin
                    routing.Reset;
                    routing.SetRange(routing."No.", ItemTable."Routing No.");
                    if routing.FindFirst then begin
                        routing.Status := routing.Status::"Under Development";
                        routing.Modify(true);

                        "routing line".Reset;
                        "routing line".SetRange("routing line"."Routing No.", routing."No.");
                        if "routing line".FindFirst then begin
                            "routing line".DeleteAll;
                        end;

                        "Operation No." := 10;
                        Estimateline.Reset;
                        Estimateline.SetCurrentKey("Work Center Category", "Line No.");
                        Estimateline.SetRange(Estimateline."Product Design Type", EstimateHeaderRout."Product Design Type");
                        Estimateline.SetRange(Estimateline."Product Design No.", EstimateHeaderRout."Product Design No.");
                        Estimateline.SetRange(Estimateline."Sub Comp No.", EstimateHeaderRout."Sub Comp No.");
                        Estimateline.SetFilter(Estimateline."No.", '<>%1', '');
                        if Estimateline.FindFirst then begin
                            repeat
                                if (Estimateline.Type = Estimateline.Type::"Work Center") or (Estimateline.Type = Estimateline.Type::"Machine Center") then begin
                                    "routing line".Init;
                                    "routing line"."Routing No." := routing."No.";
                                    "routing line"."Operation No." := Format("Operation No.");
                                    "routing line".Insert(true);
                                    "routing line".Validate("Operation No.");
                                    "Operation No." := "Operation No." + 5;

                                    if Estimateline.Type = 2 then
                                        "routing line".Validate("routing line".Type, 0);
                                    if Estimateline.Type = 3 then
                                        "routing line".Validate("routing line".Type, 1);

                                    "routing line".Validate("routing line"."No.", Estimateline."No.");
                                    "routing line".Validate("routing line".Description, Estimateline.Description);
                                    "routing line".Validate("routing line"."Unit Cost per", Estimateline."Unit Cost");
                                    "routing line".Validate("routing line"."Work Center Group Code", Estimateline."Work Centor Group");
                                    "routing line".Validate("Setup Time", (Estimateline."Setup Time(Min)" / EstimateHeaderRout.Quantity));
                                    "routing line".Validate("Run Time", (Estimateline."Run Time (Min)" / EstimateHeaderRout.Quantity));
                                    "routing line"."Die Cut Ups" := Estimateline."Die Cut Ups";
                                    "routing line"."No of Joints" := Estimateline."No of Joints";
                                    // Lines updated bY Deepak KUmar 23 11 15
                                    "routing line"."Estimate Type" := Estimateline."Product Design Type";
                                    "routing line"."Estimation No." := Estimateline."Product Design No.";
                                    "routing line"."Sub Comp No." := Estimateline."Sub Comp No.";

                                    if "routing line"."Operation No." = '10' then begin
                                        EstimateLinkCode.Reset;
                                        EstimateLinkCode.SetRange(EstimateLinkCode.Default, true);
                                        if EstimateLinkCode.FindFirst then begin
                                            EstimateLinkCode.TestField(EstimateLinkCode."Routing Link Code");
                                            "routing line"."Routing Link Code" := EstimateLinkCode."Routing Link Code";
                                        end;
                                    end;

                                    "routing line".Modify(true);
                                end;
                            until Estimateline.Next = 0;
                        end;

                        routing.Validate(Status, routing.Status::Certified);
                        routing.Modify(true);
                    end;
                end;
                // Update Item Details
                ItemTable."Model No" := EstimateHeaderRout."Model No";
                ItemTable."Model Description" := EstimateHeaderRout."Model Description";
                ItemTable."No. of Ply" := EstimateHeaderRout."No. of Ply";
                ItemTable."Flute Type" := EstimateHeaderRout."Flute Type";
                ItemTable."Color Code" := EstimateHeaderRout."Top Colour";
                ItemTable."Flute 1" := EstimateHeaderRout."Flute 1";
                ItemTable."Flute 2" := EstimateHeaderRout."Flute 2";
                ItemTable."Flute 3" := EstimateHeaderRout."Flute 3";
                ItemTable."Board Length" := EstimateHeaderRout."Board Length (mm)- L";
                ItemTable."Board Width" := EstimateHeaderRout."Board Width (mm)- W";

                ItemTable."Estimate No." := EstimateHeaderRout."Product Design No.";

                ItemTable.Blocked := false;
                ItemTable.Modify(true);

            end;
            ;
        end;
    end;

    procedure CreateSubJob(var EstimateNo: Code[50])
    var
        EstimateHeaderM: Record "Product Design Header";
    begin
        // Lines added BY Deepak Kumar

        EstimateHeaderM.Reset;
        EstimateHeaderM.SetRange(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design Type"::Main);
        EstimateHeaderM.SetRange(EstimateHeaderM."Product Design No.", EstimateNo);
        if EstimateHeaderM.FindFirst then begin
            EstimateHeaderM.TestField(EstimateHeaderM."Item Code");
            ItemMaster.Get(EstimateHeaderM."Item Code");
            ItemMaster.TestField(ItemMaster."Marked For Enq/Quote", false);
            ProgressWindow.Open('#1##############');
            ProgressWindow.Update(1, 'Creating Component Item');
            CreateComponentItem(EstimateHeaderM."Product Design No.");
            ProgressWindow.Update(1, 'Creating Sub Job Item');
            CreateSubItem(EstimateHeaderM."Product Design Type", EstimateHeaderM."Product Design No.", EstimateHeaderM."Sub Comp No.");
            ProgressWindow.Close;
        end;
    end;

    procedure UpdateSubItem(EstimateHeader: Record "Product Design Header")
    var
        ConsumeProcessFor: Code[50];
        ProcessLinkCode: Record "Material / Process Link Code";
        EstimateComponentTable: Record "Product Design Component Table";
        EstimateComponent: Record "Product Design Component Table";
        MainEstimate1: Record "Product Design Header";
    begin
        // Lines added BY Deepak Kumar
        EstimateComponentTable.Reset;
        EstimateComponentTable.SetRange(EstimateComponentTable."Product Design Type", EstimateHeader."Product Design Type");
        EstimateComponentTable.SetRange(EstimateComponentTable."Product Design No.", EstimateHeader."Product Design No.");
        EstimateComponentTable.SetRange(EstimateComponentTable."Sub Comp No.", EstimateHeader."Sub Comp No.");
        if EstimateComponentTable.FindFirst then begin
            EstimateComponentTable."Die Cut Ups" := EstimateHeader."No. of Die Cut Ups";
            EstimateComponentTable."No of Joints" := EstimateHeader."No. of Joint";
            EstimateComponentTable.Quantity :=
            (EstimateHeader.Quantity / EstimateHeader."No. of Die Cut Ups") * EstimateHeader."No. of Joint";
            EstimateComponentTable.Modify(true);
        end;
    end;
}

