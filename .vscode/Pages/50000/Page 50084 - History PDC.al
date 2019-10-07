page 50084 "History PDC"
{
    // version Samadhan PDC

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    Permissions = TableData "G/L Entry" = rm;
    SourceTable = "Post Dated Cheque PDC";
    SourceTableView = SORTING ("Cheque Date")
                      ORDER(Ascending);

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
                    Editable = false;
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
            }
        }
    }

    actions
    {
        area(creation)
        {
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
                    Navigate.SetDoc("Cheque Date", "PDC Number");
                    Navigate.Run;
                end;
            }
            action("Line Mark For Reversal")
            {
                Caption = 'Line Mark For Reversal';
                Image = MoveUp;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GenJnlPostLine.UpdateJournalLineforReverse("PDC Number"
                    );
                end;
            }
        }
    }

    var
        GenJnlPostLine: Codeunit CodeunitSubscriber;
}

