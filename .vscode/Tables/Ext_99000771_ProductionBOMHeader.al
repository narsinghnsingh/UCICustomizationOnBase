tableextension 50067 Ext_ProductionBOMHeader extends "Production BOM Header"
{
    fields
    {
        field(50000; "Item No."; Code[10])
        {
            Editable = false;
            TableRelation = Item;
        }
        field(60000; "Estimate No."; Code[20])
        {
        }
        field(60001; "Estimate Sub Comp No."; Code[20])
        {
        }
    }

}