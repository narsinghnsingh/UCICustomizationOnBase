pageextension 50056 Ext_99000823_OutputJnlPrinting extends "Output Journal"
{
    layout
    {
        addafter("Ending Time")
        {
            field("Start Date"; "Start Date")
            {
            }
            field("End Date"; "End Date")
            {
            }
            field("Posted Output Qty"; "Posted Output Qty")
            {

            }

            field("Employee Code"; "Employee Code")
            {

            }
        }
    }
    trigger OnOpenPage()
    begin
        //CurrentJnlBatchName := 'PRINTING';
    end;
}