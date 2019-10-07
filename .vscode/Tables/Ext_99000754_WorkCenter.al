tableextension 50060 Ext_WorkCenter extends "Work Center"
{
    fields
    {
        field(50001; "Work Center Category"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ',Materials,Origination Cost,Corrugation,Printing Guiding,Finishing Packing,Sub Job';
            OptionMembers = ,Materials,"Origination Cost",Corrugation,"Printing Guiding","Finishing Packing","Sub Job";
        }
        field(50002; "Price Based Condition"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,No of Ply,No of Colour,No of Joint,No of Die Cut Ups,Stitching';
            OptionMembers = " ","No of Ply","No of Colour","No of Joint","No of Die Cut Ups",Stitching;
        }
        field(50003; "Printing Plate Applicable"; Boolean)
        {
            Description = 'Deepak';
        }
        field(50004; "Die Applicable"; Boolean)
        {
            Description = 'Deepak';
        }
    }

}