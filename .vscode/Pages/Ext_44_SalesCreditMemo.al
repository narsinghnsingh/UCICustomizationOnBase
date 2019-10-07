pageextension 50014 Ext_44_SalesCreditMemo extends "Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("Job Queue Status")
        {
            field("Posting No."; "Posting No.")
            {
                Editable = true;
            }
        }
    }

}