report 50122 "Update Employee Shift"
{
    // version USE

    ProcessingOnly = true;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Employee Shift"; "Employee Shift")
        {
            RequestFilterFields = "Shift Code", "Start Date";

            trigger OnAfterGetRecord()
            begin
                /*
              //"Employee Shift".VALIDATE("Shift Code" );
              //MODIFY;
              DailyAttendance.RESET;
              DailyAttendance.SETRANGE("Employee No.","Employee Shift"."Employee No.");
              DailyAttendance.SETRANGE("Shift Code","Employee Shift"."Shift Code");
              //DailyAttendance.SETFILTER(Date,'>=%1',"Employee Shift"."Start Date");
              IF DailyAttendance.FINDFIRST THEN BEGIN
                REPEAT
                  IF EmpNoGVar <>  DailyAttendance."Employee No." THEN BEGIN
                    EmpNoGVar :=  DailyAttendance."Employee No.";
                    Window.UPDATE(1,DailyAttendance."Employee No.");
                  END;
                  DailyAttendance.VALIDATE("Shift Code");
                  DailyAttendance."Actual Time In" := "Employee Shift"."Shift Start Time";
                  DailyAttendance.VALIDATE("Actual Time Out","Employee Shift"."Shift End Time");
                  DailyAttendance.MODIFY;
                UNTIL DailyAttendance.NEXT = 0;
              END;

              DailyAttendance.RESET;
              DailyAttendance.SETRANGE("Employee No.","Employee Shift"."Employee No.");
              DailyAttendance.SETRANGE("Revised Shift Code","Employee Shift"."Shift Code");
              //DailyAttendance.SETFILTER(Date,'>=%1',"Employee Shift"."Start Date");
              IF DailyAttendance.FINDFIRST THEN BEGIN
                REPEAT
                  IF EmpNoGVar <>  DailyAttendance."Employee No." THEN BEGIN
                    EmpNoGVar :=  DailyAttendance."Employee No.";
                    Window.UPDATE(1,DailyAttendance."Employee No.");
                  END;
                  DailyAttendance.VALIDATE("Revised Shift Code");
                  DailyAttendance."Actual Time In" := "Employee Shift"."Shift Start Time";
                DailyAttendance.VALIDATE("Actual Time Out","Employee Shift"."Shift End Time");
                DailyAttendance.MODIFY;
                UNTIL DailyAttendance.NEXT = 0;
              END;
                */
                UpdateShiftTimings2("Employee Shift");

            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message('Done');
            end;

            trigger OnPreDataItem()
            begin
                if "Employee Shift".GetFilter("Start Date") = '' then
                    Error('Provide start date range');
                //IF "Employee Shift".GETFILTER("Shift Code") = '' THEN
                // ERROR('Provide Shift Code');
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

    procedure UpdateShiftTimings2(EmployeeShiftP: Record "Employee Shift")
    var
        DailyAttendance: Record "Daily Attendance";
        EmployeeShift: Record "Employee Shift";
        EndDate: Date;
        StartDate: Date;
        StartTime: Time;
        EndTime: Time;
        CheckTime: Time;
        StartDateTime: DateTime;
        EndDateTime: DateTime;
        PayYear: Record "Payroll Year";
    begin
        CheckTime := 130000T;
        EmployeeShift.SetRange("Employee No.", EmployeeShiftP."Employee No.");
        EmployeeShift.SetRange("Start Date", EmployeeShiftP."Start Date");
        if EmployeeShift.FindFirst then begin
            //REPEAT
            StartTime := EmployeeShift."Shift Start Time";
            EndTime := EmployeeShift."Shift End Time";
            StartDate := EmployeeShift."Start Date";
            EndDate := EmployeeShift."Start Date";
            DailyAttendance.Reset;
            DailyAttendance.SetRange("Employee No.", EmployeeShiftP."Employee No.");
            DailyAttendance.SetRange(Date, StartDate);
            if DailyAttendance.Find('-') then begin
                repeat
                    /*
                    //DailyAttendance."Time In" := StartTime;
                    //DailyAttendance."Time Out" := EndTime;
                    IF (StartTime > CheckTime) AND (EndTime < CheckTime) THEN BEGIN
                      StartDateTime := CREATEDATETIME(DailyAttendance.Date,DailyAttendance."Time In");
                      EndDateTime :=   CREATEDATETIME((DailyAttendance.Date+1),DailyAttendance."Time Out");
                      DailyAttendance."Hours Worked" := ABS((StartDateTime-EndDateTime)/3600000) - EmployeeShift."Break Duration";
                    END ELSE
                      DailyAttendance."Hours Worked" :=
                        ABS((DailyAttendance."Time In" - DailyAttendance."Time Out")/3600000) -
                        EmployeeShift."Break Duration";
                        */
                    DailyAttendance."Actual Time In" := StartTime;
                    DailyAttendance."Actual Time Out" := EndTime;
                    if (StartTime > CheckTime) and (EndTime < CheckTime) then begin
                        StartDateTime := CreateDateTime(DailyAttendance.Date, DailyAttendance."Actual Time In");
                        EndDateTime := CREATEDATETIME((DailyAttendance.Date + 1), DailyAttendance."Actual Time Out");
                        DailyAttendance."Actual Hrs." := Abs((StartDateTime - EndDateTime) / 3600000) - EmployeeShift."Break Duration";
                    end else
                        DailyAttendance."Actual Hrs." :=
                          Abs((DailyAttendance."Actual Time In" - DailyAttendance."Actual Time Out") / 3600000) -
                          EmployeeShift."Break Duration";
                    DailyAttendance."Revised Shift Code" := EmployeeShift."Shift Code";
                    DailyAttendance.Modify;
                until DailyAttendance.Next = 0;
            end;
            //UNTIL EmployeeShift.NEXT = 0;
        end;

    end;
}

