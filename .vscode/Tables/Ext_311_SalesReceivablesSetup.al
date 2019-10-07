tableextension 50036 Ext_SalesReceivablesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Estimation No Series"; Code[10])
        {
            Description = '//Deepak';
            TableRelation = "No. Series";
        }
        field(50001; "Packing List No Series"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "No. Series".Code;
        }
        field(50002; "Delivery Order No Series"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "No. Series".Code;
        }
        field(50003; "Enquiry Nos."; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "No. Series";
        }
        field(50004; "Starch Calculation"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50005; "Estimate Approval Mandatory"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50006; "Force Credit Limit"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50007; "Sales Variation Allowed %"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50008; "Quality for Sale Return"; Option)
        {
            Description = '//Deepak';
            OptionCaption = ' ,Before Return Receipt,After Return Receipt';
            OptionMembers = " ","Before Return Receipt","After Return Receipt";
        }
    }

}