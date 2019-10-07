tableextension 50019 Ext_StandardText extends "Standard Text"
{
    fields
    {
        field(50001; Type; Option)
        {
            OptionCaption = 'Sale,Purchase,Sale Check list,Terms';
            OptionMembers = "Sale","Purchase","Sale Check list","Terms";
        }
        field(50002; "Sub- Type"; Option)
        {
            OptionCaption = 'Shipment,Delivery,Variation Quantity vs Actual,Payment,Validity';
            OptionMembers = "Shipment","Delivery","Variation Quantity vs Actual","Payment","Validity";
        }
    }

}