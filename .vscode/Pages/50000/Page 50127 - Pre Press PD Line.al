page 50127 "Pre Press PD Line"
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
                field("Product Design Type";"Product Design Type")
                {
                    Editable = false;
                }
                field("Sub Comp No.";"Sub Comp No.")
                {
                    Editable = false;
                }
                field("Model No";"Model No")
                {
                }
                field("Model Description";"Model Description")
                {
                }
                field("Quantity Per FG";"Quantity Per FG")
                {
                }
                field("Item Code";"Item Code")
                {
                }
                field("Item Description";"Item Description")
                {
                }
                field(Quantity;Quantity)
                {
                }
                field("No. of Ply";"No. of Ply")
                {
                }
                field("Item Unit of Measure";"Item Unit of Measure")
                {
                }
                field("Board Size";"Board Size")
                {
                }
                field("Box Size";"Box Size")
                {
                }
                field(Grammage;Grammage)
                {
                }
                field("Amount Per Unit";"Amount Per Unit")
                {
                }
                field("Per Box Weight (Gms)";"Per Box Weight (Gms)")
                {
                }
                field("Unit Cost From Cal Sheet";"Unit Cost From Cal Sheet")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Technical Detail")
            {
                Image = UntrackedQuantity;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Product Design Box Details";
                RunPageLink = "Product Design Type"=FIELD("Product Design Type"),
                              "Product Design No."=FIELD("Product Design No."),
                              "Sub Comp No."=FIELD("Sub Comp No.");
                RunPageMode = View;
                RunPageView = SORTING("Product Design Type","Product Design No.","Sub Comp No.")
                              ORDER(Ascending);
            }
            action("Job Card Detail")
            {
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Product DesignJob Card Details";
                RunPageLink = "Product Design Type"=FIELD("Product Design Type"),
                              "Product Design No."=FIELD("Product Design No."),
                              "Sub Comp No."=FIELD("Sub Comp No.");
                RunPageView = SORTING("Product Design Type","Product Design No.","Sub Comp No.")
                              ORDER(Ascending);
            }
            action("Make Plate Item")
            {
                Caption = 'Make Plate Item';
                Image = Picture;

                trigger OnAction()
                begin
                    // Lines added by deepak Kumar
                    if (Printing = true) and ("Plate Required"= true) then begin
                      CreatePlateItem(Rec);
                    end else begin
                      Error('Printing must be Yes');
                    end;
                end;
            }
            action("Create Die")
            {
                Image = Picture;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    if ("Die Punching" = true) and ("Die Required" = true) then begin
                      CreateDie(Rec);
                    end else begin
                      Error('Die Punching must be Yes');
                    end;
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        // Lines added bY Deepak kumar
        if "Product Design Type" = "Product Design Type" :: Main then
          Error('You con not delete main Estimate');
    end;

    var
        EstimateHeader: Record "Product Design Header";
        EstimateLine: Record "Product Design Line";
        LineCount: Integer;
        NewEstimate: Record "Product Design Header";
}

