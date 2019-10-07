tableextension 50005 Ext_UserSetup_MPW extends "User Setup"
{
    fields
    {
        field(50001; Vendor; Boolean)
        {
            Description = '//Deepak';
        }
        field(50002; Customer; Boolean)
        {
            Description = '//Deepak';
        }
        field(50003; Item; Boolean)
        {
            Description = '//Deepak';
        }
        field(50004; "Job ReOpen"; Boolean)
        {
        }
        field(50010; "Approval Authority Vendor"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50011; "Approval Authority Customer"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50012; "Approval Authority Item"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50013; "Production Planner"; Boolean)
        {
            Description = '//deepak';
        }
        field(50014; "Estimate Approver"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50015; "Delete Issue List"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50017; "Approval Authority Pre-Press"; Boolean)
        {
            Description = '//Deepak Used for Estimate Approve';
        }
        field(50018; "Approval Authority Production"; Boolean)
        {
            Description = '//Deepak Used for Estimate Approve';
        }
        field(50019; "Approval Authority Extra Cons"; Boolean)
        {
            Description = '//Deepak// For Approval of Extra Consumtion Posting';
        }

        field(62000; "New Posting From"; Date)
        {
            Description = '//Deepak';
        }
        field(62001; "New Posting To"; Date)
        {
            Description = '//Deepak';
        }
        field(62003; "Conditional User"; Boolean)
        {
            Description = '//Deepak';

            trigger OnValidate()
            begin
                //Permission;
            end;
        }
        field(62004; "Auth. Store User"; Boolean)
        {
            Description = '//Deepak// Curr in use for approval of componet';
        }
        field(62005; "Auth. Production User"; Boolean)
        {
            Description = '//Deepak// Curr in use for approval of componet';
        }
        field(62006; "Auth. For Sale E/Q/O"; Boolean)
        {
            Description = '//deepak';
        }
        field(62007; "Sales Supervisor"; Boolean)
        {
            CaptionML = ENU = 'All Sales ';
            Description = '//deepak';
        }
        field(62008; "Extra Material Approval"; Boolean)
        {
            Description = '//deepak';
        }
        field(62009; "Last Stage Output Permission"; Boolean)
        {
            Description = '//Deepak';
        }
        field(62010; "Auth. Printing User"; Boolean)
        {
            Description = '//deepak// For Dupliex Sheet Printing Approval User';

            trigger OnValidate()
            begin
                IF "Auth. Printing User" = TRUE THEN
                    TESTFIELD("Auth. Store User", FALSE);
            end;
        }
        field(62011; "RPO Approver"; Boolean)
        {
            Description = '//Deepak// for RPO Approver USer';
        }
        field(62012; "Product Design Delete"; Boolean)
        {
            Description = '//Deepak';
        }
        field(62013; "Delete Sales Line"; Boolean)
        {
            Description = '//Delete Sales Line By Anurag';
        }
        field(62014; "Delete Sales Header"; Boolean)
        {
            Description = '//Delete Sales Header By Anurag';
        }
        field(62015; "Manual Requisition Creation"; Boolean)
        {
        }
        field(62016; "Manual Requisition Approval"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(62017; "ReOpen PDI"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(62018; "Allow Reverse Con/Output"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(62019; "Print Allowed"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(62020; "Change Sales Line"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(62021; "Delete PDI Additional"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(62022; "Return Packing list Approver"; Boolean)
        {

        }
    }

    var
        UserSetup: Record "User Setup";

    procedure CheckProdAuth()
    begin
    end;

    procedure CheckItemAuth(USERCode: Code[50])
    begin
        // Lines added BY deepak Kumar
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERCode);
        IF UserSetup.FINDFIRST THEN BEGIN
            IF NOT UserSetup.Item = TRUE THEN BEGIN
                ERROR('You are not authorised for "Item", Please contact your System Administrator');
            END;
        END;
    end;

    procedure CheckEstimateAprrover(USERCode: Code[50])
    begin
        // Lines added BY deepak Kumar
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERCode);
        IF UserSetup.FINDFIRST THEN BEGIN
            IF NOT UserSetup."Estimate Approver" = TRUE THEN BEGIN
                ERROR('You are not authorised for "Estimate", Please contact your System Administrator');
            END;
        END;
    end;

    procedure CheckDeleteSalesLine(USERCode: Code[50])
    begin
        //Restrict Sales Line Delete in Sales Order (Added By Anurag Kumar)
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERCode);
        IF UserSetup.FINDFIRST THEN BEGIN
            // MESSAGE(FORMAT(UserSetup."Delete Sales Line"));
            IF NOT UserSetup."Delete Sales Line" = TRUE THEN BEGIN
                ERROR('You are not authorised for "Deletion of sales Line", Please contact your System Administrator');
            END;
        END;
    end;

    procedure CheckDeleteSalesHeader(USERCode: Code[50])
    begin
        //Restrict Delete of Sales Order (Added By Anurag Kumar)
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERID);
        IF UserSetup.FINDFIRST THEN BEGIN
            IF NOT UserSetup."Delete Sales Header" = TRUE THEN BEGIN
                ERROR('You are not authorised for "Deletion of sales Header", Please contact your System Administrator');
            END;
        END;
    end;
}