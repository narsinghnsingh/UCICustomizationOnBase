report 50100 "List of Pending without Job"
{
    // version Sales/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/List of Pending without Job.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING ("Order Date") ORDER(Ascending) WHERE ("Document Type" = CONST (Order), Status = FILTER (<> Open), "Short Closed Document" = CONST (false), "Completely Shipped" = CONST (false));
            RequestFilterFields = "Sell-to Customer No.";
            column(Document_Number; "Sales Header"."No.")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE ("RPO Status" = FILTER (Simulated));
                column(COMINFO_NAME; COMINFO.Name)
                {
                }
                column(ProdOrderNo_SalesLine; "Sales Line"."Prod. Order No.")
                {
                }
                column(CUST_NAME; CUST_NAME)
                {
                }
                column(DocumnetDate_SalesLine; "Sales Line"."Documnet Date")
                {
                }
                column(LPOOrderDate_SalesLine; "Sales Line"."LPO(Order) Date")
                {
                }
                column(Description_SalesLine; "Sales Line".Description)
                {
                }
                column(RequestedDeliveryDate_SalesLine; "Sales Line"."Requested Delivery Date")
                {
                }
                column(LPOOrderDate_SalesLineN; "Sales Header"."Order Date")
                {
                }
                column(ExternalDocNo_SalesLine; "Sales Header"."External Document No.")
                {
                }
                column(Quantity_SalesLine; "Sales Line".Quantity)
                {
                }
                column(QuantityShipped_SalesLine; "Sales Line"."Quantity Shipped")
                {
                }
                column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                {
                }
                column(OutstandingQuantity_SalesLine; "Sales Line"."Outstanding Quantity")
                {
                }
                column(OrderDate_SalesLine; "Sales Line"."Job No.")
                {
                }
                column(FINISHED_QTY; FINISHED_QTY)
                {
                }
                column(WORKDATE; WorkDate)
                {
                }
                column(Net_Weight; "Sales Line"."Net Weight")
                {
                }
                column(CUST_SEGMENT; CUST_SEGMENT)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    COMINFO.Get;

                    S_HEADER.Reset;
                    S_HEADER.SetRange(S_HEADER."No.", "Document No.");
                    if S_HEADER.FindFirst then begin
                        CUST_NAME := S_HEADER."Sell-to Customer Name";
                    end;

                    FINISHED_QTY := 0;

                    PROD_ORDERLINE.Reset;
                    PROD_ORDERLINE.SetRange(PROD_ORDERLINE."Prod. Order No.", "Prod. Order No.");
                    //PROD_ORDERLINE.SETRANGE(PROD_ORDERLINE."Line No.","Prod. Order Line No.");
                    if PROD_ORDERLINE.FindFirst then begin
                        FINISHED_QTY := PROD_ORDERLINE."Finished Quantity";
                        //MESSAGE(FORMAT(FINISHED_QTY));
                    end;

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
        COMINFO: Record "Company Information";
        S_HEADER: Record "Sales Header";
        CUST_NAME: Text[100];
        PROD_ORDERLINE: Record "Prod. Order Line";
        FINISHED_QTY: Decimal;
        Customer: Record Customer;
        CUST_SEGMENT: Code[30];
}

