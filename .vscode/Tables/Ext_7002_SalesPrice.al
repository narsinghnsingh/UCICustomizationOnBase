tableextension 50056 Ext_SalesPrice extends "Sales Price"
{
    fields
    {
        field(50001; "No. of Ply"; Integer)
        {
            MaxValue = 5;
            MinValue = 2;
        }
    }
}