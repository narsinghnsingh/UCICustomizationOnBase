report 50118 "Update Time shi"
{
    // DefaultLayout = RDLC;
    // RDLCLayout = '.vscode/Reports/50000/Update Time shi.rdl';
    Caption = 'Update Time sheet';
    ProcessingOnly = true;
    UsageCategory = Documents;

    dataset
    {
        dataitem(Employee_B2B; Employee_B2B)
        {

            trigger OnAfterGetRecord()
            begin
                CalendarGeneration.UpdateShiftTimings(Employee_B2B)
            end;

            trigger OnPostDataItem()
            begin
                Message('Done');
            end;
        }
    }

    var
        CalendarGeneration: Codeunit "Calendar Generation";
}

