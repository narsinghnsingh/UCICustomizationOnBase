page 50133 "LC Value Update"
{
    // version LC Detail

    AutoSplitKey = true;
    CaptionML = ENU = 'LC Value Update';
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
            field(LCDetails; LCDetails)
            {
                TableRelation = "LC Detail"."No." WHERE (Released = CONST (true),
                                                         Closed = CONST (false));
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
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

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetItem("Item No.", ItemDescription);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Variant Code"; "Variant Code")
                {
                    Editable = false;
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
                    Editable = false;
                    Visible = true;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
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
                    Visible = false;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Unit Cost (Calculated)"; "Unit Cost (Calculated)")
                {
                }
                field("Inventory Value (Calculated)"; "Inventory Value (Calculated)")
                {
                }
                field("Unit Cost (Revalued)"; "Unit Cost (Revalued)")
                {
                }
                field("Inventory Value (Revalued)"; "Inventory Value (Revalued)")
                {
                }
                field("Applies-to Entry"; "Applies-to Entry")
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    Visible = false;
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
                        field(TotalLCILEQuantity; TotalLCILEQuantity)
                        {
                            CaptionML = ENU = 'Total Receipt Quantity';
                        }
                        field(TotalLCCharges; TotalLCCharges)
                        {
                            CaptionML = ENU = 'Total Charges Value';
                        }
                        field(CostAmountPerUnit; CostAmountPerUnit)
                        {
                            CaptionML = ENU = 'Amount Per Unit';
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

                        // Lines addeed BY Deepak Kumar
                        LCDetail.Reset;
                        LCDetail.SetRange(LCDetail."No.", LCDetails);
                        if LCDetail.FindFirst then begin
                            LCDetail."LC Charge Posted" := true;
                            LCDetail.Modify(true);
                        end;

                        CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Calculate Data")
                {
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // Lines Added bY Deepak Kumar
                        DeleteAll(true);
                        // Lines addeed BY Deepak Kumar
                        LCDetail.Reset;
                        LCDetail.SetRange(LCDetail."No.", LCDetails);
                        if LCDetail.FindFirst then
                            LCDetail.TestField(LCDetail."LC Charge Posted", false);

                        TotalLCCharges := 0;
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."LC No.", LCDetails);
                        if GLEntry.FindFirst then begin
                            repeat
                                TotalLCCharges += GLEntry."Debit Amount";
                            until GLEntry.Next = 0;
                        end;

                        TotalLCILEQuantity := 0;
                        TotalLCILEValue := 0;

                        PurchRCtHeader.Reset;
                        PurchRCtHeader.SetRange(PurchRCtHeader."LC No.", LCDetails);
                        if PurchRCtHeader.FindFirst then begin
                            repeat
                                ItemLedger.Reset;
                                ItemLedger.SetRange(ItemLedger."Document No.", PurchRCtHeader."No.");
                                ItemLedger.SetRange(ItemLedger.Positive, true);
                                if ItemLedger.FindFirst then begin
                                    repeat
                                        TotalLCILEQuantity += ItemLedger.Quantity;
                                        TotalLCILEValue += ItemLedger."Cost Amount (Actual)";
                                    until ItemLedger.Next = 0;
                                end;
                            until PurchRCtHeader.Next = 0;
                        end;
                        if TotalLCILEQuantity > 0 then
                            CostAmountPerUnit := TotalLCCharges / TotalLCILEQuantity
                        else
                            CostAmountPerUnit := 1;

                        TempLineNumber := 0;
                        PurchRCtHeader.Reset;
                        PurchRCtHeader.SetRange(PurchRCtHeader."LC No.", LCDetails);
                        if PurchRCtHeader.FindFirst then begin
                            repeat
                                ItemLedger.Reset;
                                ItemLedger.SetRange(ItemLedger."Document No.", PurchRCtHeader."No.");
                                ItemLedger.SetRange(ItemLedger.Positive, true);
                                if ItemLedger.FindFirst then begin
                                    repeat
                                        ItemJournalLine.Init;
                                        ItemJournalLine."Journal Template Name" := 'REVALUATIO';
                                        ItemJournalLine."Journal Batch Name" := 'DEFAULT';
                                        ItemJournalLine."Source Code" := 'REVALJNL';
                                        ItemJournalLine."Document No." := LCDetails;
                                        ItemJournalLine."Line No." := TempLineNumber;
                                        TempLineNumber += 10;
                                        ItemJournalLine."Value Entry Type" := ItemJournalLine."Value Entry Type"::Revaluation;
                                        ItemJournalLine.Validate("Item No.", ItemLedger."Item No.");
                                        ItemJournalLine.Validate("Applies-to Entry", ItemLedger."Entry No.");
                                        ItemJournalLine.Validate("Unit Cost (Revalued)", (ItemJournalLine."Unit Cost (Calculated)" + CostAmountPerUnit));
                                        ItemJournalLine.Insert(true);
                                    until ItemLedger.Next = 0;
                                end;
                            until PurchRCtHeader.Next = 0;
                        end;
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
        ItemJnlMgt.TemplateSelection(PAGE::"Revaluation Journal", 3, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');

        ItemJnlMgt.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        CalcInvtValue: Report "Calculate Inventory Value";
        ItemJnlMgt: Codeunit ItemJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        CurrentJnlBatchName: Code[10];
        ItemDescription: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        Text001: Label 'To make sure that all items are adjusted before you start the revaluation, you should run the %1 batch job first.\Do you want to continue with the revaluation?';
        OpenedFromBatch: Boolean;
        LCDetails: Code[50];
        PurchRCtHeader: Record "Purch. Rcpt. Header";
        ItemLedger: Record "Item Ledger Entry";
        ItemJournalLine: Record "Item Journal Line";
        TempLineNumber: Integer;
        GLEntry: Record "G/L Entry";
        TotalLCCharges: Decimal;
        TotalLCILEQuantity: Decimal;
        TotalLCILEValue: Decimal;
        CostAmountPerUnit: Decimal;
        LCDetail: Record "LC Detail";

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ItemJnlMgt.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;
}

