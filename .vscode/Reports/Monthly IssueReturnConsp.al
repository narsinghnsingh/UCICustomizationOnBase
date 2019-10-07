report 50075 "Monthly Issue/Return/Consp."
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Monthly IssueReturnConsp.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(SysDate; WorkDate)
            {
            }
            column(CompName; "Company Information".Name)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = SORTING ("Requisition No.") ORDER(Ascending) WHERE ("Entry Type" = CONST (Consumption), "Requisition No." = FILTER (<> ''));
                RequestFilterFields = "Posting Date";
                column(Job_no; "Item Ledger Entry"."Order No.")
                {
                }
                column(Doc_No; "Item Ledger Entry"."Document No.")
                {
                }
                column(Quantity; "Item Ledger Entry".Quantity)
                {
                }
                column(Posting_Date; "Item Ledger Entry"."Posting Date")
                {
                }
                column(Prod_Order_Qty; ProdOrderQty)
                {
                }
                column(MINDATE; Format('FROM') + '   ' + Format(MINDATE))
                {
                }
                column(MAXDATE; Format('Date: ') + '   ' + Format(MAXDATE))
                {
                }
                column(ConsumptionQty; ConsumptionQty)
                {
                }
                column(QtyIssued; QtyIssued)
                {
                }
                column(RequisitionQty; RequisitionQty)
                {
                }
                column(ItemCatagoryCode; "Item Ledger Entry"."Item Category Code")
                {
                }
                column(REQ_NO; "Item Ledger Entry"."Requisition No.")
                {
                }
                column(RequisitionDate; RequisitionDate)
                {
                }
                column(OutPutQty; OutPutQty)
                {
                }
                column(NegativeReturnQty; NegativeReturnQty)
                {
                }
                column(totalNegative; totalNegative)
                {
                }
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = FIELD ("Item No.");
                    column(Qty_On_Prod_order; Item."Qty. on Prod. Order")
                    {
                    }
                    column(GSM; Item."Paper GSM")
                    {
                    }
                    column(Deckle_Size; Item."Deckle Size (mm)")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    MAXDATE := "Item Ledger Entry".GetRangeMax("Item Ledger Entry"."Posting Date");
                    MINDATE := "Item Ledger Entry".GetRangeMin("Item Ledger Entry"."Posting Date");


                    ConsumptionQty := 0;

                    RequisitionQty := 0;
                    ProdOrder.Reset;
                    ProdOrder.SetRange(ProdOrder."No.", "Item Ledger Entry"."Order No.");
                    if ProdOrder.FindFirst then
                        ProdOrderQty := ProdOrder.Quantity;

                    //Calculate Negative

                    ILE.Reset;
                    NegativeReturnQty := 0;
                    ILE.SetRange(ILE."Document No.", "Document No.");
                    ILE.SetRange(ILE."Item No.", "Item No.");
                    ILE.SetRange(ILE."Posting Date", MINDATE, MAXDATE);
                    ILE.SetFilter(ILE."Entry Type", 'Negative Adjmt.');
                    if ILE.FindFirst then begin
                        repeat
                            // MESSAGE(ILE."Requisition No.");
                            NegativeReturnQty := NegativeReturnQty + ILE.Quantity;
                            //MESSAGE(ILE."Item No.");
                            // MESSAGE(FORMAT(NegativeReturnQty));
                        until ILE.Next = 0;
                    end else begin
                        NegativeReturnQty := 0;
                    end;


                    if "Entry Type" = "Entry Type"::Consumption then begin
                        Requisitionheader.Reset;
                        Requisitionheader.SetRange(Requisitionheader."Prod. Order No", "Order No.");
                        if Requisitionheader.FindFirst then
                            RequisitionQty := Requisitionheader."Requisition Quantity";
                        ReqNo := Requisitionheader."Requisition No.";
                        RequisitionDate := Requisitionheader."Requisition Date";
                    end else begin
                        RequisitionQty := 0;
                    end;

                    //Calculate Output Qty

                    ILE.Reset;
                    OutPutQty := 0;
                    ILE.SetRange(ILE."Order No.", "Order No.");
                    ILE.SetFilter(ILE."Item Category Code", 'PAPER');
                    ILE.SetFilter(ILE."Entry Type", 'OUTPUT');
                    if ILE.FindFirst then begin
                        repeat
                            OutPutQty := OutPutQty + ILE.Quantity;
                        until ILE.Next = 0;
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
        ProdOrder: Record "Production Order";
        ProdOrderQty: Decimal;
        MINDATE: Date;
        MAXDATE: Date;
        ConsumptionQty: Decimal;
        ILE: Record "Item Ledger Entry";
        NegativeReturnQty: Decimal;
        QtyIssued: Decimal;
        Requisitionheader: Record "Requisition Header";
        RequisitionQty: Decimal;
        ReqNo: Code[20];
        RequisitionDate: Date;
        OutPutQty: Decimal;
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        totalNegative: Decimal;
}

