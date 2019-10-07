tableextension 50034 Ext_RequisitionLine extends "Requisition Line"
{
    fields
    {
        field(50003; Inventory; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50004; "Cons. Reported last Month"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50005; "Cons. Rep. last Three Month"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50006; "Cons. Rep. Curr Month"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50007; "Expected Cons.(Curr Month)"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50008; "Re-Order  Quantity"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50009; "Safety Stock"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50010; "Maximum Order Quantity"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50011; "Minimum Order Quantity"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50012; "Requisition Quantity"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50013; "Suggested Order Quantity"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50015; "Last Purchase Date"; Date)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50016; "Last Purchase Price"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50017; "Average Purchase Price"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50018; "Lead Time"; Code[10])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50019; "Expected Purchase Value"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50020; "Qty. On Purchase Order"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50021; "Req From Sales Order"; Decimal)
        {
            Description = 'Deepak';
        }
        field(51002; "Run Date & Time"; DateTime)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(51003; "Inventory Available for Days"; Integer)
        {
            Description = 'Deepak';
            Editable = false;
        }
    }
    procedure CalcPlan(WorksheetTemplateName: Code[20]; JournalBatchName: Code[20]; ItemCategoryCode: Code[20]; ProdGroupCode: Code[20]; SuggestQty: Boolean; SalesRequired: Boolean)
    var
        ItemMaster: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemPlaningLine: Record "Requisition Line";
        ThreeMonthStartDate: Date;
        LastMonthStartDate: Date;
        LastMonthEndDate: Date;
        CurrMonthEndDate: Date;
        CurrMonthStartDate: Date;
        Day: Integer;
        Month: Integer;
        NewDate: Date;
        ProdOrderComp: Record "Prod. Order Component";
        TempQty: Decimal;
        Vendor: Record Vendor;
        ReqHeader: Record "Requisition Header";
        ReqLine: Record "Requisition Line SAM";
        PurchaseLine: Record "Purchase Line";
        LineNumber: Integer;
        CumPurchaseValue: Decimal;
        CumPurchaseQty: Decimal;
        SalesBufferTable: Record "Sales Req Buffer";
        TemNoOfDays: Integer;
    begin


        // Lines added bY deepak Kumar


        if SalesRequired = true then begin
            CalculateSalesPlan;
        end;

        ItemPlaningLine.Reset;
        ItemPlaningLine.SetFilter(ItemPlaningLine."Worksheet Template Name", WorksheetTemplateName);
        ItemPlaningLine.SetFilter(ItemPlaningLine."Journal Batch Name", JournalBatchName);
        if ItemPlaningLine.FindFirst then begin
            ItemPlaningLine.DeleteAll;
        end;

        ItemMaster.Reset;
        ItemMaster.SetRange(ItemMaster."Replenishment System", ItemMaster."Replenishment System"::Purchase);
        ItemMaster.SetRange(ItemMaster.Blocked, false);
        if ItemCategoryCode <> '' then
            ItemMaster.SetRange(ItemMaster."Item Category Code", ItemCategoryCode);
        // if ProdGroupCode <> '' then
        //     ItemMaster.SetRange(ItemMaster."Product Group Code", ProdGroupCode);

        if ItemMaster.FindFirst then begin

            ThreeMonthStartDate := CalcDate('CM-4M+1D', Today);
            LastMonthStartDate := CalcDate('CM-2M+1D', Today);
            CurrMonthStartDate := CalcDate('CM-1m+1d', Today);
            LastMonthEndDate := CalcDate('CM-1m', Today);
            CurrMonthEndDate := CalcDate('CM', Today);
            TemNoOfDays := CurrMonthStartDate - ThreeMonthStartDate;
            // MESSAGE('%1 %2 %3',LastMonthEndDate,ThreeMonthStartDate,TemNoOfDays);
            LineNumber := 10000;
            repeat
                ItemPlaningLine.Init;
                ItemPlaningLine."Worksheet Template Name" := WorksheetTemplateName;
                ItemPlaningLine."Journal Batch Name" := JournalBatchName;
                LineNumber := LineNumber + 10;
                ItemPlaningLine."Line No." := LineNumber;
                ItemPlaningLine.Type := ItemPlaningLine.Type::Item;
                ItemPlaningLine.Validate("No.", ItemMaster."No.");
                ItemPlaningLine."Action Message" := ItemPlaningLine."Action Message"::New;
                ItemMaster.CalcFields(ItemMaster.Inventory);
                ItemPlaningLine.Inventory := ItemMaster.Inventory;
                ItemPlaningLine."Re-Order  Quantity" := ItemMaster."Reorder Point";
                ItemPlaningLine."Safety Stock" := ItemMaster."Safety Stock Quantity";
                ItemPlaningLine."Maximum Order Quantity" := ItemMaster."Maximum Order Quantity";
                ItemPlaningLine."Minimum Order Quantity" := ItemMaster."Minimum Order Quantity";
                ItemPlaningLine."Last Purchase Price" := ItemMaster."Last Direct Cost";
                ItemPlaningLine.Insert(true);



                TempQty := 0;
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", ItemMaster."No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Posting Date", ThreeMonthStartDate, LastMonthEndDate);
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Entry Type", 'Negative Adjmt.|Consumption');
                if ItemLedgerEntry.FindFirst then begin
                    repeat
                        TempQty := TempQty + ItemLedgerEntry.Quantity;
                    until ItemLedgerEntry.Next = 0;
                    ItemPlaningLine."Cons. Rep. last Three Month" := Abs(TempQty);
                    ItemPlaningLine.Modify(true);
                end;
                ItemPlaningLine."Inventory Available for Days" := Round((ItemPlaningLine."Cons. Rep. last Three Month" / TemNoOfDays), 1);
                if ItemPlaningLine."Inventory Available for Days" = 0 then
                    ItemPlaningLine."Inventory Available for Days" := 1;

                ItemPlaningLine."Inventory Available for Days" := Round((ItemPlaningLine.Inventory / ItemPlaningLine."Inventory Available for Days"), 1);


                TempQty := 0;
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", ItemMaster."No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Posting Date", LastMonthStartDate, LastMonthEndDate);
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Entry Type", 'Negative Adjmt.|Consumption');
                if ItemLedgerEntry.FindFirst then begin
                    repeat
                        TempQty := TempQty + ItemLedgerEntry.Quantity;
                    until ItemLedgerEntry.Next = 0;
                    ItemPlaningLine."Cons. Reported last Month" := Abs(TempQty);
                    ItemPlaningLine.Modify(true);
                end;

                TempQty := 0;
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", ItemMaster."No.");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Posting Date", CurrMonthStartDate, CurrMonthEndDate);
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Entry Type", 'Negative Adjmt.|Consumption');
                if ItemLedgerEntry.FindFirst then begin
                    repeat
                        TempQty := TempQty + ItemLedgerEntry.Quantity;
                    until ItemLedgerEntry.Next = 0;
                    ItemPlaningLine."Cons. Rep. Curr Month" := Abs(TempQty);
                    ItemPlaningLine.Modify(true);
                end;

                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", ItemMaster."No.");
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Entry Type", 'Purchase');
                if ItemLedgerEntry.FindLast then begin
                    ItemPlaningLine."Last Purchase Date" := ItemLedgerEntry."Posting Date";
                    ItemPlaningLine.Modify(true);
                end;

                CumPurchaseValue := 0;
                CumPurchaseQty := 0;
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
                ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", ItemMaster."No.");
                ItemLedgerEntry.SetFilter(ItemLedgerEntry."Entry Type", 'Purchase');
                if ItemLedgerEntry.FindFirst then begin
                    repeat
                        CumPurchaseValue += ItemLedgerEntry."Cost Amount (Actual)";
                        CumPurchaseQty += ItemLedgerEntry.Quantity;
                    until ItemLedgerEntry.Next = 0;
                    if CumPurchaseQty = 0 then
                        CumPurchaseQty := 1;
                    ItemPlaningLine."Average Purchase Price" := CumPurchaseValue / CumPurchaseQty;
                    ItemPlaningLine.Modify(true);
                end;

                // Lines added  BY Deepak Kumar
                TempQty := 0;
                PurchaseLine.Reset;
                PurchaseLine.SetRange(PurchaseLine.Type, PurchaseLine.Type::Item);
                PurchaseLine.SetRange(PurchaseLine."No.", ItemMaster."No.");
                if PurchaseLine.FindFirst then begin
                    repeat
                        TempQty := TempQty + PurchaseLine."Outstanding Quantity";
                    until PurchaseLine.Next = 0;
                    ItemPlaningLine."Qty. On Purchase Order" := TempQty;
                    ItemPlaningLine.Modify(true);
                end;

                ProdOrderComp.Reset;
                ProdOrderComp.SetRange(ProdOrderComp.Status, ProdOrderComp.Status::Released);
                ProdOrderComp.SetRange(ProdOrderComp."Item No.", ItemMaster."No.");
                ProdOrderComp.SetRange(ProdOrderComp."Due Date", 0D, WorkDate);
                if ProdOrderComp.FindFirst then begin
                    repeat
                        ItemPlaningLine."Expected Cons.(Curr Month)" += ProdOrderComp."Remaining Quantity";
                    until ProdOrderComp.Next = 0;
                    ItemPlaningLine.Modify(true);
                end;
                if SalesRequired = true then begin
                    TempQty := 0;
                    SalesBufferTable.Reset;
                    SalesBufferTable.SetRange(SalesBufferTable."Item Code", ItemMaster."No.");
                    if SalesBufferTable.FindFirst then begin
                        repeat
                            TempQty := TempQty + SalesBufferTable.Quantity;
                        until SalesBufferTable.Next = 0;
                        ItemPlaningLine."Req From Sales Order" := TempQty;
                        ItemPlaningLine.Modify(true);
                    end;
                end;


                TempQty := 0;
                ReqLine.Reset;
                ReqLine.SetRange(ReqLine."Item No.", ItemMaster."No.");
                ReqLine.SetFilter(ReqLine."Remaining Quantity", '<>0');
                if ReqLine.FindFirst then begin
                    repeat
                        ReqHeader.Reset;
                        ReqHeader.SetRange(ReqHeader."Requisition No.", ReqLine."Requisition No.");
                        //ReqHeader.SETRANGE(ReqHeader.Status,1);
                        if ReqHeader.FindFirst then begin
                            TempQty := TempQty + ReqLine."Remaining Quantity";
                        end;
                    until ReqLine.Next = 0;
                    ItemPlaningLine."Requisition Quantity" := TempQty;
                    ItemPlaningLine.Modify(true);
                end;

                // Lines for Suggest Quantity
                /*
                TempQty:=0;
                TempQty:=(ItemPlaningLine.Inventory+ItemPlaningLine."Qty. On Purchase Order")-(ItemPlaningLine."Expected Cons.(Curr Month)"+ItemPlaningLine."Safety Stock");
                IF TempQty <= 0 THEN BEGIN
                  ItemPlaningLine."Suggested Order Quantity":=(ItemPlaningLine."Expected Cons.(Curr Month)"+ItemPlaningLine."Safety Stock")-ItemPlaningLine.Inventory-ItemPlaningLine."Qty. On Purchase Order";
                  IF SuggestQty = TRUE THEN
                  ItemPlaningLine.Quantity:=ItemPlaningLine."Expected Cons.(Curr Month)";
                END;
                ItemPlaningLine."Expected Purchase Value":=ItemPlaningLine."Last Purchase Price"*ItemPlaningLine.Quantity;

                IF TempQty > 0 THEN BEGIN
                  ItemPlaningLine."Suggested Order Quantity":=0;
                  ItemPlaningLine.Quantity:=0;
                END;
                */ //Commented as logic change was requested by EPP . New logic -- Suggested Order Quantity = Avg. Monthly Consumption
                   //Pulak 08-05-15 Begin
                ItemPlaningLine."Suggested Order Quantity" := (ItemPlaningLine."Cons. Rep. last Three Month" / 3);
                ItemPlaningLine.Quantity := ItemPlaningLine."Suggested Order Quantity";
                ItemPlaningLine."Expected Purchase Value" := ItemPlaningLine."Last Purchase Price" * ItemPlaningLine.Quantity;
                //Pulak 08-05-15 End
                ItemPlaningLine.Modify(true);
                /*IF ItemPlaningLine."Suggested Order Quantity" = 0 THEN
                  ItemPlaningLine.DELETE(TRUE);*/
            until ItemMaster.Next = 0;
            Message('Complete');
        end;

    end;

    procedure CalculateSalesPlan()
    var
        SalesOrderLine: Record "Sales Line";
        SalesPlaningBuffer: Record "Sales Req Buffer";
        ItemMaster: Record Item;
        ProdOrderBOMLine: Record "Production BOM Line";
        LastEntryno: Integer;
        BOMLine: Record "Production BOM Line";
    begin
        // Lines added by Deepak Kumar
        if SalesPlaningBuffer.FindFirst then begin
            SalesPlaningBuffer.DeleteAll;
        end;

        LastEntryno := 1;
        SalesOrderLine.Reset;
        SalesOrderLine.SetRange(SalesOrderLine.Type, SalesOrderLine.Type::Item);
        SalesOrderLine.SetFilter(SalesOrderLine."Outstanding Quantity", '<>0');
        if SalesOrderLine.FindFirst then begin
            repeat
                ItemMaster.Reset;
                ItemMaster.SetRange(ItemMaster."No.", SalesOrderLine."No.");
                if ItemMaster.FindFirst then begin
                    ProdOrderBOMLine.Reset;
                    ProdOrderBOMLine.SetRange(ProdOrderBOMLine."Production BOM No.", ItemMaster."Production BOM No.");
                    if ProdOrderBOMLine.FindFirst then begin
                        repeat
                            if ProdOrderBOMLine.Type = 1 then begin
                                LastEntryno := LastEntryno + 1;
                                SalesPlaningBuffer.Init;
                                SalesPlaningBuffer."Entry Number" := LastEntryno;
                                SalesPlaningBuffer.Validate("Item Code", ProdOrderBOMLine."No.");
                                SalesPlaningBuffer.Quantity := ProdOrderBOMLine."Quantity per" * SalesOrderLine."Outstanding Quantity";
                                SalesPlaningBuffer."Sales Order Number" := SalesOrderLine."Document No.";
                                SalesPlaningBuffer."Sales Order Line" := SalesOrderLine."Line No.";
                                SalesPlaningBuffer."Quantity Per" := ProdOrderBOMLine."Quantity per";
                                SalesPlaningBuffer."Sales Order Outstanding Qty" := SalesOrderLine."Outstanding Quantity";
                                SalesPlaningBuffer.Insert(true);
                            end;
                            if ProdOrderBOMLine.Type = 2 then begin
                                BOMLine.Reset;
                                BOMLine.SetRange(BOMLine."Production BOM No.", ProdOrderBOMLine."No.");
                                if BOMLine.FindFirst then begin
                                    repeat
                                        LastEntryno := LastEntryno + 1;
                                        SalesPlaningBuffer.Init;
                                        SalesPlaningBuffer."Entry Number" := LastEntryno;
                                        SalesPlaningBuffer.Validate("Item Code", BOMLine."No.");
                                        SalesPlaningBuffer.Quantity := BOMLine."Quantity per" * SalesOrderLine."Outstanding Quantity";
                                        SalesPlaningBuffer."Sales Order Number" := SalesOrderLine."Document No.";
                                        SalesPlaningBuffer."Sales Order Line" := SalesOrderLine."Line No.";
                                        SalesPlaningBuffer."Quantity Per" := BOMLine."Quantity per";
                                        SalesPlaningBuffer."Sales Order Outstanding Qty" := SalesOrderLine."Outstanding Quantity";
                                        SalesPlaningBuffer.Insert(true);

                                    until BOMLine.Next = 0;
                                end;
                            end;
                        until ProdOrderBOMLine.Next = 0;
                    end;
                end;
            until SalesOrderLine.Next = 0;
        end;
    end;

}