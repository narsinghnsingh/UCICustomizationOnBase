page 50206 "Pending Purch. Requistion List"
{
    CaptionML = ENU = 'Pending Purch. Requistion List';
    CardPageID = "Pending Purch Req. Header";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Tasks;
    SourceTable = "Requisition Header";
    SourceTableView = SORTING ("Requisition Type", "Requisition No.") ORDER(Ascending) WHERE ("Requisition Type" = FILTER ("Manual Requisition"), Status = CONST ("Pending for Approval"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Requisition Date"; "Requisition Date")
                {
                }
                field("Requisition Type"; "Requisition Type")
                {
                }
                field("Requisition Quantity"; "Requisition Quantity")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field(Status; Status)
                {
                }
                field("Marked Purchase Requisition"; "Marked Purchase Requisition")
                {
                }
                field("Mark for Purchase"; "Mark for Purchase")
                {
                }
                field("Extra Material"; "Extra Material")
                {
                }
                field("Extra Material Approved"; "Extra Material Approved")
                {
                }
                field("Extra Material App. By"; "Extra Material App. By")
                {
                }
                field("Extra Material App. Date"; "Extra Material App. Date")
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

    var
        UserSetup: Record "User Setup";
}

