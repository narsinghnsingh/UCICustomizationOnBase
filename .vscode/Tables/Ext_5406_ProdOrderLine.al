tableextension 50044 Ext_ProdOrderLine extends "Prod. Order Line"
{
    fields
    {
        field(50001; "Prod Status"; Option)
        {
            OptionCaption = 'New,In process,Halt,Cancel';
            OptionMembers = New,"In process",Halt,Cancel;
        }
        field(50002; "Quality Spec. No."; Code[20])
        {
        }
        field(50004; "Sales Order No."; Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE ("Document Type" = CONST (Order));
        }
        field(50005; "Estimate Code"; Code[10])
        {
            Editable = false;
        }
        field(50006; "ArtWork Available"; Boolean)
        {
        }
        field(50007; "Printing Plate"; Code[20])
        {
        }
        field(50011; "Packing List Qty"; Decimal)
        {
            CalcFormula = Sum ("Packing List Line".Quantity WHERE ("Prod. Order No." = FIELD ("Prod. Order No."),
                                                                  "Item No." = FIELD ("Item No."),
                                                                  "Return Recipt No" = FILTER ('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Creation Date"; Date)
        {
            CalcFormula = Lookup ("Production Order"."Creation Date" WHERE ("No." = FIELD ("Prod. Order No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Sales Requested Delivery Date"; Date)
        {
            Editable = false;
        }
        field(50014; "Shift Code"; Code[10])
        {
            TableRelation = "Work Shift".Code;
        }
        field(50016; "Sales Order Line No."; Integer)
        {
        }
        field(50017; "Flute Type"; Text[10])
        {
        }
        field(50018; "No. of Ply"; Integer)
        {
        }
        field(50019; "Color Code"; Code[20])
        {
        }
        field(50020; "No. of Ups"; Integer)
        {
        }
        field(50021; "Sheet Item"; Boolean)
        {
        }
        field(50022; "SubJob Item"; Boolean)
        {
        }
        field(50023; "Item Category Code"; Code[20])
        {
            TableRelation = "Item Category";
        }
        field(50024; "Board Width (mm)"; Decimal)
        {
            Editable = false;
        }
        field(50027; "Board GSM"; Decimal)
        {
            Editable = false;
        }
        field(50028; "Board Ups"; Integer)
        {
            Editable = false;
        }
        field(50029; "Die Cut Ups"; Integer)
        {
            Editable = false;
            InitValue = 1;
            MaxValue = 100;
            MinValue = 1;
        }
        field(50030; "No of Joints"; Integer)
        {
            Editable = false;
            InitValue = 1;
            MaxValue = 100;
            MinValue = 1;
        }
        field(50031; "Actual Per Unit Weight"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            Editable = false;
        }
        field(51001; "Product Design Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;
        }
        field(51002; "Product Design No."; Code[50])
        {
            Editable = false;
        }
        field(51003; "Sub Comp No."; Code[20])
        {
            Editable = false;
        }
        field(51004; "LPO No."; Code[50])
        {
            CalcFormula = Lookup ("Sales Header"."External Document No." WHERE ("Document Type" = CONST (Order),
                                                                               "No." = FIELD ("Sales Order No.")));
            FieldClass = FlowField;
        }
        field(60001; "Material Approved by Store"; Boolean)
        {
            Editable = false;
        }
        field(60002; "Material Approved by Prod."; Boolean)
        {
            Editable = false;
        }
        field(60007; "Last Production Date"; Date)
        {
            CalcFormula = Max ("Capacity Ledger Entry"."Posting Date" WHERE ("Order No." = FIELD ("Prod. Order No.")));
            FieldClass = FlowField;
        }
        field(60009; "Last Despatch Date"; Date)
        {
            CalcFormula = Max ("Item Ledger Entry"."Posting Date" WHERE ("Entry Type" = CONST (Sale),
                                                                        "Prod. Order (Sale)" = FIELD ("Prod. Order No.")));
            FieldClass = FlowField;
        }
        field(65000; "Corrugation Quantity"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Work Center No." = CONST ('WC0001'),
                                                                               "Order Type" = CONST (Production),
                                                                               "Order No." = FIELD ("Prod. Order No."),
                                                                               "Order Line No." = FILTER (20000)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65001; "Printing Quantity"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Work Center No." = CONST ('WC0002'),
                                                                               "Order Type" = CONST (Production),
                                                                               "Order No." = FIELD ("Prod. Order No."),
                                                                               "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65002; "Die Cut Quantity"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Work Center No." = CONST ('WC0003'),
                                                                               "Order Type" = CONST (Production),
                                                                               "Order No." = FIELD ("Prod. Order No."),
                                                                               "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65003; "Finishing Quantity"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Work Center No." = CONST ('WC0004'),
                                                                               "Order Type" = CONST (Production),
                                                                               "Order No." = FIELD ("Prod. Order No."),
                                                                               "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65004; "Packing Quantity"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Work Center No." = CONST ('WC0005'),
                                                                               "Order Type" = CONST (Production),
                                                                               "Order No." = FIELD ("Prod. Order No."),
                                                                               "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65005; "Corrugation Scrap"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Scrap Quantity" WHERE ("Work Center No." = CONST ('WC0001'),
                                                                              "Order Type" = CONST (Production),
                                                                              "Order No." = FIELD ("Prod. Order No."),
                                                                              "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65006; "Printing Scrap"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Scrap Quantity" WHERE ("Work Center No." = CONST ('WC0002'),
                                                                              "Order Type" = CONST (Production),
                                                                              "Order No." = FIELD ("Prod. Order No."),
                                                                              "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65007; "Die Punching Scrap"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Scrap Quantity" WHERE ("Work Center No." = CONST ('WC0003'),
                                                                              "Order Type" = CONST (Production),
                                                                              "Order No." = FIELD ("Prod. Order No."),
                                                                              "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65008; "Finishing Scrap"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Scrap Quantity" WHERE ("Work Center No." = CONST ('WC0004'),
                                                                              "Order Type" = CONST (Production),
                                                                              "Order No." = FIELD ("Prod. Order No."),
                                                                              "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65009; "Packing Scrap"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Scrap Quantity" WHERE ("Work Center No." = CONST ('WC0005'),
                                                                              "Order Type" = CONST (Production),
                                                                              "Order No." = FIELD ("Prod. Order No."),
                                                                              "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65010; "Total Scrap"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Scrap Quantity" WHERE ("Order Type" = CONST (Production),
                                                                              "Order No." = FIELD ("Prod. Order No."),
                                                                              "Order Line No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65011; "Dispatch Quantity"; Decimal)
        {
            CalcFormula = - Sum ("Item Ledger Entry"."Shipped Qty. Not Returned" WHERE ("Prod. Order (Sale)" = FIELD ("Prod. Order No."),
                                                                                      "Item No." = FIELD ("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65012; "Remaining Finish Qty."; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry"."Remaining Quantity" WHERE ("Item No." = FIELD ("Item No."),
                                                                              "Order Type" = CONST (Production),
                                                                              "Order No." = FIELD ("Prod. Order No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65016; "Corrugation WIP Quantity"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Routing Line"."WIP Quantity" WHERE ("Work Center No." = CONST ('WC0001'),
                                                                               "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                               "Routing Reference No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65017; "Printing WIP Quantity"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Routing Line"."WIP Quantity" WHERE ("Work Center No." = CONST ('WC0002'),
                                                                               "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                               "Routing Reference No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65018; "Die Cut WIP Quantity"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Routing Line"."WIP Quantity" WHERE ("Work Center No." = CONST ('WC0003'),
                                                                               "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                               "Routing Reference No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65019; "Finishing WIP Quantity"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Routing Line"."WIP Quantity" WHERE ("Work Center No." = CONST ('WC0004'),
                                                                               "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                               "Routing Reference No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65020; "Packing WIP Quantity"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Routing Line"."WIP Quantity" WHERE ("Work Center No." = CONST ('WC0005'),
                                                                               "Prod. Order No." = FIELD ("Prod. Order No."),
                                                                               "Routing Reference No." = FIELD ("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65021; "SO Line Type"; Option)
        {
            CalcFormula = Lookup ("Sales Line"."Order Line Type" WHERE ("Document No." = FIELD ("Sales Order No."),
                                                                       "Line No." = FIELD ("Sales Order Line No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = New,Replacement;
        }
        field(65022; Remarks; Text[250])
        {
            CalcFormula = Lookup ("Sales Line".Remarks WHERE ("Document No." = FIELD ("Sales Order No."),
                                                             "Line No." = FIELD ("Sales Order Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65023; "Last Printing Date"; Date)
        {
            CalcFormula = Max ("Capacity Ledger Entry"."Posting Date" WHERE ("Work Center No." = CONST ('WC0002'),
                                                                            "Order No." = FIELD ("Prod. Order No.")));
            FieldClass = FlowField;
        }
    }

    var
        "--SamadhanIndia": Code[10];
        ProdLine: Record "Prod. Order Line";
        ProductionOrder: Record "Production Order";
        AllLineOk: Boolean;

    procedure "--Samadhan"()
    begin
    end;

    procedure Halt(ProductionOrderNumber: Code[20]; LineNumber: Integer)
    begin
        // Lines added by deepak kumar
        ProdLine.Reset;
        ProdLine.SetRange(ProdLine.Status, ProdLine.Status::Released);
        ProdLine.SetRange(ProdLine."Prod. Order No.", ProductionOrderNumber);
        ProdLine.SetRange(ProdLine."Line No.", LineNumber);
        if ProdLine.FindFirst then begin

            ProdLine."Prod Status" := ProdLine."Prod Status"::Halt;
            ProdLine.Modify(true);
            ProductionOrder.Reset;
            ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
            ProductionOrder.SetRange(ProductionOrder."No.", ProductionOrderNumber);
            if ProductionOrder.FindFirst then begin
                ProductionOrder.Blocked := true;
                ProductionOrder."Prod Status" := ProductionOrder."Prod Status"::Halt;
                ProductionOrder.Modify(true);
            end;
            Message('Production Order No. %1 , Line No. %2 marked as Halt. In this stage you cannot use the Production Order', ProductionOrderNumber, LineNumber);
        end;
    end;

    procedure Resume(ProductionOrderNumber: Code[20]; LineNumber: Integer)
    begin
        // Lines added by deepak kumar
        ProdLine.Reset;
        ProdLine.SetRange(ProdLine.Status, ProdLine.Status::Released);
        ProdLine.SetRange(ProdLine."Prod. Order No.", ProductionOrderNumber);
        ProdLine.SetRange(ProdLine."Line No.", LineNumber);
        if ProdLine.FindFirst then begin

            //Check if Schedule Document already exists in confirmed stage
            //Update Prod. Order List for D Stacker Begin Pulak 23-04-15

            ProdLine."Prod Status" := 1;
            ProdLine.Modify(true);
            AllLineOk := true;
            CheckProdLine(ProductionOrderNumber, LineNumber);
            if AllLineOk = true then begin
                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
                ProductionOrder.SetRange(ProductionOrder."No.", ProductionOrderNumber);
                if ProductionOrder.FindFirst then begin
                    ProductionOrder.Blocked := false;
                    ProductionOrder."Prod Status" := ProductionOrder."Prod Status"::"In process";
                    ProductionOrder.Modify(true);
                    Message('Production Order No. %1,Line No. %2 Resumed. Now you can use the Production Order.', ProductionOrderNumber, LineNumber);
                end;
            end else begin
                Message('One or more line related to this production order %1 are halted or Canceled', ProductionOrderNumber);
            end;
        end;
    end;

    procedure Cancel(ProductionOrderNumber: Code[20]; LineNumber: Integer)
    begin
        // Lines added by deepak kumar
        ProdLine.Reset;
        ProdLine.SetRange(ProdLine.Status, ProdLine.Status::Released);
        ProdLine.SetRange(ProdLine."Prod. Order No.", ProductionOrderNumber);
        ProdLine.SetRange(ProdLine."Line No.", LineNumber);
        if ProdLine.FindFirst then begin

            ProdLine."Prod Status" := ProdLine."Prod Status"::Cancel;
            ProdLine.Modify(true);


            ProductionOrder.Reset;
            ProductionOrder.SetRange(ProductionOrder.Status, ProductionOrder.Status::Released);
            ProductionOrder.SetRange(ProductionOrder."No.", ProductionOrderNumber);
            if ProductionOrder.FindFirst then begin
                ProductionOrder.Blocked := true;
                ProductionOrder."Prod Status" := ProductionOrder."Prod Status"::Cancel;
                ProductionOrder.Modify(true);
            end;
            Message('Production Order No %1,Line No. %2 marked as Cancel', ProductionOrderNumber, LineNumber);
        end;
    end;

    procedure CheckProdLine(ProductionOrderNumber: Code[20]; LineNumber: Integer)
    begin
        // Lined added BY Deepak Kumar
        ProdLine.Reset;
        ProdLine.SetRange(ProdLine.Status, ProdLine.Status::Released);
        ProdLine.SetRange(ProdLine."Prod. Order No.", ProductionOrderNumber);
        ProdLine.SetFilter(ProdLine."Line No.", '<>%1', LineNumber);
        if ProdLine.FindFirst then begin
            repeat
                AllLineOk := true;
                if (ProdLine."Prod Status" = 3) and (ProdLine."Prod Status" = 4) then begin
                    AllLineOk := false;
                end;
            until ProdLine.Next = 0;
        end;
    end;
}