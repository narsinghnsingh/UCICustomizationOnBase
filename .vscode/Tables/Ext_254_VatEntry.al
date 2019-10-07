tableextension 50035 Ext_VatEntry extends "VAT Entry"
{
    fields
    {
        field(50001; "Customer Name"; Text[250])
        {
            CalcFormula = Lookup (Customer.Name WHERE ("No." = FIELD ("Bill-to/Pay-to No.")));
            FieldClass = FlowField;
        }
        field(50002; "Vendor Name"; Text[250])
        {
            CalcFormula = Lookup (Vendor.Name WHERE ("No." = FIELD ("Bill-to/Pay-to No.")));
            FieldClass = FlowField;
        }
        field(50003; "Customer's VAT Reg. No."; Code[50])
        {
            CalcFormula = Lookup (Customer."VAT Registration No." WHERE ("No." = FIELD ("Bill-to/Pay-to No.")));
            FieldClass = FlowField;
        }
        field(50004; "Vendor's VAT Reg. No."; Code[50])
        {
            CalcFormula = Lookup (Vendor."VAT Registration No." WHERE ("No." = FIELD ("Bill-to/Pay-to No.")));
            FieldClass = FlowField;
        }
    }

}