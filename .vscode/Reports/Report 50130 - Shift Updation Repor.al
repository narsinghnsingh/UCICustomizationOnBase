report 50130 "Shift Updation Repor"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Daily Attendance"; "Daily Attendance")
        {
            DataItemTableView = WHERE (Date = FILTER (20180101D .. 20180331D));

            trigger OnAfterGetRecord()
            begin
                EmployeeShift.Reset;
                EmployeeShift.SetRange("Employee No.", "Daily Attendance"."Employee No.");
                EmployeeShift.SetRange("Start Date", "Daily Attendance".Date);
                if EmployeeShift.FindFirst then begin
                    ShiftMaster.Reset;
                    ShiftMaster.SetRange("Shift Code", EmployeeShift."Shift Code");
                    ShiftMaster.SetRange("Location Code", "Daily Attendance"."Location Code");
                    if ShiftMaster.FindFirst then begin
                        "Daily Attendance"."Shift Code" := ShiftMaster."Shift Code";
                        "Daily Attendance"."Actual Time In" := ShiftMaster."Starting Time";
                        "Daily Attendance"."Actual Time Out" := ShiftMaster."Ending Time";
                        "Daily Attendance".Modify;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                "Daily Attendance".SetRange("Daily Attendance".Date, DMY2Date(1, 1, 2018), DMY2Date(31, 3, 2018));
                //"Daily Attendance".SETRANGE("Employee No.",'EMP2052');
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

    trigger OnPostReport()
    begin
        Message('Modified');
    end;

    var
        ShiftMaster: Record "Shift Master";
        EmployeeShift: Record "Employee Shift";
}

