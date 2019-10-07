pageextension 50001 Ext_16_ChartOfAccounts extends "Chart of Accounts"
{

    layout
    {

        // Add changes to page layout here
        addlast(Control1)
        {
            field(Blocked; Blocked)
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast("A&ccount")
        {
            action("Machine Cost Matrix")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Machine Cost Matrix';
                RunObject = Page 50197;
                RunPageView = SORTING ("No.", "Machine No.") ORDER(Ascending);
                RunPageLink = "No." = FIELD ("No.");
                Promoted = true;
                Image = MachineCenterLoad;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
            action("Inventory - G/L Reconciliation")
            {
                ApplicationArea = All;
                RunObject = Page 5845;
                Image = List;
                trigger OnAction()
                begin

                end;
            }

            /*
                        action("Update Short Closed")
                        {
                            trigger OnAction()
                            var
                                SalesHeader: Record "Sales Header";
                                salesLine: Record "Sales Line";
                            begin
                                SalesHeader.Reset();
                                SalesHeader.SetFilter("No.", '%1|%2', 'SO/19/01540', 'SO/18/01692');
                                IF SalesHeader.FindSet() then
                                    repeat
                                        salesLine.Reset();
                                        salesLine.SetRange("Document Type", SalesHeader."Document Type");
                                        salesLine.SetRange("Document No.", SalesHeader."No.");
                                        //salesLine.SetRange("Short Closed Document", true);
                                        IF salesLine.FindSet() then
                                            repeat
                                                salesLine."Outstanding Quantity" := salesLine."Short Closed Quantity";
                                                salesLine."Outstanding Amount" := salesLine."Short Closed Amount";
                                                salesLine."Outstanding Amount (LCY)" := salesLine."Short Closed Amount (LCY)";
                                                salesLine."Short Closed Quantity" := 0;
                                                salesLine."Short Closed Amount" := 0;
                                                salesLine."Short Closed Document" := FALSE;
                                                salesLine."Short Closed Amount (LCY)" := 0;
                                                salesLine.Modify();
                                            until salesLine.Next = 0;
                                    until SalesHeader.Next = 0;
                                Message('Done');
                            end;
                        }
                        action("Update FSC Category")
                        {
                            trigger OnAction()
                            var
                                UPGRec: Record "UPG Purch. Rcpt. Line";
                                ActualRec: Record "Purch. Rcpt. Line";
                            begin
                                IF UPGRec.FINDSET THEN
                                    REPEAT
                                        ActualRec.Get(UPGRec."Document No.", UPGRec."Line No.");
                                        ActualRec."FSC Category" := UPGRec."FSC Category";
                                        ActualRec.Modify();
                                    UNTIL UPGRec.NEXT = 0;
                                Message('Done');
                            end;
                        }
                        action("Update FSC Cat PIL")
                        {
                            trigger OnAction()
                            var
                                UPGRec: Record "UPG Purch. Inv. Line";
                                ActualRec: Record "Purch. Inv. Line";
                            begin
                                IF UPGRec.FINDSET THEN
                                    REPEAT
                                        ActualRec.Get(UPGRec."Document No.", UPGRec."Line No.");
                                        ActualRec."FSC Category" := UPGRec."FSC Category";
                                        ActualRec.Modify();
                                    UNTIL UPGRec.NEXT = 0;
                                Message('Done');
                            end;
                        }

                        action("Update Daily Att")
                        {
                            trigger OnAction()
                            var
                                DailyAttendance: Record "Daily Attendance";
                            begin
                                DailyAttendance.Reset;
                                DailyAttendance.SetRange(Year, 2019);
                                DailyAttendance.SetRange(Month, 6);
                                DailyAttendance.SetRange(Holiday, 1);
                                DailyAttendance.SetRange("Non-Working", true);
                                if DailyAttendance.Find('-') then Begin
                                    Repeat
                                        DailyAttendance."Non-Working Type" := 1;
                                        DailyAttendance.Modify;
                                    until DailyAttendance.Next = 0;
                                    Message('Updated');
                                end;
                            end;
                        }
            */
        }
    }

}