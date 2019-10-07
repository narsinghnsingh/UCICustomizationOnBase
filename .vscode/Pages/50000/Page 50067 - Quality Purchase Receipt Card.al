page 50067 "Quality Purchase Receipt Card"
{
    // version Samadhan Quality

    Caption = 'Quality Purchase Receipt Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Activity,Posting';
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
                field("Buy-from Address";"Buy-from Address")
                {
                    Editable = false;
                }
                field("Buy-from Address 2";"Buy-from Address 2")
                {
                    Editable = false;
                }
                field("Buy-from City";"Buy-from City")
                {
                    Editable = false;
                }
                field("Buy-from Post Code";"Buy-from Post Code")
                {
                    Editable = false;
                }
                field("Buy-from Contact";"Buy-from Contact")
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
                field("Requested Receipt Date";"Requested Receipt Date")
                {
                }
                field("Promised Receipt Date";"Promised Receipt Date")
                {
                }
                field("Quote No.";"Quote No.")
                {
                }
                field("Order No.";"Order No.")
                {
                    Editable = false;
                }
                field("Vendor Order No.";"Vendor Order No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Vendor Shipment No.";"Vendor Shipment No.")
                {
                    Editable = false;
                }
                field("Order Address Code";"Order Address Code")
                {
                    Editable = false;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    Editable = false;
                }
            }
            part(PurchReceiptLines;"Quality Purchase Rcpt. Subform")
            {
                SubPageLink = "Document No."=FIELD("No.");
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
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type"=CONST(Receipt),
                                  "No."=FIELD("No."),
                                  "Document Line No."=CONST(0);
                }
            }
            action("Inspection Sheet")
            {
                Image = Answers;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchReceiptLine: Record "Purch. Rcpt. Header";
                begin
                    ///  Lines added by Deepak Kumar
                    CreateSpecificationSheet.CreatePaperInspectionSheet("No.");
                    Commit;
                    PurchRcptHeader.Reset;
                    PurchRcptHeader.SetRange(PurchRcptHeader."No.","No.");

                    InspectionSheet.SetTableView(PurchRcptHeader);
                    InspectionSheet.Run;
                end;
            }
        }
        area(processing)
        {
            action("Print GRV")
            {
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageOnRec = true;

                trigger OnAction()
                begin
                     PurchRcptHeader.Reset;
                     PurchRcptHeader.SetCurrentKey("No.");
                     PurchRcptHeader.SetRange(PurchRcptHeader."No.","No.");
                     if PurchRcptHeader.FindFirst then
                     REPORT.RunModal(REPORT::GRN,true,true,PurchRcptHeader);
                end;
            }
            action("Update Paper Type & GSM In Receipt Line")
            {
                Caption = 'Update Paper Type & GSM In Receipt Line';
                Visible = false;

                trigger OnAction()
                var
                    UodateCodeUnit: Codeunit CreateSpecificationSheet;
                begin
                    UodateCodeUnit.UpdatePaperTypeGSMinReceptLine;
                end;
            }
            action("Quality Posting")
            {
                Image = Completed;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    // lines added bY Deepak Kumar
                    //ERROR('Please wait for few minutes');
                    PurchInspPost.PostInspectionLine("No.");
                end;
            }
            action("Post Inspection")
            {
                Caption = 'Post Inspection';
                Visible = false;

                trigger OnAction()
                begin
                    //Lines added by DeepaK kuamr
                    PurchInspPost.UpdatePurchaseInpection("No.","Posting Date");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        CreateSpecificationSheet: Codeunit CreateSpecificationSheet;
        InspectionSheet: Page "Inspection Sheet (Paper)";
        PurchInspPost: Codeunit "Purch. Inspection Post N";
        PurchRectLine: Record "Purch. Rcpt. Line";
}

