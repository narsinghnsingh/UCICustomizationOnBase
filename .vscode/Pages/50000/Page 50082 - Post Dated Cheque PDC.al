page 50082 "Post Dated Cheque PDC"
{
    // version Samadhan PDC

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Post Dated Cheque PDC";
    SourceTableView = SORTING ("PDC Number")
                      ORDER(Ascending)
                      WHERE (Received = CONST (false),
                            Presented = CONST (false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PDC Number"; "PDC Number")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No"; "Account No")
                {
                }
                field(Description; Description)
                {
                }
                field("Debit Amount"; "Debit Amount")
                {
                }
                field("Credit Amount"; "Credit Amount")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                }
                field("Cheque Bank Name"; "Cheque Bank Name")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Currency Code"; "Currency Code")
                {
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
                field(Month; Month)
                {
                }
                field(Narration; Narration)
                {
                }
                field("Amount LCY"; "Amount LCY")
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
                action("PDC Post to Receivable")
                {
                    Caption = 'PDC Post to Receivable';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        // Lines added by deepak Kumar
                        PostRecipt("PDC Number");
                    end;
                }
                separator(Separator26)
                {
                }
                action("Received Cheque")
                {
                    Caption = 'Received Cheque';
                    Image = PostedDeposit;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunPageMode = Edit;
                    PromotedIsBig = true;
                    RunObject = Page "Received PDC";
                }
                action(History)
                {
                    Caption = 'History';
                    Image = History;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "History PDC";
                    RunPageView = SORTING ("PDC Number")
                                  ORDER(Ascending)
                                  WHERE (Presented = CONST (true));
                }
                action("Cancaled Cheque")
                {
                    Caption = 'Cancaled Cheque';
                    Image = History;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "History PDC";
                    RunPageView = SORTING ("PDC Number")
                                  WHERE ("Void Cheque" = CONST (true));
                }
            }
        }
    }
}

