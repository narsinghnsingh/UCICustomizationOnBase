page 50148 "Purchase Requisition Header"
{
    // version Requisition

    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Requisition Header";
    SourceTableView = SORTING ("Requisition No.")
                      ORDER(Ascending)
                      WHERE ("Requisition Type" = FILTER ("Manual Requisition"));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Requisition Type"; "Requisition Type")
                {
                }
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Requisition Date"; "Requisition Date")
                {
                }
                field("Ref. Document Number"; "Ref. Document Number")
                {
                }
                field(Status; Status)
                {
                }
                field("Marked Purchase Requisition"; "Marked Purchase Requisition")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
            }
            part("Requisition Line"; "Purchase Requisition Subform")
            {
                Editable = StatusOpen;
                SubPageLink = "Requisition No." = FIELD ("Requisition No.");
            }
            group(Log)
            {
                field("User ID"; "User ID")
                {
                }
                field("Short Closed"; "Short Closed")
                {
                }
                field("Short Closed by"; "Short Closed by")
                {
                }
                field("Requisition Remarks"; "Requisition Remarks")
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
                action("Short Close Requisition")
                {
                    Caption = 'Short Close Requisition';
                    Image = CancelIndent;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // Lines added by Deepak Kumar
                        ShortCloseRequisition("Requisition No.");
                    end;
                }
                action("Release Requisition for Issue")
                {
                    Caption = 'Release Requisition for Issue';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Lines added BY Deepak kumar
                        TESTFIELD("Shortcut Dimension 1 Code");
                        //TESTFIELD(Status, Status::Approved);
                        ReleaseRequisition;
                    end;
                }
            }
            action("Update Purchase Requisition")
            {
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added bY Deepak Kumar
                    IF Status = Status::Approved THEN
                        MarkforPurchase
                    ELSE
                        ERROR('Status must be approved first');
                end;
            }
            action("Send for Approval")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF Status = Status::Open THEN BEGIN
                        Status := Status::"Pending for Approval";
                        MODIFY;
                    END;
                end;
            }
        }
        area(reporting)
        {
            action("Other Prod. Material Req.")
            {
                Caption = 'Print Requisition';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    RequisitionHeader.RESET;
                    RequisitionHeader.SETRANGE(RequisitionHeader."Requisition No.", "Requisition No.");
                    IF RequisitionHeader.FINDFIRST THEN;

                    REPORT.RUNMODAL(50046, TRUE, FALSE, RequisitionHeader);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ByProdSchedule: Boolean;
        ByProdOrder: Boolean;
    begin
        // Lines added By Deepak Kumar
        IF Status = Status::Open THEN
            StatusOpen := TRUE
        ELSE
            StatusOpen := FALSE;
    end;

    trigger OnAfterGetCurrRecord()
    var
        ByProdSchedule: Boolean;
        ByProdOrder: Boolean;
    begin
        // Lines added By Deepak Kumar
        IF Status = Status::Open THEN
            StatusOpen := TRUE
        ELSE
            StatusOpen := FALSE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN
            IF NOT UserSetup."Manual Requisition Creation" THEN
                ERROR('You do not have permission to create requisition');
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF Status = Status::Approved THEN
            ERROR('You can not Modify Requisition No. %1 it is already approved', "Requisition No.");
    end;

    var

        RequisitionHeader: Record "Requisition Header";
        [InDataSet]
        StatusOpen: Boolean;
        UserSetup: Record "User Setup";
        PrintEnabled: Boolean;
}