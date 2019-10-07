table 50013 "Planning Line Buffer"
{
    // version Samadhan Planing


    fields
    {
        field(1;"User ID";Code[20])
        {
        }
        field(2;"Item Category Code";Code[20])
        {
            TableRelation = "Item Category".Code;
        }
        field(3;"Prod. Group Code";Code[20])
        {
            TableRelation = "Product Group".Code WHERE ("Item Category Code"=FIELD("Item Category Code"));
        }
        field(4;"Suggest Quantity to Order";Boolean)
        {
        }
        field(5;"Calculate Sales Requirement";Boolean)
        {
        }
        field(100;"Worksheet Template Name";Code[10])
        {
            CaptionML = ENU = 'Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
        }
        field(101;"Journal Batch Name";Code[10])
        {
            CaptionML = ENU = 'Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name WHERE ("Worksheet Template Name"=FIELD("Worksheet Template Name"));
        }
    }

    keys
    {
        key(Key1;"Worksheet Template Name","Journal Batch Name","User ID")
        {
        }
    }

    fieldgroups
    {
    }

    procedure UpdateplaningData()
    begin
    end;
}

