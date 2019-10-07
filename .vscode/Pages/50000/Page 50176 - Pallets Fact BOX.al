page 50176 "Pallets Fact BOX"
{
    // version Delivery Order Samadhan

    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ShowFilter = false;
    SourceTable = "Packing List Line";
    SourceTableView = SORTING ("Packing List No.", "Pallet No.", "Sales Order No.", "Document Line No")
                      WHERE (Posted = CONST (false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Packing List No."; "Packing List No.")
                {
                }
                field("Pallet No."; "Pallet No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Select for Shipment"; "Select for Shipment")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Delivery Order No."; "Delivery Order No.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select All")
            {

                trigger OnAction()
                begin
                    PackingLine.Reset;
                    PackingLine.SetRange(PackingLine."Sales Order No.", "Sales Order No.");
                    PackingLine.SetRange(PackingLine."Item No.", "Item No.");
                    PackingLine.SetRange(PackingLine."Prod. Order No.", "Prod. Order No.");
                    PackingLine.SetRange(PackingLine.Posted, false);
                    if PackingLine.FindFirst then begin
                        repeat
                            PackingLine."Select for Shipment" := true;
                            PackingLine."Delivery Order No." := DocNo;
                            PackingLine.Modify(true);
                        until PackingLine.Next = 0;
                    end;
                end;
            }
            action("De-Select All")
            {

                trigger OnAction()
                begin
                    PackingLine.Reset;
                    PackingLine.SetRange(PackingLine."Sales Order No.", "Sales Order No.");
                    PackingLine.SetRange(PackingLine."Item No.", "Item No.");
                    PackingLine.SetRange(PackingLine."Prod. Order No.", "Prod. Order No.");
                    PackingLine.SetRange(PackingLine.Posted, false);
                    if PackingLine.FindFirst then begin
                        repeat
                            PackingLine."Select for Shipment" := false;
                            PackingLine."Delivery Order No." := '';
                            PackingLine.Modify(true);
                        until PackingLine.Next = 0;
                    end;
                end;
            }
        }
    }

    var
        SalesLine: Record "Sales Line";
        TotalQty: Decimal;
        TempLineNo: Text;
        PackingLine: Record "Packing List Line";
        DocNo: Code[20];
        TempFilter: Text[250];
        Text001: Label '|''''';
        PackingListLine: Record "Packing List Line";
        CustCheckCreditLimitN: Codeunit "Cust-Check Cr. Limit";
        CustCheckCreditLimit: Page "Check Credit Limit";
        OK: Boolean;
        SaleRecSetup: Record "Sales & Receivables Setup";
        Sam000: Label 'The update has been interrupted to respect the warning.';
        Sam001: Label 'The update has been interrupted to respect the force credit policy.';
}

