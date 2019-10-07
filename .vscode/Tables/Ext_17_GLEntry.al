tableextension 50003 Ext_GLEntry extends "G/L Entry"
{
    fields
    {
        field(50002; "PDC Type"; Option)
        {
            Description = 'PDC1.0//Deepak';
            OptionCaption = ' ,PDC Receive,PDC Post,Void Cheque';
            OptionMembers = " ","PDC Receive","PDC Post","Void Cheque";
        }
        field(50003; "Post Dated Cheque"; Boolean)
        {
            Description = 'PDC1.0//Deepak';
        }
        field(50010; "LC No."; Code[20])
        {
            CaptionML = ENU = 'LC No.';
            Description = '//Deepak';
            TableRelation = "LC Detail"."No." WHERE (Released=CONST(true));
        }
        field(60001; "Cheque No."; Code[20])
        {
            Description = '//Deepak';
        }
        field(60002; "Cheque Date"; Date)
        {
            Description = '//Deepak';
        }
        field(60003; "Parking No."; Code[20])
        {
            Editable = false;
        }

    }


}