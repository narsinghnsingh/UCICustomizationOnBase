codeunit 50008 "Delete Change Log Entries"
{

    trigger OnRun()
    begin
    end;

    procedure DeleteChangeLogEntries()
    var
        ChnageLogEntries: Record "Change Log Entry";
    begin
        ChnageLogEntries.Reset;
        if ChnageLogEntries.FindSet then begin
            ChnageLogEntries.DeleteAll(true);
        end;
        Message('complete');
    end;
}

