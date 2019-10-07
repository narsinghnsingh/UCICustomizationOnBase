page 50086 "Schedule Requisition Header"
{
    // version Requisition

    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approval,Activity,Related Information,Extra Lines,Short Closure';
    RefreshOnActivate = true;
    SourceTable = "Requisition Header";
    SourceTableView = SORTING("Requisition No.")
                      ORDER(Ascending)
                      WHERE("Requisition Type"=FILTER("Production Order"|"Production Schedule"));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Requisition Type";"Requisition Type")
                {
                }
                field("Requisition No.";"Requisition No.")
                {
                }
                field("Requisition Date";"Requisition Date")
                {
                }
                field("Schedule Document No.";"Schedule Document No.")
                {

                    trigger OnValidate()
                    begin
                        ProductionSchedule.Reset;
                        ProductionSchedule.SetRange(ProductionSchedule."Schedule No.","Schedule Document No.");
                        if ProductionSchedule.FindFirst then begin
                          Shift_Code := ProductionSchedule."Shift Code";
                        end;
                    end;
                }
                field("Shift Code";Shift_Code)
                {
                    Editable = false;
                }
                field("Ref. Document Number";"Ref. Document Number")
                {
                }
                field(Status;Status)
                {
                }
                field(Description;Description)
                {
                }
            }
            part("Requisition Line";"Schedule Requisition Subform")
            {
                SubPageLink = "Requisition No."=FIELD("Requisition No."),
                              "Extra Material"=CONST(false);
            }
            part(RequisitionLineExtra;"Schedule Requisition Subform")
            {
                Caption = 'Extra Requisition Line';
                ShowFilter = false;
                SubPageLink = "Requisition No."=FIELD("Requisition No."),
                              "Extra Material"=CONST(true);
            }
            group(Log)
            {
                field("User ID";"User ID")
                {
                }
                field("Short Closed";"Short Closed")
                {
                }
                field("Short Closed by";"Short Closed by")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Action")
            {
                Caption = 'Action';
                Image = "Order";
            }
            action("Get Component Line")
            {
                Caption = 'Get Component Line';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+Ctrl+D';
                Visible = false;

                trigger OnAction()
                begin
                    // Lines added by deepak Kumar
                    GetBOMItemLine("Prod. Order No","Prod. Order Line No.","Requisition No.");
                end;
            }
            action("Short Close Requisition")
            {
                Caption = 'Short Close Requisition';
                Image = CancelIndent;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    ShortCloseRequisition("Requisition No.");
                end;
            }
            action("Get Schedule Order Item")
            {
                Caption = 'Get Schedule Order Item';
                Image = ChangeDimensions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added BY Deepak kumar
                    TestField("Schedule Document No.");
                    GetScheduleItem("Schedule Document No.","Requisition No.");
                end;
            }
            action("Approve By Store")
            {
                Caption = 'Approve By Store';
                Image = Default;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    ApprovebyStore("Requisition No.");
                end;
            }
            action("Approve By Production")
            {
                Caption = 'Approve By Production';
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added by Deepak Kumar
                    ApprovebyProduction("Requisition No.");
                end;
            }
            action("Paper Material Requisition")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RequisitionHeader.Reset;
                    RequisitionHeader.SetRange(RequisitionHeader."Requisition No.","Requisition No.");
                    if  RequisitionHeader.FindFirst   then  ;

                    REPORT.RunModal(50004,true,false,RequisitionHeader);
                end;
            }
            action("Material Issue")
            {
                Caption = 'Material Issue';
                Image = TransferToLines;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Material Transfer";
                RunPageLink = "Requisition No."=FIELD("Requisition No.");
            }
            action("Prod. Scheduler Consumption")
            {
                Caption = 'Prod. Scheduler Consumption';
                Image = ConsumptionJournal;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Prod. Scheduler Consumption";
            }
            action("Material Return to Store")
            {
                Caption = 'Material Return to Store';
                Image = TransferToLines;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Material Return to Store";
            }
            action("Posted Transfers")
            {
                Caption = 'Posted Transfers';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                RunObject = Page "Item Ledger Entries";
                RunPageLink = "Requisition No."=FIELD("Requisition No."),
                              "Entry Type"=FILTER(Transfer),
                              Positive=CONST(true);
                RunPageView = SORTING("Item No.","Posting Date")
                              ORDER(Ascending);
            }
            action("Extra Lines")
            {
                Caption = 'Extra Lines';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Extra Material";
                RunPageLink = "Requisition No."=FIELD("Requisition No.");
                RunPageView = SORTING("Requisition No.","Requisition Line No.")
                              ORDER(Ascending);
            }
            action("Schedule Lines")
            {
                Caption = 'Schedule Lines';
                Image = CalendarWorkcenter;
                Promoted = true;
                PromotedCategory = Category6;
                RunObject = Page "Corr. Schedule Published";
                RunPageLink = "Schedule No."=FIELD("Schedule Document No."),
                              Published=CONST(true);
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Lines added By Deepak Kumar
        "Requisition Type":="Requisition Type"::"Production Schedule";
    end;

    var
        MatReq: Report "Material Req";
        RequisitionHeader: Record "Requisition Header";
        ProductionSchedule: Record "Production Schedule";
        Shift_Code: Code[20];
}

