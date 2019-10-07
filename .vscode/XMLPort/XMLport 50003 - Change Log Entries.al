xmlport 50003 "Change Log Entries"
{
    // version Prod. Schedule

    CaptionML = ENU = 'Import Production Schedule';
    Direction = Export;
    FileName = 'ChangeLogEntries';
    Format = VariableText;
    TextEncoding = UTF8;
    TransactionType = UpdateNoLocks;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Change Log Entry"; "Change Log Entry")
            {
                XmlName = 'ContactHeader';
                SourceTableView = SORTING ("Table No.", "Primary Key Field 1 Value") ORDER(Ascending);
                fieldelement(EntryNo; "Change Log Entry"."Entry No.")
                {
                }
                fieldelement(Datetime; "Change Log Entry"."Date and Time")
                {
                }
                fieldelement(Time; "Change Log Entry".Time)
                {
                }
                fieldelement(Userid; "Change Log Entry"."User ID")
                {
                }
                fieldelement(Tableno; "Change Log Entry"."Table No.")
                {
                }
                fieldelement(TableCaption; "Change Log Entry"."Table Caption")
                {
                }
                fieldelement(FieldNo; "Change Log Entry"."Field No.")
                {
                }
                fieldelement(a; "Change Log Entry"."Field Caption")
                {
                }
                fieldelement(b; "Change Log Entry"."Type of Change")
                {
                }
                fieldelement(c; "Change Log Entry"."Old Value")
                {
                }
                fieldelement(d; "Change Log Entry"."New Value")
                {
                }
                fieldelement(e; "Change Log Entry"."Primary Key")
                {
                }
                fieldelement(f; "Change Log Entry"."Primary Key Field 1 No.")
                {
                }
                fieldelement(g; "Change Log Entry"."Primary Key Field 1 Caption")
                {
                }
                fieldelement(h; "Change Log Entry"."Primary Key Field 1 Value")
                {
                }
                fieldelement(i; "Change Log Entry"."Primary Key Field 2 No.")
                {
                }
                fieldelement(j; "Change Log Entry"."Primary Key Field 2 Caption")
                {
                }
                fieldelement(k; "Change Log Entry"."Primary Key Field 2 Value")
                {
                }
                fieldelement(l; "Change Log Entry"."Primary Key Field 3 No.")
                {
                }
                fieldelement(m; "Change Log Entry"."Primary Key Field 3 Caption")
                {
                }
                fieldelement(n; "Change Log Entry"."Primary Key Field 3 Value")
                {
                }
                fieldelement(o; "Change Log Entry"."Record ID")
                {
                }
            }
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

    var
        TempLineNumber: Integer;
}

