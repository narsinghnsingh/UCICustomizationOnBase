page 50012 "Item Attribute Value"
{
    // version Item Wizard Samadhan

    PageType = List;
    SourceTable = "Attribute Value";
    SourceTableView = SORTING ("Attribute Code", "Field Type") ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Attribute Code"; "Attribute Code")
                {
                    Editable = false;
                }
                field("Attribute Value"; "Attribute Value")
                {
                    Editable = TextD;
                }
                field("Attribute Value Description"; "Attribute Value Description")
                {
                }
                field("Attribute Value Numreric"; "Attribute Value Numreric")
                {
                    Editable = NumericD;
                }
                field("Field Type"; "Field Type")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Lines added By Deepka Kumar
        ItemAttibuteCode.RESET;
        ItemAttibuteCode.SETRANGE(ItemAttibuteCode."Attribute Code", "Attribute Code");
        IF ItemAttibuteCode.FINDFIRST THEN BEGIN
            "Field Type" := ItemAttibuteCode."Field Type";
            SETRANGE("Field Type", "Field Type");
            NumericD := FALSE;
            TextD := FALSE;
            IF "Field Type" = 0 THEN BEGIN
                TextD := TRUE;
                NumericD := FALSE;
            END ELSE BEGIN
                TextD := FALSE;
                NumericD := TRUE;
            END;

        END;
    end;

    trigger OnOpenPage()
    begin
        // Lines added BY Deepak Kumar
        NumericD := FALSE;
        TextD := FALSE;
        IF "Field Type" = 0 THEN BEGIN
            TextD := TRUE;
            NumericD := FALSE;
        END ELSE BEGIN
            TextD := FALSE;
            NumericD := TRUE;
        END;
    end;

    var
        [InDataSet]
        TextD: Boolean;
        [InDataSet]
        NumericD: Boolean;
        NewFeildType: Option Text,Numeric;
        TempFilter: Text;
        ItemAttibuteCode: Record "Attribute Master";
}

