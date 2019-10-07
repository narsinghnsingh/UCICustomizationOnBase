page 50109 "Item Issue Journal"
{
    // version NAVW17.00,B2BPLM1.0

    // B2B Software Technologies
    // -----------------------------------------
    // Project : Plant Maintenance Addon
    // B2BPLM1.00.00
    // No. Sign          Dev     Date            Description
    // --------------------------------------------------------------------------
    // 01  B2BPLM1.00.00 RO    Jul2,2011  Added HeadingHeight=880
    //                                    Added Controls SourceExpr="Serial No.,Shortcut Dimension 1 Code",Shortcut Dimension 2 Code",Lot N

    AutoSplitKey = true;
    CaptionML = ENU = 'Item Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Item Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                CaptionML = ENU = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    ItemJnlMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item Identifier"; "Item Identifier")
                {
                    ShowMandatory = true;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Line No."; "Line No.")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                    Editable = false;
                }
                field("Order Type"; "Order Type")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Order Line No."; "Order Line No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                    CaptionML = ENU = 'Variant Code/ Roll No';
                }
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Requisition Line No."; "Requisition Line No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                }
                field("External Document No."; "External Document No.")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetItem("Item No.", ItemDescription);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = true;

                    trigger OnValidate()
                    var
                        WMSManagement: Codeunit "WMS Management";
                    begin
                        WMSManagement.CheckItemJnlLineLocation(Rec, xRec);
                    end;
                }
                field("Final Location"; "Final Location")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Roll Inventory"; "Roll Inventory")
                {
                }
                field("Final Inventory"; "Final Inventory")
                {
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Requisition Rem. Quantity"; "Requisition Rem. Quantity")
                {
                }
                field("Quantity In PCS"; "Quantity In PCS")
                {
                }
                field("Make Ready Qty"; "Make Ready Qty")
                {
                }
                field("Paper Type"; "Paper Type")
                {
                }
                field("Deckle Size (mm)"; "Deckle Size (mm)")
                {
                }
                field("Paper GSM"; "Paper GSM")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Editable = false;
                }
            }
            group(Control22)
            {
                ShowCaption = false;
                fixed(Control1900669001)
                {
                    ShowCaption = false;
                    group("Item Description")
                    {
                        CaptionML = ENU = 'Item Description';
                        field(ItemDescription; ItemDescription)
                        {
                            Editable = false;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1903326807; "Item Replenishment FactBox")
            {
                SubPageLink = "No." = FIELD ("Item No.");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Item")
            {
                CaptionML = ENU = '&Item';
                Image = Item;
                action(Card)
                {
                    CaptionML = ENU = 'Card';
                    Image = EditLines;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD ("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    CaptionML = ENU = 'Ledger E&ntries';
                    Image = ItemLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No." = FIELD ("Item No.");
                    RunPageView = SORTING ("Item No.");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions';
                Image = "Action";
                action("Get Requisition Line")
                {
                    CaptionML = ENU = 'Get Requisition Line';
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // Lines added by Deepak kumar
                        GenerateLine("Journal Template Name", "Journal Batch Name", "Requisition No.");
                        Delete(true);
                    end;
                }
                separator("-")
                {
                    CaptionML = ENU = '-';
                }
                action("&Get Standard Journals")
                {
                    CaptionML = ENU = '&Get Standard Journals';
                    Ellipsis = true;
                    Image = GetStandardJournal;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        StdItemJnl: Record "Standard Item Journal";
                    begin
                        StdItemJnl.FilterGroup := 2;
                        StdItemJnl.SetRange("Journal Template Name", "Journal Template Name");
                        StdItemJnl.FilterGroup := 0;
                        if PAGE.RunModal(PAGE::"Standard Item Journals", StdItemJnl) = ACTION::LookupOK then begin
                            StdItemJnl.CreateItemJnlFromStdJnl(StdItemJnl, CurrentJnlBatchName);
                            Message(Text001, StdItemJnl.Code);
                        end
                    end;
                }
                action("&Save as Standard Journal")
                {
                    CaptionML = ENU = '&Save as Standard Journal';
                    Ellipsis = true;
                    Image = SaveasStandardJournal;

                    trigger OnAction()
                    var
                        ItemJnlBatch: Record "Item Journal Batch";
                        ItemJnlLines: Record "Item Journal Line";
                        StdItemJnl: Record "Standard Item Journal";
                        SaveAsStdItemJnl: Report "Save as Standard Item Journal";
                    begin
                        ItemJnlLines.SetFilter("Journal Template Name", "Journal Template Name");
                        ItemJnlLines.SetFilter("Journal Batch Name", CurrentJnlBatchName);
                        CurrPage.SetSelectionFilter(ItemJnlLines);
                        ItemJnlLines.CopyFilters(Rec);

                        ItemJnlBatch.Get("Journal Template Name", CurrentJnlBatchName);
                        SaveAsStdItemJnl.Initialise(ItemJnlLines, ItemJnlBatch);
                        SaveAsStdItemJnl.RunModal;
                        if not SaveAsStdItemJnl.GetStdItemJournal(StdItemJnl) then
                            exit;

                        Message(Text002, StdItemJnl.Code);
                    end;
                }
            }
            group("P&osting")
            {
                CaptionML = ENU = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    CaptionML = ENU = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintItemJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    CaptionML = ENU = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        //Pulak 11-03-15  Begin
                        //MESSAGE('Code Begins');


                        IJLOld.Reset;
                        IJLOld.SetRange(IJLOld."Journal Template Name", "Journal Template Name");
                        IJLOld.SetRange(IJLOld."Journal Batch Name", "Journal Batch Name");
                        IJLOld.SetRange(IJLOld."Line Inserted", false);
                        if IJLOld.FindLast then begin
                            LastLineNo := IJLOld."Line No.";
                            IJLOld.FindFirst;
                            repeat
                                if (IJLOld."Variant Code" <> '') and (IJLOld."Final Location" <> '') and (IJLOld."Final Inventory" <> 0) and (IJLOld."Final Location" <> IJLOld."Location Code") then begin
                                    RollMaster.Reset;
                                    RollMaster.SetRange(RollMaster.Code, IJLOld."Variant Code");
                                    if RollMaster.FindFirst then
                                        RollMaster.CalcFields(RollMaster."Remaining Quantity");

                                    // Insert -ve adjmt.
                                    IJL.Reset;
                                    IJL := IJLOld;
                                    IJL."Line No." := LastLineNo + 10000;
                                    IJL."Line Inserted" := true;
                                    IJL."Order Type" := IJL."Order Type"::" ";
                                    IJL."Order No." := '';
                                    IJL."Order Line No." := 0;
                                    IJL.Insert(true);
                                    IJL.Validate(IJL."Entry Type", IJL."Entry Type"::"Negative Adjmt.");
                                    IJL.Validate(IJL.Quantity, RollMaster."Remaining Quantity" - IJLOld.Quantity);
                                    IJL.Validate(IJL."Final Location", '');
                                    IJL.Modify(true);

                                    // Insert +ve adjmt.
                                    IJL.Reset;
                                    IJL := IJLOld;
                                    IJL."Line No." := LastLineNo + 20000;
                                    IJL."Line Inserted" := true;
                                    IJL."Applies-to Entry" := 0;
                                    IJL."Order Type" := IJL."Order Type"::" ";
                                    IJL."Order No." := '';
                                    IJL."Order Line No." := 0;
                                    IJL.Insert(true);
                                    IJL.Validate(IJL."Entry Type", IJL."Entry Type"::"Positive Adjmt.");
                                    IJL.Validate(IJL.Quantity, RollMaster."Remaining Quantity" - IJLOld.Quantity);
                                    IJL.Validate(IJL."Location Code", IJLOld."Final Location");
                                    IJL.Validate(IJL."Final Location", '');
                                    IJL.Modify(true);

                                    IJLOld."Line Inserted" := true;
                                    IJLOld.Modify(true);
                                    LastLineNo := LastLineNo + 20000;
                                end;
                            until IJLOld.Next = 0;
                        end;

                        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    CaptionML = ENU = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
            action("&Print")
            {
                CaptionML = ENU = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    ItemJnlLine.Copy(Rec);
                    ItemJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
                    REPORT.RunModal(REPORT::"Inventory Movement", true, true, ItemJnlLine);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ItemJnlMgt.GetItem("Item No.", ItemDescription);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
    begin
        Commit;
        if not ReserveItemJnlLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveItemJnlLine.DeleteLine(Rec);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //Standard code commented by Pulak 01-10-2014
        /*
        IF "Entry Type" > "Entry Type"::"Negative Adjmt." THEN
          ERROR(Text000,"Entry Type");
        */
        "Entry Type" := "Entry Type"::Consumption;
        "Order Type" := "Order Type"::Production;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
        "Entry Type" := "Entry Type"::Consumption;
        "Order Type" := "Order Type"::Production;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') and ("Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := "Journal Batch Name";
            ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        ItemJnlMgt.TemplateSelection(PAGE::"Item Journal", 0, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);

        "Entry Type" := "Entry Type"::Consumption;

        "Order Type" := "Order Type"::Production;
    end;

    var
        Text000: Label 'You cannot use entry type %1 in this journal.';
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        CalcWhseAdjmt: Report "Calculate Whse. Adjustment";
        CurrentJnlBatchName: Code[10];
        ItemDescription: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        Text001: Label 'Item Journal lines have been successfully inserted from Standard Item Journal %1.';
        Text002: Label 'Standard Item Journal %1 has been successfully created.';
        OpenedFromBatch: Boolean;
        "--------------Samadhan------------": Text;
        Item: Record Item;
        LastLineNo: Integer;
        RollMaster: Record "Item Variant";
        IJL: Record "Item Journal Line";
        IJLOld: Record "Item Journal Line";

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;
}

