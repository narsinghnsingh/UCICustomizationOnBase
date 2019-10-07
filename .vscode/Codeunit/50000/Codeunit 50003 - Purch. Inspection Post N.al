codeunit 50003 "Purch. Inspection Post N"
{
    // version Samadhan Quality

    Permissions = TableData "Purch. Rcpt. Line" = rimd;
    TableNo = "Purch. Rcpt. Line";

    trigger OnRun()
    begin

        InsertItemJournal(Rec);

        //Updation of Posted Transfer Doc No for Quality  Begin
        ItemLedger.Reset;
        ItemLedger.SetRange(ItemLedger."Entry Type", ItemLedger."Entry Type"::Transfer);
        ItemLedger.SetRange(ItemLedger."Origin Purch. Rcpt No.", "Document No.");
        ItemLedger.SetRange(ItemLedger."Origin Purch. Rcpt L No.", "Line No.");
        if ItemLedger.FindFirst then begin
            TransferDocNo := ItemLedger."Document No.";
        end;
        "Quality Doc. No." := TransferDocNo;
        Modify(true);
        //Updation of Posted Transfer Doc No for Quality  End

        ChangeStatusRollMaster(Rec);

        "QA Processed" := true;
        Modify(true);
    end;

    var
        PurchInspectionSheet: Record "Inspection Sheet";
        QualitySetup: Record "Manufacturing Setup";
        "NoSeriesMngmt.": Codeunit NoSeriesManagement;
        ItemJnlPost: Codeunit "Item Jnl.-Post Batch";
        IJL: Record "Item Journal Line";
        DocNo: Code[20];
        OldIJL: Record "Item Journal Line";
        EntryNo: Integer;
        ItemLedger: Record "Item Ledger Entry";
        TransferDocNo: Code[20];
        PurchInspPost: Codeunit "Purch. Inspection Post N";
        PurchRectLine: Record "Purch. Rcpt. Line";
        PurchRectHeader: Record "Purch. Rcpt. Header";
        ILEEntryNo: Integer;
        ItemJnlBatch: Record "Item Journal Batch";
        NoofLines: Integer;
        LineNo: Integer;
        Instance: Integer;
        RollEntry: Record "Item Variant";
        OldRollLedger: Record "Item Variant";
        RollLedger: Record "Item Variant";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        Success: Boolean;

    procedure InsertItemJournal(PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        QualitySetup.Get();

        ItemJnlBatch.Reset;
        ItemJnlBatch.SetRange(ItemJnlBatch."Journal Template Name", 'TRANSFER');
        ItemJnlBatch.SetRange(ItemJnlBatch."Batch for Purch. Insp. Posting", true);
        if not ItemJnlBatch.FindFirst then
            Error('Please define a Item Journal Batch for Inspection Sheet Posting for Purchase');

        PurchRectHeader.Reset;
        PurchRectHeader.SetRange(PurchRectHeader."No.", PurchRcptLine."Document No.");
        if PurchRectHeader.FindFirst then;

        //Delete Existing Transfer Lines
        OldIJL.Reset;
        OldIJL.SetRange(OldIJL."Journal Template Name", 'TRANSFER');
        OldIJL.SetRange(OldIJL."Journal Batch Name", ItemJnlBatch.Name);
        if OldIJL.FindFirst then
            OldIJL.DeleteAll;

        DocNo := "NoSeriesMngmt.".GetNextNo(ItemJnlBatch."No. Series", PurchRcptLine."Posting Date", false);
        LineNo := 0;
        //Insert Accepted Qty
        if (PurchRcptLine."Accepted Qty." <> 0) or (PurchRcptLine."Acpt. Under Dev." <> 0) then begin
            LineNo := LineNo + 10000;
            IJL.Init;
            IJL."Journal Template Name" := 'TRANSFER';
            IJL."Journal Batch Name" := ItemJnlBatch.Name;
            IJL."Line No." := LineNo;
            IJL."Document No." := DocNo;
            IJL.Insert(true);
            IJL.Validate(IJL."Item No.", PurchRcptLine."No.");
            IJL."External Document No." := PurchRectHeader."Vendor Shipment No.";
            IJL."Posting Date" := PurchRcptLine."Posting Date";
            IJL."Entry Type" := IJL."Entry Type"::Transfer;
            IJL.Validate(Quantity, (PurchRcptLine."Accepted Qty." + PurchRcptLine."Acpt. Under Dev."));
            IJL.Validate(IJL."Location Code", QualitySetup."Quality Inspection Location");
            IJL.Validate(IJL."New Location Code", PurchRcptLine."Receiving Location");
            IJL."Gen. Bus. Posting Group" := QualitySetup."Default Gen. Bus Posting Group";
            IJL.Validate("Variant Code", PurchRectLine."Variant Code");
            IJL."Origin Purch. Rcpt No." := PurchRcptLine."Document No.";
            IJL."Origin Purch. Rcpt L No." := PurchRcptLine."Line No.";
            IJL.Validate(IJL."Applies-to Entry", PurchRcptLine."Item Rcpt. Entry No.");
            IJL.Modify(true);
        end;
        //Insert Rejected Qty
        if (PurchRcptLine."Rejected Qty." <> 0) then begin
            LineNo := LineNo + 10000;
            IJL."Journal Template Name" := 'TRANSFER';
            IJL."Journal Batch Name" := ItemJnlBatch.Name;
            IJL."Line No." := LineNo;
            IJL."Document No." := DocNo;
            IJL.Insert(true);
            IJL.Validate(IJL."Item No.", PurchRcptLine."No.");
            IJL."External Document No." := PurchRectHeader."Vendor Shipment No.";
            IJL."Posting Date" := PurchRcptLine."Posting Date";
            IJL."Entry Type" := IJL."Entry Type"::Transfer;
            IJL.Validate(Quantity, PurchRcptLine."Rejected Qty.");
            IJL.Validate(IJL."Location Code", QualitySetup."Quality Inspection Location");
            IJL.Validate(IJL."New Location Code", QualitySetup."Rejection Location");
            IJL."Gen. Bus. Posting Group" := QualitySetup."Default Gen. Bus Posting Group";
            IJL."Variant Code" := PurchRcptLine."Variant Code";
            IJL."Origin Purch. Rcpt No." := PurchRcptLine."Document No.";
            IJL."Origin Purch. Rcpt L No." := PurchRcptLine."Line No.";
            IJL.Validate(IJL."Applies-to Entry", PurchRcptLine."Item Rcpt. Entry No.");
            IJL.Modify(true);
        end;
        ItemJnlPost.Run(IJL);

        //Roll Status Updation Begin--------------------------------------
        QualitySetup.Get();
        RollEntry.Reset;
        RollEntry.SetRange(RollEntry.Code, PurchRcptLine."Variant Code");
        RollEntry.SetRange(RollEntry.Status, 1);
        if RollEntry.FindFirst then begin
            repeat
                RollEntry."Quality Doc No." := PurchRectLine."Quality Doc. No.";
                RollEntry.Status := 2;
                RollEntry.Modify(true);
            until RollEntry.Next = 0;
        end;
    end;

    procedure ChangeStatusRollMaster(PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        //MESSAGE('ChangeStatusRollMaster');
    end;

    procedure InsertRollLedger(RollMaster: Record "Attribute Master"; PostingDate: Date)
    begin
    end;

    procedure UpdatePurchaseInpection(DocNo: Code[20]; PostingDate: Date)
    var
        "Purchase Line": Record "Purchase Line";
        InspPurch: Record "Inspection Sheet";
        PostedIns: Record "Posted Inspection Sheet";
        LineNo: Integer;
        "NoSeriesMgmt.": Codeunit NoSeriesManagement;
        InspectionNo: Code[20];
        RollMaster: Record "Attribute Master";
        QualitySetup: Record "Manufacturing Setup";
    begin
        QualitySetup.Get();

        InspPurch.Reset;
        InspPurch.SetRange(InspPurch."Source Type", InspPurch."Source Type"::"Purchase Receipt");
        InspPurch.SetRange(InspPurch."Source Document No.", DocNo);
        //InspPurch.SETRANGE(InspPurch."Source Document Line No.",DocLineNo);
        if InspPurch.FindFirst then begin
            LineNo := 0;
            repeat
                //Copying Fields from Inspection Sheet to Posted Inspection Sheet
                InspectionNo := '';
                "NoSeriesMgmt.".InitSeries(QualitySetup."Inspection No. Series", '', 0D, InspectionNo, QualitySetup."Rejection Location");
                PostedIns.Reset;
                PostedIns."Source Type" := PostedIns."Source Type"::"Purchase Receipt";
                PostedIns."Source Document No." := InspPurch."Source Document No.";
                PostedIns."Source Line No." := InspPurch."Source Document Line No.";
                PostedIns."Document Type" := PostedIns."Document Type"::Transfer;
                PostedIns."Document No." := DocNo;
                PostedIns."Document Line No." := LineNo + 10000;
                PostedIns."Sample Code" := InspPurch."Sample Code";
                PostedIns."Posting Date" := PostingDate;
                PostedIns."Document Date" := PostingDate;
                //PostedIns."Vendor No./Customer No.":=PurchRcptHead."Buy-from Vendor No.";
                PostedIns."Item No." := InspPurch."Item No.";
                PostedIns."Item Description" := InspPurch."Item Description";
                PostedIns."Spec ID" := InspPurch."Spec ID";
                PostedIns."Created By" := InspPurch."Created By";
                PostedIns."Created Date" := InspPurch."Created Date";
                PostedIns."Created Time" := InspPurch."Created Time";
                PostedIns."Posted Date" := Today;
                PostedIns."Posted Time" := Time;
                PostedIns."Posted By" := UserId;
                PostedIns."Inspection Receipt No." := InspectionNo;
                PostedIns."Unit of Measure Code" := InspPurch."Unit of Measure Code";
                PostedIns."Qty. per Unit of Measure" := InspPurch."Qty. per Unit of Measure";
                PostedIns."Base Unit of Measure" := InspPurch."Base Unit of Measure";
                //PostedIns.Quantity:="Purchase Line"."Qty. to Receive";
                //PostedIns."Quantity (Base)":="Purchase Line"."Qty. to Receive (Base)";
                PostedIns."QA Characteristic Code" := InspPurch."QA Characteristic Code";
                PostedIns."QA Characteristic Description" := InspPurch."QA Characteristic Description";
                PostedIns."Normal Value (Num)" := InspPurch."Normal Value (Num)";
                PostedIns."Min. Value (Num)" := InspPurch."Min. Value (Num)";
                PostedIns."Max. Value (Num)" := InspPurch."Max. Value (Num)";
                PostedIns."Actual Value (Num)" := InspPurch."Actual Value (Num)";
                PostedIns."Normal Value (Text)" := InspPurch."Normal Value (Text)";
                PostedIns."Min. Value (Text)" := InspPurch."Min. Value (Text)";
                PostedIns."Max. Value (Text)" := InspPurch."Max. Value (Text)";
                PostedIns."Actual  Value (Text)" := InspPurch."Actual  Value (Text)";
                PostedIns."Unit of Measure" := InspPurch."Unit of Measure";
                PostedIns."Reason Code" := InspPurch."Reason Code";
                PostedIns.Remarks := InspPurch.Remarks;
                PostedIns."Inspection Persons" := InspPurch."Inspection Persons";
                PostedIns.Qualitative := InspPurch.Qualitative;
                PostedIns."Roll No" := InspPurch."Roll Number";
                PostedIns."Paper Type" := InspPurch."Paper Type";
                PostedIns."Paper GSM" := InspPurch."Paper GSM";
                PostedIns.Insert(true);
            until InspPurch.Next = 0;
        end; //InspPurch End
        InspPurch.DeleteAll;
    end;

    procedure PostInspectionLine(PurchReceiptHeader: Code[50])
    var
        TempAcceptedQty: Decimal;
        TempAccpetedUD: Decimal;
        TempRejected: Decimal;
        Answer: Boolean;
        Ques: Text;
    begin
        // Lines added by Deepak Kumar

        PurchRectLine.Reset;
        PurchRectLine.SetRange(PurchRectLine."Document No.", PurchReceiptHeader);
        PurchRectLine.SetCurrentKey(PurchRectLine."Document No.", PurchRectLine."Line No.");
        PurchRectLine.SetRange("QA Enabled", true);
        PurchRectLine.SetRange(PurchRectLine.Correction, false);
        PurchRectLine.SetFilter(PurchRectLine.Quantity, '<>0');
        if PurchRectLine.FindFirst then begin
            TempAcceptedQty := 0;
            TempAccpetedUD := 0;
            TempRejected := 0;
            repeat
                TempAcceptedQty += PurchRectLine."Accepted Qty.";
                TempAccpetedUD += PurchRectLine."Acpt. Under Dev.";
                TempRejected += PurchRectLine."Rejected Qty.";
            until PurchRectLine.Next = 0;
        end;
        Ques := 'Do you want post with details, Total accepted quantity ' + Format(TempAcceptedQty) + '  total accepted under deviation ' + Format(TempAccpetedUD) + ' total rejection ' + Format(TempRejected);

        Answer := DIALOG.Confirm(Ques, true, PurchReceiptHeader);

        if Answer = true then begin


            PurchRectLine.Reset;
            PurchRectLine.SetRange(PurchRectLine."Document No.", PurchReceiptHeader);
            PurchRectLine.SetCurrentKey(PurchRectLine."Document No.", PurchRectLine."Line No.");
            PurchRectLine.SetRange("QA Enabled", true);
            PurchRectLine.SetRange(PurchRectLine.Correction, false);
            PurchRectLine.SetFilter(PurchRectLine.Quantity, '<>0');
            if PurchRectLine.FindFirst then begin

                QualitySetup.Get();
                ItemJnlBatch.Reset;
                ItemJnlBatch.SetRange(ItemJnlBatch."Journal Template Name", 'TRANSFER');
                ItemJnlBatch.SetRange(ItemJnlBatch."Batch for Purch. Insp. Posting", true);
                if not ItemJnlBatch.FindFirst then
                    Error('Please define a Item Journal Batch for Inspection Sheet Posting for Purchase');

                PurchRectHeader.Reset;
                PurchRectHeader.SetRange(PurchRectHeader."No.", PurchRectLine."Document No.");
                if PurchRectHeader.FindFirst then;

                //Delete Existing Transfer Lines
                OldIJL.Reset;
                OldIJL.SetRange(OldIJL."Journal Template Name", 'TRANSFER');
                OldIJL.SetRange(OldIJL."Journal Batch Name", ItemJnlBatch.Name);
                if OldIJL.FindFirst then
                    OldIJL.DeleteAll;
                ItemJnlBatch.TestField(ItemJnlBatch."No. Series");
                DocNo := "NoSeriesMngmt.".GetNextNo(ItemJnlBatch."No. Series", PurchRectLine."Posting Date", false);
                LineNo := 0;

                repeat
                    //Insert & Post Item Journal Begin----------------------------------------

                    //Insert Accepted Qty
                    if (PurchRectLine."Accepted Qty." <> 0) or (PurchRectLine."Acpt. Under Dev." <> 0) then begin
                        LineNo := LineNo + 10000;
                        IJL.Init;
                        IJL."Journal Template Name" := 'TRANSFER';
                        IJL."Journal Batch Name" := ItemJnlBatch.Name;
                        IJL."Line No." := LineNo;
                        IJL."Document No." := DocNo;
                        IJL.Insert(true);
                        IJL.Validate(IJL."Item No.", PurchRectLine."No.");
                        IJL."External Document No." := PurchRectHeader."Vendor Shipment No.";
                        IJL."Posting Date" := PurchRectLine."Posting Date";
                        IJL."Entry Type" := IJL."Entry Type"::Transfer;
                        IJL.Validate(Quantity, (PurchRectLine."Accepted Qty." + PurchRectLine."Acpt. Under Dev."));
                        IJL.Validate(IJL."Location Code", QualitySetup."Quality Inspection Location");
                        IJL.Validate(IJL."New Location Code", PurchRectLine."Receiving Location");
                        IJL."Gen. Bus. Posting Group" := QualitySetup."Default Gen. Bus Posting Group";
                        IJL."Variant Code" := PurchRectLine."Variant Code";
                        IJL."Origin Purch. Rcpt No." := PurchRectLine."Document No.";
                        IJL."Origin Purch. Rcpt L No." := PurchRectLine."Line No.";
                        IJL.Validate(IJL."Applies-to Entry", PurchRectLine."Item Rcpt. Entry No.");
                        IJL.Modify(true);
                    end;
                    //Insert Rejected Qty
                    if (PurchRectLine."Rejected Qty." <> 0) then begin
                        LineNo := LineNo + 10000;
                        IJL."Journal Template Name" := 'TRANSFER';
                        IJL."Journal Batch Name" := ItemJnlBatch.Name;
                        IJL."Line No." := LineNo;
                        IJL."Document No." := DocNo;
                        IJL.Insert(true);
                        IJL.Validate(IJL."Item No.", PurchRectLine."No.");
                        IJL."External Document No." := PurchRectHeader."Vendor Shipment No.";
                        IJL."Posting Date" := PurchRectLine."Posting Date";
                        IJL."Entry Type" := IJL."Entry Type"::Transfer;
                        IJL.Validate(Quantity, PurchRectLine."Rejected Qty.");
                        IJL.Validate(IJL."Location Code", QualitySetup."Quality Inspection Location");
                        IJL.Validate(IJL."New Location Code", QualitySetup."Rejection Location");
                        IJL."Gen. Bus. Posting Group" := QualitySetup."Default Gen. Bus Posting Group";
                        IJL."Variant Code" := PurchRectLine."Variant Code";
                        IJL."Origin Purch. Rcpt No." := PurchRectLine."Document No.";
                        IJL."Origin Purch. Rcpt L No." := PurchRectLine."Line No.";
                        IJL.Validate(IJL."Applies-to Entry", PurchRectLine."Item Rcpt. Entry No.");
                        IJL.Modify(true);
                    end;
                    PurchRectLine."Quality Doc. No." := DocNo;
                    PurchRectLine."QA Processed" := true;
                    PurchRectLine.Modify(true);

                    RollEntry.Reset;
                    RollEntry.SetRange(RollEntry.Code, PurchRectLine."Variant Code");
                    RollEntry.SetRange(RollEntry.Status, RollEntry.Status::PendingforQA);
                    if RollEntry.FindFirst then begin
                        RollEntry."Quality Doc No." := DocNo;
                        RollEntry."Quality Doc Line No." := LineNo;
                        RollEntry.Status := RollEntry.Status::Open;
                        RollEntry."Purchase Receipt No." := PurchRectLine."Document No.";
                        RollEntry."Purch. Receipt Line No." := PurchRectLine."Line No.";
                        RollEntry.Modify(true);
                    end;


                until PurchRectLine.Next = 0;
                //Insert & Post Item Journal End -----------------------------------s
                ItemJnlPost.Run(IJL);
                Message('Posted');
            end;
        end else begin
            Message('Action cancelled by user');
        end;
    end;

    procedure CheckReceiptline(PurchRcptDocumentNo: Code[50])
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Reset;
        PurchRcptLine.SetRange(PurchRcptLine."Document No.", PurchRcptDocumentNo);
        PurchRcptLine.SetFilter(PurchRcptLine."No.", '<>%1', '');
        if PurchRcptLine.FindFirst then begin
            repeat

                if PurchRcptLine.Paper = true then begin
                    PurchInspectionSheet.Reset;
                    PurchInspectionSheet.SetRange(PurchInspectionSheet."Source Type", PurchInspectionSheet."Source Type"::"Purchase Receipt");
                    PurchInspectionSheet.SetRange(PurchInspectionSheet."Source Document No.", PurchRcptLine."Document No.");
                    PurchInspectionSheet.SetRange(PurchInspectionSheet."Paper Type", PurchRcptLine."Paper Type");
                    PurchInspectionSheet.SetRange(PurchInspectionSheet."Paper GSM", PurchRcptLine."Paper GSM");
                    if not PurchInspectionSheet.FindFirst then
                        Error('Inspection Sheet for Purchase Receipt No %1, Line No %2 must be entered', PurchRcptLine."Document No.", PurchRcptLine."Line No.")

                    else begin
                        repeat
                            if PurchInspectionSheet.Qualitative then begin
                                if PurchInspectionSheet."Actual  Value (Text)" = '' then
                                    Error('Please define actual value in Inspection Sheet , Identification and Values document no. %1 Paper Type %2 Paper GSM %3', PurchRcptLine."Document No.", PurchRcptLine."Paper Type", PurchRcptLine."Paper GSM");

                            end else begin
                                if PurchInspectionSheet."Actual Value (Num)" = 0 then
                                    Error('Please define actual value in Inspection Sheet , Identification and Values document no. %1 Paper Type %2 Paper GSM %3', PurchRcptLine."Document No.", PurchRcptLine."Paper Type", PurchRcptLine."Paper GSM");
                            end;
                        until PurchInspectionSheet.Next = 0;
                    end;

                end else begin
                    PurchInspectionSheet.Reset;
                    PurchInspectionSheet.SetRange(PurchInspectionSheet."Source Type", PurchInspectionSheet."Source Type"::"Purchase Receipt");
                    PurchInspectionSheet.SetRange(PurchInspectionSheet."Source Document No.", PurchRcptLine."Document No.");
                    PurchInspectionSheet.SetRange(PurchInspectionSheet."Source Document Line No.", PurchRcptLine."Line No.");
                    if not PurchInspectionSheet.FindFirst then
                        Error('Inspection Sheet for Purchase Receipt No %1, Line No %2 must be entered', PurchRcptLine."Document No.", PurchRcptLine."Line No.")

                    else begin
                        repeat
                            if PurchInspectionSheet.Qualitative then
                                PurchInspectionSheet.TestField(PurchInspectionSheet."Actual  Value (Text)")
                            else
                                PurchInspectionSheet.TestField(PurchInspectionSheet."Actual Value (Num)");
                        until PurchInspectionSheet.Next = 0;
                    end;
                end;
            until PurchRcptLine.Next = 0;
        end;
    end;

    procedure UpdateAcceptedQty(PostedRectNo: Code[50])
    var
        TempQty: Decimal;
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PaperRollDetail: Record "Item Variant";
        AcptUnderDevQty: Decimal;
    begin
        // Lines Incorporated by Deepak Kumar

        TempQty := 0;
        PurchRcptLine.Reset;
        PurchRcptLine.SetRange(PurchRcptLine."Document No.", PostedRectNo);
        PurchRcptLine.SetFilter(PurchRcptLine.Quantity, '>%1', 0);
        if PurchRcptLine.FindFirst then begin
            repeat
                AcptUnderDevQty := 0;
                PaperRollDetail.Reset;
                PaperRollDetail.SetRange(PaperRollDetail."Acpt. Under Dev.", true);
                PaperRollDetail.SetRange(PaperRollDetail."Purchase Receipt No.", PurchRcptLine."Document No.");
                PaperRollDetail.SetRange(PaperRollDetail.Code, PurchRcptLine."Variant Code");
                PaperRollDetail.SetFilter(PaperRollDetail.Status, '1|2');
                if PaperRollDetail.FindFirst then begin
                    repeat
                        AcptUnderDevQty := AcptUnderDevQty + PaperRollDetail."Roll Weight";
                    until PaperRollDetail.Next = 0;
                end;
                PurchRcptLine."Acpt. Under Dev." := AcptUnderDevQty;
                PurchRcptLine.Modify(true);

                //Update Accepted ,
                TempQty := 0;
                PaperRollDetail.Reset;
                PaperRollDetail.SetRange(PaperRollDetail.Accepted, true);
                PaperRollDetail.SetRange(PaperRollDetail."Purchase Receipt No.", PurchRcptLine."Document No.");
                PaperRollDetail.SetRange(PaperRollDetail.Code, PurchRcptLine."Variant Code");
                PaperRollDetail.SetFilter(PaperRollDetail.Status, '1|2');
                if PaperRollDetail.FindFirst then begin
                    repeat
                        TempQty := TempQty + PaperRollDetail."Roll Weight";
                    until PaperRollDetail.Next = 0;
                end;
                PurchRcptLine.Validate(PurchRcptLine."Accepted Qty.", TempQty);
                PurchRcptLine.Modify(true);
                Commit;
            until PurchRcptLine.Next = 0;
        end;
    end;
}

