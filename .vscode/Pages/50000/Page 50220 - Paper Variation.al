page 50220 "Paper Variation"
{
    // version Prod. Variation

    CaptionML = ENU = 'Paper Variation';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Paper Variation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Production Order"; "Production Order")
                {
                }
                field("Prod. Order Line"; "Prod. Order Line")
                {
                }
                field("Paper Position"; "Paper Position")
                {
                }
                field("Planed GSM"; "Planed GSM")
                {
                }
                field("Actual Avg. GSM"; "Actual Avg. GSM")
                {
                    StyleExpr = GSMDiff;
                }
                field("Variation in GSM"; "Variation in GSM")
                {
                    StyleExpr = GSMDiff;
                }
                field("Planed Deckle Size"; "Planed Deckle Size")
                {
                }
                field("Actual Avg. Deckle Size"; "Actual Avg. Deckle Size")
                {
                    StyleExpr = DeckleDif;
                }
                field("Variation in Deckle"; "Variation in Deckle")
                {
                    StyleExpr = DeckleDif;
                }
                field("Expected Consumption Quantity"; "Expected Consumption Quantity")
                {
                }
                field("Actual Consumption Quantity"; "Actual Consumption Quantity")
                {
                    StyleExpr = ConsDiff;
                }
                field("Variation Consumption Quantity"; "Variation Consumption Quantity")
                {
                    StyleExpr = ConsDiff;
                }
            }
            // part(Control17; "Item Ledger Entries")
            // {
            //     SubPageLink = "Order No." = FIELD ("Production Order"),
            //                   "Order Line No." = FIELD ("Prod. Order Line"),
            //                   "Paper Position" = FIELD ("Paper Position");
            // }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Calculate Variation")
            {
                CaptionML = ENU = 'Calculate Variation';
                Image = Certificate;
                action(Action12)
                {
                    CaptionML = ENU = 'Calculate Variation';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // Lines adedd by Deepak Kumar

                        ProdOrder.Reset;
                        ProdOrder.SetRange(ProdOrder."No.", "Production Order");
                        if ProdOrder.FindFirst then begin
                            ProdVariationCalculation.UpdatePapervariationDetails(ProdOrder);
                        end else begin
                            Error('Production Order not available in system');
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Lines added By Deepak Kumar

        if "Variation in GSM" > 0 then
            GSMDiff := 'Unfavorable'
        else
            GSMDiff := '';

        if "Variation in Deckle" > 0 then
            DeckleDif := 'Unfavorable'
        else
            DeckleDif := '';


        if "Variation Consumption Quantity" > 0 then
            ConsDiff := 'Unfavorable'
        else
            ConsDiff := '';
    end;

    var
        ProdOrder: Record "Production Order";
        ProdVariationCalculation: Codeunit "Prod.Variation Calculation";
        GSMDiff: Text;
        ConsDiff: Text;
        DeckleDif: Text;
}

