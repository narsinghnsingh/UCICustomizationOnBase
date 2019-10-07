tableextension 50008 Ext_VendorLedgerEntry extends "Vendor Ledger Entry"
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
        field(50004; "Vendor Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Vendor.Name WHERE ("No." = FIELD ("Vendor No.")));
            Description = 'Deepak';
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
        field(50007; "Vendor Segment"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Segment Header"."No."
             WHERE (Type = FILTER (Vendor));
            CaptionML = ENU = 'Vendor Segment';
            Editable = false;
        }
    }

}