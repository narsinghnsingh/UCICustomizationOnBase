table 50026 "Voucher Account"
{

    fields
    {
        field(1;"Location code";Code[20])
        {
            CaptionML = ENU = 'Location code';
            TableRelation = Location.Code;
        }
        field(2;"Sub Type";Option)
        {
            CaptionML = ENU = 'Sub Type';
            OptionCaption = ' ,Cash Receipt Voucher,Cash Payment Voucher,Bank Receipt Voucher,Bank Payment Voucher,Contra Voucher,Journal Voucher';
            OptionMembers = " ","Cash Receipt Voucher","Cash Payment Voucher","Bank Receipt Voucher","Bank Payment Voucher","Contra Voucher","Journal Voucher";
        }
        field(3;"Account Type";Option)
        {
            CaptionML = ENU = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            begin
                CheckAccountType;
            end;
        }
        field(4;"Account No.";Code[20])
        {
            CaptionML = ENU = 'Account No.';
            TableRelation = IF ("Account Type"=CONST("G/L Account")) "G/L Account"
                            ELSE IF ("Account Type"=CONST(Customer)) Customer
                            ELSE IF ("Account Type"=CONST(Vendor)) Vendor
                            ELSE IF ("Account Type"=CONST("Bank Account")) "Bank Account"
                            ELSE IF ("Account Type"=CONST("Fixed Asset")) "Fixed Asset"
                            ELSE IF ("Account Type"=CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                CheckAccountType;
            end;
        }
    }

    keys
    {
        key(Key1;"Location code","Sub Type","Account Type","Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CheckAccountType;
    end;

    trigger OnModify()
    begin
        CheckAccountType;
    end;

    local procedure CheckAccountType()
    begin
        if (("Sub Type" = "Sub Type"::"Cash Receipt Voucher") or
            ("Sub Type" = "Sub Type"::"Cash Payment Voucher"))
        then
          TestField("Account Type","Account Type"::"G/L Account");
        if (("Sub Type" = "Sub Type"::"Bank Receipt Voucher") or
            ("Sub Type" = "Sub Type"::"Bank Payment Voucher"))
        then
          TestField("Account Type","Account Type"::"Bank Account");
    end;
}

