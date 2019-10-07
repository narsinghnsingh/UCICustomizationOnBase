page 50000 "Product Design List"
{
    // version Estimate Samadhan

    CardPageID = "Product Design Card";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Product Design Header";
    SourceTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                      ORDER(Ascending)
                      WHERE ("Product Design Type" = CONST (Main));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Design No."; "Product Design No.")
                {
                }
                field("Product Design Date"; "Product Design Date")
                {
                }
                field("Old Estimate No."; "Old Estimate No.")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                }
                field("Model No"; "Model No")
                {
                }
                field("Model Description"; "Model Description")
                {
                }
                field(Customer; Customer)
                {
                }
                field(Name; Name)
                {
                }
                field("Sales Person Code"; "Sales Person Code")
                {
                }
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Modification Remarks"; "Modification Remarks")
                {

                }
                field("Quantity to Job Order"; "Quantity to Job Order")
                {
                }
                field("Per Box Weight (Gms)"; "Per Box Weight (Gms)")
                {
                }
                field("Paper Deckle Size (mm)"; "Paper Deckle Size (mm)")
                {
                }
                field("Board Length (mm)- L"; "Board Length (mm)- L")
                {
                }
                field("Board Width (mm)- W"; "Board Width (mm)- W")
                {
                }
                field("No. of Die Cut Ups"; "No. of Die Cut Ups")
                {
                }
                field("No. of Joint"; "No. of Joint")
                {
                }
                field("Top Colour"; "Top Colour")
                {
                }
                field(Grammage; Grammage)
                {
                }
                field("Flute Type"; "Flute Type")
                {
                }
                field(Printing; Printing)
                {
                }
                field("Plate Item No."; "Plate Item No.")
                {
                }
                field(PaperCombination; PaperCombination)
                {
                }
                field("Die Required"; "Die Required")
                {
                }
                field("Die Number"; "Die Number")
                {
                }
                field("Die Number 2"; "Die Number 2")
                {
                }
            }
        }
    }

    actions
    {
    }
}

