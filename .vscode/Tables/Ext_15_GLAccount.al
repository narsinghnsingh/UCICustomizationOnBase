tableextension 50002 Ext_GLAccount extends "G/L Account"
{
    fields
    {
        field(50001; "Aval. In Estimate"; Boolean)
        {

        }
        field(50002; "Machine Cost Matrix"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist ("Machine Cost Sheet" WHERE ("No." = FIELD ("No.")));

        }
    }


}