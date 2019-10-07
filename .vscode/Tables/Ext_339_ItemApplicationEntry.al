tableextension 50038 Ext_ItemApplicationEntry extends "Item Application Entry"
{
    fields
    {
        field(50000; "ILE Exists"; Boolean)
        {
            CalcFormula = Exist ("Item Ledger Entry" WHERE ("Entry No." = FIELD ("Item Ledger Entry No.")));
            Description = 'Binay 01/12/17';
            FieldClass = FlowField;
        }
        field(50001; "Inbound Posting Date"; Date)
        {
            CalcFormula = Lookup ("Item Ledger Entry"."Posting Date" WHERE ("Entry No." = FIELD ("Inbound Item Entry No.")));
            FieldClass = FlowField;
        }
        field(50002; "Outbound Posting Date"; Date)
        {
            CalcFormula = Lookup ("Item Ledger Entry"."Posting Date" WHERE ("Entry No." = FIELD ("Outbound Item Entry No.")));
            FieldClass = FlowField;
        }
        field(50003; "Inbound Order No."; Code[20])
        {
            Description = 'Binay 01/12/17';
        }
        field(50004; "Outbound Order No."; Code[20])
        {
            Description = 'Binay 01/12/17';
        }
        field(50005; "Item Category Code"; Code[20])
        {
            Description = 'Binay 01/12/17';
        }

    }

}