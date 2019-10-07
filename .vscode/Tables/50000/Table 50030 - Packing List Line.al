table 50030 "Packing List Line"
{
    // version Packing List Samadhan


    fields
    {
        field(1; "Packing List No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Pallet No."; Integer)
        {

            trigger OnValidate()
            begin
                PackingListHeader.Reset;
                PackingListHeader.SetRange(PackingListHeader.Type, PackingListHeader.Type::Production);
                PackingListHeader.SetRange(PackingListHeader.No, "Packing List No.");
                PackingListHeader.FindFirst;

                "Prod. Order No." := PackingListHeader."Prod. Order No.";
                "Sales Order No." := PackingListHeader."Sales Order No.";
                "Item No." := PackingListHeader."Item No.";
                "Sales Order Line No." := PackingListHeader."Sales Order Line No.";
            end;
        }
        field(3; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                PackingListHeader.Get("Packing List No.");
                "Prod. Order No." := PackingListHeader."Prod. Order No.";
                "Sales Order No." := PackingListHeader."Sales Order No.";
                "Item No." := PackingListHeader."Item No.";
                "Sales Order Line No." := PackingListHeader."Sales Order Line No.";
                ValidateQtytoPack();
            end;
        }
        field(4; "Prod. Order No."; Code[20])
        {
            Editable = true;
        }
        field(5; "Sales Order No."; Code[20])
        {
            Editable = true;
        }
        field(6; "Item No."; Code[20])
        {
            Editable = false;
            TableRelation = Item."No.";
        }
        field(7; "Select for Shipment"; Boolean)
        {
        }
        field(8; "Sales Shipment No."; Code[20])
        {
            Editable = false;
        }
        field(9; Posted; Boolean)
        {
            Editable = false;
        }
        field(10; "Type Of Packing"; Option)
        {
            OptionCaption = 'Pallet,Box,Bundle';
            OptionMembers = Pallet,Box,Bundle;
        }
        field(11; "No of Box/ Bundle"; Integer)
        {
        }
        field(12; "Qty Per Box / Bundle"; Integer)
        {
        }
        field(13; "Document Line No"; Integer)
        {
        }
        field(14; "Creation Date"; Date)
        {
            CalcFormula = Lookup ("Packing List Header"."Creation Date" WHERE (No = FIELD ("Packing List No.")));
            FieldClass = FlowField;
        }
        field(15; "Delivery Order No."; Code[20])
        {
        }
        field(16; "Sales Order Line No."; Integer)
        {
        }
        field(17; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Delivery Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order";
        }
        field(50; "Return Recipt No"; Code[20])
        {
            Editable = false;
        }
        field(51; "Return Recipt Line No."; Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Packing List No.", "Pallet No.", "Sales Order No.", "Document Line No")
        {
        }
        key(Key2; "Sales Order No.", "Item No.")
        {
        }
        key(Key3; "Packing List No.", Quantity)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // Lines added by deepak Kumar
        if Posted = true then
            Error('You cannot delete Posted Record, Please contact your System Adminstrator for more details.');
    end;

    var
        PackingListHeader: Record "Packing List Header";
        PackingListLine: Record "Packing List Line";
        TotQty: Decimal;

    procedure ValidateQtytoPack()
    begin
        PackingListHeader.Reset;
        PackingListHeader.SetRange(PackingListHeader.No, "Packing List No.");
        if PackingListHeader.FindFirst then begin
            TotQty := 0;
            if PackingListHeader.Type = PackingListHeader.Type::Production then begin
                if PackingListHeader."Item Ledger Entry Number" = 0 then begin
                    PackingListLine.Reset;
                    PackingListLine.SetRange(PackingListLine."Prod. Order No.", "Prod. Order No.");
                    PackingListLine.SetFilter(PackingListLine."Item No.", "Item No.");
                    PackingListLine.SetRange(PackingListLine."Return Recipt No", '');
                    if PackingListLine.FindFirst then begin
                        repeat
                            TotQty += PackingListLine.Quantity;
                        until PackingListLine.Next = 0;
                        TotQty := TotQty + Quantity;
                        //MESSAGE(FORMAT(TotQty));
                        //MESSAGE(FORMAT(PackingListHeader."Total Finished Quantity"));
                        if (TotQty > PackingListHeader."Total Finished Quantity") then
                            Error('The Total Pallet Quantity %1 cannot exceed Total Finished Quantity %2', TotQty, PackingListHeader."Total Finished Quantity");
                    end;
                end else begin
                    PackingListLine.Reset;
                    PackingListLine.SetRange(PackingListLine."Prod. Order No.", "Prod. Order No.");
                    PackingListLine.SetRange(PackingListLine."Packing List No.", "Packing List No.");
                    PackingListLine.SetFilter(PackingListLine."Item No.", "Item No.");
                    PackingListLine.SetRange(PackingListLine."Return Recipt No", '');
                    if PackingListLine.FindFirst then begin
                        repeat
                            TotQty += PackingListLine.Quantity;
                        until PackingListLine.Next = 0;
                        TotQty := TotQty + Quantity;
                        //MESSAGE(FORMAT(TotQty));
                        //MESSAGE(FORMAT(PackingListHeader."Total Finished Quantity"));
                        if (TotQty > PackingListHeader."Total Finished Quantity") then
                            Error('The Total Pallet Quantity %1 cannot exceed Total Finished Quantity %2', TotQty, PackingListHeader."Total Finished Quantity");
                    end;

                end;
            end else begin
                PackingListLine.Reset;
                PackingListLine.SetRange(PackingListLine."Return Recipt No", "Return Recipt No");
                PackingListLine.SetRange(PackingListLine."Return Recipt Line No.", "Return Recipt Line No.");
                PackingListLine.SetFilter(PackingListLine."Item No.", "Item No.");
                if PackingListLine.FindFirst then begin
                    repeat
                        TotQty += PackingListLine.Quantity;
                    until PackingListLine.Next = 0;
                    TotQty := TotQty + Quantity;
                    //MESSAGE(FORMAT(TotQty));
                    //MESSAGE(FORMAT(PackingListHeader."Total Finished Quantity"));
                    if (TotQty > PackingListHeader."Total Finished Quantity") then
                        Error('The Total Pallet Quantity %1 cannot exceed Total Finished Quantity %2', TotQty, PackingListHeader."Total Finished Quantity");
                end;


            end;
        end;
    end;
}

