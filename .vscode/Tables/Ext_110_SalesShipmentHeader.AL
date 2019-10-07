tableextension 50021 Ext_SalesShipmentHeader extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Vehicle No."; Code[20])
        {
            CaptionML = ENU = 'Vehicle No.';
        }
        field(50001; "Driver Name"; Text[30])
        {
        }
        field(50002; "Delivery Time"; Time)
        {
            Description = 'Firoz 30/11/15';
        }
        field(51002; "LC No."; Code[20])
        {
            CaptionML = ENU = 'LC No.';
            TableRelation = "LC Detail"."No." WHERE ("Transaction Type" = CONST (Sale),
                                                     "Issued To/Received From" = FIELD ("Bill-to Customer No."),
                                                     Closed = CONST (false),
                                                     Released = CONST (true));
        }
        field(51010; "Posting Time"; Time)
        {
            Editable = false;
        }
    }

    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;
}