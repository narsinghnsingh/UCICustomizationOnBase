page 50170 "Bar Code Phys. Inventory Jnl"
{
    // version NAVW18.00

    AutoSplitKey = true;
    CaptionML = ENU = 'Phys. Inventory Journal';
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
            field(ItemIdentifierBARCode; ItemIdentifierBARCode)
            {
                CaptionML = ENU = 'Item Identifier ( Bar Code)';

                trigger OnValidate()
                begin
                    // Lines added By Deepak Kumar
                    ItemIdentifier.Reset;
                    ItemIdentifier.SetRange(ItemIdentifier.Code, ItemIdentifierBARCode);
                    if ItemIdentifier.FindFirst then begin

                        if ItemIdentifier."Variant Code" <> '' then begin
                            ItemVariant.Reset;
                            ItemVariant.SetRange(ItemVariant."Item No.", ItemIdentifier."Item No.");
                            ItemVariant.SetRange(ItemVariant.Code, ItemIdentifier."Variant Code");
                            if ItemVariant.FindFirst then begin
                                if ItemVariant.Status <> ItemVariant.Status::Open then
                                    Error('Roll is not in Use Status, Please Complete the Quality Process');

                                ItemJnlLineCurr.Reset;
                                ItemJnlLineCurr.SetRange(ItemJnlLineCurr."Journal Template Name", "Journal Template Name");
                                ItemJnlLineCurr.SetRange(ItemJnlLineCurr."Journal Batch Name", "Journal Batch Name");
                                if ItemJnlLineCurr.FindLast then
                                    TempLineNumber := ItemJnlLineCurr."Line No." + 1000;

                                ItemJournalLineN.Init;
                                ItemJournalLineN."Journal Template Name" := "Journal Template Name";
                                ItemJournalLineN."Journal Batch Name" := "Journal Batch Name";
                                ItemJournalLineN."Line No." := TempLineNumber;
                                SourceCodeSetup.Get;
                                ItemJournalLineN.Validate("Source Code", SourceCodeSetup."Phys. Inventory Journal");
                                ItemJournalLineN."Source Code" := 'PHYSINVJNL';
                                ItemJournalLineN.Validate("Posting Date", WorkDate);
                                ItemJournalLineN."Document No." := 'PHY-' + Format(WorkDate);
                                ItemJournalLineN.Validate("Item No.", ItemIdentifier."Item No.");
                                ItemJournalLineN.Validate("Variant Code", ItemIdentifier."Variant Code");
                                ItemVariant.CalcFields(ItemVariant."Remaining Quantity");
                                ItemJournalLineN."Qty. (Phys. Inventory)" := ItemVariant."Remaining Quantity";
                                ItemJournalLineN."Phys. Inventory" := true;
                                ItemJournalLineN.Validate("Qty. (Calculated)", ItemVariant."Remaining Quantity");

                                ItemLedgEntry.Reset;
                                ItemLedgEntry.SetCurrentKey("Item No.");
                                ItemLedgEntry.SetRange("Item No.", ItemIdentifier."Item No.");
                                if ItemLedgEntry.FindLast then
                                    ItemJournalLineN."Last Item Ledger Entry No." := ItemLedgEntry."Entry No."
                                else
                                    ItemJournalLineN."Last Item Ledger Entry No." := 0;

                                ItemJournalLineN.Insert(true);
                            end;
                        end;
                        ItemIdentifierBARCode := '';
                    end else begin
                        Error('Item Identifier not available, please check the Identifier values');
                    end;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Entry Type"; "Entry Type")
                {
                    OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';
                }
                field("Document No."; "Document No.")
                {
                }
                field("Item No."; "Item No.")
                {

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetItem("Item No.", ItemDescription);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Variant Code"; "Variant Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Visible = false;
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
                field("Bin Code"; "Bin Code")
                {
                    Visible = false;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
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
                field("Qty. (Calculated)"; "Qty. (Calculated)")
                {
                }
                field("Qty. (Phys. Inventory)"; "Qty. (Phys. Inventory)")
                {
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Visible = false;
                }
                field("Unit Amount"; "Unit Amount")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    Visible = false;
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                    Visible = false;
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
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Item &Tracking Lines")
                {
                    CaptionML = ENU = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines(false);
                    end;
                }
                action("Bin Contents")
                {
                    CaptionML = ENU = 'Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Contents List";
                    RunPageLink = "Location Code" = FIELD ("Location Code"),
                                  "Item No." = FIELD ("Item No."),
                                  "Variant Code" = FIELD ("Variant Code");
                    RunPageView = SORTING ("Location Code", "Item No.", "Variant Code");
                    Scope = Repeater;
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
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    CaptionML = ENU = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No." = FIELD ("Item No.");
                    RunPageView = SORTING ("Item No.");
                    Scope = Repeater;
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Phys. In&ventory Ledger Entries")
                {
                    CaptionML = ENU = 'Phys. In&ventory Ledger Entries';
                    Image = PhysicalInventoryLedger;
                    RunObject = Page "Phys. Inventory Ledger Entries";
                    RunPageLink = "Item No." = FIELD ("Item No.");
                    RunPageView = SORTING ("Item No.");
                    Scope = Repeater;
                }
                group("Item Availability by")
                {
                    CaptionML = ENU = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        CaptionML = ENU = 'Event';
                        Image = "Event";
                        Scope = Repeater;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        CaptionML = ENU = 'Period';
                        Image = Period;
                        Scope = Repeater;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        CaptionML = ENU = 'Variant';
                        Image = ItemVariant;
                        Scope = Repeater;

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
                        Scope = Repeater;

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        CaptionML = ENU = 'BOM Level';
                        Image = BOMLevel;
                        Scope = Repeater;

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
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions';
                Image = "Action";
                action(CalculateInventory)
                {
                    CaptionML = ENU = 'Calculate &Inventory';
                    Ellipsis = true;
                    Image = CalculateInventory;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        CalcQtyOnHand.SetItemJnlLine(Rec);
                        CalcQtyOnHand.RunModal;
                        Clear(CalcQtyOnHand);
                    end;
                }
                action(CalculateCountingPeriod)
                {
                    CaptionML = ENU = '&Calculate Counting Period';
                    Ellipsis = true;
                    Image = CalculateCalendar;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        PhysInvtCountMgt.InitFromItemJnl(Rec);
                        PhysInvtCountMgt.Run;
                        Clear(PhysInvtCountMgt);
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
                Scope = Repeater;

                trigger OnAction()
                begin
                    ItemJournalBatch.SetRange("Journal Template Name", "Journal Template Name");
                    ItemJournalBatch.SetRange(Name, "Journal Batch Name");
                    PhysInventoryList.SetTableView(ItemJournalBatch);
                    PhysInventoryList.RunModal;
                    Clear(PhysInventoryList);
                end;
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
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintItemJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    CaptionML = ENU = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
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
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
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
        ItemJnlMgt.TemplateSelection(PAGE::"Phys. Inventory Journal", 2, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        ItemJournalBatch: Record "Item Journal Batch";
        CalcQtyOnHand: Report "Calculate Inventory";
        PhysInventoryList: Report "Phys. Inventory List";
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        CurrentJnlBatchName: Code[10];
        ItemDescription: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        ItemIdentifierBARCode: Code[50];
        ItemIdentifier: Record "Item Identifier";
        ItemVariant: Record "Item Variant";
        ItemJnlLineCurr: Record "Item Journal Line";
        ItemJournalLineN: Record "Item Journal Line";
        TempLineNumber: Integer;
        SourceCodeSetup: Record "Source Code Setup";
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemMaster: Record Item;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;
}

