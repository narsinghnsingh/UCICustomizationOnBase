page 50001 "Product Design Card"
{
    // version Estimate Samadhan

    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Action,Report,Approval';
    SourceTable = "Product Design Header";
    SourceTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                      ORDER(Ascending)
                      WHERE ("Product Design Type" = CONST (Main));


    layout
    {
        area(content)
        {
            group(General)
            {
                field("Product Design No."; "Product Design No.")
                {
                    Editable = false;
                }
                field("Product Design Date"; "Product Design Date")
                {
                }
                field(Customer; Customer)
                {
                }
                field(Contact; Contact)
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Copy From"; "Copy From")
                {
                }

                field("Modification Remarks"; "Modification Remarks")
                {

                }
                field("Production Order No."; "Production Order No.")
                {
                    Importance = Additional;
                }
                field("Quantity to Job Order"; "Quantity to Job Order")
                {
                    Importance = Additional;
                }
                field("Sales Order No."; "Sales Order No.")
                {
                    Importance = Additional;
                }
                field("Sales Order Line No."; "Sales Order Line No.")
                {
                    Importance = Additional;
                }
                field("Sales Person Code"; "Sales Person Code")
                {
                    Editable = false;
                }
                field("By Purchased Board"; "By Purchased Board")
                {
                    Importance = Additional;
                }
                grid(Control56)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group(Control57)
                    {
                        Caption = 'Status';
                        field("Pre-Press Status"; "Pre-Press Status")
                        {
                            Caption = 'Pre-Press';
                        }
                        field("Production Status"; "Production Status")
                        {
                            Caption = 'Production';
                        }
                    }
                    group("Confirmed By")
                    {
                        Caption = 'Confirmed By';
                        field("Pre-Press Confirmed By"; "Pre-Press Confirmed By")
                        {
                            ShowCaption = false;
                        }
                        field("Production Confirmed By"; "Production Confirmed By")
                        {
                            ShowCaption = false;
                        }
                    }
                }
            }
            part(Control18; "Product Design Line")
            {
                SubPageLink = "Product Design No." = FIELD ("Product Design No.");
                SubPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                              ORDER(Ascending);
            }
            group("Margin Detail")
            {
                Caption = 'Margin Detail';
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
                field("Box Amount per Unit"; "Box Amount per Unit")
                {
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total Amount"; "Total Amount")
                {
                    Importance = Promoted;
                }
                field("Amount Per Unit"; "Amount Per Unit")
                {
                    Caption = 'Amount Per Unit with Margin';
                }
                field("Total Weight for Est. Qty (Kg)"; "Total Weight for Est. Qty (Kg)")
                {
                    Caption = 'Total Weight for Est. Qty (Kg)';
                }
                field("Amount Per KG"; "Amount Per KG")
                {
                }
                field("Per Box Weight (Gms)"; "Per Box Weight (Gms)")
                {
                }
                field("Per Box Weight with Comp(Gms)"; "Per Box Weight with Comp(Gms)")
                {
                }
            }
        }
        area(factboxes)
        {
            part(EstimateFatBox; "Estimate Fact Box")
            {
                ApplicationArea = All;
                SubPageLink = "Estimate Code" = FIELD ("Product Design No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Copy Document")
            {
                Caption = 'Copy Document';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;

                trigger OnAction()
                begin
                    // Lines added bY Deepak Kumar
                    TestField("Copy From");
                    CopyEastimate("Copy From", "Product Design No.");
                end;
            }
            action("Calculate Details")
            {
                Caption = 'Calculate Details';
                Image = CalculateConsumption;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    EstimateHeader: Record "Product Design Header";
                begin
                    // Lines added BY Deepak Kumar
                    EstimateHeader.Reset;
                    EstimateHeader.SetRange(EstimateHeader."Product Design No.", "Product Design No.");
                    if EstimateHeader.FindFirst then begin
                        repeat
                            EstimateCodeunit.UpdateSubItem(EstimateHeader);
                        until EstimateHeader.Next = 0;
                    end;
                    //###################################

                    EstimateCodeunit.CreateSubJob("Product Design No.");//Deepak 230316
                    CalcDetail("Product Design No.");
                    UpdateWeightinItem(Rec);
                end;
            }
            action("Make Prod. Order")
            {
                Image = DebugNext;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    TestField(Status, Status::Approved);
                    TestField("Sales Order No.");
                    TestField("Sales Order Line No.");
                    // // Lines added By Deepak Kumar
                    // Commented on 18 01 16 as per request from Binay
                    /*
                    IF "Die Required" = TRUE THEN
                      CreateDie;
                    IF "Plate Required" = TRUE THEN
                        CreatePlateItem;
                    */
                    EstimateCodeunit.CreateProdOrder("Product Design No.");
                    CurrPage.Close;

                end;
            }
            action("Publish BOM & Routing")
            {
                Image = Migration;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    EstimateHeader: Record "Product Design Header";
                begin
                    // Lines added by Deepak Kumar
                    EstimateHeader.Reset;
                    EstimateHeader.SetRange(EstimateHeader."Product Design No.", "Product Design No.");
                    if EstimateHeader.FindFirst then begin
                        repeat
                            EstimateCodeunit.UpdateSubItem(EstimateHeader);
                        until EstimateHeader.Next = 0;
                    end;

                    EstimateCodeunit.PublishBOMRouting("Product Design No.");
                end;
            }
            action("Update Ups and No of Joints")
            {
                Caption = 'Update Ups and No of Joints';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    EstimateHeader: Record "Product Design Header";
                begin
                    // Lines added By Deepak Kumar
                    EstimateHeader.Reset;
                    EstimateHeader.SetRange(EstimateHeader."Product Design No.", "Product Design No.");
                    if EstimateHeader.FindFirst then begin
                        repeat
                            EstimateCodeunit.UpdateSubItem(EstimateHeader);
                        until EstimateHeader.Next = 0;
                        Message('Completed');
                    end;
                end;
            }
            action("Special Description ")
            {
                Image = AdjustItemCost;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Estimate Special Description";
                RunPageLink = "No." = FIELD ("Product Design No.");
                RunPageView = SORTING ("No.", "Line No.")
                              ORDER(Ascending);
            }
            action("Product Design Additional Cost")
            {
                Caption = 'Product Design Additional Cost';
                Image = JobRegisters;
                RunObject = Page "Product Design Additional Cost";
                RunPageLink = "No." = FIELD ("Product Design No."),
                              Category = CONST (Cost);
                RunPageView = SORTING ("No.", "Line No.")
                              ORDER(Ascending);
            }
            action("Update Unit Price on Sales Quote")
            {
                Caption = 'Update Unit Price on Sales Quote';
                Image = CalculateRegenerativePlan;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    UpdateEstimatePriceOnSalesQuote;
                end;
            }

            separator(Separator30)
            {
            }
            action("Quick Design")
            {
                Caption = 'Quick Design';
                Image = AutofillQtyToHandle;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Quick Product Design";
                RunPageLink = "Product Design Type" = FIELD ("Product Design Type"),
                              "Product Design No." = FIELD ("Product Design No."),
                              "Sub Comp No." = FIELD ("Sub Comp No.");
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                              ORDER(Ascending);
                Visible = false;
            }
            separator(Separator16)
            {
            }
            action("Send to Pre-Press")
            {
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    SendtoPrePress(Rec);
                end;
            }
            action("Send to Production")
            {
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    SendtoProduction(Rec);
                end;
            }
            action("Approve Pre-Press")
            {
                Image = RegisterPick;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    PDesignHeader: Record "Product Design Header";
                begin
                    // Lines added by Deepak Kumar                    
                    PDesignHeader.RESET;
                    PDesignHeader.SETRANGE(PDesignHeader."Item Code", "Item Code");
                    PDesignHeader.SETRANGE(PDesignHeader.Status, PDesignHeader.Status::Approved);
                    IF PDesignHeader.FINDFIRST THEN BEGIN
                        ERROR('You can not approve PDI %1, for this FG %2 another PDI %3 already exist and approved.', "Product Design No.", "Item Code", PDesignHeader."Product Design No.");
                    END;

                    IF ("Old Estimate No." <> '') OR ("Copy From" <> '') then
                        TestField("Modification Remarks");

                    IF (Calculated) AND ("BOM Published") THEN
                        ApproveFromPrePress(Rec)
                    ELSE
                        ERROR('Kindly click on calculate details & Published BOM Buttons first  for approval %1', "Product Design No.");
                end;
            }
            action("Approve Production")
            {
                Image = RegisterPick;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    PDesignHeader: Record "Product Design Header";
                begin
                    // Lines added by Deepak Kumar                                      
                    PDesignHeader.RESET;
                    PDesignHeader.SETRANGE(PDesignHeader."Item Code", "Item Code");
                    PDesignHeader.SETRANGE(PDesignHeader.Status, PDesignHeader.Status::Approved);
                    IF PDesignHeader.FINDFIRST THEN BEGIN
                        ERROR('You can not approve PDI %1, for this FG %2 another PDI %3 already exist and approved.', "Product Design No.", "Item Code", PDesignHeader."Product Design No.");
                    END;

                    IF ("Old Estimate No." <> '') OR ("Copy From" <> '') then
                        TestField("Modification Remarks");

                    IF (Calculated) AND ("BOM Published") THEN
                        ApproveFromProduction(Rec)
                    ELSE
                        ERROR('Kindly click on calculate details & Published BOM Buttons first  for approval %1', "Product Design No.");
                end;
            }
            action(Approval)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    PDesignHeader: Record "Product Design Header";
                    PrdDesignHeader: Record "Product Design Header";
                begin
                    // Lines added by Deepak Kumar
                    PDesignHeader.RESET;
                    PDesignHeader.SETRANGE(PDesignHeader."Item Code", "Item Code");
                    PDesignHeader.SETRANGE(PDesignHeader.Status, PDesignHeader.Status::Approved);
                    IF PDesignHeader.FINDFIRST THEN BEGIN
                        ERROR('You can not approve PDI %1, for this FG %2 another PDI %3 already exist and approved.', "Product Design No.", "Item Code", PDesignHeader."Product Design No.");
                    END;

                    IF ("Old Estimate No." <> '') OR ("Copy From" <> '') then
                        TestField("Modification Remarks");

                    IF (Calculated) AND ("BOM Published") THEN BEGIN
                        IF Status <> 1 THEN BEGIN
                            TestField("Sales Order No.");
                            TestField("Sales Order Line No.");
                            StatusApprove("Product Design No.");
                            IF "Sales Quote No." <> '' THEN
                                UpdateEstimatePriceOnSalesQuote;
                            IF "Sales Order No." <> '' THEN
                                UpdateEstimatePriceOnSalesOrder;
                            PrdDesignHeader.RESET;
                            PrdDesignHeader.SETRANGE(PrdDesignHeader."Product Design No.", "Product Design No.");
                            IF PrdDesignHeader.FINDFIRST THEN BEGIN
                                PrdDesignHeader.Calculated := FALSE;
                                PrdDesignHeader."BOM Published" := FALSE;
                                PrdDesignHeader.MODIFY;
                            END;
                        END ELSE
                            ERROR('Alreaday In %1 Stage', Status);
                    END ELSE
                        ERROR('Kindly click on calculate details and Published BOM button first  for approval %1', "Product Design No.");
                end;
            }
            action("Re-Open")
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    if Status <> 0 then
                        StatusReopen("Product Design No.")
                    else
                        Error('Alreaday In %1 Stage', Status);
                end;
            }
            action(Cancel)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    if Status <> 2 then
                        StatusSuspend("Product Design No.")
                    else
                        Error('Alreaday In %1 Stage', Status);
                end;
            }
            separator(Separator17)
            {
            }
            action("Print Design Sheet")
            {
                Caption = 'Print Design Sheet';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    EST_HEADER.Reset;
                    EST_HEADER.SetCurrentKey(EST_HEADER."Product Design No.");
                    EST_HEADER.SetRange(EST_HEADER."Product Design No.", "Product Design No.");
                    REPORT.RunModal(REPORT::Estimate, true, true, EST_HEADER);
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
            separator(Separator20)
            {
            }


            action("Update Revised Price In Sales Order")
            {
                Caption = 'Update Revised Price In Sales Order';
                Image = InsertCurrency;
                Promoted = true;
                PromotedCategory = Category4;
            }
            separator(Separator35)
            {
            }
            action("Component List")
            {
                Image = BOM;
                RunObject = Page "Product Design Component";
                RunPageLink = "Product Design No." = FIELD ("Product Design No.");
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.", "Material / Process Link Code")
                              ORDER(Ascending);
            }
            action("Update Weight on Item Card")
            {
                Caption = 'Update Weight on Item Card';

                trigger OnAction()
                begin
                    UpdateWeightinItem(Rec);
                end;
            }
        }
    }

    var
        EstimateCodeunit: Codeunit "Estimate Code Unit";
        EST_HEADER: Record "Product Design Header";
}

