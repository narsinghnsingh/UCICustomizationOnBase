page 50060 "Others Quality Spec Lines"
{
    // version Samadhan Quality

    Editable = true;
    PageType = ListPart;
    SourceTable = "Quality Spec Line";
    SourceTableView = WHERE("Source Type"=FILTER(=Others));

    layout
    {
        area(content)
        {
            repeater(Control14)
            {
                ShowCaption = false;
                field("Character Code";"Character Code")
                {

                    trigger OnValidate()
                    begin
                        "Source Type":="Source Type"::Others;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                }
                field(Description;Description)
                {
                }
                field("Normal Value (Num)";"Normal Value (Num)")
                {
                    Editable = "Quantitative";
                }
                field("Min. Value (Num)";"Min. Value (Num)")
                {
                    Editable = "Quantitative";
                }
                field("Max. Value (Num)";"Max. Value (Num)")
                {
                    Editable = "Quantitative";
                }
                field("Normal Value (Char)";"Normal Value (Char)")
                {
                    Editable = Qualitative;
                }
                field("Min. Value (Char)";"Min. Value (Char)")
                {
                    Editable = Qualitative;
                }
                field("Max. Value (Char)";"Max. Value (Char)")
                {
                    Editable = Qualitative;
                }
                field(Qualitative;Qualitative)
                {
                }
                field("Work Center Group";"Work Center Group")
                {
                }
                field(Quantitative;Quantitative)
                {
                }
            }
        }
    }

    actions
    {
    }
}

