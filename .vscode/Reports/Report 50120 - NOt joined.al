report 50120 "NOt joined"
{
    // DefaultLayout = RDLC;
    // RDLCLayout = '.vscode/Reports/50000/NOt joined.rdl';
    Caption = 'NOt joined';
    ProcessingOnly = true;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Daily Attendance"; "Daily Attendance")
        {
            DataItemTableView = WHERE ("Not Joined" = FILTER (<> 0));

            trigger OnAfterGetRecord()
            begin
                //"Daily Attendance".VALIDATE("Attendance Type","Daily Attendance"."Attendance Type"::Present);
                "Daily Attendance".Present := 0;
                "Daily Attendance".Absent := 0;
                "Daily Attendance".Leave := 0;

                Modify;
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

