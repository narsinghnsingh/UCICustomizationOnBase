page 50173 "Material Return to Store"
{
    // version Requisition

    AutoSplitKey = true;
    CaptionML = ENU = 'Material Return to Store';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SaveValues = true;
    SourceTable = "Item Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                CaptionML = ENU = 'Batch Name';
                Editable = false;
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
            grid(Control11)
            {
                ShowCaption = false;
                field(RequisitionNumber; RequisitionNumber)
                {
                    CaptionML = ENU = 'Requisition No.';
                    TableRelation = "Requisition Header"."Requisition No." WHERE ("Requisition Type" = CONST ("Production Schedule"),
                                                                                  Status = CONST (Released));
                }
                field("Item Identifier BAR Code"; ItemIdentifierBARCode)
                {

                    trigger OnValidate()
                    begin

                        // Lines added By Deepak Kumar
                        if RequisitionNumber = '' then
                            Error('Requisition No. must not be blank');

                        ItemIdentifier.Reset;
                        ItemIdentifier.SetRange(ItemIdentifier.Code, ItemIdentifierBARCode);
                        if ItemIdentifier.FindFirst then begin
                            RequistionLine.Reset;
                            RequistionLine.SetRange(RequistionLine."Requisition No.", RequisitionNumber);
                            RequistionLine.SetRange(RequistionLine."Item No.", ItemIdentifier."Item No.");
                            if not RequistionLine.FindFirst then
                                Error('Item not available in material requisition line, Please check the Bar Code');


                            ItemIdentifier.TestField(ItemIdentifier."Variant Code");
                            ItemVariant.Reset;
                            ItemVariant.SetRange(ItemVariant."Item No.", ItemIdentifier."Item No.");
                            ItemVariant.SetRange(ItemVariant.Code, ItemIdentifier."Variant Code");
                            if ItemVariant.FindFirst then begin
                                ItemVariant.TestField(ItemVariant.Status, ItemVariant.Status::Open);

                                ItemJnlLineCurr.Reset;
                                ItemJnlLineCurr.SetRange(ItemJnlLineCurr."Journal Template Name", "Journal Template Name");
                                ItemJnlLineCurr.SetRange(ItemJnlLineCurr."Journal Batch Name", "Journal Batch Name");
                                ItemJnlLineCurr.SetRange(ItemJnlLineCurr."Item No.", ItemIdentifier."Item No.");
                                ItemJnlLineCurr.SetRange(ItemJnlLineCurr."Variant Code", ItemIdentifier."Variant Code");
                                if ItemJnlLineCurr.FindFirst then
                                    Error('Item Number %1 Roll/ Variant No. %2 Line already exits, Ref. Line No. %3 ', ItemJnlLineCurr."Item No.", ItemJnlLineCurr."Variant Code", ItemJnlLineCurr."Line No.");

                                ItemJnlLineCurr.Reset;
                                ItemJnlLineCurr.SetRange(ItemJnlLineCurr."Journal Template Name", "Journal Template Name");
                                ItemJnlLineCurr.SetRange(ItemJnlLineCurr."Journal Batch Name", "Journal Batch Name");
                                if ItemJnlLineCurr.FindLast then
                                    TempLineNumber := ItemJnlLineCurr."Line No." + 1000
                                else
                                    TempLineNumber := 1000;


                                ItemJournalLineN.Init;
                                ItemJournalLineN."Journal Template Name" := "Journal Template Name";
                                ItemJournalLineN."Journal Batch Name" := "Journal Batch Name";
                                ItemJournalLineN."Line No." := TempLineNumber;
                                SourceCodeSetup.Get;
                                ItemJournalLineN.Validate("Source Code", SourceCodeSetup."Item Reclass. Journal");
                                ItemJournalLineN.Validate("Entry Type", ItemJournalLineN."Entry Type"::Transfer);
                                ItemJournalLineN.Validate("Posting Date", WorkDate);
                                ItemJournalLineN."Document No." := RequisitionNumber + '_TR';//FORMAT(WORKDATE);
                                RequisitionHeader.Reset;
                                RequisitionHeader.SetRange(RequisitionHeader."Requisition Type", RequisitionHeader."Requisition Type"::"Production Schedule");
                                RequisitionHeader.SetRange(RequisitionHeader."Requisition No.", RequisitionNumber);
                                if RequisitionHeader.FindFirst then
                                    ItemJournalLineN."External Document No." := RequisitionHeader."Schedule Document No.";

                                RequistionLine.Reset;
                                RequistionLine.SetRange(RequistionLine."Requisition No.", RequisitionNumber);
                                RequistionLine.SetRange(RequistionLine."Item No.", ItemIdentifier."Item No.");
                                RequistionLine.FindFirst;
                                ItemJournalLineN."Requisition No." := RequisitionNumber;
                                ItemJournalLineN."Requisition Line No." := RequistionLine."Requisition Line No.";

                                ItemJournalLineN.Validate("Item No.", ItemIdentifier."Item No.");
                                ItemJournalLineN.Validate("Variant Code", ItemIdentifier."Variant Code");
                                ItemVariant.CalcFields(ItemVariant."Remaining Quantity");
                                ItemJournalLineN.Validate(Quantity, ItemVariant."Remaining Quantity");
                                MfgSetup.Get;
                                MfgSetup.TestField(MfgSetup."Def. Store Location");
                                ItemJournalLineN.Validate(ItemJournalLineN."New Location Code", MfgSetup."Def. Store Location");
                                ItemLedgEntry.Reset;
                                ItemLedgEntry.SetCurrentKey("Item No.");
                                ItemLedgEntry.SetRange("Item No.", ItemIdentifier."Item No.");
                                if ItemLedgEntry.FindLast then
                                    ItemJournalLineN."Last Item Ledger Entry No." := ItemLedgEntry."Entry No."
                                else
                                    ItemJournalLineN."Last Item Ledger Entry No." := 0;

                                ItemJournalLineN.Insert(true);
                            end;
                            ItemIdentifierBARCode := '';
                        end else begin
                            Error('Item Identifier not available, please check the Identifier values');
                        end;
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetItem("Item No.", ItemDescription);
                        ShowShortcutDimCode(ShortcutDimCode);
                        ShowNewShortcutDimCode(NewShortcutDimCode);
                    end;
                }
                field("Variant Code"; "Variant Code")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                    Visible = true;

                    trigger OnValidate()
                    var
                        WMSManagement: Codeunit "WMS Management";
                    begin
                        WMSManagement.CheckItemJnlLineLocation(Rec, xRec);
                    end;
                }
                field("New Location Code"; "New Location Code")
                {

                    trigger OnValidate()
                    var
                        WMSManagement: Codeunit "WMS Management";
                    begin
                        WMSManagement.CheckItemJnlLineLocation(Rec, xRec);
                    end;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
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
            group("&Line")
            {
                CaptionML = ENU = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowReclasDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
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
                group("Item Availability by")
                {
                    CaptionML = ENU = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        CaptionML = ENU = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        CaptionML = ENU = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        CaptionML = ENU = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location = R;
                        CaptionML = ENU = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        CaptionML = ENU = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
            }
        }
        area(processing)
        {
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
            action("Get Rolls to Return")
            {
                CaptionML = ENU = 'Get Rolls to Return';
                Image = ReturnRelated;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ManufacturingSetup: Record "Manufacturing Setup";
                begin
                    // Lines added bY Depak Kumar
                    if RequisitionNumber = '' then
                        Error('Requisition No. must not be blank');

                    ManufacturingSetup.Get;
                    ItemLedgerEntry.Reset;
                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Requisition No.", RequisitionNumber);
                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Transfer);
                    ItemLedgerEntry.SetRange(ItemLedgerEntry.Positive, true);
                    ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", ManufacturingSetup."Corrugation Location");
                    if ItemLedgerEntry.FindFirst then begin
                        TempLineNumber := 10000;
                        repeat
                            if ItemLedgerEntry."Remaining Quantity" <> 0 then begin
                                ItemJournalLineN.Init;
                                ItemJournalLineN."Journal Template Name" := "Journal Template Name";
                                ItemJournalLineN."Journal Batch Name" := "Journal Batch Name";
                                ItemJournalLineN."Line No." := TempLineNumber;
                                SourceCodeSetup.Get;
                                ItemJournalLineN.Validate("Source Code", SourceCodeSetup."Item Reclass. Journal");
                                ItemJournalLineN.Validate("Entry Type", ItemJournalLineN."Entry Type"::Transfer);
                                ItemJournalLineN.Validate("Posting Date", WorkDate);
                                ItemJournalLineN."Document No." := RequisitionNumber + '_TR';//FORMAT(WORKDATE);
                                RequisitionHeader.Reset;
                                RequisitionHeader.SetRange(RequisitionHeader."Requisition Type", RequisitionHeader."Requisition Type"::"Production Schedule");
                                RequisitionHeader.SetRange(RequisitionHeader."Requisition No.", RequisitionNumber);
                                if RequisitionHeader.FindFirst then
                                    ItemJournalLineN."External Document No." := RequisitionHeader."Schedule Document No.";
                                ItemJournalLineN."Requisition No." := RequisitionNumber;
                                ItemJournalLineN.Validate("Item No.", ItemLedgerEntry."Item No.");
                                ItemJournalLineN.Validate("Variant Code", ItemLedgerEntry."Variant Code");

                                ItemJournalLineN.Validate(Quantity, ItemLedgerEntry."Remaining Quantity");
                                MfgSetup.Get;
                                MfgSetup.TestField(MfgSetup."Def. Store Location");
                                ItemJournalLineN.Validate(ItemJournalLineN."New Location Code", MfgSetup."Def. Store Location");
                                ItemLedgEntry.Reset;
                                ItemLedgEntry.SetCurrentKey("Item No.");
                                ItemLedgEntry.SetRange("Item No.", ItemIdentifier."Item No.");
                                if ItemLedgEntry.FindLast then
                                    ItemJournalLineN."Last Item Ledger Entry No." := ItemLedgEntry."Entry No."
                                else
                                    ItemJournalLineN."Last Item Ledger Entry No." := 0;

                                ItemJournalLineN.Insert(true);

                                TempLineNumber := TempLineNumber + 10000;
                            end;
                        until ItemLedgerEntry.Next = 0;
                        Message('Complete');
                    end;
                end;
            }
            action("Item Reclass. Journal")
            {
                CaptionML = ENU = 'Item Reclass. Journal';
                Image = Recalculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Reclass. Journal";
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
        ShowNewShortcutDimCode(NewShortcutDimCode);
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
        Clear(NewShortcutDimCode);
        "Entry Type" := "Entry Type"::Transfer;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') and ("Journal Template Name" = '');
        if OpenedFromBatch then begin
            //CurrentJnlBatchName := "Journal Batch Name";
            CurrentJnlBatchName := 'ITEMRETURN';
            ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        ItemJnlMgt.TemplateSelection(PAGE::"Item Reclass. Journal", 1, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        CurrentJnlBatchName := 'ITEMRETURN';
        ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        Text000: Label '1,2,3,New ';
        Text001: Label '1,2,4,New ';
        Text002: Label '1,2,5,New ';
        Text003: Label '1,2,6,New ';
        Text004: Label '1,2,7,New ';
        Text005: Label '1,2,8,New ';
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        CurrentJnlBatchName: Code[10];
        ItemDescription: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        NewShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        ItemIdentifierBARCode: Code[100];
        ItemIdentifier: Record "Item Identifier";
        ItemVariant: Record "Item Variant";
        ItemJnlLineCurr: Record "Item Journal Line";
        TempLineNumber: Integer;
        ItemJournalLineN: Record "Item Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntry: Record "Item Ledger Entry";
        RequisitionNumber: Code[50];
        RequistionLine: Record "Requisition Line SAM";
        MfgSetup: Record "Manufacturing Setup";
        RequisitionHeader: Record "Requisition Header";

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;
}

