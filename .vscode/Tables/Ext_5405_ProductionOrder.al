tableextension 50043 Ext_ProductionOrder extends "Production Order"
{
    fields
    {
        field(50000; "Production Approval Status"; Option)
        {
            Description = 'Deepak';
            Editable = false;
            OptionCaption = 'Open,Approved';
            OptionMembers = Open,Approved;
        }
        field(50001; "Prod Status"; Option)
        {
            Description = 'Deepak';
            OptionCaption = 'New,In process,Halt,Cancel';
            OptionMembers = New,"In process",Halt,Cancel;
        }
        field(50002; "Sales Order No."; Code[20])
        {
            Description = 'Deepak';
            Editable = true;
            TableRelation = "Sales Header"."No." WHERE ("Document Type" = CONST (Order));

            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                ProdOrderLine.Reset;
                ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "No.");
                if ProdOrderLine.FindFirst then begin
                    repeat
                        ProdOrderLine.Validate("Sales Order No.", "Sales Order No.");
                        ProdOrderLine.Modify(true);
                    until ProdOrderLine.Next = 0;
                end;
                // Lines added by Deepak Kumar
                SalesHeader.Reset;
                SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetRange(SalesHeader."No.", "Sales Order No.");
                if SalesHeader.FindFirst then begin
                    if SalesHeader."Salesperson Code" <> '' then
                        "Salesperson Code" := SalesHeader."Salesperson Code"
                    else
                        "Salesperson Code" := '';
                    Modify(true);
                end;
            end;
        }
        field(50003; "Estimate Code"; Code[10])
        {
            Description = 'Deepak';
        }
        field(50004; "Customer Name"; Text[150])
        {
            Description = 'Deepak';
        }
        field(50005; "Consumption Not Manadatory"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50006; "Prev. Job No."; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50010; "Repeat Job"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50011; "Sales Requested Delivery Date"; Date)
        {
            Description = 'Deepak';
            Editable = true;
        }
        field(50012; "Sales Order Line No."; Integer)
        {
            Description = 'Deepak';
        }
        field(50013; "Flute Type"; Text[10])
        {
            Description = 'Deepak';
        }
        field(50014; "No. of Ply"; Integer)
        {
            Description = 'Deepak';
        }
        field(50015; "Color Code"; Code[20])
        {
            Description = 'Deepak';
        }
        field(50016; "No. of Ups"; Integer)
        {
            Description = 'Deepak';
        }
        field(50018; "Plate Item No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50019; "Plate Item Variant"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD ("Plate Item No."));
        }
        field(50020; "Plate ArtWork Available"; Boolean)
        {
            CalcFormula = Lookup (Item."Artwork Availabe" WHERE ("No." = FIELD ("Plate Item No.")));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "Finished Quantity"; Decimal)
        {
            CalcFormula = Lookup ("Prod. Order Line"."Finished Quantity" WHERE ("Line No." = CONST (10000),
                                                                               "Prod. Order No." = FIELD ("No.")));
            Description = '//Firoz 09-03-2016';
            FieldClass = FlowField;
        }
        field(50022; "Remaining Quantity"; Decimal)
        {
            CalcFormula = Lookup ("Prod. Order Line"."Remaining Quantity" WHERE ("Prod. Order No." = FIELD ("No."),
                                                                                "Line No." = FILTER (10000)));
            Description = '//Firoz 120316';
            FieldClass = FlowField;
        }
        field(50023; "Allowed Extra Consumption"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50024; "Allowed Extra Consumption By"; Text[150])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50100; "Salesperson Code"; Code[10])
        {
            CaptionML = ENU = 'Salesperson Code';
            Description = 'Deepak';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
            end;
        }
        field(50101; "Production Comp Published"; Boolean)
        {
            CalcFormula = Exist ("Prod. Order Component"
            WHERE (Status = CONST (Released),
            "Prod. Order No." = FIELD ("No."),
            Published = CONST (true)));
            Description = '///Deepak';
            FieldClass = FlowField;
        }
        field(50103; "Additional Output Quantity"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity"
            WHERE ("Order Type" = FILTER (Production),
            "Order No." = FIELD ("No."),
            "Additional Output" = CONST (true)));
            Description = '//Deepak';
            FieldClass = FlowField;
        }
        field(60001; "Manual BOM"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Production BOM Header"."No.";
        }
        field(60002; "Manual Routing"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Routing Header"."No.";
        }
        field(60003; "Manual BOM Routing"; Boolean)
        {
            Description = 'Deepak';
        }
        field(60004; Priority; Integer)
        {
            Description = 'Deepak';
        }
        field(60005; Modified; Boolean)
        {
            Description = 'Binay //29.12.15';
        }
        field(60006; "Eliminate in Prod. Schedule"; Boolean)
        {
            Description = '//Deepak';
        }
        field(60007; "Last Production Date"; Date)
        {
            CalcFormula = Max ("Capacity Ledger Entry"."Posting Date" WHERE ("Order No." = FIELD ("No.")));
            FieldClass = FlowField;
        }
        field(60008; "Expected Del. Date"; Date)
        {
        }
        field(60009; "Last Despatch Date"; Date)
        {
            CalcFormula = Max ("Item Ledger Entry"."Posting Date" WHERE ("Prod. Order (Sale)" = FIELD ("No.")));
            FieldClass = FlowField;
        }
        field(60010; "Production Tolerance %"; Decimal)
        {
            CalcFormula = Lookup (Customer."Production Tolerance %" WHERE (Name = FIELD ("Customer Name")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60011; "Schedule No."; Code[20])
        {
            TableRelation = "Production Schedule Line"."Schedule No." where ("Prod. Order No." = field ("No."), Published = const (true));
        }
        field(60012; "Requisition No."; Code[40])
        {
            TableRelation = "Requisition Header"."Requisition No." where ("Schedule Document No." = field ("Schedule No."));
        }

    }
    // keys
    // {
    //     key(Key8; Priority, "Due Date")
    //     {
    //     }
    // }
    var
        "--Samadhan": Boolean;
        UserSetup: Record "User Setup";
        Answer: Boolean;
        Sam001: Label 'Item No %1 %2 not consumed completely, remaining Quantity is %3, first complete the consumption than after change the status.';
        LinNum: Integer;
        ProdOrderLine: Record "Prod. Order Line";

    procedure "--Samadhan--"()
    begin
    end;

    procedure ApprovebyStore(ProductionOrderNo: Code[50]; OrderLineNo: Integer)
    var
        ProductionCompLine: Record "Prod. Order Component";
        PodOrderLine: Record "Prod. Order Line";
        UserSetup: Record "User Setup";
        MfgSetup: Record "Manufacturing Setup";
    begin
        // Lines added By Deepak Kumar
        //19 05 15 // Lines updated for Printing Approval
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Printing User", true);
        if UserSetup.FindFirst then begin
            MfgSetup.Get;
            MfgSetup.TestField(MfgSetup."Duplex Paper Category");
            ProductionCompLine.Reset;
            ProductionCompLine.SetRange(ProductionCompLine.Status, ProductionCompLine.Status::Released);
            ProductionCompLine.SetRange(ProductionCompLine."Prod. Order No.", ProductionOrderNo);
            ProductionCompLine.SetRange(ProductionCompLine."Prod. Order Line No.", OrderLineNo);
            ProductionCompLine.SetFilter(ProductionCompLine."Item Category Code", MfgSetup."Duplex Paper Category");
            ProductionCompLine.SetRange(ProductionCompLine."Schedule Component", false);
            if ProductionCompLine.FindFirst then begin
                repeat
                    ProductionCompLine.TestField(ProductionCompLine."Location Code");
                    ProductionCompLine."Approved by Store" := true;
                    ProductionCompLine.Modify(true);

                until ProductionCompLine.Next = 0;
                // Lines updated by Deepak kUmar
                PodOrderLine.Reset;
                PodOrderLine.SetRange(PodOrderLine.Status, PodOrderLine.Status::Released);
                PodOrderLine.SetRange(PodOrderLine."Prod. Order No.", ProductionOrderNo);
                PodOrderLine.SetRange(PodOrderLine."Line No.", OrderLineNo);
                if PodOrderLine.FindFirst then begin
                    PodOrderLine."Material Approved by Store" := true;
                    PodOrderLine.Modify(true);
                end;
                PublishProductionOrder(ProductionOrderNo, OrderLineNo);
                Message('Complete');
            end;
        end else begin

            ValidateStoreUser;
            MfgSetup.Get;
            MfgSetup.TestField(MfgSetup."Duplex Paper Category");
            ProductionCompLine.Reset;
            ProductionCompLine.SetRange(ProductionCompLine.Status, ProductionCompLine.Status::Released);
            ProductionCompLine.SetRange(ProductionCompLine."Prod. Order No.", ProductionOrderNo);
            ProductionCompLine.SetRange(ProductionCompLine."Prod. Order Line No.", OrderLineNo);
            ProductionCompLine.SetFilter(ProductionCompLine."Item Category Code", '<>%1', MfgSetup."Duplex Paper Category");
            ProductionCompLine.SetRange(ProductionCompLine."Schedule Component", false);
            if ProductionCompLine.FindFirst then begin
                repeat
                    ProductionCompLine.TestField(ProductionCompLine."Location Code");// Deepak 20 03 15
                    ProductionCompLine."Approved by Store" := true;
                    ProductionCompLine.Modify(true);

                until ProductionCompLine.Next = 0;
                // Lines updated by Deepak kUmar
                PodOrderLine.Reset;
                PodOrderLine.SetRange(PodOrderLine.Status, PodOrderLine.Status::Released);
                PodOrderLine.SetRange(PodOrderLine."Prod. Order No.", ProductionOrderNo);
                PodOrderLine.SetRange(PodOrderLine."Line No.", OrderLineNo);
                if PodOrderLine.FindFirst then begin
                    PodOrderLine."Material Approved by Store" := true;
                    PodOrderLine.Modify(true);
                end;
                PublishProductionOrder(ProductionOrderNo, OrderLineNo);

                Message('Complete');
            end;
        end;
    end;

    procedure ApprovebyProduction(ProductionOrderNo: Code[50]; OrderLineNo: Integer)
    var
        ProductionCompLine: Record "Prod. Order Component";
        PodOrderLine: Record "Prod. Order Line";
    begin
        // Lines added By Deepak Kumar
        ValidateProdUser;
        ProductionCompLine.Reset;
        ProductionCompLine.SetRange(ProductionCompLine.Status, ProductionCompLine.Status::Released);
        ProductionCompLine.SetRange(ProductionCompLine."Prod. Order No.", ProductionOrderNo);
        ProductionCompLine.SetRange(ProductionCompLine."Prod. Order Line No.", OrderLineNo);
        ProductionCompLine.SetRange(ProductionCompLine."Schedule Component", false);
        if ProductionCompLine.FindFirst then begin
            repeat
                ProductionCompLine.TestField(ProductionCompLine."Location Code");// Deepak 20 03 15
                ProductionCompLine."Approved by Prod." := true;
                ProductionCompLine.Modify(true);
            until ProductionCompLine.Next = 0;
            // Lines updated by Deepak kUmar
            PodOrderLine.Reset;
            PodOrderLine.SetRange(PodOrderLine.Status, PodOrderLine.Status::Released);
            PodOrderLine.SetRange(PodOrderLine."Prod. Order No.", ProductionOrderNo);
            PodOrderLine.SetRange(PodOrderLine."Line No.", OrderLineNo);
            if PodOrderLine.FindFirst then begin
                PodOrderLine."Material Approved by Prod." := true;
                PodOrderLine.Modify(true);
            end;
            Message('Complete');
            PublishProductionOrder(ProductionOrderNo, OrderLineNo);
        end;
    end;

    procedure PublishProductionOrder(ProductionOrderNo: Code[50]; OrderLineNo: Integer)
    var
        ProductionCompLine: Record "Prod. Order Component";
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
        TempProductionCompLine: Record "Prod. Order Component";
        ProductionCompLineNew: Record "Prod. Order Component";
    begin
        //ValidateProdUser;
        // Lines added By Deepak Kumar
        ProductionCompLine.Reset;
        ProductionCompLine.SetRange(ProductionCompLine.Status, ProductionCompLine.Status::Released);
        ProductionCompLine.SetRange(ProductionCompLine."Prod. Order No.", ProductionOrderNo);
        ProductionCompLine.SetRange(ProductionCompLine."Prod. Order Line No.", OrderLineNo);
        ProductionCompLine.SetRange(ProductionCompLine."Schedule Component", false);
        if ProductionCompLine.FindFirst then begin
            repeat
                //     ProductionCompLine.TESTFIELD(ProductionCompLine."Approved by Store");
                //     ProductionCompLine.TESTFIELD(ProductionCompLine."Approved by Prod.");

                if (ProductionCompLine."Approved by Store" = true) and (ProductionCompLine."Approved by Prod." = true) then begin
                    // Lines added BY Deepak Kumar
                    ProductionCompLine.CalcFields(ProductionCompLine."Act. Consumption (Qty)");
                    if ProductionCompLine."Act. Consumption (Qty)" = 0 then begin
                        if (ProductionCompLine."Alternative item by Prod." <> '') then begin
                            ProductionCompLine."Previous Item No" := ProductionCompLine."Item No.";
                            ProductionCompLine."Previous Item Description" := ProductionCompLine.Description;
                            ProductionCompLine.Validate("Item No.", ProductionCompLine."Alternative item by Prod.");
                        end;
                        if (ProductionCompLine."Alternative item by Prod." = '') and (ProductionCompLine."Alternative item by Store" <> '') then begin
                            ProductionCompLine."Previous Item No" := ProductionCompLine."Item No.";
                            ProductionCompLine."Previous Item Description" := ProductionCompLine.Description;
                            ProductionCompLine.Validate("Item No.", ProductionCompLine."Alternative item by Store");
                        end;
                        ProductionCompLine.Published := true;
                        ProductionCompLine."Published by" := UserId;
                        ProductionCompLine.Modify(true);
                    end else begin
                        if (ProductionCompLine."Remaining Quantity" <> 0) and (ProductionCompLine."Alternative item by Store" <> '') or (ProductionCompLine."Alternative item by Prod." <> '') then begin
                            ProductionCompLineNew.Init;     //Mpower
                            ProductionCompLineNew := ProductionCompLine;
                            ProductionCompLineNew."Line No." := ProductionCompLine."Line No." + 1000;
                            ProductionCompLineNew."Substitute Item" := true;
                            ProductionCompLineNew."Expected Quantity" := ProductionCompLine."Remaining Quantity";
                            ProductionCompLineNew."Remaining Quantity" := ProductionCompLine."Remaining Quantity";
                            ProductionCompLineNew."Expected Qty. (Base)" := ProductionCompLine."Remaining Quantity";
                            ProductionCompLineNew."Remaining Qty. (Base)" := ProductionCompLine."Remaining Quantity";
                            ProductionCompLineNew.Insert(true);
                            ProductionCompLine.Blocked := true;
                            ProductionCompLine."Remaining Quantity" := 0;
                            ProductionCompLine.Modify(true);

                            if (ProductionCompLine."Alternative item by Prod." <> '') then begin
                                ProductionCompLineNew."Previous Item No" := ProductionCompLine."Item No.";
                                ProductionCompLineNew."Previous Item Description" := ProductionCompLine.Description;
                                ProductionCompLineNew.Validate("Item No.", ProductionCompLine."Alternative item by Prod.");
                            end;
                            if (ProductionCompLine."Alternative item by Prod." = '') and (ProductionCompLine."Alternative item by Store" <> '') then begin
                                ProductionCompLineNew."Previous Item No" := ProductionCompLine."Item No.";
                                ProductionCompLineNew."Previous Item Description" := ProductionCompLine.Description;
                                ProductionCompLineNew.Validate("Item No.", ProductionCompLine."Alternative item by Store");
                            end;

                            ProductionCompLineNew.Published := true;
                            ProductionCompLineNew."Published by" := UserId;
                            ProductionCompLineNew.Modify(true);
                        end;
                    end;
                end;
            until ProductionCompLine.Next = 0;
            /*
          // Lines added BY Deepak kUmar// for Update In Production BOM
          ProdOrderLine.RESET;
          ProdOrderLine.SETRANGE(ProdOrderLine.Status,ProdOrderLine.Status::Released);
          ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.",ProductionOrderNo);
          ProdOrderLine.SETRANGE(ProdOrderLine."Line No.",OrderLineNo);
          IF ProdOrderLine.FINDFIRST THEN BEGIN
            ProdBOMHeader.RESET;
            ProdBOMHeader.SETRANGE(ProdBOMHeader."No.",ProdOrderLine."Production BOM No.");
            IF ProdBOMHeader.FINDFIRST THEN BEGIN
              ProdBOMLine.RESET;
              ProdBOMLine.SETRANGE(ProdBOMLine."Production BOM No.",ProdBOMHeader."No.");
              ProdBOMLine.SETRANGE(ProdBOMLine.Type,ProdBOMLine.Type::Item);
              IF ProdBOMLine.FINDFIRST THEN BEGIN
                 ProdBOMHeader.Status:=ProdBOMHeader.Status::"Under Development";
                 ProdBOMHeader.MODIFY(TRUE);

                REPEAT
                  TempProductionCompLine.RESET;
                  TempProductionCompLine.SETRANGE(TempProductionCompLine.Status,TempProductionCompLine.Status::Released);
                  TempProductionCompLine.SETRANGE(TempProductionCompLine."Prod. Order No.",ProductionOrderNo);
                  TempProductionCompLine.SETRANGE(TempProductionCompLine."Prod. Order Line No.",OrderLineNo);
                  TempProductionCompLine.SETRANGE(TempProductionCompLine."Paper Position",ProdBOMLine."Paper Position");
                  IF TempProductionCompLine.FINDFIRST THEN BEGIN
                    IF TempProductionCompLine."Item No." <> ProdBOMLine."No." THEN BEGIN
                      ProdBOMLine.VALIDATE(ProdBOMLine."No.",TempProductionCompLine."Item No.");
                      ProdBOMLine.MODIFY(TRUE);
                    END;
                  END;
                UNTIL ProdBOMLine.NEXT=0;
                ProdBOMHeader.Status:=ProdBOMHeader.Status::Certified;
                ProdBOMHeader.MODIFY(TRUE);
              END;
            END;
          END;*/

        end;

    end;

    procedure ValidateStoreUser()
    begin
        // Lines added BY Deepak kUmar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Store User", true);
        if not UserSetup.FindFirst then
            Error('You are not authorized user, Please contact your system Administrator');
    end;

    procedure ValidateProdUser()
    begin
        // Lines added BY Deepak kUmar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Production User", true);
        if not UserSetup.FindFirst then
            Error('You are not authorized user, Please contact your system Administrator');
    end;

    procedure ApproveProductionOrder(ProductionOrderNo: Code[50])
    var
        ProductionOrder: Record "Production Order";
    begin
        // Lines added By Deepak Kumar
        ProductionOrder.Reset;
        ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
        ProductionOrder.SetRange(ProductionOrder."No.", ProductionOrderNo);
        if ProductionOrder.FindFirst then begin
            UserSetup.Reset;
            UserSetup.SetRange(UserSetup."User ID", UserId);
            UserSetup.SetRange(UserSetup."RPO Approver", true);
            if UserSetup.FindFirst then begin

                Answer := DIALOG.Confirm('Do you want to approve the Production Order', true, ProductionOrderNo);
                if Answer = true then begin
                    ProductionOrder.Blocked := false;
                    ProductionOrder."Production Approval Status" := ProductionOrder."Production Approval Status"::Approved;
                    ProductionOrder.Modify(true);
                    Message('The Prod. Order Status is Now %1', ProductionOrder."Production Approval Status");
                end;

            end else begin
                Error('You are not authorized user, Please contact your system Administrator');
            end;
        end;
    end;

    procedure OpenProdOrder(ProductionOrderNo: Code[50])
    var
        ProductionOrder: Record "Production Order";
    begin
        // Lines added BY Deepak Kumar
        ProductionOrder.Reset;
        ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
        ProductionOrder.SetRange(ProductionOrder."No.", ProductionOrderNo);
        if ProductionOrder.FindFirst then begin
            UserSetup.Reset;
            UserSetup.SetRange(UserSetup."User ID", UserId);
            UserSetup.SetRange(UserSetup."RPO Approver", true);
            if UserSetup.FindFirst then begin

                Answer := DIALOG.Confirm('Do you want to Open the Production Order', true, ProductionOrderNo);
                if Answer = true then begin
                    ProductionOrder.Blocked := true;
                    ProductionOrder."Production Approval Status" := ProductionOrder."Production Approval Status"::Open;
                    ProductionOrder.Modify(true);
                    Message('The Prod. Order Status is Now %1', ProductionOrder."Production Approval Status");
                end;

            end else begin
                Error('You are not authorized user, Please contact your system Administrator');
            end;
        end;
    end;

    procedure ApprovebyStoreConfirmSch(ProductionOrderNo: Code[50]; OrderLineNo: Integer)
    var
        ProductionCompLine: Record "Prod. Order Component";
        PodOrderLine: Record "Prod. Order Line";
        UserSetup: Record "User Setup";
        MfgSetup: Record "Manufacturing Setup";
        ProdOrder: Record "Production Order";
        ProdScheduleLine: Record "Production Schedule Line";
    begin
        // Lines added By Deepak Kumar
        //19 05 15 // Lines updated for Printing Approval
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Printing User", true);
        if UserSetup.FindFirst then begin
            MfgSetup.Get;
            MfgSetup.TestField(MfgSetup."Duplex Paper Category");
            ProductionCompLine.Reset;
            ProductionCompLine.SetRange(ProductionCompLine.Status, ProductionCompLine.Status::Released);
            ProductionCompLine.SetRange(ProductionCompLine."Prod. Order No.", ProductionOrderNo);
            ProductionCompLine.SetRange(ProductionCompLine."Prod. Order Line No.", OrderLineNo);
            ProductionCompLine.SetFilter(ProductionCompLine."Item Category Code", MfgSetup."Duplex Paper Category");
            ProductionCompLine.SetRange(ProductionCompLine."Schedule Component", false);
            if ProductionCompLine.FindFirst then begin
                repeat
                    ProductionCompLine.TestField(ProductionCompLine."Location Code");
                    ProductionCompLine."Approved by Store" := true;
                    ProductionCompLine.Modify(true);

                until ProductionCompLine.Next = 0;
                // Lines updated by Deepak kUmar
                PodOrderLine.Reset;
                PodOrderLine.SetRange(PodOrderLine.Status, PodOrderLine.Status::Released);
                PodOrderLine.SetRange(PodOrderLine."Prod. Order No.", ProductionOrderNo);
                PodOrderLine.SetRange(PodOrderLine."Line No.", OrderLineNo);
                if PodOrderLine.FindFirst then begin
                    ProdOrder.GET(Status::Released, ProductionOrderNo);
                    ProdOrder.TestField("Schedule No.");
                    ProdOrder.TestField("Requisition No.");
                    ProdScheduleLine.Reset;
                    ProdScheduleLine.SetRange("Schedule No.", ProdOrder."Schedule No.");
                    ProdScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
                    ProdScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
                    IF NOT FindFirst then
                        Error('There is no %1 job in Schedule No. %2 enter on updated comp. page', ProductionOrderNo, ProdOrder."Schedule No.");
                    PodOrderLine."Material Approved by Store" := true;
                    PodOrderLine.Modify(true);
                end;
                //PublishProductionOrder(ProductionOrderNo, OrderLineNo);
                Message('Complete');
            end;
        end else begin

            ValidateStoreUser;
            MfgSetup.Get;
            MfgSetup.TestField(MfgSetup."Duplex Paper Category");
            ProductionCompLine.Reset;
            ProductionCompLine.SetRange(ProductionCompLine.Status, ProductionCompLine.Status::Released);
            ProductionCompLine.SetRange(ProductionCompLine."Prod. Order No.", ProductionOrderNo);
            ProductionCompLine.SetRange(ProductionCompLine."Prod. Order Line No.", OrderLineNo);
            ProductionCompLine.SetFilter(ProductionCompLine."Item Category Code", '<>%1', MfgSetup."Duplex Paper Category");
            ProductionCompLine.SetRange(ProductionCompLine."Schedule Component", false);
            if ProductionCompLine.FindFirst then begin
                repeat
                    ProductionCompLine.TestField(ProductionCompLine."Location Code");// Deepak 20 03 15
                    ProductionCompLine."Approved by Store" := true;
                    ProductionCompLine.Modify(true);

                until ProductionCompLine.Next = 0;
                // Lines updated by Deepak kUmar
                PodOrderLine.Reset;
                PodOrderLine.SetRange(PodOrderLine.Status, PodOrderLine.Status::Released);
                PodOrderLine.SetRange(PodOrderLine."Prod. Order No.", ProductionOrderNo);
                PodOrderLine.SetRange(PodOrderLine."Line No.", OrderLineNo);
                if PodOrderLine.FindFirst then begin
                    ProdOrder.GET(Status::Released, ProductionOrderNo);
                    ProdOrder.TestField("Schedule No.");
                    ProdOrder.TestField("Requisition No.");
                    ProdScheduleLine.Reset;
                    ProdScheduleLine.SetRange("Schedule No.", ProdOrder."Schedule No.");
                    ProdScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
                    ProdScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
                    IF NOT FindFirst then
                        Error('There is no %1 job in Schedule No. %2 enter on updated comp. page', ProductionOrderNo, ProdOrder."Schedule No.");
                    PodOrderLine."Material Approved by Store" := true;
                    PodOrderLine.Modify(true);
                end;
                //  PublishProductionOrder(ProductionOrderNo, OrderLineNo);

                Message('Complete');
            end;
        end;
    end;

    procedure ApprovebyProductionConfirmSch(ProductionOrderNo: Code[50]; OrderLineNo: Integer)
    var
        ProductionCompLine: Record "Prod. Order Component";
        PodOrderLine: Record "Prod. Order Line";
        ProdOrder: Record "Production Order";
        ProdScheduleLine: Record "Production Schedule Line";
    begin
        // Lines added By Deepak Kumar
        ValidateProdUser;
        ProductionCompLine.Reset;
        ProductionCompLine.SetRange(ProductionCompLine.Status, ProductionCompLine.Status::Released);
        ProductionCompLine.SetRange(ProductionCompLine."Prod. Order No.", ProductionOrderNo);
        ProductionCompLine.SetRange(ProductionCompLine."Prod. Order Line No.", OrderLineNo);
        ProductionCompLine.SetRange(ProductionCompLine."Schedule Component", false);
        if ProductionCompLine.FindFirst then begin
            repeat
                ProductionCompLine.TestField(ProductionCompLine."Location Code");// Deepak 20 03 15
                ProductionCompLine."Approved by Prod." := true;
                ProductionCompLine.Modify(true);
            until ProductionCompLine.Next = 0;
            // Lines updated by Deepak kUmar
            PodOrderLine.Reset;
            PodOrderLine.SetRange(PodOrderLine.Status, PodOrderLine.Status::Released);
            PodOrderLine.SetRange(PodOrderLine."Prod. Order No.", ProductionOrderNo);
            PodOrderLine.SetRange(PodOrderLine."Line No.", OrderLineNo);
            if PodOrderLine.FindFirst then begin
                ProdOrder.GET(Status::Released, ProductionOrderNo);
                ProdOrder.TestField("Schedule No.");
                ProdOrder.TestField("Requisition No.");
                ProdScheduleLine.Reset;
                ProdScheduleLine.SetRange("Schedule No.", ProdOrder."Schedule No.");
                ProdScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
                ProdScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
                IF NOT FindFirst then
                    Error('There is no %1 job in Schedule No. %2 enter on updated comp. page', ProductionOrderNo, ProdOrder."Schedule No.");
                PodOrderLine."Material Approved by Prod." := true;
                PodOrderLine.Modify(true);
            end;
            //Message('Complete');
            PublishProductionOrderConfirmSch(ProductionOrderNo, OrderLineNo, ProdOrder."Schedule No.", ProdOrder."Requisition No.");
        end;
    end;

    procedure PublishProductionOrderConfirmSch(ProductionOrderNo: Code[50]; OrderLineNo: Integer; SchdeuleNum: Code[20]; RequisitionNum: code[40])
    var
        ProductionCompLine: Record "Prod. Order Component";
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
        TempProductionCompLine: Record "Prod. Order Component";
        ProductionCompLineNew: Record "Prod. Order Component";
        ProdScheduleLine: Record "Production Schedule Line";
        ProductionCompLineScheduled: Record "Prod. Order Component";
    begin
        //ValidateProdUser;
        // Lines added By Deepak Kumar
        ProductionCompLine.Reset;
        ProductionCompLine.SetRange(ProductionCompLine.Status, ProductionCompLine.Status::Released);
        ProductionCompLine.SetRange(ProductionCompLine."Prod. Order No.", ProductionOrderNo);
        ProductionCompLine.SetRange(ProductionCompLine."Prod. Order Line No.", OrderLineNo);
        ProductionCompLine.SetRange(ProductionCompLine."Schedule Component", false);
        if ProductionCompLine.FindFirst then begin
            repeat
                //     ProductionCompLine.TESTFIELD(ProductionCompLine."Approved by Store");
                //     ProductionCompLine.TESTFIELD(ProductionCompLine."Approved by Prod.");

                if (ProductionCompLine."Approved by Store" = true) and (ProductionCompLine."Approved by Prod." = true) then begin
                    // Lines added BY Deepak Kumar
                    ProductionCompLine.CalcFields(ProductionCompLine."Act. Consumption (Qty)");
                    if ProductionCompLine."Act. Consumption (Qty)" = 0 then begin
                        if (ProductionCompLine."Alternative item by Prod." <> '') then begin
                            ProductionCompLine."Previous Item No" := ProductionCompLine."Item No.";
                            ProductionCompLine."Previous Item Description" := ProductionCompLine.Description;
                            ProductionCompLine.Validate("Item No.", ProductionCompLine."Alternative item by Prod.");
                        end;
                        if (ProductionCompLine."Alternative item by Prod." = '') and (ProductionCompLine."Alternative item by Store" <> '') then begin
                            ProductionCompLine."Previous Item No" := ProductionCompLine."Item No.";
                            ProductionCompLine."Previous Item Description" := ProductionCompLine.Description;
                            ProductionCompLine.Validate("Item No.", ProductionCompLine."Alternative item by Store");
                        end;
                        ProductionCompLine.Published := true;
                        ProductionCompLine."Published by" := UserId;
                        ProductionCompLine.Modify(true);
                    end else begin
                        if (ProductionCompLine."Remaining Quantity" <> 0) and (ProductionCompLine."Alternative item by Store" <> '') or (ProductionCompLine."Alternative item by Prod." <> '') then begin
                            ProductionCompLineNew.Init;     //Mpower
                            ProductionCompLineNew := ProductionCompLine;
                            ProductionCompLineNew."Line No." := ProductionCompLine."Line No." + 1000;
                            ProductionCompLineNew."Substitute Item" := true;
                            ProductionCompLineNew."Expected Quantity" := ProductionCompLine."Remaining Quantity";
                            ProductionCompLineNew."Remaining Quantity" := ProductionCompLine."Remaining Quantity";
                            ProductionCompLineNew."Expected Qty. (Base)" := ProductionCompLine."Remaining Quantity";
                            ProductionCompLineNew."Remaining Qty. (Base)" := ProductionCompLine."Remaining Quantity";
                            ProductionCompLineNew.Insert(true);
                            ProductionCompLineScheduled.Reset();
                            ProductionCompLineScheduled.SetRange(Status, ProductionCompLine.Status::Released);
                            ProductionCompLineScheduled.SetRange("Prod. Order No.", ProductionOrderNo);
                            ProductionCompLineScheduled.SetRange("Prod. Order Line No.", OrderLineNo);
                            ProductionCompLineScheduled.SetRange("Prod Schedule No.", SchdeuleNum);
                            IF ProductionCompLineScheduled.FindSet then begin
                                ProductionCompLineScheduled."Remaining Qty. (Base)" := 0;
                                ProductionCompLineScheduled."Remaining Quantity" := 0;
                                ProductionCompLineScheduled.Modify(true);
                            end;
                            /*
                            ProductionCompLine.Blocked := true;
                            ProductionCompLine."Remaining Quantity" := 0;
                            ProductionCompLine.Modify(true);
                            */

                            if (ProductionCompLine."Alternative item by Prod." <> '') then begin
                                ProductionCompLineNew."Previous Item No" := ProductionCompLine."Item No.";
                                ProductionCompLineNew."Previous Item Description" := ProductionCompLine.Description;
                                ProductionCompLineNew.Validate("Item No.", ProductionCompLine."Alternative item by Prod.");
                            end;
                            if (ProductionCompLine."Alternative item by Prod." = '') and (ProductionCompLine."Alternative item by Store" <> '') then begin
                                ProductionCompLineNew."Previous Item No" := ProductionCompLine."Item No.";
                                ProductionCompLineNew."Previous Item Description" := ProductionCompLine.Description;
                                ProductionCompLineNew.Validate("Item No.", ProductionCompLine."Alternative item by Store");
                            end;

                            ProductionCompLineNew.Published := true;
                            ProductionCompLineNew."Published by" := UserId;
                            ProductionCompLineNew.Modify(true);
                        end;
                    end;
                end;
            until ProductionCompLine.Next = 0;
            Commit();
            ProdScheduleLine.Reset();
            ProdScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
            ProdScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
            ProdScheduleLine.SetRange("Schedule No.", SchdeuleNum);
            ProdScheduleLine.SetRange(Published, true);
            IF ProdScheduleLine.FindSet then begin
                UpdateGSMIdentifier(ProductionOrderNo, OrderLineNo, SchdeuleNum);
                ClacUpsDeckleLength(ProductionOrderNo, OrderLineNo, SchdeuleNum);
                CreateScheduleWiseReqQty(ProductionOrderNo, OrderLineNo, SchdeuleNum);
                ManualAssortment(ProductionOrderNo, OrderLineNo, SchdeuleNum);
                GenerateQtyLineMannualAsortment(ProductionOrderNo, OrderLineNo, SchdeuleNum);
                UpdateExistingSchedule(ProductionOrderNo, OrderLineNo, SchdeuleNum);
                UpdateScheduleItem(SchdeuleNum, RequisitionNum);
            end;
        end;
    end;

    procedure UpdateGSMIdentifier(ProductionOrderNo: Code[50]; OrderLineNo: Integer; ScheduleDocNum: code[20])
    var
        TempGSMTypeIdentifier: Code[200];
        TempDeckleSize: Decimal;
        ProductionScheduleLine: Record "Production Schedule Line";
        ProdOrderCompLine: Record "Prod. Order Component";
        ItemMaster: Record Item;
        ProdOrderLine: Record "Prod. Order Line";
    begin
        // Lines added By Deepak Kumar        
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
        ProductionScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
        ProductionScheduleLine.SetRange("Schedule No.", ScheduleDocNum);
        ProductionScheduleLine.SETRANGE("Schedule Line", TRUE);
        ProductionScheduleLine.SETRANGE(Published, TRUE);
        ProductionScheduleLine.SETRANGE("Schedule Closed", FALSE);
        ProductionScheduleLine.SetRange("Marked for Publication", true);
        //ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
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

    procedure ClacUpsDeckleLength(ProductionOrderNo: Code[50]; OrderLineNo: Integer; ScheduleDocNum: code[20])
    var
        TempBoardUps: Integer;
        TempExtraTrim: Decimal;
        ProductionScheduleLine: Record "Production Schedule Line";
        ScheduleHeader: Record "Production Schedule";
    begin
        // Lines added BY Deepak kumar
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
        ProductionScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
        ProductionScheduleLine.SetRange("Schedule No.", ScheduleDocNum);
        ProductionScheduleLine.SETRANGE("Schedule Line", TRUE);
        ProductionScheduleLine.SETRANGE(Published, TRUE);
        ProductionScheduleLine.SETRANGE("Schedule Closed", FALSE);
        ProductionScheduleLine.SetRange("Marked for Publication", true);
        //ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleHeader."Schedule No.");
        if ProductionScheduleLine.FindFirst then begin
            repeat
                TempBoardUps := 0;
                ScheduleHeader.Get(ProductionScheduleLine."Schedule No.");
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

    procedure CreateScheduleWiseReqQty(ProductionOrderNo: Code[50]; OrderLineNo: Integer; ScheduleDocNum: code[20])
    var
        BaseTableDeckle: Record "Schedule Base Table 1";
        //PaperTypeBaseTable: Record "Schedule Base Table 2";
        PaserGSMBaseTable: Record "Schedule Base Table 3";
        ProductionScheduleLine: Record "Production Schedule Line";
        ProdOrderCompLine: Record "Prod. Order Component";
        ItemMaster: Record Item;
    begin
        // Lines added by deepak Kumar
        PaserGSMBaseTable.Reset;
        PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Schedule Component List", true);
        PaserGSMBaseTable.SetRange("Prod. Order Number", ProductionOrderNo);
        PaserGSMBaseTable.SetRange("Prod. Order Line No.", OrderLineNo);
        if PaserGSMBaseTable.FindSet then
            PaserGSMBaseTable.DeleteAll(true);

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Closed", false);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        ProductionScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
        ProductionScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
        ProductionScheduleLine.SetRange("Schedule No.", ScheduleDocNum);
        ProductionScheduleLine.SETRANGE("Schedule Line", TRUE);
        ProductionScheduleLine.SETRANGE(Published, TRUE);
        ProductionScheduleLine.SETRANGE("Schedule Closed", FALSE);
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

    procedure ManualAssortment(ProductionOrderNo: Code[50]; OrderLineNo: Integer; ScheduleDocNum: code[20])
    var
        Answer: Boolean;
        TempBoardUps: Integer;
        ProductDesignHeader: Record "Product Design Header";
        ProdOrderLine: Record "Prod. Order Line";
        TempDesignTrim: Decimal;
        ProductionScheduleLine: Record "Production Schedule Line";
        ScheduleHeader: Record "Production Schedule";
        ProdOrderCompLine: Record "Prod. Order Component";
        ItemMaster: Record Item;
        ExtraTrimActual: Decimal;
    begin
        //Update Schedule Line

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
        ProductionScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
        ProductionScheduleLine.SetRange("Schedule No.", ScheduleDocNum);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        ProductionScheduleLine.SetRange(Published, true);
        if ProductionScheduleLine.FindFirst then begin
            repeat
                TempBoardUps := 0;
                TempDesignTrim := 0;
                ScheduleHeader.Get(ProductionScheduleLine."Schedule No.");
                if ScheduleHeader."Trim Calculation Type" = ScheduleHeader."Trim Calculation Type"::"Product Design" then begin

                    if ProductionScheduleLine."Board Width(mm)" <> 0 then
                        TempBoardUps := Round(((ProductionScheduleLine."Planned Deckle Size(mm)" - ProductionScheduleLine."Trim Product Design") / ProductionScheduleLine."Board Width(mm)"), 1, '<');

                    if TempBoardUps > ScheduleHeader."Machine Max Ups" then begin
                        ProductionScheduleLine."Calculated No. of Ups" := ScheduleHeader."Machine Max Ups";
                    end else begin
                        ProductionScheduleLine."Calculated No. of Ups" := TempBoardUps;
                    end;
                    if ProductionScheduleLine."Calculated No. of Ups" = 0 then
                        ProductionScheduleLine."Calculated No. of Ups" := 1;
                    ProductionScheduleLine."Linear Length(Mtr)" := ((ProductionScheduleLine."Quantity To Schedule" * ProductionScheduleLine."Board Length(mm)") / ProductionScheduleLine."Calculated No. of Ups") / 1000;
                    ProductionScheduleLine."Qty to Schedule Net Weight" := ((ProductionScheduleLine."Board Length(mm)" * ProductionScheduleLine."Board Width(mm)"
                               * ProductionScheduleLine."FG GSM") / 1000000000) * ProductionScheduleLine."Quantity To Schedule";
                    ProductionScheduleLine."Qty to Schedule M2 Weight" := ((ProductionScheduleLine."Board Length(mm)" * ProductionScheduleLine."Board Width(mm)") / 1000000) * ProductionScheduleLine."Quantity To Schedule";


                    ProductionScheduleLine."Extra Trim(mm)" := (ProductionScheduleLine."Planned Deckle Size(mm)" -
                    ProductionScheduleLine."Trim Product Design") - ((ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups"));
                    ProductionScheduleLine."Trim %" := (ProductionScheduleLine."Extra Trim(mm)" / ProductionScheduleLine."Planned Deckle Size(mm)") * 100;

                    ProductionScheduleLine."Trim (mm)" := (ProductionScheduleLine."Planned Deckle Size(mm)" - ((ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups")));
                    ProductionScheduleLine."Trim Weight" := (((ProductionScheduleLine."Trim (mm)" * ProductionScheduleLine."Cut Size (mm)" * ProductionScheduleLine."FG GSM") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                    ProductionScheduleLine."Extra Trim Weight" := (((ProductionScheduleLine."Extra Trim(mm)" * ProductionScheduleLine."Cut Size (mm)" * ProductionScheduleLine."FG GSM") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                    //Mpower 30 Jul 2019--
                    ProdOrderCompLine.Reset;
                    ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
                    ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                    ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                    ProdOrderCompLine.SetRange(ProdOrderCompLine."Schedule Component", false);
                    if ProdOrderCompLine.FindFirst then begin
                        ProductionScheduleLine."Extra Trim Actual" := 0;
                        ProductionScheduleLine."Extra Trim Wt. Actual" := 0;
                        repeat
                            Clear(ExtraTrimActual);
                            ItemMaster.Get(ProdOrderCompLine."Item No.");
                            ExtraTrimActual := (ItemMaster."Deckle Size (mm)" -
                            ProductionScheduleLine."Trim Product Design") - ((ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups"));
                            ProductionScheduleLine."Extra Trim Actual" += ExtraTrimActual;
                            ProductionScheduleLine."Extra Trim Wt. Actual" += (((ExtraTrimActual * ProductionScheduleLine."Cut Size (mm)" * ItemMaster."Paper GSM" * ProdOrderCompLine."Take Up") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                        until ProdOrderCompLine.Next = 0;
                    end;
                    //Mpower 30 Jul 2019++

                end else begin
                    if ProductionScheduleLine."Board Width(mm)" <> 0 then
                        TempBoardUps := Round(((ProductionScheduleLine."Planned Deckle Size(mm)" - ScheduleHeader."Min Trim") / ProductionScheduleLine."Board Width(mm)"), 1, '<');

                    if TempBoardUps > ScheduleHeader."Machine Max Ups" then begin
                        ProductionScheduleLine."Calculated No. of Ups" := ScheduleHeader."Machine Max Ups";
                    end else begin
                        ProductionScheduleLine."Calculated No. of Ups" := TempBoardUps;
                    end;
                    ProductionScheduleLine."Linear Length(Mtr)" := ((ProductionScheduleLine."Quantity To Schedule" * ProductionScheduleLine."Board Length(mm)") / ProductionScheduleLine."Calculated No. of Ups") / 1000;
                    ProductionScheduleLine."Qty to Schedule Net Weight" := ((ProductionScheduleLine."Board Length(mm)" * ProductionScheduleLine."Board Width(mm)"
                               * ProductionScheduleLine."FG GSM") / 1000000000) * ProductionScheduleLine."Quantity To Schedule";
                    ProductionScheduleLine."Qty to Schedule M2 Weight" := ((ProductionScheduleLine."Board Length(mm)" * ProductionScheduleLine."Board Width(mm)") / 1000000) * ProductionScheduleLine."Quantity To Schedule";

                    ProductionScheduleLine."Extra Trim(mm)" := (ProductionScheduleLine."Planned Deckle Size(mm)" - ScheduleHeader."Min Trim") - ((ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups"));
                    ProductionScheduleLine."Trim %" := (ProductionScheduleLine."Extra Trim(mm)" / ProductionScheduleLine."Planned Deckle Size(mm)") * 100;
                    ProductionScheduleLine."Trim (mm)" := (ProductionScheduleLine."Planned Deckle Size(mm)" - ((ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups")));
                    ProductionScheduleLine."Trim Weight" := (((ProductionScheduleLine."Trim (mm)" * ProductionScheduleLine."Cut Size (mm)" * ProductionScheduleLine."FG GSM") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                    ProductionScheduleLine."Extra Trim Weight" := (((ProductionScheduleLine."Extra Trim(mm)" * ProductionScheduleLine."Cut Size (mm)" * ProductionScheduleLine."FG GSM") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                    //Mpower 30 Jul 2019--
                    ProdOrderCompLine.Reset;
                    ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
                    ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                    ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                    ProdOrderCompLine.SetRange(ProdOrderCompLine."Schedule Component", false);
                    if ProdOrderCompLine.FindFirst then begin
                        ProductionScheduleLine."Extra Trim Actual" := 0;
                        ProductionScheduleLine."Extra Trim Wt. Actual" := 0;
                        repeat
                            Clear(ExtraTrimActual);
                            ItemMaster.Get(ProdOrderCompLine."Item No.");
                            ExtraTrimActual := (ItemMaster."Deckle Size (mm)" -
                            ProductionScheduleLine."Trim Product Design") - ((ProductionScheduleLine."Board Width(mm)" * ProductionScheduleLine."Calculated No. of Ups"));
                            ProductionScheduleLine."Extra Trim Actual" += ExtraTrimActual;
                            ProductionScheduleLine."Extra Trim Wt. Actual" += (((ExtraTrimActual * ProductionScheduleLine."Cut Size (mm)" * ItemMaster."Paper GSM" * ProdOrderCompLine."Take Up") / (1000000000)) * ProductionScheduleLine."Quantity To Schedule");
                        until ProdOrderCompLine.Next = 0;
                    end;
                    //Mpower 30 Jul 2019++
                end;
                ProductionScheduleLine.Modify(true);

                ProductionScheduleLine.RENAME(ProductionScheduleLine."Schedule No.", ProductionScheduleLine."Prod. Order No.", ProductionScheduleLine."Prod. Order Line No."
                , ProductionScheduleLine."Planned Deckle Size(mm)", ProductionScheduleLine."Schedule Line");

            until ProductionScheduleLine.Next = 0;
        end;
    end;


    procedure GenerateQtyLineMannualAsortment(ProductionOrderNo: Code[50]; OrderLineNo: Integer; ScheduleDocNum: code[20])
    var
        BaseTableDeckle: Record "Schedule Base Table 1";
        BaseTableDeckle1: Record "Schedule Base Table 1";
        PaserGSMBaseTable: Record "Schedule Base Table 3";
        TempDeckleSize: Code[20];
        ProductionScheduleLine: Record "Production Schedule Line";
        ProdOrderCompLine: Record "Prod. Order Component";
        ItemMaster: Record Item;
    begin
        // Lines added by deepak Kumar
        BaseTableDeckle.Reset;
        BaseTableDeckle.SetRange("Schedule No.", ScheduleDocNum);
        if BaseTableDeckle.FindSet then
            BaseTableDeckle.DeleteAll(true);

        PaserGSMBaseTable.Reset;
        PaserGSMBaseTable.SetRange("Prod. Order Number", ProductionOrderNo);
        PaserGSMBaseTable.SetRange("Prod. Order Line No.", OrderLineNo);
        if PaserGSMBaseTable.FindSet then
            PaserGSMBaseTable.DeleteAll(true);

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
        ProductionScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
        ProductionScheduleLine.SetRange("Schedule No.", ScheduleDocNum);
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
                    BaseTableDeckle."Prod. Order Number" := ProductionScheduleLine."Prod. Order No.";
                    BaseTableDeckle."Prod. Order Line No." := ProductionScheduleLine."Prod. Order Line No.";
                    BaseTableDeckle.Insert(true);
                    TempDeckleSize := ProductionScheduleLine."Deckle Size Schedule(mm)";
                end;
            until ProductionScheduleLine.Next = 0;
        end;


        BaseTableDeckle1.Reset;
        BaseTableDeckle1.SetRange("Schedule No.", ScheduleDocNum);
        if BaseTableDeckle1.FindFirst then begin
            repeat
                ProductionScheduleLine.Reset;
                ProductionScheduleLine.SetRange("Prod. Order No.", BaseTableDeckle1."Prod. Order Number");
                ProductionScheduleLine.SetRange("Prod. Order Line No.", BaseTableDeckle1."Prod. Order Line No.");
                ProductionScheduleLine.SetRange("Schedule No.", ScheduleDocNum);
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Deckle Size Schedule(mm)", BaseTableDeckle1."Deckle Size");
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

                                // Update Paper GSM
                                PaserGSMBaseTable.Reset;
                                PaserGSMBaseTable.SetRange("Prod. Order Number", BaseTableDeckle1."Prod. Order Number");
                                PaserGSMBaseTable.SetRange("Prod. Order Line No.", BaseTableDeckle1."Prod. Order Line No.");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Deckle Size", BaseTableDeckle1."Deckle Size");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Paper Type", ItemMaster."Paper Type");
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Paper GSM", Format(ItemMaster."Paper GSM"));
                                PaserGSMBaseTable.SetRange(PaserGSMBaseTable."Item No.", ProdOrderCompLine."Item No.");
                                if not PaserGSMBaseTable.FindFirst then begin
                                    PaserGSMBaseTable.Init;
                                    PaserGSMBaseTable."Schedule No." := BaseTableDeckle1."Schedule No.";
                                    PaserGSMBaseTable."Deckle Size" := BaseTableDeckle1."Deckle Size";
                                    PaserGSMBaseTable."Deckle Size(Num)" := BaseTableDeckle1."Deckle Size(Num)";
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
            until BaseTableDeckle1.Next = 0;
        end;
    end;


    procedure UpdateExistingSchedule(ProductionOrderNo: Code[50]; OrderLineNo: Integer; ScheduleDocNum: code[20])
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
        ProductionScheduleLine: Record "Production Schedule Line";
        ProdOrderCompLine: Record "Prod. Order Component";
    begin
        // Lines added BY Deepak Kumar
        // Only From manual Asortment                        

        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange("Prod. Order No.", ProductionOrderNo);
        ProductionScheduleLine.SetRange("Prod. Order Line No.", OrderLineNo);
        ProductionScheduleLine.SetRange("Schedule No.", ScheduleDocNum);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule Line", true);
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Marked for Publication", true);
        ProductionScheduleLine.SetRange(Published, true);
        if ProductionScheduleLine.FindFirst then begin
            repeat
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
                        PaperGSMLine.SetRange("Prod. Order Number", ProductionOrderNo);
                        PaperGSMLine.SetRange("Prod. Order Line No.", OrderLineNo);
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
                            Error('Item not found with following specification, Deckle Size %1 Paper Type %2 Paper GSM %3');
                        end;
                    until ProdOrderComp.Next = 0;
                end;
                //Updated By Deepak Kumar
                ProdOrder.Reset;
                ProdOrder.SetRange(ProdOrder.Status, ProdOrder.Status::Released);
                ProdOrder.SetRange(ProdOrder."No.", ProductionScheduleLine."Prod. Order No.");
                if ProdOrder.FindFirst then begin
                    ProdOrder."Prod Status" := ProdOrder."Prod Status"::"In process";
                    ProdOrder.Modify(true);
                end;
            until ProductionScheduleLine.Next = 0;
            Message('Corrugation Schedule is Updated in Published Schedule No %1, Order component also created for the same', ProductionScheduleLine."Schedule No.");
        end;
    end;

    procedure UpdateScheduleItem(ScheduleDocNo: Code[50]; RequistionOrderNo: Code[40])
    var
        ScheduleOrder: Record "Production Schedule";
        ProdOrderHeader: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ItemM: Record Item;
        Iloop: Integer;
        ReqLine: Record "Requisition Line SAM";
        LineNumber: Integer;
        ProdOrderCompLine: Record "Prod. Order Component";
        TempItemNumber: Code[50];
        TempPaperPostion: Code[50];
        TempQuantity: Decimal;
        RequisitionLineSAM: Record "Requisition Line SAM";
        ProductionScheduleLine: Record "Production Schedule Line";
        ReqHeader: Record "Requisition Header";
    begin
        // Lines added by Deepak Kumar
        ReqLine.Reset;
        ReqLine.SetCurrentKey("Requisition No.", "Requisition Line No.");
        ReqLine.SetRange(ReqLine."Requisition No.", RequistionOrderNo);
        if ReqLine.FindLast then
            LineNumber := ReqLine."Requisition Line No.";


        ScheduleOrder.Reset;
        ScheduleOrder.SetRange(ScheduleOrder."Schedule No.", ScheduleDocNo);
        if ScheduleOrder.FindFirst then begin
            ProdOrderCompLine.Reset;
            ProdOrderCompLine.SetCurrentKey("Prod Schedule No.", "Paper Position", "Item No.");
            ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
            ProdOrderCompLine.SetRange(ProdOrderCompLine."Schedule Component", true);
            ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod Schedule No.", ScheduleOrder."Schedule No.");
            if ProdOrderCompLine.FindFirst then begin
                //  LineNumber:=0;
                repeat
                    RequisitionLineSAM.Reset;
                    RequisitionLineSAM.SetFilter(RequisitionLineSAM."Requisition No.", RequistionOrderNo);
                    RequisitionLineSAM.SetRange(RequisitionLineSAM."Paper Position", ProdOrderCompLine."Paper Position");
                    RequisitionLineSAM.SetFilter(RequisitionLineSAM."Item No.", ProdOrderCompLine."Item No.");
                    if Not RequisitionLineSAM.FindFirst then begin
                        ReqLine.Init;
                        LineNumber := LineNumber + 1000;
                        ReqLine."Requisition No." := RequistionOrderNo;
                        ReqLine."Requisition Line No." := LineNumber;
                        ReqLine."Requested Date" := WorkDate;
                        //ReqLine."Prod. Order No":=ProdOrderComp."Prod. Order No.";
                        //ReqLine."Prod. Order Line No.":=ProdOrderComp."Prod. Order Line No.";
                        //ReqLine."Prod. Order Comp. Line No":=ProdOrderComp."Line No.";
                        ReqLine."Production Schedule No." := ProdOrderCompLine."Prod Schedule No.";
                        ReqLine.Validate("Item No.", ProdOrderCompLine."Item No.");
                        ReqLine.Validate(Quantity, ProdOrderCompLine."Remaining Quantity");
                        ReqLine."Paper Position" := ProdOrderCompLine."Paper Position";
                        ReqLine."Approved by Store" := true;
                        ReqLine."Approved by Prod." := true;
                        ReqLine."Published by" := UserId;
                        ReqLine.Published := true;
                        TempQuantity := ProdOrderCompLine."Remaining Quantity";
                        ReqHeader.Reset;
                        ReqHeader.SetRange(ReqHeader."Requisition No.", RequistionOrderNo);
                        if ReqHeader.FindFirst then begin
                            ReqLine."Extra Material" := ReqHeader."Extra Material";
                            ReqLine."Offset Printing" := ReqHeader."Offset Printing";
                        end;
                        if TempQuantity > 0 then begin
                            TempItemNumber := ProdOrderCompLine."Item No.";
                            TempPaperPostion := Format(ProdOrderCompLine."Paper Position");
                            ReqLine.Insert(true);
                        end;
                    end;
                until ProdOrderCompLine.Next = 0;
                Message('Requisition Complete');
            end else begin
                Error('There is no Prod. Order Component Line');
            end;

        end;
    end;
}