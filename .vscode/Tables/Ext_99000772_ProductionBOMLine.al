tableextension 50064 Ext_ProductionBOMLine extends "Production BOM Line"
{
    fields
    {
        field(50000; "Take Up"; Decimal)
        {
            InitValue = 1;
        }
        field(50001; "Paper Position"; Option)
        {
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(50002; "Flute Type"; Option)
        {
            OptionCaption = ' ,A,B,C,E,F';
            OptionMembers = " ",A,B,C,E,F;
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