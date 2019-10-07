pageextension 50082 Ext_Worksheet extends "Work Sheet"
{
    layout
    {
        // Add changes to page layout here
        addafter("Job Card No.")
        {
            field("Requisition No"; "Requisition No")
            {

            }
            field("Requisition Line No."; "Requisition Line No.")
            {

            }
        }
    }
}