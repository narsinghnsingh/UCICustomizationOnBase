page 50047 "Sales Order Selection"
{
    // version Delivery Order Samadhan

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    RefreshOnActivate = true;
    SourceTable = "Sales Line";
    SourceTableView = SORTING ("Document Type", "Document No.", "Line No.")
                      ORDER(Ascending)
                      WHERE ("Document Type" = CONST (Order),
                            "Outstanding Quantity" = FILTER (<> 0));

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
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Profit Margin %"; "Profit Margin %")
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                }
                field("Inventory In FG Location"; "Inventory In FG Location")
                {
                }
                field("Job Wise Inventory"; "Job Wise Inventory")
                {
                }
                field("Select Item For Delivery Order"; "Select Item For Delivery Order")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        TempOrderNo := GetFilter("Ref. Sales Order No.");
        SetFilter("Ref. Sales Order No.", '');
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // Lines added By Deepak Kumar
        GetLastLineNo;
        SourceSalesLine.Reset;
        SourceSalesLine.SetRange(SourceSalesLine."Document Type", SourceSalesLine."Document Type"::Order);
        SourceSalesLine.SetRange(SourceSalesLine."Sell-to Customer No.", "Sell-to Customer No.");
        SourceSalesLine.SetRange(SourceSalesLine."Select Item For Delivery Order", true);
        if SourceSalesLine.FindFirst then begin
            repeat
                //MESSAGE('SourceSalesLine');
                DeliveryOrderLine.Reset;
                DeliveryOrderLine.SetRange(DeliveryOrderLine."Document Type", DeliveryOrderLine."Document Type"::"Delivery Order");
                DeliveryOrderLine.SetRange(DeliveryOrderLine."Ref. Sales Order No.", SourceSalesLine."Document No.");
                DeliveryOrderLine.SetRange(DeliveryOrderLine."Ref. Sales Order Line No.", SourceSalesLine."Line No.");
                DeliveryOrderLine.SetRange(DeliveryOrderLine."Document No.", TempOrderNo);
                if not DeliveryOrderLine.FindFirst then begin
                    //MESSAGE('DeliveryOrderLine');
                    DeliveryOrderLine.Init;
                    DeliveryOrderLine."Document Type" := DeliveryOrderLine."Document Type"::"Delivery Order";
                    DeliveryOrderLine."Document No." := TempOrderNo;
                    LastLineNo := LastLineNo + 10000;
                    DeliveryOrderLine."Line No." := LastLineNo;
                    DeliveryOrderLine."Ref. Sales Order No." := SourceSalesLine."Document No.";
                    DeliveryOrderLine."Ref. Sales Order Line No." := SourceSalesLine."Line No.";

                    DeliveryOrderLine.Insert(true);
                    DeliveryOrderLine.Validate("Sell-to Customer No.", SourceSalesLine."Sell-to Customer No.");
                    DeliveryOrderLine.Validate(Type, SourceSalesLine.Type);
                    DeliveryOrderLine.Validate("No.", SourceSalesLine."No.");
                    DeliveryOrderLine."Location Code" := SourceSalesLine."Location Code";
                    DeliveryOrderLine."Unit Price" := SourceSalesLine."Unit Price";
                    DeliveryOrderLine."Estimation No." := SourceSalesLine."Estimation No.";
                    DeliveryOrderLine."Prod. Order No." := SourceSalesLine."Prod. Order No.";
                    DeliveryOrderLine."Prod. Order Line No." := SourceSalesLine."Prod. Order Line No.";
                    DeliveryOrderLine."Profit Margin %" := SourceSalesLine."Profit Margin %";
                    SourceSalesLine.CalcFields(SourceSalesLine."Order Date");
                    DeliveryOrderLine."LPO(Order) Date" := SourceSalesLine."Order Date";
                    DeliveryOrderLine."Ref. Sales Order No." := SourceSalesLine."Document No.";
                    DeliveryOrderLine."Ref. Sales Order Line No." := SourceSalesLine."Line No.";
                    DeliveryOrderLine.Modify(true);
                end;
                SourceSalesLine."Select Item For Delivery Order" := false;
                SourceSalesLine.Modify(true);
            until SourceSalesLine.Next = 0;
        end;
    end;

    var
        SourceSalesLine: Record "Sales Line";
        DeliveryOrderLine: Record "Sales Line";
        TempOrderNo: Code[50];
        LastLineNo: Integer;

    procedure GetLastLineNo()
    begin
        // Lines added by Deepak Kumar
        DeliveryOrderLine.Reset;
        DeliveryOrderLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        DeliveryOrderLine.SetRange(DeliveryOrderLine."Document Type", DeliveryOrderLine."Document Type"::"Delivery Order");
        DeliveryOrderLine.SetRange(DeliveryOrderLine."Document No.", TempOrderNo);
        if DeliveryOrderLine.FindLast then begin
            LastLineNo := DeliveryOrderLine."Line No.";
        end else begin
            LastLineNo := 10000;
        end;
    end;
}

