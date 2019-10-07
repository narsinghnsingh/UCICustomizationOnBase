page 50205 "Delivery Order Detail"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Sales Shipment Line";
    SourceTableView = SORTING ("Document No.", "Line No.")
                      ORDER(Ascending)
                      WHERE (Quantity = FILTER (<> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(PailotDescription; PailotDescription)
                {
                    Caption = 'Description Of Goods';
                    Editable = false;
                }
                field("External Doc. No."; "External Doc. No.")
                {
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Editable = false;
                }
                field("Vehicle No."; "Vehicle No.")
                {
                    Editable = false;
                }
                field("Driver Name"; "Driver Name")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //For Pallet
        PACKING_LINE.Reset;
        PACKING_LINE.SetCurrentKey(PACKING_LINE.Quantity);
        PACKING_LINE.SetRange(PACKING_LINE."Prod. Order No.", "Prod. Order No.");
        PACKING_LINE.SetRange(PACKING_LINE."Sales Shipment No.", "Document No.");
        PACKING_LINE.SetRange(PACKING_LINE."Item No.", "No.");
        PACKING_LINE.SetRange(PACKING_LINE."Type Of Packing", 0);
        if PACKING_LINE.FindFirst then begin
            TempQty := '';
            LineCounter := 0;
            PailotDescription := '';
            repeat
                if TempQty <> Format(PACKING_LINE.Quantity) then begin
                    if LineCounter <> 0 then
                        PailotDescription := PailotDescription + ' ' + TempQty + ' X ' + Format(LineCounter) + ' ' + 'Pallet' + ' ';

                    TempQty := Format(PACKING_LINE.Quantity);
                    LineCounter := 1;
                end else begin
                    LineCounter := LineCounter + 1;
                end;
            until PACKING_LINE.Next = 0;
            if LineCounter <> 0 then
                PailotDescription := PailotDescription + ' ' + TempQty + ' X ' + Format(LineCounter) + ' ' + 'Pallet' + ' ';
            //MESSAGE(PailotDescription);
        end else begin
            PailotDescription := '';
        end;

        //For Box/Bundle
        PACKING_LINE.Reset;
        PACKING_LINE.SetCurrentKey(PACKING_LINE."Type Of Packing");
        PACKING_LINE.SetRange(PACKING_LINE."Sales Shipment No.", "Document No.");
        PACKING_LINE.SetRange(PACKING_LINE."Item No.", "No.");
        PACKING_LINE.SetFilter(PACKING_LINE."Type Of Packing", '<>0');
        if PACKING_LINE.FindFirst then begin
            repeat
                PailotDescription := PailotDescription + ' ' + Format(PACKING_LINE."No of Box/ Bundle") + ' ' + ' x ' + ' ' + Format(PACKING_LINE."Qty Per Box / Bundle") + ' ' + Format(PACKING_LINE."Type Of Packing")
            until PACKING_LINE.Next = 0;
        end;
    end;

    var
        PACKING_LINE: Record "Packing List Line";
        PALLET_TAGNO: Integer;
        PALLET_QTY: Decimal;
        TempQty: Code[50];
        LineCounter: Integer;
        PailotDescription: Text[250];
}

