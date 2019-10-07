tableextension 50007 Ext_Vendor extends Vendor
{
    fields
    {
        field(50001; "Created / Modified By"; Text[50])
        {
            Description = '//Deepak';
        }
        field(50002; "Approved By"; Text[50])
        {
            Description = '//Deepak';
        }
        field(50003; "PDC Balance LCY"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Post Dated Cheque PDC"."Amount LCY"
            WHERE ("Account Type" = CONST (Vendor), "Account No" = FIELD ("No."), Received = CONST (true), Presented = CONST (false), "Void Cheque" = CONST (false)));
            Description = '//Deepak';
            Editable = false;

        }
        field(50004; "VAT TRN NO."; Code[15])
        {
        }
        field(50007; "Vendor Segment"; Code[20])
        {
            CaptionML = ENU = 'Vendor Segment';
            Description = '//Deepak';
            TableRelation = "Segment Header"."No." WHERE (Type = FILTER (Vendor));
        }
        field(63001; "Mobile No."; Text[30])
        {
        }

    }

    var
        "--Samadhan_Variables": Integer;
        UserSetup: Record "User Setup";
        Answer: Boolean;
        SAM001: Label 'You don''t have to permission for Vendor Master, for more information please contact your System Administrator';
        SAM002: Label 'Do you want to Approve Vendor Master?';
        SAM003: Label '<Do you want to Block Vendor Master?>';
        SAM004: Label '<Do you want to UnBlock Vendor Master?>';

    trigger OnDelete()
    var
    begin
        // Lines added By Deepak Kumar for Stop Delete
        ERROR('Vendor Delete is Restricted, for more Information Please contact your System Administrator');
    end;

    procedure "-Samadhan_Function"()
    begin
    end;

    procedure ApproveRecord()
    begin
        // Lines added BY Deepak Kumar
        UserSetup.RESET;
        UserSetup.SETFILTER(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Vendor, TRUE);
        UserSetup.SETRANGE(UserSetup."Approval Authority Vendor", TRUE);
        IF UserSetup.FINDFIRST THEN BEGIN
            Answer := DIALOG.CONFIRM(SAM002, FALSE);
            IF Answer = TRUE THEN BEGIN
                Blocked := 0;
                "Approved By" := USERID;
                MODIFY(TRUE);
            END;
        END ELSE BEGIN
            ERROR('You are not authorised for Vendor card Approval, Please contact your System Administrator');
        END;
        MODIFY(TRUE);
    end;

    procedure BlockRecord()
    begin
        // Lines added BY Deepak Kumar
        UserSetup.RESET;
        UserSetup.SETFILTER(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Vendor, TRUE);
        UserSetup.SETRANGE(UserSetup."Approval Authority Vendor", TRUE);
        IF UserSetup.FINDFIRST THEN BEGIN
            Answer := DIALOG.CONFIRM(SAM003, FALSE);
            IF Answer = TRUE THEN BEGIN
                //Blocked := Blocked::All;
                //MODIFY;
            END ELSE BEGIN
                ERROR('No');

            END;
        END ELSE BEGIN
            ERROR('You are not authorised for Vendor card Approval, Please contact your System Administrator');
        END;
    end;

    procedure UnBlockRecord()
    begin
        // Lines added BY Deepak Kumar
        UserSetup.RESET;
        UserSetup.SETFILTER(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Vendor, TRUE);
        UserSetup.SETRANGE(UserSetup."Approval Authority Vendor", TRUE);
        IF UserSetup.FINDFIRST THEN BEGIN
            Answer := DIALOG.CONFIRM(SAM004, FALSE);
            IF Answer = TRUE THEN BEGIN
                //Blocked := Blocked::" ";
                //MODIFY;
            END ELSE BEGIN
                ERROR('No');

            END;
        END ELSE BEGIN
            ERROR('You are not authorised for Vendor card Approval, Please contact your System Administrator');
        END;
    end;
}