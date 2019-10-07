report 50126 "Update Full Mth LOP NonWorking"
{
    // version USE

    // DefaultLayout = RDLC;
    // RDLCLayout = '.vscode/Reports/50000/Update Full Mth LOP NonWorking.rdl';
    Caption = 'Update Full Mth LOP NonWorking';
    ProcessingOnly = true;
    UsageCategory = Documents;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee_B2B; Employee_B2B)
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending);
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                MonthlyAttendance.Reset;
                MonthlyAttendance.SetRange("Employee No.", Employee_B2B."No.");
                MonthlyAttendance.SetRange("Pay Slip Month", MonthVar);
                MonthlyAttendance.SetRange(Year, YearVar);
                if MonthlyAttendance.FindFirst then begin
                    MonthlyAttendance.CalcFields(Days);
                    MonthlyAttendance.CalcFields("Weekly Off");
                    MonthlyAttendance.CalcFields(Holidays);
                    MonthlyAttendance.CalcFields("Loss Of Pay");
                    if MonthlyAttendance.Days <= MonthlyAttendance."Weekly Off" + MonthlyAttendance."Loss Of Pay" + MonthlyAttendance.Holidays then begin
                        DailyAttendance.Reset;
                        DailyAttendance.SetRange("Employee No.", Employee_B2B."No.");
                        DailyAttendance.SetRange(Month, MonthVar);
                        DailyAttendance.SetRange(Year, YearVar);
                        DailyAttendance.SetRange("Non-Working", true);
                        if DailyAttendance.FindSet then
                            repeat
                                DailyAttendance.Validate("Attendance Type", DailyAttendance."Attendance Type"::Absent);
                                DailyAttendance.Modify;
                            until DailyAttendance.Next = 0;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Done');
            end;

            trigger OnPreDataItem()
            begin
                if (MonthVar = 0) or (YearVar = 0) then
                    Error('Please update the month & Year');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(MonthVar; MonthVar)
                {
                    Caption = 'Month';
                }
                field(YearVar; YearVar)
                {
                    Caption = 'Year';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        DailyAttendance: Record "Daily Attendance";
        MonthlyAttendance: Record "Monthly Attendance";
        MonthVar: Integer;
        YearVar: Integer;
}

