codeunit 50010 "Finish Pro Order ReOpen"
{

    trigger OnRun()
    begin
        //RPO_No := 'PRO/18/05959';
        //POReOpen;
        //UpdateAttComp;
        //UpdateItemLedger;
        //UpdatePurchLine;
        Message('Done');
    end;

    var
        ProdOrder: Record "Production Order";
        ProdOrder_New: Record "Production Order";
        ProdOrdLine: Record "Prod. Order Line";
        ProdOrdLine_New: Record "Prod. Order Line";
        ProdOrdRout: Record "Prod. Order Routing Line";
        ProdOrdRout_New: Record "Prod. Order Routing Line";
        ProdOrdComp: Record "Prod. Order Component";
        ProdOrdComp_New: Record "Prod. Order Component";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentHeader: Record "Sales Shipment Header";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ProductionOrder: Record "Production Order";
        SalesHeader: Record "Sales Header";
        ProductDesignHeader: Record "Product Design Header";
        PurchaseLine: Record "Purchase Line";

    procedure POReOpen(RPO_No: Code[20])
    begin
        //UserSetup.GET(USERID);
        //UserSetup.TESTFIELD(UserSetup."Re-Open Prod. Order Authority");

        ProdOrdRout.Reset;
        ProdOrdRout.SetRange(ProdOrdRout.Status,4);
        ProdOrdRout.SetRange(ProdOrdRout."Prod. Order No.",RPO_No);
        if  ProdOrdRout.FindFirst then
          repeat
            ProdOrdRout_New.Init;
            ProdOrdRout_New:= ProdOrdRout;
            ProdOrdRout_New.Status:=  ProdOrdRout_New.Status::Released;
            ProdOrdRout_New.Insert();
            ProdOrdRout.Delete;
          until ProdOrdRout.Next  = 0;

        ProdOrdComp.Reset;
        ProdOrdComp.SetRange(ProdOrdComp.Status,4);
        ProdOrdComp.SetRange(ProdOrdComp."Prod. Order No.",RPO_No);
        if  ProdOrdComp.FindFirst then
          repeat
            ProdOrdComp_New.Init;
            ProdOrdComp_New:= ProdOrdComp;
            ProdOrdComp_New.Status:=  ProdOrdComp_New.Status::Released;
            ProdOrdComp_New.Insert();
            ProdOrdComp.Delete;
          until ProdOrdComp.Next  = 0;

        ProdOrdLine.Reset;
        ProdOrdLine.SetRange(ProdOrdLine.Status,4);
        ProdOrdLine.SetRange(ProdOrdLine."Prod. Order No.",RPO_No);
        if  ProdOrdLine.FindFirst then
          repeat
            ProdOrdLine_New.Init;
            ProdOrdLine_New:= ProdOrdLine;
            ProdOrdLine_New.Status:=  ProdOrdLine_New.Status::Released;
            ProdOrdLine_New.Insert();
            ProdOrdLine.Delete;
          until ProdOrdLine.Next  = 0;

        ProdOrder.Reset;
        ProdOrder.SetRange(ProdOrder.Status,4);
        ProdOrder.SetRange(ProdOrder."No.",RPO_No);
        if ProdOrder.FindFirst then
          repeat
            ProdOrder_New.Init;
            ProdOrder_New:= ProdOrder ;
            ProdOrder_New.Status:=  ProdOrder_New.Status::Released ;
            ProdOrder_New.Insert();
            ProdOrder.Delete;
          until ProdOrder.Next  = 0;
    end;

    local procedure UpdateAttComp()
    var
        DailyAttendance: Record "Daily Attendance";
    begin
        DailyAttendance.Reset;
        DailyAttendance.SetFilter(DailyAttendance.Date,'230818D');
        if DailyAttendance.FindFirst then begin
          repeat
            DailyAttendance.Validate("Non-Working",false);
            DailyAttendance.Validate("Attendance Type",DailyAttendance."Attendance Type"::Present);
            DailyAttendance.Validate(Holiday,0);
            DailyAttendance.Validate(Present,1);
            DailyAttendance.Modify;
          until DailyAttendance.Next = 0;
        end;
    end;

    local procedure UpdateItemLedger()
    begin
        /*
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETFILTER(ItemLedgerEntry."Entry No.",'<>%1',0);
        ItemLedgerEntry.SETFILTER(ItemLedgerEntry."Item Category Code",'%1|%2|%3','FG','FG_SUB','FG SUB 3');
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Salesperson Code",'');
        IF ItemLedgerEntry.FINDFIRST THEN
          REPEAT
            SalesShipmentHeader.RESET;
            SalesShipmentHeader.SETRANGE(SalesShipmentHeader."No.",ItemLedgerEntry."Document No.");
            IF SalesShipmentHeader.FINDFIRST THEN BEGIN
              ItemLedgerEntry."Sales Order No." := SalesShipmentHeader."Order No.";
              ItemLedgerEntry."Salesperson Code" := SalesShipmentHeader."Salesperson Code";
            END ELSE BEGIN
              ItemLedgerEntry."Sales Order No." := '';
              ItemLedgerEntry."Salesperson Code" := '';
            END;
        
            ReturnReceiptHeader.RESET;
            ReturnReceiptHeader.SETRANGE(ReturnReceiptHeader."No.",ItemLedgerEntry."Document No.");
            IF ReturnReceiptHeader.FINDFIRST THEN BEGIN
              ItemLedgerEntry."Sales Order No." := ReturnReceiptHeader."Return Order No.";
              ItemLedgerEntry."Salesperson Code" := ReturnReceiptHeader."Salesperson Code";
            END ELSE BEGIN
              ItemLedgerEntry."Sales Order No." := '';
              ItemLedgerEntry."Salesperson Code" := '';
            END;
        
            ProductionOrder.RESET;
            ProductionOrder.SETRANGE("No.",ItemLedgerEntry."Order No.");
            IF ProductionOrder.FINDFIRST THEN BEGIN
              ItemLedgerEntry."Sales Order No." := ProductionOrder."Sales Order No.";
              ItemLedgerEntry."Salesperson Code" := ProductionOrder."Salesperson Code";
            END ELSE BEGIN
              ItemLedgerEntry."Sales Order No." := '';
              ItemLedgerEntry."Salesperson Code" := '';
            END;
        
            SalesHeader.RESET;
            SalesHeader.SETRANGE(SalesHeader."No.",ItemLedgerEntry."Sales Order No.");
            IF SalesHeader.FINDFIRST THEN
              ItemLedgerEntry."Salesperson Code" := SalesHeader."Salesperson Code"
            ELSE
              ItemLedgerEntry."Salesperson Code" := '';
             ItemLedgerEntry.MODIFY;
          UNTIL ItemLedgerEntry.NEXT = 0;
          */
          //Mpower
        
        /*
        ProductDesignHeader.RESET;
        ProductDesignHeader.SETFILTER(ProductDesignHeader."Sales Order No.",'<>%1','');
        IF ProductDesignHeader.FINDSET THEN
          REPEAT
            SalesHeader.RESET;
            SalesHeader.SETRANGE(SalesHeader."Document Type",SalesHeader."Document Type"::Order);
            SalesHeader.SETRANGE(SalesHeader."No.",ProductDesignHeader."Sales Order No.");
            IF SalesHeader.FINDFIRST THEN BEGIN
              ProductDesignHeader."Sales Person Code" := SalesHeader."Salesperson Code";
              ProductDesignHeader.MODIFY;
            END;
          UNTIL ProductDesignHeader.NEXT = 0;
        
        */
        /*
        ProductionOrder.RESET;
        ProductionOrder.SETRANGE(ProductionOrder.Status,ProductionOrder.Status::Released);
        IF ProductionOrder.FINDSET THEN
          REPEAT
            SalesHeader.RESET;
            SalesHeader.SETRANGE(SalesHeader."Document Type",SalesHeader."Document Type"::Order);
            SalesHeader.SETRANGE(SalesHeader."No.",ProductionOrder."Sales Order No.");
            IF SalesHeader.FINDFIRST THEN BEGIN
              ProductionOrder."Salesperson Code" := SalesHeader."Salesperson Code";
              ProductionOrder.MODIFY;
            END;
          UNTIL ProductionOrder.NEXT = 0;
        */

    end;

    local procedure UpdatePurchLine()
    begin
        PurchaseLine.Reset;
        PurchaseLine.SetRange(PurchaseLine."Document Type",PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(PurchaseLine."Document No.",'PO/15-16/0035');
        PurchaseLine.SetRange(PurchaseLine."For Location Roll Entry",PurchaseLine."For Location Roll Entry"::Mother);
        PurchaseLine.SetRange(PurchaseLine."No.",'PAPER00081');
        if PurchaseLine.FindFirst then begin
          PurchaseLine.Validate(PurchaseLine."Qty. Rcd. Not Invoiced (Base)",0);
          PurchaseLine.Validate(PurchaseLine."Qty. Received (Base)",0);
          PurchaseLine.Validate(PurchaseLine."Outstanding Qty. (Base)",0);
          PurchaseLine.Validate(PurchaseLine."Outstanding Quantity",0);
          PurchaseLine.Validate(PurchaseLine."Qty. Rcd. Not Invoiced",0);
          PurchaseLine.Validate(PurchaseLine."Quantity Received",0);
          PurchaseLine.Modify;
        end;
    end;
}

