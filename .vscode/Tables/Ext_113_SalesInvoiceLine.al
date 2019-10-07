tableextension 50024 Ext_SalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Estimation No."; Code[20])
        {
            Description = '//Deepak';
            Editable = true;
        }
        field(50001; "Specification No."; Code[20])
        {
            Description = '//Deepak';
        }
        field(50002; "Old Job No."; Code[20])
        {
            Description = '//Deepak';
            TableRelation = IF (Type = FILTER (= Item)) "Production Order"."No." WHERE ("Source No." = FIELD ("No."));
        }
        field(50005; "Estimate Price"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50006; "Prod. Order No."; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Production Order"."No.";
        }
        field(50007; "Prod. Order Line No."; Integer)
        {
            Description = '//Deepak';
            Editable = false;
            TableRelation = "Prod. Order Line"."Line No.";
        }
        field(50011; "Mother Job No."; Code[20])
        {
            Description = '//Deepak';
        }
        field(50012; "Certificate of Analysis"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50013; "External Doc. No."; Code[35])
        {
            Description = '//Deepak';
        }
        field(50026; "Quality Inspection Sheet"; Code[50])
        {
            Description = '//Deepak';
        }
        field(50030; "Actual Weight"; Decimal)
        {
            CalcFormula = Lookup ("Item Ledger Entry"."Actual Output Weight" WHERE ("Order No." = FIELD ("Prod. Order No."),
                                                                                   "Order Line No." = FIELD ("Prod. Order Line No."),
                                                                                   "Entry Type" = CONST (Output),
                                                                                   Positive = CONST (true)));
            Description = '//frz';
            FieldClass = FlowField;
        }
        field(50031; "OutPut Qty"; Decimal)
        {
            CalcFormula = Lookup ("Item Ledger Entry".Quantity WHERE ("Order No." = FIELD ("Prod. Order No."),
                                                                     "Order Line No." = FIELD ("Prod. Order Line No."),
                                                                     "Entry Type" = CONST (Output),
                                                                     Positive = CONST (true)));
            Description = '//frz';
            FieldClass = FlowField;
        }
        field(60002; "Ref. Sales Order No."; Code[50])
        {
            Description = '//Deepak';
        }
        field(60003; "Ref. Sales Order Line No."; Integer)
        {
            Description = '//Deepak';
        }
        field(60004; "Estimate Additional Cost"; Boolean)
        {
            Description = '//Deepak';
        }
        field(60008; "LPO(Order) Date"; Date)
        {
            Description = '//Deepak';
            Editable = true;
        }
        field(63001; "Order Item Code"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = Item;
        }
        field(63007; "Salesperson Code"; Code[30])
        {
            Description = '//Deepak';
        }
    }
    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;
}