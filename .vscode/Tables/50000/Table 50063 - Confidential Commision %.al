table 50063 "Confidential/ Commision %"
{
    // version NAVW17.00

    CaptionML = ENU = 'Confidential/ Commision %';

    fields
    {
        field(1; "Sales Person Code"; Code[20])
        {
            CaptionML = ENU = 'Sales Person Code';
            NotBlank = true;
            TableRelation = "Salesperson/Purchaser".Code;

            trigger OnValidate()
            begin
                // Lines added By Depak Kumar
                Salesperson.Reset;
                Salesperson.SetRange(Salesperson.Code, "Sales Person Code");
                if Salesperson.FindFirst then begin
                    "Sales Person Name" := Salesperson.Name;
                end else begin
                    "Sales Person Name" := '';
                end;
            end;
        }
        field(2; "Confidential Code"; Code[10])
        {
            CaptionML = ENU = 'Confidential Code';
            NotBlank = true;
            TableRelation = Confidential;

            trigger OnValidate()
            begin
                Confidential.Get("Confidential Code");
                Description := Confidential.Description;
            end;
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.';
            NotBlank = true;
        }
        field(4; Description; Text[50])
        {
            CaptionML = ENU = 'Description';
        }
        field(5; Comment; Boolean)
        {
            CaptionML = ENU = 'Comment';
            Editable = false;
        }
        field(50001; "From Date"; Date)
        {
        }
        field(50002; "Sales Person Name"; Text[150])
        {
        }
        field(50003; Type; Option)
        {
            OptionCaption = 'By Weight,By Value';
            OptionMembers = "By Weight","By Value";
        }
        field(50004; "Min Value"; Decimal)
        {

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                if ("Min Value" > "Max Value") and ("Max Value" <> 0) then
                    Error('Max Value must not be lesser than Min Value');
            end;
        }
        field(50005; "Max Value"; Decimal)
        {

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                if "Max Value" < "Min Value" then
                    Error('Max Value must not be lesser than Min Value');
            end;
        }
        field(50006; "Commission Percentage"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Sales Person Code", Type, "From Date", "Min Value")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Comment then
            Error(Text000);
    end;

    var
        Text000: Label 'You can not delete confidential information if there are comments associated with it.';
        Confidential: Record Confidential;
        Salesperson: Record "Salesperson/Purchaser";
}

