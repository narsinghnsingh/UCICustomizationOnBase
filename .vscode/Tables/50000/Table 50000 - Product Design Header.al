table 50000 "Product Design Header"
{
    // version Estimate Samadhan


    fields
    {
        field(1; "Product Design Type"; Option)
        {
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(2; "Product Design No."; Code[50])
        {
        }
        field(3; "Product Design Date"; Date)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(4; "Sub Comp No."; Code[20])
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(5; "Model No"; Code[20])
        {
            TableRelation = "Product Design Model Master"."Model No";

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added bY Deepak Kumar
                ModelMaster.Reset;
                ModelMaster.SetRange(ModelMaster."Model No", "Model No");
                if ModelMaster.FindFirst then begin
                    ModelMaster.CalcFields(ModelMaster."Picture Diagram", ModelMaster.Picture);
                    "Model Description" := ModelMaster.Description;
                    "Picture 1" := ModelMaster."Picture Diagram";
                    "Picture 2" := ModelMaster.Picture;
                    "Die Punching" := ModelMaster."Die Cut";
                    Modify(true);
                end;
            end;
        }
        field(6; "Model Description"; Text[100])
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(7; "Component Type"; Option)
        {
            Description = '//Only for Sub Job';
            OptionCaption = 'Partition or Plate,Regular Slotted Container (RSC),Die Cut Carton,Die Cut Carton Laminated,Board,Half Slotted Container (HSC),RSC- Overlap Flap';
            OptionMembers = "Partition or Plate","Regular Slotted Container (RSC)","Die Cut Carton","Die Cut Carton Laminated",Board,"Half Slotted Container (HSC)","RSC- Overlap Flap";

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(10; Customer; Code[20])
        {
            TableRelation = Customer."No." WHERE (Blocked = FILTER (" "));

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added By Deepak Kumar
                CustomerMaster.Reset;
                CustomerMaster.SetRange(CustomerMaster."No.", Customer);
                if CustomerMaster.FindFirst then begin
                    Name := CustomerMaster.Name;
                    Address := CustomerMaster.Address;
                    Contact := '';
                end else begin
                    Name := '';
                    Address := '';
                end;
            end;
        }
        field(11; Contact; Code[10])
        {
            TableRelation = Contact."No.";

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                ValidateStatus;
                ContactMaster.Reset;
                ContactMaster.SetRange(ContactMaster."No.", Contact);
                if ContactMaster.FindFirst then begin
                    Name := ContactMaster.Name;
                    Address := ContactMaster.Address;
                    Customer := '';
                end else begin
                    Name := '';
                    Address := '';
                end;
            end;
        }
        field(12; Name; Text[150])
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(13; Address; Text[150])
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(14; "Sales Person Code"; Code[30])
        {
            TableRelation = "Salesperson/Purchaser".Code;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(15; "No of Sub Component"; Integer)
        {
            CalcFormula = Count ("Product Design Header" WHERE ("Product Design Type" = CONST (Sub),
                                                               "Product Design No." = FIELD ("Product Design No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(16; "Quantity Per FG"; Decimal)
        {
            Description = 'Only For Sub Job';

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(17; "By Purchased Board"; Boolean)
        {
            Description = 'for Processing from Purchased Board Material';

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(20; "Separate Sales Lines"; Boolean)
        {
            Description = 'Deepak //260316';
        }
        field(52; "Pre-Press Status"; Option)
        {
            Editable = false;
            OptionMembers = " ","Update Pending from Pre-Press ","Updated & Confirmed";
        }
        field(53; "Pre-Press Confirmed By"; Text[150])
        {
            Editable = false;
        }
        field(54; "Production Status"; Option)
        {
            Editable = false;
            OptionMembers = " ","Update Pending from Production ","Updated & Confirmed";
        }
        field(55; "Production Confirmed By"; Text[150])
        {
            Editable = false;
        }
        field(100; "Item Code"; Code[20])
        {
            TableRelation = Item."No." WHERE (Blocked = FILTER (false));

            trigger OnValidate()
            var
                ItemAttributeEntry: Record "Item Attribute Entry";
            begin
                // Lines added By Deepak Kumar
                ValidateStatus;
                EstimationHeader.Reset;
                EstimationHeader.SetRange(EstimationHeader."Item Code", "Item Code");
                EstimationHeader.SetFilter(EstimationHeader."Product Design No.", '<>%1', "Product Design No.");
                if EstimationHeader.FindFirst then begin
                    if EstimationHeader."Sales Quote No." = '' then
                        Message('This Item already exists in Estimate No %1', EstimationHeader."Product Design No.");
                end;

                ItemMaster.Reset;
                ItemMaster.SetRange(ItemMaster."No.", "Item Code");
                if ItemMaster.FindFirst then begin
                    "Item Description" := ItemMaster.Description;
                    "Item Unit of Measure" := ItemMaster."Base Unit of Measure";
                    ItemAttributeEntry.Reset;
                    ItemAttributeEntry.SetRange(ItemAttributeEntry."Item No.", "Item Code");
                    if ItemAttributeEntry.FindFirst then begin
                        repeat
                            ItemAttributeEntry.CalcFields(ItemAttributeEntry."Item Attribute Value NUm");
                            if ItemAttributeEntry."Item Attribute Code" = 'HEIGHT' then
                                Validate("Box Height (mm) - D (OD)", ItemAttributeEntry."Item Attribute Value NUm");
                            if ItemAttributeEntry."Item Attribute Code" = 'LENGTH' then
                                Validate("Box Length (mm)- L (OD)", ItemAttributeEntry."Item Attribute Value NUm");
                            if ItemAttributeEntry."Item Attribute Code" = 'WIDTH' then
                                Validate("Box Width (mm)- W (OD)", ItemAttributeEntry."Item Attribute Value NUm");
                            if ItemAttributeEntry."Item Attribute Code" = 'FG GSM' then
                                Validate("Customer GSM", ItemAttributeEntry."Item Attribute Value NUm");

                            if ItemAttributeEntry."Item Attribute Code" = 'PLY' then
                                Validate("No. of Ply", ItemAttributeEntry."Item Attribute Value NUm");
                            if ItemAttributeEntry."Item Attribute Code" = 'MODEL' then
                                Validate("Model No", ItemAttributeEntry."Item Attribute Value");
                        until ItemAttributeEntry.Next = 0;
                    end;
                    UpdateTopColour("Item Code");
                    ;
                end else begin
                    "Item Description" := '';
                end;
            end;
        }
        field(101; "Item Description"; Text[250])
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(102; "Customer GSM"; Integer)
        {
        }
        field(103; "Box Length (mm)- L (OD)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added by Deepak Kumar

                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Length (mm)- L (ID)" := ("Box Length (mm)- L (OD)" - ExpectedBoxHeight);
                end;

                "Box Length (cm)" := "Box Length (mm)- L (OD)" * 0.1;
                "Box Length (inch)" := "Box Length (mm)- L (OD)" * 0.039371;
            end;
        }
        field(104; "Box Width (mm)- W (OD)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added bY Deepak Kumar
                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Width (mm)- W (ID)" := ("Box Width (mm)- W (OD)" - ExpectedBoxHeight);
                end;

                "Box Width (cm)" := "Box Width (mm)- W (OD)" * 0.1;
                "Box Width (inch)" := "Box Width (mm)- W (OD)" * 0.039371;
            end;
        }
        field(105; "Box Height (mm) - D (OD)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added by Deepak Kumar
                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Height (mm) - D (ID)" := ("Box Height (mm) - D (OD)" - (ExpectedBoxHeight * 2));
                end;

                "Box Height (cm)" := "Box Height (mm) - D (OD)" * 0.1;
                "Box Height (inch)" := "Box Height (mm) - D (OD)" * 0.039371;
            end;
        }
        field(106; "Board Length (mm)- L"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                "Board Length (cm)" := "Board Length (mm)- L" * 0.1;
                "Board Length (inch)" := "Board Length (mm)- L" * 0.039371;
            end;
        }
        field(107; "Board Width (mm)- W"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                "Board Width (cm)" := "Board Width (mm)- W" * 0.1;
                "Board Width (inch)" := "Board Width (mm)- W" * 0.039371;
            end;
        }
        field(109; "Roll Width (mm)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;

                "Roll Width (cm)" := "Roll Width (mm)" * 0.1;
                "Roll Width ( Inch)" := "Roll Width (mm)" * 0.039371;
            end;
        }
        field(110; "Cut Size (mm)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
                "Cut Size (cm)" := "Cut Size (mm)" * 0.1;
                "Cut Size (Inch)" := "Cut Size (mm)" * 0.039371;
            end;
        }
        field(111; "Roll Width ( Inch)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;

                "Roll Width (cm)" := "Roll Width ( Inch)" * 2.54;
                "Roll Width (mm)" := "Roll Width ( Inch)" * 25.4;
            end;
        }
        field(112; "Cut Size (Inch)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;

                "Cut Size (cm)" := "Cut Size (Inch)" * 2.54;
                "Cut Size (mm)" := "Cut Size (Inch)" * 25.4;
            end;
        }
        field(113; Grammage; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(114; "Board Ups"; Integer)
        {
            InitValue = 1;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(115; "Board Size"; Text[50])
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(116; "Box Size"; Text[50])
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(117; "Corrugation Ups"; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(118; "Box Amount per Unit"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(119; "With Flap Gap"; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(120; "Flap Gap Size(mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(121; "Item No.2"; Code[50])
        {
            CalcFormula = Lookup (Item."No. 2" WHERE ("No." = FIELD ("Item Code")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(122; "Item Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(123; "Joint Flap Size(mm)"; Decimal)
        {
            InitValue = 40;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(124; "Box BS"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(125; "Box LBS"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(126; "Box Length (mm)- L (ID)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added BY Deepak Kumar
                "Input Size Option" := "Input Size Option"::ID;
                UpdateIDvsOD;
                Validate("Box Length (mm)- L (OD)", ("Box Length (mm)- L (ID)" + ExpectedBoxHeight));
            end;
        }
        field(127; "Box Width (mm)- W (ID)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;

                // Lines added BY Deepak Kumar
                "Input Size Option" := "Input Size Option"::ID;
                UpdateIDvsOD;
                Validate("Box Width (mm)- W (OD)", ("Box Width (mm)- W (ID)" + ExpectedBoxHeight));
            end;
        }
        field(128; "Box Height (mm) - D (ID)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added BY Deepak Kumar
                "Input Size Option" := "Input Size Option"::ID;
                UpdateIDvsOD;
                Validate("Box Height (mm) - D (OD)", ("Box Height (mm) - D (ID)" + (ExpectedBoxHeight * 2)));
            end;
        }
        field(129; "Input Size Option"; Option)
        {
            OptionCaption = 'OD,ID';
            OptionMembers = OD,ID;
        }
        field(150; "Box Length (cm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added By deepak Kumar
                "Box Length (mm)- L (OD)" := "Box Length (cm)" * 10;
                "Box Length (inch)" := "Box Length (cm)" / 2.54;
                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Length (mm)- L (ID)" := ("Box Length (mm)- L (OD)" - ExpectedBoxHeight);
                end;
            end;
        }
        field(151; "Box Width (cm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added by Deepak Kumar
                "Box Width (mm)- W (OD)" := "Box Width (cm)" * 10;
                "Box Width (inch)" := "Box Width (cm)" / 2.54;
                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Width (mm)- W (ID)" := ("Box Width (mm)- W (OD)" - ExpectedBoxHeight);
                end;
            end;
        }
        field(152; "Box Height (cm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added By Deepak Kumar
                "Box Height (mm) - D (OD)" := "Box Height (cm)" * 10;
                "Box Height (inch)" := "Box Height (cm)" / 2.54;
                // Lines added by Deepak Kumar
                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Height (mm) - D (ID)" := ("Box Height (mm) - D (OD)" - (ExpectedBoxHeight * 2));
                end;
            end;
        }
        field(153; "Board Length (cm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                "Board Length (mm)- L" := "Board Length (cm)" * 10;
                "Board Length (inch)" := "Board Length (cm)" / 2.54;
            end;
        }
        field(154; "Board Width (cm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                "Board Width (mm)- W" := "Board Width (cm)" * 10;
                "Board Width (inch)" := "Board Width (cm)" / 2.54;
            end;
        }
        field(155; "Box Length (inch)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                //lines added Deepak Kumar
                "Box Length (cm)" := "Box Length (inch)" * 2.54;
                "Box Length (mm)- L (OD)" := "Box Length (inch)" * 25.4;
                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Length (mm)- L (ID)" := ("Box Length (mm)- L (OD)" - ExpectedBoxHeight);
                end;
            end;
        }
        field(156; "Box Width (inch)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                "Box Width (cm)" := "Box Width (inch)" * 2.54;
                "Box Width (mm)- W (OD)" := "Box Width (inch)" * 25.4;

                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Width (mm)- W (ID)" := ("Box Width (mm)- W (OD)" - ExpectedBoxHeight);
                end;
            end;
        }
        field(157; "Box Height (inch)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                "Box Height (cm)" := "Box Height (inch)" * 2.54;
                "Box Height (mm) - D (OD)" := "Box Height (inch)" * 25.4;
                // Lines added by Deepak Kumar
                if "Input Size Option" = "Input Size Option"::OD then begin
                    UpdateIDvsOD;
                    "Box Height (mm) - D (ID)" := ("Box Height (mm) - D (OD)" - (ExpectedBoxHeight * 2));
                end;
            end;
        }
        field(158; "Board Length (inch)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;

                "Board Length (cm)" := "Board Length (inch)" * 2.54;
                "Board Length (mm)- L" := "Board Length (inch)" * 25.4;
            end;
        }
        field(159; "Board Width (inch)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                "Board Width (cm)" := "Board Width (inch)" * 2.54;
                "Board Width (mm)- W" := "Board Width (inch)" * 25.4;
            end;
        }
        field(160; "Roll Width (cm)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added By deepak Kumar
                "Roll Width (mm)" := "Roll Width (cm)" * 10;
                "Roll Width ( Inch)" := "Roll Width (cm)" / 2.54;
            end;
        }
        field(161; "Cut Size (cm)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;

                "Cut Size (mm)" := "Cut Size (cm)" * 10;
                "Cut Size (Inch)" := "Cut Size (cm)" / 2.54;
            end;
        }
        field(162; "Scorer Type"; Option)
        {
            OptionCaption = ' ,1. Male to Female(3 Point),2. Point to Flat,3. Point to Point';
            OptionMembers = " ","1. Male to Female(3 Point)","2. Point to Flat","3. Point to Point";
        }
        field(163; "Scorer 1"; Decimal)
        {
        }
        field(164; "Scorer 2"; Decimal)
        {
        }
        field(165; "Scorer 3"; Decimal)
        {
        }
        field(166; "Scorer 4"; Decimal)
        {
            Editable = false;
        }
        field(167; "Scorer 5"; Decimal)
        {
            Editable = false;
        }
        field(168; "Linear Length Qty Per"; Decimal)
        {
            Editable = false;
        }
        field(169; "Linear Length"; Decimal)
        {
            Editable = false;
        }
        field(170; "Manual Scorer"; Boolean)
        {
        }
        field(1000; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added by deepak Kumar
                "Quantity to Job Order" := Quantity;
                EstimateLine.Reset;
                EstimateLine.SetRange(EstimateLine."Product Design Type", "Product Design Type");
                EstimateLine.SetRange(EstimateLine."Product Design No.", "Product Design No.");
                EstimateLine.SetRange(EstimateLine."Sub Comp No.", "Sub Comp No.");
                EstimateLine.SetFilter(EstimateLine.Type, '<>Item');
                if EstimateLine.FindFirst then begin
                    repeat
                        EstimateLine.Validate(Quantity, Quantity);
                        EstimateLine.Modify(true);
                    until EstimateLine.Next = 0;
                end;
            end;
        }
        field(1001; "No. of Ply"; Integer)
        {
            MaxValue = 5;
            MinValue = 2;

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added By Deepak Kumar
                if not "By Purchased Board" then
                    EstimateLine.GetEstimateTemplete("Product Design Type", "Product Design No.", "Sub Comp No.", "No. of Ply");

                MfgSetup.Get;

                if "No. of Ply" = 3 then begin
                    "Trim Size (mm)" := MfgSetup."Left Trim 3 Ply (cm)" + MfgSetup."Right Trim 3 Ply (cm)";
                    "Left Trim Size (mm)" := MfgSetup."Left Trim 3 Ply (cm)";
                    "Right Trim Size (mm)" := MfgSetup."Right Trim 3 Ply (cm)";
                end;

                if "No. of Ply" = 5 then begin
                    "Trim Size (mm)" := MfgSetup."Left Trim 5 Ply (cm)" + MfgSetup."Right Trim 5 Ply (cm)";
                    "Left Trim Size (mm)" := MfgSetup."Left Trim 5 Ply (cm)";
                    "Right Trim Size (mm)" := MfgSetup."Right Trim 5 Ply (cm)";

                end;
                if ("No. of Ply" <> 5) and ("No. of Ply" <> 3) then begin
                    "Trim Size (mm)" := 20;
                    "Left Trim Size (mm)" := 10;
                    "Right Trim Size (mm)" := 10;

                end;

            end;
        }
        field(1003; "No. of Colour"; Integer)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1004; "No. of Joint"; Integer)
        {
            InitValue = 1;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1005; "No. of Die Cut Ups"; Integer)
        {
            InitValue = 1;

            trigger OnValidate()
            begin
                ValidateStatus;
                // Lines added by deepak
                EstimateLine.Reset;
                EstimateLine.SetRange(EstimateLine."Product Design Type", "Product Design Type");
                EstimateLine.SetRange(EstimateLine."Product Design No.", "Product Design No.");
                EstimateLine.SetRange(EstimateLine."Sub Comp No.", "Sub Comp No.");
                if EstimateLine.FindFirst then begin
                    repeat
                        EstimateLine.Validate("Die Cut Ups", "No. of Die Cut Ups");
                        EstimateLine.Modify(true);
                    until EstimateLine.Next = 0;
                end;
            end;
        }
        field(1006; "Top Colour"; Code[50])
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1007; "Flute Type"; Text[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1008; "Per Box Weight (Gms)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1012; "Per Box Weight with Comp(Gms)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1013; "Plate Item No."; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate()
            var
                Rec_Item: Record Item;
            begin
                ValidateStatus;
                IF Rec_Item.GET("Plate Item No.") THEN
                    "Plate Item Client" := Rec_Item."No. 2"
                else
                    "Plate Item Client" := '';
            end;
        }
        field(1014; "Double Joint"; Boolean)
        {
            Enabled = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1015; "Board Item No."; Code[50])
        {
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1016; "Board Item Required"; Boolean)
        {
            InitValue = true;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1017; "Flute 1"; Option)
        {
            Description = '3 Ply';
            Editable = false;
            OptionMembers = " ",A,B,C,D,E,F;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1018; "Flute 2"; Option)
        {
            Description = '5 Ply';
            Editable = false;
            OptionMembers = " ",A,B,C,D,E,F;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1019; "Flute 3"; Option)
        {
            Description = '7 Ply';
            Editable = false;
            OptionMembers = " ",A,B,C,D,E,F;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1020; "Plate Item No. 2"; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1501; "Picture 1"; Blob)
        {
            CaptionML = ENU = 'Picture 1';
            Subtype = Bitmap;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1502; "Picture 2"; Blob)
        {
            CaptionML = ENU = 'Picture 2';
            Subtype = Bitmap;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1503; "Picture 3"; Blob)
        {
            CaptionML = ENU = 'Picture 3';
            Subtype = Bitmap;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1600; "Corrugation Machine"; Code[20])
        {
            TableRelation = "Machine Center"."No." WHERE ("Work Center Category" = CONST (Corrugation));

            trigger OnValidate()
            var
                MachineCenter: Record "Machine Center";
            begin
                ValidateStatus;
                //Lines added By Deepak Kumar
                MachineCenter.Reset;
                MachineCenter.SetRange(MachineCenter."No.", "Corrugation Machine");
                if MachineCenter.FindFirst then begin
                    "Machine Deckle Size (mm)" := MachineCenter."Maximum Deckle Size (mm)";
                    "Corrugation Machine Name" := MachineCenter.Name;
                    MfgSetup.Get;
                    "Left Trim Size (mm)" := MfgSetup."Left Trim 3 Ply (cm)";
                    "Right Trim Size (mm)" := MfgSetup."Right Trim 3 Ply (cm)";
                    "Trim Size (mm)" := (MfgSetup."Right Trim 3 Ply (cm)" + MfgSetup."Left Trim 3 Ply (cm)");

                    "Machine Maximum Deckle Ups" := MachineCenter."Maximum Deckle Ups";
                    if "By Purchased Board" then
                        exit;

                    EstimateLine.Reset;
                    EstimateLine.SetRange(EstimateLine."Product Design Type", "Product Design Type");
                    EstimateLine.SetRange(EstimateLine."Product Design No.", "Product Design No.");
                    EstimateLine.SetRange(EstimateLine."Sub Comp No.", "Sub Comp No.");
                    EstimateLine.SetRange(EstimateLine."Work Center Category", EstimateLine."Work Center Category"::Corrugation);
                    if EstimateLine.FindFirst then begin
                        if EstimateLine."No." <> "Corrugation Machine" then begin
                            EstimateLine.DeleteAll(true);
                            EstimateLine.Init;
                            EstimateLine."Product Design Type" := "Product Design Type";
                            EstimateLine."Product Design No." := "Product Design No.";
                            EstimateLine."Sub Comp No." := "Sub Comp No.";
                            EstimateLine."Line No." := 5500;
                            EstimateLine."Work Center Category" := EstimateLine."Work Center Category"::Corrugation;
                            EstimateLine.Validate(EstimateLine.Type, EstimateLine.Type::"Machine Center");
                            EstimateLine.Insert(true);
                            EstimateLine.Validate("No.", "Corrugation Machine");
                            EstimateLine.Validate(Quantity, Quantity);
                            EstimateLine."Consume / Process For" := 'BOARD';
                            EstimateLine.Modify(true);
                        end;
                    end else begin
                        EstimateLine.Init;
                        EstimateLine."Product Design Type" := "Product Design Type";
                        EstimateLine."Product Design No." := "Product Design No.";
                        EstimateLine."Sub Comp No." := "Sub Comp No.";
                        EstimateLine."Line No." := 5500;
                        EstimateLine."Work Center Category" := EstimateLine."Work Center Category"::Corrugation;
                        EstimateLine.Type := EstimateLine.Type::"Machine Center";
                        EstimateLine.Insert(true);
                        EstimateLine.Validate("No.", "Corrugation Machine");
                        EstimateLine.Validate(Quantity, Quantity);
                        EstimateLine."Consume / Process For" := 'BOARD';
                        EstimateLine.Modify(true);
                    end;

                end else begin
                    "Machine Deckle Size (mm)" := 0;
                    "Corrugation Machine Name" := '';
                    "Machine Maximum Deckle Ups" := 0;
                end;
            end;
        }
        field(1601; "Machine Deckle Size (mm)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1602; "Corrugation Machine Name"; Text[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1603; "Paper Deckle Size (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1604; "Basis for No.of Up Calc"; Option)
        {
            OptionCaption = 'Machine Deckle Size,Paper Deckle Size';
            OptionMembers = "Machine Deckle Size","Paper Deckle Size";

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1605; "Machine Maximum Deckle Ups"; Integer)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(1606; "Corrugation Direction"; Option)
        {
            OptionCaption = 'Width Wise,Length Wise';
            OptionMembers = "Width Wise","Length Wise";

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(2000; "Quantity to Job Order"; Decimal)
        {
        }
        field(3000; "Created by"; Code[30])
        {
            Editable = false;
        }
        field(3001; "Created Date"; Date)
        {
            Editable = false;
        }
        field(3002; "Modified by"; Code[30])
        {
            Editable = false;
        }
        field(3003; "Midified Date"; Date)
        {
            Editable = false;
        }
        field(3004; "Trim Size (mm)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
                UpdateTrimSize;
            end;
        }
        field(3005; "Left Trim Size (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                UpdateTrimSize;
            end;
        }
        field(3006; "Right Trim Size (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
                UpdateTrimSize;
            end;
        }
        field(3007; "Manual Trim"; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(3999; "Line Amount"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(4000; "Margin %"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
                "Margin Amount" := 0;
            end;
        }
        field(4001; "Margin Amount"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
                "Margin %" := 0;
            end;
        }
        field(4002; "Sales Price (Per Unit)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(4003; "Die Making Charges"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(4004; "Plate Making Charges"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(4005; "Other Charges"; Decimal)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(4999; "Total Weight for Est. Qty (Kg)"; Decimal)
        {
            Editable = false;
        }
        field(5000; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(5001; "Amount Per Unit"; Decimal)
        {
            Editable = false;
        }
        field(5002; "Amount Per KG"; Decimal)
        {
            Editable = false;
        }
        field(5003; "Copy From"; Code[10])
        {
            TableRelation = "Product Design Header"."Product Design No." WHERE ("Product Design Type" = CONST (Main),
                                                                                Status = FILTER (Open | Approved));

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(5004; "Unit Cost From Cal Sheet"; Boolean)
        {
            InitValue = true;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(5060; "Product GSM"; Code[20])
        {
            CalcFormula = Lookup ("Item Attribute Entry"."Item Attribute Value" WHERE ("Item No." = FIELD ("Item Code"),
                                                                                      "Item Attribute Code" = CONST ('FG_GSM')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8000; "Artwork Available"; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8001; "Proof Required"; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8002; "Client Sample"; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8003; Printing; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8004; Stitching; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8007; "Die Punching"; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8008; "Die Number"; Code[20])
        {
            TableRelation = "Fixed Asset"."No." WHERE (Die = FILTER (true));

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8009; Lamination; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8010; "Plate Required"; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8011; "Die Required"; Boolean)
        {

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(8012; "Printing Colour 1"; Code[10])
        {
            TableRelation = Item."No." WHERE ("Item Category Code" = CONST ('INK'));
        }
        field(8013; "Printing Colour 2"; Code[10])
        {
            TableRelation = Item."No." WHERE ("Item Category Code" = CONST ('INK'));
        }
        field(8014; "Printing Colour 3"; Code[10])
        {
            TableRelation = Item."No." WHERE ("Item Category Code" = CONST ('INK'));
        }
        field(8015; "Printing Colour 4"; Code[10])
        {
            TableRelation = Item."No." WHERE ("Item Category Code" = CONST ('INK'));
        }
        field(8016; "Printing Colour 5"; Code[10])
        {
            TableRelation = Item."No." WHERE ("Item Category Code" = CONST ('INK'));
        }
        field(8017; "Printing Colour 6"; Code[10])
        {
            TableRelation = Item."No." WHERE ("Item Category Code" = CONST ('INK'));
        }
        field(8018; "Die Number 2"; Code[20])
        {
            TableRelation = "Fixed Asset"."No." WHERE (Die = FILTER (true));

            trigger OnValidate()
            begin
                ValidateStatus;
            end;
        }
        field(9000; "Sales Quote No."; Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE ("Document Type" = CONST (Quote),
                                                        "Sell-to Customer No." = FIELD (Customer));
        }
        field(9001; "Sales Order No."; Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE ("Document Type" = CONST (Order),
                                                        "Sell-to Customer No." = FIELD (Customer));

            trigger OnValidate()
            var
                Rec_SalesHeader: Record "Sales Header";
            begin
                Rec_SalesHeader.Reset;
                Rec_SalesHeader.SetRange(Rec_SalesHeader."Document Type", Rec_SalesHeader."Document Type"::Order);
                Rec_SalesHeader.SetRange("No.", "Sales Order No.");
                if Rec_SalesHeader.FindFirst then
                    "Sales Person Code" := Rec_SalesHeader."Salesperson Code"
                else
                    "Sales Person Code" := '';
                Modify;
            end;
        }
        field(9002; "Sales Quote Line Number"; Integer)
        {
        }
        field(9004; "Sales Order Line No."; Integer)
        {
            TableRelation = "Sales Line"."Line No." WHERE ("Document Type" = CONST (Order),
                                                           "Document No." = FIELD ("Sales Order No."),
                                                           Type = CONST (Item),
                                                           "No." = FIELD ("Item Code"));
        }
        field(9005; Status; Option)
        {
            CaptionML = ENU = 'Estimate Status';
            Editable = true;
            OptionCaption = 'Open,Approved,Blocked';
            OptionMembers = Open,Approved,Blocked;
        }
        field(9006; "Production Order No."; Code[50])
        {
        }
        field(9007; "Prod. Order Exists"; Boolean)
        {
            CalcFormula = Exist ("Production Order" WHERE ("Estimate Code" = FIELD ("Product Design No.")));
            FieldClass = FlowField;
        }
        field(9008; "Bottom Linear"; Option)
        {
            OptionCaption = ' ,White,Brown';
            OptionMembers = " ",White,Brown;
        }
        field(9009; "Deep Creasing"; Boolean)
        {
        }
        field(9010; "Packing Method"; Option)
        {
            OptionCaption = ' ,Automatic , Semi Automatic , Manual';
            OptionMembers = " ","Automatic "," Semi Automatic "," Manual";
        }
        field(9011; "Pallet Size"; Text[30])
        {
        }
        field(9012; "Qty / Pallet"; Text[30])
        {
        }
        field(9013; "Ref. Sample Available"; Boolean)
        {
        }
        field(9014; "Ref. Sample Approved by Custom"; Boolean)
        {
            CaptionML = ENU = 'Ref. Sample Approved by Customer';
        }
        field(9015; "Print UCI Logo"; Boolean)
        {
        }
        field(9016; "Paper Comb."; Text[250])
        {
        }
        field(9017; "Disptach Details"; Text[250])
        {
        }
        field(9018; Remarks; Text[250])
        {
        }
        field(9019; PaperCombination; Text[200])
        {
        }
        field(9020; "Old Estimate No."; Code[20])
        {
        }
        field(9021; Calculated; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9022; "BOM Published"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9023; "Plate Item Client"; Code[20])
        {
            Editable = false;
            CaptionML = ENU = 'Plate Item Client Code';
            DataClassification = ToBeClassified;
        }
        field(9024; "Modification Remarks"; Text[250])
        {
            CaptionML = ENU = 'Modification Remarks';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Product Design Type", "Product Design No.", "Sub Comp No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // Lines added By Deepak Kumar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Product Design Delete", true);
        if not UserSetup.FindFirst then
            Error('You are not authorized to Delete the Product Design detail, Please contact your system administrator.')
        else
            TestField("Production Order No.", '');
    end;

    trigger OnInsert()
    begin
        // Lines added BY Deepak Kumar

        TestField(Status, Status::Open);

        if "Product Design No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField("Estimation No Series");
            NoSeriesMgt.InitSeries(SalesSetup."Estimation No Series", '', 0D, "Product Design No.", SalesSetup."Estimation No Series");
        end;

        "Created by" := UserId;
        "Created Date" := WorkDate;
        "Product Design Date" := WorkDate;
    end;

    var

        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Sales & Receivables Setup";
        CustomerMaster: Record Customer;
        ContactMaster: Record Contact;
        ItemMaster: Record Item;
        EstimationHeader: Record "Product Design Header";
        EstimateLine: Record "Product Design Line";
        TotalGSM: Decimal;
        ItemCard: Record Item;
        UserSetup: Record "User Setup";
        Templine: array[10] of Text[250];
        TempInte: array[10] of Integer;
        ModelMaster: Record "Product Design Model Master";
        MfgSetup: Record "Manufacturing Setup";
        TempQty: Integer;
        NewEstimateLine: Record "Product Design Line";
        TempBoxBS: Decimal;
        Sam0001: Label 'The Roll Width (mm ) %1 can not exceed the Maximum Deckle Size (mm) %2, In Line Type %3 Estimate No. %4 Sub Job %5';
        EstimationHeaderSub: Record "Product Design Header";
        EstimationHeaderMain: Record "Product Design Header";
        NoofFlute: Integer;
        Sam0002: Label 'Paper deckle size must not be greater than Machine deckle size , Paper deckle size %1  Machine deckle size %2';
        TempDeckleSize: Decimal;
        ExpectedBoxHeight: Decimal;
        ProdOrderCompLine: Record "Prod. Order Component";
        PDesignHeader: Record "Product Design Header";
        iTem: Record Item;
        LineCount: Integer;

    procedure ValidateStatus()
    var
        TempEstimate: Record "Product Design Header";
    begin
        if Status <> Status::Open then
            Error('Status must be Open, Please reopen and change');
        /*
        // Lines added by Deepak Kumar //22/07/15
        IF "Sub Job Card" = TRUE THEN BEGIN
           TempEstimate.RESET;
           TempEstimate.SETRANGE(TempEstimate."Link Code",TempEstimate."Link Code"::Box );
           TempEstimate.SETRANGE(TempEstimate."Estimation No.","Estimation No.");
           IF TempEstimate.FINDFIRST THEN BEGIN
              IF TempEstimate.Status <> TempEstimate.Status::Open THEN
                ERROR('Status must be Open, Please reopen and change');
           END;
        END;
         */

    end;

    procedure StatusApprove(EstimateNumber: Code[20])
    var
        Question: Text[250];
        Sam001: Label 'Do you want to approve the Estimate no. %1 ?';
        Sam002: Label 'Do you want to suspend the Estimate no. %1 ?';
        Answer: Boolean;
    begin
        // Lines added BY Deepak Kumar
        CalcDetail(EstimateNumber);
        if not "By Purchased Board" then
            TestField("Flute Type");
        TestField("No. of Ply");
        TestField("Pre-Press Status", "Pre-Press Status"::"Updated & Confirmed");
        TestField("Production Status", "Production Status"::"Updated & Confirmed");


        UserSetup.CheckEstimateAprrover(UserId);
        Question := Sam001;
        Answer := DIALOG.Confirm(Question, true, EstimateNumber);
        if Answer = true then begin
            EstimationHeader.Reset;
            EstimationHeader.SetRange(EstimationHeader."Product Design No.", EstimateNumber);
            if EstimationHeader.FindFirst then begin
                UpdateWeightinItem(EstimationHeader);
                EstimationHeader.Status := 1;
                EstimationHeader.Modify(false);

            end else begin
                Error('Estimate Header not Found');
            end;
        end else begin
            Message('Cancelled by User');
        end;
    end;

    procedure StatusSuspend(EstimateNumber: Code[20])
    var
        Question: Text[250];
        Answer: Boolean;
        Sam001: Label 'Do you want to approve the Estimate no. %1 ?';
        Sam002: Label 'Do you want to Block the Estimate no. %1 ?';
    begin
        // Lines added BY Deepak KUmar
        UserSetup.CheckEstimateAprrover(UserId);
        Question := Sam002;
        Answer := DIALOG.Confirm(Question, true, EstimateNumber);
        if Answer = true then begin
            EstimationHeader.Reset;
            EstimationHeader.SetRange(EstimationHeader."Product Design No.", EstimateNumber);
            if EstimationHeader.FindFirst then begin
                EstimationHeader.Status := 2;
                EstimationHeader.Modify(true);
            end else begin
                Error('Estimate Header not Found');
            end;
        end else begin
            Message('Cancelled by User');
        end;
    end;

    procedure StatusReopen(EstimateNumber: Code[20])
    var
        Question: Text[250];
        Answer: Boolean;
        Sam001: Label 'Do you want to approve the Estimate no. %1 ?';
        Sam002: Label 'Do you want to suspend the Estimate no. %1 ?';
        Sam003: Label 'Do you want to Re-Open the Estimate no. %1 ?';
    begin
        // Lines added BY Deepak KUmar
        UserSetup.CheckEstimateAprrover(UserId);
        Question := Sam003;
        Answer := DIALOG.Confirm(Question, true, EstimateNumber);
        if Answer = true then begin
            EstimationHeader.Reset;
            EstimationHeader.SetRange(EstimationHeader."Product Design No.", EstimateNumber);
            if EstimationHeader.FindFirst then begin
                EstimationHeader.Status := 0;
                EstimationHeader."Pre-Press Status" := 0;
                EstimationHeader."Production Status" := 0;
                EstimationHeader.Modify(true);
            end else begin
                Error('Estimate Header not Found');
            end;
        end else begin
            Message('Cancelled by User');
        end;
    end;

    procedure CalcDetail(EstimateNumber: Code[20])
    var
        SubEstimateHeader: Record "Product Design Header";
        SubJobAmount: Decimal;
        SubJobWeight: Decimal;
        TotalLineAmountM: Decimal;
        CompInfo: Record "Company Information";
        AttributeValue_L: Record "Attribute Value";
        Item2: Record Item;
        TempBoardQuality: Code[200];
    begin

        // Lines added By Deepak Kumar
        TotalLineAmountM := 0;
        TotalGSM := 0;
        CalculatePaperSize;
        EstimationHeaderMain.Reset;
        EstimationHeaderMain.SetRange(EstimationHeaderMain."Product Design Type", EstimationHeaderMain."Product Design Type"::Main);
        EstimationHeaderMain.SetRange(EstimationHeaderMain."Product Design No.", EstimateNumber);
        if EstimationHeaderMain.FindFirst then begin
            EstimationHeaderMain.UpdateTopColour(EstimationHeaderMain."Item Code");
            ;
            // For Update of Trim Size
            if not EstimationHeaderMain."Manual Trim" then begin
                MfgSetup.Get;
                if EstimationHeaderMain."No. of Ply" = 3 then begin
                    EstimationHeaderMain."Trim Size (mm)" := MfgSetup."Left Trim 3 Ply (cm)" + MfgSetup."Right Trim 3 Ply (cm)";
                    EstimationHeaderMain."Left Trim Size (mm)" := MfgSetup."Left Trim 3 Ply (cm)";
                    EstimationHeaderMain."Right Trim Size (mm)" := MfgSetup."Right Trim 3 Ply (cm)";
                end;
                if EstimationHeaderMain."No. of Ply" = 5 then begin
                    EstimationHeaderMain."Trim Size (mm)" := MfgSetup."Left Trim 5 Ply (cm)" + MfgSetup."Right Trim 5 Ply (cm)";
                    EstimationHeaderMain."Left Trim Size (mm)" := MfgSetup."Left Trim 5 Ply (cm)";
                    EstimationHeaderMain."Right Trim Size (mm)" := MfgSetup."Right Trim 5 Ply (cm)";
                end;
                if (EstimationHeaderMain."No. of Ply" <> 5) and (EstimationHeaderMain."No. of Ply" <> 3) then begin
                    EstimationHeaderMain."Trim Size (mm)" := 20;
                    EstimationHeaderMain."Left Trim Size (mm)" := 10;
                    EstimationHeaderMain."Right Trim Size (mm)" := 10;
                end;
            end;


            CompInfo.Get;
            EstimationHeaderMain."Margin %" := CompInfo."Estimate Margin %";
            // Lines added by Deepak Kumar 29 09 15
            EstimateLine.Reset;
            EstimateLine.SetRange(EstimateLine."Product Design Type", EstimationHeaderMain."Product Design Type");
            EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeaderMain."Product Design No.");
            EstimateLine.SetRange(EstimateLine."Sub Comp No.", EstimationHeaderMain."Sub Comp No.");
            EstimateLine.SetRange(EstimateLine."Line Type", EstimateLine."Line Type"::Paper);
            if EstimateLine.FindFirst then begin
                TempDeckleSize := 5000;
                repeat
                    if (EstimateLine."Deckle Size" < TempDeckleSize) then begin
                        TempDeckleSize := EstimateLine."Deckle Size";
                    end;
                until EstimateLine.Next = 0;
                EstimationHeaderMain."Paper Deckle Size (mm)" := TempDeckleSize;
                EstimationHeaderMain.Modify(true);
            end;

            //sadaf
            EstimationHeaderMain."Paper Comb." := EstimationHeaderMain."Flute Type" + '-' + TempBoardQuality;

            //      PLATE

            if EstimationHeaderMain."Manual Scorer" = true then begin
                EstimationHeaderMain."Board Width (mm)- W" := (EstimationHeaderMain."Scorer 1" + EstimationHeaderMain."Scorer 3" + EstimationHeaderMain."Scorer 5") + EstimationHeaderMain."Box Height (mm) - D (OD)";
            end else begin
                if (EstimationHeaderMain."Model No" = '0201') and (EstimationHeaderMain."Manual Scorer" = false) then
                    EstimationHeaderMain."Board Width (mm)- W" := (EstimationHeaderMain."Box Width (mm)- W (OD)" + EstimationHeaderMain."Box Height (mm) - D (OD)");

                if (EstimationHeaderMain."Model No" = '0200') and (EstimationHeaderMain."Manual Scorer" = false) then
                    EstimationHeaderMain."Board Width (mm)- W" := ((EstimationHeaderMain."Box Width (mm)- W (OD)" / 2) + EstimationHeaderMain."Box Height (mm) - D (OD)");

                if EstimationHeaderMain."Model No" = '0202' then
                    EstimationHeaderMain."Board Width (mm)- W" := ((EstimationHeaderMain."Box Width (mm)- W (OD)") + (EstimationHeaderMain."Box Width (mm)- W (OD)" / 2) + EstimationHeaderMain."Box Height (mm) - D (OD)");
            end;


            // Update no of ups
            if (EstimationHeaderMain."Paper Deckle Size (mm)" <> 0) and (EstimationHeaderMain."Paper Deckle Size (mm)" > EstimationHeaderMain."Machine Deckle Size (mm)") then
                Error(Sam0002, EstimationHeaderMain."Paper Deckle Size (mm)", (EstimationHeaderMain."Machine Deckle Size (mm)"));


            if (EstimationHeaderMain."Paper Deckle Size (mm)" <> 0) and (EstimationHeaderMain."Paper Deckle Size (mm)" < EstimationHeaderMain."Machine Deckle Size (mm)") then begin
                EstimationHeaderMain."Basis for No.of Up Calc" := 1;


                if (EstimationHeaderMain."Board Width (mm)- W" + EstimationHeaderMain."Trim Size (mm)") > EstimationHeaderMain."Paper Deckle Size (mm)" then
                    Error('Board Width (mm)" must be smallar than Paper Deckle Size');

                EstimationHeaderMain."Board Ups" := Round((((EstimationHeaderMain."Paper Deckle Size (mm)") - EstimationHeaderMain."Trim Size (mm)") / (EstimationHeaderMain."Board Width (mm)- W")), 1, '<');
            end else begin
                EstimationHeaderMain."Basis for No.of Up Calc" := 0;

                if (EstimationHeaderMain."Board Width (mm)- W" + EstimationHeaderMain."Trim Size (mm)") > EstimationHeaderMain."Machine Deckle Size (mm)" then
                    Error('Board Width (mm)" must be smallar than Machine Deckle Size');

                EstimationHeaderMain."Board Ups" := Round((((EstimationHeaderMain."Machine Deckle Size (mm)") - EstimationHeaderMain."Trim Size (mm)") / EstimationHeaderMain."Board Width (mm)- W"), 1, '<');

            end;

            if EstimationHeaderMain."Board Ups" > EstimationHeaderMain."Machine Maximum Deckle Ups" then
                EstimationHeaderMain."Board Ups" := EstimationHeaderMain."Machine Maximum Deckle Ups";
            EstimationHeaderMain.Validate("Board Ups");
            EstimationHeaderMain.Modify(true);



            // Regular Slotted Container (RSC)
            if EstimationHeaderMain."Model No" = '0201' then begin
                EstimationHeaderMain."Roll Width (mm)" := ((EstimationHeaderMain."Box Width (mm)- W (OD)" + EstimationHeaderMain."Box Height (mm) - D (OD)") * EstimationHeaderMain."Board Ups")
                    + EstimationHeaderMain."Trim Size (mm)";
                EstimationHeaderMain."Cut Size (mm)" := ((2 * (EstimationHeaderMain."Box Length (mm)- L (OD)" + EstimationHeaderMain."Box Width (mm)- W (OD)")) / "No. of Joint") + EstimationHeaderMain."Joint Flap Size(mm)";
                EstimationHeaderMain."Board Length (mm)- L" := ((2 * (EstimationHeaderMain."Box Length (mm)- L (OD)" + EstimationHeaderMain."Box Width (mm)- W (OD)")) / "No. of Joint") + EstimationHeaderMain."Joint Flap Size(mm)";
                EstimationHeaderMain."Board Width (mm)- W" := (EstimationHeaderMain."Box Width (mm)- W (OD)" + EstimationHeaderMain."Box Height (mm) - D (OD)");
                if EstimationHeaderMain."With Flap Gap" = true then begin
                    EstimationHeaderMain."Board Width (mm)- W" := EstimationHeaderMain."Board Width (mm)- W" - EstimationHeaderMain."Flap Gap Size(mm)";

                    EstimationHeaderMain."Roll Width (mm)" := (EstimationHeaderMain."Board Width (mm)- W" * EstimationHeaderMain."Board Ups") + EstimationHeaderMain."Trim Size (mm)";

                end;
                // Lines Added for Update Scorar
                if not EstimationHeaderMain."Manual Scorer" then begin
                    EstimationHeaderMain."Scorer 1" := EstimationHeaderMain."Box Width (mm)- W (OD)" / 2;
                    EstimationHeaderMain."Scorer 2" := EstimationHeaderMain."Box Height (mm) - D (OD)";
                    EstimationHeaderMain."Scorer 3" := EstimationHeaderMain."Box Width (mm)- W (OD)" / 2;
                end else begin
                    // IF (EstimationHeaderMain."Scorer 1" +  EstimationHeaderMain."Scorer 3" + EstimationHeaderMain."Scorer 5" ) <> EstimationHeaderMain."Box Width (mm)- W (OD)"  THEN
                    EstimationHeaderMain."Board Width (mm)- W" := (EstimationHeaderMain."Scorer 1" + EstimationHeaderMain."Scorer 3" + EstimationHeaderMain."Scorer 5") + EstimationHeaderMain."Box Height (mm) - D (OD)";
                    EstimationHeaderMain."Roll Width (mm)" := (EstimationHeaderMain."Board Width (mm)- W" * EstimationHeaderMain."Board Ups") + EstimationHeaderMain."Trim Size (mm)";
                end;

            end;


            if not (EstimationHeaderMain."Model No" = '0201') or (EstimationHeaderMain."Model No" = '0200') or
              (EstimationHeaderMain."Model No" = '0900') or (EstimationHeaderMain."Model No" = '0202') then begin
                EstimationHeaderMain."Roll Width (mm)" := (EstimationHeaderMain."Board Width (mm)- W" * EstimationHeaderMain."Board Ups") + EstimationHeaderMain."Trim Size (mm)";
                EstimationHeaderMain."Cut Size (mm)" := EstimationHeaderMain."Board Length (mm)- L";
            end;


            //Half Slotted Container (HSC) 0200
            if EstimationHeaderMain."Model No" = '0200' then begin
                EstimationHeaderMain."Roll Width (mm)" := (((EstimationHeaderMain."Box Width (mm)- W (OD)" / 2) + EstimationHeaderMain."Box Height (mm) - D (OD)") * EstimationHeaderMain."Board Ups")
                    + EstimationHeaderMain."Trim Size (mm)";
                EstimationHeaderMain."Cut Size (mm)" := ((2 * (EstimationHeaderMain."Box Length (mm)- L (OD)" + EstimationHeaderMain."Box Width (mm)- W (OD)")) / EstimationHeaderMain."No. of Joint") + EstimationHeaderMain."Joint Flap Size(mm)";
                EstimationHeaderMain."Board Length (mm)- L" := ((2 * (EstimationHeaderMain."Box Length (mm)- L (OD)" + EstimationHeaderMain."Box Width (mm)- W (OD)")) / EstimationHeaderMain."No. of Joint") + EstimationHeaderMain."Joint Flap Size(mm)";
                EstimationHeaderMain."Board Width (mm)- W" := ((EstimationHeaderMain."Box Width (mm)- W (OD)" / 2) + EstimationHeaderMain."Box Height (mm) - D (OD)");
                if EstimationHeaderMain."With Flap Gap" = true then begin
                    EstimationHeaderMain."Board Width (mm)- W" := EstimationHeaderMain."Board Width (mm)- W" - EstimationHeaderMain."Flap Gap Size(mm)";
                    EstimationHeaderMain."Roll Width (mm)" := (EstimationHeaderMain."Board Width (mm)- W" * EstimationHeaderMain."Board Ups")
                        + EstimationHeaderMain."Trim Size (mm)";
                end;
                // Lines for Update Scorar
                if not EstimationHeaderMain."Manual Scorer" then begin
                    EstimationHeaderMain."Scorer 1" := EstimationHeaderMain."Box Width (mm)- W (OD)" / 2;
                    EstimationHeaderMain."Scorer 2" := EstimationHeaderMain."Box Height (mm) - D (OD)";
                end else begin
                    // IF (EstimationHeaderMain."Scorer 1" +  EstimationHeaderMain."Scorer 3" + EstimationHeaderMain."Scorer 5" ) <> EstimationHeaderMain."Box Width (mm)- W (OD)"  THEN
                    EstimationHeaderMain."Board Width (mm)- W" := (EstimationHeaderMain."Scorer 1" + EstimationHeaderMain."Scorer 3" + EstimationHeaderMain."Scorer 5") + EstimationHeaderMain."Box Height (mm) - D (OD)";
                    EstimationHeaderMain."Roll Width (mm)" := (EstimationHeaderMain."Board Width (mm)- W" * EstimationHeaderMain."Board Ups") + EstimationHeaderMain."Trim Size (mm)";
                end;
                EstimationHeaderMain.Modify(true);
            end;
            //Overlap Slotted Container (OSC)
            if EstimationHeaderMain."Model No" = '0202' then begin
                EstimationHeaderMain."Roll Width (mm)" := ((EstimationHeaderMain."Box Width (mm)- W (OD)" + EstimationHeaderMain."Box Height (mm) - D (OD)") * EstimationHeaderMain."Board Ups")
                    + EstimationHeaderMain."Trim Size (mm)";
                EstimationHeaderMain."Cut Size (mm)" := ((2 * (EstimationHeaderMain."Box Length (mm)- L (OD)" + EstimationHeaderMain."Box Width (mm)- W (OD)")) / EstimationHeaderMain."No. of Joint") + EstimationHeaderMain."Joint Flap Size(mm)";
                EstimationHeaderMain."Board Length (mm)- L" := ((2 * (EstimationHeaderMain."Box Length (mm)- L (OD)" + EstimationHeaderMain."Box Width (mm)- W (OD)")) / EstimationHeaderMain."No. of Joint") + EstimationHeaderMain."Joint Flap Size(mm)";
                EstimationHeaderMain."Board Width (mm)- W" := ((EstimationHeaderMain."Box Width (mm)- W (OD)") + (EstimationHeaderMain."Box Width (mm)- W (OD)" / 2) + EstimationHeaderMain."Box Height (mm) - D (OD)");
                if EstimationHeaderMain."With Flap Gap" = true then begin
                    EstimationHeaderMain."Board Width (mm)- W" := EstimationHeaderMain."Board Width (mm)- W" - EstimationHeaderMain."Flap Gap Size(mm)";
                    EstimationHeaderMain."Roll Width (mm)" := (EstimationHeaderMain."Board Width (mm)- W" * EstimationHeaderMain."Board Ups") + EstimationHeaderMain."Trim Size (mm)";
                end;
                if EstimationHeaderMain."Manual Scorer" then begin
                    // IF (EstimationHeaderMain."Scorer 1" +  EstimationHeaderMain."Scorer 3" + EstimationHeaderMain."Scorer 5" ) <> EstimationHeaderMain."Box Width (mm)- W (OD)"  THEN
                    EstimationHeaderMain."Board Width (mm)- W" := (EstimationHeaderMain."Scorer 1" + EstimationHeaderMain."Scorer 3" + EstimationHeaderMain."Scorer 5") + EstimationHeaderMain."Box Height (mm) - D (OD)";
                    EstimationHeaderMain."Roll Width (mm)" := (EstimationHeaderMain."Board Width (mm)- W" * EstimationHeaderMain."Board Ups") + EstimationHeaderMain."Trim Size (mm)";
                end;

            end;
            if EstimationHeaderMain."Model No" = '0900' then begin
                if EstimationHeaderMain."Corrugation Direction" = EstimationHeaderMain."Corrugation Direction"::"Length Wise" then begin
                    EstimationHeaderMain."Roll Width (mm)" := (EstimationHeaderMain."Board Length (mm)- L" * EstimationHeaderMain."Board Ups")
                        + EstimationHeaderMain."Trim Size (mm)";
                    EstimationHeaderMain."Cut Size (mm)" := (EstimationHeaderMain."Board Width (mm)- W");
                end else begin
                    EstimationHeaderMain."Roll Width (mm)" := ((EstimationHeaderMain."Board Width (mm)- W") * EstimationHeaderMain."Board Ups")
                        + EstimationHeaderMain."Trim Size (mm)";
                    EstimationHeaderMain."Cut Size (mm)" := (EstimationHeaderMain."Board Length (mm)- L");
                end;
            end;
            // Lines for Update Linear Length
            EstimationHeaderMain."Linear Length Qty Per" := (EstimationHeaderMain."Cut Size (mm)" / 1000) / EstimationHeaderMain."Board Ups";
            EstimationHeaderMain."Linear Length" := ((EstimationHeaderMain."Cut Size (mm)" * EstimationHeaderMain.Quantity) / 1000) / EstimationHeaderMain."Board Ups";
            MfgSetup.Get;

            if EstimationHeaderMain."Roll Width (mm)" > (EstimationHeaderMain."Machine Deckle Size (mm)") then
                Error('The Roll Width (mm ) %1 can not exceed the Maximum Deckle Size (mm) %2', EstimationHeaderMain."Roll Width (mm)", (EstimationHeaderMain."Machine Deckle Size (mm)"));

            EstimationHeaderMain.Validate(EstimationHeaderMain."Box Length (mm)- L (OD)");
            EstimationHeaderMain.Validate(EstimationHeaderMain."Box Width (mm)- W (OD)");
            EstimationHeaderMain.Validate(EstimationHeaderMain."Box Height (mm) - D (OD)");
            EstimationHeaderMain.Validate(EstimationHeaderMain."Board Length (mm)- L");
            EstimationHeaderMain.Validate(EstimationHeaderMain."Board Width (mm)- W");
            EstimationHeaderMain.Validate(EstimationHeaderMain."Roll Width (mm)");
            EstimationHeaderMain.Validate(EstimationHeaderMain."Cut Size (mm)");
            EstimationHeaderMain.Modify(true);


            EstimateLine.Reset;
            EstimateLine.SetRange(EstimateLine."Product Design Type", EstimateLine."Product Design Type"::Main);
            EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeaderMain."Product Design No.");
            EstimateLine.SetRange(EstimateLine."Line Type", EstimateLine."Line Type"::Paper);
            if EstimateLine.FindFirst then begin
                MfgSetup.Get;
                repeat
                    EstimateLine."Paper Weight (gms)" := ((EstimationHeaderMain."Paper Deckle Size (mm)" / EstimationHeaderMain."Board Ups") * EstimationHeaderMain."Board Length (mm)- L"
                                                        * EstimateLine.GSM * EstimateLine."Take Up" * 1.02 * EstimationHeaderMain.Quantity) / 1000000000;

                    EstimateLine.Quantity := EstimateLine."Paper Weight (gms)";
                    //Mpower
                    /*EstimateLine."Paper Weight (gms)":=((EstimationHeaderMain."Roll Width (mm)" * (EstimationHeaderMain."Cut Size (mm)"*"No. of Joint")
                                                          * EstimateLine.GSM * MfgSetup."Scrap % for Estimation" *EstimateLine."Take Up"))
                                                            /(1000000);*/
                    //Deepak 210915 for update paper required in Mtr
                    EstimateLine."Paper Required in Mtr" := (EstimationHeaderMain.Quantity * EstimationHeaderMain."Cut Size (mm)" * EstimateLine."Take Up") / 1000;



                    if (EstimateLine."Paper Position" = EstimateLine."Paper Position"::Liner1) or (EstimateLine."Paper Position" = EstimateLine."Paper Position"::Liner2)
                    or (EstimateLine."Paper Position" = EstimateLine."Paper Position"::Liner3) or (EstimateLine."Paper Position" = EstimateLine."Paper Position"::Liner4) then begin
                        EstimateLine."Paper Bursting Strength(BS)" := (EstimateLine.GSM * EstimateLine."Bursting factor(BF)") / 1000;
                    end else begin
                        EstimateLine."Paper Bursting Strength(BS)" := (EstimateLine.GSM * EstimateLine."Bursting factor(BF)") / 1000 / 2;
                    end;

                    /* IF EstimationHeaderMain."Board Ups" > 0 THEN BEGIN
                      EstimateLine.Quantity:=((EstimateLine."Paper Weight (gms)"*(EstimationHeaderMain.Quantity/(EstimationHeaderMain."Board Ups")))/1000);
                     END ELSE
                      EstimateLine.Quantity:=((EstimateLine."Paper Weight (gms)"*(EstimationHeaderMain.Quantity))/1000); */

                    if EstimationHeaderMain."No. of Die Cut Ups" > 0 then
                        EstimateLine.Quantity := EstimateLine.Quantity / EstimationHeaderMain."No. of Die Cut Ups";

                    EstimateLine."Paper Required KG" := EstimateLine."Paper Weight (gms)" / 1000;

                    EstimateLine.Validate(EstimateLine.Quantity);
                    EstimateLine.Modify(true);
                until EstimateLine.Next = 0;
            end;
            EstimationHeaderMain.Grammage := 0;
            EstimateLine.Reset;
            EstimateLine.SetRange(EstimateLine."Product Design Type", EstimateLine."Product Design Type"::Main);
            EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeaderMain."Product Design No.");
            if EstimateLine.FindFirst then begin
                repeat
                    TotalLineAmountM := TotalLineAmountM + EstimateLine."Line Amount";
                    TotalGSM := TotalGSM + EstimateLine."Paper Weight (gms)";
                    EstimationHeaderMain.Grammage := EstimationHeaderMain.Grammage + (EstimateLine.GSM * EstimateLine."Take Up");
                until EstimateLine.Next = 0;
            end;
            EstimationHeaderMain.Modify(true);
            //

            // Lines added BY Deepak Kumar for Update BS and LBS
            TempBoxBS := 0;
            NewEstimateLine.Reset;
            NewEstimateLine.SetRange(NewEstimateLine."Product Design Type", EstimationHeaderMain."Product Design Type");
            NewEstimateLine.SetRange(NewEstimateLine."Product Design No.", EstimationHeaderMain."Product Design No.");
            if NewEstimateLine.FindFirst then begin
                repeat
                    TempBoxBS := TempBoxBS + NewEstimateLine."Paper Bursting Strength(BS)";
                until NewEstimateLine.Next = 0;
                EstimationHeaderMain."Box BS" := TempBoxBS;
                EstimationHeaderMain."Box LBS" := TempBoxBS * 14.285;
            end;
            CalSubJobDetail(EstimateNumber);// To Calculate the Sub Job Calc
            SubJobAmount := 0;
            SubJobWeight := 0;
            SubEstimateHeader.Reset;
            SubEstimateHeader.SetRange(SubEstimateHeader."Product Design Type", SubEstimateHeader."Product Design Type"::Sub);
            SubEstimateHeader.SetRange(SubEstimateHeader."Product Design No.", EstimationHeaderMain."Product Design No.");
            if SubEstimateHeader.FindFirst then begin
                repeat
                    SubJobAmount := SubJobAmount + SubEstimateHeader."Line Amount";
                    SubJobWeight := SubJobWeight + (SubEstimateHeader."Per Box Weight (Gms)" * SubEstimateHeader."Quantity Per FG");

                until SubEstimateHeader.Next = 0;
            end;
            EstimationHeaderMain."Box Amount per Unit" := TotalLineAmountM / EstimationHeaderMain.Quantity;
            TotalLineAmountM := TotalLineAmountM + EstimationHeaderMain."Die Making Charges" + EstimationHeaderMain."Plate Making Charges" + EstimationHeaderMain."Other Charges" + SubJobAmount;
            EstimationHeaderMain."Line Amount" := TotalLineAmountM;


            //********* Margin Calculation
            if EstimationHeaderMain."Margin %" <> 0 then begin
                EstimationHeaderMain."Total Amount" := TotalLineAmountM + (TotalLineAmountM * EstimationHeaderMain."Margin %" / 100);
                EstimationHeaderMain."Margin Amount" := (TotalLineAmountM * EstimationHeaderMain."Margin %" / 100);
            end;

            if (EstimationHeaderMain."Sales Price (Per Unit)" <> 0) then begin
                EstimationHeaderMain."Margin Amount" := (EstimationHeaderMain."Sales Price (Per Unit)" * EstimationHeaderMain.Quantity) - (EstimationHeaderMain."Line Amount");
            end;

            if EstimationHeaderMain."Margin Amount" <> 0 then begin
                EstimationHeaderMain."Total Amount" := TotalLineAmountM + EstimationHeaderMain."Margin Amount";
                EstimationHeaderMain."Margin %" := (EstimationHeaderMain."Margin Amount" / TotalLineAmountM) * 100;
            end;

            if (EstimationHeaderMain."Margin Amount" = 0) and (EstimationHeaderMain."Margin %" = 0) then begin
                EstimationHeaderMain."Total Amount" := TotalLineAmountM;
            end;
            EstimationHeaderMain.Modify(true);
            //********* Margin Calculation//End;
            // Lines added For Glue calculation
            MfgSetup.Get;
            EstimationHeaderMain."Per Box Weight (Gms)" := (((EstimationHeaderMain."Board Length (mm)- L" * EstimationHeaderMain."Board Width (mm)- W" * EstimationHeaderMain.Grammage * MfgSetup."Scrap % for Estimation") /
            EstimationHeaderMain."No. of Die Cut Ups") * EstimationHeaderMain."No. of Joint") / (1000000); //Suhail

            EstimateLine.Reset;
            EstimateLine.SetRange(EstimateLine."Product Design Type", EstimateLine."Product Design Type"::Main);
            EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeaderMain."Product Design No.");
            EstimateLine.SetRange(EstimateLine."Line Type", EstimateLine."Line Type"::Glue);
            if EstimateLine.FindFirst then begin
                repeat
                    SalesSetup.Get;
                    SalesSetup.TestField(SalesSetup."Starch Calculation");
                    EstimateLine.Validate(Quantity, EstimationHeaderMain."Per Box Weight (Gms)" * (SalesSetup."Starch Calculation" / 100));
                    EstimateLine.Modify(true);
                until EstimateLine.Next = 0;
            end;

            if EstimationHeaderMain."Per Box Weight (Gms)" = 0 then
                EstimationHeaderMain."Per Box Weight (Gms)" := 1;

            EstimationHeaderMain."Per Box Weight with Comp(Gms)" := EstimationHeaderMain."Per Box Weight (Gms)" + SubJobWeight;
            EstimationHeaderMain."Total Weight for Est. Qty (Kg)" := (EstimationHeaderMain."Per Box Weight (Gms)" * EstimationHeaderMain.Quantity) / 1000;
            EstimationHeaderMain."Amount Per KG" := EstimationHeaderMain."Total Amount" / EstimationHeaderMain."Total Weight for Est. Qty (Kg)";
            EstimationHeaderMain."Amount Per Unit" := EstimationHeaderMain."Total Amount" / EstimationHeaderMain.Quantity;

            EstimationHeaderMain.Calculated := TRUE;
            EstimationHeaderMain.Modify(true);
            Message('Complete Total Amount %1 Per Unit Amount %2 ', Round(EstimationHeaderMain."Total Amount", 0.01), Round(EstimationHeaderMain."Amount Per Unit", 0.01));

            UpdateBoxSizeandFlute(EstimationHeaderMain."Product Design Type", EstimationHeaderMain."Product Design No.", EstimationHeaderMain."Sub Comp No.");

            UpdateGSMIdentifier(EstimationHeaderMain."Product Design No.");
        end;

    end;

    procedure CalSubJobDetail(EstimateNumber: Code[50])
    var
        TempLineAmount: Decimal;
        TempGrammage: Decimal;
        TotalLineAmount: Decimal;
    begin
        CalculatePaperSize;
        // Lines added by Deepak Kumar
        EstimationHeaderSub.Reset;
        EstimationHeaderSub.SetRange(EstimationHeaderSub."Product Design Type", EstimationHeaderSub."Product Design Type"::Sub);
        EstimationHeaderSub.SetRange(EstimationHeaderSub."Product Design No.", EstimateNumber);
        if EstimationHeaderSub.FindFirst then begin
            repeat
                //   EstimationHeaderSub.UpdateTopColour(EstimationHeaderSub."Item Code"); commented by Deepak // as UCIL Manual Colour 22/02/16

                // For Update of Trim Size
                if not EstimationHeaderSub."Manual Trim" then begin
                    MfgSetup.Get;
                    if EstimationHeaderSub."No. of Ply" = 3 then begin
                        EstimationHeaderSub."Trim Size (mm)" := MfgSetup."Left Trim 3 Ply (cm)" + MfgSetup."Right Trim 3 Ply (cm)";
                        EstimationHeaderSub."Left Trim Size (mm)" := MfgSetup."Left Trim 3 Ply (cm)";
                        EstimationHeaderSub."Right Trim Size (mm)" := MfgSetup."Right Trim 3 Ply (cm)";
                    end;
                    if EstimationHeaderSub."No. of Ply" = 5 then begin
                        EstimationHeaderSub."Trim Size (mm)" := MfgSetup."Left Trim 5 Ply (cm)" + MfgSetup."Right Trim 5 Ply (cm)";
                        EstimationHeaderSub."Left Trim Size (mm)" := MfgSetup."Left Trim 5 Ply (cm)";
                        EstimationHeaderSub."Right Trim Size (mm)" := MfgSetup."Right Trim 5 Ply (cm)";
                    end;
                    if (EstimationHeaderSub."No. of Ply" <> 5) and (EstimationHeaderSub."No. of Ply" <> 3) then begin
                        EstimationHeaderSub."Trim Size (mm)" := 20;
                        EstimationHeaderSub."Left Trim Size (mm)" := 10;
                        EstimationHeaderSub."Right Trim Size (mm)" := 10;
                    end;
                end;



                // Lines added BY Deepak Kumar
                EstimateLine.Reset;
                EstimateLine.SetRange(EstimateLine."Product Design Type", EstimationHeaderSub."Product Design Type");
                EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeaderSub."Product Design No.");
                EstimateLine.SetRange(EstimateLine."Sub Comp No.", EstimationHeaderSub."Sub Comp No.");
                EstimateLine.SetRange(EstimateLine."Line Type", EstimateLine."Line Type"::Paper);
                if EstimateLine.FindFirst then begin
                    TempDeckleSize := 5000;
                    repeat
                        if (EstimateLine."Deckle Size" < TempDeckleSize) then begin
                            TempDeckleSize := EstimateLine."Deckle Size";
                        end;
                    until EstimateLine.Next = 0;
                    EstimationHeaderSub."Paper Deckle Size (mm)" := TempDeckleSize;
                    EstimationHeaderSub.Modify(true);
                end;

                if EstimationHeaderSub."Manual Scorer" = true then begin
                    EstimationHeaderSub."Board Width (mm)- W" := (EstimationHeaderSub."Scorer 1" + EstimationHeaderSub."Scorer 3" + EstimationHeaderSub."Scorer 5") + EstimationHeaderSub."Box Height (mm) - D (OD)";
                end else begin
                    if EstimationHeaderSub."Model No" = '0201' then
                        EstimationHeaderSub."Board Width (mm)- W" := (EstimationHeaderSub."Box Width (mm)- W (OD)" + EstimationHeaderSub."Box Height (mm) - D (OD)");

                    if EstimationHeaderSub."Model No" = '0200' then
                        EstimationHeaderSub."Board Width (mm)- W" := ((EstimationHeaderSub."Box Width (mm)- W (OD)" / 2) + EstimationHeaderSub."Box Height (mm) - D (OD)");

                    if EstimationHeaderSub."Model No" = '0202' then
                        EstimationHeaderSub."Board Width (mm)- W" := ((EstimationHeaderSub."Box Width (mm)- W (OD)") + (EstimationHeaderSub."Box Width (mm)- W (OD)" / 2) + EstimationHeaderSub."Box Height (mm) - D (OD)");

                end;





                // Update no of ups
                if (EstimationHeaderSub."Paper Deckle Size (mm)" <> 0) and (EstimationHeaderSub."Paper Deckle Size (mm)" > EstimationHeaderSub."Machine Deckle Size (mm)") then
                    Error(Sam0002, EstimationHeaderSub."Paper Deckle Size (mm)", EstimationHeaderSub."Machine Deckle Size (mm)");

                if (EstimationHeaderSub."Paper Deckle Size (mm)" <> 0) and (EstimationHeaderSub."Paper Deckle Size (mm)" < EstimationHeaderSub."Machine Deckle Size (mm)") then begin
                    EstimationHeaderSub."Basis for No.of Up Calc" := 1;
                    if (EstimationHeaderSub."Board Width (mm)- W" + EstimationHeaderSub."Trim Size (mm)") > EstimationHeaderSub."Paper Deckle Size (mm)" then
                        Error('Board Width (mm)" must be smallar than Paper Deckle Size');
                    EstimationHeaderSub."Board Ups" := Round(((EstimationHeaderSub."Paper Deckle Size (mm)" - EstimationHeaderSub."Trim Size (mm)") / EstimationHeaderSub."Board Width (mm)- W"), 1, '<');

                end else begin
                    EstimationHeaderSub."Basis for No.of Up Calc" := 0;
                    if (EstimationHeaderSub."Board Width (mm)- W" + EstimationHeaderSub."Trim Size (mm)") > EstimationHeaderSub."Machine Deckle Size (mm)" then
                        Error('Board Width (mm)" must be smallar than Machine Deckle Size');
                    EstimationHeaderSub."Board Ups" := Round((((EstimationHeaderSub."Machine Deckle Size (mm)") - EstimationHeaderSub."Trim Size (mm)") / EstimationHeaderSub."Board Width (mm)- W"), 1, '<');


                end;
                if EstimationHeaderSub."Board Ups" > EstimationHeaderSub."Machine Maximum Deckle Ups" then
                    EstimationHeaderSub."Board Ups" := EstimationHeaderSub."Machine Maximum Deckle Ups";
                EstimationHeaderSub.Validate("Board Ups");
                EstimationHeaderSub.Modify(true);


                TotalLineAmount := 0;
                // Regular Slotted Container (RSC)
                if EstimationHeaderSub."Model No" = '0201' then begin
                    EstimationHeaderSub."Roll Width (mm)" := ((EstimationHeaderSub."Box Width (mm)- W (OD)" + EstimationHeaderSub."Box Height (mm) - D (OD)") * EstimationHeaderSub."Board Ups")
                        + EstimationHeaderSub."Trim Size (mm)";
                    EstimationHeaderSub."Cut Size (mm)" := ((2 * (EstimationHeaderSub."Box Length (mm)- L (OD)" + EstimationHeaderSub."Box Width (mm)- W (OD)")) / "No. of Joint") + EstimationHeaderSub."Joint Flap Size(mm)";
                    EstimationHeaderSub."Board Length (mm)- L" := ((2 * (EstimationHeaderSub."Box Length (mm)- L (OD)" + EstimationHeaderSub."Box Width (mm)- W (OD)")) / "No. of Joint") + EstimationHeaderSub."Joint Flap Size(mm)";
                    EstimationHeaderSub."Board Width (mm)- W" := (EstimationHeaderSub."Box Width (mm)- W (OD)" + EstimationHeaderSub."Box Height (mm) - D (OD)");
                    if EstimationHeaderSub."With Flap Gap" = true then begin
                        EstimationHeaderSub."Board Width (mm)- W" := EstimationHeaderSub."Board Width (mm)- W" - EstimationHeaderSub."Flap Gap Size(mm)";
                        EstimationHeaderSub."Roll Width (mm)" := (EstimationHeaderSub."Board Width (mm)- W" * EstimationHeaderSub."Board Ups") + EstimationHeaderSub."Trim Size (mm)";
                    end;
                    // Lines Added for Update Scorar
                    if not EstimationHeaderSub."Manual Scorer" then begin
                        EstimationHeaderSub."Scorer 1" := EstimationHeaderSub."Box Width (mm)- W (OD)" / 2;
                        EstimationHeaderSub."Scorer 2" := EstimationHeaderSub."Box Height (mm) - D (OD)";
                        EstimationHeaderSub."Scorer 3" := EstimationHeaderSub."Box Width (mm)- W (OD)" / 2;
                    end else begin
                        //IF (EstimationHeaderSub."Scorer 1" + EstimationHeaderSub."Scorer 3" + EstimationHeaderSub."Scorer 5") <> EstimationHeaderSub."Box Width (mm)- W (OD)"  THEN
                        EstimationHeaderSub."Board Width (mm)- W" := (EstimationHeaderSub."Scorer 1" + EstimationHeaderSub."Scorer 3" + EstimationHeaderSub."Scorer 5") + EstimationHeaderSub."Box Height (mm) - D (OD)";
                        EstimationHeaderSub."Roll Width (mm)" := (EstimationHeaderSub."Board Width (mm)- W" * EstimationHeaderSub."Board Ups") + EstimationHeaderSub."Trim Size (mm)";
                    end;
                end;


                if not (EstimationHeaderSub."Model No" = '0201') or (EstimationHeaderSub."Model No" = '0200') or
                (EstimationHeaderSub."Model No" = '0202') or (EstimationHeaderSub."Model No" = '0900') then begin
                    EstimationHeaderSub."Roll Width (mm)" := (EstimationHeaderSub."Board Width (mm)- W" * EstimationHeaderSub."Board Ups") + EstimationHeaderSub."Trim Size (mm)";
                    EstimationHeaderSub."Cut Size (mm)" := EstimationHeaderSub."Board Length (mm)- L";
                end;


                //Half Slotted Container (HSC) 0200
                if EstimationHeaderSub."Model No" = '0200' then begin
                    EstimationHeaderSub."Roll Width (mm)" := (((EstimationHeaderSub."Box Width (mm)- W (OD)" / 2) + EstimationHeaderSub."Box Height (mm) - D (OD)") * EstimationHeaderSub."Board Ups")
                        + EstimationHeaderSub."Trim Size (mm)";
                    EstimationHeaderSub."Cut Size (mm)" := ((2 * (EstimationHeaderSub."Box Length (mm)- L (OD)" + EstimationHeaderSub."Box Width (mm)- W (OD)")) / EstimationHeaderSub."No. of Joint") + EstimationHeaderSub."Joint Flap Size(mm)";
                    EstimationHeaderSub."Board Length (mm)- L" := ((2 * (EstimationHeaderSub."Box Length (mm)- L (OD)" + EstimationHeaderSub."Box Width (mm)- W (OD)")) / EstimationHeaderSub."No. of Joint") + EstimationHeaderSub."Joint Flap Size(mm)";
                    EstimationHeaderSub."Board Width (mm)- W" := ((EstimationHeaderSub."Box Width (mm)- W (OD)" / 2) + EstimationHeaderSub."Box Height (mm) - D (OD)");
                    if EstimationHeaderSub."With Flap Gap" = true then begin
                        EstimationHeaderSub."Board Width (mm)- W" := EstimationHeaderSub."Board Width (mm)- W" - EstimationHeaderSub."Flap Gap Size(mm)";
                        EstimationHeaderSub."Roll Width (mm)" := (EstimationHeaderSub."Board Width (mm)- W" * EstimationHeaderSub."Board Ups") + EstimationHeaderSub."Trim Size (mm)";

                    end;
                    // Lines Added for Update Scorar
                    if not EstimationHeaderSub."Manual Scorer" then begin
                        EstimationHeaderSub."Scorer 1" := EstimationHeaderSub."Box Width (mm)- W (OD)" / 2;
                        EstimationHeaderSub."Scorer 2" := EstimationHeaderSub."Box Height (mm) - D (OD)";
                    end else begin
                        // IF (EstimationHeaderSub."Scorer 1" + EstimationHeaderSub."Scorer 3" + EstimationHeaderSub."Scorer 5") <> EstimationHeaderSub."Box Width (mm)- W (OD)"  THEN
                        EstimationHeaderSub."Board Width (mm)- W" := (EstimationHeaderSub."Scorer 1" + EstimationHeaderSub."Scorer 3" + EstimationHeaderSub."Scorer 5") + EstimationHeaderSub."Box Height (mm) - D (OD)";
                        EstimationHeaderSub."Roll Width (mm)" := (EstimationHeaderSub."Board Width (mm)- W" * EstimationHeaderSub."Board Ups") + EstimationHeaderSub."Trim Size (mm)";

                    end;


                end;
                //Overlap Slotted Container (OSC)
                if EstimationHeaderSub."Model No" = '0202' then begin
                    EstimationHeaderSub."Roll Width (mm)" := ((EstimationHeaderSub."Box Width (mm)- W (OD)" + EstimationHeaderSub."Box Height (mm) - D (OD)") * EstimationHeaderSub."Board Ups")
                        + EstimationHeaderSub."Trim Size (mm)";
                    EstimationHeaderSub."Cut Size (mm)" := ((2 * (EstimationHeaderSub."Box Length (mm)- L (OD)" + EstimationHeaderSub."Box Width (mm)- W (OD)")) / EstimationHeaderSub."No. of Joint") + EstimationHeaderSub."Joint Flap Size(mm)";
                    EstimationHeaderSub."Board Length (mm)- L" := ((2 * (EstimationHeaderSub."Box Length (mm)- L (OD)" + EstimationHeaderSub."Box Width (mm)- W (OD)")) / EstimationHeaderSub."No. of Joint") + EstimationHeaderSub."Joint Flap Size(mm)";
                    EstimationHeaderSub."Board Width (mm)- W" := ((EstimationHeaderSub."Box Width (mm)- W (OD)") + (EstimationHeaderSub."Box Width (mm)- W (OD)" / 2) + EstimationHeaderSub."Box Height (mm) - D (OD)");
                    if EstimationHeaderSub."With Flap Gap" = true then begin
                        EstimationHeaderSub."Board Width (mm)- W" := EstimationHeaderSub."Board Width (mm)- W" - EstimationHeaderSub."Flap Gap Size(mm)";
                        EstimationHeaderSub."Roll Width (mm)" := (EstimationHeaderSub."Board Width (mm)- W" * EstimationHeaderSub."Board Ups") + EstimationHeaderSub."Trim Size (mm)";
                    end;
                    if EstimationHeaderSub."Manual Scorer" then begin
                        if (EstimationHeaderSub."Scorer 1" + EstimationHeaderSub."Scorer 3" + EstimationHeaderSub."Scorer 5") <> EstimationHeaderSub."Box Width (mm)- W (OD)" then
                            EstimationHeaderSub."Box Width (mm)- W (OD)" := (EstimationHeaderSub."Scorer 1" + EstimationHeaderSub."Scorer 3" + EstimationHeaderSub."Scorer 5") + EstimationHeaderSub."Box Height (mm) - D (OD)";
                        EstimationHeaderSub."Roll Width (mm)" := (EstimationHeaderSub."Board Width (mm)- W" * EstimationHeaderSub."Board Ups") + EstimationHeaderSub."Trim Size (mm)";
                    end;


                end;

                if EstimationHeaderSub."Model No" = '0900' then begin
                    if EstimationHeaderSub."Corrugation Direction" = EstimationHeaderSub."Corrugation Direction"::"Length Wise" then begin

                        EstimationHeaderSub."Roll Width (mm)" := (EstimationHeaderSub."Board Length (mm)- L" * EstimationHeaderSub."Board Ups")
                            + EstimationHeaderSub."Trim Size (mm)";
                        EstimationHeaderSub."Cut Size (mm)" := (EstimationHeaderSub."Board Width (mm)- W");
                    end else begin
                        EstimationHeaderSub."Roll Width (mm)" := ((EstimationHeaderSub."Board Width (mm)- W") * EstimationHeaderSub."Board Ups")
                            + EstimationHeaderSub."Trim Size (mm)";
                        EstimationHeaderSub."Cut Size (mm)" := (EstimationHeaderSub."Board Length (mm)- L");
                    end;
                end;
                // Lines For Update Linear Mtr
                // EstimationHeaderSub."Linear Length":=(EstimationHeaderSub.Quantity * EstimationHeaderSub."Cut Size (mm)")/1000;
                // EstimationHeaderSub."Linear Length Qty Per":=(EstimationHeaderSub."Cut Size (mm)"/1000);

                // Lines for Update Linear Length
                EstimationHeaderSub."Linear Length Qty Per" := (EstimationHeaderSub."Cut Size (mm)" / 1000) / EstimationHeaderSub."Board Ups";
                EstimationHeaderSub."Linear Length" := ((EstimationHeaderSub."Cut Size (mm)" * EstimationHeaderSub.Quantity) / 1000) / EstimationHeaderSub."Board Ups";
                //Mpower


                MfgSetup.Get;
                if EstimationHeaderSub."Roll Width (mm)" > (EstimationHeaderSub."Machine Deckle Size (mm)") then
                    Error(Sam0001, EstimationHeaderSub."Roll Width (mm)", EstimationHeaderSub."Machine Deckle Size (mm)", EstimationHeaderSub."Product Design Type", EstimationHeaderSub."Product Design No.", EstimationHeaderSub."Sub Comp No.");


                EstimationHeaderSub.Validate(EstimationHeaderSub."Box Length (mm)- L (OD)");
                EstimationHeaderSub.Validate(EstimationHeaderSub."Box Width (mm)- W (OD)");
                EstimationHeaderSub.Validate(EstimationHeaderSub."Box Height (mm) - D (OD)");
                EstimationHeaderSub.Validate(EstimationHeaderSub."Board Length (mm)- L");
                EstimationHeaderSub.Validate(EstimationHeaderSub."Board Width (mm)- W");
                EstimationHeaderSub.Validate(EstimationHeaderSub."Roll Width (mm)");
                EstimationHeaderSub.Validate(EstimationHeaderSub."Cut Size (mm)");
                EstimationHeaderSub.Modify(true);

                // Lines added by Deepak Kumar 21 09 15

                EstimationHeaderSub."Quantity Per FG" := EstimationHeaderSub.Quantity / EstimationHeaderMain.Quantity;


                if not (EstimationHeaderSub."Model No" = '0201') or (EstimationHeaderSub."Model No" = '0200') or
                (EstimationHeaderSub."Model No" = '0202') then begin
                    EstimationHeaderSub."Item Description" := EstimationHeaderSub."Model Description" + ' ' + Format(EstimationHeaderSub."Board Width (mm)- W") + ' mm X ' + Format(EstimationHeaderSub."Board Length (mm)- L") + ' mm X '
                    + Format(EstimationHeaderSub."No. of Ply") + ' Ply';
                end else begin
                    EstimationHeaderSub."Item Description" := EstimationHeaderSub."Model Description" + ' ' + Format(EstimationHeaderSub."Box Length (mm)- L (OD)") + ' mm X ' + Format(EstimationHeaderSub."Box Width (mm)- W (OD)") +
                    ' mm X ' + Format(EstimationHeaderSub."Box Height (mm) - D (OD)") + ' mm X ' + Format(EstimationHeaderSub."No. of Ply") + ' Ply';
                end;





                EstimationHeaderSub.Modify(true);


                EstimateLine.Reset;
                EstimateLine.SetRange(EstimateLine."Product Design Type", EstimateLine."Product Design Type"::Sub);
                EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeaderSub."Product Design No.");
                EstimateLine.SetRange(EstimateLine."Line Type", EstimateLine."Line Type"::Paper);
                if EstimateLine.FindFirst then begin
                    MfgSetup.Get;
                    repeat
                        EstimateLine."Paper Weight (gms)" := ((EstimationHeaderSub."Paper Deckle Size (mm)" / EstimationHeaderSub."Board Ups") * EstimationHeaderSub."Board Length (mm)- L"
                                                   * EstimateLine.GSM * EstimateLine."Take Up" * 1.02 * EstimationHeaderSub.Quantity) / 1000000000;

                        EstimateLine.Quantity := EstimateLine."Paper Weight (gms)";
                        //Mpower
                        /*EstimateLine."Paper Weight (gms)":=(EstimationHeaderSub."Roll Width (mm)" * EstimationHeaderSub."Board Length (mm)- L" * EstimateLine.GSM *
                        MfgSetup."Scrap % for Estimation" * EstimateLine."Take Up")/(1000000*EstimationHeaderSub."Board Ups");*/

                        if (EstimateLine."Paper Position" = EstimateLine."Paper Position"::Liner1) or (EstimateLine."Paper Position" = EstimateLine."Paper Position"::Liner2)
                        or (EstimateLine."Paper Position" = EstimateLine."Paper Position"::Liner3) or (EstimateLine."Paper Position" = EstimateLine."Paper Position"::Liner4) then begin
                            EstimateLine."Paper Bursting Strength(BS)" := (EstimateLine.GSM * EstimateLine."Bursting factor(BF)") / 1000;
                        end else begin
                            EstimateLine."Paper Bursting Strength(BS)" := (EstimateLine.GSM * EstimateLine."Bursting factor(BF)") / 1000 / 2;
                        end;

                        /*IF EstimationHeaderSub."Board Ups" > 0 THEN BEGIN
                          EstimateLine.Quantity:=(EstimateLine."Paper Weight (gms)" * (EstimationHeaderSub.Quantity/EstimationHeaderSub."Board Ups"))/1000;
                        END ELSE BEGIN
                          EstimateLine.Quantity:=(EstimateLine."Paper Weight (gms)" * EstimationHeaderSub.Quantity)/1000;
                        END;*/

                        if EstimationHeaderSub."No. of Die Cut Ups" > 0 then
                            EstimateLine.Quantity := EstimateLine.Quantity / EstimationHeaderSub."No. of Die Cut Ups";

                        EstimateLine."Paper Required KG" := EstimateLine."Paper Weight (gms)" / 1000;

                        EstimateLine.Validate(EstimateLine.Quantity);
                        EstimateLine.Modify(true);
                    until EstimateLine.Next = 0;
                end;

                EstimationHeaderSub.Grammage := 0;
                EstimateLine.Reset;
                EstimateLine.SetRange(EstimateLine."Product Design Type", EstimateLine."Product Design Type"::Sub);
                EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeaderSub."Product Design No.");
                EstimateLine.SetRange(EstimateLine."Sub Comp No.", EstimationHeaderSub."Sub Comp No.");
                if EstimateLine.FindFirst then begin
                    repeat
                        TotalLineAmount := TotalLineAmount + EstimateLine."Line Amount";
                        TotalGSM := TotalGSM + EstimateLine."Paper Weight (gms)";
                        EstimationHeaderSub.Grammage := EstimationHeaderSub.Grammage + (EstimateLine.GSM * EstimateLine."Take Up");
                    until EstimateLine.Next = 0;
                end;
                EstimationHeaderSub.Modify(true);

                // Lines added BY Deepak Kumar for Update BS and LBS
                TempBoxBS := 0;
                NewEstimateLine.Reset;
                NewEstimateLine.SetRange(NewEstimateLine."Product Design Type", EstimationHeaderSub."Product Design Type");
                NewEstimateLine.SetRange(NewEstimateLine."Product Design No.", EstimationHeaderSub."Product Design No.");
                NewEstimateLine.SetRange(NewEstimateLine."Sub Comp No.", EstimationHeaderSub."Sub Comp No.");
                if NewEstimateLine.FindFirst then begin
                    repeat
                        TempBoxBS := TempBoxBS + NewEstimateLine."Paper Bursting Strength(BS)";
                    until NewEstimateLine.Next = 0;
                    EstimationHeaderSub."Box BS" := TempBoxBS;
                    EstimationHeaderSub."Box LBS" := TempBoxBS * 14.285;
                end;



                TotalLineAmount := TotalLineAmount + EstimationHeaderSub."Die Making Charges" + EstimationHeaderSub."Plate Making Charges" + EstimationHeaderSub."Other Charges";
                EstimationHeaderSub."Line Amount" := TotalLineAmount;
                EstimationHeaderSub."Box Amount per Unit" := TotalLineAmount / EstimationHeaderSub.Quantity;
                MfgSetup.Get;
                EstimationHeaderSub."Per Box Weight (Gms)" := (((EstimationHeaderSub."Board Length (mm)- L" * EstimationHeaderSub."Board Width (mm)- W" * EstimationHeaderSub.Grammage * MfgSetup."Scrap % for Estimation") /
                EstimationHeaderSub."No. of Die Cut Ups") * EstimationHeaderSub."No. of Joint") / (1000000);
                if EstimationHeaderSub."Per Box Weight (Gms)" = 0 then
                    EstimationHeaderSub."Per Box Weight (Gms)" := 1;
                EstimationHeaderSub."Per Box Weight with Comp(Gms)" := EstimationHeaderSub."Per Box Weight (Gms)";
                EstimationHeaderSub."Total Weight for Est. Qty (Kg)" := (EstimationHeaderSub."Per Box Weight (Gms)" * EstimationHeaderSub.Quantity) / 1000;
                EstimationHeaderSub."Amount Per KG" := EstimationHeaderSub."Line Amount" / EstimationHeaderSub."Total Weight for Est. Qty (Kg)";
                EstimationHeaderSub."Amount Per Unit" := EstimationHeaderSub."Line Amount" / EstimationHeaderSub.Quantity;
                EstimationHeaderSub.Modify(true);
                UpdateBoxSizeandFlute(EstimationHeaderSub."Product Design Type", EstimationHeaderSub."Product Design No.", EstimationHeaderSub."Sub Comp No.");

                EstimateLine.Reset;
                EstimateLine.SetRange(EstimateLine."Product Design Type", EstimateLine."Product Design Type"::Sub);
                EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeaderSub."Product Design No.");
                EstimateLine.SetRange(EstimateLine."Line Type", EstimateLine."Line Type"::Glue);
                if EstimateLine.FindFirst then begin
                    repeat
                        SalesSetup.Get;
                        SalesSetup.TestField(SalesSetup."Starch Calculation");
                        EstimateLine.Validate(Quantity, EstimationHeaderSub."Per Box Weight (Gms)" * (SalesSetup."Starch Calculation" / 100));
                    until EstimateLine.Next = 0;
                end;
            until EstimationHeaderSub.Next = 0;
        end;

    end;

    procedure UpdateBoxSizeandFlute(EstimateType: Option Main,Sub; "EstimateNo.": Code[50]; SubJobNo: Code[50])
    var
        FluteType: Text;
    begin
        // lines added by deepak Kumar

        EstimationHeader.Reset;
        EstimationHeader.SetRange(EstimationHeader."Product Design Type", EstimateType);
        EstimationHeader.SetRange(EstimationHeader."Product Design No.", "EstimateNo.");
        EstimationHeader.SetRange(EstimationHeader."Sub Comp No.", SubJobNo);
        if EstimationHeader.FindFirst then begin
            repeat
                EstimateLine.Reset;
                EstimateLine.SetRange(EstimateLine."Product Design Type", EstimationHeader."Product Design Type");
                EstimateLine.SetRange(EstimateLine."Product Design No.", EstimationHeader."Product Design No.");
                EstimateLine.SetRange(EstimateLine."Sub Comp No.", EstimationHeader."Sub Comp No.");
                EstimateLine.SetFilter(EstimateLine."Paper Position", '2|4|6');
                if EstimateLine.FindFirst then begin
                    FluteType := '';
                    repeat
                        if FluteType <> '' then
                            FluteType := FluteType + '+' + Format(EstimateLine."Flute Type")
                        else
                            FluteType := Format(EstimateLine."Flute Type");

                        if EstimateLine."Paper Position" = EstimateLine."Paper Position"::Flute1 then
                            EstimationHeader."Flute 1" := EstimateLine."Flute Type";
                        if EstimateLine."Paper Position" = EstimateLine."Paper Position"::Flute2 then
                            EstimationHeader."Flute 2" := EstimateLine."Flute Type";
                        if EstimateLine."Paper Position" = EstimateLine."Paper Position"::Flute3 then
                            EstimationHeader."Flute 3" := EstimateLine."Flute Type";

                    until EstimateLine.Next = 0;
                end;

                EstimationHeader."Flute Type" := FluteType;
                EstimationHeader."Box Size" := Format(EstimationHeader."Box Length (mm)- L (OD)") + ' X ' + Format(EstimationHeader."Box Width (mm)- W (OD)") + ' X ' + Format(EstimationHeader."Box Height (mm) - D (OD)") + '(mm)';
                EstimationHeader."Board Size" := Format(EstimationHeader."Board Length (mm)- L") + ' X ' + Format(EstimationHeader."Board Width (mm)- W") + '(mm)';
                EstimationHeader.Modify(true);
            until EstimationHeader.Next = 0;

            Commit;
        end;
    end;

    procedure CopyEastimate(FromEstimate: Code[50]; ToEstimate: Code[50])
    var
        FromEstimateHeader: Record 50000;
        fromEstimateLine: Record 50001;
        ToEstimateHeader: Record 50000;
        ToEstimateLine: Record 50001;
        Question: Text[250];
        Answer: Boolean;
        ProductDesignSpecialDescripFrom: Record 50024;
        ProductDesignSpecialDescripTo: Record 50024;
        ProductionOrder: Record 5405;
    begin
        // Lines added BY Deepak Kumar
        ProductionOrder.RESET;
        ProductionOrder.SETRANGE(ProductionOrder.Status, ProductionOrder.Status::Released);
        ProductionOrder.SETRANGE("Estimate Code", "Copy From");
        IF ProductionOrder.FINDFIRST THEN
            ERROR('There is a unfinished Production Order No. %1 with old PDI %2', ProductionOrder."No.", ToEstimateHeader."Old Estimate No.");

        Answer := DIALOG.CONFIRM(('Do you want to copy from ' + FromEstimate + ' to Estimate No. ' + ToEstimate), TRUE);

        Templine[1] := '';
        Templine[2] := '';
        Templine[3] := '';
        Templine[4] := '';
        Templine[5] := '';
        Templine[6] := '';
        Templine[7] := '';
        TempInte[1] := 0;
        TempInte[2] := 0;
        Templine[8] := '';
        IF Answer = TRUE THEN BEGIN
            FromEstimateHeader.RESET;
            FromEstimateHeader.SETRANGE(FromEstimateHeader."Product Design Type", FromEstimateHeader."Product Design Type"::Main);
            FromEstimateHeader.SETRANGE(FromEstimateHeader."Product Design No.", FromEstimate);
            IF FromEstimateHeader.FINDFIRST THEN BEGIN
                ToEstimateHeader.RESET;
                ToEstimateHeader.SETRANGE(ToEstimateHeader."Product Design Type", ToEstimateHeader."Product Design Type"::Main);
                ToEstimateHeader.SETRANGE(ToEstimateHeader."Product Design No.", ToEstimate);
                ToEstimateHeader.FINDFIRST;
                Templine[1] := ToEstimateHeader.Customer;
                Templine[2] := ToEstimateHeader.Contact;
                Templine[3] := ToEstimateHeader."Sales Person Code";
                Templine[4] := ToEstimateHeader."Sales Quote No.";
                Templine[5] := ToEstimateHeader."Sales Order No.";
                Templine[6] := ToEstimateHeader."Item Code";
                Templine[7] := ToEstimateHeader."Item Description";
                TempInte[1] := ToEstimateHeader."Sales Quote Line Number";
                TempInte[2] := ToEstimateHeader."No. of Ply";
                Templine[8] := FromEstimate;

                ToEstimateHeader.TRANSFERFIELDS(FromEstimateHeader, FALSE);
                IF Templine[1] <> '' THEN
                    ToEstimateHeader.Customer := Templine[1];
                IF Templine[2] <> '' THEN
                    ToEstimateHeader.Contact := Templine[2];
                ToEstimateHeader."Sales Person Code" := Templine[3];
                ToEstimateHeader."Sales Quote No." := Templine[4];
                ToEstimateHeader."Sales Order No." := Templine[5];
                ToEstimateHeader."Sales Quote Line Number" := TempInte[1];
                ToEstimateHeader."No. of Ply" := TempInte[2];
                ToEstimateHeader."Item Code" := Templine[6];
                ToEstimateHeader."Item Description" := Templine[7];
                ToEstimateHeader.Status := 0;
                ToEstimateHeader."Pre-Press Status" := ToEstimateHeader."Pre-Press Status"::" ";
                ToEstimateHeader."Pre-Press Confirmed By" := '';
                ToEstimateHeader."Production Status" := ToEstimateHeader."Production Status"::" ";
                ToEstimateHeader."Production Confirmed By" := '';
                ToEstimateHeader."Old Estimate No." := Templine[8];
                ToEstimateHeader.MODIFY(TRUE);
                //Line added by sadaf
                IF ToEstimateHeader."Old Estimate No." <> '' THEN BEGIN
                    PDesignHeader.RESET;
                    PDesignHeader.SETRANGE(PDesignHeader."Product Design No.", ToEstimateHeader."Old Estimate No.");
                    IF PDesignHeader.FINDFIRST THEN BEGIN
                        ProductionOrder.RESET;
                        ProductionOrder.SETRANGE(ProductionOrder.Status, ProductionOrder.Status::Released);
                        ProductionOrder.SETRANGE("Estimate Code", ToEstimateHeader."Old Estimate No.");
                        IF ProductionOrder.FINDFIRST THEN
                            ERROR('There is a unfinished Production Order No. %1 with old PDI %2', ProductionOrder."No.", ToEstimateHeader."Old Estimate No.");
                        MESSAGE('This will block the old Estimate Card %1', ToEstimateHeader."Old Estimate No.");
                        PDesignHeader.Status := PDesignHeader.Status::Blocked;
                        PDesignHeader.MODIFY(TRUE);
                    END;
                END;

                ToEstimateLine.RESET;
                ToEstimateLine.SETRANGE(ToEstimateLine."Product Design No.", ToEstimate);
                ToEstimateLine.DELETEALL;
                fromEstimateLine.RESET;
                fromEstimateLine.SETRANGE(fromEstimateLine."Product Design Type", fromEstimateLine."Product Design Type"::Main);
                fromEstimateLine.SETRANGE(fromEstimateLine."Product Design No.", FromEstimate);
                IF fromEstimateLine.FINDFIRST THEN BEGIN
                    REPEAT
                        ToEstimateLine.INIT;
                        ToEstimateLine := fromEstimateLine;
                        ToEstimateLine."Product Design No." := ToEstimate;
                        ToEstimateLine.INSERT(TRUE);
                    UNTIL fromEstimateLine.NEXT = 0;
                END;

                LineCount := 0;
                FromEstimateHeader.RESET;
                FromEstimateHeader.SETRANGE("Product Design Type", FromEstimateHeader."Product Design Type"::Sub);
                FromEstimateHeader.SETRANGE("Product Design No.", FromEstimate);
                IF FromEstimateHeader.FINDFIRST THEN BEGIN
                    REPEAT
                        LineCount := LineCount + 1;
                    UNTIL FromEstimateHeader.NEXT = 0;
                END;


                FromEstimateHeader.RESET;
                FromEstimateHeader.SETRANGE(FromEstimateHeader."Product Design No.", FromEstimate);
                FromEstimateHeader.SETRANGE(FromEstimateHeader."Product Design Type", FromEstimateHeader."Product Design Type"::Sub);
                IF FromEstimateHeader.FINDFIRST THEN BEGIN
                    REPEAT
                        ToEstimateHeader.INIT;
                        ToEstimateHeader."Product Design Type" := ToEstimateHeader."Product Design Type"::Sub;
                        ToEstimateHeader."Product Design No." := ToEstimate;
                        ToEstimateHeader."Sub Comp No." := ToEstimate + '-' + FORMAT(LineCount);
                        ToEstimateHeader.INSERT(TRUE);

                        ToEstimateHeader.TRANSFERFIELDS(FromEstimateHeader, FALSE);
                        IF Templine[1] <> '' THEN
                            ToEstimateHeader.VALIDATE(Customer, Templine[1]);
                        IF Templine[2] <> '' THEN
                            ToEstimateHeader.Contact := Templine[2];
                        ToEstimateHeader."Sales Person Code" := Templine[3];
                        ToEstimateHeader."Sales Quote No." := Templine[4];
                        ToEstimateHeader."Sales Order No." := Templine[5];
                        ToEstimateHeader."Sales Quote Line Number" := TempInte[1];
                        ToEstimateHeader."No. of Ply" := TempInte[2];
                        ToEstimateHeader.VALIDATE("Item Code", Templine[6]);
                        ToEstimateHeader."Item Description" := Templine[7];
                        ToEstimateHeader.Status := 0;
                        ToEstimateHeader."Pre-Press Status" := ToEstimateHeader."Pre-Press Status"::" ";
                        ToEstimateHeader."Pre-Press Confirmed By" := '';
                        ToEstimateHeader."Production Status" := ToEstimateHeader."Production Status"::" ";
                        ToEstimateHeader."Production Confirmed By" := '';
                        ToEstimateHeader."Old Estimate No." := Templine[8];
                        ToEstimateHeader.MODIFY(TRUE);

                        ToEstimateLine.RESET;
                        ToEstimateLine.SETRANGE(ToEstimateLine."Product Design Type", FromEstimateHeader."Product Design Type");
                        ToEstimateLine.SETRANGE(ToEstimateLine."Product Design No.", ToEstimate);
                        ToEstimateLine.SETRANGE(ToEstimateLine."Sub Comp No.", FromEstimateHeader."Sub Comp No.");
                        ToEstimateLine.DELETEALL;

                        fromEstimateLine.RESET;
                        fromEstimateLine.SETRANGE(fromEstimateLine."Product Design Type", FromEstimateHeader."Product Design Type");
                        fromEstimateLine.SETRANGE(fromEstimateLine."Product Design No.", FromEstimateHeader."Product Design No.");
                        fromEstimateLine.SETRANGE(fromEstimateLine."Sub Comp No.", FromEstimateHeader."Sub Comp No.");
                        IF fromEstimateLine.FINDFIRST THEN BEGIN
                            REPEAT
                                ToEstimateLine.INIT;
                                ToEstimateLine := fromEstimateLine;
                                ToEstimateLine."Product Design No." := ToEstimate;
                                IF ToEstimateHeader."Product Design Type" = ToEstimateHeader."Product Design Type"::Sub THEN
                                    ToEstimateLine."Sub Comp No." := ToEstimateHeader."Sub Comp No.";
                                ToEstimateLine.INSERT(TRUE);
                            UNTIL fromEstimateLine.NEXT = 0;
                        END;
                    UNTIL FromEstimateHeader.NEXT = 0;
                END;
                /* //Mpower
                   ProductDesignSpecialDescripFrom.RESET;
                   ProductDesignSpecialDescripFrom.SETRANGE(ProductDesignSpecialDescripFrom."No.",FromEstimate);
                   IF ProductDesignSpecialDescripFrom.FINDFIRST THEN BEGIN
                     REPEAT
                       ProductDesignSpecialDescripTo.INIT;
                       ProductDesignSpecialDescripTo:=ProductDesignSpecialDescripFrom;
                       ProductDesignSpecialDescripTo."No.":=ToEstimate;
                       ProductDesignSpecialDescripTo.INSERT(TRUE);
                     UNTIL ProductDesignSpecialDescripFrom.NEXT=0;
                   END;
                */
                MESSAGE('Complete');
            END;
        END ELSE BEGIN
            MESSAGE('Activity declined by User!');
        END;
    end;

    procedure CopyEastimate1(FromEstimate: Code[50]; ToEstimate: Code[50])
    var
        FromEstimateHeader: Record "Product Design Header";
        fromEstimateLine: Record "Product Design Line";
        ToEstimateHeader: Record "Product Design Header";
        ToEstimateLine: Record "Product Design Line";
        Question: Text[250];
        Answer: Boolean;
    begin
        // Lines added BY Deepak Kumar

        Answer := DIALOG.Confirm(('Do you want to copy from ' + FromEstimate + ' to Estimate No. ' + ToEstimate), true);

        Templine[1] := '';
        Templine[2] := '';
        Templine[3] := '';
        Templine[4] := '';
        Templine[5] := '';
        Templine[6] := '';
        Templine[7] := '';
        TempInte[1] := 0;
        TempInte[2] := 0;

        if Answer = true then begin
            FromEstimateHeader.Reset;
            FromEstimateHeader.SetRange(FromEstimateHeader."Product Design No.", FromEstimate);
            if FromEstimateHeader.FindFirst then begin


                ToEstimateHeader.SetRange(ToEstimateHeader."Product Design No.", ToEstimate);
                ToEstimateHeader.FindFirst;
                Templine[1] := ToEstimateHeader.Customer;
                Templine[2] := ToEstimateHeader.Contact;
                Templine[3] := ToEstimateHeader."Sales Person Code";
                Templine[4] := ToEstimateHeader."Sales Quote No.";
                Templine[5] := ToEstimateHeader."Sales Order No.";
                Templine[6] := ToEstimateHeader."Item Code";
                Templine[7] := ToEstimateHeader."Item Description";
                TempInte[1] := ToEstimateHeader."Sales Quote Line Number";
                TempInte[2] := ToEstimateHeader."No. of Ply";

                ToEstimateHeader.TransferFields(FromEstimateHeader, false);
                ToEstimateHeader.Customer := Templine[1];
                ToEstimateHeader.Contact := Templine[2];
                ToEstimateHeader."Sales Person Code" := Templine[3];
                ToEstimateHeader."Sales Quote No." := Templine[4];
                ToEstimateHeader."Sales Order No." := Templine[5];
                ToEstimateHeader."Sales Quote Line Number" := TempInte[1];
                ToEstimateHeader."No. of Ply" := TempInte[2];
                ToEstimateHeader."Item Code" := Templine[6];
                ToEstimateHeader."Item Description" := Templine[7];
                ToEstimateHeader.Status := 0;
                ToEstimateHeader.Modify(true);
                ToEstimateLine.Reset;
                ToEstimateLine.SetRange(ToEstimateLine."Product Design No.", ToEstimate);
                ToEstimateLine.DeleteAll;
                fromEstimateLine.SetRange(fromEstimateLine."Product Design No.", FromEstimate);
                if fromEstimateLine.FindFirst then begin
                    repeat
                        ToEstimateLine := fromEstimateLine;
                        ToEstimateLine."Product Design No." := ToEstimate;
                        ToEstimateLine.Insert(true);
                    until fromEstimateLine.Next = 0;
                end;
                FromEstimateHeader.SetRange(FromEstimateHeader."Product Design Type", FromEstimateHeader."Product Design Type"::Sub);
                if FromEstimateHeader.FindFirst then begin
                    repeat
                        ToEstimateHeader.Init;
                        ToEstimateHeader."Product Design Type" := ToEstimateHeader."Product Design Type"::Sub;
                        ToEstimateHeader."Product Design No." := ToEstimate;
                        ToEstimateHeader."Sub Comp No." := FromEstimateHeader."Sub Comp No.";
                        ToEstimateHeader.Insert(true);

                        ToEstimateHeader.TransferFields(FromEstimateHeader, false);
                        ToEstimateHeader.Customer := Templine[1];
                        ToEstimateHeader.Contact := Templine[2];
                        ToEstimateHeader."Sales Person Code" := Templine[3];
                        ToEstimateHeader."Sales Quote No." := Templine[4];
                        ToEstimateHeader."Sales Order No." := Templine[5];
                        ToEstimateHeader."Sales Quote Line Number" := TempInte[1];
                        ToEstimateHeader."No. of Ply" := TempInte[2];
                        ToEstimateHeader."Item Code" := Templine[6];
                        ToEstimateHeader."Item Description" := Templine[7];
                        ToEstimateHeader.Status := 0;
                        ToEstimateHeader.Modify(true);

                        ToEstimateLine.Reset;
                        ToEstimateLine.SetRange(ToEstimateLine."Product Design Type", FromEstimateHeader."Product Design Type");
                        ToEstimateLine.SetRange(ToEstimateLine."Product Design No.", ToEstimate);
                        ToEstimateLine.SetRange(ToEstimateLine."Sub Comp No.", FromEstimateHeader."Sub Comp No.");
                        ToEstimateLine.DeleteAll;

                        fromEstimateLine.Reset;
                        fromEstimateLine.SetRange(fromEstimateLine."Product Design Type", FromEstimateHeader."Product Design Type");
                        fromEstimateLine.SetRange(fromEstimateLine."Product Design No.", FromEstimateHeader."Product Design No.");
                        fromEstimateLine.SetRange(fromEstimateLine."Sub Comp No.", FromEstimateHeader."Sub Comp No.");
                        if fromEstimateLine.FindFirst then begin
                            repeat
                                ToEstimateLine := fromEstimateLine;
                                ToEstimateLine."Product Design No." := ToEstimate;
                                ToEstimateLine.Insert(true);
                            until fromEstimateLine.Next = 0;
                        end;
                    until FromEstimateHeader.Next = 0;
                end;
                Message('Complete');
            end;
        end else begin
            Message('Activity declined by User!');

        end;
    end;

    local procedure UpdateTrimSize()
    begin
        // Lines added BY Deepak Kumar

        /*
        IF ("Trim Size (mm)" = 0) AND ("Left Trim Size (mm)" <> 0) OR ("Right Trim Size (mm)" <> 0) THEN BEGIN
          "Trim Size (mm)":="Left Trim Size (mm)"+"Right Trim Size (mm)";
        END ELSE BEGIN
          "Left Trim Size (mm)":="Trim Size (mm)"/2;
          "Right Trim Size (mm)":="Trim Size (mm)"/2;
        END;
         */
        "Trim Size (mm)" := "Left Trim Size (mm)" + "Right Trim Size (mm)";

    end;

    procedure UpdateEstimatePriceOnSalesQuote()
    var
        SaleQuoteLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        // Lines added BY Deepak Kumar
        TestField("Sales Quote No.");
        SaleQuoteLine.Reset;
        SaleQuoteLine.SetRange(SaleQuoteLine."Document Type", SaleQuoteLine."Document Type"::Quote);
        SaleQuoteLine.SetRange(SaleQuoteLine."Document No.", "Sales Quote No.");
        SaleQuoteLine.SetRange(SaleQuoteLine."Line No.", "Sales Quote Line Number");
        if SaleQuoteLine.FindFirst then begin
            repeat
                if SaleQuoteLine."Currency Code" <> '' then begin
                    SalesHeader.Reset;
                    SalesHeader.SetRange(SalesHeader."Document Type", SaleQuoteLine."Document Type");
                    SalesHeader.SetRange(SalesHeader."No.", SaleQuoteLine."Document No.");
                    if SalesHeader.FindFirst then begin
                        //  SaleQuoteLine.VALIDATE("Unit Price",ROUND("Box Amount per Unit",0.001)*SalesHeader."Currency Factor");
                        SaleQuoteLine.Validate("Estimate Price", Round("Amount Per Unit", 0.001) * SalesHeader."Currency Factor");
                        SaleQuoteLine."Estimation No." := "Product Design No.";
                        SaleQuoteLine.Modify(true);
                    end;

                end else begin
                    //SaleQuoteLine.VALIDATE("Unit Price",ROUND("Box Amount per Unit",0.001));
                    SaleQuoteLine.Validate("Estimate Price", Round("Amount Per Unit", 0.001));
                    SaleQuoteLine."Estimation No." := "Product Design No.";
                    SaleQuoteLine.Modify(true);

                end;
            until SaleQuoteLine.Next = 0;
            Message('Estimated Prices Updated on Sales Quote Line. The Updated Price is %1', Round("Amount Per Unit", 0.001));
        end;
    end;

    procedure UpdateEstimatePriceOnSalesOrder()
    var
        SalesOrderLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        // Lines added BY Deepak Kumar
        TestField("Sales Order No.");

        SalesOrderLine.Reset;
        SalesOrderLine.SetRange(SalesOrderLine."Document Type", SalesOrderLine."Document Type"::Order);
        SalesOrderLine.SetRange(SalesOrderLine."Document No.", "Sales Order No.");
        SalesOrderLine.SetRange(SalesOrderLine."Line No.", "Sales Order Line No.");
        if SalesOrderLine.FindFirst then begin
            repeat
                if SalesOrderLine."Currency Code" <> '' then begin
                    SalesHeader.Reset;
                    SalesHeader.SetRange(SalesHeader."Document Type", SalesOrderLine."Document Type");
                    SalesHeader.SetRange(SalesHeader."No.", SalesOrderLine."Document No.");
                    if SalesHeader.FindFirst then begin
                        // SalesOrderLine.VALIDATE("Unit Price",ROUND("Box Amount per Unit",0.001)*SalesHeader."Currency Factor");
                        SalesOrderLine."Estimate Price" := Round("Box Amount per Unit", 0.001) * SalesHeader."Currency Factor";
                        SalesOrderLine."Estimation No." := "Product Design No.";
                        SalesOrderLine.Modify(true);
                    end;
                end else begin
                    //SalesOrderLine.VALIDATE("Unit Price",ROUND("Box Amount per Unit",0.001));
                    SalesOrderLine."Estimate Price" := Round("Box Amount per Unit", 0.001);
                    ;
                    SalesOrderLine."Estimation No." := "Product Design No.";
                    SalesOrderLine.Modify(true);

                end;
            until SalesOrderLine.Next = 0;
            Message('Estimated Prices Updated on Sales Order. The Updated Price is %1', Round("Amount Per Unit", 0.001));
        end;
    end;

    procedure UpdatePaperPositionInQuickEstimate(EstimateHeader: Record "Product Design Header")
    var
        QuickEstProcessingTable: Record "Quick Entry Process";
        LineCounter: Integer;
        TempPaperPosition: Integer;
    begin
        // Lines added By Deepak kUmar
        EstimateHeader.TestField(EstimateHeader."No. of Ply");
        QuickEstProcessingTable.Reset;
        QuickEstProcessingTable.SetRange(QuickEstProcessingTable."Product Design Type", EstimateHeader."Product Design Type");
        QuickEstProcessingTable.SetRange(QuickEstProcessingTable."Product Design No.", EstimateHeader."Product Design No.");
        QuickEstProcessingTable.SetRange(QuickEstProcessingTable."Sub Comp No.", EstimateHeader."Sub Comp No.");
        QuickEstProcessingTable.SetRange(QuickEstProcessingTable."Work Center Category", QuickEstProcessingTable."Work Center Category"::Materials);
        if QuickEstProcessingTable.FindFirst then begin
            QuickEstProcessingTable.DeleteAll(true);
        end;
        LineCounter := EstimateHeader."No. of Ply";
        TempPaperPosition := 1;

        repeat

            QuickEstProcessingTable.Init;
            QuickEstProcessingTable."Product Design Type" := EstimateHeader."Product Design Type";
            QuickEstProcessingTable."Product Design No." := EstimateHeader."Product Design No.";
            QuickEstProcessingTable."Sub Comp No." := EstimateHeader."Sub Comp No.";
            QuickEstProcessingTable."Paper Position" := TempPaperPosition;
            QuickEstProcessingTable."Work Center Category" := QuickEstProcessingTable."Work Center Category"::Materials;
            QuickEstProcessingTable.Insert(true);

            LineCounter := LineCounter - 1;
            TempPaperPosition := TempPaperPosition + 1;

        until LineCounter = 0;
    end;

    procedure UpdateProcessInQuickEstimate(EstimateHeader: Record "Product Design Header")
    var
        QuickEstProcessingTable: Record "Quick Entry Process";
        LineCounter: Integer;
        QuickEstimateSetup: Record "Quick Est. Setup";
        MachineCenter: Record "Machine Center";
        EstimateHeaderL: Record "Product Design Header";
    begin
        // Lines added by Deepak Kumar

        QuickEstimateSetup.Reset;
        QuickEstimateSetup.SetRange(QuickEstimateSetup."Model Code", EstimateHeader."Model No");

        if QuickEstimateSetup.FindFirst then begin
            repeat

                QuickEstProcessingTable.Init;
                QuickEstProcessingTable."Product Design Type" := EstimateHeader."Product Design Type";
                QuickEstProcessingTable."Product Design No." := EstimateHeader."Product Design No.";
                QuickEstProcessingTable."Sub Comp No." := EstimateHeader."Sub Comp No.";
                QuickEstProcessingTable."Process Code" := QuickEstimateSetup.Code;
                QuickEstProcessingTable."Process Description" := QuickEstimateSetup."Process Description";
                if QuickEstimateSetup."Price Based Condition" = 0 then
                    QuickEstProcessingTable."Unit Cost" := QuickEstimateSetup."Standard Cost";
                QuickEstProcessingTable.Insert(true);

            until QuickEstimateSetup.Next = 0;
        end;
    end;

    procedure UpdateNoofUpsInHeader(EstimateH: Record "Product Design Header")
    var
        EstimateHeaderL: Record "Product Design Header";
    begin
    end;

    procedure CheckPermission()
    begin
        // Lines added by deepak kumar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Estimate Approver", true);
        if not UserSetup.FindFirst then begin
            Error('You are not authorized for Estimate module, Please contact your System Administrator');
        end;
    end;

    procedure UpdateIDvsOD()
    var
        LineCounterM: Integer;
    begin
        // Lines added by Deepak Kumar
        MfgSetup.Get;
        ExpectedBoxHeight := 0;
        EstimateLine.Reset;
        EstimateLine.SetRange(EstimateLine."Product Design Type", "Product Design Type");
        EstimateLine.SetRange(EstimateLine."Product Design No.", "Product Design No.");
        EstimateLine.SetRange(EstimateLine."Sub Comp No.", "Sub Comp No.");
        EstimateLine.SetRange(EstimateLine.Type, EstimateLine.Type::Item);
        EstimateLine.SetFilter(EstimateLine."Paper Position", '2|4');
        if EstimateLine.FindFirst then begin
            LineCounterM := 0;
            repeat
                if (EstimateLine."Paper Position" = 2) or (EstimateLine."Paper Position" = 4) then begin
                    LineCounterM += 1;
                    if EstimateLine."Flute Type" = EstimateLine."Flute Type"::A then
                        ExpectedBoxHeight += MfgSetup."Flute - A Height";

                    if EstimateLine."Flute Type" = EstimateLine."Flute Type"::B then
                        ExpectedBoxHeight += MfgSetup."Flute - B Height";

                    if EstimateLine."Flute Type" = EstimateLine."Flute Type"::C then
                        ExpectedBoxHeight += MfgSetup."Flute - C Height";

                    if EstimateLine."Flute Type" = EstimateLine."Flute Type"::D then
                        ExpectedBoxHeight += MfgSetup."Flute - D Height";

                    if EstimateLine."Flute Type" = EstimateLine."Flute Type"::E then
                        ExpectedBoxHeight += MfgSetup."Flute - E Height";

                    if EstimateLine."Flute Type" = EstimateLine."Flute Type"::F then
                        ExpectedBoxHeight += MfgSetup."Flute - F Height";

                end;
            until EstimateLine.Next = 0;
            if LineCounterM > 1 then
                ExpectedBoxHeight := ExpectedBoxHeight - 1;//FOR 5 pLY
        end else begin
            if "No. of Ply" > 2 then
                NoofFlute := ("No. of Ply" - 1) / 2
            else
                NoofFlute := 1;

            ExpectedBoxHeight := NoofFlute * MfgSetup."Flute - B Height";
            //    MESSAGE('No Paper found so that Flute - B Height used for calculation');

        end;
        // Condition provided bY UCIL
        /*
        FluteL W   H
        B    3 3  6
        C    4 4  8
        E    3 3  5
        B+C  6 6  12
        E+B  5 5  10
         */

    end;

    local procedure CalculatePaperSize()
    begin
        // Lines added By Deepak Kumar
        if "Input Size Option" = "Input Size Option"::OD then begin
            Validate("Box Length (mm)- L (OD)");
            Validate("Box Width (mm)- W (OD)");
            Validate("Box Height (mm) - D (OD)");
        end else begin
            Validate("Box Length (mm)- L (ID)");
            Validate("Box Width (mm)- W (ID)");
            Validate("Box Height (mm) - D (ID)");
        end;
    end;

    procedure CreateDie(ProductDesignHeader: Record "Product Design Header")
    var
        Fasetup: Record "FA Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TempItemCode: Code[20];
        TempItemCod1: Code[10];
        FAMaster: Record "Fixed Asset";
        FADepreciationBook: Record "FA Depreciation Book";
    begin
        // Lines added by Deepak Kumar
        if ProductDesignHeader."Die Punching" = true then begin

            ItemMaster.Reset;
            ItemMaster.SetRange(ItemMaster."No.", ProductDesignHeader."Item Code");
            if ItemMaster.FindFirst then begin
                if ItemMaster."Die Number" = '' then begin
                    FAMaster.Init;

                    MfgSetup.Get;
                    MfgSetup.TestField("Die No. Series");
                    NoSeriesMgt.InitSeries(MfgSetup."Die No. Series", '', 0D, TempItemCode, TempItemCod1);
                    FAMaster."No." := TempItemCode;
                    FAMaster."FG Item Number" := ItemMaster."No.";
                    if ItemMaster."Mother Job No." <> '' then begin
                        FAMaster."Mother Job No." := ItemMaster."Mother Job No."
                    end else begin
                        FAMaster."Mother Job No." := ProductDesignHeader."Production Order No.";
                        FAMaster."Mother Job Quantity" := "Quantity to Job Order";
                    end;

                    FAMaster.Description := 'Die ' + ItemMaster."No." + ' ' + FAMaster."Mother Job No.";
                    FAMaster."Customer's Name" := ProductDesignHeader.Name;
                    FAMaster."Curr Prod. Order Desc." := ProductDesignHeader."Item Description";

                    FAMaster.Die := true;
                    FAMaster."Ready to Use" := false;
                    FAMaster."Replace Die/Plate" := false;
                    FAMaster."FA Class Code" := 'TOOL_EQUI';
                    FAMaster."Customer Code" := ProductDesignHeader.Customer;
                    FAMaster."Estimate No." := ProductDesignHeader."Product Design No.";
                    FAMaster.Insert(true);

                    FADepreciationBook.Init;
                    FADepreciationBook."FA No." := FAMaster."No.";
                    FADepreciationBook."Depreciation Book Code" := 'COMPANY';
                    FADepreciationBook."Depreciation Method" := FADepreciationBook."Depreciation Method"::"Straight-Line";
                    FADepreciationBook."FA Posting Group" := 'TOOL_EQUI';
                    FADepreciationBook.Insert(true);


                    ItemMaster."Die Number" := TempItemCode;
                    ItemMaster.Modify(true);
                    ProductDesignHeader."Die Number" := TempItemCode;
                    ProductDesignHeader.Modify(true);
                end;
            end;
        end;
    end;

    procedure CreatePlateItem(ProductDesignHeader: Record "Product Design Header")
    var
        ItemM: Record Item;
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TempItemCode: Code[20];
        TempItemCod1: Code[10];
        ItemVariant: Record "Item Variant";
    begin
        // Lines added by Deepak Kumar
        if ProductDesignHeader.Printing = true then begin
            ItemMaster.Reset;
            ItemMaster.SetRange(ItemMaster."No.", ProductDesignHeader."Item Code");
            if ItemMaster.FindFirst then begin
                if ItemMaster."Plate Item No." = '' then begin
                    ItemM.Init;
                    MfgSetup.Get;
                    MfgSetup.TestField("Plate No. Series");
                    //  ItemMaster.TESTFIELD(ItemMaster."Mother Job No.");
                    NoSeriesMgt.InitSeries(MfgSetup."Plate No. Series", '', 0D, TempItemCode, TempItemCod1);
                    ItemM."No." := TempItemCode;
                    ItemM."FG Item No." := ItemMaster."No.";
                    ItemM.Description := 'Plate - ' + ItemMaster."No." + ' ' + ItemMaster."Mother Job No.";
                    ItemM."Customer's Name(Curr. Prod)" := Name;
                    ItemM."Curr Prod. Order Desc." := ProductDesignHeader."Item Description";
                    ItemM."Customer No." := ProductDesignHeader.Customer;
                    ItemM."Customer Name" := ProductDesignHeader.Name;
                    ItemM."Estimate No." := ProductDesignHeader."Product Design No.";
                    ItemM."Ready for Print" := false;
                    ItemM."Artwork Availabe" := ProductDesignHeader."Artwork Available";
                    ItemM."Replace Plate" := false;
                    ItemM."Req. For Purchase" := false;
                    ItemM."Plate Item" := true;
                    ItemM."Inventory Value Zero" := true;
                    ItemM."No. of Ply" := ItemMaster."No. of Ply";
                    if ItemMaster."Mother Job No." <> '' then begin
                        ItemM."Mother Job No." := ItemMaster."Mother Job No."
                    end else begin
                        ItemM."Mother Job No." := ProductDesignHeader."Production Order No.";
                    end;
                    ItemM.Insert(true);
                    ItemM.Validate(ItemM."Item Category Code", 'Plate_Film');
                    ItemM.Validate("Base Unit of Measure", 'Set');
                    ItemM."No. of Ply" := ItemMaster."No. of Ply";


                    ItemM.Modify(true);
                    ItemVariant.Init;
                    ItemVariant."Item No." := ItemM."No.";
                    ItemVariant.Code := ItemM."No.";
                    ItemVariant.Description := 'Plate - ' + ItemMaster."Mother Job No.";
                    ItemVariant."Active Variant" := true;
                    ItemVariant.Insert(true);
                    Message('Plate created for the Item No. %1 . Plate No. %2', ItemMaster."No.", ItemM."No.");

                    ItemMaster."Plate Item No." := ItemM."No.";
                    ItemMaster.Modify(true);
                    ProductDesignHeader."Plate Item No." := ItemM."No.";
                    ProductDesignHeader.Modify(true);
                end;
            end;
        end;
    end;

    local procedure UpdateModelCalculation(EstimateHeaderN: Record "Product Design Header")
    begin
    end;

    procedure UpdateTopColour(ItemCodeN: Code[50])
    var
        ItemAttributeEntry: Record "Item Attribute Entry";
    begin
        // Lines added By Deepak Kumar
        ItemAttributeEntry.Reset;
        ItemAttributeEntry.SetFilter(ItemAttributeEntry."Item No.", ItemCodeN);
        ItemAttributeEntry.SetRange(ItemAttributeEntry."Item Attribute Code", 'COLOUR');
        if ItemAttributeEntry.FindFirst then begin
            "Top Colour" := ItemAttributeEntry."Item Attribute Value";
            Modify(true);
        end;
    end;

    procedure SendtoPrePress(EstimateHeader: Record "Product Design Header")
    begin
        // Lines added By Deepak kumar
        EstimateHeader."Pre-Press Status" := EstimateHeader."Pre-Press Status"::"Update Pending from Pre-Press ";
        EstimateHeader."Pre-Press Confirmed By" := 'Request Date: ' + Format(CurrentDateTime);
        EstimateHeader.Modify(true);
    end;

    procedure ApproveFromPrePress(EstimateHeader: Record "Product Design Header")
    begin
        // Lines added By Deepak Kumar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Approval Authority Pre-Press", true);
        if UserSetup.FindFirst then begin
            EstimateHeader."Pre-Press Status" := EstimateHeader."Pre-Press Status"::"Updated & Confirmed";
            EstimateHeader."Pre-Press Confirmed By" := UserId + ' ' + Format(CurrentDateTime);
            EstimateHeader.Modify(true);
        end else begin
            Error('You are not authorized user, please contact your administrator for more details.');
        end;
    end;

    procedure SendtoProduction(EstimateHeader: Record "Product Design Header")
    begin
        // Lines added By Deepak Kumar
        EstimateHeader."Production Status" := EstimateHeader."Production Status"::"Update Pending from Production ";
        EstimateHeader."Production Confirmed By" := 'Request Date: ' + Format(CurrentDateTime);
        EstimateHeader.Modify(true);
    end;

    procedure ApproveFromProduction(EstimateHeader: Record "Product Design Header")
    begin
        // Lines added By Deepak Kumar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Approval Authority Production", true);
        if UserSetup.FindFirst then begin
            EstimateHeader."Production Status" := EstimateHeader."Production Status"::"Updated & Confirmed";
            EstimateHeader."Production Confirmed By" := UserId + ' ' + Format(CurrentDateTime);
            EstimateHeader.Modify(true);
        end else begin
            Error('You are not authorized user, please contact your administrator for more details.');
        end;
    end;

    procedure CheckPaperItem(EstimateHeader: Record "Product Design Header")
    var
        ProductDesignHeader: Record "Product Design Header";
    begin
        // Lines added by Deepak Kumar
        ProductDesignHeader.Reset;
        ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", EstimateHeader."Product Design No.");
        if ProductDesignHeader.FindFirst then begin
            repeat

            until ProductDesignHeader.Next = 0;
        end;
    end;

    procedure UpdateWeightinItem(ProductDesignHeader: Record "Product Design Header")
    var
        ProductDesign: Record "Product Design Header";
        Item: Record Item;
        FGGSM: Decimal;
        ItemAttribute: Record "Item Attribute Entry";
        SubJobWeightNet: Decimal;
        SubJobWeightGross: Decimal;
        SubEstimateHeader: Record "Product Design Header";
        SalesLines: Record "Sales Line";
        SubItem: Record Item;
        TemSubJobWeightNet: Decimal;
        TemSubJobWeightGross: Decimal;
        PDComponent: Record "Product Design Component Table";
        FGGrossWeight: Decimal;
        FGNetWeight: Decimal;
        ItemM: Record Item;
        SubBoardWeightNet: Decimal;
        SubBoardWeightGross: Decimal;
        MainBoardWeightNet: Decimal;
        MainBoardWeightGross: Decimal;
        ITM_GSM: Decimal;
    begin
        // Lines added by Deepak Kumar
        ProductDesign.Reset;
        ProductDesign.SetRange(ProductDesign."Product Design Type", ProductDesign."Product Design Type"::Main);
        ProductDesign.SetRange(ProductDesign."Product Design No.", ProductDesignHeader."Product Design No.");
        if ProductDesign.FindFirst then begin
            //  REPEAT
            Item.Reset;
            Item.SetRange(Item."No.", ProductDesign."Item Code");
            if Item.FindFirst then begin
                FGGSM := 0;

                SubJobWeightNet := 0;
                SubJobWeightGross := 0;
                SubBoardWeightNet := 0;
                SubBoardWeightGross := 0;

                SubEstimateHeader.Reset;
                SubEstimateHeader.SetRange(SubEstimateHeader."Product Design Type", SubEstimateHeader."Product Design Type"::Sub);
                SubEstimateHeader.SetRange(SubEstimateHeader."Product Design No.", ProductDesign."Product Design No.");
                if SubEstimateHeader.FindFirst then begin
                    repeat
                        TemSubJobWeightNet := 0;
                        TemSubJobWeightGross := 0;
                        MfgSetup.Get;
                        MfgSetup.TestField(MfgSetup."Scrap % for Estimation");
                        SubJobWeightNet += Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader."Customer GSM" * MfgSetup."Scrap % for Estimation") / SubEstimateHeader."No. of Die Cut Ups") * SubEstimateHeader."No. of Joint") / 1000000), 0.01);

                        SubJobWeightGross += Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader.Grammage) / SubEstimateHeader."No. of Die Cut Ups") * SubEstimateHeader."No. of Joint") / 1000000), 0.01);

                        TemSubJobWeightNet := Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader."Customer GSM" * MfgSetup."Scrap % for Estimation") / SubEstimateHeader."No. of Die Cut Ups") * SubEstimateHeader."No. of Joint") / 1000000), 0.01);

                        TemSubJobWeightGross := Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader.Grammage) / SubEstimateHeader."No. of Die Cut Ups") * SubEstimateHeader."No. of Joint") / 1000000), 0.01);

                        SubBoardWeightNet := Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader."Customer GSM" * MfgSetup."Scrap % for Estimation"))) / 1000000), 0.01);

                        SubBoardWeightGross := Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader.Grammage * MfgSetup."Scrap % for Estimation"))) / 1000000), 0.01);



                        SubItem.Reset;
                        SubItem.SetRange(SubItem."No.", SubEstimateHeader."Item Code");
                        if SubItem.FindFirst then begin
                            SubItem."Gross Weight" := TemSubJobWeightGross;
                            SubItem."Net Weight" := TemSubJobWeightNet;
                            SubItem.Modify(true);
                        end;
                        PDComponent.Reset;
                        PDComponent.SetRange(PDComponent."Product Design Type", PDComponent."Product Design Type"::Sub);
                        PDComponent.SetRange(PDComponent."Product Design No.", SubEstimateHeader."Product Design No.");
                        PDComponent.SetRange(PDComponent."Sub Comp No.", SubEstimateHeader."Sub Comp No.");
                        if PDComponent.FindFirst then begin
                            repeat
                                ItemM.Reset;
                                ItemM.SetRange(ItemM."No.", PDComponent."Item No.");
                                if ItemM.FindFirst then begin
                                    ItemM."Net Weight" := SubBoardWeightNet;
                                    ItemM."Gross Weight" := SubBoardWeightGross;
                                    ItemM.Modify(true);
                                end;
                            until PDComponent.Next = 0;
                        end;


                        // SubJobWeight:=SubJobWeight+SubEstimateHeader."Per Box Weight (Gms)";
                    until SubEstimateHeader.Next = 0;
                end;
                FGGrossWeight := 0;
                FGNetWeight := 0;
                MainBoardWeightNet := 0;
                MainBoardWeightGross := 0;

                FGGrossWeight := Round(ProductDesign."Per Box Weight (Gms)", 0.01);
                Item."Gross Weight" := Round((ProductDesign."Per Box Weight (Gms)" + SubJobWeightGross), 0.01);

                ItemAttribute.Reset;
                ItemAttribute.SetRange(ItemAttribute."Item No.", ProductDesign."Item Code");
                ItemAttribute.SetRange(ItemAttribute."Item Attribute Code", 'FG_GSM');
                if ItemAttribute.FindFirst then begin
                    ItemAttribute.CalcFields(ItemAttribute."Item Attribute Value NUm");
                    FGGSM := ItemAttribute."Item Attribute Value NUm";
                    MfgSetup.Get;
                    MfgSetup.TestField(MfgSetup."Scrap % for Estimation");
                    //EVALUATE(ITM_GSM,Item."FG GSM");
                    Item."Net Weight" := Round(((((ProductDesign."Board Length (mm)- L" * ProductDesign."Board Width (mm)- W" *
                    FGGSM * MfgSetup."Scrap % for Estimation") / ProductDesign."No. of Die Cut Ups") * ProductDesign."No. of Joint") / 1000000) + SubJobWeightNet, 0.01);

                    FGNetWeight := Round(((((ProductDesign."Board Length (mm)- L" * ProductDesign."Board Width (mm)- W" *
                    FGGSM * MfgSetup."Scrap % for Estimation") / ProductDesign."No. of Die Cut Ups") * ProductDesign."No. of Joint") / 1000000), 0.01);

                    MainBoardWeightNet := Round(((((ProductDesign."Board Length (mm)- L" * ProductDesign."Board Width (mm)- W" *
                    FGGSM * MfgSetup."Scrap % for Estimation"))) / 1000000), 0.01);

                    MainBoardWeightGross := Round(((((ProductDesign."Board Length (mm)- L" * ProductDesign."Board Width (mm)- W" *
                    ProductDesign.Grammage
                     * MfgSetup."Scrap % for Estimation"))) / 1000000), 0.01);


                end else begin
                    Item."Net Weight" := 0;
                end;
                Item."Box Length" := Format(ProductDesign."Box Length (mm)- L (OD)");
                Item."Box Height" := Format(ProductDesign."Box Height (mm) - D (OD)");
                Item."Box Width" := Format(ProductDesign."Box Width (mm)- W (OD)");
                Item.Modify(true);
                PDComponent.Reset;
                PDComponent.SetRange(PDComponent."Product Design Type", PDComponent."Product Design Type"::Main);
                PDComponent.SetRange(PDComponent."Product Design No.", ProductDesign."Product Design No.");
                PDComponent.SetRange(PDComponent."Sub Comp No.", ProductDesign."Sub Comp No.");
                if PDComponent.FindFirst then begin
                    repeat
                        ItemM.Reset;
                        ItemM.SetRange(ItemM."No.", PDComponent."Item No.");
                        if ItemM.FindFirst then begin
                            ItemM."Net Weight" := MainBoardWeightNet;
                            ItemM."Gross Weight" := MainBoardWeightGross;
                            ItemM.Modify(true);
                        end;
                    until PDComponent.Next = 0;
                end;

                // Lines added By Deepak Kumar

                SalesLines.RESET;
                SalesLines.SETRANGE(SalesLines."Document Type", SalesLines."Document Type"::Order);
                SalesLines.SETRANGE(SalesLines.Type, SalesLines.Type::Item);
                SalesLines.SETRANGE(SalesLines."No.", ProductDesign."Item Code");
                SalesLines.SETRANGE(SalesLines."Estimation No.", ProductDesign."Product Design No.");
                IF SalesLines.FINDFIRST THEN BEGIN
                    REPEAT
                        SalesLines."Gross Weight" := Item."Gross Weight";
                        SalesLines."Net Weight" := Item."Net Weight";
                        SalesLines."Order Quantity (Weight)" := ROUND(SalesLines.Quantity * (SalesLines."Net Weight" / 1000), 0.00001);
                        SalesLines."Outstanding  Quantity (Weight)" := ROUND((SalesLines."Quantity (Base)" - SalesLines."Qty. Shipped (Base)") * (SalesLines."Net Weight" / 1000), 0.00001);
                        SalesLines.MODIFY(TRUE);
                    UNTIL SalesLines.NEXT = 0;
                END;


            end;
            // UNTIL ProductDesign.NEXT=0;
        end;

    end;

    procedure UpdateWeightinItemNEW(ProductDesignHeader: Code[50])
    var
        ProductDesign: Record "Product Design Header";
        Item: Record Item;
        FGGSM: Decimal;
        ItemAttribute: Record "Item Attribute Entry";
        SubJobWeightNet: Decimal;
        SubJobWeightGross: Decimal;
        SubEstimateHeader: Record "Product Design Header";
        SalesLines: Record "Sales Line";
        SubItem: Record Item;
        TemSubJobWeightNet: Decimal;
        TemSubJobWeightGross: Decimal;
        PDComponent: Record "Product Design Component Table";
        FGGrossWeight: Decimal;
        FGNetWeight: Decimal;
        ItemM: Record Item;
        SubBoardWeightNet: Decimal;
        SubBoardWeightGross: Decimal;
        MainBoardWeightNet: Decimal;
        MainBoardWeightGross: Decimal;
    begin
        // Lines added by Deepak Kumar
        ProductDesign.Reset;
        ProductDesign.SetRange(ProductDesign."Product Design Type", ProductDesign."Product Design Type"::Main);
        ProductDesign.SetRange(ProductDesign."Product Design No.", ProductDesignHeader);
        if ProductDesign.FindFirst then begin
            //  REPEAT
            Item.Reset;
            Item.SetRange(Item."No.", ProductDesign."Item Code");
            if Item.FindFirst then begin
                FGGSM := 0;

                SubJobWeightNet := 0;
                SubJobWeightGross := 0;
                SubBoardWeightNet := 0;
                SubBoardWeightGross := 0;

                SubEstimateHeader.Reset;
                SubEstimateHeader.SetRange(SubEstimateHeader."Product Design Type", SubEstimateHeader."Product Design Type"::Sub);
                SubEstimateHeader.SetRange(SubEstimateHeader."Product Design No.", ProductDesign."Product Design No.");
                if SubEstimateHeader.FindFirst then begin
                    repeat
                        TemSubJobWeightNet := 0;
                        TemSubJobWeightGross := 0;
                        MfgSetup.Get;
                        MfgSetup.TestField(MfgSetup."Scrap % for Estimation");
                        SubJobWeightNet += Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader."Customer GSM" * MfgSetup."Scrap % for Estimation") / SubEstimateHeader."No. of Die Cut Ups") * SubEstimateHeader."No. of Joint") / 1000000), 0.01);

                        SubJobWeightGross += Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader.Grammage * MfgSetup."Scrap % for Estimation") / SubEstimateHeader."No. of Die Cut Ups") * SubEstimateHeader."No. of Joint") / 1000000), 0.01);

                        TemSubJobWeightNet := Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader."Customer GSM" * MfgSetup."Scrap % for Estimation") / SubEstimateHeader."No. of Die Cut Ups") * SubEstimateHeader."No. of Joint") / 1000000), 0.01);

                        TemSubJobWeightGross := Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader.Grammage * MfgSetup."Scrap % for Estimation") / SubEstimateHeader."No. of Die Cut Ups") * SubEstimateHeader."No. of Joint") / 1000000), 0.01);

                        SubBoardWeightNet := Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader."Customer GSM" * MfgSetup."Scrap % for Estimation"))) / 1000000), 0.01);

                        SubBoardWeightGross := Round(((((SubEstimateHeader."Board Length (mm)- L" * SubEstimateHeader."Board Width (mm)- W" *
                        SubEstimateHeader.Grammage * MfgSetup."Scrap % for Estimation"))) / 1000000), 0.01);



                        SubItem.Reset;
                        SubItem.SetRange(SubItem."No.", SubEstimateHeader."Item Code");
                        if SubItem.FindFirst then begin
                            SubItem."Gross Weight" := TemSubJobWeightGross;
                            SubItem."Net Weight" := TemSubJobWeightNet;
                            SubItem.Modify(true);
                        end;
                        PDComponent.Reset;
                        PDComponent.SetRange(PDComponent."Product Design Type", PDComponent."Product Design Type"::Sub);
                        PDComponent.SetRange(PDComponent."Product Design No.", SubEstimateHeader."Product Design No.");
                        PDComponent.SetRange(PDComponent."Sub Comp No.", SubEstimateHeader."Sub Comp No.");
                        if PDComponent.FindFirst then begin
                            repeat
                                ItemM.Reset;
                                ItemM.SetRange(ItemM."No.", PDComponent."Item No.");
                                if ItemM.FindFirst then begin
                                    ItemM."Net Weight" := SubBoardWeightNet;
                                    ItemM."Gross Weight" := SubBoardWeightGross;
                                    ItemM.Modify(true);
                                end;
                            until PDComponent.Next = 0;
                        end;


                        // SubJobWeight:=SubJobWeight+SubEstimateHeader."Per Box Weight (Gms)";
                    until SubEstimateHeader.Next = 0;
                end;
                FGGrossWeight := 0;
                FGNetWeight := 0;
                MainBoardWeightNet := 0;
                MainBoardWeightGross := 0;

                FGGrossWeight := Round(ProductDesign."Per Box Weight (Gms)", 0.01);
                Item."Gross Weight" := Round((ProductDesign."Per Box Weight (Gms)" + SubJobWeightGross), 0.01);

                ItemAttribute.Reset;
                ItemAttribute.SetRange(ItemAttribute."Item No.", ProductDesign."Item Code");
                ItemAttribute.SetRange(ItemAttribute."Item Attribute Code", 'FG_GSM');
                if ItemAttribute.FindFirst then begin
                    ItemAttribute.CalcFields(ItemAttribute."Item Attribute Value NUm");
                    FGGSM := ItemAttribute."Item Attribute Value NUm";
                    MfgSetup.Get;
                    MfgSetup.TestField(MfgSetup."Scrap % for Estimation");
                    Item."Net Weight" := Round(((((ProductDesign."Board Length (mm)- L" * ProductDesign."Board Width (mm)- W" *
                    FGGSM * MfgSetup."Scrap % for Estimation") / ProductDesign."No. of Die Cut Ups") * ProductDesign."No. of Joint") / 1000000) + SubJobWeightNet, 0.01);

                    FGNetWeight := Round(((((ProductDesign."Board Length (mm)- L" * ProductDesign."Board Width (mm)- W" *
                    FGGSM * MfgSetup."Scrap % for Estimation") / ProductDesign."No. of Die Cut Ups") * ProductDesign."No. of Joint") / 1000000), 0.01);

                    MainBoardWeightNet := Round(((((ProductDesign."Board Length (mm)- L" * ProductDesign."Board Width (mm)- W" *
                    FGGSM * MfgSetup."Scrap % for Estimation"))) / 1000000), 0.01);

                    MainBoardWeightGross := Round(((((ProductDesign."Board Length (mm)- L" * ProductDesign."Board Width (mm)- W" *
                    ProductDesign.Grammage
                     * MfgSetup."Scrap % for Estimation"))) / 1000000), 0.01);


                end else begin
                    Item."Net Weight" := 0;
                end;
                Item.Modify(true);
                PDComponent.Reset;
                PDComponent.SetRange(PDComponent."Product Design Type", PDComponent."Product Design Type"::Main);
                PDComponent.SetRange(PDComponent."Product Design No.", ProductDesign."Product Design No.");
                PDComponent.SetRange(PDComponent."Sub Comp No.", ProductDesign."Sub Comp No.");
                if PDComponent.FindFirst then begin
                    repeat
                        ItemM.Reset;
                        ItemM.SetRange(ItemM."No.", PDComponent."Item No.");
                        if ItemM.FindFirst then begin
                            ItemM."Net Weight" := MainBoardWeightNet;
                            ItemM."Gross Weight" := MainBoardWeightGross;
                            ItemM.Modify(true);
                        end;
                    until PDComponent.Next = 0;
                end;

                // Lines added By Deepak Kumar
                /*
                SalesLines.RESET;
                SalesLines.SETRANGE(SalesLines.Type,SalesLines.Type::Item);
                SalesLines.SETRANGE(SalesLines."No.",ProductDesign."Item Code");
                IF SalesLines.FINDFIRST THEN BEGIN
                  REPEAT
                      SalesLines."Gross Weight":=Item."Gross Weight  (Gms)";
                      SalesLines."Net Weight":=Item."Net Weight (Gms) Customer";
                      SalesLines."Order Quantity (Weight)":=ROUND(SalesLines.Quantity * (SalesLines."Net Weight"/1000),0.00001);
                        SalesLines."Outstanding  Quantity (Weight)":=ROUND((SalesLines."Quantity (Base)" - SalesLines."Qty. Shipped (Base)") * (SalesLines."Net Weight"/1000),0.00001);
                      SalesLines.MODIFY(TRUE);
                  UNTIL SalesLines.NEXT=0;
                END;
                */

            end;
            // UNTIL ProductDesign.NEXT=0;
        end;

    end;

    procedure CreateDie2(ProductDesignHeader: Record "Product Design Header")
    var
        Fasetup: Record "FA Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TempItemCode: Code[20];
        TempItemCod1: Code[10];
        FAMaster: Record "Fixed Asset";
        FADepreciationBook: Record "FA Depreciation Book";
    begin
        // Lines added by Deepak Kumar
        if ProductDesignHeader."Die Punching" = true then begin

            ItemMaster.Reset;
            ItemMaster.SetRange(ItemMaster."No.", ProductDesignHeader."Item Code");
            if ItemMaster.FindFirst then begin
                if ItemMaster."Die Number 2" = '' then begin
                    FAMaster.Init;

                    MfgSetup.Get;
                    MfgSetup.TestField("Die No. Series");
                    NoSeriesMgt.InitSeries(MfgSetup."Die No. Series", '', 0D, TempItemCode, TempItemCod1);
                    FAMaster."No." := TempItemCode;
                    FAMaster."FG Item Number" := ItemMaster."No.";
                    if ItemMaster."Mother Job No." <> '' then begin
                        FAMaster."Mother Job No." := ItemMaster."Mother Job No."
                    end else begin
                        FAMaster."Mother Job No." := ProductDesignHeader."Production Order No.";
                        FAMaster."Mother Job Quantity" := "Quantity to Job Order";
                    end;

                    FAMaster.Description := 'Die ' + ItemMaster."No." + ' ' + FAMaster."Mother Job No.";
                    FAMaster."Customer's Name" := ProductDesignHeader.Name;
                    FAMaster."Curr Prod. Order Desc." := ProductDesignHeader."Item Description";

                    FAMaster.Die := true;
                    FAMaster."Ready to Use" := false;
                    FAMaster."Replace Die/Plate" := false;
                    FAMaster."FA Class Code" := 'TOOL_EQUI';
                    FAMaster."Estimate No." := ProductDesignHeader."Product Design No.";
                    FAMaster.Insert(true);

                    FADepreciationBook.Init;
                    FADepreciationBook."FA No." := FAMaster."No.";
                    FADepreciationBook."Depreciation Book Code" := 'COMPANY';
                    FADepreciationBook."Depreciation Method" := FADepreciationBook."Depreciation Method"::"Straight-Line";
                    FADepreciationBook."FA Posting Group" := 'TOOL_EQUI';
                    FADepreciationBook.Insert(true);


                    ItemMaster."Die Number" := TempItemCode;
                    ItemMaster.Modify(true);
                    ProductDesignHeader."Die Number 2" := TempItemCode;
                    ProductDesignHeader.Modify(true);
                end;
            end;
        end;
    end;

    procedure CreatePlateItem2(ProductDesignHeader: Record "Product Design Header")
    var
        ItemM: Record Item;
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TempItemCode: Code[20];
        TempItemCod1: Code[10];
        ItemVariant: Record "Item Variant";
    begin
        // Lines added by Deepak Kumar
        if ProductDesignHeader.Printing = true then begin
            ItemMaster.Reset;
            ItemMaster.SetRange(ItemMaster."No.", ProductDesignHeader."Item Code");
            if ItemMaster.FindFirst then begin
                if ItemMaster."Plate Item No.2" = '' then begin
                    ItemM.Init;
                    MfgSetup.Get;
                    MfgSetup.TestField("Plate No. Series");
                    //  ItemMaster.TESTFIELD(ItemMaster."Mother Job No.");
                    NoSeriesMgt.InitSeries(MfgSetup."Plate No. Series", '', 0D, TempItemCode, TempItemCod1);
                    ItemM."No." := TempItemCode;
                    ItemM."FG Item No." := ItemMaster."No.";
                    ItemM.Description := 'Plate - ' + ItemMaster."No." + ' ' + ItemMaster."Mother Job No.";
                    ItemM."Customer's Name(Curr. Prod)" := Name;
                    ItemM."Curr Prod. Order Desc." := ProductDesignHeader."Item Description";
                    ItemM."Customer No." := ProductDesignHeader.Customer;
                    ItemM."Customer Name" := ProductDesignHeader.Name;
                    ItemM."Estimate No." := ProductDesignHeader."Product Design No.";
                    ItemM."Ready for Print" := false;
                    ItemM."Artwork Availabe" := ProductDesignHeader."Artwork Available";
                    ItemM."Replace Plate" := false;
                    ItemM."Req. For Purchase" := false;
                    ItemM."Plate Item" := true;
                    ItemM."Inventory Value Zero" := true;
                    ItemM."No. of Ply" := ItemMaster."No. of Ply";
                    if ItemMaster."Mother Job No." <> '' then begin
                        ItemM."Mother Job No." := ItemMaster."Mother Job No."
                    end else begin
                        ItemM."Mother Job No." := ProductDesignHeader."Production Order No.";
                    end;
                    ItemM.Insert(true);
                    ItemM.Validate(ItemM."Item Category Code", 'Plate_Film');
                    ItemM.Validate("Base Unit of Measure", 'Set');
                    ItemM."No. of Ply" := ItemMaster."No. of Ply";


                    ItemM.Modify(true);
                    ItemVariant.Init;
                    ItemVariant."Item No." := ItemM."No.";
                    ItemVariant.Code := ItemM."No.";
                    ItemVariant.Description := 'Plate - ' + ItemMaster."Mother Job No.";
                    ItemVariant."Active Variant" := true;
                    ItemVariant.Insert(true);
                    Message('Plate created for the Item No. %1 . Plate No. %2', ItemMaster."No.", ItemM."No.");

                    ItemMaster."Plate Item No.2" := ItemM."No.";
                    ItemMaster.Modify(true);
                    ProductDesignHeader."Plate Item No. 2" := ItemM."No.";
                    ProductDesignHeader.Modify(true);
                end;
            end;
        end;
    end;

    procedure UpdateGSMIdentifier(ProductDesignCode: Code[50])
    var
        TempGSMTypeIdentifier: Code[200];
        TempDeckleSize: Decimal;
        ProductDesignHeader: Record "Product Design Header";
        ProductDesignLine: Record "Product Design Line";
    begin
        // Lines added By Deepak Kumar

        ProductDesignHeader.Reset;
        ProductDesignHeader.SetRange(ProductDesignHeader."Product Design Type", ProductDesignHeader."Product Design Type"::Main);
        ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", ProductDesignCode);
        if ProductDesignHeader.FindFirst then begin
            ProductDesignLine.Reset;
            ProductDesignLine.SetRange(ProductDesignLine."Product Design Type", ProductDesignHeader."Product Design Type");
            ProductDesignLine.SetRange(ProductDesignLine."Product Design No.", ProductDesignHeader."Product Design No.");
            ProductDesignLine.SetRange(ProductDesignLine.Type, ProductDesignLine.Type::Item);
            if ProductDesignLine.FindFirst then begin
                TempGSMTypeIdentifier := '';
                repeat
                    if ProductDesignLine."No." <> '' then begin

                        ItemMaster.Get(ProductDesignLine."No.");
                        TempGSMTypeIdentifier := TempGSMTypeIdentifier + Format(ItemMaster."Paper GSM") + ItemMaster."Paper Type";
                    end;
                until ProductDesignLine.Next = 0;
                ProductDesignHeader.PaperCombination := TempGSMTypeIdentifier;
                ProductDesignHeader.Modify(true);
            end;
        end;
    end;

    procedure CopyProductDesign(FromEstimate: Code[50]; ToEstimate: Code[50])
    var
        FromEstimateHeader: Record "Product Design Header";
        fromEstimateLine: Record "Product Design Line";
        ToEstimateHeader: Record "Product Design Header";
        ToEstimateLine: Record "Product Design Line";
        Question: Text[250];
        Answer: Boolean;
        ProductDesignSpecialDescripFrom: Record "Product Design Special Descrip";
        ProductDesignSpecialDescripTo: Record "Product Design Special Descrip";
    begin
        // Lines added BY Deepak Kumar

        Answer := DIALOG.Confirm(('Do you want to copy from Product Design ' + FromEstimate + ' to Product Design No. ' + ToEstimate), true);

        Templine[1] := '';
        Templine[2] := '';
        Templine[3] := '';
        Templine[4] := '';
        Templine[5] := '';
        Templine[6] := '';
        Templine[7] := '';
        TempInte[1] := 0;
        TempInte[2] := 0;
        Templine[8] := '';

        if Answer = true then begin

            FromEstimateHeader.Reset;
            FromEstimateHeader.SetRange(FromEstimateHeader."Product Design Type", FromEstimateHeader."Product Design Type"::Main);
            FromEstimateHeader.SetRange(FromEstimateHeader."Product Design No.", FromEstimate);
            if FromEstimateHeader.FindFirst then begin
                ToEstimateHeader.Reset;
                ToEstimateHeader.SetRange(ToEstimateHeader."Product Design Type", ToEstimateHeader."Product Design Type"::Main);
                ToEstimateHeader.SetRange(ToEstimateHeader."Product Design No.", ToEstimate);
                ToEstimateHeader.FindFirst;


                Templine[1] := ToEstimateHeader.Customer;
                Templine[2] := ToEstimateHeader.Contact;
                Templine[3] := ToEstimateHeader."Sales Person Code";
                Templine[4] := ToEstimateHeader."Sales Quote No.";
                Templine[5] := ToEstimateHeader."Sales Order No.";
                Templine[6] := ToEstimateHeader."Item Code";
                Templine[7] := ToEstimateHeader."Item Description";
                TempInte[1] := ToEstimateHeader."Sales Quote Line Number";
                TempInte[2] := ToEstimateHeader."No. of Ply";
                Templine[8] := FromEstimate;

                ToEstimateHeader.TransferFields(FromEstimateHeader, false);
                // ToEstimateHeader.Status:=ToEstimateHeader.Status::Open;
                ToEstimateHeader.Customer := Templine[1];
                ToEstimateHeader.Contact := Templine[2];
                ToEstimateHeader."Sales Person Code" := Templine[3];
                ToEstimateHeader."Sales Quote No." := Templine[4];
                ToEstimateHeader."Sales Order No." := Templine[5];
                ToEstimateHeader."Sales Quote Line Number" := TempInte[1];
                ToEstimateHeader."No. of Ply" := TempInte[2];
                ToEstimateHeader."Item Code" := Templine[6];
                ToEstimateHeader."Item Description" := Templine[7];
                ToEstimateHeader.Status := 0;
                ToEstimateHeader."Pre-Press Status" := ToEstimateHeader."Pre-Press Status"::" ";
                ToEstimateHeader."Pre-Press Confirmed By" := '';
                ToEstimateHeader."Production Status" := ToEstimateHeader."Production Status"::" ";
                ToEstimateHeader."Production Confirmed By" := '';
                ToEstimateHeader."Old Estimate No." := Templine[8];
                ToEstimateHeader.Modify(true);
                //Line added by sadaf
                if ToEstimateHeader."Old Estimate No." <> '' then
                    PDesignHeader.Reset;
                PDesignHeader.SetRange(PDesignHeader."Product Design No.", ToEstimateHeader."Old Estimate No.");
                if PDesignHeader.FindFirst then begin
                    PDesignHeader.Status := PDesignHeader.Status::Blocked;
                    PDesignHeader.Modify(true);
                    iTem.Reset;
                    iTem.SetRange(iTem."Estimate No.", PDesignHeader."Product Design No.");
                    iTem.SetRange(iTem."No.", PDesignHeader."Item Code");
                    if iTem.FindFirst then begin
                        iTem.Blocked := true;
                        iTem.Modify(true);
                    end;
                end;



                // Update Estimate Line
                ToEstimateLine.Reset;
                ToEstimateLine.SetRange(ToEstimateLine."Product Design No.", ToEstimate);
                ToEstimateLine.DeleteAll;
                fromEstimateLine.Reset;
                fromEstimateLine.SetRange(fromEstimateLine."Product Design Type", fromEstimateLine."Product Design Type"::Main);
                fromEstimateLine.SetRange(fromEstimateLine."Product Design No.", FromEstimate);
                if fromEstimateLine.FindFirst then begin
                    repeat
                        ToEstimateLine.Init;
                        ToEstimateLine := fromEstimateLine;
                        ToEstimateLine."Product Design No." := ToEstimate;
                        ToEstimateLine.Insert(true);
                    until fromEstimateLine.Next = 0;
                end;
            end;
            FromEstimateHeader.Reset;
            FromEstimateHeader.SetRange(FromEstimateHeader."Product Design No.", FromEstimate);
            FromEstimateHeader.SetRange(FromEstimateHeader."Product Design Type", FromEstimateHeader."Product Design Type"::Sub);
            if FromEstimateHeader.FindFirst then begin
                repeat
                    ToEstimateHeader.Init;
                    ToEstimateHeader."Product Design Type" := ToEstimateHeader."Product Design Type"::Sub;
                    ToEstimateHeader."Product Design No." := ToEstimate;
                    ToEstimateHeader."Sub Comp No." := FromEstimateHeader."Sub Comp No.";
                    ToEstimateHeader.Insert(true);

                    ToEstimateHeader.TransferFields(FromEstimateHeader, false);
                    ToEstimateHeader.Customer := Templine[1];
                    ToEstimateHeader.Contact := Templine[2];
                    ToEstimateHeader."Sales Person Code" := Templine[3];
                    ToEstimateHeader."Sales Quote No." := Templine[4];
                    ToEstimateHeader."Sales Order No." := Templine[5];
                    ToEstimateHeader."Sales Quote Line Number" := TempInte[1];
                    ToEstimateHeader."No. of Ply" := TempInte[2];
                    ToEstimateHeader."Item Code" := Templine[6];
                    ToEstimateHeader."Item Description" := Templine[7];
                    ToEstimateHeader.Status := 0;
                    ToEstimateHeader.Modify(true);

                    ToEstimateLine.Reset;
                    ToEstimateLine.SetRange(ToEstimateLine."Product Design Type", FromEstimateHeader."Product Design Type");
                    ToEstimateLine.SetRange(ToEstimateLine."Product Design No.", ToEstimate);
                    ToEstimateLine.SetRange(ToEstimateLine."Sub Comp No.", FromEstimateHeader."Sub Comp No.");
                    ToEstimateLine.DeleteAll;

                    fromEstimateLine.Reset;
                    fromEstimateLine.SetRange(fromEstimateLine."Product Design Type", FromEstimateHeader."Product Design Type");
                    fromEstimateLine.SetRange(fromEstimateLine."Product Design No.", FromEstimateHeader."Product Design No.");
                    fromEstimateLine.SetRange(fromEstimateLine."Sub Comp No.", FromEstimateHeader."Sub Comp No.");
                    if fromEstimateLine.FindFirst then begin
                        repeat
                            ToEstimateLine.Init;
                            ToEstimateLine := fromEstimateLine;
                            ToEstimateLine."Product Design No." := ToEstimate;
                            ToEstimateLine.Insert(true);
                        until fromEstimateLine.Next = 0;
                    end;
                until FromEstimateHeader.Next = 0;
            end;

            ProductDesignSpecialDescripFrom.Reset;
            ProductDesignSpecialDescripFrom.SetRange(ProductDesignSpecialDescripFrom."No.", FromEstimate);
            if ProductDesignSpecialDescripFrom.FindFirst then begin
                repeat
                    ProductDesignSpecialDescripTo.Init;
                    ProductDesignSpecialDescripTo := ProductDesignSpecialDescripFrom;
                    ProductDesignSpecialDescripTo."No." := ToEstimate;
                    ProductDesignSpecialDescripTo.Insert(true);
                until ProductDesignSpecialDescripFrom.Next = 0;
            end;


            Message('Complete');
        end else begin
            Message('Activity declined by User!');
        end;
    end;
}

