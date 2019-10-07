pageextension 50031 Ext_General_Ledger_Setup extends "General Ledger Setup"
{
    layout
    {
        addafter(General)
        {
            group(Numbering)
            {
                field("Detail Nos."; "Detail Nos.")
                {
                }
                field("PDC No. Series"; "PDC No. Series")
                {
                }
                field("PDC Posting Date"; "PDC Posting Date")
                {
                }
                field("Bill Receivable Account"; "Bill Receivable Account")
                {
                }
                field("Bill Receivable PDC Interim"; "Bill Receivable PDC Interim")
                {
                }
                field("Bill Payable Account"; "Bill Payable Account")
                {
                }
                field("Bill Payable PDC Interim"; "Bill Payable PDC Interim")
                {
                }
            }
        }
        addafter("Allow Posting To")
        {
            field("Narration Mandatory"; "Narration Mandatory")
            {
            }
        }
        addafter("Bill Receivable Account")
        {
            field("Hire Purchase Interest A/c"; "Hire Purchase Interest A/c")
            { }

        }
    }

}