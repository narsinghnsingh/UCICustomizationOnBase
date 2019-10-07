report 50074 "Sales Details"
{
    // version Firoz

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Sales Details.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE (Quantity = FILTER (<> 0), "Quantity Invoiced" = FILTER (<> 0));
            RequestFilterFields = "Documnet Date", "Sell-to Customer No.";
            column(CompanyName; compInfo.Name)
            {
            }
            column(SysDate; WorkDate)
            {
            }
            column(SalesNo; "Sales Line"."Document No.")
            {
            }
            column(ItemNo_SalesLine; "Sales Line"."No.")
            {
            }
            column(ItemDesc_SalesLine; "Sales Line".Description)
            {
            }
            column(CustNo; CustomerName)
            {
            }
            column(LPNo_SalesLine; "Sales Line"."External Doc. No.")
            {
            }
            column(LPODate_SalesLine; "Sales Line"."Documnet Date")
            {
            }
            column(SODate_SalesLine; "Sales Line"."Order Date")
            {
            }
            column(JobNo_SalesLine; "Sales Line"."Prod. Order No.")
            {
            }
            column(DO_No; DO_No)
            {
            }
            column(DO_Date; DO_Date)
            {
            }
            column(Invoice_No; Invoice_No)
            {
            }
            column(Invoice_Date; Invoice_Date)
            {
            }
            column(LPO_Qty; LPO_Qty)
            {
            }
            column(DispatchedQty; DispatchedQty)
            {
            }
            column(InvoiceQty; InvoiceQty)
            {
            }
            column(InvoiceAmount; InvoiceAmount)
            {
            }
            column(OutStandingAmount; OutStandingAmount)
            {
            }
            column(RPOQty; RPOQty)
            {
            }
            column(InvoiceWt; InvoiceWt)
            {
            }
            column(DispatchWt; DispatchWt)
            {
            }
            column(JobQty; JobQty)
            {
            }
            column(Job_Date; Job_Date)
            {
            }
            column(PlateNo; PlateNo)
            {
            }
            column(DieNumber; DieNumber)
            {
            }
            column(AllFilters; AllFilters)
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(PreviousOutPutQTY; PreviousOutPutQTY)
            {
            }
            column(PreviousProcess; PreviousProcess)
            {
            }
            column(CUST_SEGMENT; CUST_SEGMENT)
            {
            }

            trigger OnAfterGetRecord()
            begin
                AllFilters := "Sales Line".GetFilters;

                //compInfo.GET;
                //CompanyName:=compInfo.Name;


                SalesShipmentLine.Reset;
                SalesShipmentLine.SetRange(SalesShipmentLine."Order No.", "Document No.");
                SalesShipmentLine.SetRange(SalesShipmentLine."External Doc. No.", "External Doc. No.");
                SalesShipmentLine.SetRange(SalesShipmentLine."No.", "No.");
                SalesShipmentLine.SetRange(SalesShipmentLine."Line No.", "Line No.");
                if SalesShipmentLine.FindFirst then begin

                    repeat
                        if SalesShipmentLine.Quantity <> 0 then begin
                            DO_No := SalesShipmentLine."Document No.";
                            DO_Date := SalesShipmentLine."Posting Date";
                            DispatchedQty := SalesShipmentLine.Quantity;
                            DispatchWt := SalesShipmentLine."Net Weight";
                        end else begin

                            DO_No := '';
                            DO_Date := 0D;
                            DispatchedQty := 0;
                            DispatchWt := 0;
                        end;
                    until SalesShipmentLine.Next = 0;


                end;



                SalesInvLine.Reset;
                SalesInvLine.SetRange(SalesInvLine."External Doc. No.", "External Doc. No.");
                SalesInvLine.SetRange(SalesInvLine."Prod. Order No.", "Prod. Order No.");
                SalesInvLine.SetRange(SalesInvLine."No.", "No.");
                SalesInvLine.SetRange(SalesInvLine."Line No.", "Line No.");
                if SalesInvLine.FindFirst then begin

                    repeat
                        if SalesInvLine.Quantity <> 0 then
                            Invoice_No := SalesInvLine."Document No.";
                        Invoice_Date := SalesInvLine."Posting Date";
                        InvoiceQty := SalesInvLine.Quantity;
                        InvoiceAmount := SalesInvLine.Amount;
                        OutStandingAmount := 0;
                        InvoiceWt := SalesInvLine."Net Weight";
                    until SalesInvLine.Next = 0;

                end else begin
                    Invoice_No := '';
                    Invoice_Date := 0D;
                    InvoiceQty := 0;
                    InvoiceAmount := 0;
                    OutStandingAmount := 0;
                    InvoiceWt := 0;
                end;

                //END;

                JobQty := 0;
                Job_Date := 0D;
                ProdOrderHeader.Reset;
                ProdOrderHeader.SetRange(ProdOrderHeader."No.", "Prod. Order No.");
                if ProdOrderHeader.FindFirst then
                    JobQty := ProdOrderHeader.Quantity;
                Job_Date := ProdOrderHeader."Creation Date";

                DieNumber := '';
                PlateNo := '';
                ProductDesignHeader.Reset;
                ProductDesignHeader.SetRange(ProductDesignHeader."Product Design No.", "Estimation No.");
                if ProductDesignHeader.FindFirst then begin
                    DieNumber := ProductDesignHeader."Plate Item No.";
                    PlateNo := ProductDesignHeader."Die Number";
                end;

                CustomerName := '';
                CustomerCard.Reset;
                CustomerCard.SetRange(CustomerCard."No.", "Sales Line"."Sell-to Customer No.");
                if CustomerCard.FindFirst then
                    CustomerName := CustomerCard.Name;


                ProductionRoutingLine.Reset;
                //ProductionRoutingLine.SETRANGE(ProductionRoutingLine."Item No.","No.");
                ProductionRoutingLine.SetRange(ProductionRoutingLine."Prod. Order No.", "Prod. Order No.");
                ProductionRoutingLine.SetRange(ProductionRoutingLine."Estimation No.", "Estimation No.");
                if ProductionRoutingLine.FindFirst then begin
                    //IF ProductionRoutingLine."Actual Output Quantity"<>0 THEN BEGIN
                    ProductionRoutingLine.CalcFields("Actual Output Quantity");
                    PreviousOutPutQTY := ProductionRoutingLine."Actual Output Quantity";
                    PreviousProcess := ProductionRoutingLine.Description;
                end; //ELSE BEGIN
                     //PreviousOutPutQTY:=0;
                     //PreviousProcess:='';


                //END;
                //END;


                Customer.Reset;
                Customer.SetRange(Customer."No.", "Sell-to Customer No.");
                if Customer.FindFirst then begin
                    CUST_SEGMENT := Customer."Customer Segment";
                end else begin
                    CUST_SEGMENT := '';
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
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvLine: Record "Sales Invoice Line";
        DO_No: Code[20];
        DO_Date: Date;
        Invoice_No: Code[20];
        Invoice_Date: Date;
        LPO_Qty: Decimal;
        DispatchedQty: Decimal;
        InvoiceQty: Decimal;
        InvoiceAmount: Decimal;
        OutStandingAmount: Decimal;
        RPOQty: Decimal;
        InvoiceWt: Decimal;
        DispatchWt: Decimal;
        JobQty: Decimal;
        ProdOrderHeader: Record "Production Order";
        ProductionRoutingLine: Record "Prod. Order Routing Line";
        Job_Date: Date;
        ProductDesignHeader: Record "Product Design Header";
        PlateNo: Code[20];
        DieNumber: Code[20];
        AllFilters: Text[100];
        compInfo: Record "Company Information";
        CompanyName: Text[60];
        CustomerCard: Record Customer;
        CustomerName: Text[100];
        PreviousOutPutQTY: Decimal;
        PreviousProcess: Text[100];
        Customer: Record Customer;
        CUST_SEGMENT: Code[30];
}

