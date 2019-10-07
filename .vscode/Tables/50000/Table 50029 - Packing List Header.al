table 50029 "Packing List Header"
{
    // version Packing List Samadhan


    fields
    {
        field(1; No; Code[20])
        {
            Editable = false;
        }
        field(2; "Prod. Order No."; Code[20])
        {
            TableRelation = "Production Order"."No." WHERE (Status = FILTER (Released | Finished));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Prod. Order No." <> xRec."Prod. Order No." then begin
                    PackingLine.Reset;
                    PackingLine.SetRange(PackingLine."Packing List No.", No);
                    if PackingLine.FindFirst then
                        Error('The Packing Line for the Document %1 exists. Please delete all lines to proceed', No)
                end;
                Validate("Prod. Order Line No.");
            end;
        }
        field(3; "Prod. Order Line No."; Integer)
        {
            InitValue = 10000;
            TableRelation = "Prod. Order Line"."Line No." WHERE ("Prod. Order No." = FIELD ("Prod. Order No."));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                Clear(PosQty);
                if "Prod. Order Line No." <> 0 then begin
                    ProdOrderLine.Reset;
                    ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                    ProdOrderLine.SetRange(ProdOrderLine."Line No.", "Prod. Order Line No.");
                    if ProdOrderLine.FindFirst then begin

                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::"Positive Adjmt.");
                        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Order No.", ProdOrderLine."Prod. Order No.");
                        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Order Line No.", ProdOrderLine."Line No.");
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", ProdOrderLine."Item No.");
                        IF ItemLedgerEntry.FINDFIRST THEN
                            repeat
                                PosQty := ItemLedgerEntry.Quantity;
                            until ItemLedgerEntry.Next = 0;

                        ProdOrderLine.CalcFields(ProdOrderLine."Packing List Qty");
                        "Item No." := ProdOrderLine."Item No.";
                        Item.Get("Item No.");
                        "Item Description" := Item.Description;
                        "Existing Packing List Qty." := ProdOrderLine."Packing List Qty";
                        "Order Quantity" := ProdOrderLine.Quantity;
                        "Total Finished Quantity" := ProdOrderLine."Finished Quantity";
                        "Qty in each pallet" := Item."Quantity Per Pallet";
                        "Available Qty for Packing" := ("Total Finished Quantity" + PosQty) - "Existing Packing List Qty.";
                        "Sales Order No." := ProdOrderLine."Sales Order No.";
                        "Sales Order Line No." := ProdOrderLine."Sales Order Line No.";
                        SalesHeader.Reset;
                        SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
                        SalesHeader.SetRange(SalesHeader."No.", ProdOrderLine."Sales Order No.");
                        if SalesHeader.FindFirst then begin
                            "Customer No." := SalesHeader."Sell-to Customer No.";
                            "Customer's Name" := SalesHeader."Bill-to Name";
                        end;
                    end;
                end;

            end;
        }
        field(4; "Item No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);//Deepak
            end;
        }
        field(5; "Order Quantity"; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);//Deepak
            end;
        }
        field(6; "Existing Packing List Qty."; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);//Deepak
            end;
        }
        field(7; "Available Qty for Packing"; Integer)
        {
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);//Deepak
            end;
        }
        field(8; "Qty in each pallet"; Integer)
        {
            Editable = true;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);//Deepak
            end;
        }
        field(9; "No. of Pallets"; Integer)
        {
            CalcFormula = Count ("Packing List Line" WHERE ("Packing List No." = FIELD (No),
                                                           Quantity = FILTER (> 0)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);//Deepak
            end;
        }
        field(10; "Total Finished Quantity"; Integer)
        {
            Editable = false;
            TableRelation = "Item Ledger Entry" WHERE ("Entry Type" = CONST (Output),
                                                       "Entry Type" = CONST ("Positive Adjmt."),
                                                       "Item No." = FIELD ("Item No."));
        }
        field(11; "Total Shipped Quantity"; Decimal)
        {
            CalcFormula = Sum ("Packing List Line".Quantity WHERE (Posted = CONST (true),
                                                                  "Packing List No." = FIELD (No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Sales Order No."; Code[20])
        {
            Editable = true;
            TableRelation = "Sales Line"."Document No." WHERE ("Document Type" = CONST (Order),
                                                        "Prod. Order No." = field ("Prod. Order No."));

            trigger OnValidate()
            begin
                // Lines added by Deepak Kumar
                SalesHeader.Reset;
                SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SetRange(SalesHeader."No.", "Sales Order No.");
                if SalesHeader.FindFirst then begin
                    "Customer No." := SalesHeader."Sell-to Customer No.";
                    "Customer's Name" := SalesHeader."Bill-to Name";
                end;
            end;
        }
        field(13; "Total Pallet Quantity"; Decimal)
        {
            CalcFormula = Sum ("Packing List Line".Quantity WHERE ("Packing List No." = FIELD (No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Item Description"; Text[250])
        {
            Editable = false;
        }
        field(15; "Prod. Order Pallet Quantity"; Decimal)
        {
            CalcFormula = Sum ("Packing List Line".Quantity WHERE ("Prod. Order No." = FIELD ("Prod. Order No."),
                                                                  "Return Recipt No" = FILTER ('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Item Ledger Entry Number"; Integer)
        {
            TableRelation = "Item Ledger Entry"."Entry No." WHERE ("Item No." = FIELD ("Item No."),
                                                                   Open = CONST (true));

            trigger OnValidate()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
            begin
                TestField(Status, Status::Open);

                //"Existing Packing List Qty.":=0;

                if "Item Ledger Entry Number" <> 0 then begin
                    ItemLedgerEntry.Reset;
                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry No.", "Item Ledger Entry Number");
                    if ItemLedgerEntry.FindFirst then begin
                        ProdOrderLine.Reset;
                        ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", ItemLedgerEntry."Order No.");
                        ProdOrderLine.SetRange(ProdOrderLine."Line No.", ItemLedgerEntry."Order Line No.");
                        if ProdOrderLine.FindFirst then begin
                            ProdOrderLine.CalcFields(ProdOrderLine."Packing List Qty");
                            "Item No." := ProdOrderLine."Item No.";
                            Item.Get("Item No.");
                            "Item Description" := Item.Description;
                            "Existing Packing List Qty." := ProdOrderLine."Packing List Qty";
                            "Order Quantity" := ProdOrderLine.Quantity;
                            "Total Finished Quantity" := ItemLedgerEntry.Quantity;
                            "Qty in each pallet" := Item."Quantity Per Pallet";
                            "Available Qty for Packing" := ItemLedgerEntry."Remaining Quantity";
                            "Sales Order No." := ProdOrderLine."Sales Order No.";
                            "Sales Order Line No." := ProdOrderLine."Sales Order Line No.";
                            "Prod. Order No." := ItemLedgerEntry."Order No.";
                            "Prod. Order Line No." := ItemLedgerEntry."Order Line No.";
                            SalesHeader.Reset;
                            SalesHeader.SetRange(SalesHeader."Document Type", SalesHeader."Document Type"::Order);
                            SalesHeader.SetRange(SalesHeader."No.", ProdOrderLine."Sales Order No.");
                            if SalesHeader.FindFirst then begin
                                "Customer No." := SalesHeader."Sell-to Customer No.";
                                "Customer's Name" := SalesHeader."Bill-to Name";
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(20; Type; Option)
        {
            OptionCaption = 'Production,Sales Return';
            OptionMembers = Production,"Sales Return";
        }
        field(21; "Return Recipt No."; Code[30])
        {
            TableRelation = IF (Type = CONST ("Sales Return")) "Return Receipt Header"."No.";
        }
        field(22; "Return Recipt Line No."; Integer)
        {
            TableRelation = "Return Receipt Line"."Line No." WHERE (Type = CONST (Item),
                                                                    "Document No." = FIELD ("Return Recipt No."));

            trigger OnValidate()
            var
                ReturnReciptLine: Record "Return Receipt Line";
                PackingLine: Record "Packing List Line";
                ExistingPackingListQtyTemp: Decimal;
                ItemLedgerEntry: Record "Item Ledger Entry";
            begin
                // Lines added By Deepak Kumar
                ReturnReciptLine.Reset;
                ReturnReciptLine.SetRange(ReturnReciptLine."Document No.", "Return Recipt No.");
                ReturnReciptLine.SetRange(ReturnReciptLine."Line No.", "Return Recipt Line No.");
                if ReturnReciptLine.FindFirst then begin
                    ExistingPackingListQtyTemp := 0;
                    PackingLine.Reset;
                    PackingLine.SetRange(PackingLine."Return Recipt No", ReturnReciptLine."Document No.");
                    PackingLine.SetRange(PackingLine."Return Recipt Line No.", ReturnReciptLine."Line No.");
                    if PackingLine.FindFirst then begin
                        repeat
                            ExistingPackingListQtyTemp += PackingLine.Quantity;
                        until PackingLine.Next = 0;
                    end;
                    "Item No." := ReturnReciptLine."No.";
                    Item.Get("Item No.");
                    "Item Description" := Item.Description;
                    "Existing Packing List Qty." := ExistingPackingListQtyTemp;
                    ItemLedgerEntry.Reset;
                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", ReturnReciptLine."Document No.");
                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Item No.", ReturnReciptLine."No.");
                    if ItemLedgerEntry.FindFirst then begin
                        "Prod. Order No." := ItemLedgerEntry."Order No.";
                    end;
                    "Order Quantity" := ReturnReciptLine.Quantity;
                    "Total Finished Quantity" := ReturnReciptLine.Quantity;
                    "Qty in each pallet" := Item."Quantity Per Pallet";
                    "Available Qty for Packing" := "Total Finished Quantity" - "Existing Packing List Qty.";
                end;
            end;
        }
        field(60; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(61; "Remaining Qty to Pack"; Integer)
        {
        }
        field(62; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(63; "Created  By"; Code[150])
        {
            Editable = false;
        }
        field(64; "Sales Order Line No."; Integer)
        {
            TableRelation = "Sales Line"."Line No." where ("Document Type" = const (order),
                                                            "Document No." = field ("Sales Order No."));

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                PackListHeader: Record "Packing List Header";
            begin
                IF "Sales Order Line No." <> 0 THEN BEGIN
                    SalesLine.RESET;
                    SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SETRANGE(SalesLine."Document No.", "Sales Order No.");
                    SalesLine.SETRANGE(SalesLine."Line No.", "Sales Order Line No.");
                    IF SalesLine.FINDFIRST THEN BEGIN
                        "Item No." := SalesLine."No.";
                        Item.GET("Item No.");
                        "Item Description" := Item.Description;
                        Item.CALCFIELDS(Inventory);
                        "Available Qty for Packing" := Item.Inventory;
                        PackListHeader.RESET;
                        PackListHeader.SETRANGE(PackListHeader."Item No.", "Item No.");
                        IF PackListHeader.FINDFIRST THEN
                            REPEAT
                                "Existing Packing List Qty." += PackListHeader."Total Pallet Quantity";
                            UNTIL PackListHeader.NEXT = 0;
                        "Order Quantity" := SalesLine.Quantity;
                        "Qty in each pallet" := Item."Quantity Per Pallet";
                        "Available Qty for Packing" := ("Available Qty for Packing") - "Existing Packing List Qty.";
                    END;
                END;
            end;
        }
        field(65; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer."No.";
        }
        field(66; "Customer's Name"; Text[80])
        {
            Editable = false;
        }
        field(67; "Packing List Status"; Option)
        {
            OptionCaption = 'Open,Pending for Approval,Approved,Rejected';
            OptionMembers = Open,"Pending for Approval",Approved,Rejected;
            Editable = false;

        }
        field(68; "Approved By"; Code[20])
        {
            Caption = 'Approved/Rejected By';
            Editable = false;

        }
        field(69; Remarks; Text[250])
        {

        }
    }

    keys
    {
        key(Key1; No)
        {
        }
        key(Key2; Type, No)
        {

        }

    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //Pulak 23-01-2015 begin
        PackingLine.Reset;
        PackingLine.SetRange(PackingLine."Packing List No.", No);
        if PackingLine.FindFirst then
            Error('The Packing Line for the Document %1 exists', No)
        //Pulak 23-01-2015 end
    end;

    trigger OnInsert()
    begin
        SalesSetup.Get();
        SalesSetup.TestField(SalesSetup."Packing List No Series");
        NoSeriesMngmt.InitSeries(SalesSetup."Packing List No Series", SalesSetup."Packing List No Series", Today, NewNo, SalesSetup."Packing List No Series");
        No := NewNo;
        "Creation Date" := Today; //Pulak 07-03-15
        "Created  By" := UserId;  //Pulak 07-03-15
        TestField(Status, Status::Open);
    end;

    trigger OnModify()
    begin
    end;

    var
        ProdOrderLine: Record "Prod. Order Line";
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMngmt: Codeunit NoSeriesManagement;
        NewNo: Code[20];
        Item: Record Item;
        PackingLine: Record "Packing List Line";
        PackingListHeader: Record "Packing List Header";
        Question: Text[150];
        Answer: Boolean;
        SalesHeader: Record "Sales Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PosQty: Decimal;

    procedure ReleasePackingList()
    begin
        // Lines added By Deepak Kumar
        PackingListHeader.Reset;
        PackingListHeader.SetRange(PackingListHeader.No, No);
        if PackingListHeader.FindFirst then begin
            if PackingListHeader.Status = PackingListHeader.Status::Released then begin
                Error('Document already in released State');
            end else begin

                Question := 'Do you want to Release the Packing List No. ' + PackingListHeader.No;
                Answer := DIALOG.Confirm(Question, true);
                if Answer = true then begin
                    PackingListHeader.Status := PackingListHeader.Status::Released;
                    PackingListHeader.Modify(true);
                end;
            end;

        end;
    end;

    procedure ReOpenPackingList()
    begin
        // Lines added By Deepak Kumar
        PackingListHeader.Reset;
        PackingListHeader.SetRange(PackingListHeader.No, No);
        if PackingListHeader.FindFirst then begin
            if PackingListHeader.Status = PackingListHeader.Status::Open then begin
                Error('Packing Document already in Open State');
            end else begin

                Question := 'Do you want to Open the Packing List No. ' + PackingListHeader.No;
                Answer := DIALOG.Confirm(Question, true);
                if Answer = true then begin
                    PackingListHeader.Status := PackingListHeader.Status::Open;
                    PackingListHeader.Modify(true);
                end;
            end;

        end;
    end;
}

