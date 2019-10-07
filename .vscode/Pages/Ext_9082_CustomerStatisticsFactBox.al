pageextension 50050 Ext_CustomerStatisticsFactBox extends "Customer Statistics FactBox"
{
    layout
    {
        addafter("Sales (LCY)")
        {
            field("PDC Balance LCY"; "PDC Balance LCY")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}