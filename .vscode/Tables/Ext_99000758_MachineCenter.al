tableextension 50061 Ext_MachineCenter extends "Machine Center"
{
    fields
    {
        field(50001; "Work Center Category"; Option)
        {
            Description = '// Deepak';
            OptionCaption = ',Materials,Origination Cost,Corrugation,Printing Guiding,Finishing Packing,Sub Job';
            OptionMembers = ,Materials,"Origination Cost",Corrugation,"Printing Guiding","Finishing Packing","Sub Job";
        }
        field(50002; "Price Based Condition"; Option)
        {
            Description = '// Deepak';
            OptionCaption = ' ,No of Ply,No of Colour,No of Joint,No of Die Cut Ups,Stitching';
            OptionMembers = " ","No of Ply","No of Colour","No of Joint","No of Die Cut Ups",Stitching;
        }
        field(50003; "Printing Plate Applicable"; Boolean)
        {
            Description = '// Deepak';
        }
        field(50004; "Die Applicable"; Boolean)
        {
            Description = '// Deepak';
        }
        field(50008; "Maximum Deckle Size (mm)"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50009; "Maximum Deckle Ups"; Integer)
        {
            Description = '//Deepak';
        }
        field(50010; "Corrugation Speed (Mtr)/min"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50011; "Aval.Min/Day for Price Calc"; Integer)
        {
            Description = '//deepak';
        }
        field(50012; "Machine Price Calculated"; Decimal)
        {
            CalcFormula = Sum ("Machine Cost Sheet"."Unit Amount" WHERE ("Machine No." = FIELD ("No.")));
            Description = '//deepak';
            Editable = false;
            FieldClass = FlowField;
        }
    }

}