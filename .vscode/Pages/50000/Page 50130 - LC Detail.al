page 50130 "LC Detail"
{
    // version LC Detail

    CaptionML = ENU = 'LC Detail';
    PageType = Card;
    SourceTable = "LC Detail";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General';
                field("No.";"No.")
                {

                    trigger OnAssistEdit()
                    begin
                        //IF AssistEdit(xRec) THEN
                          CurrPage.Update;
                    end;
                }
                field("LC No.";"LC No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Transaction Type";"Transaction Type")
                {
                    Enabled = "Transaction TypeEnable";
                }
                field("Issued To/Received From";"Issued To/Received From")
                {
                    Enabled = "Issued To/Received FromEnable";
                }
                field("Issuing Bank";"Issuing Bank")
                {
                    Enabled = "Issuing BankEnable";

                    trigger OnValidate()
                    begin
                        IssuingBankOnAfterValidate;
                    end;
                }
                field("Receiving Bank";"Receiving Bank")
                {
                    Enabled = "Receiving BankEnable";

                    trigger OnValidate()
                    begin
                        ReceivingBankOnAfterValidate;
                    end;
                }
                field(Released;Released)
                {
                }
                field(Closed;Closed)
                {
                }
                field("Date of Issue";"Date of Issue")
                {
                    Enabled = "Date of IssueEnable";
                }
                field("Expiry Date";"Expiry Date")
                {
                    Enabled = "Expiry DateEnable";
                }
                field("Type of LC";"Type of LC")
                {
                    Enabled = "Type of LCEnable";

                    trigger OnValidate()
                    begin
                        TypeofLCOnAfterValidate;
                    end;
                }
                field("Type of Credit Limit";"Type of Credit Limit")
                {
                    Enabled = "Type of Credit LimitEnable";

                    trigger OnValidate()
                    begin
                        TypeofCreditLimitOnAfterValida;
                    end;
                }
                field("Revolving Cr. Limit Types";"Revolving Cr. Limit Types")
                {
                    Enabled = RevolvingCrLimitTypesEnable;

                    trigger OnValidate()
                    begin
                        RevolvingCrLimitTypesOnAfterVa;
                    end;
                }
                field("Currency Code";"Currency Code")
                {
                    Enabled = "Currency CodeEnable";

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field("Exchange Rate";"Exchange Rate")
                {
                    Enabled = "Exchange RateEnable";
                }
                field("LC Charges";"LC Charges")
                {
                }
                field("LC Value";"LC Value")
                {
                    Enabled = "LC ValueEnable";
                }
            }
            group(Invoicing)
            {
                CaptionML = ENU = 'Invoicing';
                field("Value Utilised";"Value Utilised")
                {
                    DrillDown = false;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                }
                field("Latest Amended Value";"Latest Amended Value")
                {
                    CaptionML = ENU = 'LC Value LCY';
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
                action(Amendments)
                {
                    CaptionML = ENU = 'Amendments';
                    Image = EditAdjustments;
                    RunObject = Page "LC Amended List";
                }
                action(Orders)
                {
                    CaptionML = ENU = 'Orders';
                    Image = Document;
                    RunObject = Page "LC Orders";
                    RunPageLink = "Transaction Type"=FIELD("Transaction Type"),
                                  "LC No."=FIELD("No.");
                }
                action("Posted Orders")
                {
                    CaptionML = ENU = 'Posted Orders';
                    Image = PostedOrder;

                    trigger OnAction()
                    begin
                        if "Transaction Type" = "Transaction Type"::Sale then begin
                          SInvHeader.SetRange("LC No.","No.");
                          SalesInvForm.SetTableView(SInvHeader);
                          SalesInvForm.Run;
                        end;
                        if "Transaction Type" = "Transaction Type"::Purchase then begin
                          PInvHeader.SetRange("LC No.","No.");
                          PInvHeader.SetRange("Buy-from Vendor No.","Issued To/Received From");
                          PurchaseInvForm.SetTableView(PInvHeader);
                          PurchaseInvForm.Run;
                        end;
                    end;
                }
                action("Posted Receipt")
                {
                    CaptionML = ENU = 'Posted Receipt';
                    Image = PostedOrder;

                    trigger OnAction()
                    begin
                        if "Transaction Type" = "Transaction Type"::Purchase then begin
                          PRectHeader.SetRange("LC No.","No.");
                          PRectHeader.SetRange("Buy-from Vendor No.","Issued To/Received From");
                          PostedPurchaseReceipts.SetTableView(PRectHeader);
                          PostedPurchaseReceipts.Run;
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
                        if "LC G/L Entry Exist" then
                          TestField("LC Charge Posted",true);

                        LetterofCredit.LCClose(Rec);
                    end;
                }
                action("LC Charges Load on Inventory")
                {
                    Image = Confirm;
                    Promoted = true;
                    RunObject = Page "LC Value Update";
                    RunPageView = SORTING("Journal Template Name","Journal Batch Name","Line No.")
                                  ORDER(Ascending);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls;
        CalcFields("Value Utilised","Renewed Amount");
        if "Latest Amended Value" <> 0 then
          "Remaining Amount" := "Latest Amended Value" - "Value Utilised" + "Renewed Amount"
        else
          "Remaining Amount" := "LC Value LCY" - "Value Utilised" + "Renewed Amount";
    end;

    trigger OnInit()
    begin
        "Exchange RateEnable" := true;
        "Currency CodeEnable" := true;
        RevolvingCrLimitTypesEnable := true;
        "LC ValueEnable" := true;
        "Type of Credit LimitEnable" := true;
        "Type of LCEnable" := true;
        "Expiry DateEnable" := true;
        "Date of IssueEnable" := true;
        "Receiving BankEnable" := true;
        "Issuing BankEnable" := true;
        "Issued To/Received FromEnable" := true;
        "Transaction TypeEnable" := true;
    end;

    var
        PInvHeader: Record "Purch. Inv. Header";
        PRectHeader: Record "Purch. Rcpt. Header";
        SInvHeader: Record "Sales Invoice Header";
        SalesInvForm: Page "Posted Sales Invoices";
        PurchaseInvForm: Page "Posted Purchase Invoices";
        LetterofCredit: Codeunit "Letter of Credit";
        [InDataSet]
        "Transaction TypeEnable": Boolean;
        [InDataSet]
        "Issued To/Received FromEnable": Boolean;
        [InDataSet]
        "Issuing BankEnable": Boolean;
        [InDataSet]
        "Receiving BankEnable": Boolean;
        [InDataSet]
        "Date of IssueEnable": Boolean;
        [InDataSet]
        "Expiry DateEnable": Boolean;
        [InDataSet]
        "Type of LCEnable": Boolean;
        [InDataSet]
        "Type of Credit LimitEnable": Boolean;
        [InDataSet]
        "LC ValueEnable": Boolean;
        [InDataSet]
        RevolvingCrLimitTypesEnable: Boolean;
        [InDataSet]
        "Currency CodeEnable": Boolean;
        [InDataSet]
        "Exchange RateEnable": Boolean;
        PostedPurchaseReceipts: Page "Posted Purchase Receipts";

    procedure EnableControls()
    begin
        "Transaction TypeEnable" := not Released;
        "Issued To/Received FromEnable" := not Released;
        "Issuing BankEnable" := not Released;
        "Receiving BankEnable" := not Released;
        "Date of IssueEnable" := not Released;
        "Expiry DateEnable" := not Released;
        "Type of LCEnable" := not Released;
        "Type of Credit LimitEnable" := not Released;
        if not Released and ("Type of Credit Limit" = "Type of Credit Limit"::Revolving) then
          RevolvingCrLimitTypesEnable := true
        else
          RevolvingCrLimitTypesEnable := false;

        if ("Type of LC" = "Type of LC"::Foreign) and (not Released) then begin
          "Currency CodeEnable" := true;
          "Exchange RateEnable" := true;
        end else begin
          "Currency CodeEnable" := false;
          "Exchange RateEnable" := false;
        end;

        if ("Currency Code" <> '') and not Released then
          "Exchange RateEnable" := true
        else
          "Exchange RateEnable" := false;

        "LC ValueEnable" := not Released;
    end;

    local procedure IssuingBankOnAfterValidate()
    begin
        EnableControls;
    end;

    local procedure TypeofLCOnAfterValidate()
    begin
        EnableControls;
    end;

    local procedure TypeofCreditLimitOnAfterValida()
    begin
        EnableControls;
    end;

    local procedure RevolvingCrLimitTypesOnAfterVa()
    begin
        EnableControls;
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        EnableControls;
    end;

    local procedure ReceivingBankOnAfterValidate()
    begin
        EnableControls;
    end;
}

