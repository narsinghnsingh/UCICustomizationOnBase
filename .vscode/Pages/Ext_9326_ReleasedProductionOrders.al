pageextension 50048 Ext_ReleasedProductionOrders extends "Released Production Orders"
{
    layout
    {
        addafter("No.")
        {
            field("Prev. Job No."; "Prev. Job No.")
            {
            }
            field("Repeat Job"; "Repeat Job")
            {
            }

        }
        addafter(Quantity)
        {
            field("Finished Quantity"; "Finished Quantity")
            {
            }
            field("Production Tolerance %"; "Production Tolerance %")
            {
            }
            field("Sales Order No."; "Sales Order No.")
            {
            }
            field("Sales Order Line No."; "Sales Order Line No.")
            {
            }
            field("Estimate Code"; "Estimate Code")
            {
            }
            field("Prod Status"; "Prod Status")
            {
            }
            field("Customer Name"; "Customer Name")
            {
            }
        }
        addafter(Control1905767507)
        {
            part(Control19; "Prod. Order ListPart")
            {
                SubPageLink = "Prod. Order No." = FIELD ("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        addafter(Statistics)
        {
            action("Update Production Weight")
            {
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()

                begin
                    // Lines Added By Deepak Kumar
                    CodeunitSub.UpdateFGWeight(Rec);
                end;
            }
            action("Consumption Journal")
            {
                Caption = 'Consumption Journal';
                Image = ConsumptionJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Consumption Journal";
            }
        }

    }

    var
        CodeunitSub: Codeunit CodeunitSubscriber;
}