tableextension 50037 Ext_PurchasesPayablesSetup extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Paper Roll No Series"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "No. Series".Code;
        }
        field(50001; "Requisition No Series"; Code[10])
        {
            Description = 'Deepak';
            TableRelation = "No. Series".Code;
        }
        field(50002; "Work Order No Series"; Code[10])
        {
            Description = 'Deepak';
            TableRelation = "No. Series".Code;
        }
        field(50004; "Printing Plate Adj. Jnl Batch"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Item Journal Batch".Name WHERE ("Journal Template Name" = CONST ('ITEM'));
        }
        field(50005; "Printing Plate Location Code"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = Location;
        }
    }

}