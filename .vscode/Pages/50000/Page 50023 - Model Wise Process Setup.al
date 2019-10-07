page 50023 "Model Wise Process Setup"
{
    PageType = CardPart;
    SourceTable = "Quick Est. Setup";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Model Code";"Model Code")
                {
                    Editable = false;
                }
                field("Code";Code)
                {
                }
                field("Work Center Category";"Work Center Category")
                {
                    OptionCaption = ',,Origination Cost,Corrugation,Printing Guiding,Finishing Packing,Sub Job>';
                }
                field(Type;Type)
                {
                }
                field("No.";"No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Price Based Condition";"Price Based Condition")
                {
                }
                field("Standard Cost";"Standard Cost")
                {
                }
                field("Process Description";"Process Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

