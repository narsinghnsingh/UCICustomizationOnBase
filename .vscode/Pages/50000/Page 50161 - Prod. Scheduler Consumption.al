page 50161 "Prod. Scheduler Consumption"
{
    // version Prod. Schedule

    InsertAllowed = false;
    PageType = Worksheet;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Con. Item Selection N";
    SourceTableView = SORTING ("Prod. Schedule No", "Req. Line Number", "Line Number")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            field(RequisitionNo; RequisitionNo)
            {
                CaptionML = ENU = 'Requisition No.';
                TableRelation = "Requisition Header"."Requisition No." WHERE (Status = CONST (Released),
                                                                              "Requisition Type" = CONST ("Production Schedule"));
            }
            group(Control13)
            {
                ShowCaption = false;
                repeater(Group)
                {
                    field("Item Code"; "Item Code")
                    {
                        StyleExpr = AdditionalLine;
                    }
                    field("Roll ID"; "Roll ID")
                    {
                        StyleExpr = AdditionalLine;
                    }
                    field("Item Description"; "Item Description")
                    {
                        StyleExpr = AdditionalLine;
                    }
                    field("Initial Roll Weight"; "Initial Roll Weight")
                    {
                        StyleExpr = AdditionalLine;
                    }
                    field("Paper Position"; "Paper Position")
                    {
                        OptionCaption = ' ,DL- Liner1,M1-Flute1,L1-Liner2,M2-Flute2,L2-Liner3';
                        StyleExpr = AdditionalLine;
                    }
                    field("Final Roll Weight"; "Final Roll Weight")
                    {
                        StyleExpr = AdditionalLine;
                    }
                    field("Quantity to Consume"; "Quantity to Consume")
                    {
                        StyleExpr = AdditionalLine;
                    }
                    field("Vendor Roll Number"; "Vendor Roll Number")
                    {
                    }
                    field("Paper Type"; "Paper Type")
                    {
                    }
                    field("Paper GSM"; "Paper GSM")
                    {
                    }
                    field("Deckle Size (mm)"; "Deckle Size (mm)")
                    {
                    }
                    field("Applied Quantity"; "Applied Quantity")
                    {
                    }
                }
                group(Control24)
                {
                    ShowCaption = false;
                    part(Control10; "Prod. Scheduler Cons. Sub")
                    {
                        SubPageLink = "Requisition No." = FIELD ("Requisition No."),
                                      "Prod. Schedule No" = FIELD ("Prod. Schedule No"),
                                      "Item Code" = FIELD ("Item Code"),
                                      "Variant Code/ Reel Number" = FIELD ("Roll ID");
                        SubPageView = SORTING ("Marked for Consumption Post")
                                      ORDER(Ascending);
                    }
                    part("<Prod. Scheduler Cons. SubN"; "Prod. Scheduler Cons. Sub")
                    {
                        CaptionML = ENU = 'Lines Available for Consumption';
                        Editable = false;
                        SubPageLink = "Requisition No." = FIELD ("Requisition No."),
                                      "Prod. Schedule No" = FIELD ("Prod. Schedule No");
                        Visible = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New Line")
            {
                Image = Add;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    // Lines Added By  Deepak Kumar
                    SchedularCodeUnit.AddNewLConsumptionLine(RequisitionNo);
                end;
            }
            action("Get Req. Line")
            {
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    SchedularCodeUnit.GetConsumptionLineNew(RequisitionNo)
                    //SchedularCodeUnit.GetConsumptionLine(RequisitionNo);
                end;
            }
            action("Calc Consumption Line")
            {
                Image = CalculateConsumption;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    if RequisitionNo = '' then
                        Error('Please define Requisition No');
                    SchedularCodeUnit.CalcReInitiate(RequisitionNo);
                    SchedularCodeUnit.UpdatePaperPosition(RequisitionNo);
                    Commit;
                    SchedularCodeUnit.ValidatePaperPosition(RequisitionNo);
                    SchedularCodeUnit.CalcPostingLine(RequisitionNo);
                end;
            }
            action("Calc Cons + Post Line")
            {
                Image = CalculateConsumption;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    SchedularCodeUnit.CalcPostingLine("Requisition No.");
                    SchedularCodeUnit.PostConsumptionLine("Requisition No.");
                    CurrPage.Close;
                end;
            }
            action("Re-Initiate")
            {
                CaptionML = ENU = 'Re-Initiate';
                Image = RefreshRegister;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ConItemSelection: Record "Con. Item Selection 1";
                    ConsProdOrderSelection: Record "Cons. Prod. Order Selection";
                begin
                    ConItemSelection.Reset;
                    if ConItemSelection.FindSet then
                        ConItemSelection.DeleteAll(true);

                    ConsProdOrderSelection.Reset;
                    if ConsProdOrderSelection.FindSet then
                        ConsProdOrderSelection.DeleteAll(true);
                end;
            }
            action("Update paper Postion")
            {
                CaptionML = ENU = 'Update paper Postion';

                trigger OnAction()
                begin
                    SchedularCodeUnit.UpdatePaperPosition(RequisitionNo);
                end;
            }
            action("Validate Paper Details")
            {
                CaptionML = ENU = 'Validate Paper Details';
                Image = CalculateCrossDock;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    if RequisitionNo = '' then
                        Error('Please define Requisition No');

                    SchedularCodeUnit.CreatePaperPositionErrorLog("Requisition No.");
                end;
            }
            action("Error Log")
            {
                CaptionML = ENU = 'Error Log';
                Image = ErrorLog;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Prod. Order Comment Sheet";
                RunPageLink = "Req No." = FIELD ("Requisition No.");
            }
            action("Extra Item")
            {
                CaptionML = ENU = 'Extra Item';
                RunObject = Page "Cons. Prod. Order Selection";
                RunPageView = SORTING ("Prod. Schedule No", "Line No.")
                              ORDER(Ascending)
                              WHERE ("Extra Consumtion Variation(%)" = FILTER (> 0));
            }
        }
    }

    var
        SchedularCodeUnit: Codeunit Scheduler;
        ConsProdOrderSelection: Record "Cons. Prod. Order Selection";
        RequisitionNo: Code[50];
        [InDataSet]
        AdditionalLine: Text;
}

