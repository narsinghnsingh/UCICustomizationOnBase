page 50174 "Scheduler Consumption Entry"
{
    // version Requisition

    InsertAllowed = false;
    PageType = Worksheet;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Con. Item Selection 1";
    //SourceTableView = SORTING(Field50000,Req. Line Number,Field50010) ORDER(Ascending);

    layout
    {
        area(content)
        {
            field(RequisitionNo; RequisitionNo)
            {
                Caption = 'Requisition No.';
                TableRelation = "Requisition Header"."Requisition No." WHERE (Status = CONST (Released), "Requisition Type" = CONST ("Production Schedule"));
            }
            group(Control13)
            {
                ShowCaption = false;
                repeater(Group)
                {
                    field("Document No."; "Document No.")
                    { }
                    // field("Item Code";"Item Code")
                    // {
                    //     StyleExpr = AdditionalLine;
                    // }
                    // field("Roll ID";"Roll ID")
                    // {
                    //     StyleExpr = AdditionalLine;
                    // }
                    // field("Item Description";"Item Description")
                    // {
                    //     StyleExpr = AdditionalLine;
                    // }
                    // field("Initial Roll Weight";"Initial Roll Weight")
                    // {
                    //     StyleExpr = AdditionalLine;
                    // }
                    // field("Paper Position";"Paper Position")
                    // {
                    //     OptionCaption = ' ,DL- Liner1,M1-Flute1,L1-Liner2,M2-Flute2,L2-Liner3';
                    //     StyleExpr = AdditionalLine;
                    // }
                    // field("Final Roll Weight";"Final Roll Weight")
                    // {
                    //     StyleExpr = AdditionalLine;
                    // }
                    // field("Quantity to Consume";"Quantity to Consume")
                    // {
                    //     StyleExpr = AdditionalLine;
                    // }
                    // field("Vendor Roll Number";"Vendor Roll Number")
                    // {
                    // }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Req. Line")
            {
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added By Deepak Kumar
                    SchedularCodeUnit.GetConsumptionLine(RequisitionNo);
                end;
            }
            action("Re-Initiate")
            {
                Caption = 'Re-Initiate';
                Image = RefreshRegister;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ConItemSelection: Record "Con. Item Selection 1";
                    ConsProdOrderSelection: Record "Cons. Prod. Order Selection";
                begin
                    ConItemSelection.RESET;
                    IF ConItemSelection.FINDSET THEN
                        ConItemSelection.DELETEALL(TRUE);

                    ConsProdOrderSelection.RESET;
                    IF ConsProdOrderSelection.FINDSET THEN
                        ConsProdOrderSelection.DELETEALL(TRUE);
                end;
            }
            action("Print Butt Roll")
            {
                Image = BarCode;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Itemvariant.RESET;
                    //Itemvariant.SETRANGE(Itemvariant."Roll ID","Roll ID");
                    RollLebel.SETTABLEVIEW(Itemvariant);
                    RollLebel.RUN;
                end;
            }
        }
    }

    var
        SchedularCodeUnit: Codeunit Scheduler;
        ConsProdOrderSelection: Record "Cons. Prod. Order Selection";
        RequisitionNo: Code[50];
        [InDataSet]
        AdditionalLine: Text;
        RollLebel: Report "Inks & Pallet Report";
        Itemvariant: Record "Con. Item Selection 1";
}

