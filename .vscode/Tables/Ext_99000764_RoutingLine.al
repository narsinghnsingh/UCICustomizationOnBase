tableextension 50062 Ext_RoutingLine extends "Routing Line"
{
    fields
    {
        field(50000; "Work Center Category"; Option)
        {
            OptionCaption = ',Materials,Press Operation,Origination Cost,Printing Guiding,Finishing Packing';
            OptionMembers = ,Materials,"Press Operation","Origination Cost","Printing Guiding","Finishing Packing";
        }
        field(50001; "Die Cut Ups"; Integer)
        {
        }
        field(50002; "No of Joints"; Integer)
        {
        }
        field(50003; "Routing Unit of Measure"; Code[20])
        {
            InitValue = 'PCS';
            TableRelation = "Unit of Measure".Code;
        }
        field(51001; "Estimate Type"; Option)
        {
            Description = 'Deepak';
            Editable = false;
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;
        }
        field(51002; "Estimation No."; Code[50])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(51003; "Sub Comp No."; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
    }

}