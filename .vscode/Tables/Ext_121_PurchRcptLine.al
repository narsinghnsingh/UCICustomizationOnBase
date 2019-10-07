tableextension 50027 Ext_PurchRcptLine extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50001; "Receiving Location"; Code[10])
        {
            TableRelation = Location.Code;
        }
        field(50003; "Quality Doc. No."; Code[20])
        {
            Description = 'Identifies the posted quality document no';
        }
        field(50006; ORIGIN; Code[20])
        {
            Description = 'Firoz 23-12-15 for Reporting Purpose';
        }
        field(50007; MILL; Code[20])
        {
            Description = 'Firoz 23-12-15 for Reporting Purpose';
        }
        field(60002; "QA Enabled"; Boolean)
        {
            Description = 'Updated from Item Card. This signifies that quality is a must for this particular receipt line.';
        }
        field(60003; "QA Processed"; Boolean)
        {
            Description = 'Identifies lines for which quality data has been posted';
        }
        field(60004; "Accepted Qty."; Decimal)
        {

            trigger OnValidate()
            begin
                "Rejected Qty." := Quantity - ("Accepted Qty." + "Acpt. Under Dev.");
                "Roll Quality Entered" := true;
            end;
        }
        field(60005; "Rejected Qty."; Decimal)
        {
            Editable = false;
        }
        field(60006; "Roll Quality Entered"; Boolean)
        {
            Description = 'identify is roll gave been accepted/rejected';
            Editable = false;
        }
        field(60007; "Quality Spec Entered"; Boolean)
        {
            Description = 'identify if Qulaity Specs have been entered';
        }
        field(60008; "Acpt. Under Dev."; Decimal)
        {
            Description = 'identify is roll gave been accepted under deviation';
        }
        field(62000; Paper; Boolean)
        {
            Description = 'Deepak';
        }
        field(62001; "Paper Type"; Code[20])
        {
            Description = 'Deepak';
            Editable = true;
        }
        field(62002; "Paper GSM"; Code[30])
        {
            Description = 'Deepak';
            Editable = true;
        }
        field(62003; "Purch. Invoice No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(62006; "FSC Category"; Text[100])
        {

        }
        field(62007; "Buy-from Vendor Name"; text[200])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Vendor.Name WHERE ("No." = FIELD ("Buy-from Vendor No.")));
            CaptionML = ENU = 'Buy-from Vendor Name';
        }


    }
    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');

    end;
}