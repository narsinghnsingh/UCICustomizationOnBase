pageextension 50075 Ext_99000768_ManfacSetup extends "Manufacturing Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(Planning)
        {
            group("Corrugation  Specific")
            {
                Caption = 'Corrugation  Specific';
                field("Component Category"; "Component Category")
                {
                }
                field("Component Series"; "Component Series")
                {
                }
                field("Component Routing Link"; "Component Routing Link")
                {
                }
                field("Maximum Deckle Size (mm)"; "Maximum Deckle Size (mm)")
                {
                }
                field("Def. Location for Production"; "Def. Location for Production")
                {
                }
                field("Corrugation Location"; "Corrugation Location")
                {
                }
                field("Def. Store Location"; "Def. Store Location")
                {
                }
                field("Duplex Paper Category"; "Duplex Paper Category")
                {
                }
                field("Printing Plate Active"; "Printing Plate Active")
                {
                }
                field("Die Mandatory"; "Die Mandatory")
                {
                }
                field("Prod. Order Schedule"; "Prod. Order Schedule")
                {
                }
                field("Board Required for Sub Job"; "Board Required for Sub Job")
                {
                }
                field("Output Tolerance %"; "Output Tolerance %")
                {
                }
                field("Planning Quantity Tolerance"; "Planning Quantity Tolerance")
                {
                }
                field("PD Approval Mandatory"; "PD Approval Mandatory")
                {
                }
                group("Corrugation Trim")
                {
                    Caption = 'Corrugation Trim';
                    field("Left Trim 3 Ply (cm)"; "Left Trim 3 Ply (cm)")
                    {
                    }
                    field("Right Trim 3 Ply (cm)"; "Right Trim 3 Ply (cm)")
                    {
                    }
                    field("Left Trim 5 Ply (cm)"; "Left Trim 5 Ply (cm)")
                    {
                    }
                    field("Right Trim 5 Ply (cm)"; "Right Trim 5 Ply (cm)")
                    {
                    }
                }
                field("Extra Trim - Min"; "Extra Trim - Min")
                {
                }
                field("Extra Trim - Max"; "Extra Trim - Max")
                {
                }
                field("Scrap % for Estimation"; "Scrap % for Estimation")
                {
                }
                field("Allowed Extra Consumption %"; "Allowed Extra Consumption %")
                {
                }
            }
            grid("Flute Details")
            {
                Caption = 'Flute Details';
                group("Take-Up Factor")
                {
                    Caption = 'Take-Up Factor';
                    field("Flute - A"; "Flute - A")
                    {
                    }
                    field("Flute - B"; "Flute - B")
                    {
                    }
                    field("Flute - C"; "Flute - C")
                    {
                    }
                    field("Flute - D"; "Flute - D")
                    {
                    }
                    field("Flute - E"; "Flute - E")
                    {
                    }
                    field("Flute - F"; "Flute - F")
                    {
                    }
                }
                group("Height (mm)")
                {
                    Caption = 'Height (mm)';
                    field("Flute - A Height"; "Flute - A Height")
                    {
                    }
                    field("Flute - B Height"; "Flute - B Height")
                    {
                    }
                    field("Flute - C Height"; "Flute - C Height")
                    {
                    }
                    field("Flute - D Height"; "Flute - D Height")
                    {
                    }
                    field("Flute - E Height"; "Flute - E Height")
                    {
                    }
                    field("Flute - F Height"; "Flute - F Height")
                    {
                    }
                }
            }
            group("Quality Setup")
            {
                Caption = 'Quality Setup';
                field("Quality Inspection Location"; "Quality Inspection Location")
                {
                }
                field("Rejection Location"; "Rejection Location")
                {
                }
                field("Inspection No. Series"; "Inspection No. Series")
                {
                }
                field("Specification Nos."; "Specification Nos.")
                {
                }
                field("Default Gen. Bus Posting Group"; "Default Gen. Bus Posting Group")
                {
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}