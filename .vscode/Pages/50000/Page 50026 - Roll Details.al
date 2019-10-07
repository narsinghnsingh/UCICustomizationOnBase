page 50026 "Roll Details"
{
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "Item Variant";
    SourceTableView = SORTING ("Item No.", Code)
                      ORDER(Ascending)
                      WHERE (Status = CONST (" "));

    layout
    {
        area(content)
        {
            repeater(Control8)
            {
                ShowCaption = false;
                field("Roll Weight"; "Roll Weight")
                {

                    trigger OnValidate()
                    begin
                        if Code = '' then begin
                            PurchSetup.Get;
                            PurchSetup.TestField(PurchSetup."Paper Roll No Series");
                            NoSeriesMgt.InitSeries(PurchSetup."Paper Roll No Series", '', 0D, Code, PurchSetup."Paper Roll No Series");
                        end;
                    end;
                }
                field("MILL Reel No."; "MILL Reel No.")
                {
                }
                field("Code"; Code)
                {
                    Caption = 'System Generated Roll No';
                    Editable = false;
                }
                field("Mill Name"; "Mill Name")
                {
                }
            }
            group(Line1)
            {

                field(TotalQuantity; TotalQuantity)
                {
                    Caption = 'TotalQuantity';
                    Editable = false;
                }
                field(TotalNoofRolls; TotalNoofRolls)
                {
                    Caption = 'TotalNoofRolls';
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Document Line No."; "Document Line No.")
                {
                    Editable = false;
                }
                field("Initial Location Code"; "Initial Location Code")
                {
                    Editable = false;
                }
                field("Location after QA"; "Location after QA")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        DocumentNo := Rec.GetFilter("Document No.");
        Evaluate(DocumentLineNo, Rec.GetFilter("Document Line No."));
        ItemNo := Rec.GetFilter("Item No.");
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateTotalQuantity();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ItemMaster: Record Item;
    begin
        "Document No." := Rec.GetFilter("Document No.");
        Evaluate("Document Line No.", Rec.GetFilter("Document Line No."));

        UpdateTotalQuantity();
        // Lines added BY Deepak Kumar
        PurchaseLine.Reset;
        PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(PurchaseLine."Document No.", DocumentNo);
        PurchaseLine.SetRange(PurchaseLine."Line No.", DocumentLineNo);
        if PurchaseLine.FindFirst then begin
            "Location after QA" := PurchaseLine."Receiving Location";
            "Initial Location Code" := PurchaseLine."Location Code";
            Origin := PurchaseLine.ORIGIN;
            Suppiler := PurchaseLine.MILL;
            "Paper Type" := PurchaseLine."Paper Type";
            "Paper GSM" := PurchaseLine."Paper GSM";
            ItemMaster.Get(PurchaseLine."No.");
            "Deckle Size (mm)" := ItemMaster."Deckle Size (mm)";
            "Item Category Code" := ItemMaster."Item Category Code";
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        UpdateTotalQuantity();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateTotalQuantity();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Subs: Codeunit CodeunitSubscriber;
        PurchHeader: Record "Purchase Header";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        ReOpenReq: Boolean;
        CDSubscriber: Codeunit CodeunitSubscriber;
    begin
        // Lines added By Deepak Kumar

        UpdateTotalQuantity();
        PurchaseLine.Reset;
        PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(PurchaseLine."Document No.", DocumentNo);
        PurchaseLine.SetRange(PurchaseLine."Line No.", DocumentLineNo);
        if PurchaseLine.FindFirst then begin
            PurchHeader.Get(PurchHeader."Document Type"::Order, PurchaseLine."Document No.");
            IF PurchHeader.Status = PurchHeader.Status::Released THEN begin
                ReOpenReq := true;
                ReleasePurchaseDocument.Reopen(PurchHeader);
            end Else
                ReOpenReq := false;
            PurchaseLine.Validate("Qty. to Receive", TotalQuantity);
            Subs.UpdateRollWiseLocation(PurchaseLine."Document No.", PurchaseLine."Line No.");
            PurchaseLine."Qty. to Receive" := 0;
            PurchaseLine.Validate("Qty. to Receive");
            PurchaseLine.Modify(true);
            IF ReOpenReq THEN
                CDSubscriber.ReleasePurchDoc(PurchHeader);
            Commit;
        end;
    end;

    var
        TotalQuantity: Decimal;
        TotalNoofRolls: Decimal;
        RollMaster: Record "Item Variant";
        PurchaseLine: Record "Purchase Line";
        PurchPost: Codeunit "Purch.-Post";
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocumentNo: Code[20];
        DocumentLineNo: Integer;
        ItemNo: Code[20];


    local procedure UpdateTotalQuantity()
    begin
        // Lines added by deepak Kumar
        TotalQuantity := 0;

        RollMaster.Reset;
        RollMaster.SetRange(RollMaster."Document No.", DocumentNo);
        RollMaster.SetRange(RollMaster."Document Line No.", DocumentLineNo);
        RollMaster.SetRange(RollMaster."Item No.", ItemNo);
        RollMaster.SetRange(RollMaster.Status, RollMaster.Status::" ");
        if RollMaster.FindFirst then begin
            TotalNoofRolls := RollMaster.Count;
            repeat
                TotalQuantity += RollMaster."Roll Weight";
            until RollMaster.Next = 0;
        end;
    end;
}

