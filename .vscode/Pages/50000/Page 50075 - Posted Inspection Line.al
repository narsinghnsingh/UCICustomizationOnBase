page 50075 "Posted Inspection Line"
{
    // version Samadhan Quality

    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Posted Inspection Sheet";

    layout
    {
        area(content)
        {
            repeater(Control22)
            {
                ShowCaption = false;
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
                field("Spec ID";"Spec ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

