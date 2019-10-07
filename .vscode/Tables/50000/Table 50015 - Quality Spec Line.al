table 50015 "Quality Spec Line"
{
    // version Samadhan Quality

    // // Module Updated By Deepak Kumar

    CaptionML = ENU = 'Quality Spec Line';
    Description = 'Quality Spec Line';

    fields
    {
        field(1; "Spec ID"; Code[20])
        {
            CaptionML = ENU = 'Spec ID';
        }
        field(3; "Character Code"; Code[20])
        {
            CaptionML = ENU = 'Character Code';
            TableRelation = "Quality Parameters".Code;

            trigger OnValidate()
            begin

                Characterstic.Get("Character Code");
                Description := Characterstic.Description;
                "Unit of Measure Code" := Characterstic."Unit of Measure Code";
                Qualitative := Characterstic.Qualitative;
                Quantitative := Characterstic.Quantitative;
                "Work Center Group" := Characterstic."Work Center Group";
                // lines added BY Deepak Kumar
                "Sequence No" := Characterstic."Sequence No";
            end;
        }
        field(4; Description; Text[50])
        {
            CaptionML = ENU = 'Description';
            Editable = false;
            NotBlank = false;
        }
        field(6; "Normal Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Normal Value (Num)';
            DecimalPlaces = 0 : 5;
        }
        field(7; "Min. Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Min. Value (Num)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin

                Validate("Max. Value (Num)");
                Validate("Normal Value (Num)");
            end;
        }
        field(8; "Max. Value (Num)"; Decimal)
        {
            BlankZero = true;
            CaptionML = ENU = 'Max. Value (Num)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin

                if ("Max. Value (Num)" < "Min. Value (Num)") and ("Max. Value (Num)" <> 0) then
                    Error(Text004, FieldCaption("Min. Value (Num)"), FieldCaption("Max. Value (Num)"));
                Validate("Normal Value (Num)");
            end;
        }
        field(9; "Normal Value (Char)"; Code[20])
        {
            CaptionML = ENU = 'Normal Value (Char)';

            trigger OnValidate()
            begin
                TestField(Qualitative);
            end;
        }
        field(10; "Min. Value (Char)"; Code[20])
        {
            CaptionML = ENU = 'Min. Value (Char)';

            trigger OnValidate()
            begin

                TestField(Qualitative);
                Validate("Normal Value (Char)");
            end;
        }
        field(11; "Max. Value (Char)"; Code[20])
        {
            CaptionML = ENU = 'Max. Value (Char)';

            trigger OnValidate()
            begin

                TestField(Qualitative);
                Validate("Normal Value (Char)");
            end;
        }
        field(13; "Unit of Measure Code"; Code[20])
        {
            CaptionML = ENU = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(14; Qualitative; Boolean)
        {
            CaptionML = ENU = 'Qualitative';
            Editable = false;
        }
        field(15; "Source Type"; Option)
        {
            OptionCaption = 'SO,Estimation,Others';
            OptionMembers = SO,Estimation,Others;
        }
        field(16; "Work Center Group"; Text[80])
        {
            TableRelation = "Work Center Group".Code;
        }
        field(17; Quantitative; Boolean)
        {
            Editable = false;
        }
        field(18; "Sequence No"; Integer)
        {
            Editable = true;
        }
    }

    keys
    {
        key(Key1; "Spec ID", "Character Code")
        {
        }
        key(Key2; "Spec ID", "Source Type", "Character Code")
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        QualitySpecHeader.Get("Spec ID");
        if QualitySpecHeader.Status = QualitySpecHeader.Status::Certified then
            Error('The status must not be certified for making any changes');
    end;

    trigger OnModify()
    begin
        QualitySpecHeader.Get("Spec ID");
        if QualitySpecHeader.Status = QualitySpecHeader.Status::Certified then
            Error('The status must not be certified for making any changes');
    end;

    var
        Characterstic: Record "Quality Parameters";
        Text002: Label '%1 should not be less than %2.';
        Text003: Label '%1 should be within %2 and %3.';
        Text004: Label '%1 should not be greater than %2 specification line %3.';
        QualitySpecHeader: Record "Quality Spec Header";
}

