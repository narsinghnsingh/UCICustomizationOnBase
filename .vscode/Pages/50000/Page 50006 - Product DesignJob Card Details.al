page 50006 "Product DesignJob Card Details"
{
    // version Estimate Samadhan

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Product Design Header";

    layout
    {
        area(content)
        {
            group("Job Card Details")
            {
                Caption = 'Job Card Details';
                group("Pre Press")
                {
                    Caption = 'Pre Press';
                    field("By Purchased Board"; "By Purchased Board")
                    {
                    }
                    field("Artwork Available"; "Artwork Available")
                    {
                    }
                    field("Proof Required"; "Proof Required")
                    {
                    }
                    field("Client Sample"; "Client Sample")
                    {
                    }
                    field("Plate Required"; "Plate Required")
                    {
                    }
                    field("Plate Item No."; "Plate Item No.")
                    {
                    }
                    field("Plate Item Client"; "Plate Item Client")
                    {

                    }
                    field("Plate Item No. 2"; "Plate Item No. 2")
                    {
                    }
                    field(Printing; Printing)
                    {
                    }
                    field("Scorer Type"; "Scorer Type")
                    {
                    }
                    field("Manual Scorer"; "Manual Scorer")
                    {
                    }
                    field("Scorer 1"; "Scorer 1")
                    {
                        Editable = "Manual Scorer";
                    }
                    field("Scorer 2"; "Scorer 2")
                    {
                        Editable = "Manual Scorer";
                    }
                    field("Scorer 3"; "Scorer 3")
                    {
                        Editable = "Manual Scorer";
                    }
                    field("Scorer 4"; "Scorer 4")
                    {
                        Editable = "Manual Scorer";
                    }
                    field("Scorer 5"; "Scorer 5")
                    {
                        Editable = "Manual Scorer";
                    }
                    field("Linear Length Qty Per"; "Linear Length Qty Per")
                    {
                    }
                    field("Linear Length"; "Linear Length")
                    {
                    }
                    field("No. of Colour"; "No. of Colour")
                    {
                        Enabled = Printing;
                    }
                    field("Top Colour"; "Top Colour")
                    {
                    }
                    field("Printing Colour 1"; "Printing Colour 1")
                    {
                    }
                    field("Printing Colour 2"; "Printing Colour 2")
                    {
                    }
                    field("Printing Colour 3"; "Printing Colour 3")
                    {
                    }
                    field("Printing Colour 4"; "Printing Colour 4")
                    {
                    }
                    field("Printing Colour 5"; "Printing Colour 5")
                    {
                    }
                    field("Printing Colour 6"; "Printing Colour 6")
                    {
                    }
                }
                group(Finishing)
                {
                    Caption = 'Finishing';
                    field(Stitching; Stitching)
                    {
                    }
                    field("Box Height"; "Box Height (mm) - D (OD)")
                    {
                        Caption = 'Box Height (mm)';
                        Editable = Stitching;
                    }
                    field("Die Required"; "Die Required")
                    {
                    }
                    field("Die Punching"; "Die Punching")
                    {
                    }
                    field("Die Number"; "Die Number")
                    {
                        Enabled = "Die Punching";
                    }
                    field("Die Number 2"; "Die Number 2")
                    {
                        Editable = "Die Punching";
                    }
                    field(Lamination; Lamination)
                    {
                    }
                    group("Special Detail")
                    {
                        field("Bottom Linear"; "Bottom Linear")
                        {
                        }
                        field("Deep Creasing"; "Deep Creasing")
                        {
                        }
                        field("Packing Method"; "Packing Method")
                        {
                        }
                        field("Pallet Size"; "Pallet Size")
                        {
                        }
                        field("Qty / Pallet"; "Qty / Pallet")
                        {
                        }
                        field("Ref. Sample Available"; "Ref. Sample Available")
                        {
                        }
                        field("Ref. Sample Approved by Custom"; "Ref. Sample Approved by Custom")
                        {
                        }
                        field("Print UCI Logo"; "Print UCI Logo")
                        {
                        }
                        field("Paper Comb."; "Paper Comb.")
                        {
                        }
                        field("Disptach Details"; "Disptach Details")
                        {
                        }
                        field(Remarks; Remarks)
                        {
                        }
                        field("Modification Remarks"; "Modification Remarks")
                        {

                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Make Plate Item")
            {
                Caption = 'Make Plate Item';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by deepak Kumar
                    if (Printing = true) and ("Plate Required" = true) then begin
                        CreatePlateItem(Rec);
                    end else begin
                        Error('Printing must be Yes');
                    end;
                end;
            }
            action("Create Die")
            {
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

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
            action("Print Product Development Details")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;

                trigger OnAction()
                begin
                    EST_HEADER.Reset;
                    EST_HEADER.SetCurrentKey(EST_HEADER."Product Design No.");
                    EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Product Design No.");
                    REPORT.RunModal(REPORT::"Product Dev. Details", true, true, EST_HEADER);
                end;
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
            action("Make Plate Item - 2")
            {
                Caption = 'Make Plate Item -2';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by deepak Kumar
                    if (Printing = true) and ("Plate Required" = true) then begin
                        CreatePlateItem2(Rec);
                    end else begin
                        Error('Printing must be Yes');
                    end;
                end;
            }
            action("Create Die2")
            {
                Caption = 'Create Die-2';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    if ("Die Punching" = true) and ("Die Required" = true) then begin
                        CreateDie2(Rec);
                    end else begin
                        Error('Die Punching must be Yes');
                    end;
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // Lines added BY Deepak Kumar
        if (Printing) and (Status = Status::Open) then
            TestField("No. of Colour");
    end;

    var
        EST_HEADER: Record "Product Design Header";
}

