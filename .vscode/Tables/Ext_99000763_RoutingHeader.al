tableextension 50068 Ext_RoutingHeader extends "Routing Header"
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
            TableRelation = "No. Series";
        }
        field(60001; "Estimate Sub Comp No."; Code[20])
        {
        }
    }

}