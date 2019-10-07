page 50018 "Quick Product Design"
{
    // version Estimate Samadhan

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    UsageCategory = Documents;
    RefreshOnActivate = true;
    SourceTable = "Product Design Header";

    layout
    {
        area(content)
        {
            group(Model)
            {
                CaptionML = ENU = 'Model';
                field("Model No"; "Model No")
                {

                    trigger OnValidate()
                    var
                        QuickEntryProcess: Record "Quick Entry Process";
                    begin
                        // Lines added BY Deepak Kumar
                        if ("Model No" = '0203') then begin
                            DieCutType := true;
                            RSCType := false;
                        end else begin
                            DieCutType := false;
                            RSCType := true;
                        end;

                        // Lines added BY Deepak Kumar
                        UpdateProcessInQuickEstimate(Rec);
                    end;
                }
                field("No. of Ply"; "No. of Ply")
                {

                    trigger OnValidate()
                    begin
                        // Lines added BY Deepak Kumar
                        UpdatePaperPositionInQuickEstimate(Rec);
                    end;
                }
                field(Quantity; Quantity)
                {
                }
                field("Board Ups"; "Board Ups")
                {
                }
                field("Corrugation Machine"; "Corrugation Machine")
                {
                }
                grid(Control30)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group("In Millimetre(mm)")
                    {
                        CaptionML = ENU = 'In Millimetre(mm)';
                        field("Box Length (mm)- L (OD)"; "Box Length (mm)- L (OD)")
                        {
                            CaptionML = ENU = 'Box Length';
                            Editable = RSCType;
                        }
                        field("Box Width (mm)- W (OD)"; "Box Width (mm)- W (OD)")
                        {
                            CaptionML = ENU = 'Box Width';
                            Editable = RSCType;
                        }
                        field("Box Height (mm) - D (OD)"; "Box Height (mm) - D (OD)")
                        {
                            CaptionML = ENU = 'Box Height';
                            Editable = RSCType;
                        }
                        field("Board Length"; "Board Length (mm)- L")
                        {
                            CaptionML = ENU = 'Board Length';
                            Editable = DieCutType;
                            Importance = Promoted;
                        }
                        field("Board Width"; "Board Width (mm)- W")
                        {
                            CaptionML = ENU = 'Board Width';
                            Editable = DieCutType;
                            Importance = Promoted;
                        }
                        field("Cut Size (mm)"; "Cut Size (mm)")
                        {
                            CaptionML = ENU = 'Cut Size';
                        }
                        field("Roll Width (mm)"; "Roll Width (mm)")
                        {
                            CaptionML = ENU = 'Roll Width';
                        }
                    }
                    group("In Centimetre(cm)")
                    {
                        CaptionML = ENU = 'In Centimetre(cm)';
                        field("Box Length (cm)"; "Box Length (cm)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Width (cm)"; "Box Width (cm)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Height (cm)"; "Box Height (cm)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Board Length (cm)"; "Board Length (cm)")
                        {
                            Editable = DieCutType;
                            ShowCaption = false;
                        }
                        field("Board Width (cm)"; "Board Width (cm)")
                        {
                            Editable = DieCutType;
                            ShowCaption = false;
                        }
                        field("Cut Size (cm)"; "Cut Size (cm)")
                        {
                            ShowCaption = false;
                        }
                        field("Roll Width (cm)"; "Roll Width (cm)")
                        {
                            ShowCaption = false;
                        }
                    }
                    group("In Inch(inch)")
                    {
                        CaptionML = ENU = 'In Inch(inch)';
                        field("Box Length (inch)"; "Box Length (inch)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Width (inch)"; "Box Width (inch)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Height (inch)"; "Box Height (inch)")
                        {
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Board Length (inch)"; "Board Length (inch)")
                        {
                            Editable = DieCutType;
                            ShowCaption = false;
                        }
                        field("Board Width (inch)"; "Board Width (inch)")
                        {
                            Editable = DieCutType;
                            ShowCaption = false;
                        }
                        field("Cut Size (Inch)"; "Cut Size (Inch)")
                        {
                            ShowCaption = false;
                        }
                        field("Roll Width ( Inch)"; "Roll Width ( Inch)")
                        {
                            ShowCaption = false;
                        }
                    }
                    group("Box ID (mm)")
                    {
                        CaptionML = ENU = 'Box ID (mm)';
                        field("Box Length (mm)- L (ID)"; "Box Length (mm)- L (ID)")
                        {
                            CaptionML = ENU = 'Box Length';
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Width (mm)- W (ID)"; "Box Width (mm)- W (ID)")
                        {
                            CaptionML = ENU = 'Box Width';
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                        field("Box Height (mm) - D (ID)"; "Box Height (mm) - D (ID)")
                        {
                            CaptionML = ENU = 'Box Height';
                            Editable = RSCType;
                            ShowCaption = false;
                        }
                    }
                }
            }
            part("Quick Estimate Material"; "Quick Product Design Component")
            {
                ShowFilter = false;
                SubPageLink = "Product Design Type" = FIELD ("Product Design Type"),
                              "Product Design No." = FIELD ("Product Design No."),
                              "Sub Comp No." = FIELD ("Sub Comp No.");
                SubPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.", "Process Code")
                              ORDER(Ascending);
            }
            part("Quick Estimate Process"; "Quick Product Design Routing")
            {
                CaptionML = ENU = 'Quick Estimate Process';
                ShowFilter = false;
                SubPageLink = "Product Design Type" = FIELD ("Product Design Type"),
                              "Product Design No." = FIELD ("Product Design No."),
                              "Sub Comp No." = FIELD ("Sub Comp No.");
                SubPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.", "Process Code")
                              ORDER(Ascending);
            }
            group("Margin Detail")
            {
                CaptionML = ENU = 'Margin Detail';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field("Die Making Charges"; "Die Making Charges")
                {
                    Importance = Additional;
                }
                field("Plate Making Charges"; "Plate Making Charges")
                {
                    Importance = Additional;
                }
                field("Other Charges"; "Other Charges")
                {
                    Importance = Additional;
                }
                field("Line Amount"; "Line Amount")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Margin %"; "Margin %")
                {
                    Importance = Promoted;
                }
                field("Margin Amount"; "Margin Amount")
                {
                    Importance = Promoted;
                }
                field("Sales Price (Per Unit)"; "Sales Price (Per Unit)")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                    Importance = Promoted;
                }
                field("Amount Per Unit"; "Amount Per Unit")
                {
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total Weight for Est. Qty (Kg)"; "Total Weight for Est. Qty (Kg)")
                {
                    CaptionML = ENU = 'Total Weight for Est. Qty (Kg)';
                }
                field("Amount Per KG"; "Amount Per KG")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control33; "Paper Inventory")
            {
                Provider = "Quick Estimate Material";
                SubPageLink = "Deckle Size (mm)" = FIELD (FILTER ("Deckle Size")),
                              "Paper GSM" = FIELD (FILTER ("Paper GSM")),
                              "Bursting factor(BF)" = FIELD (FILTER ("BF (Burst Factor)"));
            }
            part(Control2; "Quick Estimate Fact  Box")
            {
                ShowFilter = false;
                SubPageLink = "Product Design Type" = FIELD ("Product Design Type"),
                              "Product Design No." = FIELD ("Product Design No."),
                              "Sub Comp No." = FIELD ("Sub Comp No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Details")
            {
                Image = CalculateConsumption;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    EstimateCodeunit.QuickEstimate("Product Design No.");
                    CalcDetail("Product Design No.");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Lines added BY Deepak Kumar
        if ("Model No" = '0203') then begin
            DieCutType := true;
            RSCType := false;
        end else begin
            DieCutType := false;
            RSCType := true;
        end;
    end;

    var
        [InDataSet]
        RSCType: Boolean;
        DieCutType: Boolean;
        EstimateCodeunit: Codeunit "Estimate Code Unit";
}

