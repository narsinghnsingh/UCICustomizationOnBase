codeunit 50005 "Update Att"
{

    trigger OnRun()
    begin
        DailyAttendance.Reset;
        DailyAttendance.SetFilter(Date, '13092018D');
        //DailyAttendance.SETFILTER("Employee No.",'<>%1|<>%2','EMP2026','EMP1055');
        if DailyAttendance.FindSet then
            repeat
                DailyAttendance.Validate("Time Out");
                DailyAttendance.Modify();
            until DailyAttendance.Next = 0;


        Message('Done');
    end;

    var
        DailyAttendance: Record "Daily Attendance";
        oldTime: Time;
}

