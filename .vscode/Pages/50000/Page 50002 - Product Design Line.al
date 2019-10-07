page 50002 "Product Design Line"
{
    // version Estimate Samadhan

    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Product Design Header";

    layout
    {
        area(content)
        {
            repeater(Control14)
            {
                ShowCaption = false;
                field("Product Design Type"; "Product Design Type")
                {
                    Editable = false;
                }
                field("Sub Comp No."; "Sub Comp No.")
                {
                    Editable = false;
                }
                field("Model No"; "Model No")
                {
                }
                field("Model Description"; "Model Description")
                {
                }
                field("Quantity Per FG"; "Quantity Per FG")
                {
                }
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Flute Type"; "Flute Type")
                {

                }
                field("Customer GSM"; "Customer GSM")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("No. of Ply"; "No. of Ply")
                {
                }
                field("Item Unit of Measure"; "Item Unit of Measure")
                {
                }
                field("Board Size"; "Board Size")
                {
                }
                field("Box Size"; "Box Size")
                {
                }
                field(Grammage; Grammage)
                {
                }
                field("Amount Per Unit"; "Amount Per Unit")
                {
                }
                field("Per Box Weight (Gms)"; "Per Box Weight (Gms)")
                {
                }
                field("Unit Cost From Cal Sheet"; "Unit Cost From Cal Sheet")
                {
                }
                field("Separate Sales Lines"; "Separate Sales Lines")
                {
                    Importance = Promoted;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New Component")
            {
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added by Deepak kumar for Create !!!
                    LineCount := 0;
                    EstimateHeader.Reset;
                    EstimateHeader.SetRange(EstimateHeader."Product Design Type", EstimateHeader."Product Design Type"::Sub);
                    EstimateHeader.SetRange(EstimateHeader."Product Design No.", "Product Design No.");
                    if EstimateHeader.FindFirst then begin
                        repeat
                            LineCount := LineCount + 1;
                        until EstimateHeader.Next = 0;
                    end;
                    LineCount := LineCount + 1;

                    NewEstimate.Init;
                    NewEstimate."Product Design Type" := NewEstimate."Product Design Type"::Sub;
                    NewEstimate."Product Design No." := "Product Design No.";
                    NewEstimate."Sub Comp No." := "Product Design No." + '-' + Format(LineCount);
                    NewEstimate."Product Design Date" := WorkDate;
                    NewEstimate.Insert(true);
                end;
            }
            action("Technical Detail")
            {
                Image = UntrackedQuantity;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Product Design Box Details";
                RunPageLink = "Product Design Type" = FIELD ("Product Design Type"),
                              "Product Design No." = FIELD ("Product Design No."),
                              "Sub Comp No." = FIELD ("Sub Comp No.");
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                              ORDER(Ascending);
            }
            action("Material (Bill of Material)")
            {
                Image = BOM;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Product Design BOM";
                RunPageLink = "Product Design Type" = FIELD ("Product Design Type"),
                              "Product Design No." = FIELD ("Product Design No."),
                              "Sub Comp No." = FIELD ("Sub Comp No.");
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.", "Line No.")
                              ORDER(Ascending);
            }
            action("Process ( Routing )")
            {
                Image = Route;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Product Design Process Routing";
                RunPageLink = "Product Design Type" = FIELD ("Product Design Type"),
                              "Product Design No." = FIELD ("Product Design No."),
                              "Sub Comp No." = FIELD ("Sub Comp No.");
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.", "Line No.")
                              ORDER(Ascending);
            }
            action("Job Card Detail")
            {
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Product DesignJob Card Details";
                RunPageLink = "Product Design Type" = FIELD ("Product Design Type"),
                              "Product Design No." = FIELD ("Product Design No."),
                              "Sub Comp No." = FIELD ("Sub Comp No.");
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                              ORDER(Ascending);
            }
            action("Sales link")
            {
                Image = "Order";
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Estimate Sales Quote / Order";
                RunPageLink = "Product Design Type" = FILTER (Main),
                              "Product Design No." = FIELD ("Product Design No.");
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                              ORDER(Ascending);
            }
            action(Components)
            {
                Image = BOMLevel;
                RunObject = Page "Product Design Component";
                RunPageLink = "Product Design No." = FIELD ("Product Design No.");
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.", "Material / Process Link Code")
                              ORDER(Ascending);
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        // Lines added bY Deepak kumar
        if "Product Design Type" = "Product Design Type"::Main then
            Error('You con not delete main Estimate');
    end;

    var
        EstimateHeader: Record "Product Design Header";
        EstimateLine: Record "Product Design Line";
        LineCount: Integer;
        NewEstimate: Record "Product Design Header";
}

