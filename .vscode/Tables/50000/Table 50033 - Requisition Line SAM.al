table 50033 "Requisition Line SAM"
{
    // version Requisition


    fields
    {
        field(1; "Requisition No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Requisition Line No."; Integer)
        {
            Editable = false;
        }
        field(3; "Production Schedule No."; Code[20])
        {
        }
        field(4; "Schedule Prod. Order"; Code[20])
        {
            TableRelation = "Production Schedule Line"."Prod. Order No." WHERE ("Schedule No." = FIELD ("Production Schedule No."),
                                                                                Published = CONST (true));

            trigger OnValidate()
            var
                ProductionScheduleLine: Record "Production Schedule Line";
            begin
                // Lines added By Deepak Kumar
                ProductionScheduleLine.Reset;
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", "Production Schedule No.");
                ProductionScheduleLine.SetRange(ProductionScheduleLine."Prod. Order No.", "Schedule Prod. Order");
                if ProductionScheduleLine.FindFirst then begin
                    Validate("Prod. Order No", ProductionScheduleLine."Prod. Order No.");
                    Validate("Prod. Order Line No.", ProductionScheduleLine."Prod. Order Line No.");
                end;
            end;
        }
        field(7; "Prod. Order No"; Code[20])
        {
            TableRelation = "Production Order"."No." WHERE (Status = CONST (Released));

            trigger OnValidate()
            begin
                // Lines added by deepak Kumar
            end;
        }
        field(8; "Prod. Order Line No."; Integer)
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status = CONST (Released),
                                                                 "Prod. Order No." = FIELD ("Prod. Order No"));
        }
        field(9; "Prod. Order Comp. Line No"; Integer)
        {
        }
        field(10; "Item No."; Code[20])
        {
            TableRelation = Item."No." WHERE (Blocked = CONST (false));

            trigger OnValidate()
            begin
                // Lines added bY Deepak Kumar
                ItemMaster.Reset;
                ItemMaster.SetRange(ItemMaster."No.", "Item No.");
                if ItemMaster.FindFirst then begin
                    Description := ItemMaster.Description;
                    "Unit Of Measure" := ItemMaster."Base Unit of Measure";

                    "Paper GSM" := ItemMaster."Paper GSM";
                    "Item Category Code" := ItemMaster."Item Category Code";
                    // GSMType:= ItemMaster.PaperGSMType;
                    "Deckle Size(mm)" := ItemMaster."Deckle Size (mm)";
                    if xRec."Paper GSM" > 1 then
                        Validate(Quantity, (Quantity / xRec."Paper GSM") * "Paper GSM")
                    else
                        Validate(Quantity, (Quantity / 1) * "Paper GSM");



                    if ItemMaster."Item Category Code" = 'DUPLEX_PAP' then begin
                        ItemAttributeEntry.Reset;
                        ItemAttributeEntry.SetRange(ItemAttributeEntry."Item No.", "Item No.");
                        ItemAttributeEntry.SetFilter(ItemAttributeEntry."Item Attribute Code", 'DUPLEX_LENGTH');
                        if ItemAttributeEntry.FindFirst then begin
                            AttributeValue.Reset;
                            AttributeValue.SetRange(AttributeValue."Attribute Code", ItemAttributeEntry."Item Attribute Code");
                            AttributeValue.SetRange(AttributeValue."Attribute Value", ItemAttributeEntry."Item Attribute Value");
                            if AttributeValue.FindFirst then begin
                                "Length of Board (CM)" := AttributeValue."Attribute Value Numreric";
                            end;
                        end;
                        ItemAttributeEntry.Reset;
                        ItemAttributeEntry.SetRange(ItemAttributeEntry."Item No.", "Item No.");
                        ItemAttributeEntry.SetFilter(ItemAttributeEntry."Item Attribute Code", 'DUPLEX_WIDTH');
                        if ItemAttributeEntry.FindFirst then begin
                            Message('DUPLEX_WIDTH' + ItemAttributeEntry."Item Attribute Value");
                            AttributeValue.Reset;
                            AttributeValue.SetRange(AttributeValue."Attribute Code", ItemAttributeEntry."Item Attribute Code");
                            AttributeValue.SetRange(AttributeValue."Attribute Value", ItemAttributeEntry."Item Attribute Value");
                            if AttributeValue.FindFirst then begin
                                "Width of Board (CM)" := AttributeValue."Attribute Value Numreric";
                            end;
                        end;
                    end;
                end;
                // Lines updated By Deepak Kumar
                RequisitionHeader.Reset;
                RequisitionHeader.SetRange(RequisitionHeader."Requisition No.", "Requisition No.");
                RequisitionHeader.SetRange(RequisitionHeader."Requisition Type", RequisitionHeader."Requisition Type"::"Production Order");
                if RequisitionHeader.FindFirst then begin
                    RequisitionHeader.TestField(RequisitionHeader."Prod. Order No");
                    RequisitionHeader.TestField(RequisitionHeader."Prod. Order Line No.");
                    "Prod. Order No" := RequisitionHeader."Prod. Order No";
                    "Prod. Order Line No." := RequisitionHeader."Prod. Order Line No.";
                end;
            end;
        }
        field(11; Description; Text[250])
        {
        }
        field(12; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                UpdateQuantity;
            end;
        }
        field(13; "Unit Of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(14; "Requested Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Requested Date" < WorkDate then
                    Error('You can not request before Work Date');
            end;
        }
        field(15; "Remaining Quantity"; Decimal)
        {
            Editable = false;
        }
        field(16; "Short Closed Quantity"; Decimal)
        {
            Editable = false;
        }
        field(17; "Short Closed"; Boolean)
        {
            Editable = false;
        }
        field(18; "Issued Quantity"; Decimal)
        {
            CalcFormula = - Sum ("Item Ledger Entry".Quantity WHERE ("Item No." = FIELD ("Item No."),
                                                                   "Requisition No." = FIELD ("Requisition No."),
                                                                   "Requisition Line No." = FIELD ("Requisition Line No."),
                                                                   Quantity = FILTER (< 0),
                                                                   "Entry Type" = FILTER (<> Transfer)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Quantity to Purchase"; Decimal)
        {
        }
        field(20; "Transfer Quantity"; Decimal)
        {
            CalcFormula = - Sum ("Item Ledger Entry".Quantity WHERE ("Item No." = FIELD ("Item No."),
                                                                   "Requisition No." = FIELD ("Requisition No."),
                                                                   "Requisition Line No." = FIELD ("Requisition Line No."),
                                                                   Quantity = FILTER (< 0),
                                                                   "Entry Type" = CONST (Transfer)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Offset Printing"; Boolean)
        {
            Editable = false;
        }
        field(51; "Paper GSM"; Decimal)
        {

            trigger OnValidate()
            begin
                //Deepak 25 04 15
                TestField("Offset Printing");
            end;
        }
        field(52; "Length of Board (CM)"; Decimal)
        {

            trigger OnValidate()
            begin
                //Deepak 25 04 15
                TestField("Offset Printing");
            end;
        }
        field(53; "Width of Board (CM)"; Decimal)
        {

            trigger OnValidate()
            begin
                //Deepak 25 04 15
                TestField("Offset Printing");
            end;
        }
        field(54; "Quantity In PCS"; Decimal)
        {

            trigger OnValidate()
            begin
                //Deepak 25 04 15
                TestField("Offset Printing");
                CalcDuplexPaperWeight;
            end;
        }
        field(55; "Make Ready Qty"; Decimal)
        {

            trigger OnValidate()
            begin
                //Deepak 25 04 15
                TestField("Offset Printing");
                CalcDuplexPaperWeight;
            end;
        }
        field(70; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(71; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(121; "Marked Purchase Requisition"; Boolean)
        {
            Editable = false;
        }
        field(201; "Extra Material"; Boolean)
        {
            Editable = false;
        }
        field(202; "Paper Position"; Option)
        {
            Editable = true;
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(203; GSMType; Text[20])
        {
            Editable = false;
        }
        field(204; "Deckle Size(mm)"; Decimal)
        {
        }
        field(205; "Validate Origin"; Boolean)
        {
        }
        field(206; "Part Code"; Option)
        {
            OptionMembers = " ","Part -A","Part -B";
        }
        field(207; "Make Ready Posted"; Boolean)
        {
            Editable = false;
        }
        field(208; "Line Remark"; Text[150])
        {
        }
        field(1001; "Temp Line"; Boolean)
        {
            Editable = false;
        }
        field(70000; "Item Category Code"; Code[10])
        {
            CaptionML = ENU = 'Item Category Code';
            Editable = false;
            TableRelation = "Item Category";
        }
        field(70001; "Alternative item by Store"; Code[20])
        {
            TableRelation = Item."No." WHERE ("Item Category Code" = FIELD ("Item Category Code"),
                                            Inventory = filter (> 0));

            trigger OnValidate()
            begin
                // Lines added by Deepak kUmar
                CalcFields("Issued Quantity");
                TestField("Issued Quantity", 0);
                ValidateStoreUser;
                "Approved by Prod." := false;
                "Approved by Store" := false;
                Published := false;
                Item.Reset;
                Item.SetRange(Item."No.", "Alternative item by Store");
                if Item.FindFirst then begin
                    "Alt. Item Store Description" := Item.Description;
                end else begin
                    "Alt. Item Store Description" := '';
                end;
            end;
        }
        field(70002; "Alt. Item Store Description"; Text[250])
        {
            Editable = false;
        }
        field(70003; "Available Inventory"; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Item No." = FIELD ("Item No.")));
            Description = 'Binay Date:27.12.15';
            FieldClass = FlowField;
        }
        field(72001; "Alternative item by Prod."; Code[20])
        {
            TableRelation = Item."No." WHERE ("Item Category Code" = FIELD ("Item Category Code"),
                                            Inventory = filter (> 0));

            trigger OnValidate()
            begin
                // Lines added by Deepak kUmar
                CalcFields("Issued Quantity");
                TestField("Issued Quantity", 0);

                ValidateProdUser;
                "Approved by Prod." := false;
                "Approved by Store" := false;
                Published := false;

                Item.Reset;
                Item.SetRange(Item."No.", "Alternative item by Prod.");
                if Item.FindFirst then begin
                    "Alt. item by Prod. Description" := Item.Description;
                end else begin
                    "Alt. item by Prod. Description" := '';
                end;
            end;
        }
        field(72002; "Alt. item by Prod. Description"; Text[250])
        {
            Editable = false;
        }
        field(73001; "Approved by Store"; Boolean)
        {
            Editable = false;
        }
        field(73002; "Approved by Prod."; Boolean)
        {
            CaptionML = ENU = 'Approved by Prod.';
            Editable = false;
        }
        field(73003; "Previous Item No"; Code[20])
        {
            Editable = false;
        }
        field(73004; "Previous Item Description"; Text[250])
        {
            Editable = false;
        }
        field(73005; "Published by"; Text[100])
        {
            Editable = false;
        }
        field(73006; Published; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Requisition No.", "Requisition Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // Lines added BY Deepak Kumar
        RequisitionHeader.ValidateStatus("Requisition No.");

        if ("Issued Quantity" > 0) or ("Short Closed Quantity" > 0) then Error('You can not delete after issue or short close');
    end;

    trigger OnInsert()
    begin
        // Lines added BY Deepak Kumar
        RequisitionHeader.ValidateStatus("Requisition No.");
        "Requested Date" := WorkDate;
    end;

    trigger OnModify()
    begin
        // Lines added BY Deepak Kumar
        RequisitionHeader.ValidateStatus("Requisition No.");
    end;

    var
        ItemMaster: Record Item;
        ReqLine: Record "Requisition Line SAM";
        RequisitionHeader: Record "Requisition Header";
        ItemAttributeEntry: Record "Item Attribute Entry";
        AttributeValue: Record "Attribute Value";
        UserSetup: Record "User Setup";
        Item: Record Item;

    procedure "--Samadhan"()
    begin
    end;

    procedure UpdateQuantity() Success: Boolean
    begin
        // Lines added by Deepak kumar
        Success := false;
        CalcFields("Issued Quantity");
        /*
        IF Quantity < ("Short Closed Quantity"+"Issued Quantity") THEN
          ERROR('The Issued Qty %1 + Short Close Qty %2 = %3 cannot exceed the Requisition Quantity %4',"Issued Quantity","Short Closed Quantity",
                "Issued Quantity"+"Short Closed Quantity",Quantity);
        */
        "Remaining Quantity" := Quantity - ("Issued Quantity" + "Short Closed Quantity");
        Success := true;
        exit(Success);

    end;

    procedure CalcDuplexPaperWeight()
    var
        TempQty: Decimal;
        TempQtyWt: Decimal;
    begin
        // Lines added BY Deepak Kumar
        TestField("Paper GSM");
        TestField("Length of Board (CM)");
        TestField("Width of Board (CM)");

        TempQty := 0;
        TempQty := "Quantity In PCS" + "Make Ready Qty";

        TempQtyWt := (((((("Length of Board (CM)" * "Width of Board (CM)") / 10000)) * "Paper GSM") / 1000) * TempQty);
        Validate(Quantity, TempQtyWt);
    end;

    procedure ValidateStoreUser()
    begin
        // Lines added BY Deepak kUmar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Store User", true);
        if not UserSetup.FindFirst then
            Error('You are not authorized user, Please contact your system Administrator');
    end;

    procedure ValidateProdUser()
    begin
        // Lines added BY Deepak kUmar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Production User", true);
        if not UserSetup.FindFirst then
            Error('You are not authorized user, Please contact your system Administrator');
    end;
}

