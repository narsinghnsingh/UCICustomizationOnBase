page 50111 "Posted Inspection Card"
{
    // version Samadhan Quality

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Inspection Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE(Posted=CONST(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                }
                field("Job No.";"Job No.")
                {
                }
                field("Job Line No.";"Job Line No.")
                {
                }
                group(Control21)
                {
                    ShowCaption = false;
                    field("Paper Type";"Paper Type")
                    {
                    }
                    field("Paper GSM";"Paper GSM")
                    {
                    }
                }
                group(Control22)
                {
                    ShowCaption = false;
                    field("Item No.";"Item No.")
                    {
                    }
                    field("Item Description";"Item Description")
                    {
                    }
                    field(Posted;Posted)
                    {
                    }
                    field(Remarks;Remarks)
                    {
                    }
                }
            }
            part(Control11;"Posted Inspection Line")
            {
                SubPageLink = "Inspection Receipt No."=FIELD("No."),
                              "Source Type"=CONST(Output),
                              "Source Document No."=FIELD("Job No."),
                              "Source Line No."=FIELD("Job Line No.");
                SubPageView = SORTING("Inspection Receipt No.","Item No.","QA Characteristic Code")
                              ORDER(Ascending);
            }
            group(Control16)
            {
                ShowCaption = false;
                field("Vendor No.";"Vendor No.")
                {
                }
                field("Vendor Name";"Vendor Name")
                {
                }
                field(Sample;Sample)
                {
                }
                field("Sample Remarks";"Sample Remarks")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup12)
            {
                action("COA Report for FG Inspection")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                            PostedInspectionSheet.Reset;
                            PostedInspectionSheet.SetCurrentKey("No.");
                            PostedInspectionSheet.SetRange(PostedInspectionSheet."No.","No.");
                            if PostedInspectionSheet.FindFirst then
                               REPORT.RunModal(REPORT::"QualityTest Before",true,false,PostedInspectionSheet);
                    end;
                }
            }
        }
    }

    var
        PostedInspectionSheet: Record "Inspection Header";
        PISh: Record "Posted Inspection Sheet";
}

