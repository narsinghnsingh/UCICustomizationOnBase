table 50002 "Product Design Model Master"
{
    // version Estimate Samadhan


    fields
    {
        field(1; "Model No"; Code[10])
        {
        }
        field(2; Description; Text[150])
        {
        }
        field(3; "Detail Description"; Text[250])
        {
        }
        field(10; "Picture Diagram"; Blob)
        {
            CaptionML = ENU = 'Picture Diagram';
            Subtype = Bitmap;
        }
        field(11; Picture; Blob)
        {
            CaptionML = ENU = 'Picture';
            Subtype = Bitmap;
        }
        field(12; "Die Cut"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Model No")
        {
        }
    }

    fieldgroups
    {
    }
}

