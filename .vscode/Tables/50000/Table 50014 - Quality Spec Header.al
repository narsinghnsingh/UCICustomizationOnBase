table 50014 "Quality Spec Header"
{
    // version Samadhan Quality


    fields
    {
        field(1;"Spec ID";Code[20])
        {
            CaptionML = ENU = 'Spec ID';
            Editable = false;
        }
        field(2;Description;Text[150])
        {
            CaptionML = ENU = 'Description';
        }
        field(3;Status;Option)
        {
            CaptionML = ENU = 'Status';
            OptionCaption = 'New,Under Development,Certified';
            OptionMembers = New,"Under Development",Certified;
        }
        field(7;"Estimation No.";Code[10])
        {
            TableRelation = "Product Design Header"."Product Design No." WHERE ("Product Design Type"=CONST(Main),
                                                                                Status=CONST(Approved));
        }
        field(9;Type;Option)
        {
            OptionCaption = 'Paper,Other RM,FG';
            OptionMembers = Paper,"Other RM",FG;
        }
        field(10;"Sampling Plan";Code[10])
        {
            TableRelation = "Sampling Plan QA".Code WHERE (Status=CONST(Certified));
        }
        field(2000;"Paper Type";Code[20])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=FILTER('PAPERTYPE'));

            trigger OnValidate()
            begin
                // lines aDDED BY Deepak kumar
                ValidatePaperTypeGSM("Paper Type","Paper GSM");
            end;
        }
        field(2001;"Paper GSM";Code[10])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=FILTER('PAPERGSM'));

            trigger OnValidate()
            begin
                ValidatePaperTypeGSM("Paper Type","Paper GSM");
            end;
        }
        field(3000;Remarks;Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Spec ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        QualitySpecLines.Reset;
        QualitySpecLines.SetRange(QualitySpecLines."Spec ID","Spec ID");
        if QualitySpecLines.FindFirst then
          QualitySpecLines.DeleteAll;
    end;

    trigger OnInsert()
    begin
         InitInsert;
    end;

    trigger OnModify()
    begin
        if (Status = Status::Certified) and (xRec.Status  = Status::Certified) then
          Error('Status must not be certified for making any changes');
    end;

    var
        ManSetup: Record "Manufacturing Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        QualitySpecLines: Record "Quality Spec Line";

    procedure ValidatePaperTypeGSM(PaperType: Code[20];PaperGSM: Code[20])
    var
        QualitySpecHeader: Record "Quality Spec Header";
    begin
        // Lines added by deepak Kumar
        if (PaperType = '') or (PaperGSM = '') then
          exit;
        QualitySpecHeader.Reset;
        QualitySpecHeader.SetRange(QualitySpecHeader."Paper Type",PaperType);
        QualitySpecHeader.SetRange(QualitySpecHeader."Paper GSM",PaperGSM);
        if QualitySpecHeader.FindFirst then
          Error('The Record is already exits , Paper Type %1 Paper GSM %2',PaperType,PaperGSM);
    end;

    local procedure InitInsert()
    begin
        if "Spec ID" = '' then begin
        ManSetup.FindFirst;
        Message(ManSetup."Specification Nos.");
        NoSeriesMgt.InitSeries(ManSetup."Specification Nos.",ManSetup."Specification Nos.",0D,"Spec ID",ManSetup."Specification Nos.");
        end;
    end;
}

