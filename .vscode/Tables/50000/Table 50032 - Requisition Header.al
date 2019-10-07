table 50032 "Requisition Header"
{
    // version Requisition

    // // Table Designed By Deepak Kumar


    fields
    {
        field(1; "Requisition No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Requisition Date"; Date)
        {

            trigger OnValidate()
            begin
                ValidateReq;
            end;
        }
        field(3; "Requisition Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Manual Requisition,Production Order,Production Schedule,Maintenance';
            OptionMembers = "Manual Requisition","Production Order","Production Schedule",Maintenance;
        }
        field(4; "Ref. Document Number"; Code[20])
        {
        }
        field(5; Description; Text[250])
        {
            Editable = false;
        }
        field(6; "User ID"; Code[50])
        {
            Editable = false;
        }
        field(7; "Prod. Order No"; Code[20])
        {
            TableRelation = "Production Order"."No." WHERE (Status = CONST (Released));

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                ValidateStatus("Requisition No.");

                // Lines added by deepak Kumar
                "Requisition Type" := 1;
                ProdOrder.Reset;
                ProdOrder.SetRange(ProdOrder.Status, ProdOrder.Status::Released);
                ProdOrder.SetRange(ProdOrder."No.", "Prod. Order No");
                if ProdOrder.FindFirst then begin
                    Description := ProdOrder.Description;
                    "Estimation No." := ProdOrder."Estimate Code";
                    "Customer's Name" := ProdOrder."Customer Name";
                    EstimationHeader.Reset;
                    EstimationHeader.SetRange(EstimationHeader."Product Design No.", ProdOrder."Estimate Code");
                    if EstimationHeader.FindFirst then
                        "Board Ups" := EstimationHeader."Board Ups";
                end;
            end;
        }
        field(8; "Prod. Order Line No."; Integer)
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status = CONST (Released),
                                                                 "Prod. Order No." = FIELD ("Prod. Order No"));

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                ValidateStatus("Requisition No.");
                TestField("Prod. Order No");
                ProdOrder.Reset;
                ProdOrder.SetRange(ProdOrder."No.", "Prod. Order No");
                if ProdOrder.FindFirst then begin
                    "Production Order Quantity" := ProdOrder.Quantity;
                    "Requisition Quantity" := ProdOrder.Quantity;
                end;

                ProdOrderLine.Reset;
                ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No");
                ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Prod. Order Line No.");
                if ProdOrderLine.FindFirst then begin
                    "Prod. Order Line Quantity" := ProdOrderLine.Quantity;
                    if "Prod. Order Line Req. Qty" = 0 then
                        "Prod. Order Line Req. Qty" := ProdOrderLine.Quantity;
                    if ProdOrderLine."Board Ups" <> 0 then
                        "Board Ups" := ProdOrderLine."Board Ups";

                    //"Printed Dupl. Board Ups":= ProdOrderLine."Printed Duplex BoardUps";
                    //"Printed Dupl. No. of Joints":= ProdOrderLine."Printed Duplex NoofJoints";
                end;
            end;
        }
        field(9; "Prod. Order Line Quantity"; Decimal)
        {
            Editable = false;
        }
        field(10; "Requisition Quantity"; Decimal)
        {

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                ValidateStatus("Requisition No.");

                // Lines added bY Deepak Kumar
                if "Requisition Quantity" > "Production Order Quantity" then
                    Error('Requisition quantity must not be greater than  Prod. Order Quantity');

                if "Board Ups" = 0 then
                    "Board Ups" := 1;

                "Prod. Order Line Req. Qty" := Round("Requisition Quantity" / "Board Ups", 1, '<');
            end;
        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));

            trigger OnValidate()
            begin
                ValidateReq;
            end;
        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(50; "Offset Printing"; Boolean)
        {
        }
        field(100; "Short Closed"; Boolean)
        {
        }
        field(101; "Short Closed by"; Code[50])
        {
            Editable = false;
        }
        field(120; Status; Option)
        {
            CaptionML = ENU = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Closed,Pending for Approval,Approved,Rejected';
            OptionMembers = Open,Released,Closed,"Pending for Approval",Approved,Rejected;
        }
        field(121; "Marked Purchase Requisition"; Boolean)
        {
            Editable = false;
        }
        field(200; "Mark for Purchase"; Boolean)
        {
        }
        field(201; "Extra Material"; Boolean)
        {
            Editable = false;
        }
        field(202; "Extra Material Approved"; Boolean)
        {
            Editable = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                "Extra Material App. By" := UserId + ' ' + Format(WorkDate) + ' ' + Format(Time);
                "Extra Material App. Date" := Today;
            end;
        }
        field(203; "Extra Material App. By"; Text[150])
        {
            Editable = false;
        }
        field(204; "Extra Material App. Date"; Date)
        {
            Editable = false;
        }
        field(205; "Production Order Quantity"; Decimal)
        {
            Editable = false;
        }
        field(206; "Prod. Order Line Req. Qty"; Decimal)
        {
            Editable = false;
        }
        field(207; "Estimation No."; Code[20])
        {
            Editable = false;
        }
        field(208; "Board Ups"; Integer)
        {
            Editable = false;
        }
        field(300; "Schedule Document No."; Code[20])
        {
            TableRelation = "Production Schedule"."Schedule No." WHERE ("Schedule Published" = CONST (true),
                Status = filter (Confirmed));

            trigger OnValidate()
            begin
                // Lines added bY Deepak Kumar
                "Requisition Type" := 2;
            end;
        }
        field(301; Published; Boolean)
        {
        }
        field(302; "Customer's Name"; Text[80])
        {
            Editable = false;
        }
        field(303; "Printed Dupl. Board Ups"; Integer)
        {
            Editable = false;
        }
        field(304; "Printed Dupl. No. of Joints"; Integer)
        {
            Editable = false;
        }
        field(305; "Repeated Job No."; Code[20])
        {
            Editable = false;
        }
        field(306; "Requisition Remarks"; Text[250])
        {
        }
        field(307; "Rejection Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(308; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(309; "Machine Id"; Code[20])
        {

        }
        field(310; "Complaint No."; Code[20])
        {

        }
        field(311; "Maintenance Type"; Option)
        {
            OptionCaption = 'PMR,BreakDown,Others,Predictive';
            OptionMembers = PMR,BreakDown,Others,Predictive;
        }
        field(312; "Work Center"; Code[20])
        {

        }
        field(313; "Maintenance Date"; Date)
        {

        }
    }

    keys
    {
        key(Key1; "Requisition Type", "Requisition No.")
        {
        }
        key(Key2; "Prod. Order No")
        {
        }
        key(Key3; "Ref. Document Number")
        {
        }
        key(Key4; "Requisition No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Requisition No.", "Prod. Order No", "Ref. Document Number")
        {
        }
    }

    trigger OnDelete()
    begin
        // Lines added by depak kUmar
        RequisitionLine.Reset;
        RequisitionLine.SetRange(RequisitionLine."Requisition No.", "Requisition No.");
        if RequisitionLine.FindFirst then begin
            repeat
                if (RequisitionLine."Issued Quantity" > 0) or (RequisitionLine."Short Closed Quantity" > 0) then Error('You can not delete the record, one or more item issued or shortclosed');
            until RequisitionLine.Next = 0;
            RequisitionLine.DeleteAll;
        end;
    end;

    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        // Lines added BY Deepak Kumar

        if "Requisition No." = '' then begin
            PurchSetup.Get;
            PurchSetup.TestField("Requisition No Series");
            NoSeriesMgt.InitSeries(PurchSetup."Requisition No Series", '', 0D, "Requisition No.", PurchSetup."Requisition No Series");
        end;
        "User ID" := UserId;
        "Requisition Date" := WorkDate;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ProdOrder: Record "Production Order";
        RequisitionLine: Record "Requisition Line SAM";
        ProdOrderLine: Record "Prod. Order Line";
        ReqHeader: Record "Requisition Header";
        EstimationHeader: Record "Product Design Header";
        UserSetup: Record "User Setup";
        ProdOrderComp: Record "Prod. Order Component";

    procedure "--Samadhan"()
    begin
    end;

    procedure GetBOMItemLine(ProdOrderNo: Code[20]; ProdOrderLine: Integer; ReqDocNo: Code[20])
    var
        ProdOrderComp: Record "Prod. Order Component";
        ReqLine: Record "Requisition Line SAM";
        LineNumber: Integer;
        RequisitionLine: Record "Requisition Line SAM";
        TotalReqQuantity: Decimal;
        TempQuantity: Decimal;
    begin
        // Lines added by deepak kUmar
        TestField("Prod. Order No");
        TestField("Prod. Order Line No.");
        TestField("Short Closed", false);

        ProdOrderComp.Reset;
        ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
        ProdOrderComp.SetRange(ProdOrderComp."Prod. Order No.", ProdOrderNo);
        ProdOrderComp.SetRange(ProdOrderComp."Prod. Order Line No.", ProdOrderLine);
        ProdOrderComp.SetRange(ProdOrderComp.Published, true);
        ProdOrderComp.SetFilter(ProdOrderComp."Remaining Quantity", '<>0');
        if ProdOrderComp.FindFirst then begin
            ReqLine.Reset;
            ReqLine.SetRange(ReqLine."Requisition No.", ReqDocNo);
            if ReqLine.FindFirst then begin
                ReqLine.DeleteAll;
            end;
            repeat
                TotalReqQuantity := 0;
                RequisitionLine.Reset;
                RequisitionLine.SetRange(RequisitionLine."Prod. Order No", ProdOrderComp."Prod. Order No.");
                RequisitionLine.SetRange(RequisitionLine."Prod. Order Line No.", ProdOrderComp."Prod. Order Line No.");
                RequisitionLine.SetRange(RequisitionLine."Prod. Order Comp. Line No", ProdOrderComp."Line No.");
                if RequisitionLine.FindFirst then begin
                    repeat
                        TotalReqQuantity := TotalReqQuantity + RequisitionLine.Quantity;
                    until RequisitionLine.Next = 0;
                end;

                if (TotalReqQuantity < ProdOrderComp."Expected Quantity") then begin
                    ReqLine.Reset;
                    ReqLine.Init;
                    LineNumber := LineNumber + 1000;
                    ReqLine."Requisition No." := ReqDocNo;
                    ReqLine."Requisition Line No." := LineNumber;
                    ReqLine."Requested Date" := WorkDate;
                    ReqLine."Prod. Order No" := ProdOrderComp."Prod. Order No.";
                    ReqLine."Prod. Order Line No." := ProdOrderComp."Prod. Order Line No.";
                    ReqLine."Prod. Order Comp. Line No" := ProdOrderComp."Line No.";
                    ReqLine.Validate("Item No.", ProdOrderComp."Item No.");
                    ReqLine.Validate(Quantity, (ProdOrderComp."Quantity per" * "Prod. Order Line Req. Qty"));
                    ReqLine."Paper Position" := ProdOrderComp."Paper Position"; //Pulak 04-06-15
                                                                                //ReqLine."Validate Origin":= ProdOrderComp."Validate Orgin"  ; //Pulak 17-06-15
                    TempQuantity := ProdOrderComp."Quantity per" * "Prod. Order Line Req. Qty";
                    //ReqLine."Part Code":=ProdOrderComp."Part Code"; //Firoz 25-07-15
                    if "Offset Printing" then
                        ReqLine."Quantity In PCS" := "Prod. Order Line Quantity"; //Pulak 02-09-15
                    ReqLine."Offset Printing" := "Offset Printing";
                    // Lines added bY deepak Kumar // 24 03 15
                    ReqHeader.Reset;
                    ReqHeader.SetRange(ReqHeader."Requisition No.", ReqDocNo);
                    if ReqHeader.FindFirst then begin
                        ReqLine."Extra Material" := ReqHeader."Extra Material";
                    end;
                    //IF TempQuantity > 0 THEN

                    ReqLine.Insert(true);
                    ReqLine.UpdateQuantity();
                end;
            until ProdOrderComp.Next = 0;
            //MESSAGE('Line Generated');
        end else begin
            Message('There are no lines to create !, Or not Released for Issue');
        end;
    end;

    procedure ShortCloseRequisition(RequisitionNUmber: Code[20])
    var
        RequisitionHeader: Record "Requisition Header";
        RequisitionLine: Record "Requisition Line SAM";
    begin
        // Lines added  bY deepak Kumar
        ValidateStoreUser;
        RequisitionHeader.Reset;
        RequisitionHeader.SetRange(RequisitionHeader."Requisition No.", RequisitionNUmber);
        if RequisitionHeader.FindFirst then begin
            RequisitionLine.Reset;
            RequisitionLine.SetRange(RequisitionLine."Requisition No.", RequisitionHeader."Requisition No.");
            if RequisitionLine.FindFirst then begin
                RequisitionHeader."Short Closed" := true;
                RequisitionHeader."Short Closed by" := UserId;
                RequisitionHeader.Status := RequisitionHeader.Status::Closed;
                RequisitionHeader.Modify(true);
                repeat
                    RequisitionLine."Short Closed Quantity" := RequisitionLine."Remaining Quantity";
                    RequisitionLine."Remaining Quantity" := 0;
                    RequisitionLine."Short Closed" := true;
                    RequisitionLine.Modify(true);
                until RequisitionLine.Next = 0;
                Message('Complete');
            end;

        end;
    end;

    procedure ExtraMaterialApproval()
    var
        UserSetup: Record "User Setup";
    begin
        //lines added bY Deepak Kumar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Extra Material Approval", true);
        if not UserSetup.FindFirst then begin
            Error('You are not authorised user for Extra material approval');
        end else begin
            Validate("Extra Material Approved", true);
            Modify(true);
        end;
    end;

    procedure ValidateStatus(RequistionNo: Code[50])
    var
        Answer: Boolean;
        Question: Text[250];
        RequisitionHeader: Record "Requisition Header";
    begin
        // Lines added BY Deepak Kumar
        RequisitionHeader.Reset;
        RequisitionHeader.SetRange(RequisitionHeader."Requisition No.", RequistionNo);
        RequisitionHeader.SetRange(RequisitionHeader."Extra Material", true);
        RequisitionHeader.SetRange(RequisitionHeader."Extra Material Approved", true);
        if RequisitionHeader.FindFirst then begin
            Question := 'In this requisition extra material is approved, if you modify the record you have to re-approve the requisition. Do you want to continue ? ';
            Answer := DIALOG.Confirm(Question, true);
            if Answer = true then begin
                RequisitionHeader."Extra Material Approved" := false;
                RequisitionHeader."Extra Material App. By" := 'Approval void by user modification.' + UserId + ' ' + Format(WorkDate) + ' ' + Format(Time);
                RequisitionHeader.Modify(true);
            end else begin
                Error('');
                exit;
            end;
        end;
    end;

    procedure GetScheduleItem(ScheduleDocNo: Code[50]; RequistionOrderNo: Code[40])
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
    begin
        // Lines added by Deepak Kumar
        ReqLine.Reset;
        ReqLine.SetCurrentKey("Requisition No.", "Requisition Line No.");
        ReqLine.SetRange(ReqLine."Requisition No.", RequistionOrderNo);
        if ReqLine.FindLast then
            LineNumber := ReqLine."Requisition Line No.";


        RequisitionLineSAM.Reset;
        RequisitionLineSAM.SetFilter(RequisitionLineSAM."Requisition No.", RequistionOrderNo);
        if RequisitionLineSAM.FindFirst then begin
            repeat
                RequisitionLineSAM.Validate(RequisitionLineSAM.Quantity, 0);
                RequisitionLineSAM.Modify(true);
            until RequisitionLineSAM.Next = 0;
        end;


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
                    if RequisitionLineSAM.FindFirst then begin
                        RequisitionLineSAM.Validate(RequisitionLineSAM.Quantity, (RequisitionLineSAM.Quantity + ProdOrderCompLine."Remaining Quantity"));
                        RequisitionLineSAM.Modify(true);

                    end else begin


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
                        TempQuantity := ProdOrderCompLine."Remaining Quantity";
                        ReqLine."Offset Printing" := "Offset Printing";
                        ReqHeader.Reset;
                        ReqHeader.SetRange(ReqHeader."Requisition No.", RequistionOrderNo);
                        if ReqHeader.FindFirst then begin
                            ReqLine."Extra Material" := ReqHeader."Extra Material";
                        end;
                        if TempQuantity > 0 then begin
                            TempItemNumber := ProdOrderCompLine."Item No.";
                            TempPaperPostion := Format(ProdOrderCompLine."Paper Position");
                            ReqLine.Insert(true);
                        end;
                    end;

                until ProdOrderCompLine.Next = 0;
                Message('Complete');
            end else begin
                Error('There is no Prod. Order Component Line');
            end;

        end;

        // for Componet Updated by Force
        ProductionScheduleLine.Reset;
        ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", ScheduleDocNo);
        ProductionScheduleLine.SetRange(ProductionScheduleLine.Published, true);
        if ProductionScheduleLine.FindFirst then begin
            repeat

                ProdOrderCompLine.Reset;
                ProdOrderCompLine.SetCurrentKey("Prod Schedule No.", "Paper Position", "Item No.");
                ProdOrderCompLine.SetRange(ProdOrderCompLine.Status, ProdOrderCompLine.Status::Released);
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Force Avail. for Requisition", true);
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order No.", ProductionScheduleLine."Prod. Order No.");
                ProdOrderCompLine.SetRange(ProdOrderCompLine."Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                if ProdOrderCompLine.FindFirst then begin
                    repeat
                        RequisitionLineSAM.Reset;
                        RequisitionLineSAM.SetFilter(RequisitionLineSAM."Requisition No.", RequistionOrderNo);
                        RequisitionLineSAM.SetRange(RequisitionLineSAM."Paper Position", ProdOrderCompLine."Paper Position");
                        RequisitionLineSAM.SetFilter(RequisitionLineSAM."Item No.", ProdOrderCompLine."Item No.");
                        if RequisitionLineSAM.FindFirst then begin
                            RequisitionLineSAM.Validate(RequisitionLineSAM.Quantity, (RequisitionLineSAM.Quantity + ProdOrderCompLine."Remaining Quantity"));
                            RequisitionLineSAM.Modify(true);

                        end else begin


                            ReqLine.Init;
                            LineNumber := LineNumber + 1000;
                            ReqLine."Requisition No." := RequistionOrderNo;
                            ReqLine."Requisition Line No." := LineNumber;
                            ReqLine."Requested Date" := WorkDate;
                            ReqLine."Production Schedule No." := ProdOrderCompLine."Prod Schedule No.";
                            ReqLine.Validate("Item No.", ProdOrderCompLine."Item No.");
                            ReqLine.Validate(Quantity, ProdOrderCompLine."Remaining Quantity");
                            ReqLine."Paper Position" := ProdOrderCompLine."Paper Position";
                            TempQuantity := ProdOrderCompLine."Remaining Quantity";
                            ReqLine."Offset Printing" := "Offset Printing";
                            ReqHeader.Reset;
                            ReqHeader.SetRange(ReqHeader."Requisition No.", RequistionOrderNo);
                            if ReqHeader.FindFirst then begin
                                ReqLine."Extra Material" := ReqHeader."Extra Material";
                            end;
                            if TempQuantity > 0 then begin
                                TempItemNumber := ProdOrderCompLine."Item No.";
                                TempPaperPostion := Format(ProdOrderCompLine."Paper Position");
                                ReqLine.Insert(true);
                            end;
                        end;

                    until ProdOrderCompLine.Next = 0;
                    //    MESSAGE('Complete');
                end;
            until ProductionScheduleLine.Next = 0;
        end;
    end;

    procedure "--Samadhan--"()
    begin
    end;

    procedure ApprovebyStore(ReqNo: Code[50])
    var
        ReqLine: Record "Requisition Line SAM";
        PodOrderLine: Record "Prod. Order Line";
        UserSetup: Record "User Setup";
        MfgSetup: Record "Manufacturing Setup";
    begin
        // Lines added By Deepak Kumar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        //UserSetup.SETRANGE(UserSetup."Auth. Printing User",TRUE);
        if UserSetup.FindFirst then begin
            /*
              MfgSetup.GET;
              MfgSetup.TESTFIELD(MfgSetup."Duplex Paper Category");
              ReqLine.RESET;
              ReqLine.SETRANGE(ReqLine."Requisition No.",ReqNo);
              ReqLine.SETFILTER(ReqLine."Item Category Code",MfgSetup."Duplex Paper Category");
              IF ReqLine.FINDFIRST THEN BEGIN
                REPEAT
                  ReqLine."Approved by Store":=TRUE;
                  ReqLine.MODIFY(TRUE);
                UNTIL ReqLine.NEXT=0;
                PublishProductionOrder(ReqNo);
                MESSAGE('Complete');
              END;
          END ELSE BEGIN
          */
            ValidateStoreUser;
            MfgSetup.Get;
            // MfgSetup.TESTFIELD(MfgSetup."Duplex Paper Category");
            ReqLine.Reset;
            ReqLine.SetRange(ReqLine."Requisition No.", "Requisition No.");
            // ReqLine.SETFILTER(ReqLine."Item Category Code",'<>%1',MfgSetup."Duplex Paper Category");
            if ReqLine.FindFirst then begin
                repeat
                    ReqLine."Approved by Store" := true;
                    ReqLine.Modify(true);
                until ReqLine.Next = 0;
                PublishProductionOrder(ReqNo);
                Message('Complete');
            end;
        end;

    end;

    procedure ApprovebyProduction(ReqNo: Code[50])
    var
        ReqLine: Record "Requisition Line SAM";
    begin
        // Lines added By Deepak Kumar
        ValidateProdUser;
        ReqLine.Reset;
        ReqLine.SetRange(ReqLine."Requisition No.", ReqNo);
        if ReqLine.FindFirst then begin
            repeat
                ReqLine."Approved by Prod." := true;
                ReqLine.Modify(true);
            until ReqLine.Next = 0;
            PublishProductionOrder(ReqNo);
            Message('Complete');

        end;
    end;

    procedure PublishProductionOrder(ReqNo: Code[50])
    var
        ReqLine: Record "Requisition Line SAM";
        RequisitionHeader: Record "Requisition Header";
        TempProdOrderLine: Record "Prod. Order Component";
        NewProdCompLine: Record "Prod. Order Component";
    begin
        //ValidateProdUser;
        // Lines added By Deepak Kumar
        ReqLine.Reset;
        ReqLine.SetRange(ReqLine."Requisition No.", ReqNo);
        if ReqLine.FindFirst then begin
            repeat
                if (ReqLine."Approved by Store" = true) and (ReqLine."Approved by Prod." = true) then begin
                    if (ReqLine."Alternative item by Prod." <> '') then begin
                        ReqLine."Previous Item No" := ReqLine."Item No.";
                        ReqLine."Previous Item Description" := ReqLine.Description;
                        ReqLine.Validate("Item No.", ReqLine."Alternative item by Prod.");
                    end;
                    if (ReqLine."Alternative item by Prod." = '') and (ReqLine."Alternative item by Store" <> '') then begin
                        ReqLine."Previous Item No" := ReqLine."Item No.";
                        ReqLine."Previous Item Description" := ReqLine.Description;
                        ReqLine.Validate("Item No.", ReqLine."Alternative item by Store");
                    end;
                    ReqLine.Published := true;
                    ReqLine."Published by" := UserId;
                    ReqLine.Modify(true);

                    // Update the Prod. Order Components as per Published Items in requisition

                    RequisitionHeader.Reset;
                    RequisitionHeader.SetRange(RequisitionHeader."Requisition Type", RequisitionHeader."Requisition Type"::"Production Schedule");
                    RequisitionHeader.SetRange(RequisitionHeader."Requisition No.", ReqLine."Requisition No.");
                    if RequisitionHeader.FindFirst then begin
                        ProdOrderComp.Reset;
                        ProdOrderComp.SetRange(ProdOrderComp."Schedule Component", true);
                        ProdOrderComp.SetRange(ProdOrderComp."Prod Schedule No.", RequisitionHeader."Schedule Document No.");
                        ProdOrderComp.SetRange(ProdOrderComp."Paper Position", ReqLine."Paper Position");
                        ProdOrderComp.SetRange(ProdOrderComp."Item No.", ReqLine."Previous Item No");
                        if ProdOrderComp.FindFirst then begin
                            repeat
                                ProdOrderComp.Validate(ProdOrderComp."Item No.", ReqLine."Item No.");
                                ProdOrderComp.Modify(true);
                            until ProdOrderComp.Next = 0;
                        end;
                    end;
                    /*
RequisitionHeader.RESET;
RequisitionHeader.SETRANGE(RequisitionHeader."Requisition Type",RequisitionHeader."Requisition Type"::"Production Order");
RequisitionHeader.SETRANGE(RequisitionHeader."Requisition No.",ReqLine."Requisition No.");
IF RequisitionHeader.FINDFIRST THEN BEGIN
MESSAGE('First Stage');
ProdOrderComp.RESET;
ProdOrderComp.SETRANGE(ProdOrderComp."By Material Requisition",TRUE);
ProdOrderComp.SETRANGE(ProdOrderComp."Material Requisition No.",ReqLine."Requisition No.");
ProdOrderComp.SETRANGE(ProdOrderComp."Prod. Order No.",ReqLine."Prod. Order No");
ProdOrderComp.SETRANGE(ProdOrderComp."Prod. Order Line No.",ReqLine."Prod. Order Line No.");
ProdOrderComp.SETRANGE(ProdOrderComp."Paper Position",ReqLine."Paper Position");
IF  NOT ProdOrderComp.FINDFIRST THEN BEGIN
TempProdOrderLine.RESET;
TempProdOrderLine.SETRANGE(TempProdOrderLine.Status,TempProdOrderLine.Status::Released);
TempProdOrderLine.SETRANGE(TempProdOrderLine."Prod. Order No.",ReqLine."Prod. Order No");
TempProdOrderLine.SETRANGE(TempProdOrderLine."Prod. Order Line No.",ReqLine."Prod. Order Line No.");
TempProdOrderLine.SETRANGE(TempProdOrderLine."Paper Position",ReqLine."Paper Position");
TempProdOrderLine.SETRANGE(TempProdOrderLine."Schedule Component",FALSE);
IF TempProdOrderLine.FINDFIRST THEN BEGIN
NewProdCompLine.INIT;
NewProdCompLine:=TempProdOrderLine;
//NewProdCompLine."Line No.":=
NewProdCompLine."Expected Quantity":=0;
NewProdCompLine."Remaining Quantity":=0;
NewProdCompLine."Remaining Qty. (Base)":=0;
NewProdCompLine."Expected Qty. (Base)":=0;
NewProdCompLine."By Material Requisition":=TRUE;
NewProdCompLine."Material Requisition No.":=ReqLine."Requisition No.";
NewProdCompLine.VALIDATE(Quantity,ReqLine.Quantity);
NewProdCompLine."Schedule Component":=TRUE;
NewProdCompLine.INSERT(TRUE);
END;
END ELSE BEGIN
ProdOrderComp.VALIDATE(ProdOrderComp."Item No.",ReqLine."Item No.");
ProdOrderComp.VALIDATE(Quantity,ReqLine.Quantity);
ProdOrderComp.MODIFY(TRUE);
END;

END;                                   */
                end;
            until ReqLine.Next = 0;
            Published := true;
            Status := Status::Released;
            Modify(true);
            /*
            ProdSchedHeader.RESET;
            ProdSchedHeader.SETRANGE(ProdSchedHeader."Document No.","Schedule Document No.");
            IF  (Published) AND (ProdSchedHeader.FINDFIRST) THEN
              BEGIN
                ProdSchedHeader."Requisition Confirmed":= TRUE  ;
                ProdSchedHeader.MODIFY(TRUE);
              END;
              */
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

    procedure MarkforPurchase()
    var
        ReqLine: Record "Requisition Line SAM";
    begin
        // Lines added By Deepak Kumar
        ValidateStoreUser;
        "Marked Purchase Requisition" := true;
        Modify(true);
        ReqLine.Reset;
        ReqLine.SetRange(ReqLine."Requisition No.", "Requisition No.");
        if ReqLine.FindFirst then begin
            repeat
                ReqLine."Marked Purchase Requisition" := true;
                ReqLine.Modify(true);
            until ReqLine.Next = 0;
            Message('Material Requisition %1 marked for Purchase Requisition', "Requisition No.");
        end;
    end;

    procedure ReleaseRequisition()
    begin
        // Lines added By Deepak Kumar
        TestField(Status, Status::Open);
        Status := Status::Released;
    end;

    procedure ReOpenRequisition()
    begin
        // Lines added By Deepak Kumar
        IF Status IN [Status::Released, Status::Rejected] then
            Status := Status::Open
        else Error('Status already Open');
    end;

    procedure ValidateReq()
    begin
        TestField(Status, Status::Open);
    end;
}

