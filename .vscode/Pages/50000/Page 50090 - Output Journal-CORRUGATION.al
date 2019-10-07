page 50090 "Output Journal-CORRUGATION"
{
    // version NAVW17.00,Samadhan

    // B2B Software Technologies
    // -----------------------------------------
    // Project : Plant Maintenance Addon
    // B2BPLM1.00.00
    // No. Sign          Dev     Date            Description
    // --------------------------------------------------------------------------
    // 01  B2BPLM1.00.00                        Added Fields(Routing No, Machine Id)

    AutoSplitKey = true;
    CaptionML = ENU = 'Output Journal';
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
                    ItemJnlMgt.CheckName(CurrentJnlBatchName, Rec);
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
                field("Document No."; "Document No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Order No."; "Order No.")
                {

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetOutput(Rec, ProdOrderDescription, OperationName);
                    end;
                }
                field("Order Line No."; "Order Line No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                }
                field("Item No."; "Item No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupItemNo;
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Operation No."; "Operation No.")
                {

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetOutput(Rec, ProdOrderDescription, OperationName);
                    end;
                }
                field("Work Shift Code"; "Work Shift Code")
                {
                }
                field("Starting Time"; "Starting Time")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = true;
                    TableRelation = "Dimension Value".Name WHERE ("Dimension Code" = CONST ('EMPLOYEE'));
                }
                field("Start Date"; "Start Date")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("Run Time"; "Run Time")
                {
                }
                field("Output Quantity"; "Output Quantity")
                {
                }
                field("Scrap Quantity"; "Scrap Quantity")
                {
                }
                field("Schedule Doc. No."; "Schedule Doc. No.")
                {
                }
                field("Posted Output Qty"; "Posted Output Qty")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Part Code"; "Part Code")
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
                field("Scrap Code"; "Scrap Code")
                {
                }
                field("Setup Time"; "Setup Time")
                {
                }
                field("Stop Time"; "Stop Time")
                {
                }
                field("Cap. Unit of Measure Code"; "Cap. Unit of Measure Code")
                {
                }
                field("Stop Code"; "Stop Code")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                    Visible = true;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("External Document No."; "External Document No.")
                {
                    Visible = false;
                }
                field("Applies-to Entry"; "Applies-to Entry")
                {
                }
            }
            group(Control73)
            {
                ShowCaption = false;
                fixed(Control1902114901)
                {
                    ShowCaption = false;
                    group("Prod. Order Name")
                    {
                        CaptionML = ENU = 'Prod. Order Name';
                        field(ProdOrderDescription; ProdOrderDescription)
                        {
                            Editable = false;
                        }
                    }
                    group(Operation)
                    {
                        CaptionML = ENU = 'Operation';
                        field(OperationName; OperationName)
                        {
                            CaptionML = ENU = 'Operation';
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
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Item Tracking Lines")
                {
                    CaptionML = ENU = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
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
                    RunPageView = SORTING ("Location Code", "Bin Code", "Item No.", "Variant Code");
                }
            }
            group("Pro&d. Order")
            {
                CaptionML = ENU = 'Pro&d. Order';
                Image = "Order";
                action(Card)
                {
                    CaptionML = ENU = 'Card';
                    Image = EditLines;
                    RunObject = Page "Released Production Order";
                    RunPageLink = "No." = FIELD ("Order No.");
                    ShortCutKey = 'Shift+F7';
                }
                group("Ledger E&ntries")
                {
                    CaptionML = ENU = 'Ledger E&ntries';
                    Image = Entries;
                    action("Item Ledger E&ntries")
                    {
                        CaptionML = ENU = 'Item Ledger E&ntries';
                        Image = ItemLedger;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("Order No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action("Capacity Ledger Entries")
                    {
                        CaptionML = ENU = 'Capacity Ledger Entries';
                        Image = CapacityLedger;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Capacity Ledger Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("Order No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
                    }
                    action("Value Entries")
                    {
                        CaptionML = ENU = 'Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Order Type" = CONST (Production),
                                      "Order No." = FIELD ("Order No.");
                        RunPageView = SORTING ("Order Type", "Order No.");
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
                action("Explode &Routing")
                {
                    CaptionML = ENU = 'Explode &Routing';
                    Image = ExplodeRouting;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Output Jnl.-Expl. Route";
                    Visible = false;
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
                        TrySetApplyToEntries;
                        PostingItemJnlFromProduction(false);
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
                        TrySetApplyToEntries;
                        PostingItemJnlFromProduction(true);
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
        ItemJnlMgt.GetOutput(Rec, ProdOrderDescription, OperationName);
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
        Validate("Entry Type", "Entry Type"::Output);
        Clear(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') and ("Journal Template Name" = '');
        if OpenedFromBatch then begin
            //CurrentJnlBatchName := "Journal Batch Name";
            CurrentJnlBatchName := 'CORRUG';
            ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        ItemJnlMgt.TemplateSelection(PAGE::"Output Journal", 5, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        CurrentJnlBatchName := 'CORRUG';
        ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ProdOrderDescription: Text[250];
        OperationName: Text[250];
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        //SubsCribs:Codeunit CodeunitSubscriber
    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    procedure TrySetApplyToEntries()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemJournalLine2: Record "Item Journal Line";
        ReservationEntry: Record "Reservation Entry";
    begin
        ItemJournalLine2.Copy(Rec);
        if ItemJournalLine2.FindSet then
            repeat
                if FindReservationsReverseOutput(ReservationEntry, ItemJournalLine2) then
                    repeat
                        if FindILEFromReservation(ItemLedgerEntry, ItemJournalLine2, ReservationEntry, "Order No.") then begin
                            ReservationEntry.Validate("Appl.-to Item Entry", ItemLedgerEntry."Entry No.");
                            ReservationEntry.Modify(true);
                        end;
                    until ReservationEntry.Next = 0;

            until ItemJournalLine2.Next = 0;
    end;

    local procedure FindReservationsReverseOutput(var ReservationEntry: Record "Reservation Entry"; ItemJnlLine: Record "Item Journal Line"): Boolean
    begin
        if ItemJnlLine.Quantity >= 0 then
            exit(false);

        ReservationEntry.SetCurrentKey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name", "Source Prod. Order Line");
        ReservationEntry.SetRange("Source ID", ItemJnlLine."Journal Template Name");
        ReservationEntry.SetRange("Source Ref. No.", ItemJnlLine."Line No.");
        ReservationEntry.SetRange("Source Type", DATABASE::"Item Journal Line");
        ReservationEntry.SetRange("Source Subtype", ItemJnlLine."Entry Type");
        ReservationEntry.SetRange("Source Batch Name", ItemJnlLine."Journal Batch Name");

        ReservationEntry.SetFilter("Serial No.", '<>%1', '');
        ReservationEntry.SetRange("Qty. to Handle (Base)", -1);
        ReservationEntry.SetRange("Appl.-to Item Entry", 0);

        exit(ReservationEntry.FindSet);
    end;

    local procedure FindILEFromReservation(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJnlLine: Record "Item Journal Line"; ReservationEntry: Record "Reservation Entry"; ProductionOrderNo: Code[20]): Boolean
    begin
        ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive,
          "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.");

        ItemLedgerEntry.SetRange("Item No.", ItemJnlLine."Item No.");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange("Variant Code", ItemJnlLine."Variant Code");
        ItemLedgerEntry.SetRange(Positive, true);
        ItemLedgerEntry.SetRange("Location Code", ItemJnlLine."Location Code");
        ItemLedgerEntry.SetRange("Serial No.", ReservationEntry."Lot No.");
        ItemLedgerEntry.SetRange("Serial No.", ReservationEntry."Serial No.");
        ItemLedgerEntry.SetRange("Document No.", ProductionOrderNo);

        exit(ItemLedgerEntry.FindSet);
    end;
}

