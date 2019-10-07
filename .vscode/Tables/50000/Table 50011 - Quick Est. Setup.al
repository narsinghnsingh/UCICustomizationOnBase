table 50011 "Quick Est. Setup"
{
    // version Estimate Samadhan


    fields
    {
        field(1;"Code";Code[20])
        {
            TableRelation = "Material / Process Link Code".Code WHERE ("Quick Product Design"=CONST(true));

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                ProcessMaster.Reset;
                ProcessMaster.SetRange(ProcessMaster.Code,Code);
                if ProcessMaster.FindFirst then begin
                    "Process Description":=ProcessMaster.Description;
                  end else begin
                    "Process Description":='';
                end;
            end;
        }
        field(2;"Process Description";Text[50])
        {
        }
        field(3;"Model Code";Code[10])
        {
            TableRelation = "Product Design Model Master"."Model No";
        }
        field(9;"Work Center Category";Option)
        {
            OptionCaption = ',Materials,Origination Cost,Corrugation,Printing Guiding,Finishing Packing,Sub Job';
            OptionMembers = ,Materials,"Origination Cost",Corrugation,"Printing Guiding","Finishing Packing","Sub Job";
        }
        field(10;Type;Option)
        {
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";
        }
        field(11;"No.";Code[10])
        {
            TableRelation = IF (Type=CONST("Work Center")) "Work Center"."No." WHERE ("Work Center Category"=FIELD("Work Center Category"))
                            ELSE IF (Type=CONST("Machine Center")) "Machine Center"."No." WHERE ("Work Center Category"=FIELD("Work Center Category"));

            trigger OnValidate()
            var
                TempPrice: Decimal;
            begin
                // Lines added bY Deepak Kumar
                case Type of
                  Type::"Work Center":
                    begin
                      WorkCenter.Get("No.");
                       Description:= WorkCenter.Name;
                       "Price Based Condition":=WorkCenter."Price Based Condition";
                       "Standard Cost":=WorkCenter."Unit Cost";
                    end;
                  Type::"Machine Center":
                    begin
                        MachineCenter.Get("No.");
                        Description := MachineCenter.Name;
                        "Price Based Condition":=MachineCenter."Price Based Condition";
                        "Standard Cost":=MachineCenter."Unit Cost";
                    end;
                 end;
            end;
        }
        field(12;Description;Text[50])
        {
        }
        field(15;"Price Based Condition";Option)
        {
            OptionCaption = ' ,No of Ply,No of Colour,No of Joint,No of Die Cut Ups,Stitching';
            OptionMembers = " ","No of Ply","No of Colour","No of Joint","No of Die Cut Ups",Stitching;
        }
        field(20;"Standard Cost";Decimal)
        {
        }
        field(50000;"Item Code";Code[50])
        {
        }
        field(50001;"Item Description";Text[250])
        {
            CalcFormula = Lookup(Item.Description WHERE ("No."=FIELD("Item Code")));
            FieldClass = FlowField;
        }
        field(50002;Quanity;Decimal)
        {
        }
        field(50003;"Item cate";Code[50])
        {
            CalcFormula = Lookup(Item."Item Category Code" WHERE ("No."=FIELD("Item Code")));
            FieldClass = FlowField;
        }
        field(50004;"Used in Phy Jurnal";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Model Code","Code","Item Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        ProcessMaster: Record "Material / Process Link Code";
}

