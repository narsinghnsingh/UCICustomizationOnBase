table 50004 "Material / Process Link Code"
{
    // version Estimate Samadhan

    // // Table Designed By Deepak Kumar

    CaptionML = ENU = 'Material / Process Link Code';
    DrillDownPageID = "Material & Process Master";
    LookupPageID = "Material & Process Master";

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[50])
        {
        }
        field(3;Default;Boolean)
        {
        }
        field(4;"No Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5;"Default Item Category";Code[20])
        {
            TableRelation = "Item Category".Code;
        }
        field(6;"Base Unit of Measure";Code[20])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(10;"Quick Product Design";Boolean)
        {
        }
        field(19;"Routing Link Code";Code[10])
        {
            CaptionML = ENU = 'Routing Link Code';
            TableRelation = "Routing Link";
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

