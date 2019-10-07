report 50121 "Update Rev Empty"
{
    // DefaultLayout = RDLC;
    // RDLCLayout = '.vscode/Reports/50000/Update Rev Empty.rdl';
    Caption = 'Update Rev Empty';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Daily Attendance"; "Daily Attendance")
        {
            DataItemTableView = SORTING ("Employee No.", Date) ORDER(Ascending) WHERE (Date = FILTER (20180301D .. 20180331D));

            trigger OnAfterGetRecord()
            begin
                "Daily Attendance"."Revised Shift Code" := '';
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

