pageextension 50049 Ext_FinishedProductionOrders extends "Finished Production Orders"
{
    layout
    {
        addafter("Starting Date")
        {
            field("Customer Name"; "Customer Name")
            {
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
                var
                    SubsCrib: Codeunit CodeunitSubscriber;
                begin
                    // Lines Added By Deepak Kumar
                    SubsCrib.UpdateFGWeight(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}