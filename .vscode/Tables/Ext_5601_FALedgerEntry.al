tableextension 50049 Ext_FALedgerEntry extends "FA Ledger Entry"
{
    fields
    {
        field(50001; "GL Account"; Code[50])
        {
            CalcFormula = Lookup ("G/L Entry"."G/L Account No." WHERE ("Entry No." = FIELD ("G/L Entry No.")));
            Description = 'Temp';
            FieldClass = FlowField;
        }
        field(50002; "GL Acccount By Detup"; Code[10])
        {
            CalcFormula = Lookup ("FA Posting Group"."Acquisition Cost Account" WHERE (Code = FIELD ("FA Posting Group")));
            Description = 'Temp';
            FieldClass = FlowField;
        }
        field(50003; "GL Acccount By Dep"; Code[10])
        {
            CalcFormula = Lookup ("FA Posting Group"."Accum. Depreciation Account" WHERE (Code = FIELD ("FA Posting Group")));
            Description = 'Temp';
            FieldClass = FlowField;
        }
    }

}