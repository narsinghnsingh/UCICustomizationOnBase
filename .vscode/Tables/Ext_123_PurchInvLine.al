tableextension 50029 Ext_PurchInvLine extends "Purch. Inv. Line"
{
    fields
    {
        field(50006; ORIGIN; Code[20])
        {
            Description = 'Firoz 23-12-15 for Reporting Purpose';
        }
        field(50007; MILL; Code[20])
        {
            Description = 'Firoz 23-12-15 for Reporting Purpose';
        }
        field(50011; "Purch. Rcpt No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50012; "Purch. Rcpt. Line No."; Integer)
        {
            Description = 'Deepak';
        }
        field(62000; Paper; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(62001; "Paper Type"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(62002; "Paper GSM"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(62006; "FSC Category"; Text[100])
        {

        }

    }
    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        ERROR('Delete is restricted, please contact your system administrator for more information.');
    end;
}