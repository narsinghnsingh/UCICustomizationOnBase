page 50037 "Voucher No. Series"
{
    // version NAVIN7.10| Deepak

    CaptionML = ENU = 'Voucher No. Series';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Voucher No. Series";

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
                field("Posting No. Series"; "Posting No. Series")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Voucher")
            {
                CaptionML = ENU = '&Voucher';
                Image = Voucher;
                action(Account)
                {
                    CaptionML = ENU = 'Account';
                    Image = ChartOfAccounts;

                    trigger OnAction()
                    begin
                        if ("Sub Type" = "Sub Type"::"Contra Voucher") or
                           ("Sub Type" = "Sub Type"::"Journal Voucher") or
                           ("Sub Type" = "Sub Type"::" ")
                        then
                            Error(Text16500, "Sub Type");

                        VoucherAcc.Reset;
                        VoucherAcc.SetRange("Location code", "Location Code");
                        VoucherAcc.SetRange("Sub Type", "Sub Type");
                        //PAGE.RunModal(PAGE::Page16575,VoucherAcc);
                    end;
                }
            }
        }
    }

    var
        VoucherAcc: Record "Voucher Account";
        Text16500: Label 'Accounts cannot be defined for the voucher type %1.';
}

