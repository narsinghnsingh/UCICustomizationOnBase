tableextension 50040 Ext_CashFlowForecastEntry extends "Cash Flow Forecast Entry"
{
    fields
    {
        field(50000; "Short Close"; Boolean)
        {
            CalcFormula = Lookup ("Sales Line"."Short Closed Document" WHERE ("Document No." = FIELD ("Document No.")));
            FieldClass = FlowField;
        }
        field(50001; "Short Close Purchase"; Boolean)
        {
            CalcFormula = Lookup ("Purchase Line"."Short Closed Document" WHERE ("Document No." = FIELD ("Document No.")));
            FieldClass = FlowField;
        }
    }

}