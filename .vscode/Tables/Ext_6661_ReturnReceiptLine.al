tableextension 50055 Ext_ReturnReceiptLine extends "Return Receipt Line"
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

}