page 50117 "Item Update Batch Job"
{
    // version Samadhan

    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Item Creation Buffer";
    SourceTableView = SORTING ("Sorting Order");

    layout
    {
        area(content)
        {
            group(Control1000000018)
            {
                ShowCaption = false;
            }
            field(ItemList; ItemList)
            {
                TableRelation = Item."No.";

                trigger OnValidate()
                var
                    ItemCategaryAttributeSetup: Record "Item Cat. Attribute Setup";
                    ItemCategory: Record "Item Category";
                begin
                    // Lines added bY Deepak Kumar
                    ItemCreationBuffer.RESET;
                    ItemCreationBuffer.SETRANGE(ItemCreationBuffer."User ID", USERID);
                    IF ItemCreationBuffer.FINDFIRST THEN BEGIN
                        ItemCreationBuffer.DELETEALL;
                        COMMIT;
                        CurrPage.UPDATE;
                    END;

                    Item.RESET;
                    Item.SETRANGE(Item."No.", ItemList);
                    IF Item.FINDFIRST THEN BEGIN
                        "Item Description" := Item.Description;

                        ItemCategaryAttributeSetup.RESET;
                        ItemCategaryAttributeSetup.SETRANGE(ItemCategaryAttributeSetup."Item Category Code", Item."Item Category Code");
                        ItemCategaryAttributeSetup.SETCURRENTKEY(ItemCategaryAttributeSetup."Sorting Order");
                        IF ItemCategaryAttributeSetup.FINDFIRST THEN BEGIN
                            REPEAT
                                ItemCreationBuffer."Item Category Code" := ItemCategaryAttributeSetup."Item Category Code";
                                ItemCategory.RESET;
                                ItemCategory.SETRANGE(ItemCategory.Code, ItemCreationBuffer."Item Category Code");
                                IF ItemCategory.FINDFIRST THEN
                                    ItemCreationBuffer."Item Category UID" := ItemCategory."IC Code";
                                ItemCreationBuffer.VALIDATE("Item Attribute Code", ItemCategaryAttributeSetup."Item Attribute");
                                ItemCategaryAttributeSetup.CALCFIELDS(ItemCategaryAttributeSetup."Item Attribute Caption");
                                ItemCreationBuffer."Item Attribute Caption" := ItemCategaryAttributeSetup."Item Attribute Caption";
                                ItemCreationBuffer."Sorting Order" := ItemCategaryAttributeSetup."Sorting Order";
                                ItemCreationBuffer."Add on Description" := ItemCategaryAttributeSetup."Add on Description";
                                ItemCreationBuffer."Item Number" := Item."No.";
                                ItemCreationBuffer."User ID" := USERID;
                                ItemCreationBuffer."Flag For Modify" := TRUE;
                                ItemCreationBuffer.INSERT(TRUE);
                                COMMIT;
                            UNTIL ItemCategaryAttributeSetup.NEXT = 0;
                        END;

                        ItemCreationBuffer.RESET;
                        ItemCreationBuffer.SETRANGE(ItemCreationBuffer."Item Number", Item."No.");
                        IF ItemCreationBuffer.FINDFIRST THEN BEGIN
                            REPEAT
                                ItemAttributeEntry.RESET;
                                ItemAttributeEntry.SETRANGE(ItemAttributeEntry."Item No.", ItemCreationBuffer."Item Number");
                                ItemAttributeEntry.SETRANGE(ItemAttributeEntry."Item Attribute Code", ItemCreationBuffer."Item Attribute Code");
                                ItemAttributeEntry.SETFILTER(ItemAttributeEntry."Item Attribute Value", '<>%1', '');
                                IF ItemAttributeEntry.FINDFIRST THEN BEGIN
                                    ItemCreationBuffer."Attribute Value" := ItemAttributeEntry."Item Attribute Value";
                                    AttributeValueCode.RESET;
                                    AttributeValueCode.SETRANGE(AttributeValueCode."Attribute Code", ItemCreationBuffer."Item Attribute Code");
                                    AttributeValueCode.SETRANGE(AttributeValueCode."Attribute Value", ItemAttributeEntry."Item Attribute Value");
                                    IF AttributeValueCode.FINDFIRST THEN
                                        ItemCreationBuffer."Attribute Value Numeric" := AttributeValueCode."Attribute Value Numreric";
                                    ItemCreationBuffer."Item Attribute Code" := ItemAttributeEntry."Item Attribute Code";
                                    ItemCreationBuffer."Attribute Value UID" := ItemAttributeEntry."Attribute Value UID";
                                END;
                                ItemCreationBuffer.MODIFY(TRUE);
                            UNTIL ItemCreationBuffer.NEXT = 0;
                        END;
                        ItemCreationBuffer.INIT;
                        ItemCreationBuffer."Item Category Code" := ItemCategaryAttributeSetup."Item Category Code";
                        ItemCreationBuffer.Master := TRUE;
                        ItemCreationBuffer."Master List" := ItemCreationBuffer."Master List"::"Product Group Code";
                        ItemCreationBuffer."Item Attribute Code" := 'Product Group Code';
                        ItemCreationBuffer."Item Attribute Caption" := 'Product Group Code';
                        ItemCreationBuffer."Sorting Order" := 'NA';
                        ItemCreationBuffer."User ID" := USERID;
                        //ItemCreationBuffer."Attribute Value":=Item."Product Group Code";
                        ItemCreationBuffer.INSERT(TRUE);

                        ItemCreationBuffer.INIT;
                        ItemCreationBuffer."Item Category Code" := ItemCategaryAttributeSetup."Item Category Code";
                        ItemCreationBuffer.Master := TRUE;
                        ItemCreationBuffer."Master List" := ItemCreationBuffer."Master List"::"Base Unit Of Measure";
                        ItemCreationBuffer."Item Attribute Code" := 'Base Unit of Measure';
                        ItemCreationBuffer."Item Attribute Caption" := 'Base Unit of Measure';
                        ItemCreationBuffer."Sorting Order" := 'NA';
                        ItemCreationBuffer."User ID" := USERID;
                        ItemCreationBuffer."Attribute Value" := Item."Base Unit of Measure";
                        ItemCreationBuffer.INSERT(TRUE);

                    END ELSE BEGIN
                        "Item Description" := '';
                    END;
                    COMMIT;
                end;
            }
            field("Item Description"; "Item Description")
            {
                Editable = false;
            }
            grid(Control1000000011)
            {
                ShowCaption = false;
            }
            repeater(Group)
            {
                field("Item Attribute Caption"; "Item Attribute Caption")
                {
                }
                field("Attribute Value"; "Attribute Value")
                {
                }
                field("Sorting Order"; "Sorting Order")
                {
                }
                field(Master; Master)
                {
                }
                field("Attribute Value Numeric"; "Attribute Value Numeric")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Item Category UID"; "Item Category UID")
                {
                }
                field("Attribute Code UID"; "Attribute Code UID")
                {
                }
                field("Attribute Value UID"; "Attribute Value UID")
                {
                }
                field("User ID"; "User ID")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Item")
            {
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemCode: Code[200];
                begin
                    // Lines added By Deepak Kumar
                    CheckDuplication;
                    ItemCode := '';
                    "Temp Description" := '';

                    ItemCategoryCode.GET("Item Category Code");
                    ItemAttributeEntry.RESET;
                    ItemAttributeEntry.SETFILTER(ItemAttributeEntry."Entry No.", '<>%1', 0);
                    IF ItemAttributeEntry.FINDFIRST THEN
                        ItemAttributeEntry.FINDLAST;
                    EntryNumber := ItemAttributeEntry."Entry No.";

                    ItemCreationBuffer.RESET;
                    ItemCreationBuffer.SETCURRENTKEY(ItemCreationBuffer."Sorting Order");
                    ItemCreationBuffer.SETRANGE(ItemCreationBuffer."User ID", USERID);
                    ItemCreationBuffer.SETRANGE(ItemCreationBuffer.Master, FALSE);
                    IF ItemCreationBuffer.FINDFIRST THEN BEGIN
                        ItemCode := FORMAT(ItemCategoryCode."IC Code");
                        REPEAT
                            ItemCode := ItemCode + FORMAT(ItemCreationBuffer."Attribute Code UID") + FORMAT(ItemCreationBuffer."Attribute Value UID");
                        UNTIL ItemCreationBuffer.NEXT = 0;
                    END;

                    ItemCreationBuffer.RESET;
                    ItemCreationBuffer.SETCURRENTKEY(ItemCreationBuffer."Sorting Order");
                    ItemCreationBuffer.SETRANGE(ItemCreationBuffer."User ID", USERID);
                    ItemCreationBuffer.SETFILTER(ItemCreationBuffer."Master List", '<>%1&<>%2', 2, 3);
                    IF ItemCreationBuffer.FINDFIRST THEN BEGIN
                        //ItemCode:=FORMAT(ItemCategoryCode."IC Code");
                        "Temp Description" := '';
                        REPEAT
                            ItemAttributeEntry.RESET;
                            ItemAttributeEntry.SETRANGE(ItemAttributeEntry."Item No.", ItemCreationBuffer."Item Number");
                            ItemAttributeEntry.SETRANGE(ItemAttributeEntry."Item Category Code", ItemCreationBuffer."Item Category Code");
                            ItemAttributeEntry.SETRANGE(ItemAttributeEntry."Item Attribute Code", ItemCreationBuffer."Item Attribute Code");
                            IF ItemAttributeEntry.FINDFIRST THEN BEGIN
                                ItemAttributeEntry."Item Attribute Value" := ItemCreationBuffer."Attribute Value";
                                ItemAttributeEntry."Modified By" := USERID + FORMAT(WORKDATE) + ' ' + FORMAT(TIME);
                                ItemAttributeEntry.MODIFY(TRUE);
                            END
                            ELSE BEGIN
                                EntryNumber := EntryNumber + 1;
                                //ItemAttributeEntryExtra.INIT;
                                ItemAttributeEntryExtra."Entry No." := EntryNumber;
                                ItemAttributeEntryExtra."Item Category Code" := ItemCreationBuffer."Item Category Code";
                                ItemAttributeEntryExtra."Item Attribute Code" := ItemCreationBuffer."Item Attribute Code";
                                ItemAttributeEntryExtra."Item Attribute Value" := ItemCreationBuffer."Attribute Value";
                                ItemAttributeEntryExtra."Item No." := ItemCreationBuffer."Item Number";
                                ItemAttributeEntryExtra."User ID" := USERID;
                                ItemAttributeEntryExtra."Item Category UID" := FORMAT(ItemCreationBuffer."Item Category UID");
                                ItemAttributeEntryExtra."Attribute UID" := FORMAT(ItemCreationBuffer."Attribute Code UID");
                                ItemAttributeEntryExtra."Attribute Value UID" := ItemCreationBuffer."Attribute Value UID";
                                ItemAttributeEntryExtra.INSERT(TRUE);
                            END;
                            IF ItemCreationBuffer."Add on Description" = TRUE THEN BEGIN
                                IF ItemCreationBuffer."Caption show in Description" = TRUE THEN BEGIN
                                    IF "Temp Description" <> '' THEN
                                        "Temp Description" := "Temp Description" + ' ' + ItemCreationBuffer."Add on Des. (Prefix)" + '' + ItemCreationBuffer."Attribute Value" + '' + ItemCreationBuffer."Add on Des. (Postfix)"
                                    ELSE
                                        "Temp Description" := ItemCreationBuffer."Add on Des. (Prefix)" + ' ' + ItemCreationBuffer."Attribute Value" + '' + ItemCreationBuffer."Add on Des. (Postfix)";
                                END ELSE BEGIN
                                    IF "Temp Description" <> '' THEN
                                        "Temp Description" := "Temp Description" + ' ' + ItemCreationBuffer."Attribute Value"
                                    ELSE
                                        "Temp Description" := ItemCreationBuffer."Attribute Value";
                                END;
                            END;
                            // ItemCode:=ItemCode+FORMAT(ItemCreationBuffer."Attribute Code UID")+FORMAT(ItemCreationBuffer."Attribute Value UID");
                        UNTIL ItemCreationBuffer.NEXT = 0;

                        Item.RESET;
                        Item.SETRANGE(Item."No.", ItemCreationBuffer."Item Number");
                        IF Item.FINDFIRST THEN BEGIN
                            Item.VALIDATE(Description, "Temp Description");
                            Item."Item UID Code" := ItemCode;
                            Item.MODIFY(TRUE);

                            ItemCategory.RESET;
                            ItemCategory.SETRANGE(ItemCategory.Code, "Item Category Code");
                            IF ItemCategory.FINDFIRST THEN BEGIN

                                IF ItemCategory."Roll ID Applicable" = TRUE THEN BEGIN
                                    ItemCreationBuffer.RESET;
                                    ItemCreationBuffer.SETRANGE(ItemCreationBuffer."User ID", USERID);
                                    IF ItemCreationBuffer.FINDFIRST THEN BEGIN
                                        REPEAT
                                            Item."Roll ID Applicable" := TRUE;
                                            IF ItemCreationBuffer."Item Attribute Code" = 'PAPERGSM' THEN
                                                Item."Paper GSM" := ItemCreationBuffer."Attribute Value Numeric";
                                            IF ItemCreationBuffer."Item Attribute Code" = 'BF' THEN
                                                Item."Bursting factor(BF)" := ItemCreationBuffer."Attribute Value Numeric";
                                            IF ItemCreationBuffer."Item Attribute Code" = 'PAPERTYPE' THEN BEGIN
                                                Item."Paper Type" := ItemCreationBuffer."Attribute Value";
                                                Rec_AttributeValue.RESET;
                                                Rec_AttributeValue.SETRANGE("Attribute Code", ItemCreationBuffer."Item Attribute Code");
                                                Rec_AttributeValue.SETRANGE(Rec_AttributeValue."Attribute Value", ItemCreationBuffer."Attribute Value");
                                                IF Rec_AttributeValue.FINDFIRST THEN
                                                    Item."FSC Category" := Rec_AttributeValue."Attribute Value Description";
                                            END;
                                            IF ItemCreationBuffer."Item Attribute Code" = 'DECKLESIZE' THEN
                                                Item."Deckle Size (mm)" := ItemCreationBuffer."Attribute Value Numeric";
                                            IF ItemCreationBuffer."Item Attribute Code" = 'SUPPLIER' THEN
                                                Item.Supplier := ItemCreationBuffer."Attribute Value";
                                            IF ItemCreationBuffer."Item Attribute Code" = 'ORIGIN & MILL' THEN
                                                Item."Paper Origin" := ItemCreationBuffer."Attribute Value";
                                            Item.MODIFY(TRUE);

                                        UNTIL ItemCreationBuffer.NEXT = 0;
                                    END;
                                END;
                            END;

                            //Firoz 18-11-15
                            IF ItemCategory."Def. Inventory Posting Group" = 'FG' THEN BEGIN
                                ItemCreationBuffer.RESET;
                                ItemCreationBuffer.SETRANGE(ItemCreationBuffer."User ID", USERID);
                                IF ItemCreationBuffer.FINDFIRST THEN BEGIN
                                    REPEAT

                                        IF ItemCreationBuffer."Item Attribute Code" = 'COLOUR' THEN
                                            Item."Color Code" := ItemCreationBuffer."Attribute Value";
                                        IF ItemCreationBuffer."Item Attribute Code" = 'LENGTH' THEN
                                            Item."Box Length" := ItemCreationBuffer."Attribute Value";
                                        IF ItemCreationBuffer."Item Attribute Code" = 'WIDTH' THEN
                                            Item."Box Width" := ItemCreationBuffer."Attribute Value";
                                        IF ItemCreationBuffer."Item Attribute Code" = 'HEIGHT' THEN
                                            Item."Box Height" := ItemCreationBuffer."Attribute Value";
                                        IF ItemCreationBuffer."Item Attribute Code" = 'FG_GSM' THEN
                                            Item."FG GSM" := ItemCreationBuffer."Attribute Value";
                                        IF ItemCreationBuffer."Item Attribute Code" = 'FLUTE' THEN
                                            Item."Flute Type" := ItemCreationBuffer."Attribute Value";

                                        Item.MODIFY(TRUE);
                                    UNTIL ItemCreationBuffer.NEXT = 0;
                                END;
                            END;

                            //End Firoz 18-11-15

                            ItemCreationBuffer.RESET;
                            ItemCreationBuffer.SETCURRENTKEY(ItemCreationBuffer."Sorting Order");
                            ItemCreationBuffer.SETRANGE(ItemCreationBuffer."User ID", USERID);
                            ItemCreationBuffer.SETRANGE(ItemCreationBuffer.Master, TRUE);
                            IF ItemCreationBuffer.FINDFIRST THEN BEGIN
                                REPEAT
                                    //  IF ItemCreationBuffer."Master List" = ItemCreationBuffer."Master List"::"Product Group Code" THEN
                                    //    Item."Product Group Code":=ItemCreationBuffer."Attribute Value";
                                    IF ItemCreationBuffer."Master List" = ItemCreationBuffer."Master List"::"Base Unit Of Measure" THEN
                                        Item.VALIDATE("Base Unit of Measure", ItemCreationBuffer."Attribute Value");
                                    Item.MODIFY(TRUE);
                                UNTIL ItemCreationBuffer.NEXT = 0;
                            END;
                            Item.MODIFY(TRUE);
                        END;
                        ItemCreationBuffer.RESET;
                        ItemCreationBuffer.SETRANGE(ItemCreationBuffer."User ID", USERID);
                        ItemCreationBuffer.DELETEALL(TRUE);
                        CurrPage.CLOSE;
                        ItemCard.SETTABLEVIEW(Item);
                        ItemCard.RUN;
                    END;
                end;
            }
            action("Delete Template")
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar

                    ItemCreationBuffer.RESET;
                    ItemCreationBuffer.SETRANGE(ItemCreationBuffer."User ID", USERID);
                    ItemCreationBuffer.DELETEALL;
                    COMMIT;
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SETRANGE("User ID", USERID);
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TempItemNumber: Code[30];
        Item: Record Item;
        EntryNumber: Integer;
        "Temp Description": Text[250];
        ItemCard: Page "Item Card";
        ItemCreationBuffer: Record "Item Creation Buffer";
        ItemCreationBufferNew: Record "Item Creation Buffer";
        iPG: Code[20];
        IAttrib: Record "Attribute Master";
        IAttrib2: Record "Attribute Master";
        NO2: Code[10];
        ARTICLE: Code[30];
        "Item Description": Text[250];
        ItemAttributeEntry: Record "Item Attribute Entry";
        ItemList: Code[50];
        ItemAttributeEntryNew: Record "Item Attribute Entry";
        Attributevaluesum: Record "Attribute Value";
        ItemAttributeEntry1: Record "Item Attribute Entry";
        ProductionBOMHeader: Record "Production BOM Header";
        routing: Record "Routing Header";
        ItemCategoryCode: Record "Item Category";
        AttributeValueCode: Record "Attribute Value";
        CheckDescription: Text;
        ItemCategory: Record "Item Category";
        SparesMaster: Record Spare;
        EquipmentMaster: Record Equipment;
        ItemAttributeEntryExtra: Record "Item Attribute Entry";
        SpareItems: Record Item;
        AttrSetup: Record "Item Cat. Attribute Setup";
        ItemCode: Code[10];
        AttrValue: Text[150];
        Rec_AttributeValue: Record "Attribute Value";

    procedure CheckDuplication()
    var
        ItemBuffer: Record "Item Creation Buffer";
        TempItemCode: Code[200];
        TempItemCodeValue: Code[250];
        ItemMaster: Record Item;
    begin

        TempItemCode := '';
        TempItemCodeValue := '';
        CheckDescription := '';

        ItemBuffer.RESET;
        ItemBuffer.SETCURRENTKEY(ItemBuffer."Sorting Order");
        ItemBuffer.SETRANGE(ItemBuffer."User ID", USERID);
        ItemBuffer.SETRANGE(ItemBuffer.Master, FALSE);
        IF ItemBuffer.FINDFIRST THEN BEGIN
            TempItemCode := FORMAT(ItemBuffer."Item Category UID");
            TempItemCodeValue := FORMAT(ItemBuffer."Item Category Code");
            REPEAT
                TempItemCode := TempItemCode + FORMAT(ItemBuffer."Attribute Code UID") + FORMAT(ItemBuffer."Attribute Value UID");
                CheckDescription := CheckDescription + ' ' + ItemBuffer."Attribute Value";
            UNTIL ItemBuffer.NEXT = 0;
        END;
        //MESSAGE(TempItemCode);

        ItemMaster.RESET;
        ItemMaster.SETFILTER(ItemMaster."Item UID Code", TempItemCode);
        IF ItemMaster.FINDFIRST THEN BEGIN
            IF (ItemMaster."No." <> "Item Number") THEN
                ERROR('This Specification of Item already exits, The identification value is %1', ItemMaster."No.");
        END;
    end;
}

