page 50207 "Pending Purch Req. Header"
{
    // version Requisition
    CaptionML = ENU = 'Pending Purch Req. Header';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SourceTable = "Requisition Header";
    SourceTableView = SORTING ("Requisition No.") ORDER(Ascending) WHERE ("Requisition Type" = FILTER ("Manual Requisition"));

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
                field("Rejection Remarks"; "Rejection Remarks")
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
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // Lines added by Deepak Kumar
                        UserSetup.RESET;
                        IF UserSetup.GET(USERID) THEN BEGIN
                            IF UserSetup."Manual Requisition Approval" THEN BEGIN
                                Status := Status::Approved;
                                "Approved By" := USERID;
                                MODIFY;
                            END ELSE
                                ERROR('You do not have permission to approve, Kindly contact system administrator');
                        END;
                        MESSAGE('The Requistion %1 has been successfully approved', "Requisition No.");
                        CurrPage.UPDATE();
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        IF UserSetup.GET(USERID) THEN BEGIN
                            IF UserSetup."Manual Requisition Approval" THEN BEGIN
                                TESTFIELD("Rejection Remarks");
                                Status := Status::Rejected;
                                MODIFY;
                            END ELSE
                                ERROR('You do not have permission to Reject the requisition, Kindly contact system administrator');
                        END;
                        MESSAGE('The Requistion %1 has been successfully Rejected', "Requisition No.");
                        CurrPage.UPDATE();
                    end;
                }
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN
            IF NOT UserSetup."Manual Requisition Creation" THEN
                ERROR('You do not have permission to create requisition');
    end;

    var
        MatReq: Report "Material Req";
        RequisitionHeader: Record "Requisition Header";
        [InDataSet]
        StatusOpen: Boolean;
        UserSetup: Record "User Setup";
}

