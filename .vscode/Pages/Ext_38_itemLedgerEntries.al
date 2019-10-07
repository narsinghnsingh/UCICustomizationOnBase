pageextension 50012 Ext_38_ItemLedgerEntries extends "Item Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("Applies-to Entry"; "Applies-to Entry")
            {

            }
        }
        addafter("Location Code")
        {
            field("Unit of Measure Code"; "Unit of Measure Code")
            {

            }
        }
        addafter("Remaining Quantity")
        {
            field(Positive; Positive)
            {

            }
        }
        addafter("Shipped Qty. Not Returned")
        {
            field("Requisition No."; "Requisition No.")
            {

            }
            field("Requisition Line No."; "Requisition Line No.")
            {

            }
        }
        addafter("Cost Amount (Expected) (ACY)")
        {
            field("Item Category Code"; "Item Category Code")
            {

            }
            field("Standard Output Weight"; "Standard Output Weight")
            {

            }
            field("Actual Output Weight"; "Actual Output Weight")
            {

            }
        }
        addafter("Cost Amount (Non-Invtbl.)(ACY)")
        {
            field("Paper Type"; "Paper Type")
            {

            }
            field("Paper GSM"; "Paper GSM")
            {

            }
            field("Deckle Size (mm)"; "Deckle Size (mm)")
            {

            }
            field("Old Production Order No."; "Old Production Order No.")
            {

            }

            field("Old Prod. Order Line No."; "Old Prod. Order Line No.")
            {

            }
            field("Old Prod. Order Item No."; "Old Prod. Order Item No.")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Order &Tracking")
        {
            action(UpdateOrderNo_SalesShipment)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ILE.RESET;
                    ILE.SETRANGE(ILE."Document Type", ILE."Document Type"::"Sales Shipment");
                    ILE.SETFILTER(ILE."Order No.", '=%1', '');
                    IF ILE.FINDFIRST THEN BEGIN
                        REPEAT
                            SalesShipmentLine.RESET;
                            SalesShipmentLine.SETRANGE(SalesShipmentLine."Item Shpt. Entry No.", ILE."Entry No.");
                            SalesShipmentLine.SETRANGE(SalesShipmentLine."Document No.", ILE."Document No.");
                            IF SalesShipmentLine.FINDFIRST THEN BEGIN
                                ILE."Order No." := SalesShipmentLine."Prod. Order No.";
                                ILE.MODIFY(TRUE);
                            END;
                        UNTIL ILE.NEXT = 0;
                    END;
                    MESSAGE('Loop Completed');
                end;
            }
        }
    }

    var
        ILE: Record "Item Ledger Entry";
        SalesShipmentLine: Record "Sales Shipment Line";
}