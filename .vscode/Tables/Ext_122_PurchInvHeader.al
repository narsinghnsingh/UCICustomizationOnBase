tableextension 50028 Ext_PurchInvHeader extends "Purch. Inv. Header"
{
    fields
    {
        field(50001; "Custom's Reference No."; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50005; "LC No."; Code[20])
        {
            CaptionML = ENU = 'LC No.';
            Description = 'Deepak';
            TableRelation = "LC Detail"."No." WHERE ("Transaction Type" = CONST (Purchase),
                                                     "Issued To/Received From" = FIELD ("Buy-from Vendor No."),
                                                     Closed = CONST (false),
                                                     Released = CONST (true));
        }
        field(50006; "Vendor Segment"; Code[30])
        {
            CalcFormula = Lookup (Vendor."Vendor Segment" WHERE ("No." = FIELD ("Buy-from Vendor No.")));
            Editable = false;
            Enabled = true;
            FieldClass = FlowField;
        }
    }
    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        //ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;
}