tableextension 50025 Ext_SalesCrMemoLine extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50026; "Quality Inspection Sheet"; Code[50])
        {
            Description = '//Deepak';
            TableRelation = "Inspection Header"."No." WHERE ("Item No." = FIELD ("No."),
                                                             Posted = CONST (true));
        }
    }
    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;

}