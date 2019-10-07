table 50023 "Machine Cost Sheet"
{
    DrillDownPageID = "Machine Proportion Page MC";
    LookupPageID = "Machine Proportion Page MC";

    fields
    {
        field(1;"No.";Code[20])
        {
            CaptionML = ENU = 'No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "G/L Account"."No." WHERE ("Account Type"=CONST(Posting));

            trigger OnValidate()
            begin
                // Lines added By Deepak kumar
                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.","No.");
                if GLAccount.FindFirst then begin
                  Name:=GLAccount.Name;
                  end else begin
                  Name:='';
                end;
            end;
        }
        field(2;Name;Text[50])
        {
            CaptionML = ENU = 'Name';
            Editable = false;
        }
        field(10;"Machine No.";Code[20])
        {
            CaptionML = ENU = 'No.';
            TableRelation = "Machine Center"."No.";

            trigger OnValidate()
            begin
                // Lines added by Deepak Kumar
                MachineCenter.Reset;
                MachineCenter.SetRange(MachineCenter."No.","Machine No.");
                if MachineCenter.FindFirst then begin
                  "Machine Name":=MachineCenter.Name;
                  end else begin
                  "Machine Name":='';
                end;
            end;
        }
        field(11;"Machine Name";Text[50])
        {
            CaptionML = ENU = 'Name';
            Editable = false;
        }
        field(12;"Machine Percentage";Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                PercentageValidate;
            end;
        }
        field(13;"Unit Amount";Decimal)
        {
            Editable = false;
        }
        field(14;"Unit Amount Total";Decimal)
        {
            CalcFormula = Sum("Machine Cost Sheet"."Unit Amount" WHERE ("Machine No."=FIELD("Machine No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.","Machine No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLAccount: Record "G/L Account";
        MachineCenter: Record "Machine Center";
        MachineCostSheet: Record "Machine Cost Sheet";
        TempPercentage: Decimal;

    local procedure PercentageValidate()
    begin
        // Lines added by Deepak Kumar
        MachineCostSheet.Reset;
        MachineCostSheet.SetRange(MachineCostSheet."No.","No.");
        if MachineCostSheet.FindFirst then begin
          TempPercentage:=0;
          repeat
            TempPercentage+=MachineCostSheet."Machine Percentage";
          until MachineCostSheet.Next=0;
          if (TempPercentage + "Machine Percentage") > 100 then
            Error('Maximum value is %1',(100-TempPercentage));
        end;
    end;
}

