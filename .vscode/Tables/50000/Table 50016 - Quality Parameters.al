table 50016 "Quality Parameters"
{
    // version Samadhan Quality

    CaptionML = ENU = 'Quality Parameters';

    fields
    {
        field(1;"Code";Code[20])
        {
            CaptionML = ENU = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
            CaptionML = ENU = 'Description';
        }
        field(3;"Unit of Measure Code";Code[20])
        {
            CaptionML = ENU = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(4;Qualitative;Boolean)
        {
            CaptionML = ENU = 'Qualitative';
            InitValue = false;

            trigger OnValidate()
            begin
                if Qualitative  then
                  Quantitative  :=false
                else
                  Quantitative  :=true;
            end;
        }
        field(5;"Estimation Parameter";Option)
        {
            OptionCaption = 'Board Length,Board Width,Board GSM,Box Wt.,Box Length,Box Width,Box Height';
            OptionMembers = "Board Length","Board Width","Board GSM","Box Wt.","Box Length","Box Width","Box Height";
        }
        field(6;"Display in Board RPO";Boolean)
        {
            Description = 'for display in different Job Card Report';
        }
        field(7;"Display in Print & Cut RPO";Boolean)
        {
            Description = 'for display in different Job Card Report';
        }
        field(8;"Display in Stich & Glue RPO";Boolean)
        {
            Description = 'for display in different Job Card Report';
        }
        field(9;"Display in Final RPO";Boolean)
        {
            Description = 'for display in different Job Card Report';
        }
        field(10;"Update from Estimation";Boolean)
        {
            Description = 'The parameters marked would be updated using type field from estimation';
        }
        field(11;"Work Center Group";Text[80])
        {
            Description = 'link quality parameters to relevant WC group code , so that while output the quality parameters are filtered by the WC group code on the WC Card';
        }
        field(12;Quantitative;Boolean)
        {
            InitValue = true;

            trigger OnValidate()
            begin
                if Quantitative  then
                  Qualitative :=false
                else
                  Qualitative  :=true;
            end;
        }
        field(13;"Sequence No";Integer)
        {

            trigger OnValidate()
            var
                QualityParameters: Record "Quality Parameters";
            begin
                // Lines added by Deepak Kumar
                if "Sequence No" = 0 then
                  exit;
                QualityParameters.Reset;
                QualityParameters.SetRange(QualityParameters."Sequence No","Sequence No");
                if QualityParameters.FindFirst then
                  Error('%1 Already Exist',QualityParameters."Sequence No");
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
}

