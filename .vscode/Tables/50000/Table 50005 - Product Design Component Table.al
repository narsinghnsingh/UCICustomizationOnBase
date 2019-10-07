table 50005 "Product Design Component Table"
{
    // version Estimate Samadhan

    // Table added by Deepak Kumar for recording of Compoenet Item

    DrillDownPageID = "Product Design Component";
    LookupPageID = "Product Design Component";

    fields
    {
        field(1;"Product Design Type";Option)
        {
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;
        }
        field(2;"Product Design No.";Code[50])
        {
        }
        field(4;"Sub Comp No.";Code[20])
        {
        }
        field(5;"Material / Process Link Code";Code[20])
        {
            TableRelation = "Material / Process Link Code".Code;
        }
        field(6;"Item No.";Code[20])
        {
            TableRelation = Item."No.";
        }
        field(7;"Item Description";Text[150])
        {
        }
        field(10;"Component Of";Code[20])
        {
            TableRelation = "Material / Process Link Code".Code;
        }
        field(19;"Routing Link Code";Code[10])
        {
            CaptionML = ENU = 'Routing Link Code';
            TableRelation = "Routing Link";
        }
        field(1000;"Date Created";Date)
        {
        }
        field(1001;"User ID";Code[50])
        {
        }
        field(50000;"Take Up";Decimal)
        {
            Description = 'deepak';
            InitValue = 1;
        }
        field(50001;"Paper Position";Option)
        {
            Description = 'deepak';
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(50002;"Flute Type";Option)
        {
            Description = 'deepak';
            OptionCaption = ' ,A,B,C,E,F';
            OptionMembers = " ",A,B,C,E,F;
        }
        field(50003;"Die Cut Ups";Integer)
        {
            Description = 'deepak';
            InitValue = 1;
            MaxValue = 100;
            MinValue = 1;
        }
        field(50004;"No of Joints";Integer)
        {
            Description = 'deepak';
            InitValue = 1;
            MaxValue = 100;
            MinValue = 1;
        }
        field(50005;Quantity;Decimal)
        {
            Description = 'deepak';
        }
        field(50006;"Estimate Quantity";Decimal)
        {
            CalcFormula = Lookup("Product Design Header".Quantity WHERE ("Product Design Type"=FIELD("Product Design Type"),
                                                                         "Product Design No."=FIELD("Product Design No."),
                                                                         "Sub Comp No."=FIELD("Sub Comp No.")));
            Description = 'deepak';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Product Design Type","Product Design No.","Sub Comp No.","Material / Process Link Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        // Lines added BY  Deepak Kumar
        "Date Created":=WorkDate;
        "User ID":=UserId;
    end;
}

