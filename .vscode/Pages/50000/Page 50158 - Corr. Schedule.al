page 50158 "Corr. Schedule"
{
    // version Prod. Schedule

    DeleteAllowed = false;
    InsertAllowed = false;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Production Schedule";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field("Total Linear Capacity";"Total Linear Capacity")
                {
                }
                field("Linear Cap.Marked for Publish";"Linear Cap.Marked for Publish")
                {
                }
                field("Linear Capacity Published";"Linear Capacity Published")
                {
                }
                group(Control18)
                {
                    ShowCaption = false;
                }
                field("Update Existing Schedule";"Update Existing Schedule")
                {
                }
                field("Existing Schedule No.";"Existing Schedule No.")
                {
                }
                grid(Control29)
                {
                    ShowCaption = false;
                    group(Control24)
                    {
                        ShowCaption = false;
                        Visible = ByDeckleSize;
                        part(Deckle;"Sub Form Deckle")
                        {
                            CaptionML = ENU = 'Deckle';
                            ShowFilter = false;
                            SubPageLink = "Schedule No."=FIELD("Schedule No.");
                            SubPageView = SORTING("Schedule No.","Deckle Size")
                                          ORDER(Ascending);
                            UpdatePropagation = Both;
                        }
                    }
                    group(Control21)
                    {
                        ShowCaption = false;
                        Visible = ByDeckleSize;
                        part("Paper Type";"Sub Form Paper Type")
                        {
                            CaptionML = ENU = 'Paper Type Requiremet View';
                            Provider = Deckle;
                            ShowFilter = false;
                            SubPageLink = "Schedule No."=FIELD("Schedule No."),
                                          "Deckle Size"=FIELD("Deckle Size");
                            SubPageView = SORTING("Schedule No.","Deckle Size","Paper Type")
                                          ORDER(Ascending);
                        }
                    }
                    group(Control25)
                    {
                        ShowCaption = false;
                        Visible = ByDeckleSize;
                        part("Paper GSM";"Sub Form Paper GSM")
                        {
                            CaptionML = ENU = 'Paper GSM Requirement View';
                            Provider = "Paper Type";
                            ShowFilter = false;
                            SubPageLink = "Schedule No."=FIELD("Schedule No."),
                                          "Deckle Size"=FIELD("Deckle Size"),
                                          "Paper Type"=FIELD("Paper Type");
                            SubPageView = SORTING("Schedule No.","Deckle Size","Paper Type","Paper GSM")
                                          ORDER(Ascending);
                        }
                    }
                }
            }
            group(Control26)
            {
                ShowCaption = false;
                Visible = ByDeckleSize;
                group(Control31)
                {
                    ShowCaption = false;
                    part("Job Possible";"Corr Schedule Sub Page")
                    {
                        CaptionML = ENU = 'Job Possible';
                        Provider = Deckle;
                        ShowFilter = false;
                        SubPageLink = "Schedule No."=FIELD("Schedule No."),
                                      "Deckle Size Schedule(mm)"=FIELD("Deckle Size");
                        SubPageView = SORTING("Schedule No.","No. Of Ply",Flute,"GSM Identifier")
                                      ORDER(Ascending)
                                      WHERE(Possible=CONST(true));
                    }
                }
                group(Control34)
                {
                    ShowCaption = false;
                    part("Job Out Of Range";"Corr Schedule Sub Page")
                    {
                        CaptionML = ENU = 'Job Out Of Range';
                        Provider = Deckle;
                        ShowFilter = false;
                        SubPageLink = "Schedule No."=FIELD("Schedule No."),
                                      "Deckle Size Schedule(mm)"=FIELD("Deckle Size");
                        SubPageView = SORTING("Schedule No.","No. Of Ply",Flute,"GSM Identifier")
                                      ORDER(Ascending)
                                      WHERE(Possible=CONST(false));
                    }
                }
            }
            part(Job;"Corr Schedule Sub Page")
            {
                CaptionML = ENU = 'Job';
                ShowFilter = false;
                SubPageLink = "Schedule No."=FIELD("Schedule No.");
                SubPageView = SORTING("Schedule No.","No. Of Ply",Flute,"GSM Identifier")
                              ORDER(Ascending);
                Visible = false;
            }
            part("Job Marked for Publish";"Corr Schedule Sub Page")
            {
                CaptionML = ENU = 'Job Marked for Publish';
                Provider = Deckle;
                ShowFilter = false;
                SubPageLink = "Schedule No."=FIELD("Schedule No.");
                SubPageView = SORTING("Schedule No.","No. Of Ply",Flute,"GSM Identifier")
                              ORDER(Ascending)
                              WHERE("Marked for Publication"=CONST(true));
                Visible = ManualAssortment;
            }
            part("Total Paper Requirment";"Update Paper in Schedule")
            {
                CaptionML = ENU = 'Total Paper Requirement';
                ShowFilter = false;
                SubPageLink = "Schedule No."=FIELD("Schedule No.");
                SubPageView = SORTING("Schedule No.","Deckle Size","Paper Type","Paper GSM")
                              ORDER(Ascending)
                              WHERE("Total Requirement (kg)"=FILTER(<>0));
                Visible = ManualAssortment;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Lines")
            {
                CaptionML = ENU = 'Calculate Lines';
                Visible = false;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    Scheduler.CreateBaseData(Rec);
                end;
            }
            action("Calculate Deckle")
            {
                CaptionML = ENU = 'Calculate Deckle';
                Visible = false;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    Scheduler.CreateDeckleLine(Rec);
                    Scheduler.CalculateJobLines(Rec);

                    Scheduler.CreateTypeGSM(Rec);
                    Scheduler.PriorityTheDeckle(Rec);
                    Scheduler.UpdateFluteChnage(Rec);
                    Message('Calulated');
                end;
            }
            action("Calculate Job")
            {
                Visible = false;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    Scheduler.CalculateJobLines(Rec);
                end;
            }
            action("Publish Schedule")
            {
                Image = Production;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Lines aadded BY Deepak Kumar

                    // Lines aupdated on 0806 16//Deepak
                    if "Update Existing Schedule" then begin
                      Scheduler.UpdateExistingSchedule(Rec);
                    end else begin
                        if "Manual Assortment" = true then begin
                           Scheduler.PublishSchedule(Rec);
                        end else begin
                          Scheduler.CreateTypeGSM(Rec);
                          Scheduler.PublishSchedule(Rec);
                        end;
                    end;
                    CurrPage.Close;
                end;
            }
            action("Manual Assortment")
            {
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    Scheduler.ManualAssortment(Rec);
                    Scheduler.CreateTypeGSM(Rec);
                end;
            }
            action("Update Quantity Requirement")
            {
                Image = UpdateShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines aded By Deepak Kumar
                    if "Manual Assortment" = true then
                      Scheduler.GenerateQtyLineMannualAsortment(Rec)
                    else
                      Scheduler.CreateTypeGSM(Rec);
                end;
            }
            action("Update Ideal Size ")
            {

                trigger OnAction()
                begin
                    Scheduler.CalculateIdealDeckleSize(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        // Lines added By Deepak Kumar
        if "Manual Assortment" then begin
          ManualAssortment:=true;
          ByDeckleSize:=false;
        end else begin
          ManualAssortment:=false;
          ByDeckleSize:=true;
         end;
    end;

    trigger OnAfterGetRecord()
    begin
        // Lines added By Deepak Kumar
        if "Manual Assortment" then begin
          ManualAssortment:=true;
          ByDeckleSize:=false;
        end else begin
          ManualAssortment:=false;
          ByDeckleSize:=true;
        end;
    end;

    var
        Scheduler: Codeunit Scheduler;
        [InDataSet]
        ManualAssortment: Boolean;
        [InDataSet]
        ByDeckleSize: Boolean;
}

