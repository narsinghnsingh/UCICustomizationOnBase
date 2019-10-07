report 50123 "Update Total Daily Attendance"
{
    // version USE

    // DefaultLayout = RDLC;
    // RDLCLayout = '.vscode/Reports/50000/Update Total Daily Attendance.rdl';
    Caption = 'Update Total Daily Attendance';
    ProcessingOnly = true;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Daily Attendance"; "Daily Attendance")
        {
            DataItemTableView = WHERE ("Not Joined" = CONST (0));
            RequestFilterFields = Month, Year;

            trigger OnAfterGetRecord()
            begin
                if ("Time In" <> 0T) and ("Time Out" <> 0T) then begin
                    Validate("Daily Attendance"."Time In");
                    Validate("Daily Attendance"."Time Out");
                end else begin
                    "Daily Attendance"."Time In" := 0T;
                    "Daily Attendance"."Time Out" := 0T;
                    "Daily Attendance"."OT Hrs." := 0;
                    "Daily Attendance"."Early Going Hrs." := 0;
                    "Daily Attendance"."Hours Worked" := 0;
                    "Daily Attendance"."Reporting Hours Worked" := 0;
                    "Daily Attendance"."Reporting OT Hrs." := 0;
                    "Daily Attendance"."Late Hrs." := 0;
                    "Daily Attendance"."Late Time" := 0;
                    "Daily Attendance"."Attendance Type" := "Daily Attendance"."Attendance Type"::Present;
                    "Daily Attendance"."OT Approved Hrs." := 0;
                    "Late Coming Minutes" := '';
                    "Early Going Minutes" := '';
                end;

                Modify;
            end;

            trigger OnPostDataItem()
            begin
                Message('Done');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

