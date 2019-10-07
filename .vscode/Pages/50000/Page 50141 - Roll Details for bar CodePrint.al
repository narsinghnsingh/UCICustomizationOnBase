page 50141 "Roll Details for bar CodePrint"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Item Variant";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Status; Status)
                {
                }
                field("Paper Type"; "Paper Type")
                {
                }
                field("Paper GSM"; "Paper GSM")
                {
                }
                field("Deckle Size (mm)"; "Deckle Size (mm)")
                {
                }
                field("MILL Reel No."; "MILL Reel No.")
                {
                }
                field("Rejection Remark"; "Rejection Remark")
                {
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Roll Lebel")
            {
                Caption = 'Roll Lebel';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Lines added bY deepak Kumar
                    Itemvariant.Reset;
                    Itemvariant.SetRange(Itemvariant.Code, Code);
                    RollLebel.SetTableView(Itemvariant);
                    RollLebel.Run;
                end;
            }
            action("Reel Transaction Details")
            {
                Caption = 'Reel Transaction Details';
                Image = Translation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Ledger Entries";
                RunPageLink = "Item No." = FIELD ("Item No."),
                              "Variant Code" = FIELD (Code);
                RunPageView = SORTING ("Item No.", "Posting Date")
                              ORDER(Ascending);
            }
        }
    }

    var
        RollLebel: Report Label;
        Itemvariant: Record "Item Variant";
}

