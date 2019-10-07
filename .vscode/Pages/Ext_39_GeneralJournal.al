pageextension 50036 Ext_General_Journal extends "General Journal"
{
    layout
    {
        addafter(Comment)
        {
            field("Cheque No."; "Cheque No.")
            {

            }
            field("Cheque Date"; "Cheque Date")
            {

            }
        }
        addafter(Control30)
        {
            part(Control52; "Voucher Narration New")
            {
                ShowFilter = false;
                SubPageLink = "Journal Template Name" = FIELD ("Journal Template Name"),
                              "Journal Batch Name" = FIELD ("Journal Batch Name"),
                              "Document No." = FIELD ("Document No.");
                SubPageView = SORTING ("Journal Template Name", "Journal Batch Name", "Document No.", "Gen. Journal Line No.", "Line No.");
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