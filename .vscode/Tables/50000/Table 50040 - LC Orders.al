table 50040 "LC Orders"
{
    // version LC Detail

    CaptionML = ENU = 'LC Orders';

    fields
    {
        field(1;"LC No.";Code[20])
        {
            CaptionML = ENU = 'LC No.';
            Editable = false;
        }
        field(2;"Transaction Type";Option)
        {
            CaptionML = ENU = 'Transaction Type';
            Editable = false;
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;
        }
        field(3;"Issued To/Received From";Code[20])
        {
            CaptionML = ENU = 'Issued To/Received From';
            Editable = false;
            TableRelation = IF ("Transaction Type"=CONST(Sale)) Customer
                            ELSE IF ("Transaction Type"=CONST(Purchase)) Vendor;
        }
        field(4;"Order No.";Code[20])
        {
            CaptionML = ENU = 'Order No.';
            Editable = false;
        }
        field(5;"Shipment Date";Date)
        {
            CaptionML = ENU = 'Shipment Date';
            Editable = false;
        }
        field(6;"Order Value";Decimal)
        {
            CaptionML = ENU = 'Order Value';
            Editable = false;
        }
        field(8;Renewed;Boolean)
        {
            CaptionML = ENU = 'Renewed';
            Editable = false;
        }
        field(9;"Received Bank Receipt No.";Boolean)
        {
            CaptionML = ENU = 'Received Bank Receipt No.';
        }
    }

    keys
    {
        key(Key1;"LC No.","Order No.")
        {
        }
        key(Key2;Renewed,"LC No.","Order No.")
        {
            SumIndexFields = "Order Value";
        }
    }

    fieldgroups
    {
    }
}

