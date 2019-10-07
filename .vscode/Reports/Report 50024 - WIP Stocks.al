report 50024 "WIP Stocks"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/WIP Stocks.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
        {
            DataItemTableView = SORTING (Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") ORDER(Ascending) WHERE ("Work Center No." = FILTER ('WC0002'), "Routing Link Code" = FILTER ('SHEET'), Status = FILTER (Released), "Print Load Qty" = FILTER (> 0));
            RequestFilterFields = Type, "No.";
            column(Comp_Name; REPORTFILTER)
            {
            }
            column(RUNDATE; WorkDate)
            {
            }
            column(REPORTFILTER; REPORTFILTER)
            {
            }
            column(ProdOrderNo_ProdOrderRoutingLine; "Prod. Order Routing Line"."Prod. Order No.")
            {
            }
            column(No_ProdOrderRoutingLine; "Prod. Order Routing Line"."No.")
            {
            }
            column(Description_ProdOrderRoutingLine; "Prod. Order Routing Line".Description)
            {
            }
            column(PrintLoadQty_ProdOrderRoutingLine; "Prod. Order Routing Line"."Print Load Qty")
            {
            }
            column(DELIVERY_DATE; DELIVERY_DATE)
            {
            }
            column(REPEATEXT; REPEATEXT)
            {
            }
            column(GLUTEXT; GLUTEXT)
            {
            }
            column(OD_LENGTH; OD_LENGTH)
            {
            }
            column(OD_WIDTH; OD_WIDTH)
            {
            }
            column(OD_HEIGHT; OD_HEIGHT)
            {
            }
            column(Size; OD_LENGTH * OD_WIDTH * OD_HEIGHT)
            {
            }
            column(CUST_NAME; CUST_NAME)
            {
            }
            column(ItemDescription; ItemDescription)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.Get;

                REPORTFILTER := "Prod. Order Routing Line".GetFilters;
                "Prod. Order Routing Line".CalcFields("Prod. Order Routing Line"."Item Catgory Code");

                ProdOrderLine.Reset;
                ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                if ProdOrderLine.FindFirst then begin
                    Sales_orderno := ProdOrderLine."Sales Order No.";
                    Sales_ordernoline := ProdOrderLine."Sales Order Line No.";
                    SalesLine.Reset;
                    SalesLine.SetRange(SalesLine."Document No.", Sales_orderno);
                    SalesLine.SetRange(SalesLine."Line No.", Sales_ordernoline);
                    if SalesLine.FindFirst then begin
                        DELIVERY_DATE := SalesLine."Requested Delivery Date";
                    end;
                end;

                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder."No.", "Prod. Order No.");
                if ProductionOrder.FindFirst then begin
                    if ProductionOrder."Repeat Job" = true then begin
                        REPEATEXT := 'Repeat'
                    end else begin
                        REPEATEXT := 'New'
                    end;
                end;

                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder."No.", "Prod. Order No.");
                if ProductionOrder.FindFirst then begin
                    FG_NO := ProductionOrder."Source No.";
                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetRange(ProductDesignHeader."Item Code", FG_NO);
                    //ProductDesignHeader.SETRANGE(ProductDesignHeader."Production Order No.","Order No.");
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", PRODDESN_NO);
                    if ProductDesignHeader.FindFirst then begin
                        if ProductDesignHeader.Stitching <> true then begin
                            GLUTEXT := 'Glue';
                        end else begin
                            GLUTEXT := 'Stitch';
                        end;
                    end;
                end;

                CUST_NAME := '';
                ProductionOrder.Reset;
                ProductionOrder.SetRange(ProductionOrder."No.", "Prod. Order No.");
                if ProductionOrder.FindFirst then begin
                    CUST_NAME := ProductionOrder."Customer Name";
                    FG_NO := ProductionOrder."Source No.";
                    PRODDESN_NO := ProductionOrder."Estimate Code";
                    ProductDesignHeader.Reset;
                    ProductDesignHeader.SetRange(ProductDesignHeader."Item Code", FG_NO);
                    ProductDesignHeader.SetRange(ProductDesignHeader."Production Order No.", "Prod. Order No.");
                    ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", PRODDESN_NO);
                    if ProductDesignHeader.FindFirst then begin
                        OD_LENGTH := ProductDesignHeader."Box Length (mm)- L (OD)";
                        OD_WIDTH := ProductDesignHeader."Box Width (mm)- W (OD)";
                        OD_HEIGHT := ProductDesignHeader."Box Height (mm) - D (OD)";
                    end;
                end;


                Item.Reset;
                "Prod. Order Routing Line".CalcFields("Prod. Order Routing Line"."Item No.");
                Item.SetRange(Item."No.", "Item No.");
                Item.SetFilter(Item."Item Category Code", 'FG');
                if Item.FindFirst then begin
                    ItemDescription := Item.Description;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
        ProdOrderLine: Record "Prod. Order Line";
        Sales_orderno: Code[30];
        Sales_ordernoline: Integer;
        SalesLine: Record "Sales Line";
        DELIVERY_DATE: Date;
        ProductionOrder: Record "Production Order";
        REPEATEXT: Text;
        ProductDesignHeader: Record "Product Design Header";
        FG_NO: Code[30];
        GLUTEXT: Text;
        PRODDESN_NO: Code[30];
        CUST_NAME: Text;
        OD_LENGTH: Integer;
        OD_WIDTH: Integer;
        OD_HEIGHT: Integer;
        REPORTFILTER: Text;
        ItemDescription: Text;
        Item: Record Item;
}

