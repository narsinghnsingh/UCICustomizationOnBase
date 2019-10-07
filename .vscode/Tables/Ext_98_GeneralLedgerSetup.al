tableextension 50020 Ext_GeneralLedgerSetup extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Hire Purchase Interest A/c"; Code[20])
        {
            Description = 'PDC1.0';
            TableRelation = "G/L Account";
        }
        field(60000; "PDC No. Series"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "No. Series".Code;
        }
        field(60001; "PDC Posting Date"; Option)
        {
            Description = 'Deepak';
            OptionCaption = 'Workdate,Cheque Date';
            OptionMembers = Workdate,"Cheque Date";
        }
        field(60002; "Bill Receivable Account"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "G/L Account"."No.";
        }
        field(60003; "Bill Payable Account"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "G/L Account"."No.";
        }
        field(60004; "Detail Nos."; Code[10])
        {
            CaptionML = ENU = 'Detail Nos.';
            Description = 'Deepak';
            TableRelation = "No. Series";
        }
        field(60005; "Amended Nos."; Code[10])
        {
            CaptionML = ENU = 'Amended Nos.';
            Description = 'Deepak';
            TableRelation = "No. Series";
        }
        field(60006; "Narration Mandatory"; Boolean)
        {
            Description = 'Deepak';
        }
        field(60007; "Bill Receivable PDC Interim"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "G/L Account"."No.";
        }
        field(60008; "Bill Payable PDC Interim"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "G/L Account"."No.";
        }

    }
}