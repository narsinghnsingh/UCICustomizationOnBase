report 50018 "Refresh Production Order N"
{
    // version NAVW17.00

    Caption = 'Refresh Production Order N';
    ProcessingOnly = true;
    TransactionType = Update;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING (Status, "No.");
            RequestFilterFields = Status, "No.";

            trigger OnAfterGetRecord()
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
                IF Status = Status::Finished THEN
                    CurrReport.SKIP;
                IF Direction = Direction::Backward THEN
                    TESTFIELD("Due Date");

                Window.UPDATE(1, Status);
                Window.UPDATE(2, "No.");

                RoutingNo := "Routing No.";
                CASE "Source Type" OF
                    "Source Type"::Item:
                        IF Item.GET("Source No.") THEN
                            RoutingNo := Item."Routing No.";
                    "Source Type"::Family:
                        IF Family.GET("Source No.") THEN
                            RoutingNo := Family."Routing No.";
                END;
                IF RoutingNo <> "Routing No." THEN BEGIN
                    "Routing No." := RoutingNo;
                    MODIFY;
                END;

                ProdOrderLine.LOCKTABLE;

                CheckReservationExist;

                IF CalcLines THEN BEGIN
                    IF NOT CreateProdOrderLines.Copy("Production Order", Direction, '', false) THEN
                        ErrorOccured := TRUE;
                END ELSE BEGIN
                    ProdOrderLine.SETRANGE(Status, Status);
                    ProdOrderLine.SETRANGE("Prod. Order No.", "No.");
                    IF CalcRoutings OR CalcComponents THEN BEGIN
                        IF ProdOrderLine.FIND('-') THEN
                            REPEAT
                                IF CalcRoutings THEN BEGIN
                                    ProdOrderRtngLine.SETRANGE(Status, Status);
                                    ProdOrderRtngLine.SETRANGE("Prod. Order No.", "No.");
                                    ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                                    ProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
                                    IF ProdOrderRtngLine.FINDSET(TRUE) THEN
                                        REPEAT
                                            ProdOrderRtngLine.SetSkipUpdateOfCompBinCodes(TRUE);
                                            ProdOrderRtngLine.DELETE(TRUE);
                                        UNTIL ProdOrderRtngLine.NEXT = 0;
                                END;
                                IF CalcComponents THEN BEGIN
                                    ProdOrderComp.SETRANGE(Status, Status);
                                    ProdOrderComp.SETRANGE("Prod. Order No.", "No.");
                                    ProdOrderComp.SETRANGE("Prod. Order Line No.", ProdOrderLine."Line No.");
                                    ProdOrderComp.DELETEALL(TRUE);
                                END;
                            UNTIL ProdOrderLine.NEXT = 0;
                        IF ProdOrderLine.FIND('-') THEN
                            REPEAT
                                IF CalcComponents THEN
                                    CheckProductionBOMStatus(ProdOrderLine."Production BOM No.", ProdOrderLine."Production BOM Version Code");
                                IF CalcRoutings THEN
                                    CheckRoutingStatus(ProdOrderLine."Routing No.", ProdOrderLine."Routing Version Code");
                                ProdOrderLine."Due Date" := "Due Date";
                                IF NOT CalcProdOrder.Calculate(ProdOrderLine, Direction, CalcRoutings, CalcComponents, FALSE, false) THEN
                                    ErrorOccured := TRUE;
                            UNTIL ProdOrderLine.NEXT = 0;
                    END;
                END;
                IF (Direction = Direction::Backward) AND
                   ("Source Type" = "Source Type"::Family)
                THEN BEGIN
                    SetUpdateEndDate;
                    VALIDATE("Due Date", "Due Date");
                END;

                IF Status = Status::Released THEN BEGIN
                    ProdOrderStatusMgt.FlushProdOrder("Production Order", Status, WORKDATE);
                    WhseProdRelease.Release("Production Order");
                    IF CreateInbRqst THEN
                        WhseOutputProdRelease.Release("Production Order");
                END;

                IF ErrorOccured THEN
                    MESSAGE(Text005, ProdOrder.TABLECAPTION, ProdOrderLine.FIELDCAPTION("Bin Code"));
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN(
                  Text000 +
                  Text001 +
                  Text002);
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

        trigger OnInit()
        begin
            CalcLines := TRUE;
            CalcRoutings := TRUE;
            CalcComponents := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        Direction := Direction::Backward;
    end;

    var
        Text000: Label 'Refreshing Production Orders...\\';
        Text001: Label 'Status         #1##########\';
        Text002: Label 'No.            #2##########';
        Text003: Label 'Routings must be calculated, when lines are calculated.';
        Text004: Label 'Component Need must be calculated, when lines are calculated.';
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
        Text005: Label 'One or more of the lines on this %1 require special warehouse handling. The %2 for these lines has been set to blank.';

    procedure CheckReservationExist()
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ProdOrderComp2: Record "Prod. Order Component";
        ReservEntry: Record "Reservation Entry";
    begin
        // Not allowed to refresh if reservations exist
        IF (NOT CalcLines) OR (NOT CalcComponents) THEN
            EXIT;
        ReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        ReservEntry.SETRANGE("Source Batch Name", '');
        ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Reservation);

        ProdOrderLine2.SETRANGE(Status, "Production Order".Status);
        ProdOrderLine2.SETRANGE("Prod. Order No.", "Production Order"."No.");
        IF ProdOrderLine2.FIND('-') THEN
            REPEAT
                IF CalcLines THEN BEGIN
                    ProdOrderLine2.CALCFIELDS("Reserved Qty. (Base)");
                    IF ProdOrderLine2."Reserved Qty. (Base)" <> 0 THEN BEGIN
                        ReservEntry.SETRANGE("Source ID", ProdOrderLine2."Prod. Order No.");
                        ReservEntry.SETRANGE("Source Ref. No.", 0);
                        ReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Line");
                        ReservEntry.SETRANGE("Source Subtype", ProdOrderLine2.Status);
                        ReservEntry.SETRANGE("Source Prod. Order Line", ProdOrderLine2."Line No.");
                        IF ReservEntry.FINDFIRST THEN BEGIN
                            ReservEntry.GET(ReservEntry."Entry No.", NOT ReservEntry.Positive);
                            IF NOT ((ReservEntry."Source Type" = DATABASE::"Prod. Order Component") AND
                                    (ReservEntry."Source ID" = ProdOrderLine2."Prod. Order No.") AND
                                    (ReservEntry."Source Subtype" = ProdOrderLine2.Status))
                            THEN
                                ProdOrderLine2.TESTFIELD("Reserved Qty. (Base)", 0);
                        END;
                    END;
                END;

                IF CalcLines OR CalcComponents THEN BEGIN
                    ProdOrderComp2.SETRANGE(Status, ProdOrderLine2.Status);
                    ProdOrderComp2.SETRANGE("Prod. Order No.", ProdOrderLine2."Prod. Order No.");
                    ProdOrderComp2.SETRANGE("Prod. Order Line No.", ProdOrderLine2."Line No.");
                    IF ProdOrderComp2.FIND('-') THEN
                        REPEAT
                            ProdOrderComp2.CALCFIELDS("Reserved Qty. (Base)");
                            IF ProdOrderComp2."Reserved Qty. (Base)" <> 0 THEN BEGIN
                                ReservEntry.SETRANGE("Source ID", ProdOrderComp2."Prod. Order No.");
                                ReservEntry.SETRANGE("Source Ref. No.", ProdOrderComp2."Line No.");
                                ReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Component");
                                ReservEntry.SETRANGE("Source Subtype", ProdOrderComp2.Status);
                                ReservEntry.SETRANGE("Source Prod. Order Line", ProdOrderComp2."Prod. Order Line No.");
                                IF ReservEntry.FINDFIRST THEN BEGIN
                                    ReservEntry.GET(ReservEntry."Entry No.", NOT ReservEntry.Positive);
                                    IF NOT ((ReservEntry."Source Type" = DATABASE::"Prod. Order Line") AND
                                            (ReservEntry."Source ID" = ProdOrderComp2."Prod. Order No.") AND
                                            (ReservEntry."Source Subtype" = ProdOrderComp2.Status))
                                    THEN
                                        ProdOrderComp2.TESTFIELD("Reserved Qty. (Base)", 0);
                                END;
                            END;
                        UNTIL ProdOrderComp2.NEXT = 0;
                END;
            UNTIL ProdOrderLine2.NEXT = 0;
    end;

    local procedure CheckProductionBOMStatus(ProdBOMNo: Code[20]; ProdBOMVersionNo: Code[20])
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMVersion: Record "Production BOM Version";
    begin
        IF ProdBOMNo = '' THEN
            EXIT;

        IF ProdBOMVersionNo = '' THEN BEGIN
            ProductionBOMHeader.GET(ProdBOMNo);
            ProductionBOMHeader.TESTFIELD(Status, ProductionBOMHeader.Status::Certified);
        END ELSE BEGIN
            ProductionBOMVersion.GET(ProdBOMNo, ProdBOMVersionNo);
            ProductionBOMVersion.TESTFIELD(Status, ProductionBOMVersion.Status::Certified);
        END;
    end;

    local procedure CheckRoutingStatus(RoutingNo: Code[20]; RoutingVersionNo: Code[20])
    var
        RoutingHeader: Record "Routing Header";
        RoutingVersion: Record "Routing Version";
    begin
        IF RoutingNo = '' THEN
            EXIT;

        IF RoutingVersionNo = '' THEN BEGIN
            RoutingHeader.GET(RoutingNo);
            RoutingHeader.TESTFIELD(Status, RoutingHeader.Status::Certified);
        END ELSE BEGIN
            RoutingVersion.GET(RoutingNo, RoutingVersionNo);
            RoutingVersion.TESTFIELD(Status, RoutingVersion.Status::Certified);
        END;
    end;

    procedure InitializeRequest(Direction2: Option Forward,Backward; CalcLines2: Boolean; CalcRoutings2: Boolean; CalcComponents2: Boolean; CreateInbRqst2: Boolean)
    begin
        Direction := Direction2;
        CalcLines := CalcLines2;
        CalcRoutings := CalcRoutings2;
        CalcComponents := CalcComponents2;
        CreateInbRqst := CreateInbRqst2;
    end;
}

