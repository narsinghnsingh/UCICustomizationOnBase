table 50001 "Product Design Line"
{
    // version Estimate Samadhan


    fields
    {
        field(1; "Product Design Type"; Option)
        {
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;
        }
        field(2; "Product Design No."; Code[20])
        {
        }
        field(3; "Sub Comp No."; Code[20])
        {
        }
        field(4; "Line No."; Integer)
        {
            AutoIncrement = true;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(10; Type; Option)
        {
            OptionCaption = ' ,Item,Work Center,Machine Center,G/L Account';
            OptionMembers = " ",Item,"Work Center","Machine Center","G/L Account";

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(11; "No."; Code[10])
        {
            TableRelation = IF (Type = CONST (" ")) "Standard Text"
            ELSE
            IF (Type = CONST ("G/L Account")) "G/L Account"."No." WHERE ("Aval. In Estimate" = CONST (true))
            ELSE
            IF (Type = CONST (Item),
                                     GSM = FILTER (0),
                                     "Deckle Size" = FILTER (0)) Item."No." WHERE ("Available in Estimate Line" = FILTER (true))
            ELSE
            IF (Type = CONST ("Work Center")) "Work Center"."No." WHERE ("Work Center Category" = FIELD ("Work Center Category"))
            ELSE
            IF (Type = CONST ("Machine Center")) "Machine Center"."No." WHERE ("Work Center Category" = FIELD ("Work Center Category"))
            ELSE
            IF (Type = CONST (Item),
                                              GSM = FILTER (<> 0),
                                              "Deckle Size" = FILTER (<> 0)) Item."No." WHERE ("Available in Estimate Line" = FILTER (true),
                                                                                           "Paper GSM" = FIELD (GSM),
                                                                                           "Deckle Size (mm)" = FIELD ("Deckle Size"))
            ELSE
            IF (Type = CONST (Item),
                                                                                                    GSM = FILTER (<> 0),
                                                                                                    "Deckle Size" = FILTER (0)) Item."No." WHERE ("Available in Estimate Line" = FILTER (true),
                                                                                                                                               "Paper GSM" = FIELD (GSM))
            ELSE
            IF (Type = CONST (Item),
                                                                                                                                                        GSM = FILTER (0),
                                                                                                                                                        "Deckle Size" = FILTER (<> 0)) Item."No." WHERE ("Available in Estimate Line" = FILTER (true),
                                                                                                                                                                                                     "Deckle Size (mm)" = FIELD ("Deckle Size"));

            trigger OnValidate()
            var
                TempPrice: Decimal;
                Question: Text;
            begin
                ValidateHeaderStatus;
                // Lines added bY Deepak Kumar
                case Type of
                    Type::" ":
                        begin
                            StdTxt.Get("No.");
                            Description := StdTxt.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            Description := GLAcc.Name;
                            Quantity := 1;
                        end;
                    Type::Item:
                        begin
                            GetItem;
                            Item.TestField(Blocked, false);
                            Item.TestField("Inventory Posting Group");
                            Item.TestField("Gen. Prod. Posting Group");
                            // Lines added BY Deepak kUmar
                            ItemCate.Reset;
                            ItemCate.SetRange(ItemCate.Code, Item."Item Category Code");
                            ItemCate.SetRange(ItemCate."Starch Group", true);
                            if ItemCate.FindFirst then begin
                                "Line Type" := "Line Type"::Glue;
                            end;

                            Description := Item.Description;
                            "Unit Of Measure" := Item."Base Unit of Measure";

                            Validate("Unit Cost", Item."Unit Cost");
                            Validate("Last Purchase Price", Item."Last Direct Cost");
                            Validate("Wt. Average Price", Item."Unit Cost");
                            CalculatePaperTypeAddCost("No.");

                            Validate(GSM, Item."Paper GSM");
                            "FSC Category" := Item."FSC Category";
                            Validate("Bursting factor(BF)", Item."Bursting factor(BF)");
                            Validate("Deckle Size", Item."Deckle Size (mm)");
                            if Item."Roll ID Applicable" = true then begin
                                "Line Type" := 2;
                                CalculateExrtaTrim("No.");
                                "Consume / Process For" := 'BOARD';
                            end;

                        end;
                    Type::"Work Center":
                        begin
                            WorkCenter.Get("No.");
                            Description := WorkCenter.Name;
                            Estimate.Reset;
                            Estimate.SetRange(Estimate."Product Design Type", "Product Design Type");
                            Estimate.SetRange(Estimate."Product Design No.", "Product Design No.");
                            Estimate.SetRange(Estimate."Sub Comp No.", "Sub Comp No.");
                            if Estimate.FindFirst then begin
                                "Die Cut Ups" := Estimate."No. of Die Cut Ups";
                                if Estimate."No. of Die Cut Ups" > 1 then begin
                                    Quantity := Round((Estimate.Quantity / Estimate."No. of Die Cut Ups"), 1);
                                    Validate(Quantity);
                                end else begin
                                    Validate(Quantity, Estimate.Quantity);
                                end;

                                if Estimate."Unit Cost From Cal Sheet" = true then begin
                                    "Price Based Condition" := WorkCenter."Price Based Condition";
                                    if WorkCenter."Price Based Condition" = 1 then begin
                                        Estimate.TestField(Estimate."No. of Ply");
                                        "Price Based Condition Value" := Estimate."No. of Ply";
                                        GetPricesWorkCenter("Product Design No.");
                                    end;
                                    if WorkCenter."Price Based Condition" = 2 then begin
                                        "Price Based Condition Value" := Estimate."No. of Colour";
                                        GetPricesWorkCenter("Product Design No.");
                                    end;
                                    if WorkCenter."Price Based Condition" = 3 then begin
                                        Estimate.TestField(Estimate."No. of Joint");
                                        "Price Based Condition Value" := Estimate."No. of Joint";
                                        GetPricesWorkCenter("Product Design No.");
                                    end;
                                    if WorkCenter."Price Based Condition" = 4 then begin
                                        Estimate.TestField(Estimate."No. of Die Cut Ups");
                                        "Price Based Condition Value" := Estimate."No. of Die Cut Ups";
                                        GetPricesWorkCenter("Product Design No.");
                                    end;
                                    if WorkCenter."Price Based Condition" = 5 then begin
                                        Estimate.TestField(Estimate.Stitching);
                                        Estimate.TestField(Estimate."Box Height (mm) - D (OD)");
                                        "Price Based Condition Value" := Estimate."Box Height (mm) - D (OD)";
                                        GetPricesStichingWorkCenter("Product Design No.");
                                    end;

                                    PriceUpdate;
                                end else begin
                                    Validate("Unit Cost", WorkCenter."Unit Cost");
                                    Validate(Quantity, Estimate.Quantity);
                                    PriceUpdate;
                                end;
                            end;
                        end;
                    Type::"Machine Center":
                        begin
                            MachineCenter.Get("No.");
                            Description := MachineCenter.Name;

                            Estimate.Reset;
                            Estimate.SetRange(Estimate."Product Design Type", "Product Design Type");
                            Estimate.SetRange(Estimate."Product Design No.", "Product Design No.");
                            Estimate.SetRange(Estimate."Sub Comp No.", "Sub Comp No.");
                            if Estimate.FindFirst then begin
                                "Die Cut Ups" := Estimate."No. of Die Cut Ups";
                                if Estimate."No. of Die Cut Ups" > 1 then begin
                                    Quantity := Round((Estimate.Quantity / Estimate."No. of Die Cut Ups"), 1);
                                    Validate(Quantity);
                                end else begin
                                    Validate(Quantity, Estimate.Quantity);
                                end;

                                if Estimate."Unit Cost From Cal Sheet" = true then begin
                                    "Price Based Condition" := MachineCenter."Price Based Condition";
                                    if MachineCenter."Price Based Condition" = 1 then begin
                                        Estimate.TestField(Estimate."No. of Ply");
                                        "Price Based Condition Value" := Estimate."No. of Ply";
                                        GetPrices("Product Design No.");
                                    end;

                                    if MachineCenter."Price Based Condition" = 2 then begin
                                        "Price Based Condition Value" := Estimate."No. of Colour";
                                        GetPrices("Product Design No.");
                                    end;

                                    if MachineCenter."Price Based Condition" = 3 then begin
                                        Estimate.TestField(Estimate."No. of Joint");
                                        "Price Based Condition Value" := Estimate."No. of Joint";
                                        GetPrices("Product Design No.");
                                    end;

                                    if MachineCenter."Price Based Condition" = 4 then begin
                                        Estimate.TestField(Estimate."No. of Die Cut Ups");
                                        "Price Based Condition Value" := Estimate."No. of Die Cut Ups";
                                        GetPrices("Product Design No.");
                                    end;
                                    if MachineCenter."Price Based Condition" = 5 then begin
                                        Estimate.TestField(Estimate.Stitching);
                                        Estimate.TestField(Estimate."Box Height (mm) - D (OD)");
                                        "Price Based Condition Value" := Estimate."Box Height (mm) - D (OD)";
                                        GetPricesStiching("Product Design No.");
                                    end;
                                end;
                                PriceUpdate;
                            end else begin
                                Validate("Unit Cost", MachineCenter."Unit Cost");
                                Validate(Quantity, Estimate.Quantity);
                                PriceUpdate;
                            end;
                        end;
                end;
            end;
        }
        field(12; Description; Text[250])
        {

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(13; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
                PriceUpdate;
            end;
        }
        field(14; "Unit Of Measure"; Code[10])
        {
            TableRelation = IF (Type = CONST (Item)) "Item Unit of Measure".Code WHERE ("Item No." = FIELD ("No."))
            ELSE
            IF (Type = CONST ("Work Center")) "Capacity Unit of Measure"
            ELSE
            IF (Type = FILTER ("Machine Center")) "Capacity Unit of Measure"
            ELSE
            IF (Type = CONST ("G/L Account")) "Unit of Measure";

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
                PriceUpdate;
            end;
        }
        field(15; "Bursting factor(BF)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(16; "Deckle Size"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(17; "Setup Time(Min)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(18; "Run Time (Min)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(19; "Paper Required in Mtr"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(30; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                PriceUpdate;
            end;
        }
        field(31; "Line Amount"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(40; "Last Purchase Price"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(41; "Wt. Average Price"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(50; Remarks; Text[100])
        {

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(51; "Line Type"; Option)
        {
            OptionCaption = ' ,RM,Paper,Glue,Process,Expences';
            OptionMembers = " ",RM,Paper,Glue,Process,Expences;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(53; GSM; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(54; "Flute Type"; Option)
        {
            OptionCaption = ' ,A,B,C,D,E,F';
            OptionMembers = " ",A,B,C,D,E,F;

            trigger OnValidate()
            begin
                // Lines added BY Deepak kumar
                if ("Paper Position" = 1) or ("Paper Position" = 3) or ("Paper Position" = 5) or ("Paper Position" = 7) then
                    Error(Sam001);

                MfgSetup.Get;

                case "Flute Type" of
                    "Flute Type"::A:
                        begin
                            MfgSetup.TestField(MfgSetup."Flute - A");
                            "Take Up" := MfgSetup."Flute - A";
                            Modify(true);
                        end;

                    "Flute Type"::B:
                        begin
                            MfgSetup.TestField(MfgSetup."Flute - B");
                            "Take Up" := MfgSetup."Flute - B";
                            Modify(true);
                        end;
                    "Flute Type"::C:
                        begin
                            MfgSetup.TestField(MfgSetup."Flute - C");
                            "Take Up" := MfgSetup."Flute - C";
                            Modify(true);
                        end;
                    "Flute Type"::D:
                        begin
                            MfgSetup.TestField(MfgSetup."Flute - D");
                            "Take Up" := MfgSetup."Flute - D";
                            Modify(true);
                        end;

                    "Flute Type"::E:
                        begin
                            MfgSetup.TestField(MfgSetup."Flute - E");
                            "Take Up" := MfgSetup."Flute - E";
                            Modify(true);
                        end;
                    "Flute Type"::F:
                        begin
                            MfgSetup.TestField(MfgSetup."Flute - F");
                            "Take Up" := MfgSetup."Flute - F";
                            Modify(true);
                        end;
                end;
            end;
        }
        field(55; "Take Up"; Decimal)
        {
            InitValue = 1;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
                // Lines added bY Deepak Kumar
                if ("Paper Position" = 1) or ("Paper Position" = 3) or ("Paper Position" = 5) or ("Paper Position" = 7) then
                    Error(Sam001);
            end;
        }
        field(56; "Paper Position"; Option)
        {
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
                "Take Up" := 1;
            end;
        }
        field(57; "Paper Weight (gms)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(58; "Paper Required KG"; Decimal)
        {
            DecimalPlaces = 2 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(59; "Trim Weight (gms)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(60; "Paper Bursting Strength(BS)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(62; "Board / Partition Ply Wt (gm)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(63; "Board Ply GSM"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(64; "Link Code"; Option)
        {
            OptionCaption = 'Box,Board';
            OptionMembers = Box,Board;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(77; "Paper Weight incl Core (gm)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(78; "Die Cut Ups"; Integer)
        {
            InitValue = 1;
            MaxValue = 100;
            MinValue = 1;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
                //Deepak
                UpdateBoardUps;
                // Lines added bY Deepak Kumar 23 / 03/ 14
                if "Die Cut Ups" > 1 then
                    "Routing Unit of Measure" := 'Sheet'
                else
                    "Routing Unit of Measure" := 'PCS';
            end;
        }
        field(79; "No of Joints"; Integer)
        {
            InitValue = 1;
            MaxValue = 100;
            MinValue = 1;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
                //Deepak
                UpdateBoardUps;
            end;
        }
        field(80; "Extra Trim"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(81; "Trim more than Allowed"; Boolean)
        {
            Editable = false;
        }
        field(82; "Extra Trim Weight (KG)"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(100; "Work Centor Group"; Code[20])
        {
            TableRelation = "Work Center Group".Code;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(101; "Routing Unit of Measure"; Code[20])
        {
            InitValue = 'PCS';
            TableRelation = "Unit of Measure".Code;

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(102; "Routing Link Code"; Code[10])
        {
            CaptionML = ENU = 'Routing Link Code';
            TableRelation = "Routing Link";

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
                if "Routing Link Code" <> '' then begin
                    TestField("No.");
                end;
            end;
        }
        field(105; "Customer GSM"; Decimal)
        {
        }
        field(1501; "Component Of"; Code[20])
        {
            TableRelation = "Material / Process Link Code".Code WHERE ("Quick Product Design" = FILTER (false));

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(1502; "Consume / Process For"; Code[20])
        {
            TableRelation = "Material / Process Link Code".Code WHERE ("Quick Product Design" = FILTER (false));

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
            end;
        }
        field(2000; "Deckle Size Filter"; Code[10])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code" = CONST ('DECKLESIZE'));

            trigger OnValidate()
            var
                AttributeValue: Record "Attribute Value";
            begin
                ValidateHeaderStatus;
                // Lines added By Deepak Kumar
                //GetItemLine;
                //Update Deckle DECKLESIZE
                AttributeValue.Reset;
                AttributeValue.SetRange(AttributeValue."Attribute Code", 'DECKLESIZE');
                AttributeValue.SetRange(AttributeValue."Attribute Value", "Deckle Size Filter");
                if AttributeValue.FindFirst then begin
                    "Deckle Size" := AttributeValue."Attribute Value Numreric";
                end;
            end;
        }
        field(2001; "BF (Burst Factor) Filter"; Code[10])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code" = CONST ('BF'));

            trigger OnValidate()
            begin
                ValidateHeaderStatus;
                // Lines added By Deepak Kumar
                GetItemLine;
            end;
        }
        field(2002; "Paper GSM Filter"; Code[10])
        {
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code" = CONST ('PAPERGSM'));

            trigger OnValidate()
            var
                AttributeValue: Record "Attribute Value";
            begin
                ValidateHeaderStatus;
                // Lines added By Deepak Kumar
                //GetItemLine;
                // Update GSM Filter PAPERGSM
                AttributeValue.Reset;
                AttributeValue.SetRange(AttributeValue."Attribute Code", 'PAPERGSM');
                AttributeValue.SetRange(AttributeValue."Attribute Value", "Paper GSM Filter");
                if AttributeValue.FindFirst then begin
                    GSM := AttributeValue."Attribute Value Numreric";
                end;
            end;
        }
        field(50001; "Work Center Category"; Option)
        {
            OptionCaption = ',Materials,Origination Cost,Corrugation,Printing Guiding,Finishing Packing,Sub Job';
            OptionMembers = ,Materials,"Origination Cost",Corrugation,"Printing Guiding","Finishing Packing","Sub Job";

            trigger OnValidate()
            begin

                // Lines added BY Deepak Kumar
                ValidateHeaderStatus;
                TestField("No.", '');
                if "Work Center Category" = "Work Center Category"::"Printing Guiding" then begin
                    Estimate.Reset;
                    Estimate.SetRange(Estimate."Product Design Type", "Product Design Type");
                    Estimate.SetRange(Estimate."Product Design No.", "Product Design No.");
                    Estimate.SetRange(Estimate."Sub Comp No.", "Sub Comp No.");
                    if Estimate.FindFirst then begin
                        Estimate.Printing := true;
                        Estimate.Modify(true);
                    end;
                end;
                if (xRec."Work Center Category" = xRec."Work Center Category"::"Printing Guiding") and
                  ("Work Center Category" <> "Work Center Category"::"Printing Guiding") then begin
                    Estimate.Reset;
                    Estimate.SetRange(Estimate."Product Design Type", "Product Design Type");
                    Estimate.SetRange(Estimate."Product Design No.", "Product Design No.");
                    Estimate.SetRange(Estimate."Sub Comp No.", "Sub Comp No.");
                    if Estimate.FindFirst then begin
                        Estimate.Printing := false;
                        Estimate.Modify(true);
                    end;
                end;
            end;
        }
        field(50002; Inventory; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Item No." = FIELD ("No.")));
            FieldClass = FlowField;
        }
        field(60000; "Price Based Condition"; Option)
        {
            Editable = false;
            OptionCaption = ' ,No of Ply,No of Colour,No of Joint,No of Die Cut Ups,Stitching';
            OptionMembers = " ","No of Ply","No of Colour","No of Joint","No of Die Cut Ups",Stitching;
        }
        field(60001; "Price Based Condition Value"; Integer)
        {
            Editable = false;
        }
        field(60002; "Paper Type"; Code[30])
        {
            CalcFormula = Lookup (Item."Paper Type" WHERE ("No." = FIELD ("No.")));
            FieldClass = FlowField;
        }
        field(60003; "FSC Category"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Product Design Type", "Product Design No.", "Sub Comp No.", "Line No.")
        {
        }
        key(Key2; "Consume / Process For", "Component Of")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ValidateHeaderStatus;
    end;

    var
        Sam001: Label 'Liner Paper not required take up factor';
        StdTxt: Record "Standard Text";
        Item: Record Item;
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
        Resource: Record Resource;
        GLAcc: Record "G/L Account";
        Estimate: Record "Product Design Header";
        EstimateLine: Record "Product Design Line";
        LineCounter: Integer;
        TempLineNumber: Integer;
        TempPaperPostion: Integer;
        TempHeight: Decimal;
        ItemCate: Record "Item Category";
        ItemCategoryToFilter: Code[100];
        MfgSetup: Record "Manufacturing Setup";
        Answer: Boolean;

    local procedure GetItem()
    begin
        TestField("No.");
        if Item."No." <> "No." then
            Item.Get("No.");
    end;

    procedure PriceUpdate()
    begin
        "Line Amount" := Quantity * "Unit Cost";
    end;

    procedure UpdateBoardUps()
    begin
        // Lines added BY Deepak Kumar


        Estimate.Reset;
        Estimate.SetRange(Estimate."Product Design Type", "Product Design Type");
        Estimate.SetRange(Estimate."Product Design No.", "Product Design No.");
        Estimate.SetRange(Estimate."Sub Comp No.", "Sub Comp No.");
        if Estimate.FindFirst then begin
            Quantity := Round(((Estimate.Quantity / "Die Cut Ups") * "No of Joints"), 1, '>');
            Validate(Quantity);
        end;
    end;

    procedure GetEstimateTemplete(var EstimateType: Option Main,Sub; var EstimationNo: Code[20]; var SubCompNo: Code[20]; var NoofPly: Integer)
    var
        Question: Text[150];
        Answer: Boolean;
    begin
        // Lines added by deepak KUmar

        EstimateLine.Reset;
        EstimateLine.SetRange(EstimateLine."Product Design Type", EstimateType);
        EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationNo);
        EstimateLine.SetRange(EstimateLine."Sub Comp No.", SubCompNo);
        if EstimateLine.FindFirst then begin
            Question := 'Do you want to update "No. of Ply", it will reset current lines';
            Answer := DIALOG.Confirm(Question, true, EstimationNo);
            if Answer = true then
                EstimateLine.DeleteAll(true)
            else
                exit;

        end;

        LineCounter := NoofPly;
        if LineCounter > 5 then
            LineCounter := 5;
        TempLineNumber := 1000;
        TempPaperPostion := 1;
        repeat
            EstimateLine.Init;
            EstimateLine."Product Design Type" := EstimateType;
            EstimateLine."Product Design No." := EstimationNo;
            EstimateLine."Sub Comp No." := SubCompNo;
            EstimateLine."Line No." := TempLineNumber;
            TempLineNumber := TempLineNumber + 1000;
            EstimateLine.Type := EstimateLine.Type::Item;
            EstimateLine."Paper Position" := TempPaperPostion;
            TempPaperPostion += 1;
            EstimateLine."Work Center Category" := 1;
            EstimateLine.Insert(true);
            LineCounter := LineCounter - 1;
        until LineCounter = 0;
    end;

    procedure GetPrices(EstimateNumber: Code[20])
    var
        MachinePrices: Record "M/W Price List";
        TempPrice: Decimal;
    begin
        // Linhes added By Deepak kumar
        Estimate.Reset;
        Estimate.SetRange(Estimate."Product Design No.", EstimateNumber);
        if Estimate.FindFirst then begin

            MachinePrices.Reset;
            MachinePrices.SetRange(MachinePrices."No.", "No.");
            MachinePrices.SetRange(MachinePrices."Price Based Condition", "Price Based Condition");
            MachinePrices.SetFilter(MachinePrices."Condition Value", Format("Price Based Condition Value"));
            if MachinePrices.FindFirst then begin
                TempPrice := 0;
                repeat
                    if (MachinePrices."Minimum Quantity" <> 0) then begin
                        if (Estimate.Quantity >= MachinePrices."Minimum Quantity") and (Estimate.Quantity <= MachinePrices."Maximum Quantity") then begin
                            TempPrice := MachinePrices."Unit Price";

                        end;
                    end else begin
                        TempPrice := MachinePrices."Unit Price";
                    end;
                until MachinePrices.Next = 0;
                "Unit Cost" := TempPrice;
                // VALIDATE(Quantity,Estimate.Quantity);

            end else begin
                Error('Unit cost not available for the Machine Center %1');
            end;
        end;
    end;

    procedure GetPricesStiching(EstimateNumber: Code[20])
    var
        MachinePrices: Record "M/W Price List";
        TempPrice: Decimal;
    begin
        // Linhes added By Deepak kUmar
        Estimate.Reset;
        Estimate.SetRange(Estimate."Product Design No.", EstimateNumber);
        if Estimate.FindFirst then begin
            MachinePrices.Reset;
            MachinePrices.SetRange(MachinePrices."No.", "No.");
            MachinePrices.SetRange(MachinePrices."Price Based Condition", "Price Based Condition");
            if MachinePrices.FindFirst then begin
                TempPrice := 0;
                repeat
                    if (MachinePrices."Minimum Quantity" <> 0) then begin
                        if (Estimate."Box Height (mm) - D (OD)" >= MachinePrices."Minimum Quantity") and (Estimate."Box Height (mm) - D (OD)" <= MachinePrices."Maximum Quantity") then begin
                            TempPrice := MachinePrices."Unit Price";

                        end;
                    end else begin
                        TempPrice := MachinePrices."Unit Price";
                    end;
                until MachinePrices.Next = 0;
                "Unit Cost" := TempPrice;
                Validate(Quantity, Estimate.Quantity);

            end else begin
                Error('Unit cost not available for the Machine Center %1');
            end;
        end;
    end;

    procedure GetPricesWorkCenter(EstimateNumber: Code[20])
    var
        MachinePrices: Record "M/W Price List";
        TempPrice: Decimal;
    begin
        // Linhes added By Deepak kUmar
        Estimate.Reset;
        Estimate.SetRange(Estimate."Product Design No.", EstimateNumber);
        if Estimate.FindFirst then begin

            MachinePrices.Reset;
            MachinePrices.SetRange(MachinePrices.Type, MachinePrices.Type::"Work Center");
            MachinePrices.SetRange(MachinePrices."No.", "No.");
            MachinePrices.SetRange(MachinePrices."Price Based Condition", "Price Based Condition");
            MachinePrices.SetFilter(MachinePrices."Condition Value", Format("Price Based Condition Value"));
            if MachinePrices.FindFirst then begin
                TempPrice := 0;
                repeat
                    if (MachinePrices."Minimum Quantity" <> 0) then begin
                        if (Estimate.Quantity >= MachinePrices."Minimum Quantity") and (Estimate.Quantity <= MachinePrices."Maximum Quantity") then begin
                            TempPrice := MachinePrices."Unit Price";
                        end;
                    end else begin
                        TempPrice := MachinePrices."Unit Price";
                    end;
                until MachinePrices.Next = 0;
                "Unit Cost" := TempPrice;
                // VALIDATE(Quantity,Estimate.Quantity);

            end else begin
                Error('Unit cost not available for the Work Center %1');
            end;
        end;
    end;

    procedure GetPricesStichingWorkCenter(EstimateNumber: Code[20])
    var
        MachinePrices: Record "M/W Price List";
        TempPrice: Decimal;
    begin
        // Linhes added By Deepak kUmar
        Estimate.Reset;
        Estimate.SetRange(Estimate."Product Design No.", EstimateNumber);
        if Estimate.FindFirst then begin
            MachinePrices.Reset;
            MachinePrices.SetRange(MachinePrices.Type, MachinePrices.Type::"Work Center");
            MachinePrices.SetRange(MachinePrices."No.", "No.");
            MachinePrices.SetRange(MachinePrices."Price Based Condition", "Price Based Condition");
            if MachinePrices.FindFirst then begin
                TempPrice := 0;
                repeat
                    if (MachinePrices."Minimum Quantity" <> 0) then begin
                        if (Estimate."Box Height (mm) - D (OD)" >= MachinePrices."Minimum Quantity") and (Estimate."Box Height (mm) - D (OD)" <= MachinePrices."Maximum Quantity") then begin
                            TempPrice := MachinePrices."Unit Price";

                        end;
                    end else begin
                        TempPrice := MachinePrices."Unit Price";
                    end;
                until MachinePrices.Next = 0;
                "Unit Cost" := TempPrice;
                Validate(Quantity, Estimate.Quantity);

            end else begin
                Error('Unit cost not available for the Work center %1');
            end;
        end;
    end;

    local procedure GetItemLine()
    var
        ItemMaster: Record Item;
    begin
        // Lines added BY Deepak Kumar


        ItemMaster.Reset;
        if ("BF (Burst Factor) Filter" <> '') then
            ItemMaster.SetFilter(ItemMaster."Bursting factor(BF)", "BF (Burst Factor) Filter");
        if ("Paper GSM Filter" <> '') then
            ItemMaster.SetFilter(ItemMaster."Paper GSM", "Paper GSM Filter");
        if ("Deckle Size Filter" <> '') then
            ItemMaster.SetFilter(ItemMaster."Deckle Size (mm)", "Deckle Size Filter");
        if ItemMaster.FindFirst then begin
            Validate("No.", ItemMaster."No.");
        end else begin
            Error('Item with BF %1 ,GSM %2 and Deckle size %3 not available in Item master', "BF (Burst Factor) Filter", "Paper GSM Filter", "Deckle Size Filter");
        end;
    end;

    local procedure ValidateHeaderStatus()
    begin
        // Lines added BY Deepak Kumar
        Estimate.Reset;
        Estimate.SetRange(Estimate."Product Design Type", Estimate."Product Design Type"::Main);
        Estimate.SetRange(Estimate."Product Design No.", "Product Design No.");
        if Estimate.FindFirst then
            Estimate.TestField(Estimate.Status, Estimate.Status::Open);
    end;

    procedure CalculateExrtaTrim(ItemNo: Code[20])
    var
        EstimateHeader: Record "Product Design Header";
    begin
        // Lines added By Deepak Kumar
        MfgSetup.Get;

        EstimateHeader.Reset;
        EstimateHeader.SetRange(EstimateHeader."Product Design Type", "Product Design Type");
        EstimateHeader.SetRange(EstimateHeader."Product Design No.", "Product Design No.");
        EstimateHeader.SetRange(EstimateHeader."Sub Comp No.", "Sub Comp No.");
        if EstimateHeader.FindFirst then begin
            Item.Get(ItemNo);
            if Item."Deckle Size (mm)" < EstimateHeader."Roll Width (mm)" then
                Error('"Item Deckle" size must not be smaller than "Roll Width"');
            MfgSetup.Get;
            MfgSetup.TestField(MfgSetup."Scrap % for Estimation");

            "Extra Trim" := Item."Deckle Size (mm)" - EstimateHeader."Roll Width (mm)";

            "Extra Trim Weight (KG)" := (((("Extra Trim" * GSM * EstimateHeader."Cut Size (mm)" * MfgSetup."Scrap % for Estimation" * "Take Up") / 1000000) * EstimateHeader.Quantity) / 1000) / EstimateHeader."Board Ups"; // Added by Binay 20.12.15
            if "Extra Trim" > MfgSetup."Extra Trim - Max" then
                "Trim more than Allowed" := true;

        end;
    end;

    procedure CalculatePaperTypeAddCost(ItemCode: Code[50])
    var
        PaperTypeAddCost: Record "Paper Type Price";
    begin
        // Lines Added By Deepak Kumar Fo Additioanl Cost
        Item.Get(ItemCode);
        PaperTypeAddCost.Reset;
        PaperTypeAddCost.SetRange(PaperTypeAddCost."Paper Type", Item."Paper Type");
        PaperTypeAddCost.SetRange(PaperTypeAddCost."Start Date", 0D, WorkDate);
        if PaperTypeAddCost.FindFirst then begin
            "Wt. Average Price" := "Wt. Average Price" + ("Wt. Average Price" * (PaperTypeAddCost."Add On % for Est. Cost" / 100));
            "Unit Cost" := "Unit Cost" + ("Unit Cost" * (PaperTypeAddCost."Add On % for Est. Cost" / 100));
            PriceUpdate;
        end;
    end;
}

