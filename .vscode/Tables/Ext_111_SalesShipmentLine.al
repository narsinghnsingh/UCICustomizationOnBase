tableextension 50022 "Ext_SalesShipmentLine" extends "Sales Shipment Line"
{
    fields
    {
        field(50000; "Vehicle No."; Code[20])
        {
            CalcFormula = Lookup ("Sales Shipment Header"."Vehicle No." WHERE ("No." = FIELD ("Document No.")));
            CaptionML = ENU = 'Vehicle No.';
            FieldClass = FlowField;
        }
        field(50001; "Driver Name"; Text[30])
        {
            CalcFormula = Lookup ("Sales Shipment Header"."Driver Name" WHERE ("No." = FIELD ("Document No.")));
            FieldClass = FlowField;
        }
        field(50002; "Sell-to Customer Name"; Text[50])
        {
            CalcFormula = Lookup ("Sales Shipment Header"."Sell-to Customer Name" WHERE ("No." = FIELD ("Document No.")));
            CaptionML = ENU = 'Sell-to Customer Name';
            FieldClass = FlowField;
        }
        field(50006; "Prod. Order No."; Code[20])
        {
            Description = 'firoz 11-10-15';
            TableRelation = "Production Order"."No.";
        }
        field(50007; "Prod. Order Line No."; Integer)
        {
            Description = 'firoz 11-10-15';
            Editable = false;
            TableRelation = "Prod. Order Line"."Line No.";
        }
        field(50013; "External Doc. No."; Code[35])
        {
            Description = 'firoz 11-10-15';
        }
        field(50021; "Shipment Weight"; Decimal)
        {
            Description = '//firoz 30-11-15';
        }
        field(50026; "Quality Inspection Sheet"; Code[50])
        {
            Description = '//Deepak';
            TableRelation = "Inspection Header"."No." WHERE ("Item No." = FIELD ("No."),
                                                             Posted = CONST (true));
        }
        field(60002; "Ref. Sales Order No."; Code[50])
        {
            Description = '//Firoz';
        }
        field(60003; "Ref. Sales Order Line No."; Integer)
        {
            Description = '//Firoz';
        }
    }
    trigger onDelete()
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;
}