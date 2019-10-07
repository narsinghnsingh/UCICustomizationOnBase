pageextension 50078 Ext_99000846_ConsumptionJnl extends "Consumption Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Bin Contents")
        {
            action("Get Consumption Line")
            {
                CaptionML = ENU = 'Get Consumption Line';
                Promoted = true;
                Image = GetLines;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin

                    TESTFIELD("Order Type", "Order Type"::Production);
                    TESTFIELD("Order No.");
                    ConsumeBalanceMaterial("Journal Template Name", "Journal Batch Name", "Order No.");
                    DELETE(TRUE);
                end;

            }
        }
        addafter("Post and &Print")
        {
            action("Reservation Entries")
            {
                CaptionML = ENU = '&Reservation Entries';
                Image = ReservationLedger;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Reservation Entries";
                RunPageView = SORTING ("Item No.", "Variant Code", "Location Code", "Reservation Status");
                RunPageLink = "Reservation Status" = CONST (Reservation), "Item No." = FIELD ("Item No.");
            }
        }

    }
}