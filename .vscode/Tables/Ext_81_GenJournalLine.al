tableextension 50016 Ext_GenJournalLine extends "Gen. Journal Line"
{
    fields
    {
        field(50002; "PDC Type"; Option)
        {
            Description = 'PDC1.0//Deepak';
            OptionCaption = ' ,PDC Receive,PDC Post,Void Cheque';
            OptionMembers = " ","PDC Receive","PDC Post","Void Cheque";
        }
        field(50003; "Post Dated Cheque"; Boolean)
        {
            Description = 'PDC1.0//Deepak';
        }
        field(50004; "Created By"; Code[50])
        {
            Description = '//Deepak';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(50005; Approved; Boolean)
        {
            Description = '//Deepak';

            trigger OnValidate()
            begin
                IF Approved THEN
                    "Approval Due" := FALSE
                ELSE
                    "Approval Due" := TRUE;
            end;
        }
        field(50006; "Approver ID"; Code[50])
        {
            Description = '//Deepak';
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(50007; "Approval Due"; Boolean)
        {
            Description = '//Deepak';
            Editable = true;
        }
        field(50008; "Select for Approval"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50010; "LC No."; Code[20])
        {
            CaptionML = ENU = 'LC No.';
            Description = '//Deepak';
            TableRelation = "LC Detail"."No." WHERE (Released = CONST (true));
        }
        field(60001; "Cheque No."; Code[20])
        {
            Description = '//Deepak';
        }
        field(60002; "Cheque Date"; Date)
        {
            Description = '//Deepak';
        }
        field(60003; PAY; Text[50])
        {
            Description = '//Deepak';
        }
        field(60004; "Drawn On"; Text[30])
        {
            Description = '//Deepak';
        }
        field(60005; "Parking No."; Code[20])
        {
            Editable = false;
        }

    }

}