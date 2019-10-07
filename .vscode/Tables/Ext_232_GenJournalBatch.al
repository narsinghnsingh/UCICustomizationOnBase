tableextension 50070 Ext_GenJournalBatch extends "Gen. Journal Batch"
{
    fields
    {
        field(50000; "Approver User Id"; Code[50])
        {
            Description = 'Deepak';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50002; "Sub Type"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,Cash Receipt Voucher,Cash Payment Voucher,Bank Receipt Voucher,Bank Payment Voucher,Contra Voucher,Journal Voucher';
            OptionMembers = " ","Cash Receipt Voucher","Cash Payment Voucher","Bank Receipt Voucher","Bank Payment Voucher","Contra Voucher","Journal Voucher";
        }
    }

}