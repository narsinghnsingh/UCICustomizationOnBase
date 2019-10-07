table 50003 "M/W Price List"
{
    // version Estimate Samadhan


    fields
    {
        field(1;"No.";Code[20])
        {
            TableRelation = "Machine Center"."No.";

            trigger OnValidate()
            begin
                // Lines added by deepak Kumar
                if Type = Type :: "Machine Center" then begin
                  MachineCenter.Reset;
                  MachineCenter.SetRange(MachineCenter."No.","No.");
                  if MachineCenter.FindFirst then begin
                    "Work Center Category":=MachineCenter."Work Center Category";
                    Description:=MachineCenter.Name;
                  end else begin
                    "Work Center Category":=0;
                    Description:='';
                  end;
                end;

                if Type= Type::"Work Center" then begin
                  WokCenter.Reset;
                  WokCenter.SetRange(WokCenter."No.","No.");
                  if WokCenter.FindFirst then begin
                    "Work Center Category":=WokCenter."Work Center Category";
                    Description:=WokCenter.Name;

                  end else begin
                    "Work Center Category":=0;
                    Description:='';

                  end;
                end;
            end;
        }
        field(2;"Price Based Condition";Option)
        {
            OptionCaption = ' ,No of Ply,No of Colour,No of Joint,No of Die Cut Ups,Stitching';
            OptionMembers = " ","No of Ply","No of Colour","No of Joint","No of Die Cut Ups",Stitching;
        }
        field(3;"Condition Value";Integer)
        {
        }
        field(4;"Minimum Quantity";Decimal)
        {
        }
        field(5;"Maximum Quantity";Decimal)
        {
        }
        field(6;"Unit Price";Decimal)
        {
        }
        field(10;Type;Option)
        {
            OptionMembers = "Machine Center","Work Center";
        }
        field(100;"Work Center Category";Option)
        {
            OptionCaption = ',,Press Operation,Origination Cost,Printing Guiding,Finishing Packing';
            OptionMembers = ,,"Press Operation","Origination Cost","Printing Guiding","Finishing Packing";
        }
        field(101;Description;Text[150])
        {
        }
    }

    keys
    {
        key(Key1;Type,"No.","Price Based Condition","Condition Value","Minimum Quantity")
        {
        }
    }

    fieldgroups
    {
    }

    var
        MachineCenter: Record "Machine Center";
        WokCenter: Record "Work Center";
}

