report 50125 "Update Dailt Attendance"
{
    // version Test Delete

    ProcessingOnly = true;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Daily Attendance"; "Daily Attendance")
        {

            trigger OnAfterGetRecord()
            begin
                if EmpNoGVar <> "Daily Attendance"."Employee No." then begin
                    EmpNoGVar := "Daily Attendance"."Employee No.";
                    Window.Update(1, "Daily Attendance"."Employee No.");
                end;
                "Daily Attendance".Validate("Actual Time Out");
                if ("Time In" <> 0T) and ("Time Out" <> 0T) then begin
                    "Daily Attendance".Validate("Time In");
                    "Daily Attendance".Validate("Time Out");
                end;
                "Daily Attendance".Modify;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Updating Daily Attendance Table : #1#######');
            end;
        }
    }

    var
        Window: Dialog;
        EmpNoGVar: Code[20];
}

