page 50131 "LC Amended Details"
{
    // version LC Detail

    CaptionML = ENU = 'LC Amended Details';
    PageType = Card;
    SourceTable = "LC Amended Details";

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
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                }
                field("LC No.";"LC No.")
                {
                    Enabled = "LC No.Enable";
                }
                field("Bank LC No.";"Bank LC No.")
                {
                    Enabled = "Bank LC No.Enable";
                }
                field("Issuing Bank";"Issuing Bank")
                {
                    Enabled = "Issuing BankEnable";
                }
                field("Receiving Bank";"Receiving Bank")
                {
                    Enabled = "Receiving BankEnable";
                }
                field(Released;Released)
                {
                }
                field(Closed;Closed)
                {
                }
                field("Expiry Date";"Expiry Date")
                {
                    Editable = "Expiry DateEditable";
                    Enabled = "Expiry DateEnable";
                }
                field("LC Amended Date";"LC Amended Date")
                {
                    Enabled = "LC Amended DateEnable";
                }
                field("Bank Amended No.";"Bank Amended No.")
                {
                    Enabled = "Bank Amended No.Enable";
                }
                field("Currency Code";"Currency Code")
                {
                    Enabled = "Currency CodeEnable";
                }
                field("LC Value";"LC Value")
                {
                    Enabled = "LC ValueEnable";

                    trigger OnValidate()
                    begin
                        LCValueOnAfterValidate;
                    end;
                }
                field("Exchange Rate";"Exchange Rate")
                {
                    Enabled = "Exchange RateEnable";
                }
                field("LC Value LCY";"LC Value LCY")
                {
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("LC &Amendments")
            {
                CaptionML = ENU = 'LC &Amendments';
                Image = EditAdjustments;
                action("LC &Card")
                {
                    CaptionML = ENU = 'LC &Card';
                    Image = EditLines;
                    RunObject = Page "LC Detail List";
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
                        LetterofCredit.LCAmendmentRelease(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls;
        CalcFields("Value Utilised");
        "Remaining Amount" := "LC Value LCY" - "Value Utilised";
    end;

    trigger OnInit()
    begin
        "Exchange RateEnable" := true;
        "LC ValueEnable" := true;
        "Bank Amended No.Enable" := true;
        "Expiry DateEnable" := true;
        "LC Amended DateEnable" := true;
        "Currency CodeEnable" := true;
        "Receiving BankEnable" := true;
        "Issuing BankEnable" := true;
        "Bank LC No.Enable" := true;
        "LC No.Enable" := true;
        "Expiry DateEditable" := true;
    end;

    var
        LetterofCredit: Codeunit "Letter of Credit";
        [InDataSet]
        "Expiry DateEditable": Boolean;
        [InDataSet]
        "LC No.Enable": Boolean;
        [InDataSet]
        "Bank LC No.Enable": Boolean;
        [InDataSet]
        "Issuing BankEnable": Boolean;
        [InDataSet]
        "Receiving BankEnable": Boolean;
        [InDataSet]
        "Currency CodeEnable": Boolean;
        [InDataSet]
        "LC Amended DateEnable": Boolean;
        [InDataSet]
        "Expiry DateEnable": Boolean;
        [InDataSet]
        "Bank Amended No.Enable": Boolean;
        [InDataSet]
        "LC ValueEnable": Boolean;
        [InDataSet]
        "Exchange RateEnable": Boolean;

    procedure EnableControls()
    begin
        "LC No.Enable" := false;
        "Bank LC No.Enable" := false;
        "Issuing BankEnable" := false;
        "Receiving BankEnable" := false;
        "Currency CodeEnable" := false;
        "LC Amended DateEnable" := not Released;
        "Expiry DateEnable" := not Released;
        "Bank Amended No.Enable" := not Released;
        if ("Currency Code" <> '') and (not Released) then
          "Exchange RateEnable" := true
        else
          "Exchange RateEnable" := false;
        "LC ValueEnable" := not Released;

        // IF Released THEN BEGIN
        // CurrForm.Description.ENABLED := FALSE;
        // CurrForm."Expiry Date".ENABLED := FALSE;
        // CurrForm."LC Amended Date".ENABLED := FALSE;
        // CurrForm."Bank Amended No.".ENABLED := FALSE;
        // CurrForm."LC Value".ENABLED := FALSE;
        // CurrForm."Exchange Rate".ENABLED := FALSE;
        // END ELSE BEGIN
        // CurrForm.Description.ENABLED := TRUE;
        // CurrForm."Expiry Date".ENABLED := TRUE;
        // CurrForm."LC Amended Date".ENABLED := TRUE;
        // CurrForm."Bank Amended No.".ENABLED := TRUE;
        // CurrForm."LC Value".ENABLED := TRUE;
        // CurrForm."Exchange Rate".ENABLED := TRUE;
        // END;
    end;

    local procedure LCValueOnAfterValidate()
    begin
        EnableControls;
    end;
}

