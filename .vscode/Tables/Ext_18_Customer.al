tableextension 50004 Ext_Customer extends Customer
{
    fields
    {
        field(50001; "Created / Modified By"; Text[50])
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50002; "Approved / Blocked By"; Text[50])
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50003; "Trade License No."; Code[20])
        {
            Description = '//Deepak';
        }
        field(50004; "Chamber of Commerce Reg. No."; Code[20])
        {
            Description = '//Deepak';
        }
        field(50005; "Cust. Credit Buffer(LCY)"; Decimal)
        {
            Description = '//Deepak';
            trigger OnValidate()
            begin
                if "Credit Limit (LCY)" = 0 then
                    Error('Please define Credit Limit (LCY) first.');

                Rec."Credit Limit (LCY) Base" := "Credit Limit (LCY)" - xRec."Cust. Credit Buffer(LCY)";
                "Credit Limit (LCY)" := xRec."Credit Limit (LCY)" - xRec."Cust. Credit Buffer(LCY)" + "Cust. Credit Buffer(LCY)";
            end;
        }
        field(50006; "Credit Limit Override"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50007; "Customer Segment"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Segment Header"."No." WHERE (Type = CONST (Customer));
        }
        field(50008; "PDC Balance LCY"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Post Dated Cheque PDC"."Amount LCY"
            WHERE ("Account Type" = CONST (Customer), "Account No" = FIELD ("No."), Received = CONST (true), Presented = CONST (false), "Void Cheque" = CONST (false)));
            Description = '//Deepak';
            Editable = false;

        }
        field(50009; "Due Date Calculated By Month"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50010; "Last Order Date"; Date)
        {
            CalcFormula = Max ("Sales Header"."Order Date" WHERE ("Sell-to Customer No." = FIELD ("No.")));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Conditional Shipping Tolerance"; Boolean)
        {
            Description = 'Deepak';

            trigger OnValidate()
            begin
                // Lines added By Deepak kumar
                IF "Conditional Shipping Tolerance" = FALSE THEN BEGIN
                    "Conditional Ship Tolerance %" := 0;
                    "Production Tolerance %" := 0;
                END;
            end;
        }
        field(50012; "Conditional Ship Tolerance %"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50013; "Production Tolerance %"; Decimal)
        {
            Description = 'Deepak';
        }
        field(50014; "VAT TRN NO."; Code[15])
        {
        }
        field(50015; "Payment Terms Print"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(50016; ItemApprove; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Created On"; Date)
        {
            Caption = 'Cust Creation Date';
        }
        field(50018; "Expiry Date of Trade Lic"; Date)
        {

        }
        field(50019; "Outstanding Orders1 (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Outstanding Orders (LCY)';
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Line"."Outstanding Amount (LCY)" WHERE
                     ("Document Type" = CONST (Order), "Bill-to Customer No." = FIELD ("No."),
                     "Shortcut Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"),
                     "Shortcut Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"),
                     "Currency Code" = FIELD ("Currency Filter"),
                     "Short Closed Document" = filter (false)));
            Editable = false;
            AccessByPermission = TableData "Sales Shipment Header" = R;
        }
        field(50020; "Credit Limit (LCY) Base"; Decimal)
        {
            CaptionML = ENU = 'Credit Limit (LCY) Base';
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(50021; "Customer Address Print"; Boolean)
        {

        }
    }
    var

        UserSetup: Record "User Setup";
        Answer: Boolean;
        SAM001: Label 'You don''t have to permission for Customer Master,for more information please contact your System Administrator';
        SAM002: Label 'Do you want to Approve Customer Master? ';
        SAM003: Label 'Do you want to Block Customer Master?';

    procedure "-Samadhan_Function"()
    begin
    end;

    procedure ApproveRecord()
    begin
        // Lines added By Deepak Kumar
        TESTFIELD(Name);
        TESTFIELD(Address);
        TESTFIELD("Post Code");
        TESTFIELD("Phone No.");
        TESTFIELD("Salesperson Code");
        TESTFIELD("Customer Segment");
        TESTFIELD("Credit Limit (LCY)");
        TESTFIELD("Gen. Bus. Posting Group");
        TESTFIELD("Customer Posting Group");
        TESTFIELD("Payment Terms Code");

        UserSetup.RESET;
        UserSetup.SETFILTER(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Customer, TRUE);
        IF UserSetup.FINDFIRST THEN BEGIN
            Blocked := 3;
            IF UserSetup."Approval Authority Customer" = TRUE THEN BEGIN
                Answer := DIALOG.CONFIRM(SAM002, FALSE);
                IF Answer = TRUE THEN BEGIN
                    ItemApprove := TRUE;
                    Blocked := 0;
                    "Approved / Blocked By" := USERID;
                    MODIFY(TRUE);
                END;
            END ELSE BEGIN
                ERROR('You do not have permission for Customer Master Approval, Please contact your System Administrator.');
            END;
        END ELSE BEGIN
            ERROR('You do not have permission for Customer master, Please contact your system administrator.');
        END;
    end;

    procedure BlockRecord()
    begin
        // Lines added BY Deepak Kumar
        UserSetup.RESET;
        UserSetup.SETFILTER(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Customer, TRUE);
        IF UserSetup.FINDFIRST THEN BEGIN
            IF UserSetup."Approval Authority Customer" = TRUE THEN BEGIN
                Answer := DIALOG.CONFIRM(SAM003, FALSE);
                IF Answer = TRUE THEN BEGIN
                    Blocked := 3;
                    "Approved / Blocked By" := USERID;
                    MODIFY(TRUE);
                END;
            END ELSE BEGIN
                ERROR('You do not have permission for Customer Master Status Change, Please contact your System Administrator.');
            END;
        END ELSE BEGIN
            ERROR('You do not have permission for Customer master, Please contact your system administrator.');
        END;
    end;
}