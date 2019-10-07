tableextension 50052 Ext_ValueEntry extends "Value Entry"
{
    fields
    {
        field(50001; "Item Ledger Entry Date"; Date)
        {
            CalcFormula = Lookup ("Item Ledger Entry"."Posting Date" WHERE ("Item No." = FIELD ("Item No."),
                                                                           "Entry No." = FIELD ("Item Ledger Entry No.")));
            FieldClass = FlowField;
        }
    }
    trigger OnDelete()
    begin
        ERROR('');
    end;
}