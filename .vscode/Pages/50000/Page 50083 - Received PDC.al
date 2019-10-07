page 50083 "Received PDC"
{
    // version Samadhan PDC

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Post Dated Cheque PDC";
    SourceTableView = SORTING ("Cheque Date")
                      ORDER(Ascending)
                      WHERE (Received = CONST (true),
                            Presented = CONST (false),
                            "Void Cheque" = CONST (false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Month; Month)
                {
                }
                field("PDC Number"; "PDC Number")
                {
                }
                field("Account Type"; "Account Type")
                {
                    Editable = false;
                }
                field("Account No"; "Account No")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Cheque No"; "Cheque No")
                {
                    Editable = false;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Editable = true;
                }
                field("Cheque Bank Name"; "Cheque Bank Name")
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = false;
                }
                field("Currency Factor"; "Currency Factor")
                {
                }
                field("Presented Bank"; "Presented Bank")
                {
                }
                field("Presented Bank Name"; "Presented Bank Name")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field(Received; Received)
                {
                }
                field(Presented; Presented)
                {
                }
                field("Void Cheque"; "Void Cheque")
                {
                }
                field(Narration; Narration)
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
                action("PDC Post to Bank")
                {
                    Caption = 'PDC Post to Bank';
                    Image = PostApplication;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Answer: Boolean;
                    begin
                        // Lines added by deepak Kumar
                        Answer := Confirm('Do you want to post PDC');
                        if Answer = true then begin
                            PostReciptBank("PDC Number");
                        end else begin
                            Message('Cancalled');
                        end;
                    end;
                }
                action("PDC Payment Voucher")
                {
                    Image = Print;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        PDC.Reset;
                        PDC.SetRange(PDC."PDC Number", "PDC Number");
                        PDC.SetRange(PDC."Posting Date", "Posting Date");
                        REPORT.RunModal(REPORT::"PDC Receipt/Payment", true, true, PDC);
                    end;
                }
                action("Void PDC Cheque")
                {
                    Caption = 'Void PDC Cheque';
                    Image = VoidCheck;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Answer: Boolean;
                    begin
                        // Lines added bY Deepak Kumar
                        Answer := Confirm('Do you want to post Void Cheque');
                        if Answer = true then begin
                            VoidCheque("PDC Number");
                        end else begin
                            Message('Cancalled');
                        end;
                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc("Posting Date", "PDC Number");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        PDC: Record "Post Dated Cheque PDC";
}

