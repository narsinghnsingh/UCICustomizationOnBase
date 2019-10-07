tableextension 50046 Ext_ProdOrderRoutingLine extends "Prod. Order Routing Line"
{
    fields
    {
        field(50001; "Die Cut Ups"; Integer)
        {
            Description = 'Deepak';
        }
        field(50002; "No of Joints"; Integer)
        {
            Description = 'Deepak';
        }
        field(50003; "Printing Plate"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = Item."No." WHERE ("Plate Item" = FILTER (true),
                                              Blocked = FILTER (false));
        }
        field(50004; "Replace Printing Plate"; Boolean)
        {
            Description = 'Deepak';
        }
        field(50005; "Mother Job No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50006; "Printing Plate Applicable"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50007; "Item No."; Code[20])
        {
            CalcFormula = Lookup ("Prod. Order Line"."Item No." WHERE ("Prod. Order No." = FIELD ("Prod. Order No."),
                                                                      "Line No." = FIELD ("Routing Reference No.")));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Routing Unit of Measure"; Code[20])
        {
            Description = 'Deepak';
            InitValue = 'PCS';
            TableRelation = "Unit of Measure".Code;
        }
        field(50009; "Work Center Category"; Option)
        {
            CalcFormula = Lookup ("Machine Center"."Work Center Category" WHERE ("No." = FIELD ("No.")));
            Description = '// Deepak';
            FieldClass = FlowField;
            OptionCaption = ',Materials,Origination Cost,Corrugation,Printing Guiding,Finishing Packing,Sub Job';
            OptionMembers = ,Materials,"Origination Cost",Corrugation,"Printing Guiding","Finishing Packing","Sub Job";
        }
        field(50010; "Corr. Output Qty."; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Order No." = FIELD ("Prod. Order No."),
                                                                  "Item Category Code" = FILTER ('BOARD'),
                                                                  "Entry Type" = FILTER (Output)));
            FieldClass = FlowField;
        }
        field(51001; "Estimate Type"; Option)
        {
            Description = 'Deepak';
            Editable = false;
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;
        }
        field(51002; "Estimation No."; Code[50])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(51003; "Sub Comp No."; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(60001; "Actual Output Quantity"; Decimal)
        {
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Order Type" = CONST (Production),
                                                                               "Order No." = FIELD ("Prod. Order No."),
                                                                               "Order Line No." = FIELD ("Routing Reference No."),
                                                                               "Operation No." = FIELD ("Operation No.")));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60002; "RPO Description"; Text[250])
        {
            CalcFormula = Lookup ("Production Order".Description WHERE (Status = FIELD (Status),
                                                                       "No." = FIELD ("Prod. Order No.")));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60003; "WIP Quantity"; Decimal)
        {
            Description = 'Deepak';
        }
        field(60004; "WIP Process Value"; Decimal)
        {
            CalcFormula = Sum ("Value Entry"."Cost Amount (Actual)" WHERE ("Item Ledger Entry Type" = FILTER (" "),
                                                                          "Order Type" = FILTER (Production),
                                                                          "Order No." = FIELD ("Prod. Order No."),
                                                                          "Order Line No." = FIELD ("Routing Reference No."),
                                                                          Type = FILTER ("Work Center"),
                                                                          "No." = FIELD ("Work Center No.")));
            Description = 'Deepak';
            FieldClass = FlowField;
        }
        field(60005; "Print Load Qty"; Decimal)
        {
            Description = '//Anurag';
        }
        field(60006; "Scrap Output Qty"; Decimal)
        {
            CalcFormula = Lookup ("Capacity Ledger Entry"."Scrap Quantity" WHERE ("Order No." = FIELD ("Prod. Order No."),
                                                                                 "Work Center No." = CONST ('WC0002')));
            Description = '//Anurag';
            FieldClass = FlowField;
        }
        field(60007; "Item Catgory Code"; Code[10])
        {
            CalcFormula = Lookup (Item."Item Category Code" WHERE ("No." = FIELD ("Item No.")));
            FieldClass = FlowField;
        }
    }

    procedure UpdateWIPQuantity(ProdOrder: Code[30]; LineNumber: Integer)
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderRoutingLineNext: Record "Prod. Order Routing Line";
        PurchaseLine: Record "Purchase Line";
        TempOrderQuantity: Decimal;
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempWipQty: Decimal;
    begin
        // Lines added by Deepak Kumar
        ProdOrderRoutingLine.Reset;
        ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine.Status, ProdOrderRoutingLine.Status::Released);
        ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Prod. Order No.", ProdOrder);
        ProdOrderRoutingLine.SetRange(ProdOrderRoutingLine."Routing Reference No.", LineNumber);
        if ProdOrderRoutingLine.FindFirst then begin
            repeat
                if ProdOrderRoutingLine."Next Operation No." <> '' then begin
                    ProdOrderRoutingLineNext.Reset;
                    ProdOrderRoutingLineNext.SetRange(ProdOrderRoutingLineNext.Status, ProdOrderRoutingLineNext.Status::Released);
                    ProdOrderRoutingLineNext.SetRange(ProdOrderRoutingLineNext."Prod. Order No.", ProdOrder);
                    ProdOrderRoutingLineNext.SetRange(ProdOrderRoutingLineNext."Routing Reference No.", LineNumber);
                    ProdOrderRoutingLineNext.SetFilter(ProdOrderRoutingLineNext."Operation No.", ProdOrderRoutingLine."Next Operation No.");
                    if ProdOrderRoutingLineNext.FindFirst then begin
                        ProdOrderRoutingLine.CalcFields(ProdOrderRoutingLine."Actual Output Quantity");
                        ProdOrderRoutingLineNext.CalcFields(ProdOrderRoutingLineNext."Actual Output Quantity");
                        TempWipQty := 0;
                        if ProdOrderRoutingLineNext."Die Cut Ups" > 0 then begin
                            TempWipQty := (ProdOrderRoutingLineNext."Actual Output Quantity" / ProdOrderRoutingLine."Die Cut Ups") * ProdOrderRoutingLineNext."No of Joints";
                        end else begin
                            TempWipQty := ProdOrderRoutingLineNext."Actual Output Quantity";//
                        end;

                        ProdOrderRoutingLine."WIP Quantity" := ProdOrderRoutingLine."Actual Output Quantity" - TempWipQty;
                        ProdOrderRoutingLine.Modify(true);
                    end;
                end;
            until ProdOrderRoutingLine.Next = 0;
        end;
    end;
}