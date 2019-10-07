tableextension 50013 Ext_PurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(50000; "Type Of Transaction"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,Work Order';
            OptionMembers = " ","Work Order";
        }
        field(50001; "Custom's Reference No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50003; "Amount to Vendor"; Decimal)
        {
            FieldClass = FlowField;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Purchase Line".Amount WHERE ("Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No.")));
            CaptionML = ENU = 'Amount to Vendor';
            Description = 'Deepak';
            Editable = false;

        }
        field(50004; "Short Closed Document"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50005; "LC No."; Code[20])
        {
            CaptionML = ENU = 'LC No.';
            Description = 'Deepak';
            TableRelation = "LC Detail"."No." WHERE ("Transaction Type" = CONST (Purchase), Closed = CONST (false), Released = CONST (true));

            trigger OnValidate()
            var
                Text13700: Label 'The LC which you have selected is Foreign type you cannot utilise for this order.';
            begin
                /*
                IF "LC No." <> '' THEN BEGIN
                  LCDetail.GET("LC No.");
                  IF LCDetail."Type of LC" = LCDetail."Type of LC"::Foreign THEN
                    IF "Currency Code" = '' THEN
                      ERROR(Text13700);
                END;
                 */

            end;
        }
        field(50006; "Vendor Segment"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Vendor."Vendor Segment" WHERE ("No." = FIELD ("Buy-from Vendor No.")));
            Editable = false;

        }

        field(63002; "Subcontracting Order"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist ("Purchase Line" WHERE ("Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No."), "Prod. Order No." = FILTER (<> '')));
            Description = 'Deepak';

        }
        field(63003; "Requisition No."; Code[20])
        {
            Description = 'Deepak';
            TableRelation = "Requisition Header"."Requisition No." WHERE ("Requisition Type" = FILTER ("Manual Requisition"), "Marked Purchase Requisition" = CONST (true));
            trigger OnValidate()
            var

                ReqHeader: Record 50032;
            BEGIN
                ReqHeader.RESET;
                IF ReqHeader.GET(ReqHeader."Requisition Type"::"Manual Requisition", "Requisition No.") THEN BEGIN
                    IF ReqHeader.Status <> ReqHeader.Status::Approved THEN
                        ERROR('Requisition No. %1, should be approved first', ReqHeader."Requisition No.");
                END;
            END;
        }
        field(50007; "Amount Inc. VAT"; Decimal)
        {
            CaptionML = ENU = 'Amount Including VAT';
            FieldClass = FlowField;
            CalcFormula = Sum ("Purchase Line"."Amount Including VAT" WHERE ("Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No."), "For Location Roll Entry" = CONST (Mother)));
            Editable = false;

        }
    }

    var

        Answer: Boolean;
        sam002: Label 'Do you want to short close the document?';
        sam003: Label 'Do you want to Re-Open short closed document?';


    procedure ShortCloseDocument(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNumber: Code[50])
    var
        PurchHeaderDoc: Record "Purchase Header";
        PurchLineDoc: Record "Purchase Line";
    begin
        // Lines added by Deepak Kumar

        PurchHeaderDoc.RESET;
        PurchHeaderDoc.SETRANGE(PurchHeaderDoc."Document Type", DocumentType);
        PurchHeaderDoc.SETRANGE(PurchHeaderDoc."No.", DocumentNumber);
        IF PurchHeaderDoc.FINDFIRST THEN BEGIN
            PurchHeaderDoc.TESTFIELD(PurchHeaderDoc."Short Closed Document", FALSE);
            //  Answer := DIALOG.CONFIRM(sam002, TRUE, DocumentNumber);
            //  IF Answer = TRUE THEN
            //  BEGIN
            PurchLineDoc.RESET;
            PurchLineDoc.SETRANGE(PurchLineDoc."Document Type", PurchHeaderDoc."Document Type");
            PurchLineDoc.SETRANGE(PurchLineDoc."Document No.", PurchHeaderDoc."No.");
            IF PurchLineDoc.FINDFIRST THEN BEGIN
                REPEAT
                    PurchLineDoc."Short Closed Quantity" := PurchLineDoc.Quantity - PurchLineDoc."Quantity Received";
                    PurchLineDoc."Short Closed Amount" := PurchLineDoc."Outstanding Amount";
                    PurchLineDoc."Outstanding Quantity" := 0;
                    PurchLineDoc."Outstanding Amount" := 0;
                    //PurchLineDoc."Quantity Received":=PurchLineDoc."Quantity Received" + PurchLineDoc."Short Closed Quantity";
                    //PurchLineDoc."Qty. Received (Base)":= PurchLineDoc."Qty. Received (Base)"  + PurchLineDoc."Short Closed Quantity";
                    PurchLineDoc."Short Closed Document" := TRUE;
                    PurchLineDoc.MODIFY(TRUE);
                UNTIL PurchLineDoc.NEXT = 0;
            END;
            PurchHeaderDoc."Short Closed Document" := TRUE;
            PurchHeaderDoc.Status := PurchHeaderDoc.Status::"Short Closed";
            PurchHeaderDoc.MODIFY(TRUE);
            // END ELSE BEGIN
            //  MESSAGE('Action Canceled');
            // END;
        END;
    end;

    procedure ReOpenShortClosedDocument(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNumber: Code[50])
    var
        PurchHeaderDoc: Record "Purchase Header";
        PurchLineDoc: Record "Purchase Line";
    begin
        // Lines added by Deepak Kumar
        PurchHeaderDoc.RESET;
        PurchHeaderDoc.SETRANGE(PurchHeaderDoc."Document Type", DocumentType);
        PurchHeaderDoc.SETRANGE(PurchHeaderDoc."No.", DocumentNumber);
        IF PurchHeaderDoc.FINDFIRST THEN BEGIN
            PurchHeaderDoc.TESTFIELD(PurchHeaderDoc."Short Closed Document", TRUE);
            Answer := DIALOG.CONFIRM(sam003, TRUE, DocumentNumber);
            IF Answer = TRUE THEN BEGIN
                PurchLineDoc.RESET;
                PurchLineDoc.SETRANGE(PurchLineDoc."Document Type", PurchHeaderDoc."Document Type");
                PurchLineDoc.SETRANGE(PurchLineDoc."Document No.", PurchHeaderDoc."No.");
                IF PurchLineDoc.FINDFIRST THEN BEGIN
                    REPEAT
                        //PurchLineDoc."Quantity Received":=PurchLineDoc."Quantity Received"  - PurchLineDoc."Short Closed Quantity";
                        PurchLineDoc."Outstanding Quantity" := PurchLineDoc."Short Closed Quantity";
                        PurchLineDoc."Outstanding Amount" := PurchLineDoc."Short Closed Amount";
                        //PurchLineDoc."Qty. Received (Base)":=PurchLineDoc."Qty. Received (Base)"- PurchLineDoc."Short Closed Quantity";
                        PurchLineDoc."Short Closed Quantity" := 0;
                        PurchLineDoc."Short Closed Amount" := 0;
                        PurchLineDoc."Short Closed Document" := FALSE;
                        PurchLineDoc.MODIFY(TRUE);
                    UNTIL PurchLineDoc.NEXT = 0;
                END;
                PurchHeaderDoc.Status := PurchHeaderDoc.Status::Open;
                PurchHeaderDoc."Short Closed Document" := FALSE;
                PurchHeaderDoc.MODIFY(TRUE);
                MESSAGE('Document No. %1 re-opened successfully !', DocumentNumber);
            END ELSE BEGIN
                MESSAGE('Action Canceled');
            END;
        END;
    end;

    procedure GetReqLine(PurchHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        ReqLine: Record "Requisition Line SAM";
        TempLine: Integer;
        RequisitionHeader: Record 50032;
    begin
        // Lines added BY Deepak Kumar

        PurchHeader.TESTFIELD(PurchHeader."Requisition No.");
        RequisitionHeader.RESET;
        IF RequisitionHeader.GET(RequisitionHeader."Requisition Type"::"Manual Requisition", PurchHeader."Requisition No.") THEN BEGIN
            IF RequisitionHeader.Status <> RequisitionHeader.Status::Approved THEN
                ERROR('Requisition No. %1, should be approved first', RequisitionHeader."Requisition No.");
        END;
        ReqLine.RESET;
        ReqLine.SETRANGE(ReqLine."Requisition No.", PurchHeader."Requisition No.");
        ReqLine.SETRANGE(ReqLine."Marked Purchase Requisition", TRUE);
        IF ReqLine.FINDFIRST THEN BEGIN
            TempLine := 100;
            REPEAT
                PurchaseLine.INIT;
                PurchaseLine."Document Type" := PurchHeader."Document Type";
                PurchaseLine."Document No." := PurchHeader."No.";
                PurchaseLine."Line No." := TempLine;
                PurchaseLine.INSERT(TRUE);
                PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
                PurchaseLine.VALIDATE(PurchaseLine."No.", ReqLine."Item No.");
                PurchaseLine.VALIDATE(PurchaseLine.Quantity, ReqLine."Remaining Quantity");
                PurchaseLine."Requested Receipt Date" := ReqLine."Requested Date";
                PurchaseLine.MODIFY(TRUE);
                TempLine := TempLine + 10;
            UNTIL ReqLine.NEXT = 0;
            MESSAGE('Complete');
        END ELSE BEGIN
            MESSAGE('There is no Requisition Line witin filter');
        END;
    end;
}