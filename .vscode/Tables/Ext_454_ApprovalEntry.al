tableextension 50039 Ext_ApprovalEntry extends "Approval Entry"
{
    fields
    {
        field(50000; "Salary Document No."; Text[50])
        {
            Description = 'SAP1.0';
        }
        field(50001; Reason; Text[50])
        {
            Description = 'SAP1.0';
        }
        field(50002; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup ("Sales Header"."Bill-to Name" WHERE ("Document Type" = FIELD ("Document Type"),
                                                                      "No." = FIELD ("Document No.")));
            FieldClass = FlowField;
        }
    }

}