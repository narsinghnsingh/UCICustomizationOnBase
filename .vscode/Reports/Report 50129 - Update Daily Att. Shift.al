report 50129 "Update Daily Att. Shift"
{
    // version USE

    ProcessingOnly = true;
    UsageCategory = Documents;
    ApplicationArea = All;

    dataset
    {
        dataitem("Employee Shift"; "Employee Shift")
        {
            RequestFilterFields = "Shift Code", "Start Date";

            trigger OnAfterGetRecord()
            begin
                Validate("Shift Code");
                Modify;
                DailyAttendance.Reset;
                DailyAttendance.SetRange("Employee No.", "Employee No.");
                DailyAttendance.SetRange(Date, "Start Date");
                if DailyAttendance.FindFirst then begin
                    Window.Update(1, DailyAttendance."Employee No.");
                    DailyAttendance.Validate("Revised Shift Code", "Employee Shift"."Shift Code");
                    DailyAttendance."Actual Time In" := "Employee Shift"."Shift Start Time";
                    DailyAttendance.Validate("Actual Time Out", "Employee Shift"."Shift End Time");
                    DailyAttendance.Modify;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message('Done');
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Updating Daily Attendance Table : #1#######');
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

    var
        DailyAttendance: Record "Daily Attendance";
        Window: Dialog;
        EmpNoGVar: Code[20];
}

