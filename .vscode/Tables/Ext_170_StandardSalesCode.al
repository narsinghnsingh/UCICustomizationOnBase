tableextension 50073 Ext_StandardSalesCode extends "Standard Sales Code"
{
    fields
    {
        field(50001; Occurrence; Option)
        {
            OptionCaption = 'Once,Every Invoice';
            OptionMembers = Once,"Every Invoice";
        }
        field(50002; "G/L Account"; Code[50])
        {
            TableRelation = "G/L Account"."No." WHERE ("Account Type" = FILTER (Posting));
        }
    }


}