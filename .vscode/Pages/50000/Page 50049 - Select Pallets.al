page 50049 "Select Pallets"
{
    // version Delivery Order Samadhan

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

                    trigger OnValidate()
                    begin
                        // Lines added bY Deepak Kumar
                        if "Select for Shipment" = true then begin
                            "Delivery Order No." := DocNo;
                            Modify(true)
                        end else begin
                            "Delivery Order No." := '';
                            Modify(true);
                        end;
                    end;
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Delivery Order No."; "Delivery Order No.")
                {
                    Editable = false;
                }
                field("Sales Shipment No."; "Sales Shipment No.")
                {
                }
                field(Posted; Posted)
                {
                }
                field("Sales Order No."; "Sales Order No.")
                {
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

    trigger OnOpenPage()
    begin
        // Lines Updated  bY Deepak Kumar
        TempLineNo := '';
        TempLineNo := GetFilter("Document Line No");
        SetFilter("Document Line No", '');
        DocNo := GetFilter("Delivery Order No.");
        if DocNo <> '' then begin
            TempFilter := DocNo + Text001;
            SetFilter("Delivery Order No.", TempFilter);
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // Lines updated bY Deepak Kumar
        TotalQty := 0;
        SetRange("Select for Shipment", true);
        if Rec.FindFirst then begin
            repeat
                TotalQty += Quantity;
            until Next = 0;
        end;

        if "Document Type" = "Document Type"::Order then begin

            //CustCheckCreditLimitN.SalesLineCheck(SalesLine);
            SalesLine.Reset;
            SalesLine.SetRange(SalesLine."Document Type", "Document Type");
            SalesLine.SetRange(SalesLine."Document No.", "Sales Order No.");
            SalesLine.SetFilter(SalesLine."Line No.", TempLineNo);
            //  SalesLine.SETFILTER(SalesLine."Prod. Order No.","Prod. Order No.");
            if SalesLine.FindFirst then begin


                if CustCheckCreditLimit.SalesLineShowWarning(SalesLine) then begin
                    OK := CustCheckCreditLimit.RunModal = ACTION::Yes;
                    Clear(CustCheckCreditLimit);
                    SaleRecSetup.Get;
                    if SaleRecSetup."Force Credit Limit" then begin
                        Message(Sam001);
                        exit;
                    end;
                    if not OK then begin
                        Error(Sam000);
                        exit;
                    end;

                end;

                SalesLine.Validate(SalesLine."Qty. to Ship", TotalQty);
                SalesLine.Modify(true);
            end;

        end else begin
            SalesLine.Reset;
            SalesLine.SetRange(SalesLine."Document Type", "Document Type");
            SalesLine.SetRange(SalesLine."Ref. Sales Order No.", "Sales Order No.");
            SalesLine.SetRange(SalesLine."Document No.", DocNo);
            SalesLine.SetFilter(SalesLine."Line No.", TempLineNo);
            SalesLine.SetFilter(SalesLine."Prod. Order No.", "Prod. Order No.");
            if SalesLine.FindFirst then begin
                SalesLine.Validate(SalesLine.Quantity, TotalQty);
                SalesLine.Modify(true);
                Message('Delivery Order Number %1  Line Number %2 Quantity %3', SalesLine."Document No.", SalesLine."Line No.", SalesLine.Quantity);
            end;
        end;
    end;

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

