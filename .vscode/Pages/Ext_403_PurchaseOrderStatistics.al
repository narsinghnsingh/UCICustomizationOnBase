pageextension 50033 Ext_403_PurchaseOrderStatistic extends "Purchase Order Statistics"
{
    layout
    {
        // Add changes to page layout here
        addafter("VATAmount[3]")
        {
            field(QtytoReciveVatAmount; QtytoReciveVatAmount)
            {
                CaptionML = ENU = 'Roll Receive VAT Amount';
            }
            field(TotalAmount2; TotalAmount2[3] + QtytoReciveVatAmount)
            {
                CaptionML = ENU = 'Total Incl. VAT New';
            }

        }
    }

    Local procedure CalculateQtytoReceiveVatAmount()
    Begin
        QtytoReciveVatAmount := 0;
        TempPurchaseLine.RESET;
        TempPurchaseLine.SETRANGE(TempPurchaseLine."Document Type", "Document Type");
        TempPurchaseLine.SETRANGE(TempPurchaseLine."Document No.", "No.");
        TempPurchaseLine.SETFILTER(TempPurchaseLine."Qty. to Receive", '<>0');
        IF TempPurchaseLine.FINDFIRST THEN BEGIN
            REPEAT
                QtytoReciveVatAmount += (TempPurchaseLine."Amount Including VAT" - TempPurchaseLine.Amount);
            UNTIL TempPurchaseLine.NEXT = 0;
        END;

    End;

    trigger OnAfterGetRecord()
    begin
        CalculateQtytoReceiveVatAmount();
    end;

    var
        TempPurchaseLine: Record "Purchase Line";
        QtytoReciveVatAmount: Decimal;
        TotalAmount2: Array[3] of Decimal;

}