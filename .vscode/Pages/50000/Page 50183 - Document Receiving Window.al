page 50183 "Document Receiving Window"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData "Sales Invoice Header"=rm;
    SourceTable = "Sales Invoice Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("No.";"No.")
                {
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                }
                field("External Document No.";"External Document No.")
                {
                }
                field("Vehicle No.";"Vehicle No.")
                {
                }
                field("Driver Name";"Driver Name")
                {
                }
                field("Amount to Customer";"Amount to Customer")
                {
                }
            }
            group(Control11)
            {
                ShowCaption = false;
                field("Document Receiving Received";"Document Receiving Received")
                {
                }
                field("Document Receiving Remarks";"Document Receiving Remarks")
                {
                }
                field("Document Received By";"Document Received By")
                {
                }
            }
            group("Receiving Copy")
            {
                CaptionML = ENU = 'Receiving Copy';
                field("Document Receiving Image";"Document Receiving Image")
                {
                }
            }
        }
    }

    actions
    {
    }
}

