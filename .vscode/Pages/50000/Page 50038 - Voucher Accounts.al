page 50038 "Voucher Accounts"
{
    // version NAVIN7.10| Deepak

    CaptionML = ENU = 'Voucher Account';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Voucher Account";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                ShowCaption = false;
                field("Sub Type"; "Sub Type")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if ("Sub Type" = "Sub Type"::"Cash Receipt Voucher") or ("Sub Type" = "Sub Type"::"Cash Payment Voucher") then
            "Account Type" := "Account Type"::"G/L Account";
        if ("Sub Type" = "Sub Type"::"Bank Receipt Voucher") or ("Sub Type" = "Sub Type"::"Bank Payment Voucher") then
            "Account Type" := "Account Type"::"Bank Account";
    end;
}

