page 50014 "Item Wizard"
{
    // version Item Wizard Samadhan

    SourceTable = "Item Creation Buffer";

    SourceTableView = SORTING ("Sorting Order")
                      ORDER(Ascending)
                      WHERE ("Item Attribute Code" = FILTER (<> ''));

    layout
    {
        area(content)
        {
            group(Control14)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                ShowCaption = false;
                Editable = true;
                field("Item Category Code"; "Item Category Code")
                {
                    CaptionML = ENU = 'Item Category Code';

                    trigger OnValidate()
                    var
                        ItemCategaryAttributeSetup: Record "Product Design Model Master";
                        "Item Creation Buffer": Record "Item Cat. Attribute Setup";
                        Int: Integer;
                    begin
                    end;
                }
            }
            repeater(Group)
            {
                field("Item Attribute Caption"; "Item Attribute Caption")
                {
                }
                field("Attribute Value"; "Attribute Value")
                {
                }
                field("Add on Des. (Prefix)"; "Add on Des. (Prefix)")
                {
                }
                field("Add on Des. (Postfix)"; "Add on Des. (Postfix)")
                {
                }
                field(Master; Master)
                {
                    Visible = false;
                }
                field("Sorting Order"; "Sorting Order")
                {
                }
                field("User ID"; "User ID")
                {
                    Visible = false;
                }
                field("Item Category UID"; "Item Category UID")
                {
                    Visible = false;
                }
                field("Attribute Code UID"; "Attribute Code UID")
                {
                    Visible = false;
                }
                field("Master List"; "Master List")
                {
                    Visible = false;
                }
                field("Attribute Value UID"; "Attribute Value UID")
                {
                    Visible = false;
                }
                field("Add on Description"; "Add on Description")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Template")
            {
                Image = Template;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemCategaryAttributeSetup: Record "Product Design Model Master";
                    "Item Creation Buffer": Record "Item Cat. Attribute Setup";
                    Int: Integer;
                begin
                    // Lines added by deepak Kumar
                    GetTemplete("Item Category Code");
                end;
            }
            action("Create Item")
            {
                Image = NewItem;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    "Item Creation Buffer": Record "Item Creation Buffer";
                    ItemAttributeEntry: Record "Item Attribute Entry";
                    ItemCategory: Record "Item Category";
                    TempItemM: Record Item;
                    ItemCode: Code[200];
                    ItemMaster: Record Item;
                begin
                    CheckDuplication;

                    ItemCategory.Reset;
                    ItemCategory.SetRange(ItemCategory.Code, "Item Category Code");
                    if ItemCategory.FindFirst then begin

                        TempItemNumber := '';
                        ItemCode := '';
                        ItemCategory.TestField(ItemCategory."No Series");
                        NoSeriesMgt.InitSeries(ItemCategory."No Series", '', 0D, TempItemNumber, ItemCategory."No Series");

                        if ItemAttributeEntry.FindFirst then
                            ItemAttributeEntry.FindLast;
                        EntryNumber := ItemAttributeEntry."Entry No.";

                        "Item Creation Buffer".Reset;
                        "Item Creation Buffer".SetCurrentKey("Item Creation Buffer"."Sorting Order");
                        "Item Creation Buffer".SetRange("Item Creation Buffer"."User ID", UserId);
                        "Item Creation Buffer".SetRange("Item Creation Buffer".Master, false);
                        if "Item Creation Buffer".FindFirst then begin
                            ItemCode := Format("Item Creation Buffer"."Item Category UID");
                            repeat
                                ItemCode := ItemCode + Format("Item Creation Buffer"."Attribute Code UID") + Format("Item Creation Buffer"."Attribute Value UID");
                            until "Item Creation Buffer".Next = 0;
                        end;

                        "Item Creation Buffer".Reset;
                        "Item Creation Buffer".SetCurrentKey("Item Creation Buffer"."Sorting Order");
                        "Item Creation Buffer".SetRange("Item Creation Buffer"."User ID", UserId);
                        "Item Creation Buffer".SetFilter("Item Creation Buffer"."Master List", '<>%1&<>%2', 2, 3);
                        if "Item Creation Buffer".FindFirst then begin
                            "Temp Description" := '';
                            repeat
                                //MESSAGE(FORMAT("Item Creation Buffer"."Master List"));
                                if "Item Creation Buffer"."Sorting Order" <> 'NA' then
                                    "Item Creation Buffer".TestField("Item Creation Buffer"."Attribute Value");
                                EntryNumber := EntryNumber + 1;
                                ItemAttributeEntry.Init;
                                ItemAttributeEntry."Entry No." := EntryNumber;
                                ItemAttributeEntry."Item Category Code" := "Item Creation Buffer"."Item Category Code";
                                ItemAttributeEntry."Item Attribute Code" := "Item Creation Buffer"."Item Attribute Code";
                                ItemAttributeEntry."Item Attribute Value" := "Item Creation Buffer"."Attribute Value";
                                ItemAttributeEntry."Item Category UID" := Format("Item Creation Buffer"."Item Category UID");
                                ItemAttributeEntry."Attribute UID" := Format("Item Creation Buffer"."Attribute Code UID");
                                ItemAttributeEntry."Attribute Value UID" := "Item Creation Buffer"."Attribute Value UID";
                                ItemAttributeEntry."Item No." := TempItemNumber;
                                ItemAttributeEntry."User ID" := UserId;
                                ItemAttributeEntry."Add on Des. (Postfix)" := "Item Creation Buffer"."Add on Des. (Postfix)";
                                ItemAttributeEntry."Add on Des. (Prefix)" := "Item Creation Buffer"."Add on Des. (Prefix)";
                                if ("Item Creation Buffer"."Attribute Value" <> '-') and ("Item Creation Buffer"."Attribute Value" <> '0') and ("Item Creation Buffer"."Add on Description" = true) then begin
                                    if "Item Creation Buffer"."Caption show in Description" = true then begin
                                        if "Temp Description" <> '' then
                                            "Temp Description" := "Temp Description" + ' ' + "Item Creation Buffer"."Add on Des. (Prefix)" + '' + "Item Creation Buffer"."Attribute Value" + '' + "Item Creation Buffer"."Add on Des. (Postfix)"
                                        else
                                            "Temp Description" := "Item Creation Buffer"."Add on Des. (Prefix)" + '' + "Item Creation Buffer"."Attribute Value" + '' + "Item Creation Buffer"."Add on Des. (Postfix)";
                                    end else begin
                                        if "Temp Description" <> '' then
                                            "Temp Description" := "Temp Description" + ' ' + "Item Creation Buffer"."Attribute Value"
                                        else
                                            "Temp Description" := "Item Creation Buffer"."Attribute Value";
                                    end;
                                end;
                                ItemAttributeEntry.Insert(true);
                            until "Item Creation Buffer".Next = 0;
                        end;
                        ItemMaster.Reset;
                        ItemMaster.SetFilter(ItemMaster."Item UID Code", ItemCode);
                        if ItemMaster.FindFirst then begin
                            Error('This Specification of Item already exits, The identification value is %1', ItemMaster."No.");
                        end;

                        // Insert Item
                        Item.Init;
                        Item."No." := TempItemNumber;
                        Item.Insert(true);
                        Item.Validate(Item."Item UID Code", ItemCode);
                        Item.Validate(Description, "Temp Description");
                        Item.Validate("Item Category Code", "Item Creation Buffer"."Item Category Code");

                        if ItemCategory."Roll ID Applicable" = true then begin
                            "Item Creation Buffer".Reset;
                            "Item Creation Buffer".SetRange("Item Creation Buffer"."User ID", UserId);
                            if "Item Creation Buffer".FindFirst then begin
                                repeat
                                    //MESSAGE('I am Inside');
                                    Item."Roll ID Applicable" := true;
                                    if "Item Creation Buffer"."Item Attribute Code" = 'PAPERGSM' then begin
                                        Item."Paper GSM" := "Item Creation Buffer"."Attribute Value Numeric";
                                        //MESSAGE(FORMAT("Item Creation Buffer"."Attribute Value Numreric"));
                                    end;
                                    if "Item Creation Buffer"."Item Attribute Code" = 'BF' then
                                        Item."Bursting factor(BF)" := "Item Creation Buffer"."Attribute Value Numeric";
                                    if "Item Creation Buffer"."Item Attribute Code" = 'PAPERTYPE' then
                                        Item.VALIDATE("Paper Type", "Item Creation Buffer"."Attribute Value");
                                    if "Item Creation Buffer"."Item Attribute Code" = 'DECKLESIZE' then
                                        Item."Deckle Size (mm)" := "Item Creation Buffer"."Attribute Value Numeric";
                                    if "Item Creation Buffer"."Item Attribute Code" = 'SUPPLIER' then
                                        Item.Supplier := "Item Creation Buffer"."Attribute Value";
                                    if "Item Creation Buffer"."Item Attribute Code" = 'ORIGIN_MILL' then
                                        Item."Paper Origin" := "Item Creation Buffer"."Attribute Value";
                                    Item.Modify(true);
                                until "Item Creation Buffer".Next = 0;
                            end;
                        end;

                        //Firoz 18-11-15

                        if ItemCategory."Def. Inventory Posting Group" = 'FG' then begin
                            "Item Creation Buffer".Reset;
                            "Item Creation Buffer".SetRange("Item Creation Buffer"."User ID", UserId);
                            if "Item Creation Buffer".FindFirst then begin
                                repeat

                                    if "Item Creation Buffer"."Item Attribute Code" = 'COLOUR' then
                                        Item."Color Code" := "Item Creation Buffer"."Attribute Value";
                                    if "Item Creation Buffer"."Item Attribute Code" = 'LENGTH' then
                                        Item."Box Length" := "Item Creation Buffer"."Attribute Value";
                                    if "Item Creation Buffer"."Item Attribute Code" = 'WIDTH' then
                                        Item."Box Width" := "Item Creation Buffer"."Attribute Value";
                                    if "Item Creation Buffer"."Item Attribute Code" = 'HEIGHT' then
                                        Item."Box Height" := "Item Creation Buffer"."Attribute Value";
                                    if "Item Creation Buffer"."Item Attribute Code" = 'FG_GSM' then
                                        Item."FG GSM" := "Item Creation Buffer"."Attribute Value";
                                    if "Item Creation Buffer"."Item Attribute Code" = 'FLUTE' then
                                        Item."Flute Type" := "Item Creation Buffer"."Attribute Value";

                                    if "Item Creation Buffer"."Item Attribute Code" = 'PLY' then begin
                                        if "Item Creation Buffer"."Attribute Value Numeric" = 2 then
                                            Item."No. of Ply" := 1;
                                        if "Item Creation Buffer"."Attribute Value Numeric" = 3 then
                                            Item."No. of Ply" := 2;
                                        if "Item Creation Buffer"."Attribute Value Numeric" = 5 then
                                            Item."No. of Ply" := 3;
                                        if "Item Creation Buffer"."Attribute Value Numeric" = 7 then
                                            Item."No. of Ply" := 4;

                                    end;


                                    Item.Modify(true);
                                until "Item Creation Buffer".Next = 0;
                            end;
                        end;
                        //End Firoz 18-11-15

                        //***************************************Item Master Update
                        "Item Creation Buffer".Reset;
                        "Item Creation Buffer".SetCurrentKey("Item Creation Buffer"."Sorting Order");
                        "Item Creation Buffer".SetRange("Item Creation Buffer"."User ID", UserId);
                        if "Item Creation Buffer".FindFirst then begin
                            repeat
                                //if "Item Creation Buffer"."Master List" = "Item Creation Buffer"."Master List"::"Product Group Code" then
                                //Item."Product Group Code" := "Item Creation Buffer"."Attribute Value";
                                if "Item Creation Buffer"."Master List" = "Item Creation Buffer"."Master List"::"Base Unit Of Measure" then begin
                                    Item.Validate("Base Unit of Measure", "Item Creation Buffer"."Attribute Value");
                                end;
                                Item.Modify(true);
                            until "Item Creation Buffer".Next = 0;
                        end;
                        //*****************************************
                        Item.Modify(true);
                        Message('%1 with description %2 created.', TempItemNumber, "Temp Description");
                        DeleteAll;
                        CurrPage.Close;
                        ItemWizardPage.Run;
                        //COMMIT;

                    end
                    else
                        Error('Item Category code not Exist');
                end;
            }
            action("Delete Template")
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ItemCreationBuffer.Reset;
                    ItemCreationBuffer.SetRange(ItemCreationBuffer."User ID", UserId);
                    ItemCreationBuffer.DeleteAll;
                    Commit;
                    CurrPage.Update;
                end;
            }
            action("Check Duplicate")
            {

                trigger OnAction()
                begin
                    CheckDuplication;
                end;
            }
            action("Update Item")
            {
                RunObject = Page "Inspection Line";
                Visible = false;
            }
            action("Item Category")
            {
                CaptionML = ENU = 'Item Category';
                Image = Category;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Item Categories";
                RunPageView = SORTING (Code);
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange("User ID", UserId);
        if FindFirst then;
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
        CheckDescription: Text[250];
        "Old Item Number": Code[30];
        "Base Unit": Code[10];
        ItemWizardPage: Page "Item Wizard";
        ItemCategory: Text[20];
        FGItem: Record Item;

    procedure CheckDuplication()
    var
        ItemBuffer: Record "Item Creation Buffer";
        TempItemCode: Code[200];
        TempItemCodeValue: Text[1000];
        ItemMaster: Record Item;
    begin
        // Lines added by Deepak Kumar
        TempItemCode := '';
        TempItemCodeValue := '';
        CheckDescription := '';

        ItemBuffer.Reset;
        ItemBuffer.SetCurrentKey(ItemBuffer."Sorting Order");
        ItemBuffer.SetRange(ItemBuffer."User ID", UserId);
        ItemBuffer.SetRange(ItemBuffer.Master, false);
        if ItemBuffer.FindFirst then begin
            TempItemCode := Format(ItemBuffer."Item Category UID");
            TempItemCodeValue := Format(ItemBuffer."Item Category Code");
            repeat
                TempItemCode := TempItemCode + Format(ItemBuffer."Attribute Code UID") + Format(ItemBuffer."Attribute Value UID");
                CheckDescription := CheckDescription + ' ' + ItemBuffer."Attribute Value";
            until ItemBuffer.Next = 0;
            // MESSAGE(  TempItemCode);
        end;


        ItemMaster.Reset;
        ItemMaster.SetFilter(ItemMaster."Item UID Code", TempItemCode);
        if ItemMaster.FindFirst then begin
            Error('This Specification of Item already exits, The identification value is %1', ItemMaster."No.");
        end;
    end;
}

