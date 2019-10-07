report 50127 "Update Weekoffs"
{
    // DefaultLayout = RDLC;
    // RDLCLayout = '.vscode/Reports/50000/Update Weekoffs.rdl';
    Caption = 'Update Weekoffs';
    ProcessingOnly = true;
    UsageCategory = Documents;
    dataset
    {
        dataitem("Daily Attendance"; "Daily Attendance")
        {
            DataItemTableView = SORTING ("Employee No.", Date) ORDER(Ascending) WHERE ("Not Joined" = FILTER (0), Date = FILTER (20180504D | 20180511D | 20180518D | 20180525D));
            RequestFilterFields = "Employee No.";

            trigger OnAfterGetRecord()
            begin
                "Daily Attendance".Validate("Non-Working Type", "Non-Working Type"::OffDay);
                "Daily Attendance".Validate("Non-Working", true);
                "Daily Attendance".Validate("Attendance Type", "Daily Attendance"."Attendance Type"::Present);
                "Daily Attendance".Validate("Weekly Off", 1);
                Modify;
                /*
                "Daily Attendance".VALIDATE("Non-Working Type","Non-Working Type"::" ");
                "Daily Attendance".VALIDATE("Non-Working",FALSE);
                "Daily Attendance".VALIDATE("Attendance Type","Daily Attendance"."Attendance Type"::Present);
                "Daily Attendance".VALIDATE("Weekly Off",0);
                MODIFY;
                 */

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

