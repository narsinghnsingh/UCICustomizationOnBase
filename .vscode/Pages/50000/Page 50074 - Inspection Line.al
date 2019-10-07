page 50074 "Inspection Line"
{
    // version Samadhan Quality

    InsertAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Inspection Sheet";

    layout
    {
        area(content)
        {
            repeater(Control22)
            {
                ShowCaption = false;
                field("Source Type";"Source Type")
                {
                }
                field("Source Document No.";"Source Document No.")
                {
                }
                field("Item Type";"Item Type")
                {
                }
                field("QA Characteristic Code";"QA Characteristic Code")
                {
                }
                field("QA Characteristic Description";"QA Characteristic Description")
                {
                }
                field("Normal Value (Num)";"Normal Value (Num)")
                {
                }
                field("Min. Value (Num)";"Min. Value (Num)")
                {
                }
                field("Max. Value (Num)";"Max. Value (Num)")
                {
                }
                field("Observation 1 (Num)";"Observation 1 (Num)")
                {
                }
                field("Observation 2 (Num)";"Observation 2 (Num)")
                {
                }
                field("Observation 3 (Num)";"Observation 3 (Num)")
                {
                }
                field("Observation 4 (Num)";"Observation 4 (Num)")
                {
                }
                field("Actual Value (Num)";"Actual Value (Num)")
                {
                }
                field("Normal Value (Text)";"Normal Value (Text)")
                {
                    Editable = false;
                }
                field("Min. Value (Text)";"Min. Value (Text)")
                {
                    Editable = false;
                }
                field("Max. Value (Text)";"Max. Value (Text)")
                {
                    Editable = false;
                }
                field("Actual  Value (Text)";"Actual  Value (Text)")
                {
                }
                field("Unit of Measure";"Unit of Measure")
                {
                }
                field("Reason Code";"Reason Code")
                {
                }
                field(Remarks;Remarks)
                {
                }
                field(Qualitative;Qualitative)
                {
                }
                field(Quantitative;Quantitative)
                {
                }
                field("Entry No.";"Entry No.")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

