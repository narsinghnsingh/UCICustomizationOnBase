table 50025 "Voucher No. Series"
{

    fields
    {
        field(1;"Location Code";Code[10])
        {
            CaptionML = ENU = 'Location Code';
            TableRelation = Location.Code;
        }
        field(2;"Sub Type";Option)
        {
            CaptionML = ENU = 'Sub Type';
            OptionCaption = ' ,Cash Receipt Voucher,Cash Payment Voucher,Bank Receipt Voucher,Bank Payment Voucher,Contra Voucher,Journal Voucher';
            OptionMembers = " ","Cash Receipt Voucher","Cash Payment Voucher","Bank Receipt Voucher","Bank Payment Voucher","Contra Voucher","Journal Voucher";
        }
        field(3;"Posting No. Series";Code[20])
        {
            CaptionML = ENU = 'Posting No. Series';
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(Key1;"Location Code","Sub Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        VoucherAcc.Reset;
        VoucherAcc.SetRange("Location code","Location Code");
        VoucherAcc.SetRange("Sub Type","Sub Type");
        VoucherAcc.DeleteAll;
    end;

    trigger OnInsert()
    begin
        TestField("Sub Type");
    end;

    var
        VoucherAcc: Record "Voucher Account";
}

