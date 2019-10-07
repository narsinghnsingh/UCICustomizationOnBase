Page 50234 "Output Journal Board Swap"
{
    CaptionML = ENU = 'Output Journal Board Swap';
    SourceTable = "Item Journal Line";
    DataCaptionFields = "Journal Batch Name";
    PageType = Worksheet;
    AutoSplitKey = true;
    DelayedInsert = true;
    UsageCategory = Tasks;
    SaveValues = true;
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
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
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
                field("Employee Name"; "Employee Name")
                {
                    Editable = true;
                    TableRelation = "Dimension Value".Name WHERE ("Dimension Code" = CONST ('EMPLOYEE'));
                }

                field("Output Quantity"; "Output Quantity")
                {
                    trigger OnValidate()
                    begin
                        IF "Old Prod. Order Qty." <> 0 THEN begin
                            IF "Old Prod. Order Qty." <> "Output Quantity" then
                                Error('Output Quantity should be equal to Old Prod. Order Qty');
                        END;
                    end;
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
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Visible = false;
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
                field("Old Production Order No."; "Old Production Order No.")
                {

                }
                field("Old Prod. Order Line No."; "Old Prod. Order Line No.")
                {

                }
                field("Old Prod. Order Item No."; "Old Prod. Order Item No.")
                {

                }
                field("Old Prod. Order Qty."; "Old Prod. Order Qty.")
                {

                }
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
                        SwapBoard();
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
        "Additional Output" := TRUE;
        "Swap Output" := true;
        "Order Type" := "Order Type"::Production;
        "Run Time" := 0;
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

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali();
    BEGIN
        CurrPage.SAVERECORD;
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(FALSE);
    END;

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

    LOCAL PROCEDURE SwapBoard()
    VAR
        ItemJournalLine: Record 83;
        ItemJournalLineNew: Record 83;
        LineNum: Integer;
        ItemLedgerEntry: Record 32;
        CapacityLedger: Record "Capacity Ledger Entry";
        Item: Record item;
    BEGIN
        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", "Journal Template Name");
        ItemJournalLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
        IF ItemJournalLine.FINDLAST THEN
            LineNum := ItemJournalLine."Line No."
        ELSE
            LineNum := 0;

        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", "Journal Template Name");
        ItemJournalLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
        ItemJournalLine.SETRANGE("Entry Type", ItemJournalLine."Entry Type"::Output);
        ItemJournalLine.SetRange("Swap Output", true);
        IF ItemJournalLine.FINDSET THEN
            REPEAT
                ItemJournalLine.TESTFIELD("Old Production Order No.");
                ItemJournalLine.TESTFIELD("Old Prod. Order Line No.");
                ItemJournalLine.TESTFIELD("Old Prod. Order Item No.");
                ItemJournalLine.TESTFIELD("Old Prod. Order Qty.");
                ItemJournalLineNew.INIT;
                ItemJournalLineNew.VALIDATE("Journal Template Name", ItemJournalLine."Journal Template Name");
                ItemJournalLineNew.VALIDATE("Journal Batch Name", ItemJournalLine."Journal Batch Name");
                ItemJournalLineNew."Line No." := LineNum + 10000;
                ItemJournalLineNew.VALIDATE("Posting Date", ItemJournalLine."Posting Date");
                ItemJournalLineNew."Entry Type" := ItemJournalLine."Entry Type"::Output;
                ItemJournalLineNew.VALIDATE("Document No.", ItemJournalLine."Document No.");
                ItemJournalLineNew.Validate("Order Type", ItemJournalLineNew."Order Type"::Production);
                ItemJournalLineNew."Order No." := ItemJournalLine."Old Production Order No.";
                ItemJournalLineNew."Order Line No." := ItemJournalLine."Old Prod. Order Line No.";
                ItemJournalLineNew.VALIDATE("Item No.", ItemJournalLine."Old Prod. Order Item No.");
                ItemJournalLineNew.VALIDATE("Output Quantity", -ItemJournalLine."Old Prod. Order Qty.");
                ItemJournalLineNew."Swap Output" := false;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SetCurrentKey("Entry No.");
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
                ItemLedgerEntry.SETRANGE("Order No.", ItemJournalLine."Old Production Order No.");
                ItemLedgerEntry.SETRANGE("Order Line No.", ItemJournalLine."Old Prod. Order Line No.");
                ItemLedgerEntry.SETRANGE("Item No.", ItemJournalLine."Old Prod. Order Item No.");
                ItemLedgerEntry.SETFILTER("Remaining Quantity", '>=%1', "Old Prod. Order Qty.");
                IF ItemLedgerEntry.FINDFIRST THEN begin
                    CapacityLedger.Reset();
                    CapacityLedger.SetRange("Order No.", ItemLedgerEntry."Order No.");
                    CapacityLedger.SetRange("Order Line No.", ItemLedgerEntry."Order Line No.");
                    CapacityLedger.SetRange("Document No.", ItemLedgerEntry."Document No.");
                    CapacityLedger.SetRange("Item No.", ItemLedgerEntry."Item No.");
                    if CapacityLedger.FindFirst() then begin
                        ItemJournalLineNew.Validate("Operation No.", CapacityLedger."Operation No.");
                        ItemJournalLineNew.validate("Work Shift Code", CapacityLedger."Work Shift Code");
                    End;
                    ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                    IF ItemLedgerEntry."Cost Amount (Actual)" <> 0 THEN
                        ItemJournalLineNew.Validate("Unit Cost", (ItemLedgerEntry."Cost Amount (Actual)" / ItemLedgerEntry.Quantity))
                    else begin
                        Item.GET(ItemLedgerEntry."Item No.");
                        ItemJournalLineNew.Validate("Unit Cost", item."Unit Cost");
                    END;
                    ItemJournalLineNew.VALIDATE("Applies-to Entry", ItemLedgerEntry."Entry No.");
                End;
                ItemJournalLineNew.VALIDATE("Run Time", 0);
                ItemJournalLineNew.INSERT;
                ItemJournalLine.Validate("Unit Cost", ItemJournalLineNew."Unit Cost");
                ItemJournalLine.Modify();
            UNTIL ItemJournalLine.NEXT = 0;
    END;
}