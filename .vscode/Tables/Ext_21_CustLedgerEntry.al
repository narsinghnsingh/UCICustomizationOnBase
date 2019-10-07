tableextension 50006 Ext_CustLedgerEntry extends "Cust. Ledger Entry"
{
    fields
    {
        field(50001; "Post Dated Cheque"; Boolean)
        {
            Description = 'PDC1.0//Deepak';
        }
        field(50002; "PDC Detail"; Code[20])
        {
            Description = 'PDC1.0//Deepak';
        }
        field(50003; "PDC Presented"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist ("Bank Account Ledger Entry" WHERE ("Document No." = FIELD ("Document No.")));
            Description = 'PDC1.0//Deepak';

        }
        field(50004; "Customer  Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Customer.Name WHERE ("No." = FIELD ("Customer No.")));
            Editable = false;

        }
        field(50005; "Cheque No."; Code[10])
        {
            CaptionML = ENU = 'Cheque No.';
        }
        field(50006; "Cheque Date"; Date)
        {
            CaptionML = ENU = 'Cheque Date';
        }
    }

}
