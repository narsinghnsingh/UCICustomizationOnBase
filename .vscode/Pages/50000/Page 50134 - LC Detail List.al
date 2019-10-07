page 50134 "LC Detail List"
{
    // version LC Detail

    CaptionML = ENU = 'LC Detail List';
    CardPageID = "LC Detail";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "LC Detail";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field("LC No."; "LC No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Issued To/Received From"; "Issued To/Received From")
                {
                }
                field("Issuing Bank"; "Issuing Bank")
                {
                }
                field("Date of Issue"; "Date of Issue")
                {
                }
                field("Expiry Date"; "Expiry Date")
                {
                }
                field("Type of LC"; "Type of LC")
                {
                }
                field("Type of Credit Limit"; "Type of Credit Limit")
                {
                }
                field("LC Value"; "LC Value")
                {
                }
                field("Latest Amended Value"; "Latest Amended Value")
                {
                }
                field(Closed; Closed)
                {
                }
                field(Released; Released)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&LC Details")
            {
                CaptionML = ENU = '&LC Details';
                Image = ViewDetails;
                action(Orders)
                {
                    CaptionML = ENU = 'Orders';
                    Image = Document;
                    RunObject = Page "LC Orders";
                    RunPageLink = "Transaction Type" = FIELD ("Transaction Type"),
                                  "LC No." = FIELD ("No.");
                }
                action("Posted Orders")
                {
                    CaptionML = ENU = 'Posted Orders';
                    Image = PostedOrder;

                    trigger OnAction()
                    begin
                        if "Transaction Type" = "Transaction Type"::Sale then begin
                            SInvHeader.SetRange("LC No.", "No.");
                            SalesInvForm.SetTableView(SInvHeader);
                            SalesInvForm.Run;
                        end;
                        if "Transaction Type" = "Transaction Type"::Purchase then begin
                            PInvHeader.SetRange("LC No.", "No.");
                            PInvHeader.SetRange("Buy-from Vendor No.", "Issued To/Received From");
                            PurchaseInvForm.SetTableView(PInvHeader);
                            PurchaseInvForm.Run;
                        end;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions';
                Image = "Action";
                action("LC &Release")
                {
                    CaptionML = ENU = 'LC &Release';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        LetterofCredit.LCRelease(Rec);
                    end;
                }
                action("LC &Amendments")
                {
                    CaptionML = ENU = 'LC &Amendments';
                    Image = EditAdjustments;

                    trigger OnAction()
                    begin
                        LetterofCredit.LCAmendments(Rec);
                    end;
                }
                action("Close LC")
                {
                    CaptionML = ENU = 'Close LC';
                    Image = Close;

                    trigger OnAction()
                    begin
                        LetterofCredit.LCClose(Rec);
                    end;
                }
            }
        }
    }

    var
        PInvHeader: Record "Purch. Inv. Header";
        SInvHeader: Record "Sales Invoice Header";
        SalesInvForm: Page "Posted Sales Invoices";
        PurchaseInvForm: Page "Posted Purchase Invoices";
        LetterofCredit: Codeunit "Letter of Credit";
}

