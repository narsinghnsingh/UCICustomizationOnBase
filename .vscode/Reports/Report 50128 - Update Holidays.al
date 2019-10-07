report 50128 "Update Holidays"
{
    // DefaultLayout = RDLC;
    // RDLCLayout = '.vscode/Reports/50000/Update Holidays.rdl';
    Caption = 'Update Holidays';
    ProcessingOnly = true;
    UsageCategory = Documents;
    ApplicationArea = All;

    dataset
    {
        dataitem("Daily Attendance"; "Daily Attendance")
        {
            DataItemTableView = SORTING ("Employee No.", Date) ORDER(Ascending) WHERE (Month = CONST (12), Date = FILTER (20171203D));

            trigger OnAfterGetRecord()
            begin
                "Daily Attendance".Validate("Non-Working Type", "Non-Working Type"::" ");
                "Daily Attendance".Validate("Non-Working", false);
                "Daily Attendance".Validate("Attendance Type", "Daily Attendance"."Attendance Type"::Present);
                "Daily Attendance".Validate(Holiday, 0);
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

