table 50034 "Sales Req Buffer"
{
    // version Samadhan Purchase Planing


    fields
    {
        field(1;"Entry Number";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Item Code";Code[20])
        {
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                // Lines added bY deepak Kumar
                ItemMaster.Reset;
                ItemMaster.SetRange(ItemMaster."No.","Item Code");
                if ItemMaster.FindFirst then begin
                  Description:=ItemMaster.Description;
                end else begin
                  Description:='';
                end;
            end;
        }
        field(3;Description;Text[250])
        {
        }
        field(4;Quantity;Decimal)
        {
        }
        field(5;"Sales Order Number";Code[20])
        {
        }
        field(6;"Sales Order Line";Integer)
        {
        }
        field(7;"Quantity Per";Decimal)
        {
        }
        field(8;"Sales Order Outstanding Qty";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Entry Number")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ItemMaster: Record Item;
}

