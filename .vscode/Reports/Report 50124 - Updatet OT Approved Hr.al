report 50124 "Updatet OT Approved Hr."
{
    // version USE

    // DefaultLayout = RDLC;
    // RDLCLayout = '.vscode/Reports/50000/Updatet OT Approved Hr..rdl';
    Caption = 'Updatet OT Approved Hr.';
    ProcessingOnly = true;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Daily Attendance"; "Daily Attendance")
        {
            DataItemTableView = SORTING ("Employee No.", Date) ORDER(Ascending) WHERE ("OT Hrs." = FILTER (<> 0));
            RequestFilterFields = "Employee No.", Date;

            trigger OnAfterGetRecord()
            begin
                Validate("OT Approved Hrs.", "OT Hrs.");
                Modify;
            end;

            trigger OnPostDataItem()
            begin
                Message('OT approved hrs. updated successfully');
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

