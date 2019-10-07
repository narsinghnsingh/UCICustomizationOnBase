pageextension 50013 Ext_42_SalesOrder extends "Sales Order"
{

    layout
    {
        moveafter("Salesperson Code"; "Payment Terms Code")
        // Add changes to page layout here

        addafter("Job Queue Status")
        {
            field(Ship; Ship)
            {

            }
            field(Invoice; Invoice)
            {

            }
        }
        addafter("Due Date")
        {
            field("Due Date Calculated By Month"; "Due Date Calculated By Month")
            {

            }
            field("LC No."; "LC No.")
            {

            }
        }
        addafter(Prepayment)
        {
            group("Order Copy")
            {
                CaptionML = ENU = 'Order Copy';

                field(Picture; Picture)
                {

                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(AssemblyOrders)
        {
            action(Action51)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Update Sales Picture';
                trigger OnAction()
                var
                    SalesPicture: Record SalesOrderPicture;
                    SalesHeaderN: Record "Sales Header";
                begin
                    // Lines added By Deepak Kumar
                    SalesHeaderN.RESET;
                    SalesHeaderN.SETRANGE(SalesHeaderN."Document Type", SalesHeaderN."Document Type"::Order);
                    IF SalesHeaderN.FINDFIRST THEN BEGIN
                        REPEAT
                            SalesPicture.RESET;
                            SalesPicture.SETRANGE(SalesPicture.SalesHeadeDocNo, SalesHeaderN."No.");
                            IF SalesPicture.FINDFIRST THEN BEGIN
                                SalesPicture.CALCFIELDS(SalesPicture.Picture);
                                SalesHeaderN.Picture := SalesPicture.Picture;
                                SalesHeaderN.MODIFY(TRUE);
                            END;
                        UNTIL SalesHeaderN.NEXT = 0;
                        MESSAGE('Complete');
                    END;
                end;
            }
        }
        addafter("Send IC Sales Order")
        {
            action(Action7)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Short Close Document';
                Promoted = true;
                PromotedIsBig = true;
                Image = CancelIndent;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    //Lines added BY Deepak Kumar
                    ShortCloseDocument("Document Type", "No.");
                end;
            }
        }
        /*
        addafter(Plan)
        {
            group(RequestApproval)
            {
                CaptionML = ENU = 'Request Approval1';
                Image = SendApprovalRequest;

                action(SentForApproval)
                {
                    CaptionML = ENU = 'Send A&pproval Request1';
                    //Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    //PromotedCategory = Category9;
                    //PromotedOnly = true;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                            ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;

                }
                action(CancelforApproval)
                {
                    CaptionML = ENU = 'Cancel Approval Re&quest';
                    ToolTipML = ENU = 'ENU=Cancel the approval request.';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(RECORDID);
                    end;
                }
            }
            
    }*/
        addafter("Pick Instruction")
        {
            action("Proforma Invoice")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;
                PromotedCategory = Report;
                trigger OnAction()
                begin
                    SalesHeader.RESET;
                    SalesHeader.SETCURRENTKEY("No.");
                    SalesHeader.SETRANGE(SalesHeader."No.", "No.");
                    IF SalesHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(REPORT::"Proforma Inv", TRUE, FALSE, SalesHeader);
                end;
            }
        }
        addafter("Print Confirmation")
        {
            action(UpdateSalespersonCode)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //Firoz 28-11-15
                    SalesLine.RESET;
                    SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
                    IF SalesLine.FINDFIRST THEN BEGIN
                        REPEAT
                            SalesHeader.RESET;
                            SalesHeader.SETRANGE(SalesHeader."No.", SalesLine."Document No.");
                            //SalesHeader.SETRANGE(SalesHeader."Sell-to Customer No.",SalesLine."Sell-to Customer No.");
                            IF SalesHeader.FINDFIRST THEN BEGIN
                                SalesLine."Salesperson Code" := SalesHeader."Salesperson Code";
                                SalesLine.MODIFY(TRUE);
                            END;
                        UNTIL SalesLine.NEXT = 0;
                    END;
                    MESSAGE('Update Completed');
                end;
            }
        }
    }

    var
        UserSetup: Record "User Setup";
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        SalesLine: Record "Sales Line";

    trigger OnDeleteRecord(): Boolean
    begin
        UserSetup.CheckDeleteSalesHeader(USERID);//Anurag 03-05-2017 
    end;


    local procedure IsEditable1(): Boolean
    begin
        if Status in [Status::Released, Status::"Pending Approval", Status::"Short Closed"] then
            exit(false)
        else
            exit(true);
        exit(false);
    end;
}