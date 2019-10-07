page 50155 "Sub Form Deckle"
{
    // version Prod. Schedule

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Schedule Base Table 1";
    SourceTableView = SORTING ("No Of Job(Internal)")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Deckle Size"; "Deckle Size")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("No. of Jobs(Within Trimlimit)"; "No. of Jobs(Within Trimlimit)")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("No. of Jobs(Outside TrimLimit)"; "No. of Jobs(Outside TrimLimit)")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Marked for Publish"; "Marked for Publish")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Force Marked for Publish"; "Force Marked for Publish")
                {
                }
                field("No. of Flute Change"; "No. of Flute Change")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Priority by System"; "Priority by System")
                {
                    StyleExpr = SetStyleFormat;
                }
                field("Select for Publish"; "Select for Publish")
                {
                    StyleExpr = SetStyleFormat;

                    trigger OnValidate()
                    begin
                        // Lines aded BY Deepak Kumar
                        DeckleMaster.Reset;
                        DeckleMaster.SetRange(DeckleMaster."Schedule No.", "Schedule No.");
                        DeckleMaster.SetFilter(DeckleMaster."Deckle Size", '<>%1', "Deckle Size");
                        if DeckleMaster.FindFirst then begin
                            repeat
                                DeckleMaster."Select for Publish" := false;
                                DeckleMaster.Modify(true);
                            until DeckleMaster.Next = 0;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Roll Detail")
            {
                RunObject = Page "Roll Details for Prod. Scdule";
                //RunPageLink = "Deckle Size (mm)"=FIELD(FORMAT("Deckle Size"));
                RunPageView = SORTING (Code)
                              ORDER(Ascending);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Lines added BY Deepak Kumar
        SetStyleFormat := SetStyle;
    end;

    var
        SetStyleFormat: Text;
        DeckleMaster: Record "Schedule Base Table 1";

    procedure SetStyle(): Text
    begin
        // Lines added By Deepak Kumar
        if "Priority by System" = 1 then begin
            exit('Favorable');
        end;
        /*
        EXIT('Unfavorable');
        EXIT('StandardAccent');
        EXIT('Favorable');
         */

    end;
}

