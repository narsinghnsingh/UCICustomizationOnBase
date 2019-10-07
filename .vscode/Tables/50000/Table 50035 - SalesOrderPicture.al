table 50035 SalesOrderPicture
{

    fields
    {
        field(1;SalesHeadeDocNo;Code[100])
        {
        }
        field(51006;Picture;BLOB)
        {
            CaptionML = ENU = 'Picture';
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1;SalesHeadeDocNo)
        {
        }
    }

    fieldgroups
    {
    }
}

