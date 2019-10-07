tableextension 50032 Ext_PaperTypePrice extends "Job Register"
{
    // version Estimate

    CaptionML = ENU = 'Paper Type Price';

    fields
    {
        field(50000; "Start Date"; Date)
        {
        }
        field(50001; "Paper Type"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code" = CONST ('PAPERTYPE'));
        }
        field(50002; "Add On % for Est. Cost"; Decimal)
        {
            Description = '//Deepak';
        }


    }
    // keys
    // {
    //     key(PK; "Paper Type", "Start Date", "No.")
    //     {
    //     }
    // }
}