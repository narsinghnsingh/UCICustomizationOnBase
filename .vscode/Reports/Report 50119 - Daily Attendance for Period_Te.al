report 50119 "Daily Attendance for Period_T"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Daily Attendance for Period_Te.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Employee_B2B; Employee_B2B)
        {
            // DataItemTableView = SORTING("Department Code") ORDER(Ascending);
            // RequestFilterFields = "Department Code";
            dataitem("Daily Attendance"; "Daily Attendance")
            {
                DataItemLink = "Employee No." = FIELD ("No.");
                DataItemTableView = SORTING ("Employee No.", Date) ORDER(Ascending);
                RequestFilterFields = Month, Year;
                column(ReportingOTHrs_DailyAttendance; "Daily Attendance"."Reporting OT Hrs.")
                {
                }
                column(EmployeeName; EmployeeName)
                {
                }
                column(SLNo; SLNo)
                {
                }
                column(CompanyInfo_Name; CompanyInfo.Name)
                {
                }
                column(CompanyInfo_Address; CompanyInfo.Address)
                {
                }
                column(CompanyInfo_Address2; CompanyInfo."Address 2")
                {
                }
                column(EmployeeNo_DailyAttendance; "Daily Attendance"."Employee No.")
                {
                }
                column(Date_DailyAttendance; "Daily Attendance".Date)
                {
                }
                column(TimeIn_DailyAttendance; "Daily Attendance"."Time In")
                {
                }
                column(TimeOut_DailyAttendance; "Daily Attendance"."Time Out")
                {
                }
                column(HoursWorked_DailyAttendance; "Daily Attendance"."Hours Worked")
                {
                }
                column(ShiftCode_DailyAttendance; "Daily Attendance"."Shift Code")
                {
                }
                column(AttendanceType_DailyAttendance; "Daily Attendance"."Attendance Type")
                {
                }
                column(Holiday_DailyAttendance; "Daily Attendance".Holiday)
                {
                }
                column(Year_DailyAttendance; "Daily Attendance".Year)
                {
                }
                column(Month_DailyAttendance; "Daily Attendance".Month)
                {
                }
                column(EmployeeName_DailyAttendance; "Daily Attendance"."Employee Name")
                {
                }
                column(LeaveCode_DailyAttendance; "Daily Attendance"."Leave Code")
                {
                }
                column(Present_DailyAttendance; "Daily Attendance".Present)
                {
                }
                column(Absent_DailyAttendance; "Daily Attendance".Absent)
                {
                }
                column(Leave_DailyAttendance; "Daily Attendance".Leave)
                {
                }
                column(ActualTimeIn_DailyAttendance; "Daily Attendance"."Actual Time In")
                {
                }
                column(ActualTimeOut_DailyAttendance; "Daily Attendance"."Actual Time Out")
                {
                }
                column(OTHrs_DailyAttendance; "Daily Attendance"."OT Hrs.")
                {
                }
                column(OTApprovedHrs_DailyAttendance; "Daily Attendance"."OT Approved Hrs.")
                {
                }
                column(ActualHrs_DailyAttendance; "Daily Attendance"."Actual Hrs.")
                {
                }
                column(TiminRegister_CaptionLbl; TiminRegister_CaptionLbl)
                {
                }
                column(ForTheMoonthOf_CaptionLbl; ForTheMoonthOf_CaptionLbl)
                {
                }
                column(PrintedOn_CaptionLbl; PrintedOn_CaptionLbl)
                {
                }
                column(Legends_CaptionLbl; Legends_CaptionLbl)
                {
                }
                column(PP_CaptionLbl; PP_CaptionLbl)
                {
                }
                column(PhysicalPresent_CaptionLbl; PhysicalPresent_CaptionLbl)
                {
                }
                column(AB_CaptionLbl; AB_CaptionLbl)
                {
                }
                column(Absent_CaptionLbl; Absent_CaptionLbl)
                {
                }
                column(HL_CaptionLbl; HL_CaptionLbl)
                {
                }
                column(Holiday_CaptionLbl; Holiday_CaptionLbl)
                {
                }
                column(OD_CaptionLbl; OD_CaptionLbl)
                {
                }
                column(OffDay_CaptionLbl; OffDay_CaptionLbl)
                {
                }
                column(CL_CaptionLbl; CL_CaptionLbl)
                {
                }
                column(CasualLeave_CaptionLbl; CasualLeave_CaptionLbl)
                {
                }
                column(SL_CaptionLbl; SL_CaptionLbl)
                {
                }
                column(SickLeave_CaptionLbl; SickLeave_CaptionLbl)
                {
                }
                column(AL_CaptionLbl; AL_CaptionLbl)
                {
                }
                column(AnualLeave_CaptionLbl; AnualLeave_CaptionLbl)
                {
                }
                column(SP_CaptionLbl; SP_CaptionLbl)
                {
                }
                column(SpecialLeave_CaptionLbl; SpecialLeave_CaptionLbl)
                {
                }
                column(PageNo_Caption; PageNo_Caption)
                {
                }
                column(SNo_CaptionLbl; SNo_CaptionLbl)
                {
                }
                column(ECode_CaptionLbl; ECode_CaptionLbl)
                {
                }
                column(EmplyeeName_CaptionLbl; EmplyeeName_CaptionLbl)
                {
                }
                column(Signature_CaptionLbl; Signature_CaptionLbl)
                {
                }
                column(Total_CaptionLbl; Total_CaptionLbl)
                {
                }
                column(IN_CaptionLbl; IN_CaptionLbl)
                {
                }
                column(OUT_CaptionLbl; OUT_CaptionLbl)
                {
                }
                column(OTH_CaptionLbl; OTH_CaptionLbl)
                {
                }
                column(ODH_CaptionLbl; ODH_CaptionLbl)
                {
                }
                column(Days_CaptionLbl; Days_CaptionLbl)
                {
                }
                column(HDH_CaptionLbl; HDH_CaptionLbl)
                {
                }
                column(LateTime_CaptionLbl; LateTime_CaptionLbl)
                {
                }
                column(EarlyTime_CaptionLbl; EarlyTime_CaptionLbl)
                {
                }
                column(GrandOT_CaptionLbl; GrandOT_CaptionLbl)
                {
                }
                column(ONTIME_CaptionLbl; ONTIME_CaptionLbl)
                {
                }
                column(LateDays_CaptionLbl; LateDays_CaptionLbl)
                {
                }
                column(EarlyDays_CaptionLbl; EarlyDays_CaptionLbl)
                {
                }
                column(OTperDay1_CaptionLbl; OTperDay1_CaptionLbl)
                {
                }
                column(OTperDay2_CaptionLbl; OTperDay2_CaptionLbl)
                {
                }
                column(OTperDay3_CaptionLbl; OTperDay3_CaptionLbl)
                {
                }
                column(PayrollStaff_CaptionLbl; PayrollStaff_CaptionLbl)
                {
                }
                column(DayVar; DayVar)
                {
                }
                column(DateNo; DateNo)
                {
                }
                column(MonthlyReport; MonthlyReport)
                {
                }
                column(EmployeeDept; EmployeeDept)
                {
                }
                column(MonthlyReportValue; MonthlyReportValue)
                {
                }
                column(DayVarShort; DayVarShort)
                {
                }
                column(CountVar; CountVar)
                {
                }
                column(MonthVar; MonthVar)
                {
                }
                column(LateHrs; LateHrs)
                {
                }
                column(EarlyHrs; EarlyHrs)
                {
                }
                dataitem("Monthly Attendance"; "Monthly Attendance")
                {
                    DataItemLink = "Employee No." = FIELD ("Employee No."), "Pay Slip Month" = FIELD (Month), Year = FIELD (Year);
                    column(Attendance_MonthlyAttendance; "Monthly Attendance".Attendance)
                    {
                    }
                    column(Days_MonthlyAttendance; "Monthly Attendance".Days)
                    {
                    }
                    column(OverTimeHrs_MonthlyAttendance; "Monthly Attendance"."Over Time Hrs.")
                    {
                    }
                    column(LateHours_MonthlyAttendance; "Monthly Attendance"."Late Hours")
                    {
                    }
                    column(Holidays_MonthlyAttendance; "Monthly Attendance".Holidays)
                    {
                    }
                    column(Year_MonthlyAttendance; "Monthly Attendance".Year)
                    {
                    }
                    column(WeeklyOff_MonthlyAttendance; "Monthly Attendance"."Weekly Off")
                    {
                    }
                    column(Phypre; Phypre)
                    {
                    }
                    column(Absen; Absen)
                    {
                    }
                    column(Holid; Holid)
                    {
                    }
                    column(OffDays; OffDays)
                    {
                    }
                    column(CalLeave; CalLeave)
                    {
                    }
                    column(SickLeave; SickLeave)
                    {
                    }
                    column(SpecialLeave; SpecialLeave)
                    {
                    }
                    column(ArnedLeave; ArnedLeave)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Employee.Get("Daily Attendance"."Employee No.") then begin
                            EmployeeName := Employee."First Name" + Employee."Middle Name" + Employee."Last Name";
                            //EmployeeDept := Employee."Department Code";
                        end;
                        DateRec.Reset;
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Date);
                        DateRec.SetRange("Period Start", "Daily Attendance".Date);
                        if DateRec.FindFirst then
                            DayVar := DateRec."Period Name";

                        DateRec.Reset;
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
                        DateRec.SetRange(DateRec."Period No.", "Daily Attendance".Month);
                        if DateRec.FindFirst then
                            MonthVar := DateRec."Period Name";

                        if PreviousEmployeeDept <> EmployeeDept then begin
                            CountVar += 1;
                            PreviousEmployeeDept := EmployeeDept;
                        end;


                        //pp
                        Clear(Phypre);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", false);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Present);
                        if DailyAttendanceGRec.FindSet then
                            repeat
                                Phypre := DailyAttendanceGRec.Count;
                            until DailyAttendanceGRec.Next = 0;


                        //Ab
                        Clear(Absen);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", false);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Absent);
                        if DailyAttendanceGRec.FindSet then
                            repeat
                                Absen := DailyAttendanceGRec.Count;
                            until DailyAttendanceGRec.Next = 0;

                        /*
                        //Hl
                        CLEAR(Holid);
                        DailyAttendanceGRec.RESET;
                        DailyAttendanceGRec.SETRANGE("Employee No.","Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SETRANGE(Year,"Monthly Attendance".Year);
                        DailyAttendanceGRec.SETRANGE(Month,"Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SETRANGE(DailyAttendanceGRec."Non-Working",FALSE);
                        DailyAttendanceGRec.SETRANGE(DailyAttendanceGRec."Attendance Type",DailyAttendanceGRec."Attendance Type"::'');
                        IF DailyAttendanceGRec.FINDSET THEN
                          REPEAT
                              Holid := DailyAttendanceGRec.COUNT;
                          UNTIL DailyAttendanceGRec.NEXT =0;
                        */

                        //OD
                        Clear(OffDays);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee NO.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", true);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Present);
                        if DailyAttendanceGRec.FindSet then
                            repeat
                                OffDays := DailyAttendanceGRec.Count;
                            until DailyAttendanceGRec.Next = 0;

                        //Cl
                        Clear(CalLeave);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", false);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Leave);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Leave Code", 'CL');
                        if DailyAttendanceGRec.FindSet then
                            repeat
                                CalLeave := DailyAttendanceGRec.Count;
                            until DailyAttendanceGRec.Next = 0;

                        //SP
                        Clear(SickLeave);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", false);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Leave);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Leave Code", 'SP');
                        if DailyAttendanceGRec.FindSet then
                            repeat
                                SickLeave := DailyAttendanceGRec.Count;
                            until DailyAttendanceGRec.Next = 0;


                        //SL
                        Clear(SpecialLeave);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", false);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Leave);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Leave Code", 'SL');
                        if DailyAttendanceGRec.FindSet then
                            repeat
                                SpecialLeave := DailyAttendanceGRec.Count;
                            until DailyAttendanceGRec.Next = 0;


                        //AL
                        Clear(ArnedLeave);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", false);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Leave);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Leave Code", 'AL');
                        if DailyAttendanceGRec.FindSet then
                            repeat
                                ArnedLeave := DailyAttendanceGRec.Count;
                            until DailyAttendanceGRec.Next = 0;

                        //On Time
                        Clear(OnTime);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", false);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Present);
                        //DailyAttendanceGRec.SETFILTER(DailyAttendanceGRec."Late Coming Minutes",'=%1','');
                        if DailyAttendanceGRec.FindSet then
                            repeat
                                if DailyAttendanceGRec."Time In" = DailyAttendanceGRec."Actual Time In" then
                                    OnTime += 1;
                            until DailyAttendanceGRec.Next = 0;
                        /*
                        //Late Days
                        CLEAR(LateDays);
                        DailyAttendanceGRec.RESET;
                        DailyAttendanceGRec.SETRANGE("Employee No.","Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SETRANGE(Year,"Monthly Attendance".Year);
                        DailyAttendanceGRec.SETRANGE(Month,"Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SETRANGE(DailyAttendanceGRec."Non-Working",FALSE);
                        DailyAttendanceGRec.SETRANGE(DailyAttendanceGRec."Attendance Type",DailyAttendanceGRec."Attendance Type"::Present);
                        DailyAttendanceGRec.SETFILTER(DailyAttendanceGRec."Late Coming Minutes",'<>%1','');
                        IF DailyAttendanceGRec.FINDSET THEN
                          REPEAT
                              LateDays := DailyAttendanceGRec.COUNT;
                          UNTIL DailyAttendanceGRec.NEXT =0;
                        */

                        //Early Days
                        Clear(EarlyDays);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Non-Working", false);
                        DailyAttendanceGRec.SetRange(DailyAttendanceGRec."Attendance Type", DailyAttendanceGRec."Attendance Type"::Present);
                        DailyAttendanceGRec.SetFilter(DailyAttendanceGRec."Late Coming Minutes", '=%1', '');
                        DailyAttendanceGRec.SetFilter(DailyAttendanceGRec."Time In", '<>%1', 0T);
                        if DailyAttendanceGRec.FindSet then begin
                            repeat
                                Clear(EarlyDaysDiff);
                                EarlyDaysDiff := DailyAttendanceGRec."Time In" - DailyAttendanceGRec."Actual Time In";
                                if (EarlyDaysDiff) < 0 then
                                    EarlyDays += 1;
                            until DailyAttendanceGRec.Next = 0;
                        end;

                        // Changes >>
                        Clear(TotOTDays);
                        Clear(OTHHrs);
                        Clear(OTWHrs);
                        Clear(OTHoliHrs);
                        Clear(TotalOTHRs);
                        Clear(OTHSumintegerpart);
                        Clear(OTHSumdecimalpart);
                        Clear(OTWSumintegerpart);
                        Clear(OTWSumdecimalpart);
                        Clear(OTHoliSumintegerpart);
                        Clear(OTHoliSumdecimalpart);
                        Clear(TotalOTHrsSumintegerpart);
                        Clear(TotalOTHrsSumdecimalpart);
                        Clear(GrandOTSumintegerpart);
                        Clear(GrandOTSumdecimalpart);
                        //--------
                        Clear(OTHintegerpart);
                        Clear(OTHdecimalpart);
                        Clear(OTHTotintegerpart);
                        Clear(OTHTotdecimalpart);
                        Clear(OTWintegerpart);
                        Clear(OTWdecimalpart);
                        Clear(OTWSumintegerpart);
                        Clear(OTWSumdecimalpart);
                        Clear(OTHoliintegerpart);
                        Clear(OTHolidecimalpart);
                        Clear(OTHoliTotintegerpart);
                        Clear(OTHoliTotdecimalpart);
                        Clear(TotalOTHrsSumintegerpart);
                        Clear(TotalOTHrsSumdecimalpart);


                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        DailyAttendanceGRec.SetFilter(DailyAttendanceGRec."Reporting OT Hrs.", '<>%1', 0);
                        if DailyAttendanceGRec.FindSet then begin
                            repeat
                                if (DailyAttendanceGRec."Non-Working" = false) and (DailyAttendanceGRec."Attendance Type" = DailyAttendanceGRec."Attendance Type"::Present) then begin
                                    OTHintegerpart := Format(DailyAttendanceGRec."Reporting OT Hrs.", 0, '<Integer,3><Filler Character,0>');
                                    OTHdecimalpart := Format(DailyAttendanceGRec."Reporting OT Hrs.", 0, '<Decimals,3><Filler Character,0>');
                                    OTHdecimalpart := DelChr(OTHdecimalpart, '=', '.');

                                    Evaluate(OTHTotintegerpart, OTHintegerpart);
                                    Evaluate(OTHTotdecimalpart, OTHdecimalpart);

                                    OTHSumintegerpart += OTHTotintegerpart;
                                    OTHSumdecimalpart += OTHTotdecimalpart;
                                end;

                                if (DailyAttendanceGRec."Non-Working" = true) and (DailyAttendanceGRec."Non-Working Type" = DailyAttendanceGRec."Non-Working Type"::OffDay) then begin
                                    OTWintegerpart := Format(DailyAttendanceGRec."Reporting OT Hrs.", 0, '<Integer,3><Filler Character,0>');
                                    OTWdecimalpart := Format(DailyAttendanceGRec."Reporting OT Hrs.", 0, '<Decimals,3><Filler Character,0>');
                                    OTWdecimalpart := DelChr(OTWdecimalpart, '=', '.');

                                    Evaluate(OTWTotintegerpart, OTWintegerpart);
                                    Evaluate(OTWTotdecimalpart, OTWdecimalpart);

                                    OTWSumintegerpart += OTWTotintegerpart;
                                    OTWSumdecimalpart += OTWTotdecimalpart;
                                end;
                                if (DailyAttendanceGRec."Non-Working" = true) and (DailyAttendanceGRec."Non-Working Type" = DailyAttendanceGRec."Non-Working Type"::Holiday) then begin
                                    OTHoliintegerpart := Format(DailyAttendanceGRec."Reporting OT Hrs.", 0, '<Integer,3><Filler Character,0>');
                                    OTHolidecimalpart := Format(DailyAttendanceGRec."Reporting OT Hrs.", 0, '<Decimals,3><Filler Character,0>');
                                    OTHolidecimalpart := DelChr(OTHolidecimalpart, '=', '.');

                                    Evaluate(OTHoliTotintegerpart, OTHoliintegerpart);
                                    Evaluate(OTHoliTotdecimalpart, OTHolidecimalpart);

                                    OTHoliSumintegerpart += OTHoliTotintegerpart;
                                    OTHoliSumdecimalpart += OTHoliTotdecimalpart;
                                end;

                                // OT Normaldays
                                if OTHSumdecimalpart > 60 then begin
                                    OTHSumintegerpart += (OTHSumdecimalpart div 60);
                                    OTHSumdecimalpart := (OTHSumdecimalpart mod 60);
                                    OTHHrs := OTHSumintegerpart + (OTHSumdecimalpart / 100);
                                end else
                                    OTHHrs := OTHSumintegerpart + (OTHSumdecimalpart / 100);

                                // OT WeekDays
                                if OTWSumdecimalpart > 60 then begin
                                    OTWSumintegerpart += (OTWSumdecimalpart div 60);
                                    OTWSumdecimalpart := (OTWSumdecimalpart mod 60);
                                    OTWHrs := OTWSumintegerpart + (OTWSumdecimalpart / 100);
                                end else
                                    OTWHrs := OTWSumintegerpart + (OTWSumdecimalpart / 100);

                                // OT Holidays
                                if OTHoliSumdecimalpart > 60 then begin
                                    OTHoliSumintegerpart += (OTHoliSumdecimalpart div 60);
                                    OTHoliSumdecimalpart := (OTHoliSumdecimalpart mod 60);
                                    OTHoliHrs := OTHoliSumintegerpart + (OTHoliSumdecimalpart / 100);
                                end else
                                    OTHoliHrs := OTHoliSumintegerpart + (OTHoliSumdecimalpart / 100);

                                //total OT Hours
                                TotalOTHrsSumintegerpart := OTHSumintegerpart + OTWSumintegerpart + OTHoliSumintegerpart;
                                TotalOTHrsSumdecimalpart := OTHSumdecimalpart + OTWSumdecimalpart + OTHoliSumdecimalpart;
                                if TotalOTHrsSumdecimalpart > 60 then begin
                                    TotalOTHrsSumintegerpart += (TotalOTHrsSumdecimalpart div 60);
                                    TotalOTHrsSumdecimalpart := (TotalOTHrsSumdecimalpart mod 60);
                                    TotalOTHRs := TotalOTHrsSumintegerpart + (TotalOTHrsSumdecimalpart / 100);
                                end else
                                    TotalOTHRs := TotalOTHrsSumintegerpart + (TotalOTHrsSumdecimalpart / 100);
                                // KS re
                                if DailyAttendanceGRec."Reporting OT Hrs." > 0 then
                                    TotOTDays += 1;

                            until DailyAttendanceGRec.Next = 0;
                        end;

                        // Changes <<


                        //JKK
                        // LateMin
                        Clear(LateMinintegerpart);
                        Clear(LateMindecimalpart);
                        Clear(LateMinTotintegerpart);
                        Clear(LateMinTotdecimalpart);
                        Clear(LateSumintegerpart);
                        Clear(LateSumdecimalpart);
                        Clear(Late);
                        Clear(LateHrs);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        if DailyAttendanceGRec.FindSet then begin
                            repeat
                                if DailyAttendanceGRec."Late Coming Minutes" <> '' then begin
                                    Evaluate(Late, DailyAttendanceGRec."Late Coming Minutes");
                                    LateMinintegerpart := Format(Late, 0, '<Integer,3><Filler Character,0>');
                                    LateMindecimalpart := Format(Late, 0, '<Decimals,3><Filler Character,0>');
                                    LateMindecimalpart := DelChr(LateMindecimalpart, '=', '.');

                                    Evaluate(LateMinTotintegerpart, LateMinintegerpart);
                                    Evaluate(LateMinTotdecimalpart, LateMindecimalpart);

                                    LateSumintegerpart += LateMinTotintegerpart;
                                    LateSumdecimalpart += LateMinTotdecimalpart;
                                end;

                                // LateMin
                                if LateSumdecimalpart > 60 then begin
                                    LateSumintegerpart += (LateSumdecimalpart div 60);
                                    LateSumdecimalpart := (LateSumdecimalpart mod 60);
                                    LateHrs := LateSumintegerpart + (LateSumdecimalpart / 100);
                                end else
                                    LateHrs := LateSumintegerpart + (LateSumdecimalpart / 100);

                            until DailyAttendanceGRec.Next = 0;
                        end;


                        //EarlyOut

                        Clear(Earlyintegerpart);
                        Clear(Earlydecimalpart);
                        Clear(EarlyTotintegerpart);
                        Clear(EarlyTotdecimalpart);
                        Clear(EarlySumintegerpart);
                        Clear(EarlySumdecimalpart);
                        Clear(EarlyOut);
                        Clear(EarlyHrs);
                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        if DailyAttendanceGRec.FindSet then begin
                            repeat
                                if DailyAttendanceGRec."Early Going Minutes" <> '' then begin
                                    Evaluate(EarlyOut, DailyAttendanceGRec."Early Going Minutes");
                                    Earlyintegerpart := Format(EarlyOut, 0, '<Integer,3><Filler Character,0>');
                                    Earlydecimalpart := Format(EarlyOut, 0, '<Decimals,3><Filler Character,0>');
                                    Earlydecimalpart := DelChr(Earlydecimalpart, '=', '.');

                                    Evaluate(EarlyTotintegerpart, Earlyintegerpart);
                                    Evaluate(EarlyTotdecimalpart, Earlydecimalpart);

                                    EarlySumintegerpart += EarlyTotintegerpart;
                                    EarlySumdecimalpart += EarlyTotdecimalpart;
                                end;

                                //EarlyOut
                                if EarlySumdecimalpart > 60 then begin
                                    EarlySumintegerpart += (EarlySumdecimalpart div 60);
                                    EarlySumdecimalpart := (EarlySumdecimalpart mod 60);
                                    EarlyHrs := EarlySumintegerpart + (EarlySumdecimalpart / 100);
                                end else
                                    EarlyHrs := EarlySumintegerpart + (EarlySumdecimalpart / 100);

                            until DailyAttendanceGRec.Next = 0;
                        end;
                        //JKK

                        //JKK2
                        //OverTime
                        Clear(Overintegerpart);
                        Clear(Overdecimalpart);
                        Clear(OverTotintegerpart);
                        Clear(OverTotdecimalpart);
                        Clear(OverSumintegerpart);
                        Clear(OverSumdecimalpart);
                        Clear(OverHrs);

                        DailyAttendanceGRec.Reset;
                        DailyAttendanceGRec.SetRange("Employee No.", "Monthly Attendance"."Employee No.");
                        DailyAttendanceGRec.SetRange(Year, "Monthly Attendance".Year);
                        DailyAttendanceGRec.SetRange(Month, "Monthly Attendance"."Pay Slip Month");
                        if DailyAttendanceGRec.FindSet then begin
                            repeat
                                Overintegerpart := Format(DailyAttendanceGRec."Reporting OT Hrs.", 0, '<Integer,3><Filler Character,0>');
                                Overdecimalpart := Format(DailyAttendanceGRec."Reporting OT Hrs.", 0, '<Decimals,3><Filler Character,0>');
                                Overdecimalpart := DelChr(Overdecimalpart, '=', '.');

                                Evaluate(OverTotintegerpart, Overintegerpart);
                                Evaluate(OverTotdecimalpart, Overdecimalpart);

                                OverSumintegerpart += OverTotintegerpart;
                                OverSumdecimalpart += OverTotdecimalpart;

                                // OverTime
                                if OverSumdecimalpart > 60 then begin
                                    OverSumintegerpart += (OverSumdecimalpart div 60);
                                    OverSumdecimalpart := (OverSumdecimalpart mod 60);
                                    OverHrs := OverSumintegerpart + (OverSumdecimalpart / 100);
                                end else
                                    OverHrs := OverSumintegerpart + (OverSumdecimalpart / 100);

                            until DailyAttendanceGRec.Next = 0;
                        end;
                        //JKK2

                        //JKK3
                        //Total of Late&Early Mints
                        Clear(TotLateEarlySumintegerpart);
                        Clear(TotLateEarlySumdecimalpart);
                        Clear(TotLateEarlyHRs);
                        Clear(GrandOTSumintegerpart);
                        Clear(GrandOTSumdecimalpart);
                        Clear(GrandOTHours);

                        TotLateEarlySumintegerpart := LateSumintegerpart + EarlySumintegerpart;
                        TotLateEarlySumdecimalpart := LateSumdecimalpart + EarlySumdecimalpart;
                        if TotLateEarlySumdecimalpart > 60 then begin
                            TotLateEarlySumintegerpart += (TotLateEarlySumdecimalpart div 60);
                            TotLateEarlySumdecimalpart := (TotLateEarlySumdecimalpart mod 60);
                            TotLateEarlyHRs := TotLateEarlySumintegerpart + (TotLateEarlySumdecimalpart / 100);
                        end else
                            TotLateEarlyHRs := TotLateEarlySumintegerpart + (TotLateEarlySumdecimalpart / 100);

                        //Grand Total OT
                        Clear(GrandOTSumintegerpart);
                        Clear(GrandOTSumdecimalpart);
                        Clear(GrandOTHours);

                        GrandOTSumintegerpart := OTHSumintegerpart - TotLateEarlySumintegerpart;
                        GrandOTSumdecimalpart := OTHSumdecimalpart - TotLateEarlySumdecimalpart;

                        if GrandOTSumdecimalpart < 0 then begin
                            GrandOTSumintegerpart := GrandOTSumintegerpart - 1;
                            GrandOTSumdecimalpart := 60 + GrandOTSumdecimalpart;
                            GrandOTHours := GrandOTSumintegerpart + (GrandOTSumdecimalpart / 100);
                        end else
                            GrandOTHours := GrandOTSumintegerpart + (GrandOTSumdecimalpart / 100);
                        //JKK3

                        if DayVar = 'Sunday' then
                            DayVarShort := 'Sun'
                        else
                            if DayVar = 'Monday' then
                                DayVarShort := 'Mon'
                            else
                                if DayVar = 'Tuesday' then
                                    DayVarShort := 'Tue'
                                else
                                    if DayVar = 'Wednesday' then
                                        DayVarShort := 'wed'
                                    else
                                        if DayVar = 'Thursday' then
                                            DayVarShort := 'Thu'
                                        else
                                            if DayVar = 'Friday' then
                                                DayVarShort := 'Fri'
                                            else
                                                if DayVar = 'Saturday' then
                                                    DayVarShort := 'Sat';




                        if DateNo = 1 then begin
                            MonthlyReport := PP_CaptionLbl;
                            MonthlyReportValue := Phypre;
                            //MonthlyReportValueText := FORMAT(Phypre);
                        end else
                            if DateNo = 2 then begin
                                MonthlyReport := AB_CaptionLbl;
                                MonthlyReportValue := Absen;
                                //MonthlyReportValueText := FORMAT(Absen);
                            end else
                                if DateNo = 3 then begin
                                    MonthlyReport := HL_CaptionLbl;
                                    MonthlyReportValue := "Monthly Attendance".Holidays;
                                    //MonthlyReportValueText :=FORMAT("Monthly Attendance".Holidays);
                                end else
                                    if DateNo = 4 then begin
                                        MonthlyReport := OD_CaptionLbl;
                                        MonthlyReportValue := "Monthly Attendance"."Weekly Off";
                                        //MonthlyReportValueText := FORMAT("Monthly Attendance"."Weekly Off");
                                    end else
                                        if DateNo = 5 then begin
                                            MonthlyReport := CL_CaptionLbl;
                                            MonthlyReportValue := CalLeave;
                                            //MonthlyReportValueText := FORMAT(CalLeave);
                                        end else
                                            if DateNo = 6 then begin
                                                MonthlyReport := SL_CaptionLbl;
                                                MonthlyReportValue := SpecialLeave;
                                                //MonthlyReportValueText := FORMAT(SpecialLeave);
                                            end else
                                                if DateNo = 7 then begin
                                                    MonthlyReport := AL_CaptionLbl;
                                                    MonthlyReportValue := ArnedLeave;
                                                    //MonthlyReportValueText := FORMAT(ArnedLeave);
                                                end else
                                                    if DateNo = 8 then begin
                                                        MonthlyReport := SP_CaptionLbl;
                                                        MonthlyReportValue := SickLeave;
                                                        //MonthlyReportValueText := FORMAT(SickLeave);
                                                    end else
                                                        if DateNo = 9 then begin
                                                            MonthlyReport := Total_CaptionLbl;
                                                            MonthlyReportValue := "Monthly Attendance".Days;
                                                            //MonthlyReportValueText := FORMAT( "Monthly Attendance".Days);
                                                        end else
                                                            if DateNo = 10 then begin
                                                                MonthlyReport := '';
                                                                MonthlyReportValue := 0;
                                                                //MonthlyReportValueText := '';
                                                            end else
                                                                if DateNo = 11 then begin
                                                                    MonthlyReport := OTH_CaptionLbl;
                                                                    MonthlyReportValue := OTHHrs;
                                                                    //MonthlyReportValueText := CONVERTSTR(FORMAT(OTHHrs),'.',':');
                                                                end else
                                                                    if DateNo = 12 then begin
                                                                        MonthlyReport := ODH_CaptionLbl;
                                                                        MonthlyReportValue := OTWHrs;
                                                                        //MonthlyReportValueText := CONVERTSTR(FORMAT(OTWHrs),'.',':');
                                                                    end else
                                                                        if DateNo = 13 then begin
                                                                            MonthlyReport := '';
                                                                            MonthlyReportValue := 0;
                                                                            //MonthlyReportValueText := '';
                                                                        end else
                                                                            if DateNo = 14 then begin
                                                                                MonthlyReport := HDH_CaptionLbl;
                                                                                MonthlyReportValue := OTHoliHrs;
                                                                                //MonthlyReportValueText := CONVERTSTR(FORMAT(OTHoliHrs),'.',':');
                                                                            end else
                                                                                if DateNo = 15 then begin
                                                                                    MonthlyReport := Days_CaptionLbl;
                                                                                    MonthlyReportValue := TotOTDays;
                                                                                    //MonthlyReportValueText := CONVERTSTR(FORMAT(TotOTDays),'.',':');
                                                                                end else
                                                                                    if DateNo = 16 then begin
                                                                                        MonthlyReport := Total_CaptionLbl;
                                                                                        MonthlyReportValue := TotalOTHRs;
                                                                                        //MonthlyReportValueText := CONVERTSTR(FORMAT(TotalOTHRs),'.',':');
                                                                                    end else
                                                                                        if DateNo = 17 then begin
                                                                                            MonthlyReport := '';
                                                                                            MonthlyReportValue := 0;
                                                                                            //MonthlyReportValueText := '';
                                                                                        end else
                                                                                            if DateNo = 18 then begin
                                                                                                MonthlyReport := LateTime_CaptionLbl;
                                                                                                MonthlyReportValue := LateHrs;
                                                                                                //MonthlyReportValueText := CONVERTSTR(FORMAT(LateHrs),'.',':');
                                                                                            end else
                                                                                                if DateNo = 19 then begin
                                                                                                    MonthlyReport := '';
                                                                                                    MonthlyReportValue := 0;
                                                                                                    //MonthlyReportValueText := '';
                                                                                                end else
                                                                                                    if DateNo = 20 then begin
                                                                                                        MonthlyReport := EarlyTime_CaptionLbl;
                                                                                                        MonthlyReportValue := EarlyHrs;
                                                                                                        //MonthlyReportValueText := CONVERTSTR(FORMAT(EarlyHrs),'.',':');
                                                                                                    end else
                                                                                                        if DateNo = 21 then begin
                                                                                                            MonthlyReport := '';
                                                                                                            MonthlyReportValue := 0;
                                                                                                            //MonthlyReportValueText := '';
                                                                                                        end else
                                                                                                            if DateNo = 22 then begin
                                                                                                                MonthlyReport := Total_CaptionLbl;
                                                                                                                MonthlyReportValue := TotLateEarlyHRs;
                                                                                                                //MonthlyReportValueText := CONVERTSTR(FORMAT(TotLateEarlyHRs),'.',':');
                                                                                                            end else
                                                                                                                if DateNo = 23 then begin
                                                                                                                    MonthlyReport := '';
                                                                                                                    MonthlyReportValue := 0;
                                                                                                                    //MonthlyReportValueText := '';
                                                                                                                end else
                                                                                                                    if DateNo = 24 then begin
                                                                                                                        /*MonthlyReport := GrandOT_CaptionLbl;
                                                                                                                        IF GrandOTHours > 0 THEN
                                                                                                                         MonthlyReportValue := GrandOTHours
                                                                                                                        ELSE
                                                                                                                         MonthlyReportValue := 0;  */
                                                                                                                        //MonthlyReportValueText :=CONVERTSTR(FORMAT(GrandOTHours),'.',':');
                                                                                                                    end else
                                                                                                                        if DateNo = 25 then begin
                                                                                                                            MonthlyReport := '';
                                                                                                                            MonthlyReportValue := 0;
                                                                                                                            //MonthlyReportValueText := '';
                                                                                                                        end else
                                                                                                                            if DateNo = 26 then begin
                                                                                                                                MonthlyReport := ONTIME_CaptionLbl;
                                                                                                                                MonthlyReportValue := OnTime;
                                                                                                                                //MonthlyReportValueText := FORMAT(OnTime);
                                                                                                                            end else
                                                                                                                                if DateNo = 27 then begin
                                                                                                                                    MonthlyReport := '';
                                                                                                                                    MonthlyReportValue := 0;
                                                                                                                                    //MonthlyReportValueText :='';
                                                                                                                                end else
                                                                                                                                    if DateNo = 28 then begin
                                                                                                                                        MonthlyReport := LateDays_CaptionLbl;
                                                                                                                                        MonthlyReportValue := LateDays;
                                                                                                                                        //MonthlyReportValueText:= FORMAT(LateDays);
                                                                                                                                    end else
                                                                                                                                        if DateNo = 29 then begin
                                                                                                                                            MonthlyReport := '';
                                                                                                                                            MonthlyReportValue := 0;
                                                                                                                                            //MonthlyReportValueText := '';
                                                                                                                                        end else
                                                                                                                                            if DateNo = 30 then begin
                                                                                                                                                MonthlyReport := EarlyDays_CaptionLbl;
                                                                                                                                                MonthlyReportValue := TotEarlyDays;
                                                                                                                                                //MonthlyReportValueText := FORMAT(TotEarlyDays);
                                                                                                                                            end else
                                                                                                                                                if DateNo = 31 then begin
                                                                                                                                                    MonthlyReport := '';
                                                                                                                                                    MonthlyReportValue := 0;
                                                                                                                                                    //MonthlyReportValueText := '';
                                                                                                                                                end;

                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DateNo := Date2DMY("Daily Attendance".Date, 1);
                    if EmpNo <> "Daily Attendance"."Employee No." then begin
                        SLNo += 1;
                        EmpNo := "Daily Attendance"."Employee No.";
                        Clear(GrandOT);
                        Clear(TotEarlyDays);
                        Clear(OnTime);
                        Clear(LateDays);
                        Clear(TotOTDays);
                        Clear(OTHHrs);
                        Clear(OTWHrs);
                        Clear(OTHoliHrs);
                        Clear(TotalOTHRs);
                        Clear(LateHrs);
                        Clear(EarlyHrs);
                        Clear(OverHrs);
                        Clear(GrandOTHours);
                        Clear(LateSumintegerpart);
                        Clear(LateSumdecimalpart);
                        Clear(OTHSumintegerpart);
                        Clear(OTHSumdecimalpart);
                        Clear(OTWSumintegerpart);
                        Clear(OTWSumdecimalpart);
                        Clear(OTHoliSumintegerpart);
                        Clear(OTHoliSumdecimalpart);
                        Clear(TotalOTHrsSumintegerpart);
                        Clear(TotalOTHrsSumdecimalpart);
                        Clear(EarlySumintegerpart);
                        Clear(EarlySumdecimalpart);
                        Clear(OverSumintegerpart);
                        Clear(OverSumdecimalpart);
                        Clear(TotLateEarlySumintegerpart);
                        Clear(TotLateEarlySumdecimalpart);
                        Clear(GrandOTSumintegerpart);
                        Clear(GrandOTSumdecimalpart);
                        Clear(GrandOTHours);
                        Clear(TotLateEarlyHRs);
                        //CLEAR();
                        //CLEAR();
                    end else
                        GrandOT += "Daily Attendance"."OT Hrs.";

                    if "Daily Attendance"."Early Going Minutes" <> '' then
                        TotEarlyDays += 1;
                    /*
                    IF "Daily Attendance"."Late Coming Minutes" ='' THEN
                      OnTime  +=1;
                    */

                    if "Daily Attendance"."Late Coming Minutes" <> '' then
                        LateDays += 1;

                    if "Daily Attendance"."Reporting OT Hrs." > 0 then
                        TotOTDays += 1;


                    //
                    /*// commented
                    IF "Daily Attendance"."Reporting OT Hrs." > 0 THEN BEGIN
                      IF ("Daily Attendance"."Non-Working" = FALSE) AND ("Daily Attendance"."Attendance Type"= Present)THEN BEGIN
                        OTHintegerpart := FORMAT("Daily Attendance"."Reporting OT Hrs.",0,'<Integer,3><Filler Character,0>');
                        OTHdecimalpart := FORMAT("Daily Attendance"."Reporting OT Hrs.",0,'<Decimals,3><Filler Character,0>');
                        OTHdecimalpart := DELCHR(OTHdecimalpart,'=','.');
                    
                        EVALUATE(OTHTotintegerpart, OTHintegerpart);
                        EVALUATE(OTHTotdecimalpart, OTHdecimalpart);
                    
                        OTHSumintegerpart +=OTHTotintegerpart;
                        OTHSumdecimalpart +=OTHTotdecimalpart;
                      END;
                    
                      IF ("Daily Attendance"."Non-Working" = TRUE) AND ("Daily Attendance"."Non-Working Type"="Daily Attendance"."Non-Working Type"::OffDay)THEN  BEGIN
                        OTWintegerpart := FORMAT("Daily Attendance"."Reporting OT Hrs.",0,'<Integer,3><Filler Character,0>');
                        OTWdecimalpart := FORMAT("Daily Attendance"."Reporting OT Hrs.",0,'<Decimals,3><Filler Character,0>');
                        OTWdecimalpart := DELCHR(OTWdecimalpart,'=','.');
                    
                        EVALUATE(OTWTotintegerpart, OTWintegerpart);
                        EVALUATE(OTWTotdecimalpart, OTWdecimalpart);
                    
                        OTWSumintegerpart +=OTWTotintegerpart;
                        OTWSumdecimalpart +=OTWTotdecimalpart;
                      END;
                      IF ("Daily Attendance"."Non-Working" = TRUE) AND ("Daily Attendance"."Non-Working Type"="Daily Attendance"."Non-Working Type"::Holiday)THEN BEGIN
                        OTHoliintegerpart := FORMAT("Daily Attendance"."Reporting OT Hrs.",0,'<Integer,3><Filler Character,0>');
                        OTHolidecimalpart := FORMAT("Daily Attendance"."Reporting OT Hrs.",0,'<Decimals,3><Filler Character,0>');
                        OTHolidecimalpart := DELCHR(OTHolidecimalpart,'=','.');
                    
                        EVALUATE(OTHoliTotintegerpart, OTHoliintegerpart);
                        EVALUATE(OTHoliTotdecimalpart, OTHolidecimalpart);
                    
                        OTHoliSumintegerpart +=OTHoliTotintegerpart;
                        OTHoliSumdecimalpart +=OTHoliTotdecimalpart;
                        END
                    END;
                    
                    
                    // OT Normaldays
                    IF OTHSumdecimalpart > 60 THEN BEGIN
                      OTHSumintegerpart += (OTHSumdecimalpart DIV 60);
                      OTHSumdecimalpart := (OTHSumdecimalpart MOD 60);
                      OTHHrs := OTHSumintegerpart + (OTHSumdecimalpart / 100);
                    END ELSE
                      OTHHrs := OTHSumintegerpart + (OTHSumdecimalpart / 100);
                    
                    // OT WeekDays
                    IF OTWSumdecimalpart > 60 THEN BEGIN
                      OTWSumintegerpart += (OTWSumdecimalpart DIV 60);
                      OTWSumdecimalpart := (OTWSumdecimalpart MOD 60);
                      OTWHrs := OTWSumintegerpart + (OTWSumdecimalpart / 100);
                    END ELSE
                      OTWHrs := OTWSumintegerpart + (OTWSumdecimalpart / 100);
                    
                    // OT Holidays
                    IF OTHoliSumdecimalpart > 60 THEN BEGIN
                      OTHoliSumintegerpart += (OTHoliSumdecimalpart DIV 60);
                      OTHoliSumdecimalpart := (OTHoliSumdecimalpart MOD 60);
                      OTHoliHrs := OTHoliSumintegerpart + (OTHoliSumdecimalpart / 100);
                    END ELSE
                      OTHoliHrs := OTHoliSumintegerpart + (OTHoliSumdecimalpart / 100);
                    
                    //total OT Hours
                    TotalOTHrsSumintegerpart := OTHSumintegerpart + OTWSumintegerpart + OTHoliSumintegerpart;
                    TotalOTHrsSumdecimalpart  := OTHSumdecimalpart + OTWSumdecimalpart + OTHoliSumdecimalpart;
                    IF TotalOTHrsSumdecimalpart > 60 THEN BEGIN
                       TotalOTHrsSumintegerpart += (TotalOTHrsSumdecimalpart DIV 60);
                       TotalOTHrsSumdecimalpart := (TotalOTHrsSumdecimalpart MOD 60);
                       TotalOTHRs := TotalOTHrsSumintegerpart + (TotalOTHrsSumdecimalpart / 100);
                    END ELSE
                       TotalOTHRs := TotalOTHrsSumintegerpart + (TotalOTHrsSumdecimalpart / 100);
                    
                    
                    */// CKS commented



                    /*
                    // JKK COMMENTED
                    
                    // LateMin
                    IF  "Late Coming Minutes" <> '' THEN BEGIN
                    EVALUATE(Late,"Late Coming Minutes");
                    LateMinintegerpart := FORMAT(Late,0,'<Integer,3><Filler Character,0>');
                    LateMindecimalpart := FORMAT(Late,0,'<Decimals,3><Filler Character,0>');
                    LateMindecimalpart := DELCHR(LateMindecimalpart,'=','.');
                    
                    EVALUATE(LateMinTotintegerpart,LateMinintegerpart);
                    EVALUATE(LateMinTotdecimalpart, LateMindecimalpart);
                    
                    LateSumintegerpart +=LateMinTotintegerpart;
                    LateSumdecimalpart +=LateMinTotdecimalpart;
                    END;
                    
                    //EarlyOut
                    IF "Early Going Minutes" <> '' THEN BEGIN
                    EVALUATE(EarlyOut,"Early Going Minutes");
                    Earlyintegerpart := FORMAT(EarlyOut,0,'<Integer,3><Filler Character,0>');
                    Earlydecimalpart := FORMAT(EarlyOut,0,'<Decimals,3><Filler Character,0>');
                    Earlydecimalpart := DELCHR(Earlydecimalpart,'=','.');
                    
                    EVALUATE(EarlyTotintegerpart, Earlyintegerpart);
                    EVALUATE(EarlyTotdecimalpart, Earlydecimalpart);
                    
                    EarlySumintegerpart +=EarlyTotintegerpart;
                    EarlySumdecimalpart +=EarlyTotdecimalpart;
                    END;
                    
                    //OverTime
                    Overintegerpart := FORMAT("Daily Attendance"."Reporting OT Hrs.",0,'<Integer,3><Filler Character,0>');
                    Overdecimalpart := FORMAT("Daily Attendance"."Reporting OT Hrs.",0,'<Decimals,3><Filler Character,0>');
                    Overdecimalpart := DELCHR(Overdecimalpart,'=','.');
                    
                    EVALUATE(OverTotintegerpart, Overintegerpart);
                    EVALUATE(OverTotdecimalpart, Overdecimalpart);
                    
                    OverSumintegerpart +=OverTotintegerpart;
                    OverSumdecimalpart +=OverTotdecimalpart;
                    
                    // LateMin
                    IF LateSumdecimalpart > 60 THEN BEGIN
                      LateSumintegerpart += (LateSumdecimalpart DIV 60);
                      LateSumdecimalpart := (LateSumdecimalpart MOD 60);
                      LateHrs := LateSumintegerpart + (LateSumdecimalpart / 100);
                    END ELSE
                      LateHrs := LateSumintegerpart + (LateSumdecimalpart / 100);
                    
                    //EarlyOut
                    IF EarlySumdecimalpart > 60 THEN BEGIN
                      EarlySumintegerpart += (EarlySumdecimalpart DIV 60);
                      EarlySumdecimalpart := (EarlySumdecimalpart MOD 60);
                      EarlyHrs := EarlySumintegerpart + (EarlySumdecimalpart / 100);
                    END ELSE
                      EarlyHrs := EarlySumintegerpart + (EarlySumdecimalpart / 100);
                    
                    // OverTime
                    IF OverSumdecimalpart > 60 THEN BEGIN
                      OverSumintegerpart += (OverSumdecimalpart DIV 60);
                      OverSumdecimalpart := (OverSumdecimalpart MOD 60);
                      OverHrs := OverSumintegerpart + (OverSumdecimalpart / 100);
                    END ELSE
                      OverHrs := OverSumintegerpart + (OverSumdecimalpart / 100);
                    
                    
                    //Total of Late&Early Mints
                    TotLateEarlySumintegerpart :=  LateSumintegerpart + EarlySumintegerpart;
                    TotLateEarlySumdecimalpart :=  LateSumdecimalpart + EarlySumdecimalpart;
                    IF TotLateEarlySumdecimalpart > 60 THEN BEGIN
                       TotLateEarlySumintegerpart += (TotLateEarlySumdecimalpart DIV 60);
                       TotLateEarlySumdecimalpart := (TotLateEarlySumdecimalpart MOD 60);
                       TotLateEarlyHRs := TotLateEarlySumintegerpart + (TotLateEarlySumdecimalpart / 100);
                    END ELSE
                       TotLateEarlyHRs := TotLateEarlySumintegerpart + (TotLateEarlySumdecimalpart / 100);
                    
                    //Grand Total OT
                    GrandOTSumintegerpart := OTHSumintegerpart - TotLateEarlySumintegerpart;
                    GrandOTSumdecimalpart :=  OTHSumdecimalpart - TotLateEarlySumdecimalpart;
                    IF  GrandOTSumdecimalpart > 60 THEN BEGIN
                         GrandOTSumintegerpart += (GrandOTSumdecimalpart DIV 60);
                         GrandOTSumdecimalpart  := (GrandOTSumdecimalpart MOD 60);
                         GrandOTHours := GrandOTSumintegerpart + (GrandOTSumdecimalpart / 100);
                    END ELSE
                         GrandOTHours := GrandOTSumintegerpart + (GrandOTSumdecimalpart / 100);
                    */
                    //COMMENTED JKK

                end;
            }

            trigger OnPreDataItem()
            begin
                Clear(SLNo);
                Clear(DateNo);
                Clear(MonthlyReport);
                Clear(EmployeeDept);
                Clear(CountVar);
                Clear(TotEarlyDays);
                Clear(TotalOTHRs);
                Clear(OTHHrs);
                Clear(OTWHrs);
                Clear(OTHoliHrs);
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

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
    end;

    var
        TiminRegister_CaptionLbl: Label 'TIMING REGISTER';
        ForTheMoonthOf_CaptionLbl: Label 'For The Month Of';
        PrintedOn_CaptionLbl: Label 'Printed on';
        Legends_CaptionLbl: Label 'LEGENDS';
        PP_CaptionLbl: Label 'PP';
        PhysicalPresent_CaptionLbl: Label 'Physical Present';
        AB_CaptionLbl: Label 'AB';
        Absent_CaptionLbl: Label 'Absent';
        HL_CaptionLbl: Label 'HL';
        Holiday_CaptionLbl: Label 'Holiday';
        OD_CaptionLbl: Label 'OD';
        OffDay_CaptionLbl: Label 'Off Day';
        CL_CaptionLbl: Label 'CL';
        CasualLeave_CaptionLbl: Label 'Casual Leave';
        SL_CaptionLbl: Label 'SL';
        SickLeave_CaptionLbl: Label 'Sick Leave';
        AL_CaptionLbl: Label 'AL';
        AnualLeave_CaptionLbl: Label 'Anual Leave';
        SP_CaptionLbl: Label 'SP';
        SpecialLeave_CaptionLbl: Label 'Special Leave';
        PageNo_Caption: Label 'Page No.';
        SNo_CaptionLbl: Label 'S/No.';
        ECode_CaptionLbl: Label 'E.Code';
        EmplyeeName_CaptionLbl: Label 'Employee Name';
        Signature_CaptionLbl: Label 'Signature';
        Total_CaptionLbl: Label 'Total';
        IN_CaptionLbl: Label 'IN';
        OUT_CaptionLbl: Label 'OUT';
        OTH_CaptionLbl: Label 'Normal OT';
        ODH_CaptionLbl: Label 'OffDay OT';
        Days_CaptionLbl: Label 'DAYS';
        HDH_CaptionLbl: Label 'Holiday OT';
        LateTime_CaptionLbl: Label 'Late Coming Min';
        EarlyTime_CaptionLbl: Label 'Early Going Min';
        GrandOT_CaptionLbl: Label 'GRAND O/T';
        ONTIME_CaptionLbl: Label 'ON TIME';
        LateDays_CaptionLbl: Label 'Late Coming Days';
        EarlyDays_CaptionLbl: Label 'Early Going Days';
        OTperDay1_CaptionLbl: Label 'OT ';
        CompanyInfo: Record "Company Information";
        SLNo: Integer;
        DateRec: Record Date;
        DayVar: Text;
        DateNo: Integer;
        EmpNo: Code[20];
        MonthlyReport: Text;
        Employee: Record Employee_B2B;
        EmployeeDept: Code[20];
        MonthlyReportValue: Decimal;
        MonthlyReportValueText: Text;
        DayVarShort: Text;
        CountVar: Integer;
        PreviousEmployeeDept: Code[20];
        MonthVar: Text;
        OTperDay2_CaptionLbl: Label 'PER';
        OTperDay3_CaptionLbl: Label 'DAY';
        PayrollStaff_CaptionLbl: Label 'Payroll Staff';
        EmployeeName: Text;
        GrandOT: Decimal;
        DailyAttendanceGRec: Record "Daily Attendance";
        Phypre: Integer;
        Absen: Integer;
        Holid: Integer;
        OffDays: Integer;
        CalLeave: Integer;
        SickLeave: Integer;
        SpecialLeave: Integer;
        ArnedLeave: Integer;
        "-----": Integer;
        LateMinintegerpart: Text;
        LateMindecimalpart: Text;
        LateMinTotintegerpart: Integer;
        LateMinTotdecimalpart: Integer;
        LateHrs: Decimal;
        LateSumintegerpart: Integer;
        LateSumdecimalpart: Integer;
        EarlyHrs: Decimal;
        Earlyintegerpart: Text;
        Earlydecimalpart: Text;
        EarlyTotintegerpart: Integer;
        EarlyTotdecimalpart: Integer;
        EarlySumintegerpart: Integer;
        EarlySumdecimalpart: Integer;
        Late: Decimal;
        EarlyOut: Decimal;
        OverHrs: Decimal;
        Overintegerpart: Text;
        Overdecimalpart: Text;
        OverTotintegerpart: Integer;
        OverTotdecimalpart: Integer;
        OverSumintegerpart: Integer;
        OverSumdecimalpart: Integer;
        "---": Integer;
        OnTime: Integer;
        LateDays: Integer;
        EarlyDays: Integer;
        EarlyDaysDiff: Integer;
        CountGVar: Integer;
        OnTimeDiff: Integer;
        NormalOTHrs: Decimal;
        OffDayOTHrs: Decimal;
        HolidayOTHrs: Decimal;
        TotOTDays: Integer;
        "----NormalDays": Integer;
        OTHHrs: Decimal;
        OTHintegerpart: Text;
        OTHdecimalpart: Text;
        OTHTotintegerpart: Integer;
        OTHTotdecimalpart: Integer;
        OTHSumintegerpart: Integer;
        OTHSumdecimalpart: Integer;
        "---WeekDays": Integer;
        OTWHrs: Decimal;
        OTWintegerpart: Text;
        OTWdecimalpart: Text;
        OTWTotintegerpart: Integer;
        OTWTotdecimalpart: Integer;
        OTWSumintegerpart: Integer;
        OTWSumdecimalpart: Integer;
        "----Holidays": Integer;
        OTHoliHrs: Decimal;
        OTHoliintegerpart: Text;
        OTHolidecimalpart: Text;
        OTHoliTotintegerpart: Integer;
        OTHoliTotdecimalpart: Integer;
        OTHoliSumintegerpart: Integer;
        OTHoliSumdecimalpart: Integer;
        "----TotalOTh": Integer;
        TotalOTHrsSumintegerpart: Integer;
        TotalOTHrsSumdecimalpart: Integer;
        TotalOTHRs: Decimal;
        TotEarlyDays: Integer;
        "---TotLate&Early Hours": Integer;
        TotLateEarlySumintegerpart: Integer;
        TotLateEarlySumdecimalpart: Integer;
        TotLateEarlyHRs: Decimal;
        "----GrandOT----": Integer;
        GrandOTSumintegerpart: Integer;
        GrandOTSumdecimalpart: Integer;
        GrandOTHours: Decimal;
}

