table 50010 "Item Creation Buffer"
{
    // version Item Wizard Samadhan


    fields
    {
        field(1; "Item Category Code"; Code[10])
        {
            TableRelation = "Item Category".Code;

            trigger OnValidate()
            var
                ItemCategoryCode: Record "Item Category";
            begin
                // Lines added By Deepak Kumar
                ItemCategoryCode.Reset;
                ItemCategoryCode.SetRange(ItemCategoryCode.Code, "Item Category Code");
                if ItemCategoryCode.FindFirst then begin
                    "Item Category UID" := ItemCategoryCode."IC Code";
                end else begin
                    "Item Category UID" := 0;
                end;
            end;
        }
        field(2; "Item Attribute Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Attribute Master"."Attribute Code";

            trigger OnValidate()
            var
                AttributeMaster: Record "Attribute Master";
            begin
                // Lines Added By Deepak Kumar
                AttributeMaster.Reset;
                AttributeMaster.SetRange(AttributeMaster."Attribute Code", "Item Attribute Code");
                if AttributeMaster.FindFirst then begin
                    "Item Attribute Caption" := AttributeMaster."Attribute Description";
                    "Add on Des. (Postfix)" := AttributeMaster."Add on Des. (Postfix)";
                    "Add on Des. (Prefix)" := AttributeMaster."Add on Des. (Prefix)";
                    "Caption show in Description" := AttributeMaster."Suffix Add on Description";
                    Validate(Master, AttributeMaster.Master);
                    Validate("Master List", AttributeMaster."Master List");
                    Validate("Attribute Code UID", AttributeMaster."Attribute UID");
                end
                else
                    Error('Item Attribute Code not found');
            end;
        }
        field(4; "Item Attribute Caption"; Text[100])
        {
            Editable = false;
        }
        field(5; "Attribute Value"; Code[250])
        {
            TableRelation = IF (Master = FILTER (false)) "Attribute Value"."Attribute Value" WHERE ("Attribute Code" = FIELD ("Item Attribute Code"))
            ELSE
            IF (Master = FILTER (true),
                                     "Master List" = CONST (Vendor)) Vendor."No."
            ELSE
            IF (Master = FILTER (true),
                                              "Master List" = CONST ("Product Group Code")) "Item Category".Code WHERE ("Parent Category" = FIELD ("Item Category Code"))
            ELSE
            IF (Master = FILTER (true),
                                                       "Master List" = CONST ("Base Unit Of Measure")) "Unit of Measure".Code
            ELSE
            IF (Master = FILTER (true),
                                                                "Master List" = CONST (Model)) "Product Design Model Master"."Model No";
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                AttributeValueCode: Record "Attribute Value";
            begin
                // Lines added By Deepak Kumar
                if Master = true then
                    "Attribute Value UID" := "Attribute Value"
                else begin
                    AttributeValueCode.Reset;
                    AttributeValueCode.SetRange(AttributeValueCode."Attribute Code", "Item Attribute Code");
                    AttributeValueCode.SetRange(AttributeValueCode."Attribute Value", "Attribute Value");
                    if AttributeValueCode.FindFirst then begin
                        "Attribute Value UID" := Format(AttributeValueCode."Attribute Value UID");
                        "Attribute Value Numeric" := AttributeValueCode."Attribute Value Numreric";
                    end else
                        "Attribute Value UID" := '';
                end;
            end;
        }
        field(6; "Sorting Order"; Code[2])
        {
            Editable = false;
            Numeric = true;
        }
        field(7; Master; Boolean)
        {
        }
        field(8; "Master List"; Option)
        {
            OptionCaption = ' ,Vendor,Product Group Code,Base Unit Of Measure,ItemCrossReference,Model';
            OptionMembers = " ",Vendor,"Product Group Code","Base Unit Of Measure",ItemCrossReference,Model;
        }
        field(9; "Item Number"; Code[30])
        {
            TableRelation = Item."No.";
        }
        field(12; "Add on Description"; Boolean)
        {
            Editable = false;
        }
        field(13; "Caption show in Description"; Boolean)
        {
            Editable = false;
        }
        field(50; "Item Category UID"; Integer)
        {
            Editable = false;
        }
        field(51; "Attribute Code UID"; Integer)
        {
            Editable = false;
        }
        field(52; "Attribute Value UID"; Code[10])
        {
            Editable = false;
        }
        field(54; "User ID"; Code[30])
        {
            Editable = false;
        }
        field(55; "Attribute Value Numeric"; Decimal)
        {

            trigger OnValidate()
            var
                AttributeSam: Record "M/W Price List";
            begin
            end;
        }
        field(56; "Add on Des. (Postfix)"; Code[30])
        {
        }
        field(57; "Flag For Modify"; Boolean)
        {
        }
        field(58; "Add on Des. (Prefix)"; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Item Category Code", "Item Attribute Code", "User ID")
        {
        }
        key(Key2; "Sorting Order")
        {
        }
    }

    fieldgroups
    {
    }

    procedure GetTemplete(ItemCategory: Code[20])
    var
        ItemCategaryAttributeSetup: Record "Item Cat. Attribute Setup";
        "Item Creation Buffer": Record "Item Creation Buffer";
        Int: Integer;
        ICBuffer: Record "Item Creation Buffer";
    begin
        // Lines added by Deepak Kumar
        "Item Creation Buffer".Reset;
        "Item Creation Buffer".SetRange("Item Creation Buffer"."User ID", UserId);
        if "Item Creation Buffer".FindFirst then
            "Item Creation Buffer".DeleteAll;

        ItemCategaryAttributeSetup.Reset;
        ItemCategaryAttributeSetup.SetRange(ItemCategaryAttributeSetup."Item Category Code", ItemCategory);
        ItemCategaryAttributeSetup.SetCurrentKey(ItemCategaryAttributeSetup."Sorting Order");
        if ItemCategaryAttributeSetup.FindFirst then begin
            repeat
                "Item Creation Buffer"."Item Category Code" := ItemCategaryAttributeSetup."Item Category Code";
                "Item Creation Buffer".Validate("Item Attribute Code", ItemCategaryAttributeSetup."Item Attribute");
                ItemCategaryAttributeSetup.CalcFields(ItemCategaryAttributeSetup."Item Attribute Caption");
                "Item Creation Buffer"."Item Attribute Caption" := ItemCategaryAttributeSetup."Item Attribute Caption";
                "Item Creation Buffer"."Sorting Order" := ItemCategaryAttributeSetup."Sorting Order";
                "Item Creation Buffer"."Add on Description" := ItemCategaryAttributeSetup."Add on Description";
                "Item Creation Buffer"."User ID" := UserId;
                "Item Creation Buffer".Insert(true);
                Commit;
            until ItemCategaryAttributeSetup.Next = 0;
            // Lines added for product group code
            "Item Creation Buffer".Reset;
            "Item Creation Buffer"."Item Category Code" := ItemCategaryAttributeSetup."Item Category Code";
            "Item Creation Buffer".Master := true;
            "Item Creation Buffer"."Master List" := "Item Creation Buffer"."Master List"::"Product Group Code";
            "Item Creation Buffer"."Item Attribute Code" := 'Product Group Code';
            "Item Creation Buffer"."Item Attribute Caption" := 'Product Group Code';
            "Item Creation Buffer"."Sorting Order" := 'NA';
            "Item Creation Buffer"."User ID" := UserId;
            "Item Creation Buffer".Insert(true);
            //Lines added by Deepak

            "Item Creation Buffer".Reset;
            "Item Creation Buffer"."Item Category Code" := ItemCategaryAttributeSetup."Item Category Code";
            "Item Creation Buffer".Master := true;
            "Item Creation Buffer"."Master List" := "Item Creation Buffer"."Master List"::"Base Unit Of Measure";
            "Item Creation Buffer"."Item Attribute Code" := 'Base Unit of Measure';
            "Item Creation Buffer"."Item Attribute Caption" := 'Base Unit of Measure';
            "Item Creation Buffer"."Sorting Order" := 'NA';
            "Item Creation Buffer"."User ID" := UserId;
            "Item Creation Buffer".Insert(true);
        end;
        Commit;
    end;
}

