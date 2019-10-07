page 50152 "Corr. Schedule Card"
{
    // version Prod. Schedule

    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Production Schedule";
    SourceTableView = SORTING ("Schedule No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                grid(Control16)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group(Control21)
                    {
                        ShowCaption = false;
                        field("Schedule Date"; "Schedule Date")
                        {
                        }
                        field(Status; Status)
                        {
                            Editable = false;
                        }
                        field("Shift Code"; "Shift Code")
                        {
                            Editable = OpenSchedule;
                        }
                        field("Total Avail Time(Min/Shift)"; "Total Avail Time(Min/Shift)")
                        {
                            Caption = 'Min/Shift';
                        }
                        field("Machine No."; "Machine No.")
                        {
                            Editable = OpenSchedule;
                        }
                        field("Machine Name"; "Machine Name")
                        {
                            Caption = 'Machine Name                                     .';
                        }
                        field("Machine Max Deckle Size"; "Machine Max Deckle Size")
                        {
                            Caption = 'MC Deckle Size';
                        }
                        field("Machine Max Ups"; "Machine Max Ups")
                        {
                            Caption = 'MC Ups';
                        }
                        field("Avg. Machine Speed Per Min"; "Avg. Machine Speed Per Min")
                        {
                            Caption = 'MC Speed/Min';
                            Editable = OpenSchedule;
                        }
                        field("Total Linear Capacity"; "Total Linear Capacity")
                        {
                        }
                        field("Linear Cap.Marked for Publish"; "Linear Cap.Marked for Publish")
                        {
                        }
                        field("Trim Calculation Type"; "Trim Calculation Type")
                        {
                        }
                        field("Min Trim"; "Min Trim")
                        {
                        }
                        field("Maximum Extra Trim"; "Maximum Extra Trim")
                        {
                            Caption = 'Max Trim';
                            Editable = false;
                        }
                        field("Manual Assortment1"; "Manual Assortment")
                        {
                            Editable = false;
                        }
                    }
                    group(Control42)
                    {
                        ShowCaption = false;
                        field("Update Existing Schedule"; "Update Existing Schedule")
                        {
                            Visible = "Update Existing Schedule";
                        }
                        field("Existing Schedule No."; "Existing Schedule No.")
                        {
                            Visible = "Update Existing Schedule";
                        }
                    }
                }
            }
            part("Corr. Schedule All Job"; "Corr. Schedule All Job")
            {
                Caption = 'Corr. Schedule All Job';
                ShowFilter = false;
                Editable = true;
                SubPageLink = "Schedule No." = FIELD ("Schedule No."),
                              "Schedule Line" = CONST (false);
                SubPageView = SORTING ("Schedule No.", "No. Of Ply", Flute, "GSM Identifier")
                              ORDER(Ascending);
                Visible = OpenSchedule;
            }
            part("Corr. Schedule Published"; "Corr. Schedule Published")
            {
                Caption = 'Corr. Schedule Published';
                Editable = true;
                ShowFilter = false;
                SubPageLink = "Schedule No." = FIELD ("Schedule No.");
                SubPageView = SORTING ("Schedule No.", "No. Of Ply", Flute, "GSM Identifier")
                              ORDER(Ascending)
                              WHERE (Published = CONST (true));
                Visible = ConfirmedSchedule;
            }
            grid(Control33)
            {
                GridLayout = Columns;
                ShowCaption = false;
                group(Control37)
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    ShowCaption = false;
                    field("Schedule Published"; "Schedule Published")
                    {
                    }
                }
                group(Control38)
                {
                    ShowCaption = false;
                    field(LinearCapMarkedforPublish; "Linear Cap.Marked for Publish")
                    {
                        Caption = 'Linear Cap Marked for Publish';
                    }
                }
                group(Control39)
                {
                    ShowCaption = false;
                    field("Schedule Net Weight"; "Schedule Net Weight")
                    {
                    }
                }
                group(Control40)
                {
                    ShowCaption = false;
                    field("Schedule M2 Weight"; "Schedule M2 Weight")
                    {
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Lines")
            {
                Caption = 'Calculate Lines';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    TestField("Schedule Date");
                    TestField("Shift Code");
                    TestField("Machine No.");
                    TestField("Schedule Published", false);
                    TestField("Schedule Closed", false);

                    Scheduler.CreateBaseData(Rec);
                end;
            }
            action(Schedule)
            {
                Caption = 'Schedule';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    Answer: Boolean;
                begin
                    // Lines added BY Deepak Kumar
                    TestField(Status, Status::Open);
                    TestField("Schedule Published", false);
                    TestField("Schedule Closed", false);

                    if "Manual Assortment" = false then begin
                        Scheduler.CreateDeckleLine(Rec);
                        Scheduler.CalculateJobLines(Rec);
                        Scheduler.CreateTypeGSM(Rec);
                        Scheduler.PriorityTheDeckle(Rec);
                        Scheduler.UpdateFluteChnage(Rec);
                    end else begin
                        Answer := DIALOG.Confirm('Schedule %1 marked for Manual Assortment, do you want to recalculate the line ?', false, "Schedule No.");
                        if Answer = true then begin
                            "Manual Assortment" := false;
                            Scheduler.CreateDeckleLine(Rec);
                            Scheduler.CalculateJobLines(Rec);
                            Scheduler.CreateTypeGSM(Rec);
                            Scheduler.PriorityTheDeckle(Rec);
                            Scheduler.UpdateFluteChnage(Rec);

                        end;
                    end;

                    CorrScheduleTable.Reset;
                    CorrScheduleTable.SetRange(CorrScheduleTable."Schedule No.", "Schedule No.");
                    PageCorrSchedule.SetTableView(CorrScheduleTable);
                    PageCorrSchedule.Run;
                end;
            }
            action("Manual Assortment")
            {
                Caption = 'Manual Assortment';
                Image = ShowSelected;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Answer: Boolean;
                begin
                    // Lines added BY Deepak Kumar
                    TestField(Status, Status::Open);
                    TestField("Schedule Published", false);
                    TestField("Schedule Closed", false);

                    // Lines added BY Deepak Kumar
                    if "Manual Assortment" then begin
                        Answer := DIALOG.Confirm('Schedule %1 marked for Manual Assortment, do you want to recalculate the line ?', false, "Schedule No.");
                        if Answer = true then begin
                            Scheduler.ManualAssortment(Rec);
                            Scheduler.CreateTypeGSM(Rec);
                        end;
                    end else begin
                        Scheduler.ManualAssortment(Rec);
                        Scheduler.CreateTypeGSM(Rec);
                    end;

                    CorrScheduleTable.Reset;
                    CorrScheduleTable.SetRange(CorrScheduleTable."Schedule No.", "Schedule No.");
                    PageCorrSchedule.SetTableView(CorrScheduleTable);
                    PageCorrSchedule.Run;
                end;
            }
            action("XML Port for Production Schedular")
            {
                Caption = 'XML Port for Production Schedular';
                Image = XMLFile;

                trigger OnAction()
                var
                    varXmlFile: File;
                    XMLPORT1: XMLport "Export Production Schedule";
                    varOutputStream: OutStream;
                begin
                    // Lines added BY Deepak Kumar
                    varXmlFile.Create('D:\Project\UniversalCartoon\OfficeH.txt');
                    varXmlFile.CreateOutStream(varOutputStream);
                    XMLPORT.Export(XMLPORT::"Export Production Schedule", varOutputStream);
                    varXmlFile.Close;


                    // For Import Code Unit
                    /*
                    varXs
                    mlFile.OPEN(“FilePath\myXmlfile.xml”);
                    varXmlFile.CREATEINSTREAM(varInputStream);
                    XMLPORT.IMPORT(XMLPORT::XMLportName, varInputStream);
                    varXmlFile.CLOSE;
                     */

                end;
            }
            action("Post Consumption ")
            {
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Prod. Scheduler Consumption";

                trigger OnAction()
                begin
                    // Lines Added By Deepak Kumar
                end;
            }
            action("Generate CMPS Data")
            {
                Image = ExportElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by Deepak ku
                    Scheduler.GenerateCPMSData(Rec);

                    CMPSTable.Reset;
                    CMPSTable.SetRange(CMPSTable."Schedule No.", "Schedule No.");
                    CMPSPage.SetTableView(CMPSTable);
                    CMPSPage.Run;
                end;
            }
            action("Schedule Close")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added bY Deepak Kumar
                    Scheduler.FinishSchedule(Rec);
                end;
            }
            action("Schedule Print")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ConfirmSchedule: Report "Confirm Schedule";
                    ProductionScheduleLine: Record "Production Schedule Line";
                begin
                    // Lines added By Deepak Kumar
                    ProductionScheduleLine.Reset;
                    ProductionScheduleLine.SetRange(ProductionScheduleLine."Schedule No.", "Schedule No.");
                    //ProductionScheduleLine.SETRANGE(ProductionScheduleLine."Schedule Date","Schedule Date");
                    if ProductionScheduleLine.FindFirst then begin
                        ConfirmSchedule.SetTableView(ProductionScheduleLine);
                        ConfirmSchedule.Run;
                    end;

                end;
            }
            action("Remove Un Selected Line")
            {
                Caption = 'Remove Un Selected Line';
                Image = RemoveFilterLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    Scheduler.RemoveUnSelectedLine(Rec);
                end;
            }
            action("Re-Publish Component")
            {
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Scheduler.CreateProdOrderCompLine(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        // Lines added BY Deepak Kumar
        if "Schedule Published" then begin
            ConfirmedSchedule := true;
            OpenSchedule := false;
        end else begin
            ConfirmedSchedule := false;
            OpenSchedule := true;
        end;


    end;

    var
        Scheduler: Codeunit Scheduler;
        PageCorrSchedule: Page "Corr. Schedule";
        CorrScheduleTable: Record "Production Schedule";
        CMPSTable: Record "PROD. CMPS data";
        CMPSPage: Page "CMPS Data";
        [InDataSet]
        ConfirmedSchedule: Boolean;
        [InDataSet]
        OpenSchedule: Boolean;
}

