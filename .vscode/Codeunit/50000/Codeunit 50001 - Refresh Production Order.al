codeunit 50001 "Refresh Production Order"
{
    TableNo = "Production Order";

    trigger OnRun()
    var
        Item: Record Item;
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        ProdOrderComp: Record "Prod. Order Component";
        Family: Record Family;
        ProdOrder: Record "Production Order";
        ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
        RoutingNo: Code[20];
        ErrorOccured: Boolean;
    begin
        Direction := Direction::Backward;
        CalcLines:= true;

        if Status = Status::Finished then
          exit;
        if Direction = Direction::Backward then
          TestField("Due Date");



        "Production Order".Reset;
        "Production Order".SetRange("Production Order".Status,Status);
        "Production Order".SetRange("Production Order"."No.","No.");
        "Production Order".FindSet;

        RoutingNo := "Routing No.";
        case "Source Type" of
          "Source Type"::Item:
            if Item.Get("Source No.") then
              RoutingNo := Item."Routing No.";
          "Source Type"::Family:
            if Family.Get("Source No.") then
              RoutingNo := Family."Routing No.";
        end;
        if RoutingNo <> "Routing No." then begin
          "Routing No." := RoutingNo;
          Modify;
        end;

        ProdOrderLine.LockTable;

        CheckReservationExist;

        if CalcLines then begin
          if not CreateProdOrderLines.Copy("Production Order",Direction,'',true) then
            ErrorOccured := true;
        end else begin
          ProdOrderLine.SetRange(Status,Status);
          ProdOrderLine.SetRange("Prod. Order No.","No.");
          if CalcRoutings or CalcComponents then begin
            if ProdOrderLine.Find('-') then
              repeat
                if CalcRoutings then begin
                  ProdOrderRtngLine.SetRange(Status,Status);
                  ProdOrderRtngLine.SetRange("Prod. Order No.","No.");
                  ProdOrderRtngLine.SetRange("Routing Reference No.",ProdOrderLine."Routing Reference No.");
                  ProdOrderRtngLine.SetRange("Routing No.",ProdOrderLine."Routing No.");
                  if ProdOrderRtngLine.FindSet(true) then
                    repeat
                      ProdOrderRtngLine.SetSkipUpdateOfCompBinCodes(true);
                      ProdOrderRtngLine.Delete(true);
                    until ProdOrderRtngLine.Next = 0;
                end;
                if CalcComponents then begin
                  ProdOrderComp.SetRange(Status,Status);
                  ProdOrderComp.SetRange("Prod. Order No.","No.");
                  ProdOrderComp.SetRange("Prod. Order Line No.",ProdOrderLine."Line No.");
                  ProdOrderComp.DeleteAll(true);
                end;
              until ProdOrderLine.Next = 0;
            if ProdOrderLine.Find('-') then
              repeat
                if CalcComponents then
                  CheckProductionBOMStatus(ProdOrderLine."Production BOM No.",ProdOrderLine."Production BOM Version Code");
                if CalcRoutings then
                  CheckRoutingStatus(ProdOrderLine."Routing No.",ProdOrderLine."Routing Version Code");
                ProdOrderLine."Due Date" := "Due Date";
                if not CalcProdOrder.Calculate(ProdOrderLine,Direction,CalcRoutings,CalcComponents,false,true) then
                  ErrorOccured := true;
              until ProdOrderLine.Next = 0;
          end;
        end;
        if (Direction = Direction::Backward) and
           ("Source Type" = "Source Type"::Family)
        then begin
          SetUpdateEndDate;
          Validate("Due Date","Due Date");
        end;

        if Status = Status::Released then begin
          ProdOrderStatusMgt.FlushProdOrder("Production Order",Status,WorkDate);
          WhseProdRelease.Release("Production Order");
          if CreateInbRqst then
            WhseOutputProdRelease.Release("Production Order");
        end;

        if ErrorOccured then
          Message(Text005,ProdOrder.TableCaption,ProdOrderLine.FieldCaption("Bin Code"));
    end;

    var
        Text000: Label 'Refreshing Production Orders...\\';
        Text001: Label 'Status         #1##########\';
        Text002: Label 'No.            #2##########';
        Text003: Label 'Routings must be calculated, when lines are calculated.';
        Text004: Label 'Component Need must be calculated, when lines are calculated.';
        Text005: Label 'One or more of the lines on this %1 require special warehouse handling. The %2 for these lines has been set to blank.';
        ProdOrder: Record "Production Order";
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        CreateProdOrderLines: Codeunit "Create Prod. Order Lines";
        WhseProdRelease: Codeunit "Whse.-Production Release";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        Window: Dialog;
        Direction: Option Forward,Backward;
        CalcLines: Boolean;
        CalcRoutings: Boolean;
        CalcComponents: Boolean;
        CreateInbRqst: Boolean;
        "Production Order": Record "Production Order";

    procedure RefreshProdOrder()
    begin
    end;

    procedure CheckReservationExist()
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ProdOrderComp2: Record "Prod. Order Component";
        ReservEntry: Record "Reservation Entry";
    begin
        // Not allowed to refresh if reservations exist
        if (not CalcLines) or (not CalcComponents) then
          exit;
        ReservEntry.SetCurrentKey("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name");
        ReservEntry.SetRange("Source Batch Name",'');
        ReservEntry.SetRange("Reservation Status",ReservEntry."Reservation Status"::Reservation);

        ProdOrderLine2.SetRange(Status,"Production Order".Status);
        ProdOrderLine2.SetRange("Prod. Order No.","Production Order"."No.");
        if ProdOrderLine2.Find('-') then
          repeat
            if CalcLines then begin
              ProdOrderLine2.CalcFields("Reserved Qty. (Base)");
              if ProdOrderLine2."Reserved Qty. (Base)" <> 0 then begin
                ReservEntry.SetRange("Source ID",ProdOrderLine2."Prod. Order No.");
                ReservEntry.SetRange("Source Ref. No.",0);
                ReservEntry.SetRange("Source Type",DATABASE::"Prod. Order Line");
                ReservEntry.SetRange("Source Subtype",ProdOrderLine2.Status);
                ReservEntry.SetRange("Source Prod. Order Line",ProdOrderLine2."Line No.");
                if ReservEntry.FindFirst then begin
                  ReservEntry.Get(ReservEntry."Entry No.",not ReservEntry.Positive);
                  if not ((ReservEntry."Source Type" = DATABASE::"Prod. Order Component") and
                          (ReservEntry."Source ID" = ProdOrderLine2."Prod. Order No.") and
                          (ReservEntry."Source Subtype" = ProdOrderLine2.Status))
                  then
                    ProdOrderLine2.TestField("Reserved Qty. (Base)",0);
                end;
              end;
            end;

            if CalcLines or CalcComponents then begin
              ProdOrderComp2.SetRange(Status,ProdOrderLine2.Status);
              ProdOrderComp2.SetRange("Prod. Order No.",ProdOrderLine2."Prod. Order No.");
              ProdOrderComp2.SetRange("Prod. Order Line No.",ProdOrderLine2."Line No.");
              if ProdOrderComp2.Find('-') then
                repeat
                  ProdOrderComp2.CalcFields("Reserved Qty. (Base)");
                  if ProdOrderComp2."Reserved Qty. (Base)" <> 0 then begin
                    ReservEntry.SetRange("Source ID",ProdOrderComp2."Prod. Order No.");
                    ReservEntry.SetRange("Source Ref. No.",ProdOrderComp2."Line No.");
                    ReservEntry.SetRange("Source Type",DATABASE::"Prod. Order Component");
                    ReservEntry.SetRange("Source Subtype",ProdOrderComp2.Status);
                    ReservEntry.SetRange("Source Prod. Order Line",ProdOrderComp2."Prod. Order Line No.");
                    if ReservEntry.FindFirst then begin
                      ReservEntry.Get(ReservEntry."Entry No.",not ReservEntry.Positive);
                      if not ((ReservEntry."Source Type" = DATABASE::"Prod. Order Line") and
                              (ReservEntry."Source ID" = ProdOrderComp2."Prod. Order No.") and
                              (ReservEntry."Source Subtype" = ProdOrderComp2.Status))
                      then
                        ProdOrderComp2.TestField("Reserved Qty. (Base)",0);
                    end;
                  end;
                until ProdOrderComp2.Next = 0;
            end;
          until ProdOrderLine2.Next = 0;
    end;

    local procedure CheckProductionBOMStatus(ProdBOMNo: Code[20];ProdBOMVersionNo: Code[20])
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMVersion: Record "Production BOM Version";
    begin
        if ProdBOMNo = '' then
          exit;

        if ProdBOMVersionNo = '' then begin
          ProductionBOMHeader.Get(ProdBOMNo);
          ProductionBOMHeader.TestField(Status,ProductionBOMHeader.Status::Certified);
        end else begin
          ProductionBOMVersion.Get(ProdBOMNo,ProdBOMVersionNo);
          ProductionBOMVersion.TestField(Status,ProductionBOMVersion.Status::Certified);
        end;
    end;

    local procedure CheckRoutingStatus(RoutingNo: Code[20];RoutingVersionNo: Code[20])
    var
        RoutingHeader: Record "Routing Header";
        RoutingVersion: Record "Routing Version";
    begin
        if RoutingNo = '' then
          exit;

        if RoutingVersionNo = '' then begin
          RoutingHeader.Get(RoutingNo);
          RoutingHeader.TestField(Status,RoutingHeader.Status::Certified);
        end else begin
          RoutingVersion.Get(RoutingNo,RoutingVersionNo);
          RoutingVersion.TestField(Status,RoutingVersion.Status::Certified);
        end;
    end;

    procedure InitializeRequest(Direction2: Option Forward,Backward;CalcLines2: Boolean;CalcRoutings2: Boolean;CalcComponents2: Boolean;CreateInbRqst2: Boolean)
    begin
        Direction := Direction2;
        CalcLines := CalcLines2;
        CalcRoutings := CalcRoutings2;
        CalcComponents := CalcComponents2;
        CreateInbRqst := CreateInbRqst2;
    end;
}

