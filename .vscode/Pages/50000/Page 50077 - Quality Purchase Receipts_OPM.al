page 50077 "Quality Purchase Receipts_OPM"
{
    // version Samadhan Quality

    Caption = 'Quality Purchase Receipts_OPM';
    CardPageID = "Quality Purchase Receipt Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTable = "Purch. Rcpt. Header";
    SourceTableView = SORTING ("No.")
                      ORDER(Ascending)
                      WHERE ("Quality Applicable" = FILTER (true),
                            "Quality Posted" = FILTER (false),
                            "Vendor Posting Group" = CONST ('OPM'));

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
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                }
                field("Buy-from Post Code"; "Buy-from Post Code")
                {
                    Visible = false;
                }
                field("Buy-from Country/Region Code"; "Buy-from Country/Region Code")
                {
                    Visible = false;
                }
                field("Buy-from Contact"; "Buy-from Contact")
                {
                    Visible = false;
                }
                field("Vendor Posting Group"; "Vendor Posting Group")
                {
                }
                field("Vendor Order No."; "Vendor Order No.")
                {
                }
                field("Vendor Shipment No."; "Vendor Shipment No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                    Visible = false;
                }
                field("Order No."; "Order No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                    Visible = true;
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
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
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Receipt Statistics";
                    RunPageLink = "No." = FIELD ("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = CONST (Receipt),
                                  "No." = FIELD ("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report GRN;

                trigger OnAction()
                var
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                begin
                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    PurchRcptHeader.PrintRecords(true);
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
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
                    PurchRcptHeader.SetRange(PurchRcptHeader."No.", "No.");
                    if PurchRcptHeader.FindFirst then
                        REPORT.RunModal(REPORT::GRN, true, true, PurchRcptHeader);
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
}

