codeunit 50012 TableSubscriberMgmt
{
    var
        UserSetup: Record "User Setup";

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeInsertEvent', '', false, false)]
    local procedure Customer_OnBeforeInsertEvent(var Rec: Record Customer; RunTrigger: Boolean)
    var
        SAM001: Label 'You don''t have to permission for Customer Master,for more information please contact your System Administrator';
    begin
        IF RunTrigger then begin
            UserSetup.Reset();
            UserSetup.SETFILTER(UserSetup."User ID", USERID);
            UserSetup.SETRANGE(UserSetup.Customer, TRUE);
            IF NOT UserSetup.FINDFIRST THEN
                ERROR(SAM001);
            // Lines added by Deepak Kumar
            Rec.Blocked := 3;
            Rec."Created / Modified By" := USERID;
            Rec."Created On" := Today;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterInsertEvent', '', false, false)]
    local procedure Customer_OnAfterInsertEvent(var Rec: Record Customer; RunTrigger: Boolean)

    begin
        Rec."Bill-to Customer No." := Rec."No.";
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Credit Limit (LCY)', false, false)]
    local procedure Customer_CreditLimitLCY_OnAfterValidateEvent(var Rec: Record Customer; xRec: Record Customer)
    begin
        if (Rec."Credit Limit (LCY)" = 0) OR (xRec."Credit Limit (LCY)" <> Rec."Credit Limit (LCY)") then
            Rec.TestField("Cust. Credit Buffer(LCY)", 0);
        Rec."Credit Limit (LCY) Base" := Rec."Credit Limit (LCY)"
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeModifyEvent', '', false, false)]
    local procedure Customer_OnBeforeModifyEvent(var Rec: Record Customer; RunTrigger: Boolean)
    var
        SAM001: Label 'You don''t have to permission for Customer Master,for more information please contact your System Administrator';
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        ApprovalEntry: Record "Approval Entry";
        flag: Boolean;
    begin
        //Lines Modified by Deepak kumar
        IF RunTrigger then begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Approver ID", UserId);
            ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordId);
            if NOT ApprovalEntry.FindFirst then
                RecordRestrictionMgt.CheckRecordHasUsageRestrictions(Rec);
            UserSetup.Reset();
            UserSetup.SETFILTER(UserSetup."User ID", USERID);
            UserSetup.SETRANGE(UserSetup.Customer, true);
            IF UserSetup.FINDFIRST THEN BEGIN
                Rec.Blocked := Rec.Blocked::All; //suhail
                Rec."Created / Modified By" := USERID;
                Rec.ItemApprove := false;
            end else
                ERROR(SAM001);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 21, 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //Mpower --
        CustLedgerEntry."Cheque No." := GenJournalLine."Cheque No.";
        CustLedgerEntry."Cheque Date" := GenJournalLine."Cheque Date";
        //Mpower ++
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeInsertEvent', '', false, false)]
    local procedure Vendor_OnBeforeInsertEvent(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        SAM001: Label 'You don''t have to permission for Vendor Master,for more information please contact your System Administrator';
    begin
        UserSetup.Reset();
        UserSetup.SETFILTER(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Vendor, TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR(SAM001);
        // Lines added by Deepak Kumar
        Rec.Blocked := 2;
        Rec."Created / Modified By" := USERID;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeModifyEvent', '', false, false)]
    local procedure Vendor_OnBeforeModifyEvent(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        SAM001: Label 'You don''t have to permission for Vendor Master,for more information please contact your System Administrator';
    begin
        UserSetup.RESET;
        UserSetup.SETFILTER(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Vendor, TRUE);
        IF UserSetup.FINDFIRST THEN BEGIN
            //Blocked:=2;
            IF UserSetup."Approval Authority Vendor" = TRUE THEN BEGIN
                //Blocked:=0;
                Rec."Approved By" := USERID;
            END ELSE BEGIN
                Rec."Created / Modified By" := USERID;
            END;
            Rec."Created / Modified By" := USERID;
            Rec."Last Date Modified" := TODAY;
        END ELSE BEGIN
            ERROR(SAM001);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeValidateEvent', 'Blocked', false, false)]
    local procedure Vendor__Blocked_OnBeforeValidateEvent(var Rec: Record "Vendor"; var xRec: Record "Vendor")
    begin
        // Lines added by deepak kUmar
        Rec.TESTFIELD(Name);
        Rec.TESTFIELD("Vendor Posting Group");
        Rec.TESTFIELD("Payment Terms Code");
        Rec.TESTFIELD("Gen. Bus. Posting Group");
        IF (Rec.Blocked = Rec.Blocked::All) OR (Rec.Blocked = Rec.Blocked::Payment) THEN
            Rec.BlockRecord;
        IF Rec.Blocked = Rec.Blocked::" " THEN
            Rec.UnBlockRecord;
        Rec.MODIFY;
    end;

    [EventSubscriber(ObjectType::Table, 25, 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //Mpower --
        VendorLedgerEntry."Cheque No." := GenJournalLine."Cheque No.";
        VendorLedgerEntry."Cheque Date" := GenJournalLine."Cheque Date";
        //Mpower ++
    end;

    // [EventSubscriber(ObjectType::Table, 36, 'OnBeforeValidateEvent', 'Sell-to Customer No.', false, false)]
    // local procedure SelltoCustomerNo__OnBeforeValidateEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    // var
    //     Cust: Record Customer;
    // begin
    //     Cust.GET(Rec."Sell-to Customer No.");
    //     Cust."Credit Limit (LCY)" += Cust."Cust. Credit Buffer(LCY)";
    //     Cust.Modify();
    // end;


    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure SelltoCustomerNo__OnAfterValidateEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        Cust: Record Customer;
    begin
        Cust.GET(Rec."Sell-to Customer No.");
        // Cust."Credit Limit (LCY)" := Cust."Credit Limit (LCY)" - Cust."Cust. Credit Buffer(LCY)";
        // Cust.Modify();
        Rec."Due Date Calculated By Month" := Cust."Due Date Calculated By Month";
        // Lines added BY deepak kUmar


        IF Rec."Document Type" = Rec."Document Type"::"Delivery Order" THEN
            Rec.GetDocumentCheckList(Rec."Sell-to Customer No.", Rec."No.");
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Posting Date', false, false)]
    local procedure PostingDate__OnAfterValidateEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        PaymentTerms: Record "Payment Terms";
        MonthLastDate: Date;
    begin
        // Lines added By Deepak Kumar
        IF Rec."Due Date Calculated By Month" THEN BEGIN
            PaymentTerms.GET(Rec."Payment Terms Code");
            IF Rec."Posting Date" = 0D THEN BEGIN
                MonthLastDate := CALCDATE('cm', TODAY);
            END ELSE BEGIN
                MonthLastDate := CALCDATE('cm', REc."Posting Date");
            END;
            Rec."Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", MonthLastDate);
            Rec.VALIDATE("Due Date");

        END;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeInsertEvent', '', false, false)]
    local procedure Item_OnBeforeInsertEvent(var Rec: Record Item; RunTrigger: Boolean)
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.CheckItemAuth(USERID);
        Rec.Blocked := true;
        Rec.Status := Rec.Status::"Pending Approval";
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeModifyEvent', '', false, false)]
    local procedure Item_OnBeforeModifyEvent(var Rec: Record Item; RunTrigger: Boolean)
    var
        UserSetup: Record "User Setup";
    begin
        if RunTrigger then
            UserSetup.CheckItemAuth(USERID);

    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure Item_OnBeforeDeleteEvent(var Rec: Record Item; RunTrigger: Boolean)
    var
        EstimateHeader: Record 50000;
        ItemAttributeEntry: Record "Item Attribute Entry";
    begin
        If RunTrigger then begin
            ERROR('Item Delete is Restricted, Please Contact your Administrator');

            EstimateHeader.RESET;
            EstimateHeader.SETRANGE(EstimateHeader."Item Code", Rec."No.");
            IF EstimateHeader.FINDFIRST THEN
                ERROR('The Estimate No %1 exists for the item', EstimateHeader."Product Design No.");
            ItemAttributeEntry.Reset();
            ItemAttributeEntry.SETRANGE(ItemAttributeEntry."Item No.", Rec."No.");
            ItemAttributeEntry.DELETEALL;
        end;

    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Item Category Code', false, false)]
    local procedure ItemCategoryCode__OnAfterValidateEvent(var Rec: Record Item; var xRec: Record Item)
    var
        ItemCategory: Record "Item Category";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
    begin
        IF Rec."Item Category Code" <> xRec."Item Category Code" THEN BEGIN
            IF ItemCategory.GET(Rec."Item Category Code") THEN BEGIN
                IF Rec."Gen. Prod. Posting Group" = '' THEN
                    Rec.VALIDATE("Gen. Prod. Posting Group", ItemCategory."Def. Gen. Prod. Posting Group");
                IF (Rec."VAT Prod. Posting Group" = '') OR
                    (GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, Rec."Gen. Prod. Posting Group") AND
                    (Rec."Gen. Prod. Posting Group" = ItemCategory."Def. Gen. Prod. Posting Group") AND
                    (Rec."VAT Prod. Posting Group" = GenProdPostingGrp."Def. VAT Prod. Posting Group"))
                THEN
                    Rec.VALIDATE("VAT Prod. Posting Group", ItemCategory."Def. VAT Prod. Posting Group");
                IF Rec."Inventory Posting Group" = '' THEN
                    Rec.VALIDATE("Inventory Posting Group", ItemCategory."Def. Inventory Posting Group");
                IF Rec."Tax Group Code" = '' THEN
                    Rec.VALIDATE("Tax Group Code", ItemCategory."Def. Tax Group Code");
                Rec.VALIDATE("Costing Method", ItemCategory."Def. Costing Method");

                Rec."Roll ID Applicable" := ItemCategory."Roll ID Applicable";
                Rec."PO Quantity Variation %" := ItemCategory."PO Quantity Variation %";
                Rec."Replenishment System" := ItemCategory."Def. Replenishment System";
                Rec."Manufacturing Policy" := ItemCategory."Def. Manufacturing Policy";
                Rec."QA Enable" := ItemCategory."QA Enable";
                //"QA Enable":=ItemCategory."QA Enable";
                Rec."Tariff No." := ItemCategory."Tariff No.";
                Rec."Global Dimension 1 Code" := ItemCategory."Global Dimension 1 Code";
                Rec."Global Dimension 2 Code" := ItemCategory."Global Dimension 2 Code";
                Rec."Reordering Policy" := ItemCategory."Reordering Policy";
                Rec."Minimum Order Quantity" := ItemCategory."Minimum Order Quantity";
                Rec."Maximum Order Quantity" := ItemCategory."Maximum Order Quantity";
                Rec."Safety Stock Quantity" := ItemCategory."Safety Stock Quantity";

                IF ItemCategory."Plate Item" THEN BEGIN
                    Rec."Plate Item" := TRUE;
                    Rec."Inventory Value Zero" := TRUE;
                END;
                Rec.Modify();
            END;
        END;
    End;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'External Document No.', false, false)]
    local procedure ExternalDocumentNo__OnAfterValidateEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        TempSalesLine: Record "Sales Line";
        TempSalesHeader: Record "Sales Header";
    begin
        // Lines added BY Deepak Kumar
        IF Rec."External Document No." = '' THEN
            EXIT;

        //IF "Blanket Order No." <> '' THEN BEGIN
        TempSalesHeader.RESET;
        TempSalesHeader.SETRANGE(TempSalesHeader."Document Type", TempSalesHeader."Document Type"::Order);
        TempSalesHeader.SETRANGE(TempSalesHeader."Sell-to Customer No.", Rec."Sell-to Customer No.");
        TempSalesHeader.SETRANGE(TempSalesHeader."External Document No.", Rec."External Document No.");
        IF TempSalesHeader.FINDFIRST THEN
            MESSAGE('The External Document No. Already Exist in Document No. %1', TempSalesHeader."No.");
        //END;

        TempSalesLine.RESET;
        TempSalesLine.SETRANGE(TempSalesLine."Document Type", TempSalesLine."Document Type"::Order);
        TempSalesLine.SETRANGE(TempSalesLine."Document No.", Rec."No.");
        IF TempSalesLine.FINDFIRST THEN BEGIN
            REPEAT
                TempSalesLine."External Doc. No." := Rec."External Document No.";
                TempSalesLine.MODIFY(TRUE);
            UNTIL TempSalesLine.NEXT = 0;
        END;
    END;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterTestNoSeries', '', false, false)]
    local procedure OnAfterTestNoSeries(var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        // Lines addede BY deepak kumar
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Delivery Order" then
            SalesSetup.TESTFIELD("Delivery Order No Series");
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure OnAfterGetNoSeriesCode(var SalesHeader: Record "Sales Header"; SalesReceivablesSetup: Record "Sales & Receivables Setup"; var NoSeriesCode: Code[20])
    begin
        // Lines added BY deepak Kumar
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Delivery Order" then
            NoSeriesCode := SalesReceivablesSetup."Delivery Order No Series";
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure SalesLine_OnAfterInitOutstandingQty(var SalesLine: Record "Sales Line")
    begin
        IF not (SalesLine."Document Type" IN [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"]) THEN BEGIN
            // Lines added By Deepak Kumar
            SalesLine."Order Quantity (Weight)" := ROUND(SalesLine.Quantity * (SalesLine."Net Weight" / 1000), 0.00001);
            SalesLine."Outstanding  Quantity (Weight)" := ROUND((SalesLine."Quantity (Base)" - SalesLine."Qty. Shipped (Base)") * (SalesLine."Net Weight" / 1000), 0.00001);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignItemValues', '', false, false)]
    local procedure SalesLine_OnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        EstimateHeader: Record "Product Design Header";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        SalesLine."External Doc. No." := SalesHeader."External Document No.";// Deepak
        SalesLine."LPO(Order) Date" := SalesHeader."Order Date";//deepak
        SalesLine."Salesperson Code" := SalesHeader."Salesperson Code";//deepak

        //      Item.TESTFIELD(Item."Net Weight (Gms) Customer");
        SalesLine."Net Weight" := Item."Net Weight" * SalesLine."Qty. per Unit of Measure";
        // lInes added BY deepak Kumar
        /*
        IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN BEGIN
            IF Item."Estimate No." <> '' THEN
                SalesLine."Estimation No." := Item."Estimate No."
            ELSE BEGIN
                EstimateHeader.RESET;
                EstimateHeader.SETRANGE(EstimateHeader."Item Code", SalesLine."No.");
                IF EstimateHeader.FINDFIRST THEN
                    SalesLine."Estimation No." := EstimateHeader."Product Design No.";

            END;
            EstimateHeader.RESET;
            EstimateHeader.SETRANGE(EstimateHeader."Product Design No.", Item."Estimate No.");
            IF EstimateHeader.FINDFIRST THEN BEGIN
                IF SalesLine."Currency Code" <> '' THEN BEGIN
                    SalesHeader.RESET;
                    SalesHeader.SETRANGE(SalesHeader."Document Type", SalesLine."Document Type");
                    SalesHeader.SETRANGE(SalesHeader."No.", SalesLine."Document No.");
                    IF SalesHeader.FINDFIRST THEN BEGIN
                        SalesLine."Estimate Price" := EstimateHeader."Amount Per Unit" * SalesHeader."Currency Factor";
                        //VALIDATE("Unit Price",(Estimate."Amount Per Unit"*SalesHeader."Currency Factor"));
                    END;
                END ELSE BEGIN
                    SalesLine."Estimate Price" := EstimateHeader."Amount Per Unit";
                    SalesLine."Estimation No." := EstimateHeader."Product Design No.";
                END;
            END;
        END; 
        */
        IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN BEGIN
            IF Item."Estimate No." <> '' THEN BEGIN //Mpower
                EstimateHeader.RESET;
                EstimateHeader.SETRANGE(EstimateHeader."Product Design No.", Item."Estimate No.");
                IF EstimateHeader.FINDFIRST THEN BEGIN
                    IF EstimateHeader.Status = EstimateHeader.Status::Blocked THEN
                        ERROR('PDI %1 on this FG %2 is not approved, Kindly approved the PDI first')
                    ELSE
                        SalesLine."Estimation No." := Item."Estimate No.";
                END;
            END ELSE BEGIN
                EstimateHeader.RESET;
                EstimateHeader.SETRANGE(EstimateHeader."Item Code", SalesLine."No.");
                IF EstimateHeader.FINDFIRST THEN BEGIN
                    IF EstimateHeader.Status = EstimateHeader.Status::Blocked THEN
                        ERROR('PDI %1 is not approved Kindly approve the PDI')
                    ELSE
                        SalesLine."Estimation No." := EstimateHeader."Product Design No.";
                END;
            END;
            EstimateHeader.RESET;
            EstimateHeader.SETRANGE(EstimateHeader."Product Design No.", Item."Estimate No.");
            IF EstimateHeader.FINDFIRST THEN BEGIN
                IF SalesLine."Currency Code" <> '' THEN BEGIN
                    IF SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") THEN BEGIN
                        SalesLine."Estimate Price" := EstimateHeader."Amount Per Unit" * SalesHeader."Currency Factor";
                        //VALIDATE("Unit Price",(Estimate."Amount Per Unit"*SalesHeader."Currency Factor"));
                    END;
                END ELSE BEGIN
                    SalesLine."Estimate Price" := EstimateHeader."Amount Per Unit";
                    SalesLine."Estimation No." := EstimateHeader."Product Design No.";
                END;
            END;
        END;

    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Quantity', false, false)]
    local procedure SalesLine_Quantity_OnOnBeforeValidateEvent(var Rec: Record "Sales Line")
    begin
        // Lines added by Deepak Kumar
        IF (Rec."Document Type" = Rec."Document Type"::"Delivery Order") AND (Rec.Quantity > 0) THEN
            Rec.ValidateOrder;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterInitQtyToShip', '', false, false)]
    local procedure SalesLine_OnAfterInitQtyToShip(VAR SalesLine: Record "Sales Line"; CurrFieldNo: Integer)
    var
        EstimateCostLine: Record "Product Design Special Descrip";
        PostedSalesInvoice: Record "Sales Invoice Line";
    begin
        IF SalesLine.Type = SalesLine.Type::"G/L Account" then begin
            EstimateCostLine.Reset;
            EstimateCostLine.SetRange(EstimateCostLine."No.", SalesLine."Estimation No.");
            EstimateCostLine.SetRange(EstimateCostLine.Category, EstimateCostLine.Category::Cost);
            if EstimateCostLine.FindFirst then begin
                repeat
                    if EstimateCostLine.Occurrence = EstimateCostLine.Occurrence::Once then begin
                        PostedSalesInvoice.Reset;
                        PostedSalesInvoice.SetRange(PostedSalesInvoice."Estimation No.", EstimateCostLine."No.");
                        PostedSalesInvoice.SetRange(PostedSalesInvoice."Estimate Additional Cost", true);
                        PostedSalesInvoice.SetFilter(PostedSalesInvoice."Cross-Reference No.", EstimateCostLine."Cost Code");
                        PostedSalesInvoice.SetRange(PostedSalesInvoice.Type, PostedSalesInvoice.Type::"G/L Account");
                        if PostedSalesInvoice.FindFirst then begin
                            SalesLine."Qty. to Ship" := 0;
                            SalesLine."Qty. to Ship (Base)" := 0;
                            SalesLine."Qty. to Invoice" := 0;
                            SalesLine."Qty. to Invoice (Base)" := 0;
                        END else begin
                            SalesLine."Qty. to Ship" := SalesLine.Quantity;
                            SalesLine."Qty. to Ship (Base)" := SalesLine.Quantity;
                            SalesLine."Qty. to Invoice" := SalesLine.Quantity;
                            SalesLine."Qty. to Invoice (Base)" := SalesLine.Quantity;
                        END;
                    End;
                until EstimateCostLine.Next = 0;
            END ElsE BEgin
                SalesLine."Qty. to Ship" := SalesLine.Quantity;
                SalesLine."Qty. to Ship (Base)" := SalesLine.Quantity;
                SalesLine."Qty. to Invoice" := SalesLine.Quantity;
                SalesLine."Qty. to Invoice (Base)" := SalesLine.Quantity;
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterSetDefaultQuantity', '', false, false)]
    local procedure SalesLine_OnAfterSetDefaultQuantity(VAR SalesLine: Record "Sales Line"; VAR xSalesLine: Record "Sales Line")
    var
        EstimateCostLine: Record "Product Design Special Descrip";
        PostedSalesInvoice: Record "Sales Invoice Line";
        SalesLineNew: Record "Sales Line";
    begin
        IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND
        (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Quote]) then begin
            SalesLine."Qty. to Ship" := SalesLine.Quantity;
            SalesLine."Qty. to Ship (Base)" := SalesLine.Quantity;
        END;
        IF (SalesLine.Type = SalesLine.Type::"G/L Account") then begin
            SalesLine."Qty. to Invoice" := SalesLine.Quantity;
            SalesLine."Qty. to Invoice (Base)" := SalesLine.Quantity;
        end;

        IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND
            (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Quote]) then begin
            EstimateCostLine.Reset;
            EstimateCostLine.SetRange(EstimateCostLine."No.", SalesLine."Estimation No.");
            EstimateCostLine.SetRange(EstimateCostLine.Category, EstimateCostLine.Category::Cost);
            if EstimateCostLine.FindFirst then begin
                repeat
                    if EstimateCostLine.Occurrence = EstimateCostLine.Occurrence::Once then begin
                        PostedSalesInvoice.Reset;
                        PostedSalesInvoice.SetRange(PostedSalesInvoice."Estimation No.", EstimateCostLine."No.");
                        PostedSalesInvoice.SetRange(PostedSalesInvoice."Estimate Additional Cost", true);
                        PostedSalesInvoice.SetFilter(PostedSalesInvoice."Cross-Reference No.", EstimateCostLine."Cost Code");
                        PostedSalesInvoice.SetRange(PostedSalesInvoice.Type, PostedSalesInvoice.Type::"G/L Account");
                        if PostedSalesInvoice.FindFirst then begin
                            SalesLine."Qty. to Ship" := 0;
                            SalesLine."Qty. to Ship (Base)" := 0;
                            SalesLine."Qty. to Invoice" := 0;
                            SalesLine."Qty. to Invoice (Base)" := 0;
                        END;
                    End;
                until EstimateCostLine.Next = 0;
            END;
        end;
    end;


    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Qty. to Ship', false, false)]
    local procedure SalesLine_QtytoShip_OnOnBeforeValidateEvent(var Rec: Record "Sales Line")
    begin
        // Lines added by Deepak Kumar
        IF (Rec."Document Type" = Rec."Document Type"::"Delivery Order") AND (Rec.Quantity > 0) THEN
            Rec.ValidateOrder;
        Rec.UpdateAmounts;//Deepak
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Qty. to Ship', false, false)]
    local procedure SalesLine_QtytoShip_OnAfterValidateEvent(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ExtraAllowedQty: Decimal;
        CustomerMaster: Record Customer;
        Text007: Label 'You cannot ship more than %1 units and %2 buffer Unit.';
        Text008: Label 'You cannot ship more than %1 base units and %2 buffer base Unit.';
        SRSetup: Record "Sales & Receivables Setup";
    begin
        // Lines added bY deepak Kumar
        IF (Rec."Document Type" <> Rec."Document Type"::"Blanket Order") THEN BEGIN
            CustomerMaster.GET(Rec."Sell-to Customer No.");
            IF CustomerMaster."Conditional Shipping Tolerance" = TRUE THEN BEGIN
                ExtraAllowedQty := (Rec.Quantity * CustomerMaster."Conditional Ship Tolerance %") / 100;
            END ELSE BEGIN
                SRSetup.GET;
                ExtraAllowedQty := (Rec.Quantity * SRSetup."Sales Variation Allowed %") / 100;
            END;
        end ELSE
            IF (Rec."Document Type" = Rec."Document Type"::"Blanket Order") AND (xRec."Qty. to Ship" < 0) THEN BEGIN
                CustomerMaster.GET(Rec."Sell-to Customer No.");
                IF CustomerMaster."Conditional Shipping Tolerance" = TRUE THEN BEGIN
                    ExtraAllowedQty := (Rec.Quantity * CustomerMaster."Conditional Ship Tolerance %") / 100;
                END ELSE BEGIN
                    SRSetup.GET;
                    ExtraAllowedQty := (Rec.Quantity * SRSetup."Sales Variation Allowed %") / 100;
                END;
            end;
        IF (((Rec."Qty. to Ship" < 0) XOR (Rec.Quantity < 0)) AND (Rec.Quantity <> 0) AND (Rec."Qty. to Ship" <> 0)) OR
           (ABS(Rec."Qty. to Ship") > ABS(Rec."Outstanding Quantity" + ExtraAllowedQty)) OR
           (((Rec.Quantity < 0) XOR ((Rec."Outstanding Quantity" + ExtraAllowedQty) < 0)) AND (Rec.Quantity <> 0) AND (Rec."Outstanding Quantity" <> 0))
        THEN
            ERROR(
              Text007,
              Rec."Outstanding Quantity", ExtraAllowedQty);
        IF (((Rec."Qty. to Ship (Base)" < 0) XOR (Rec."Quantity (Base)" < 0)) AND (Rec."Qty. to Ship (Base)" <> 0) AND (Rec."Quantity (Base)" <> 0)) OR
           (ABS(Rec."Qty. to Ship (Base)") > ABS(Rec."Outstanding Qty. (Base)" + ExtraAllowedQty)) OR
           (((Rec."Quantity (Base)" < 0) XOR ((Rec."Outstanding Qty. (Base)" + ExtraAllowedQty) < 0)) AND (Rec."Quantity (Base)" <> 0) AND ((Rec."Outstanding Qty. (Base)" + ExtraAllowedQty) <> 0))
        THEN
            ERROR(
              Text008,
              Rec."Outstanding Qty. (Base)", ExtraAllowedQty);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Unit Price', false, false)]
    local procedure SalesLine_UnitPrice_OnAfterValidateEvent(var Rec: Record "Sales Line")
    begin
        Rec.GetCompSalePrice;
        // lines added by deepak kumar
        IF Rec."Net Weight" <> 0 THEN
            Rec."Rate Per KG" := (Rec."Unit Price" / Rec."Net Weight") * 1000;
        Rec.QuoteVariation();
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignItemUOM', '', false, false)]
    local procedure SalesLine_OnAfterAssignItemUOM(var SalesLine: Record "Sales Line"; Item: Record Item)
    begin
        SalesLine."Gross Weight" := Item."Gross Weight" * SalesLine."Qty. per Unit of Measure";
        SalesLine."Net Weight" := Item."Net Weight" * SalesLine."Qty. per Unit of Measure";
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Requested Delivery Date', false, false)]
    local procedure SalesLine_RequestedDeliveryDate_OnAfterValidateEvent(var Rec: Record "Sales Line")
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        // Lines incoporated BY Deepak Kumar
        IF Rec."Document Type" = Rec."Document Type"::Order THEN BEGIN
            ProdOrderLine.RESET;
            ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.", Rec."Prod. Order No.");
            IF ProdOrderLine.FINDFIRST THEN
                ProdOrderLine.MODIFYALL(ProdOrderLine."Sales Requested Delivery Date", Rec."Requested Delivery Date");
        END;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignGLAccountValues', '', false, false)]
    local procedure PurchaseLine_OnAfterAssignGLAccountValues(var PurchLine: Record "Purchase Line"; GLAccount: Record "G/L Account")
    begin
        PurchLine."Allow Item Charge Assignment" := TRUE;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignItemValues', '', false, false)]
    local procedure PurchaseLine_OnAfterAssignItemValues(var PurchLine: Record "Purchase Line"; Item: Record Item)
    begin
        //Lines added BY deepak Kumar
        PurchLine.MILL := Item.Supplier;
        PurchLine.Paper := Item."Roll ID Applicable";
        PurchLine."Paper Type" := Item."Paper Type";
        PurchLine."Paper GSM" := FORMAT(Item."Paper GSM");
        PurchLine."FSC Category" := Item."FSC Category";
        //end//deepak
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Qty. to Receive', false, false)]
    local procedure PurchaseLine_QtytoReceive_OnAfterValidateEvent(var Rec: Record "Purchase Line")
    var
        ItemMaster: Record Item;
        VariationQuantity: Decimal;
        Text008: Label 'You cannot receive more than %1 units.';
        Text009: Label 'You cannot receive more than %1 base units.';
    begin
        //Lines added BY Deepak Kumar
        VariationQuantity := 0;
        IF Rec.Type = Rec.Type::Item THEN BEGIN
            ItemMaster.RESET;
            ItemMaster.SETRANGE(ItemMaster."No.", Rec."No.");
            IF ItemMaster.FINDFIRST THEN BEGIN
                VariationQuantity := (Rec."Outstanding Quantity" * ItemMaster."PO Quantity Variation %") / 100;
            END;
        END;



        IF (((Rec."Qty. to Receive" < 0) XOR (Rec.Quantity < 0)) AND (Rec.Quantity <> 0) AND (Rec."Qty. to Receive" <> 0)) OR
           (ABS(Rec."Qty. to Receive") > ABS(Rec.Quantity + VariationQuantity)) OR
           (((Rec.Quantity < 0) OR ((Rec.Quantity + VariationQuantity) < 0)) AND (Rec.Quantity <> 0) AND ((Rec.Quantity + VariationQuantity) <> 0))
        THEN
            ERROR(
              Text008,
              (Rec."Outstanding Quantity" + VariationQuantity));
        IF (((Rec."Qty. to Receive (Base)" < 0) XOR (Rec."Quantity (Base)" < 0)) AND (Rec."Quantity (Base)" <> 0) AND (Rec."Qty. to Receive (Base)" <> 0)) OR
           (ABS(Rec."Qty. to Receive (Base)") > ABS(Rec.Quantity + VariationQuantity)) OR
           (((Rec."Quantity (Base)" < 0) XOR ((Rec.Quantity + VariationQuantity) < 0)) AND (Rec."Quantity (Base)" <> 0) AND ((Rec.Quantity + VariationQuantity) <> 0))
        THEN
            ERROR(
              Text009,
              (Rec.Quantity + VariationQuantity));

    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignItemUOM', '', false, false)]
    local procedure PurchaseLine_OnAfterAssignItemUOM(var PurchLine: Record "Purchase Line"; Item: Record Item)
    begin
        PurchLine."Gross Weight" := Item."Gross Weight" * PurchLine."Qty. per Unit of Measure";
        PurchLine."Net Weight" := Item."Net Weight" * PurchLine."Qty. per Unit of Measure";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterSetupNewLine', '', false, false)]
    local procedure GenJournalLine_OnAfterSetupNewLine(var GenJournalLine: Record "Gen. Journal Line"; GenJournalTemplate: Record "Gen. Journal Template"; GenJournalBatch: Record "Gen. Journal Batch"; LastGenJournalLine: Record "Gen. Journal Line"; Balance: Decimal; BottomLine: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
        IF GenJnlLine.FINDFIRST THEN BEGIN
            GenJournalLine."Parking No." := LastGenJournalLine."Document No."; //Mpower
            IF BottomLine AND (Balance - LastGenJournalLine."Balance (LCY)" = 0) AND NOT LastGenJournalLine.EmptyLine THEN
                GenJournalLine."Parking No." := GenJournalLine."Document No.";
        END ELSE
            IF GenJournalBatch."No. Series" <> '' THEN BEGIN
                GenJournalLine."Parking No." := GenJournalLine."Document No.";
            END;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure ItemJournalLine_No_OnAfterValidateEvent(var Rec: Record "Item Journal Line")
    var
        Item: Record Item;
    begin
        Item.Get(Rec."Item No.");
        Rec."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterValidateEvent', 'Order No.', false, false)]
    local procedure ItemJournalLine_OrderNo_OnAfterValidateEvent(var Rec: Record "Item Journal Line")
    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProductDesignHeader: Record "Product Design Header";
        MfgSetup: Record "Manufacturing Setup";
    begin
        IF Rec."Order Type" IN [Rec."Order Type"::Production, Rec."Order Type"::Assembly] then BEGIN
            IF Rec."Order No." = '' THEN
                EXIT;
        END;
        IF Rec."Order Type" = Rec."Order Type"::Production then BEGIN
            ProdOrder.GET(ProdOrder.Status::Released, Rec."Order No.");
            ProdOrder.TESTFIELD(Blocked, FALSE);
            MfgSetup.Get();
            // Lines added By Deepak Kumar
            IF MfgSetup."PD Approval Mandatory" = TRUE THEN BEGIN
                ProdOrder.TESTFIELD(ProdOrder."Estimate Code");
                ProductDesignHeader.RESET;
                ProductDesignHeader.SETRANGE(ProductDesignHeader."Product Design Type", ProductDesignHeader."Product Design Type"::Main);
                ProductDesignHeader.SETRANGE(ProductDesignHeader."Product Design No.", ProdOrder."Estimate Code");
                IF ProductDesignHeader.FINDFIRST THEN BEGIN
                    ProductDesignHeader.TESTFIELD(ProductDesignHeader.Status, ProductDesignHeader.Status::Approved);
                END;
            END;
            // Lines end Deepak
        end;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterValidateEvent', 'Variant Code', false, false)]
    local procedure ItemJournalLine_VariantCode_OnAfterValidateEvent(var Rec: Record "Item Journal Line")
    var
        RollMaster: Record "Item Variant";
    begin
        // Lines added BY Deepak Kumar
        IF Rec."Entry Type" = Rec."Entry Type"::Consumption THEN BEGIN
            Rec.TESTFIELD("Order No.");
            Rec.TESTFIELD("Order Line No.");
        END;

        RollMaster.RESET;
        RollMaster.SETRANGE(RollMaster.Code, Rec."Variant Code");
        IF RollMaster.FINDFIRST THEN BEGIN
            RollMaster.CALCFIELDS("Remaining Quantity", RollMaster.CurrentLocation);
            Rec."Location Code" := RollMaster.CurrentLocation;
            Rec."Roll Inventory" := RollMaster."Remaining Quantity";
        END;
    END;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterValidateEvent', 'Operation No.', false, false)]
    local procedure ItemJournalLine_OperationNo_OnAfterValidateEvent(var Rec: Record "Item Journal Line")
    var
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        MfgSetup: Record "Manufacturing Setup";
        ProdOrderLine: Record "Prod. Order Line";
        EstimateHeader: Record "Product Design Header";
        ItemVariant: Record "Item Variant";
    begin
        Rec.TESTFIELD(Rec."Order Type", Rec."Order Type"::Production);
        Rec.TESTFIELD("Order No.");
        Rec.TESTFIELD("Operation No.");
        ProdOrderRtngLine.GET(ProdOrderRtngLine.Status::Released,
        Rec."Order No.", Rec."Routing Reference No.", Rec."Routing No.", Rec."Operation No.");
        IF ProdOrderRtngLine."Work Center No." = 'WC0002' THEN BEGIN

            // Lines added BY Deepak Kumar
            MfgSetup.GET();
            IF MfgSetup."Die Mandatory" = TRUE THEN BEGIN
                ProdOrderLine.RESET;
                ProdOrderLine.SETRANGE(ProdOrderLine.Status, ProdOrderLine.Status::Released);
                ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.", Rec."Order No.");
                ProdOrderLine.SETRANGE(ProdOrderLine."Line No.", Rec."Order Line No.");
                IF ProdOrderLine.FINDFIRST THEN BEGIN
                    EstimateHeader.RESET;
                    //EstimateHeader.SETRANGE(EstimateHeader."Product Design Type",ProdOrderLine."Product Design Type");
                    EstimateHeader.SETRANGE(EstimateHeader."Product Design No.", ProdOrderLine."Product Design No.");
                    EstimateHeader.SETRANGE(EstimateHeader."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                    IF EstimateHeader.FINDFIRST THEN BEGIN
                        IF EstimateHeader."Die Punching" THEN BEGIN
                            Rec."Die Number" := EstimateHeader."Die Number";
                            //       MODIFY(TRUE);
                        END;
                    END;
                END;
            END;
        END ELSE BEGIN
            Rec."Die Number" := '';
        END;

        IF ProdOrderRtngLine."Work Center No." = 'WC0002' THEN BEGIN
            // Lines added BY Deepak Kumar
            MfgSetup.GET();
            IF MfgSetup."Printing Plate Active" = TRUE THEN BEGIN
                ProdOrderLine.RESET;
                ProdOrderLine.SETRANGE(ProdOrderLine.Status, ProdOrderLine.Status::Released);
                ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.", Rec."Order No.");
                ProdOrderLine.SETRANGE(ProdOrderLine."Line No.", Rec."Order Line No.");
                IF ProdOrderLine.FINDFIRST THEN BEGIN
                    EstimateHeader.RESET;
                    //EstimateHeader.SETRANGE(EstimateHeader."Product Design Type",ProdOrderLine."Product Design Type");
                    EstimateHeader.SETRANGE(EstimateHeader."Product Design No.", ProdOrderLine."Product Design No.");
                    EstimateHeader.SETRANGE(EstimateHeader."Sub Comp No.", ProdOrderLine."Sub Comp No.");
                    IF EstimateHeader.FINDFIRST THEN BEGIN
                        IF EstimateHeader."Plate Required" = TRUE THEN BEGIN
                            Rec."Plate Item" := EstimateHeader."Plate Item No.";
                            ItemVariant.RESET;
                            ItemVariant.SETRANGE(ItemVariant."Item No.", Rec."Plate Item");
                            ItemVariant.SETRANGE(ItemVariant."Active Variant", TRUE);
                            IF ItemVariant.FINDFIRST THEN
                                Rec."Plate Variant" := ItemVariant.Code;
                            Rec."Plate Item No. 2" := EstimateHeader."Plate Item No. 2";
                            ItemVariant.RESET;
                            ItemVariant.SETRANGE(ItemVariant."Item No.", Rec."Plate Item No. 2");
                            ItemVariant.SETRANGE(ItemVariant."Active Variant", TRUE);
                            IF ItemVariant.FINDFIRST THEN
                                Rec."Plate Variant 2" := ItemVariant.Code;
                        END;
                    END;
                END;
            END;
        END ELSE BEGIN
            Rec."Plate Item" := '';
            Rec."Plate Item No. 2" := '';
        END;
    END;

    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeValidateEvent', 'Output Quantity', false, false)]
    local procedure ItemJournalLine_OutputQuantity_OnBeforeValidateEvent(var Rec: Record "Item Journal Line")
    var
        SubcontractedErr: Label '%1 must be zero in line number %2 because it is linked to the subcontracted work center.';
    begin
        Rec.TESTFIELD("Entry Type", Rec."Entry Type"::Output);
        IF Rec.SubcontractingWorkCenterUsed AND (Rec."Output Quantity" <> 0) THEN
            ERROR(SubcontractedErr, Rec.FIELDCAPTION("Output Quantity"), Rec."Line No.");
        IF Rec."Additional Output" = false THEN
            Rec.CheckPreviousStageOutput(Rec."Order No.", Rec."Order Line No.", Rec."Operation No.", Rec."Output Quantity", 0);
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeValidateEvent', 'Quantity', false, false)]
    local procedure ItemJournalLine_Quantity_OnBeforeValidateEvent(var Rec: Record "Item Journal Line")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN BEGIN
            IF Rec."Entry Type" IN [Rec."Entry Type"::Consumption, Rec."Entry Type"::Output] THEN BEGIN
                IF Rec.Quantity < 0 THEN BEGIN
                    IF NOT UserSetup."Allow Reverse Con/Output" THEN
                        ERROR('You do not have permission to reverse this entry, Kindly Contact System Administrator');
                END;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterValidateEvent', 'Starting Time', false, false)]
    local procedure ItemJournalLine_StartingTime_OnAfterValidateEvent(var Rec: Record "Item Journal Line")
    begin
        //Lines added by Deepak Kumar
        Rec.ValidateShiftTime;
        Rec.UpdateRunTime();
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterValidateEvent', 'Ending Time', false, false)]
    local procedure ItemJournalLine_EndingTime_OnAfterValidateEvent(var Rec: Record "Item Journal Line")
    begin
        //Lines added by Deepak Kumar
        Rec.ValidateShiftTime;
        Rec.UpdateRunTime();
    end;

    [EventSubscriber(ObjectType::Table, 114, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure SalesCrMemoHeader_OnBeforeDeleteEvent(var Rec: Record "Sales Cr.Memo Header"; RunTrigger: Boolean)
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;

    [EventSubscriber(ObjectType::Table, 124, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure PurchCrMemoHdr_OnBeforeDeleteEvent(var Rec: Record "Purch. Cr. Memo Hdr."; RunTrigger: Boolean)
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;

    [EventSubscriber(ObjectType::Table, 125, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure PurchCrMemoLine_OnBeforeDeleteEvent(var Rec: Record "Purch. Cr. Memo Line"; RunTrigger: Boolean)
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;

    [EventSubscriber(ObjectType::Table, 5401, 'OnBeforeInsertEvent', '', false, false)]
    local procedure ItemVariant_OnBeforeInsertEvent(var Rec: Record "Item Variant"; RunTrigger: Boolean)
    var
        ItemIdentifier: Record "Item Identifier";
        Item: Record Item;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        // Lines added BY Deepak Kumar
        IF Rec.Code = '' THEN BEGIN
            PurchSetup.GET;
            PurchSetup.TESTFIELD(PurchSetup."Paper Roll No Series");
            NoSeriesMgt.InitSeries(PurchSetup."Paper Roll No Series", '', 0D, Rec.Code, PurchSetup."Paper Roll No Series");
        END;
        ValidateItemVariant(Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 5401, 'OnAfterInsertEvent', '', false, false)]
    local procedure ItemVariant_OnAfterInsertEvent(var Rec: Record "Item Variant"; RunTrigger: Boolean)
    var
        ItemIdentifier: Record "Item Identifier";
        Item: Record Item;
    begin
        // Lines added BY Deepak Kumar for Update Item Identifier
        ItemIdentifier.INIT;
        ItemIdentifier.Code := Rec."Item No." + Rec.Code;
        ItemIdentifier."Item No." := Rec."Item No.";
        ItemIdentifier."Variant Code" := Rec.Code;
        Item.GET(Rec."Item No.");
        ItemIdentifier."Unit of Measure Code" := Item."Base Unit of Measure";
        ItemIdentifier.INSERT(TRUE);
    end;

    LOCAL procedure ValidateItemVariant(VariantCode: Code[50])
    var
        ItemVariant: Record "Item Variant";
    begin
        // Lines added BY Deepak Kumar
        ItemVariant.RESET;
        ItemVariant.SETRANGE(ItemVariant.Code, VariantCode);
        IF ItemVariant.FINDFIRST THEN BEGIN
            ERROR('%1 already exists', VariantCode);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 5401, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure ItemVariant_OnBeforeDeleteEvent(var Rec: Record "Item Variant"; RunTrigger: Boolean)
    var
        ItemIdentifier: Record "Item Identifier";
        Item: Record Item;
        PurchaseLine: Record "Purchase Line";
    begin
        ItemIdentifier.RESET;
        ItemIdentifier.SETRANGE(ItemIdentifier.Code, (Rec."Item No." + Rec.Code));
        IF ItemIdentifier.FINDFIRST THEN
            ItemIdentifier.DELETE;

        Rec.TESTFIELD(Rec.Status, Rec.Status::" ");
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETRANGE(PurchaseLine."Document No.", Rec."Document No.");
        PurchaseLine.SETRANGE(PurchaseLine."For Location Roll Entry", PurchaseLine."For Location Roll Entry"::Child);
        PurchaseLine.SETRANGE(PurchaseLine."Variant Code", Rec.Code);
        IF PurchaseLine.FINDFIRST THEN
            PurchaseLine.DELETE;
    end;

    [EventSubscriber(ObjectType::Table, 5401, 'OnAfterValidateEvent', 'Code', false, false)]
    local procedure ItemVariant_Code_OnAfterValidateEvent(var Rec: Record "Item Variant")
    begin
        ValidateItemVariant(Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 5401, 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure ItemVariant_ItemNo_OnAfterValidateEvent(var Rec: Record "Item Variant")
    var
        Item: Record Item;
    begin
        Item.GET(Rec."Item No.");
        Rec.Description := Item.Description;
    end;

    [EventSubscriber(ObjectType::Table, 5406, 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure ProdOrderLine_OnAfterValidateEvent(var Rec: Record "Prod. Order Line")
    var
        Item: Record Item;
    begin
        Item.GET(Rec."Item No.");
        Rec."Item Category Code" := Item."Item Category Code";
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure ProdOrderComponent_ItemNo_OnAfterValidateEvent(var Rec: Record "Prod. Order Component")
    var
        Item: Record Item;
    begin
        Item.GET(Rec."Item No.");
        Rec."Item Category Code" := Item."Item Category Code";
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnAfterValidateEvent', 'Unit of Measure Code', false, false)]
    local procedure ProdOrderComponent_UOM_OnAfterValidateEvent(var Rec: Record "Prod. Order Component"; var xRec: Record "Prod. Order Component")
    begin
        if Rec."Substitute Item" = true then
            Rec.VALIDATE("Expected Quantity", Rec."Expected Quantity");
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnAfterValidateEvent', 'Routing Link Code', false, false)]
    local procedure ProdOrderComponent_RoutingLinkCode_OnAfterValidateEvent(var Rec: Record "Prod. Order Component"; var xRec: Record "Prod. Order Component")
    begin
        if Rec."Substitute Item" = true then
            Rec.VALIDATE("Expected Quantity", Rec."Expected Quantity");
    end;

    [EventSubscriber(ObjectType::Table, 5407, 'OnAfterValidateEvent', 'Calculation Formula', false, false)]
    local procedure ProdOrderComponent_CalculationFormula_OnAfterValidateEvent(var Rec: Record "Prod. Order Component"; var xRec: Record "Prod. Order Component")
    begin
        if Rec."Substitute Item" = true then
            Rec.VALIDATE("Expected Quantity", Rec."Expected Quantity");
    end;

    [EventSubscriber(ObjectType::Table, 5612, 'OnBeforeValidateEvent', 'FA Posting Group', false, false)]
    local procedure FADepreciationBook_FAPostingGroup_OnBeforeValidateEvent(var Rec: Record "FA Depreciation Book"; var xRec: Record "FA Depreciation Book")
    var
        FAPostingGroup: Record "FA Posting Group";
    begin
        // Lines added by Deepak kumar
        FAPostingGroup.Get(Rec."FA Posting Group");
        FAPostingGroup.TestField(FAPostingGroup."No. of Depreciation Year");
        if Rec."Depreciation Starting Date" = 0D then
            Rec."Depreciation Starting Date" := WorkDate;
        Rec.Validate("No. of Depreciation Years", FAPostingGroup."No. of Depreciation Year");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Restricted Record", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure RestrictedRecord_OnBeforeDeleteEvent(var Rec: Record "Restricted Record"; RunTrigger: Boolean)
    var
        Customer: Record Customer;
        RecRef: RecordRef;
        No: Code[20];
        FieldRef1: FieldRef;
    begin
        RecRef.Get(Rec."Record ID");
        Clear(FieldRef1);
        if RecRef.Number = 18 then begin
            FieldRef1 := recref.Field(1);
            with Customer do begin
                Customer.GET(FieldRef1.VALUE);
                TESTFIELD(Name);
                TESTFIELD(Address);
                TESTFIELD("Post Code");
                TESTFIELD("Phone No.");
                TESTFIELD("Salesperson Code");
                TESTFIELD("Customer Segment");
                TESTFIELD("Credit Limit (LCY)");
                TESTFIELD("Gen. Bus. Posting Group");
                TESTFIELD("Customer Posting Group");
                TESTFIELD("VAT Bus. Posting Group");
                TESTFIELD("Payment Terms Code");
                ItemApprove := TRUE;
                Blocked := Blocked::" ";
                "Approved / Blocked By" := USERID;
                MODIFY;
            end;
        end;
    end;

}
