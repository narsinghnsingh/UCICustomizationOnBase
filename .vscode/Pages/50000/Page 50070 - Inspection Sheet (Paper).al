page 50070 "Inspection Sheet (Paper)"
{
    // version Samadhan Quality

    Caption = 'Posted Purchase Receipt';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Purch. Rcpt. Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    Editable = false;
                }
                field("Posting Date";"Posting Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Document Date";"Document Date")
                {
                    Editable = false;
                }
                part(PurchReceiptLines;"Paper Type Buffer")
                {
                    Editable = false;
                    SubPageLink = "Document Type"=CONST("Purchase Receipt"),
                                  "Document No."=FIELD("No.");
                }
                group("Paper Item")
                {
                    Caption = 'Paper Item';
                    part(PurchaseItem;"Insp. Sheet Purchase")
                    {
                        Provider = PurchReceiptLines;
                        SubPageLink = "Source Type"=FIELD("Document Type"),
                                      "Source Document No."=FIELD("Document No."),
                                      "Paper Type"=FIELD("Paper Type"),
                                      "Paper GSM"=FIELD("Paper GSM"),
                                      "Source Document Line No."=FILTER(0);
                    }
                }
                group("Other Item")
                {
                    Caption = 'Other Item';
                    part(OtherItem;"Insp. Sheet Purchase")
                    {
                        Provider = PurchReceiptLines;
                        SubPageLink = "Source Type"=FIELD("Document Type"),
                                      "Source Document No."=FIELD("Document No."),
                                      "Source Document Line No."=FIELD("Document Line No."),
                                      "Paper Type"=FILTER('');
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Receipt")
            {
                Caption = '&Receipt';
                Image = Receipt;
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type"=CONST(Receipt),
                                  "No."=FIELD("No."),
                                  "Document Line No."=CONST(0);
                }
            }
            action("Update Paper Type & GSM In Receipt Line")
            {
                Caption = 't Line';
                Visible = false;

                trigger OnAction()
                var
                    UodateCodeUnit: Codeunit CreateSpecificationSheet;
                begin
                    UodateCodeUnit.UpdatePaperTypeGSMinReceptLine;
                end;
            }
            action("Update Normal Value in Actual Value")
            {
                Caption = 'Update Normal Value in Actual Value';
                ShortCutKey = 'Ctrl+U';

                trigger OnAction()
                var
                    "Inspection Sheet": Record "Inspection Sheet";
                begin
                    // Lines added By Deepak Kumar
                    "Inspection Sheet".Reset;
                    "Inspection Sheet".SetRange("Inspection Sheet"."Source Type","Inspection Sheet"."Source Type"::"Purchase Receipt");
                    "Inspection Sheet".SetRange("Inspection Sheet"."Source Document No.","No.");
                    if "Inspection Sheet".FindFirst then begin
                      repeat
                        if "Inspection Sheet".Qualitative then begin
                          if "Inspection Sheet"."Normal Value (Text)" <>'' then begin
                            "Inspection Sheet"."Actual  Value (Text)":="Inspection Sheet"."Normal Value (Text)";
                            "Inspection Sheet".Modify(true);
                          end else begin
                            "Inspection Sheet"."Actual  Value (Text)":='NA';
                            "Inspection Sheet".Modify(true);
                          end;
                        end;
                        if "Inspection Sheet".Quantitative then begin
                          if "Inspection Sheet"."Normal Value (Num)" <> 0 then begin
                            "Inspection Sheet"."Actual Value (Num)":="Inspection Sheet"."Normal Value (Num)";
                            "Inspection Sheet".Modify(true);
                          end else begin
                            "Inspection Sheet"."Actual Value (Num)":=0.0001;
                            "Inspection Sheet".Modify(true);
                          end;
                        end;
                      until "Inspection Sheet".Next=0;
                      Message('Updated');
                    end;
                end;
            }
            group("Report")
            {
                Caption = 'Report';
                action("GRV Inspection Sheet")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        INSPSHEET.Reset;
                        INSPSHEET.SetCurrentKey(INSPSHEET."Source Document No.",INSPSHEET."Paper Type",INSPSHEET."Paper GSM");
                        INSPSHEET.SetRange(INSPSHEET."Source Document No.","No.");
                        REPORT.RunModal(REPORT::"GRV Inspection sheet",true,true,INSPSHEET);
                    end;
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        // Lines added BY Deepak Kumar
        QualityPostingLine.UpdateAcceptedQty("No.");
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        CreateSpecificationSheet: Codeunit CreateSpecificationSheet;
        QualityPostingLine: Codeunit "Purch. Inspection Post N";
        INSPSHEET: Record "Inspection Sheet";
}

