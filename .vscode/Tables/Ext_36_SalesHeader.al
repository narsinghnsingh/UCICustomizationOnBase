tableextension 50011 Ext_SalesHeader extends "Sales Header"
{
    fields
    {
        field(50000; "Vehicle No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(50001; "Driver Name"; Text[30])
        {
            Description = 'Deepak';
        }
        field(50002; "Delivery Time"; Time)
        {
            Description = 'Firoz 30/11/15';
        }
        field(50004; "Short Closed Document"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(50005; "Blanket Order No."; Code[20])
        {
            CaptionML = ENU = 'Blanket Order No.';
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE ("Document Type" = CONST ("Blanket Order"));

        }
        field(50009; "Due Date Calculated By Month"; Boolean)
        {
            Description = '//Deepak';
        }
        field(51000; "Quote Status"; Option)
        {
            Description = 'Deepak';
            Editable = false;
            OptionCaption = 'Open,Win,Loss,Cancel';
            OptionMembers = Open,Win,Loss,Cancel;
        }
        field(51001; "Loss/Cancel Reason"; Text[50])
        {
            Description = 'Deepak';
        }
        field(51002; "LC No."; Code[20])
        {
            CaptionML = ENU = 'LC No.';
            Description = 'Deepak';
            TableRelation = "LC Detail"."No."
            WHERE ("Transaction Type" = CONST (Sale),
            "Issued To/Received From" = FIELD ("Bill-to Customer No."),
            Closed = CONST (false), Released = CONST (true));

            trigger OnValidate()
            var
                Text13700: Label 'The LC which you have selected is Foreign type you cannot utilise for this order.';
            begin

                /*IF "LC No." <> '' THEN BEGIN
                  LCDetail.GET("LC No.");
                  IF LCDetail."Type of LC" = LCDetail."Type of LC"::Foreign THEN
                    IF "Currency Code" = '' THEN
                      ERROR(Text13700);
                END;
                 */

            end;
        }
        field(51003; "Amount to Customer"; Decimal)
        {
            FieldClass = FlowField;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Sales Line".Amount
            WHERE ("Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No.")));
            CaptionML = ENU = 'Amount to Customer';
            Description = 'Deepak';
            Editable = false;

        }

        field(51004; "Paper Sale Order"; Boolean)
        {
            Description = 'Deepak';
        }
        field(51006; Picture; BLOB)
        {
            CaptionML = ENU = 'Picture';
            SubType = Bitmap;
        }
        field(51007; "Bank Account Code"; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                BankAccount.RESET();
                BankAccount.SETRANGE(BankAccount."No.", "Bank Account Code");
                IF BankAccount.FINDFIRST THEN BEGIN
                    "Bank Account Name" := BankAccount.Name;
                END;
            end;
        }
        field(51008; "Bank Account Name"; Text[100])
        {
        }
        field(51009; "Overlook Prod. Order No."; Boolean)
        {
        }
        field(51010; "Posting Time"; Time)
        {
            Editable = false;
        }
    }

    var

        UserSetup: Record "User Setup";
        Sam001: Label 'There are some additional cost entries linked with this document %1, do you still want to short close ?';
        sam002: Label 'Do you want to short close the document?';
        sam003: Label 'Do you want to Re-Open short closed document?';
        Q: Text[150];
        Answer: Boolean;
        AdditionalCostPosted: Boolean;
        SSH: Record "Sales Shipment Header";
        sam004: Label 'Document delete is restricted.';
        MonthLastDate: Date;
        BankAccount: Record "Bank Account";

    trigger
    OnDelete()
    begin
        //Lines added bY Deepak Kumar
        IF ("Document Type" = "Document Type"::Quote) AND ("Quote Status" = "Quote Status"::Win) THEN BEGIN
            ERROR(sam004);
        END;
    end;

    procedure GetDocumentCheckList(CustomerNo: Code[50]; Orderno: Code[50])
    var
        CustomerComment: Record "Comment Line";
        SalesCommentLine: Record "Sales Comment Line";
    begin
        // Lines added BY Deepak KUmar
        SalesCommentLine.RESET;
        SalesCommentLine.SETRANGE(SalesCommentLine."Document Type", SalesCommentLine."Document Type"::"Delivery Order");
        SalesCommentLine.SETRANGE(SalesCommentLine."No.", Orderno);
        IF SalesCommentLine.FINDFIRST THEN
            EXIT;

        CustomerComment.RESET;
        CustomerComment.SETRANGE(CustomerComment.Type, CustomerComment.Type::Document);
        CustomerComment.SETRANGE(CustomerComment."No.", CustomerNo);
        IF CustomerComment.FINDFIRST THEN BEGIN
            REPEAT
                SalesCommentLine.INIT;
                SalesCommentLine."Document Type" := SalesCommentLine."Document Type"::"Delivery Order";
                SalesCommentLine."No." := Orderno;
                SalesCommentLine."Line No." := CustomerComment."Line No.";
                SalesCommentLine.Date := WORKDATE;
                SalesCommentLine.VALIDATE(SalesCommentLine."Document Code", CustomerComment."Document Code");
                SalesCommentLine.Mandatory := CustomerComment.Mandatory;
                SalesCommentLine.INSERT(TRUE);
                MESSAGE(CustomerComment.GETFILTERS);
            UNTIL CustomerComment.NEXT = 0;
        END;
    end;

    procedure ValidateAuth()
    var
        UserSetup: Record "User Setup";
    begin
        //Lines added By Deepak Kumar
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERID);
        IF UserSetup.FINDFIRST THEN BEGIN
            IF (UserSetup."Auth. For Sale E/Q/O" = FALSE) AND (UserSetup."Sales Supervisor" = FALSE) THEN
                ERROR('You are not authorized for Sales Data,Please contact your System Administrator');
        END;
    end;

    procedure ReOpenEnqQuote(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNo: Code[50])
    var
        DocSalesHeader: Record "Sales Header";
    begin
        // Function added by Deepak kumar
        DocSalesHeader.RESET;
        DocSalesHeader.SETRANGE(DocSalesHeader."Document Type", DocumentType);
        DocSalesHeader.SETRANGE(DocSalesHeader."No.", DocumentNo);
        IF DocSalesHeader.FINDFIRST THEN BEGIN
            DocSalesHeader.ValidateAuth;
            Q := 'Do you want to "Re-Open ' + FORMAT(DocumentType) + ' No. ' + FORMAT(DocumentNo);
            Answer := DIALOG.CONFIRM(Q, TRUE);
            IF Answer = TRUE THEN BEGIN
                DocSalesHeader."Quote Status" := DocSalesHeader."Quote Status"::Open;
                DocSalesHeader.MODIFY(TRUE);
            END;

        END;
    end;

    procedure LossEnqQuote(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNo: Code[50])
    var
        DocSalesHeader: Record "Sales Header";
    begin
        // Function added by Deepak kumar
        DocSalesHeader.RESET;
        DocSalesHeader.SETRANGE(DocSalesHeader."Document Type", DocumentType);
        DocSalesHeader.SETRANGE(DocSalesHeader."No.", DocumentNo);
        IF DocSalesHeader.FINDFIRST THEN BEGIN
            DocSalesHeader.ValidateAuth;
            Q := 'Do you want to change status ' + FORMAT(DocumentType) + ' No. ' + FORMAT(DocumentNo) + ' as Loss';
            Answer := DIALOG.CONFIRM(Q, TRUE);
            IF Answer = TRUE THEN BEGIN
                DocSalesHeader.TESTFIELD(DocSalesHeader."Loss/Cancel Reason");
                DocSalesHeader."Quote Status" := DocSalesHeader."Quote Status"::Loss;
                DocSalesHeader.MODIFY(TRUE);
            END;

        END;
    end;

    procedure CancalEnqQuote(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNo: Code[50])
    var
        DocSalesHeader: Record "Sales Header";
    begin
        // Function added by Deepak kumar
        DocSalesHeader.RESET;
        DocSalesHeader.SETRANGE(DocSalesHeader."Document Type", DocumentType);
        DocSalesHeader.SETRANGE(DocSalesHeader."No.", DocumentNo);
        IF DocSalesHeader.FINDFIRST THEN BEGIN
            DocSalesHeader.ValidateAuth;
            Q := 'Do you want to cancel ' + FORMAT(DocumentType) + ' No. ' + FORMAT(DocumentNo);
            Answer := DIALOG.CONFIRM(Q, TRUE);
            IF Answer = TRUE THEN BEGIN
                DocSalesHeader.TESTFIELD(DocSalesHeader."Loss/Cancel Reason");
                DocSalesHeader."Quote Status" := DocSalesHeader."Quote Status"::Cancel;
                DocSalesHeader.MODIFY(TRUE);
            END;
        END;
    end;

    procedure ShortCloseDocument(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNumber: Code[50])
    var
        SalesHeaderDoc: Record "Sales Header";
        SalesLineDoc: Record "Sales Line";
    begin
        // Lines addee by Deepak Kumar

        SalesHeaderDoc.RESET;
        SalesHeaderDoc.SETRANGE(SalesHeaderDoc."Document Type", DocumentType);
        SalesHeaderDoc.SETRANGE(SalesHeaderDoc."No.", DocumentNumber);
        IF SalesHeaderDoc.FINDFIRST THEN BEGIN

            SalesHeaderDoc.TESTFIELD(SalesHeaderDoc."Short Closed Document", FALSE);

            Answer := DIALOG.CONFIRM(sam002, TRUE, DocumentNumber);
            IF Answer = TRUE THEN BEGIN

                AdditionalCostPosted := TRUE;
                ValidateAdditionalCost(DocumentType, DocumentNumber);
                IF AdditionalCostPosted = FALSE THEN BEGIN
                    Answer := DIALOG.CONFIRM(Sam001, TRUE, DocumentNumber);
                    IF Answer = TRUE THEN BEGIN
                        UpdateCostLines(DocumentType, DocumentNumber);
                    END ELSE BEGIN
                        EXIT;
                    END;
                END;

                SalesLineDoc.RESET;
                SalesLineDoc.SETRANGE(SalesLineDoc."Document Type", SalesHeaderDoc."Document Type");
                SalesLineDoc.SETRANGE(SalesLineDoc."Document No.", SalesHeaderDoc."No.");
                IF SalesLineDoc.FINDFIRST THEN BEGIN
                    REPEAT
                        SalesLineDoc."Short Closed Quantity" := SalesLineDoc.Quantity - SalesLineDoc."Quantity Shipped";
                        SalesLineDoc."Short Closed Amount" := SalesLineDoc."Outstanding Amount";
                        SalesLineDoc."Short Closed Amount (LCY)" := SalesLineDoc."Outstanding Amount (LCY)";
                        SalesLineDoc."Outstanding Quantity" := 0;
                        SalesLineDoc."Outstanding Amount" := 0;
                        SalesLineDoc."Outstanding Amount (LCY)" := 0;
                        //SalesLineDoc."Quantity Shipped":=SalesLineDoc."Quantity Shipped"+SalesLineDoc."Short Closed Quantity";
                        //SalesLineDoc."Qty. Shipped (Base)":=SalesLineDoc."Qty. Shipped (Base)"+SalesLineDoc."Short Closed Quantity";
                        SalesLineDoc."Short Closed Document" := TRUE;
                        SalesLineDoc.MODIFY(TRUE);
                    UNTIL SalesLineDoc.NEXT = 0;
                END;
                SalesHeaderDoc."Short Closed Document" := TRUE;
                SalesHeaderDoc.Status := SalesHeaderDoc.Status::"Short Closed";
                SalesHeaderDoc.MODIFY(TRUE);
                MESSAGE('Document No. %1 Short Closed successfully !', DocumentNumber);
            END ELSE BEGIN
                MESSAGE('Action Canceled');
            END;

        END;
    end;

    procedure ValidateAdditionalCost(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNumber: Code[50])
    var
        SalesHeaderN: Record "Sales Header";
        SalesLineN: Record "Sales Line";
        SalesLineNew: Record "Sales Line";
        TempLineNo: Integer;
        EstimateCostLine: Record "Product Design Special Descrip";
        StandardSalesCode: Record "Standard Sales Code";
        PostedSalesInvoice: Record "Sales Invoice Line";
    begin
        // Lines added BY Deepak Kumar
        SalesHeaderN.RESET;
        SalesHeaderN.SETRANGE(SalesHeaderN."Document Type", DocumentType);
        SalesHeaderN.SETRANGE(SalesHeaderN."No.", DocumentNumber);
        IF SalesHeaderN.FINDFIRST THEN BEGIN
            SalesLineN.RESET;
            SalesLineN.SETRANGE(SalesLineN."Document Type", SalesHeaderN."Document Type");
            SalesLineN.SETRANGE(SalesLineN."Document No.", SalesHeaderN."No.");
            SalesLineN.SETRANGE(SalesLineN."Estimate Additional Cost", FALSE);
            IF SalesLineN.FINDFIRST THEN BEGIN
                REPEAT
                    EstimateCostLine.RESET;
                    EstimateCostLine.SETRANGE(EstimateCostLine."No.", SalesLineN."Estimation No.");
                    EstimateCostLine.SETRANGE(EstimateCostLine.Category, EstimateCostLine.Category::Cost);
                    IF EstimateCostLine.FINDFIRST THEN BEGIN
                        REPEAT

                            AdditionalCostPosted := FALSE;
                            IF EstimateCostLine.Occurrence = EstimateCostLine.Occurrence::Once THEN BEGIN
                                PostedSalesInvoice.RESET;
                                PostedSalesInvoice.SETRANGE(PostedSalesInvoice."Estimation No.", EstimateCostLine."No.");
                                PostedSalesInvoice.SETRANGE(PostedSalesInvoice."Estimate Additional Cost", TRUE);
                                PostedSalesInvoice.SETFILTER(PostedSalesInvoice."Cross-Reference No.", EstimateCostLine."Cost Code");
                                IF PostedSalesInvoice.FINDFIRST THEN BEGIN
                                    AdditionalCostPosted := TRUE;
                                END;
                            END;
                        UNTIL EstimateCostLine.NEXT = 0;
                    END;
                UNTIL SalesLineN.NEXT = 0;

            END;
        END;
    end;

    procedure UpdateCostLines(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNumber: Code[50])
    var
        SalesHeaderN: Record "Sales Header";
        SalesLineN: Record "Sales Line";
        SalesLineNew: Record "Sales Line";
        TempLineNo: Integer;
        EstimateCostLine: Record "Product Design Special Descrip";
        StandardSalesCode: Record "Standard Sales Code";
        PostedSalesInvoice: Record "Sales Invoice Line";
        TempLineNumebr: Integer;
    begin
        // Lines added BY Deepak Kumar
        TempLineNumebr := 100;
        SalesHeaderN.RESET;
        SalesHeaderN.SETRANGE(SalesHeaderN."Document Type", DocumentType);
        SalesHeaderN.SETRANGE(SalesHeaderN."No.", DocumentNumber);
        IF SalesHeaderN.FINDFIRST THEN BEGIN
            SalesLineN.RESET;
            SalesLineN.SETRANGE(SalesLineN."Document Type", SalesHeaderN."Document Type");
            SalesLineN.SETRANGE(SalesLineN."Document No.", SalesHeaderN."No.");
            SalesLineN.SETRANGE(SalesLineN."Estimate Additional Cost", FALSE);
            IF SalesLineN.FINDFIRST THEN BEGIN
                REPEAT
                    EstimateCostLine.RESET;
                    EstimateCostLine.SETRANGE(EstimateCostLine."No.", SalesLineN."Estimation No.");
                    EstimateCostLine.SETRANGE(EstimateCostLine.Category, EstimateCostLine.Category::Cost);
                    IF EstimateCostLine.FINDFIRST THEN BEGIN
                        REPEAT
                            TempLineNumebr := TempLineNumebr + 1;
                            SalesLineNew.INIT;
                            SalesLineNew."Document Type" := DocumentType;
                            SalesLineNew."Document No." := DocumentNumber;
                            SalesLineNew."Line No." := TempLineNumebr;
                            SalesLineNew.Description := EstimateCostLine."Cost Description" + 'Occurrence  ' + FORMAT(EstimateCostLine.Occurrence);
                            SalesLineNew.Quantity := 1;
                            SalesLineNew."Unit Price" := EstimateCostLine.Amount;
                            SalesLineNew.INSERT(TRUE);

                        UNTIL EstimateCostLine.NEXT = 0;
                    END;
                UNTIL SalesLineN.NEXT = 0;

            END;
        END;
    end;

    procedure ReOpenShortClosedDocument(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry; DocumentNumber: Code[50])
    var
        SalesHeaderDoc: Record "Sales Header";
        SalesLineDoc: Record "Sales Line";
    begin
        // Lines added by Deepak Kumar

        SalesHeaderDoc.RESET;
        SalesHeaderDoc.SETRANGE(SalesHeaderDoc."Document Type", DocumentType);
        SalesHeaderDoc.SETRANGE(SalesHeaderDoc."No.", DocumentNumber);
        IF SalesHeaderDoc.FINDFIRST THEN BEGIN
            SalesHeaderDoc.TESTFIELD(SalesHeaderDoc."Short Closed Document", TRUE);
            Answer := DIALOG.CONFIRM(sam003, TRUE, DocumentNumber);
            IF Answer = TRUE THEN BEGIN
                SalesLineDoc.RESET;
                SalesLineDoc.SETRANGE(SalesLineDoc."Document Type", SalesHeaderDoc."Document Type");
                SalesLineDoc.SETRANGE(SalesLineDoc."Document No.", SalesHeaderDoc."No.");
                IF SalesLineDoc.FINDFIRST THEN BEGIN
                    REPEAT

                        //SalesLineDoc."Quantity Shipped":=SalesLineDoc."Quantity Shipped"-SalesLineDoc."Short Closed Quantity";
                        SalesLineDoc."Outstanding Quantity" := SalesLineDoc."Short Closed Quantity";
                        SalesLineDoc."Outstanding Amount" := SalesLineDoc."Short Closed Amount";
                        SalesLineDoc."Outstanding Amount (LCY)" := SalesLineDoc."Short Closed Amount (LCY)";
                        //SalesLineDoc."Qty. Shipped (Base)":=SalesLineDoc."Qty. Shipped (Base)"-SalesLineDoc."Short Closed Quantity";
                        SalesLineDoc."Short Closed Quantity" := 0;
                        SalesLineDoc."Short Closed Amount" := 0;
                        SalesLineDoc."Short Closed Amount (LCY)" := 0;
                        SalesLineDoc."Short Closed Document" := FALSE;
                        SalesLineDoc.MODIFY(TRUE);
                    UNTIL SalesLineDoc.NEXT = 0;
                END;
                SalesHeaderDoc.Status := SalesHeaderDoc.Status::Open;
                SalesHeaderDoc."Short Closed Document" := FALSE;
                SalesHeaderDoc.MODIFY(TRUE);
                MESSAGE('Document No. %1 re-opened successfully !, it will be available in Sales Order List', DocumentNumber);
            END ELSE BEGIN
                MESSAGE('Action Canceled');
            END;

        END;
    end;
}