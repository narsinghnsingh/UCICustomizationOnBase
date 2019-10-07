tableextension 50026 Ext_PurchRcptHeader extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50001; "Custom's Reference No."; Code[20])
        {
            Description = 'Deepak';
            Editable = true;
        }
        field(50002; "Quality Applicable"; Boolean)
        {
            CalcFormula = Exist ("Purch. Rcpt. Line" WHERE ("Document No." = FIELD ("No."),
                                                           Type = FILTER (Item),
                                                           "QA Enabled" = FILTER (true),
                                                           "QA Processed" = FILTER (false)));
            FieldClass = FlowField;
        }
        field(50003; "Quality Posted"; Boolean)
        {
            CalcFormula = Exist ("Purch. Rcpt. Line" WHERE ("Document No." = FIELD ("No."),
                                                           Type = FILTER (Item),
                                                           "QA Enabled" = FILTER (true),
                                                           "QA Processed" = FILTER (true)));
            Description = '//Deepak';
            FieldClass = FlowField;
        }
        field(50005; "LC No."; Code[20])
        {
            CaptionML = ENU = 'LC No.';
            Description = 'Deepak';
            TableRelation = "LC Detail"."No." WHERE ("Transaction Type" = CONST (Purchase),
                                                     "Issued To/Received From" = FIELD ("Pay-to Vendor No."),
                                                     Closed = CONST (false),
                                                     Released = CONST (true));

            trigger OnValidate()
            var
                Text13700: Label 'The LC which you have selected is Foreign type you cannot utilise for this order.';
            begin
                /*
                IF "LC No." <> '' THEN BEGIN
                  LCDetail.GET("LC No.");
                  IF LCDetail."Type of LC" = LCDetail."Type of LC"::Foreign THEN
                    IF "Currency Code" = '' THEN
                      ERROR(Text13700);
                END;
                 */

            end;
        }
        field(50006; "Vendor Segment"; Code[30])
        {
            CalcFormula = Lookup (Vendor."Vendor Segment" WHERE ("No." = FIELD ("Buy-from Vendor No.")));
            Editable = false;
            Enabled = true;
            FieldClass = FlowField;
        }
    }

    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;
}