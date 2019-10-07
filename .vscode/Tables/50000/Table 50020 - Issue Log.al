table 50020 "Issue Log"
{
    // version Deepak

    CaptionML = ENU = 'Issue Log';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Editable = false;
            NotBlank = false;
        }
        field(2; "Issue Title"; Text[100])
        {

            trigger OnValidate()
            begin
                RestrictModifyAction();
            end;
        }
        field(3; Description; Text[250])
        {

            trigger OnValidate()
            begin
                RestrictModifyAction();
            end;
        }
        field(4; "Description 2"; Text[250])
        {

            trigger OnValidate()
            begin
                RestrictModifyAction();
            end;
        }
        field(5; "Open by"; Code[100])
        {
            Editable = false;
        }
        field(6; "Open Date"; Date)
        {
            Editable = false;
        }
        field(7; "Communicated to"; Text[100])
        {

            trigger OnValidate()
            begin
                RestrictModifyAction();
            end;
        }
        field(8; "Communicated on"; Date)
        {

            trigger OnValidate()
            begin
                RestrictModifyAction();
            end;
        }
        field(9; Category; Option)
        {
            OptionCaption = ',Training Required,Modification Required,Beyond Scope,Invalid Problem,Need Clarification,Quality,Quantity,Design,Others';
            OptionMembers = ,"Training Required","Modification Required","Beyond Scope","Invalid Problem","Need Clarification",Quality,Quantity,Design,Others;
        }
        field(10; Department; Option)
        {
            OptionCaption = ',Account,Sale,Purchase,Production,Quality & PM,Stores';
            OptionMembers = ,Account,Sale,Purchase,Production,"Quality & PM",Stores;

            trigger OnValidate()
            begin
                RestrictModifyAction();
            end;
        }
        field(11; Remarks1; Text[250])
        {

            trigger OnValidate()
            begin
                RestrictModifyAction();
            end;
        }
        field(12; Remarks2; Text[250])
        {
        }
        field(13; "Issue Resolution"; Text[250])
        {
        }
        field(14; "Resolved by"; Text[100])
        {
        }
        field(15; "Resolved Date"; Date)
        {
        }
        field(16; Contact; Code[100])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                EmployeeMaster.Reset;
                EmployeeMaster.SetFilter(EmployeeMaster."No.", Contact);
                if EmployeeMaster.FindFirst then begin
                    Name := EmployeeMaster."First Name";
                    "Phone No." := EmployeeMaster."Phone No.";
                    "Mobile No." := EmployeeMaster."Mobile Phone No.";
                    Email := EmployeeMaster."E-Mail";
                end;
            end;
        }
        field(17; Name; Text[100])
        {
        }
        field(18; "Phone No."; Text[30])
        {
        }
        field(19; "Mobile No."; Text[10])
        {
        }
        field(20; Email; Text[50])
        {
        }
        field(21; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Closed,WIP';
            OptionMembers = Open,Closed,WIP;
        }
        field(22; "No."; Integer)
        {

            trigger OnValidate()
            begin
                /*   IF Status = 1 THEN BEGIN
                    Closed:=TRUE;
                    modify(true);
                   END;
                 */

            end;
        }
        field(23; Closed; Boolean)
        {
            Editable = false;
        }
        field(24; Priority; Option)
        {
            OptionCaption = 'Low,Medium,High,Urgent ';
            OptionMembers = Low,Medium,High,"Urgent ";

            trigger OnValidate()
            begin
                RestrictModifyAction();
            end;
        }
        field(25; Responsibility; Option)
        {
            OptionCaption = ',Samadhan,Customer Project Manager,Related User';
            OptionMembers = ,Samadhan,"Customer Project Manager","Related User";
        }
        field(26; "Resolution Date"; Date)
        {
        }
        field(27; "CRM Tracking ID"; Code[50])
        {
        }
        field(100; "Sale Document Type"; Option)
        {
            OptionCaption = 'Sales Order,Sales Shipment,Sales Invoice';
            OptionMembers = "Sales Order","Sales Shipment","Sales Invoice";

            trigger OnValidate()
            begin
                TestField("Sale Document No.", '');
            end;
        }
        field(101; "Sale Document No."; Code[50])
        {
            TableRelation = IF ("Sale Document Type" = CONST ("Sales Order")) "Sales Header"."No." WHERE ("Document Type" = CONST (Order),
                                                                                                       "Sell-to Customer No." = FIELD ("Customer Code"))
            ELSE
            IF ("Sale Document Type" = CONST ("Sales Shipment")) "Sales Shipment Header"."No." WHERE ("Sell-to Customer No." = FIELD ("Customer Code"))
            ELSE
            IF ("Sale Document Type" = CONST ("Sales Invoice")) "Sales Invoice Header"."No." WHERE ("Sell-to Customer No." = FIELD ("Customer Code"));
        }
        field(1000; "Issue Type"; Option)
        {
            OptionCaption = 'Internal,Case';
            OptionMembers = Internal,"Case";
        }
        field(1001; "Customer Code"; Code[50])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                // Lines aded By Deepak Kumar
                Customer.Reset;
                Customer.SetRange(Customer."No.", "Customer Code");
                if Customer.FindFirst then begin
                    "Customer Name" := Customer.Name;
                    Name := Customer.Contact;
                    "Phone No." := Customer."Phone No.";
                    Email := Customer."E-Mail";
                end else begin
                    "Customer Name" := '';
                    Name := '';
                    "Phone No." := '';
                    Email := '';


                end;
            end;
        }
        field(1002; "Customer Name"; Text[150])
        {
        }
        field(1003; "Sales Person Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(1501; "Picture 1"; BLOB)
        {
            CaptionML = ENU = 'Picture';
            SubType = Bitmap;
        }
        field(1502; "Picture 2"; BLOB)
        {
            CaptionML = ENU = 'Picture';
            SubType = Bitmap;
        }
        field(1503; "Picture 3"; BLOB)
        {
            CaptionML = ENU = 'Picture';
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; "Issue Type", "No.", "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //Deepak
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        if (UserSetup.FindFirst) then begin
            if not UserSetup."Delete Issue List" then
                Error('You are not authorized to delete');
        end;
    end;

    trigger OnInsert()
    begin
        "Issue Master".Reset;
        "Issue Master".SetRange("Issue Master"."Issue Type", "Issue Type");
        if "Issue Master".FindLast then begin
            IssueID := "Issue Master"."No." + 1;
            "No." := IssueID;
            Code := Format("Issue Type") + '-' + Format(IssueID);
        end else begin
            IssueID := 1;
            "No." := IssueID;
            Code := Format("Issue Type") + '-' + Format(IssueID);


        end;

        "Open by" := UserId;
        "Open Date" := WorkDate;
    end;

    var
        IssueID: Integer;
        EmployeeMaster: Record Employee;
        "Issue Master": Record "Issue Log";
        UID: Code[30];
        UserSetup: Record "User Setup";
        Customer: Record Customer;

    procedure CloseIssue(IssueType: Option Internal,"Case"; IssueNumber: Integer)
    var
        Question: Text[250];
        Answer: Boolean;
    begin
        // Lines added BY Deepak Kumar
        "Issue Master".Reset;
        "Issue Master".SetRange("Issue Master"."Issue Type", IssueType);
        "Issue Master".SetRange("Issue Master"."No.", IssueNumber);
        if "Issue Master".FindFirst then begin
            if "Issue Master".Status = "Issue Master".Status::Closed then
                Error(' Issue is already closed');
            "Issue Master".TestField("Issue Master"."Issue Resolution");

            Question := 'Do you want to Close issue ID ' + Format(IssueType) + '-' + Format(IssueNumber) + '?';
            Answer := DIALOG.Confirm(Question, true);
            if Answer = true then begin
                "Issue Master".Status := 1;
                "Issue Master".Closed := true;
                "Issue Master".Modify(true);
                Message('Issue Closed Successfully ');
            end else begin
                Message('Action Cancelled');
            end;
        end;
    end;

    procedure RestrictModifyAction()
    begin
        UID := UserId;
        if "Open by" <> UID then
            Error('User can modify only own issue');
    end;

    procedure ReOpenIssue(IssueType: Option Internal,"Case"; IssueNumber: Integer)
    var
        Question: Text[250];
        Answer: Boolean;
    begin
        // Lines added BY Deepak Kumar
        "Issue Master".Reset;
        "Issue Master".SetRange("Issue Master"."Issue Type", IssueType);
        "Issue Master".SetRange("Issue Master"."No.", IssueNumber);
        if "Issue Master".FindFirst then begin
            if "Issue Master".Status = "Issue Master".Status::Open then
                Error('Issue is already in Open Stage');

            Question := 'Do you want to Re-Open issue ID ' + Format(IssueType) + '-' + Format(IssueNumber) + '?';
            Answer := DIALOG.Confirm(Question, true);
            if Answer = true then begin
                "Issue Master".Status := "Issue Master".Status::Open;
                "Issue Master".Closed := false;
                "Issue Master".Modify(true);
                Message('Issue Re-Opened Successfully ');
            end else begin
                Message('Action Cancelled');
            end;
        end;
    end;
}

