tableextension 50063 Ext_ManufacturingSetup extends "Manufacturing Setup"
{
    fields
    {
        field(50000; "Specification Nos."; Code[10])
        {
            Description = '//Deepak';
            TableRelation = "No. Series".Code;
        }
        field(50002; "Component Category"; Code[20])
        {
            TableRelation = "Item Category".Code;
        }
        field(50004; "Component Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50005; "Def. Location for Production"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = Location.Code;
        }
        field(50006; "Printing Plate Active"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50007; "Output Tolerance %"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50008; "Maximum Deckle Size (mm)"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50009; "Prod. Order Schedule"; Code[10])
        {
            Description = '//Deepak';
            TableRelation = "No. Series";
        }
        field(50010; "Plate No. Series"; Code[10])
        {
            Description = '//Deepak';
            TableRelation = "No. Series";
        }
        field(50011; "Die No. Series"; Code[10])
        {
            Description = '//Deepak';
            TableRelation = "No. Series";
        }
        field(50015; "Board Base UOM"; Code[20])
        {
            Description = 'To be used as Base UOM for all Board Items';
            TableRelation = "Unit of Measure".Code;
        }
        field(50016; "Quality Inspection Location"; Code[10])
        {
            Description = '//Deepak';
            TableRelation = Location;
        }
        field(50017; "Rejection Location"; Code[10])
        {
            Description = '//Deepak';
            TableRelation = Location;
        }
        field(50018; "Inspection No. Series"; Code[10])
        {
            Description = '//Deepak';
            TableRelation = "No. Series".Code;
        }
        field(50019; "Default Gen. Bus Posting Group"; Code[50])
        {
            Description = '// For Roll Transfer Entry';
            TableRelation = "Gen. Business Posting Group".Code;
        }
        field(50020; "Duplex Paper Category"; Code[30])
        {
            Description = '//Deepak';
            TableRelation = "Item Category".Code;
        }
        field(50021; "OSP Routing Link Code"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Routing Link".Code;
        }
        field(50022; "Default Location For OSP"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = Location;
        }
        field(50023; "Planning Quantity Tolerance"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50024; "Printed DS Item Category"; Code[30])
        {
            Description = '//Deepak';
            TableRelation = "Item Category".Code;
        }
        field(50025; "OPM Consumption Batch"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Item Journal Batch".Name WHERE ("Journal Template Name" = CONST ('ITEM'));
        }
        field(50026; "Board Required for Sub Job"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50027; "Extra Trim - Min"; Decimal)
        {
            Description = '//Deepak';

            trigger OnValidate()
            begin
                if ("Extra Trim - Max" <> 0) and ("Extra Trim - Min" > "Extra Trim - Max") then
                    Error('"Extra Trim - Min" must not be greater than "Extra Trim - Max"');
            end;
        }
        field(50028; "Extra Trim - Max"; Decimal)
        {
            Description = '//Deepak';

            trigger OnValidate()
            begin
                if ("Extra Trim - Min" <> 0) and ("Extra Trim - Max" < "Extra Trim - Min") then
                    Error('"Extra Trim - Max" must not be less than "Extra Trim - Min"');
            end;
        }
        field(50029; "Scrap % for Estimation"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50030; "Left Trim 3 Ply (cm)"; Integer)
        {
            Description = '//Deepak';
        }
        field(50031; "Right Trim 3 Ply (cm)"; Integer)
        {
            Description = '//Deepak';
        }
        field(50032; "Left Trim 5 Ply (cm)"; Integer)
        {
            Description = '//Deepak';
        }
        field(50033; "Right Trim 5 Ply (cm)"; Integer)
        {
            Description = '//Deepak';
        }
        field(50034; "Corrugation Location"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = Location.Code;
        }
        field(50035; "Def. Store Location"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = Location.Code;
        }
        field(50036; "Paper Consumption Batch"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Item Journal Batch".Name WHERE ("Journal Template Name" = CONST ('ITEM'));
        }
        field(50037; "Component Routing Link"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Routing Link";
        }
        field(50038; "Die Mandatory"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50039; "Allowed Extra Consumption %"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50040; "PD Approval Mandatory"; Boolean)
        {
            Description = '//Deepak';
        }
        field(51000; "Flute - A"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51001; "Flute - B"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51002; "Flute - C"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51003; "Flute - D"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51004; "Flute - E"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51005; "Flute - F"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51006; "Flute - A Height"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51007; "Flute - B Height"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51008; "Flute - C Height"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51009; "Flute - D Height"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51010; "Flute - E Height"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51011; "Flute - F Height"; Decimal)
        {
            Description = '//Deepak';
        }
    }

}