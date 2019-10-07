page 50110 "Posted Inspection List"
{
    // version Samadhan Quality

    CardPageID = "Posted Inspection Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = History;
    SourceTable = "Inspection Header";
    SourceTableView = SORTING ("No.")
                      ORDER(Ascending)
                      WHERE (Posted = CONST (true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Job No."; "Job No.")
                {
                }
                field("Job Line No."; "Job Line No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field(Posted; Posted)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup9)
            {
                action("COA Report for FG Inspection")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PostedInspectionSheet.Reset;
                        PostedInspectionSheet.SetCurrentKey("No.");
                        PostedInspectionSheet.SetRange(PostedInspectionSheet."No.", "No.");
                        if PostedInspectionSheet.FindFirst then
                            REPORT.RunModal(REPORT::"QualityTest Before", true, false, PostedInspectionSheet);


                        /*
                         salesInvHeader.RESET;
                         salesInvHeader.SETCURRENTKEY("No.");
                         salesInvHeader.SETRANGE(salesInvHeader."No.");
                         IF salesInvHeader.FINDFIRST THEN
                           REPORT.RUNMODAL(REPORT::"Quality Test",TRUE,FALSE,salesInvHeader);
                        */

                    end;
                }
                action("Sample Paper Test Report")
                {
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageOnRec = true;

                    trigger OnAction()
                    begin
                        inspectionHeader.Reset;
                        inspectionHeader.SetCurrentKey(inspectionHeader."Inspection Receipt No.");
                        inspectionHeader.SetRange(inspectionHeader."Inspection Receipt No.", "No.");
                        if inspectionHeader.FindFirst then
                            REPORT.RunModal(REPORT::"Sample Paper Test Report", true, true, inspectionHeader);
                    end;
                }
            }
        }
    }

    var
        PostedInspectionSheet: Record "Inspection Header";
        salesInvHeader: Record "Sales Invoice Header";
        PostedInspection: Record "Posted Inspection Sheet";
        inspectionHeader: Record "Posted Inspection Sheet";
}

