table 50012 "Quick Entry Process"
{
    // version Estimate Samadhan

    // // Table Created by Deepak Kumar


    fields
    {
        field(1;"Product Design Type";Option)
        {
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;
        }
        field(2;"Product Design No.";Code[50])
        {
        }
        field(4;"Sub Comp No.";Code[20])
        {
        }
        field(10;"Process Code";Code[20])
        {
        }
        field(11;"Process Description";Text[50])
        {
        }
        field(12;Required;Boolean)
        {

            trigger OnValidate()
            var
                QuickEstimateMaster: Record "Quick Est. Setup";
            begin
                // Lines added BY Deepak Kumar
                EstimateHeader.Reset;
                EstimateHeader.SetRange(EstimateHeader."Product Design Type","Product Design Type");
                EstimateHeader.SetRange(EstimateHeader."Product Design No.","Product Design No.");
                EstimateHeader.SetRange(EstimateHeader."Sub Comp No.","Sub Comp No.");
                if EstimateHeader.FindFirst then begin

                  if Required = true then begin
                    QuickEstimateMaster.Reset;
                    QuickEstimateMaster.SetRange(QuickEstimateMaster."Model Code",EstimateHeader."Model No");
                    QuickEstimateMaster.SetRange(QuickEstimateMaster.Code,"Process Code");
                    if QuickEstimateMaster.FindFirst then begin
                      Type:=QuickEstimateMaster.Type;
                      "No.":=QuickEstimateMaster."No.";
                      Description:=QuickEstimateMaster.Description;
                      "Unit Cost":=QuickEstimateMaster."Standard Cost";
                      "Work Center Category":=QuickEstimateMaster."Work Center Category";
                      if "Work Center Category" = "Work Center Category":: Corrugation then begin
                        EstimateHeader.Validate("Corrugation Machine",QuickEstimateMaster."No.");
                      end;
                    end;
                  end else begin
                    Type:=0;
                    "No.":='';
                    Description:='';
                    "Unit Cost":=0;
                      if "Work Center Category" = "Work Center Category":: Corrugation then begin
                        EstimateHeader.Validate("Corrugation Machine",'');
                      end;

                  end;
                end;
            end;
        }
        field(49;"Deckle Size";Code[10])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=CONST('DECKLESIZE'));

            trigger OnValidate()
            begin
                // Lines added By Deepak Kumar
                GetItemLine;
            end;
        }
        field(50;"BF (Burst Factor)";Code[10])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=CONST('BF'));

            trigger OnValidate()
            begin
                // Lines added By Deepak Kumar
                GetItemLine;
            end;
        }
        field(51;"Paper GSM";Code[10])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=CONST('PAPERGSM'));

            trigger OnValidate()
            begin
                // Lines added By Deepak Kumar
                GetItemLine;
            end;
        }
        field(52;"Item Code";Code[20])
        {
            TableRelation = Item."No." WHERE (Blocked=CONST(false));

            trigger OnValidate()
            begin
                //Lines added BY Deepak Kumar
                ItemMaster.Reset;
                ItemMaster.SetRange(ItemMaster."No.","Item Code");
                if ItemMaster.FindFirst then begin
                  "Item Description":=ItemMaster.Description;
                  "Unit Cost":=ItemMaster."Unit Price";
                  LinePriceUpdate;
                  end else begin
                  "Item Description":='';
                  "Unit Cost":=0;
                end;
            end;
        }
        field(53;"Item Description";Text[150])
        {
        }
        field(54;"Flute Type";Option)
        {
            OptionCaption = ' ,A,B,C,D,E,F';
            OptionMembers = " ",A,B,C,D,E,F;

            trigger OnValidate()
            begin
                // Lines added BY Deepak kumar
                if ("Paper Position" =1 ) or ("Paper Position" = 3) or ("Paper Position" = 5) or ("Paper Position" = 7) then
                  Error(Sam001);

                MfgSetup.Get;

                case "Flute Type" of
                  "Flute Type"::A:
                    begin
                       MfgSetup.TestField(MfgSetup."Flute - A");
                      "Take Up":=MfgSetup."Flute - A";
                      Modify(true);
                    end;

                  "Flute Type"::B:
                    begin
                      MfgSetup.TestField(MfgSetup."Flute - B");
                      "Take Up":=MfgSetup."Flute - B";
                      Modify(true);
                    end;
                  "Flute Type"::C:
                    begin
                      MfgSetup.TestField(MfgSetup."Flute - C");
                      "Take Up":=MfgSetup."Flute - C";
                      Modify(true);
                    end;
                  "Flute Type"::D:
                    begin
                      MfgSetup.TestField(MfgSetup."Flute - D");
                      "Take Up":=MfgSetup."Flute - D";
                      Modify(true);
                    end;

                  "Flute Type"::E:
                    begin
                      MfgSetup.TestField(MfgSetup."Flute - E");
                      "Take Up":=MfgSetup."Flute - E";
                      Modify(true);
                    end;
                  "Flute Type"::F:
                    begin
                      MfgSetup.TestField(MfgSetup."Flute - F");
                      "Take Up":=MfgSetup."Flute - F";
                      Modify(true);
                    end;
                 end;
            end;
        }
        field(55;"Take Up";Decimal)
        {
            InitValue = 1;

            trigger OnValidate()
            begin
                // Lines added bY Deepak Kumar
                if ("Paper Position" =1 ) or ("Paper Position" = 3) or ("Paper Position" = 5) or ("Paper Position" = 7) then
                  Error(Sam001);
            end;
        }
        field(56;"Paper Position";Option)
        {
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;

            trigger OnValidate()
            begin
                "Take Up":=1;
            end;
        }
        field(60;Quantity;Decimal)
        {
        }
        field(61;"Unit Cost";Decimal)
        {

            trigger OnValidate()
            begin
                  LinePriceUpdate;
            end;
        }
        field(62;"Line Amount";Decimal)
        {
            Editable = false;
        }
        field(80;Type;Option)
        {
            OptionCaption = 'Work Center,Machine Center';
            OptionMembers = "Work Center","Machine Center";
        }
        field(81;"No.";Code[10])
        {
            TableRelation = IF (Type=CONST("Work Center")) "Work Center"."No."
                            ELSE IF (Type=CONST("Machine Center")) "Machine Center"."No.";

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
                       "Unit Cost":=WorkCenter."Unit Cost";
                    end;
                  Type::"Machine Center":
                    begin
                        MachineCenter.Get("No.");
                        Description := MachineCenter.Name;
                        "Unit Cost":=MachineCenter."Unit Cost";
                    end;
                 end;
            end;
        }
        field(82;Description;Text[50])
        {
        }
        field(85;"Work Center Category";Option)
        {
            OptionCaption = ',Materials,Origination Cost,Corrugation,Printing Guiding,Finishing Packing,Sub Job';
            OptionMembers = ,Materials,"Origination Cost",Corrugation,"Printing Guiding","Finishing Packing","Sub Job";
        }
    }

    keys
    {
        key(Key1;"Product Design Type","Product Design No.","Sub Comp No.","Process Code","Paper Position")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ItemMaster: Record Item;
        Sam001: Label 'Liner Paper not required take up factor';
        MfgSetup: Record "Manufacturing Setup";
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        EstimateHeader: Record "Product Design Header";

    local procedure GetItemLine()
    begin
        // Lines added BY Deepak Kumar
          ItemMaster.Reset;
          if ("BF (Burst Factor)" <> '' ) then
            ItemMaster.SetFilter(ItemMaster."Bursting factor(BF)","BF (Burst Factor)");
          if ("Paper GSM" <> '') then
            ItemMaster.SetFilter(ItemMaster."Paper GSM","Paper GSM");
          if ("Deckle Size" <> '') then
            ItemMaster.SetFilter(ItemMaster."Deckle Size (mm)","Deckle Size");
          if ItemMaster.FindFirst then begin
            Validate("Item Code",ItemMaster."No.");
          end else begin
            Error('Item with BF %1 and GSM %2 not available in Item master',"BF (Burst Factor)","Paper GSM");
          end;
    end;

    local procedure LinePriceUpdate()
    begin
        // Lines updated By Deepak Kumar
        EstimateHeader.Reset;
        EstimateHeader.SetRange(EstimateHeader."Product Design Type","Product Design Type");
        EstimateHeader.SetRange(EstimateHeader."Product Design No.","Product Design No.");
        EstimateHeader.SetRange(EstimateHeader."Sub Comp No.","Sub Comp No.");
        if EstimateHeader.FindFirst then begin
          "Line Amount":=EstimateHeader.Quantity*"Unit Cost";
        end else begin
          Error('Estimate not found !');
        end;
    end;
}

