table 50056 "Con. Item Selection N"
{
    // version NAVW17.00

    CaptionML = ENU = 'Con. Item Selection ';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Job No.';
            NotBlank = true;
            TableRelation = Job;
        }
        field(2; "Req. Line Number"; Integer)
        {
            CaptionML = ENU = 'Job Task No.';
        }
        field(3; "G/L Account No."; Code[20])
        {
            CaptionML = ENU = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(5; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionML = ENU = 'Unit Price';
        }
        field(6; "Currency Code"; Code[10])
        {
            CaptionML = ENU = 'Currency Code';
            TableRelation = Currency;
        }
        field(7; "Unit Cost Factor"; Decimal)
        {
            CaptionML = ENU = 'Unit Cost Factor';
        }
        field(8; "Line Discount %"; Decimal)
        {
            CaptionML = ENU = 'Line Discount %';
        }
        field(9; "Unit Cost"; Decimal)
        {
            CaptionML = ENU = 'Unit Cost';
        }
        field(10; Description; Text[50])
        {
            CalcFormula = Lookup ("G/L Account".Name WHERE ("No." = FIELD ("G/L Account No.")));
            CaptionML = ENU = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "Prod. Schedule No"; Code[20])
        {
            Description = 'deepak';
            Editable = false;
            TableRelation = "Production Schedule"."Schedule No." WHERE ("Schedule Published" = CONST (true));
        }
        field(50001; "Requisition No."; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Requisition Header"."Requisition No." WHERE (Status = CONST (Released),
                                                                          "Requisition Type" = CONST ("Production Schedule"));
        }
        field(50002; "Item Code"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
            TableRelation = Item."No." WHERE (Blocked = CONST (false));

            trigger OnValidate()
            begin
                // Lines added bY Deepak Kumar
                ItemMaster.Get("Item Code");
                "Item Description" := ItemMaster.Description;
                "Paper Type" := ItemMaster."Paper Type";
                "Paper GSM" := Format(ItemMaster."Paper GSM");
                "Deckle Size (mm)" := ItemMaster."Deckle Size (mm)";
            end;
        }
        field(50003; "Roll ID"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD ("Item Code"),
                                                       "Remaining Quantity" = FILTER (<> 0));

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                ItemVariant.Reset;
                ItemVariant.SetRange(ItemVariant."Item No.", "Item Code");
                ItemVariant.SetRange(ItemVariant.Code, "Roll ID");
                if ItemVariant.FindFirst then begin
                    ItemVariant.CalcFields(ItemVariant."Remaining Quantity");
                    "Initial Roll Weight" := ItemVariant."Remaining Quantity";
                end else begin
                    Error('Roll Not Found');
                end;
            end;
        }
        field(50004; "Item Description"; Text[250])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50005; "Initial Roll Weight"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50006; "Final Roll Weight"; Decimal)
        {
            Description = 'Deepak';

            trigger OnValidate()
            begin
                // Lines added bY deepak Kumar
                TestField("Roll ID");
                if "Final Roll Weight" > "Initial Roll Weight" then
                    Error('Final Weight must not be greater than Initial Weight');

                "Quantity to Consume" := "Initial Roll Weight" - "Final Roll Weight";
            end;
        }
        field(50007; "Quantity to Consume"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50008; "Paper Position"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,Liner1-DL,Flute1-M1,Liner2-L1,Flute2-M2,Liner3-L2,Flute3-M3,Liner4-L3';
            OptionMembers = " ","Liner1-DL","Flute1-M1","Liner2-L1","Flute2-M2","Liner3-L2","Flute3-M3","Liner4-L3";

            trigger OnValidate()
            var
                RequisitionLineSAM: Record "Requisition Line SAM";
            begin

                // Lines added By Deepak Kumar
                RequisitionLineSAM.Reset;
                RequisitionLineSAM.SetRange(RequisitionLineSAM."Requisition No.", "Requisition No.");
                RequisitionLineSAM.SetRange(RequisitionLineSAM."Item No.", "Item Code");
                RequisitionLineSAM.SetRange(RequisitionLineSAM."Paper Position", "Paper Position");
                if RequisitionLineSAM.FindFirst then begin
                    "Req. Line Number" := RequisitionLineSAM."Requisition Line No.";
                end;//ELSE
                    //ERROR('There is no Requisition Line for Item Number %1 Paper Position %2',"Item Code","Paper Position");
            end;
        }
        field(50009; "Item Identifier"; Code[50])
        {
            CaptionML = ENU = 'Item Identifier ( Bar Code)';
            Description = 'For Bar Code Purpose';

            trigger OnValidate()
            var
                ItemIdentifier: Record "Item Identifier";
            begin
                // Lines added BY Deepak Kumar
                ItemIdentifier.Reset;
                ItemIdentifier.SetRange(ItemIdentifier.Code, "Item Identifier");
                if ItemIdentifier.FindFirst then begin

                    if ItemIdentifier."Variant Code" <> '' then begin
                        ItemVariant.Reset;
                        ItemVariant.SetRange(ItemVariant."Item No.", ItemIdentifier."Item No.");
                        ItemVariant.SetRange(ItemVariant.Code, ItemIdentifier."Variant Code");
                        if ItemVariant.FindFirst then begin
                            if ItemVariant.Status <> ItemVariant.Status::Open then
                                Error('Roll is not in Use Status, Please Complete the Quality Process');
                        end;
                        //VALIDATE("Item Code",ItemIdentifier."Item No.");
                        Validate("Roll ID", ItemIdentifier."Variant Code");
                    end else begin
                        //VALIDATE("Item Code",ItemIdentifier."Item No.");
                        Error('Roll entry not available');
                    end;
                    Modify(true);
                end else begin
                    Error('Item Identifier not available, please check the Identifier values');
                end;
            end;
        }
        field(50010; "Line Number"; Integer)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50011; "Additional Line"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50012; "Vendor Roll Number"; Code[100])
        {
            CalcFormula = Lookup ("Item Variant"."MILL Reel No." WHERE ("Item No." = FIELD ("Item Code"),
                                                                       Code = FIELD ("Roll ID")));
            Description = 'Deepak';
            FieldClass = FlowField;
        }
        field(50021; "Paper Type"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50022; "Paper GSM"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50023; "Deckle Size (mm)"; Decimal)
        {
            Description = 'Deepak';
            Editable = false;
            MinValue = 0;
        }
        field(50024; "Applied Quantity"; Decimal)
        {
            CalcFormula = Sum ("Cons. Prod. Order Selection"."Qty to be Post" WHERE ("Prod. Schedule No" = FIELD ("Prod. Schedule No"),
                                                                                    "Requisition No." = FIELD ("Requisition No."),
                                                                                    "Item Code" = FIELD ("Item Code"),
                                                                                    "Variant Code/ Reel Number" = FIELD ("Roll ID"),
                                                                                    "Paper Position(Item)" = FIELD ("Paper Position")));
            Description = 'Deepak';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Prod. Schedule No", "Line Number")
        {
        }
        key(Key2; "Prod. Schedule No", "Req. Line Number", "Line Number")
        {

        }
    }

    fieldgroups
    {
    }

    var
        Job: Record Job;
        JT: Record "Job Task";
        ItemMaster: Record Item;
        ItemVariant: Record "Item Variant";

    procedure GetJob()
    begin
        TestField("Document No.");
        Job.Get("Document No.");
    end;
}

