tableextension 50047 Ext_5414_ProdOrderCommentLine extends "Prod. Order Comment Line"
{
    fields
    {
        field(50001; Category; Option)
        {
            Description = '//Deepak';
            OptionCaption = ' ,Pre Press,Finishing,Special Instruction,Special Instruction Corrugation';
            OptionMembers = " ","Pre Press",Finishing,"Special Instruction","Special Instruction Corrugation";
        }
        field(50002; "Req No."; Code[50])
        {
            Description = '//Deepak';
        }
    }
}