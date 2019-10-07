table 50028 "Sampling Plan QA"
{
    // version Samadhan Quality


    fields
    {
        field(1;"Code";Code[10])
        {
            CaptionML = ENU = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
            CaptionML = ENU = 'Description';

            trigger OnValidate()
            begin
                if Status = Status::Certified then
                  FieldError(Status);
            end;
        }
        field(5;Status;Option)
        {
            CaptionML = ENU = 'Status';
            OptionCaption = 'New,Under Development,Certified';
            OptionMembers = New,"Under Development",Certified;

            trigger OnValidate()
            begin
                if Status = Status :: Certified then begin
                  case "Sampling Type" of
                    "Sampling Type" ::"Fixed Quantity" :
                      TestField("Fixed Quantity");
                    "Sampling Type" :: "Percentage Lot":
                      TestField("Lot Percentage");
                  end;
                end;
            end;
        }
        field(6;"Created Date";Date)
        {
            CaptionML = ENU = 'Created Date';
        }
        field(7;"Last Modified Date";Date)
        {
            CaptionML = ENU = 'Last Modified Date';
        }
        field(8;"Sampling Type";Option)
        {
            CaptionML = ENU = 'Sampling Type';
            OptionCaption = 'Fixed Quantity,Percentage Lot,Complete Lot';
            OptionMembers = "Fixed Quantity","Percentage Lot","Complete Lot";

            trigger OnValidate()
            begin
                if Status =Status :: Certified then
                  FieldError(Status);
            end;
        }
        field(9;"Fixed Quantity";Integer)
        {
            CaptionML = ENU = 'Fixed Quantity';

            trigger OnValidate()
            begin
                if Status = Status::Certified then
                  FieldError(Status);

                Validate("Sampling Type");
                TestField("Sampling Type","Sampling Type" :: "Fixed Quantity");
            end;
        }
        field(10;"Lot Percentage";Decimal)
        {
            CaptionML = ENU = 'Lot Percentage';
            Description = '// Rounded off by Nearest';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Status = Status::Certified then
                  FieldError(Status);

                Validate("Sampling Type");
                TestField("Sampling Type","Sampling Type" :: "Percentage Lot");
            end;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        // Lines added by Deepak Kumar
        "Created Date":=WorkDate;
    end;

    trigger OnModify()
    begin
        // Lines added by Deepak Kumar
        "Last Modified Date":=WorkDate;
    end;
}

