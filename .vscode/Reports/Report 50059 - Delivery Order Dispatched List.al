report 50059 "Delivery Order Dispatched List"
{
    // version Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Delivery Order Dispatched List.rdl';
    Caption = 'DOWISE Dispatched LIST';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING ("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Posting Date";
            column(COMINFONAME; COMINFO.Name)
            {
            }
            column(No_SalesShipmentHeader; "Sales Shipment Header"."No.")
            {
            }
            column(SelltoCustomerName_SalesShipmentHeader; "Sales Shipment Header"."Sell-to Customer Name")
            {
            }
            column(PostingDate; "Sales Shipment Header"."Posting Date")
            {
            }
            column(SalespersonCode_SalesShipmentHeader; "Sales Shipment Header"."Salesperson Code")
            {
            }
            column(SALESPERSON_NAME; SALESPERSON_NAME)
            {
            }
            column(MINDATE; Format('FROM') + ' ' + Format(MINDATE))
            {
            }
            column(OrderDate; "Sales Shipment Header"."Order Date")
            {
            }
            column(ExternalDocNo; "Sales Shipment Header"."External Document No.")
            {
            }
            column(MAXDATE; Format('TO') + ' ' + Format(MAXDATE))
            {
            }
            column(CUST_SEGMENT; CUST_SEGMENT)
            {
            }
            column(VehicleNo_SalesShipmentHeader; "Sales Shipment Header"."Vehicle No.")
            {
            }
            column(DriverName_SalesShipmentHeader; "Sales Shipment Header"."Driver Name")
            {
            }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document No.", "Line No.") ORDER(Ascending) WHERE (Quantity = FILTER (<> 0));
                RequestFilterFields = "Prod. Order No.";
                column(DocumentNo_SalesShipmentLine; "Sales Shipment Line"."Document No.")
                {
                }
                column(ProdOrderNo_SalesShipmentLine; "Sales Shipment Line"."Prod. Order No.")
                {
                }
                column(Quantity_SalesShipmentLine; Abs("Sales Shipment Line".Quantity))
                {
                }
                column(ORDERED_QTY; Abs(ORDERED_QTY))
                {
                }
                column(INVNO; INVNO)
                {
                }
                column(INVAMT; INVAMT)
                {
                }
                column(Weight; "Sales Shipment Line"."Net Weight")
                {
                }
                column(ORDER_DATE; ORDER_DATE)
                {
                }
                column(No_SalesShipmentLine; "Sales Shipment Line"."No.")
                {
                }
                column(Description_SalesShipmentLine; "Sales Shipment Line".Description)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ORDERED_QTY := 0;
                    INVNO := '';
                    INVAMT := 0;


                    SL.Reset;
                    SL.SetRange(SL."Document No.", "Order No.");
                    SL.SetRange(SL."Line No.", "Line No.");
                    SL.SetRange(SL."Sell-to Customer No.", "Sell-to Customer No.");
                    if SL.FindFirst then begin
                        ORDERED_QTY := SL.Quantity;
                        ORDER_DATE := SL."Order Date";

                    end else begin
                        ORDERED_QTY := 0;
                        ORDER_DATE := 0D;
                    end;

                    /*
                    
                    SL.RESET;
                    SL.SETRANGE(SL."Document No.","Order No.");
                    SL.SETRANGE(SL."Sell-to Customer No.","Sell-to Customer No." );
                    SL.SETRANGE(SL."Line No.","Line No.");
                    IF SL.FINDFIRST THEN BEGIN
                     IF SL."Quantity Shipped" <>0 THEN
                        REPEAT
                      //SL.CALCFIELDS(SL."Mother Job No.");
                      ORDERED_QTY :=ORDERED_QTY+SL.Quantity;
                      ORDER_DATE := SL."Order Date";
                      //MESSAGE(FORMAT(ORDERED_QTY));
                      UNTIL SL.NEXT=0;
                    END ELSE BEGIN
                      ORDERED_QTY := 0;
                      ORDER_DATE := 0D;
                    END;
                    
                    
                    */




                    SINVLINE.Reset;
                    SINVLINE.SetRange(SINVLINE."Shipment No.", "Document No.");
                    SINVLINE.SetRange(SINVLINE."Shipment Line No.", "Line No.");
                    //SINVLINE.SETRANGE(SINVLINE."No.","No.");
                    if SINVLINE.FindFirst then begin
                        INVNO := SINVLINE."Document No.";
                        INVAMT := SINVLINE."Line Amount";
                    end else begin
                        INVNO := '';
                        INVAMT := 0;
                    end;



                    //for Weight Firoz
                    /*
                    ILE.RESET;
                    ILE.SETRANGE(ILE."Document No.","Sales Shipment Line"."Document No.");
                    ILE.SETRANGE(ILE."Item No.","Sales Shipment Line"."No.");
                     IF ILE.FINDFIRST THEN BEGIN
                        Weight:= Need to be added field in ILE
                     END;
                    */

                end;
            }

            trigger OnAfterGetRecord()
            begin
                MINDATE := "Sales Shipment Header".GetRangeMin("Sales Shipment Header"."Posting Date");
                MAXDATE := "Sales Shipment Header".GetRangeMax("Sales Shipment Header"."Posting Date");

                Customer.Reset;
                Customer.SetRange(Customer."No.", "Sell-to Customer No.");
                if Customer.FindFirst then begin
                    CUST_SEGMENT := Customer."Customer Segment";
                end else begin
                    CUST_SEGMENT := '';
                end;

                SALESPERSON_PURCHASER.Reset;
                SALESPERSON_PURCHASER.SetRange(SALESPERSON_PURCHASER.Code, "Salesperson Code");
                if SALESPERSON_PURCHASER.FindFirst then begin
                    SALESPERSON_NAME := SALESPERSON_PURCHASER.Name;
                end else begin
                    SALESPERSON_NAME := '';
                end;

                COMINFO.Get;
                /*
                SL.RESET;
                SL.SETRANGE(SL."Document No.","Order No.");
                SL.SETRANGE(SL."Sell-to Customer No.","Sell-to Customer No." );
                SL.SETRANGE(SL."Line No.","Line No.");
                IF SL.FINDFIRST THEN BEGIN
                 IF SL."Quantity Shipped" <>0 THEN
                    REPEAT
                  //SL.CALCFIELDS(SL."Mother Job No.");
                  ORDERED_QTY :=ORDERED_QTY+SL.Quantity;
                  ORDER_DATE := SL."Order Date";
                  //MESSAGE(FORMAT(ORDERED_QTY));
                  UNTIL SL.NEXT=0;
                END ELSE BEGIN
                  ORDERED_QTY := 0;
                  ORDER_DATE := 0D;
                END;
                
                */

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
        COMINFO: Record "Company Information";
        MINDATE: Date;
        MAXDATE: Date;
        SL: Record "Sales Line";
        ORDERED_QTY: Decimal;
        SINVLINE: Record "Sales Invoice Line";
        INVNO: Code[20];
        INVAMT: Decimal;
        ORDER_DATE: Date;
        SALESPERSON_PURCHASER: Record "Salesperson/Purchaser";
        SALESPERSON_NAME: Text[100];
        ILE: Record "Item Ledger Entry";
        Weight: Decimal;
        Customer: Record Customer;
        CUST_SEGMENT: Code[30];
}

