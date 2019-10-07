tableextension 50069 Ext_BankAccountLedgerEntry extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50001; "Cheque No."; Code[10])
        {
            CaptionML = ENU = 'Cheque No.';
            Description = '//Deepak';
        }
        field(50002; "Cheque Date"; Date)
        {
            CaptionML = ENU = 'Cheque Date';
            Description = '//Deepak';
        }
        field(50003; "Stale Cheque"; Boolean)
        {
            CaptionML = ENU = 'Stale Cheque';
            Description = '//Deepak';
        }
        field(50004; "Stale Cheque Expiry Date"; Date)
        {
            CaptionML = ENU = 'Stale Cheque Expiry Date';
            Description = '//Deepak';
        }
        field(50005; "Cheque Stale Date"; Date)
        {
            CaptionML = ENU = 'Cheque Stale Date';
            Description = '//Deepak';
        }
        field(60003; PAY; Text[50])
        {
            Description = '//Deepak';
        }
        field(60004; "Drawn On"; Text[30])
        {
            Description = '//Deepak';
        }
    }

}