tableextension 50023 Ext_SalesInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "Vehicle No."; Code[20])
        {
            Description = 'Firoz 161215';
        }
        field(50001; "Driver Name"; Text[30])
        {
            Description = 'Firoz 161215';
        }
        field(50002; "Delivery Time"; Time)
        {
            Description = 'Firoz 30/11/15';
        }
        field(51002; "LC No."; Code[20])
        {
            CaptionML = ENU = 'LC No.';
            Description = 'Deepak';
            TableRelation = "LC Detail"."No." WHERE ("Transaction Type" = CONST (Sale),
                                                     "Issued To/Received From" = FIELD ("Bill-to Customer No."),
                                                     Closed = CONST (false),
                                                     Released = CONST (true));
        }
        field(51003; "Amount to Customer"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU = 'Amount to Customer';
            Description = 'Deepak';
            Editable = false;
        }
        field(51010; "Posting Time"; Time)
        {
            Editable = false;
        }
        field(52000; "Document Receiving Received"; Boolean)
        {

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                "Document Received By" := UserId + ' ' + Format(CurrentDateTime);
            end;
        }
        field(52001; "Document Receiving Remarks"; Text[100])
        {
        }
        field(52002; "Document Received By"; Text[50])
        {
            Editable = false;
        }
        field(52003; "Document Receiving Image"; BLOB)
        {
            SubType = Bitmap;
        }
    }
    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;
}