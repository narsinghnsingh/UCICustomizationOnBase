pageextension 50004 Ext_21_CustomerCard extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here

        moveafter("Preferred Bank Account Code"; "CustSalesLCY - CustProfit - AdjmtCostLCY")
        moveafter("CustSalesLCY - CustProfit - AdjmtCostLCY"; AdjCustProfit)
        moveafter(AdjCustProfit; AdjProfitPct)
        moveafter(AdjProfitPct; TotalSales2)
        moveafter(City; "VAT Registration No.")
        moveafter("Service Zone Code"; "Payment Terms Code")
        moveafter("Payment Terms Code"; "Location Code")
        //moveafter("VAT Registration No."; "Trade License No.")
        //moveafter("Trade License No.";"Expiry Date of Trade Lic")        
        addafter("Credit Limit (LCY)")

        {
            field("Cust. Credit Buffer(LCY)"; "Cust. Credit Buffer(LCY)")
            {
                CaptionML = ENU = 'Customer Buffer Amount LCY';
            }
            field("Credit Limit (LCY) Base"; "Credit Limit (LCY) Base")
            {

            }
            field("Credit Limit Override"; "Credit Limit Override")
            {
                CaptionML = ENU = 'Credit Limit Override (Ignore Credit Limit)';
            }
            field("Due Date Calculated By Month"; "Due Date Calculated By Month")
            {

            }
            field("Created On"; "Created On")
            {
                Editable = False;
            }
            field("Customer Address Print"; "Customer Address Print")
            {

            }


        }
        addafter("Last Date Modified")
        {
            field("Customer Segment"; "Customer Segment")
            {

            }
            field("Conditional Shipping Tolerance"; "Conditional Shipping Tolerance")
            {

            }
            field("Conditional Ship Tolerance %"; "Conditional Ship Tolerance %")
            {
                Editable = "Conditional Shipping Tolerance";
            }
            field("Production Tolerance %"; "Production Tolerance %")
            {
                Editable = "Conditional Shipping Tolerance";
            }

        }
        addafter("VAT Registration No.")
        {
            field("Trade License No."; "Trade License No.")
            {

            }
            field("Expiry Date of Trade Lic"; "Expiry Date of Trade Lic")
            {

            }
        }
        addafter(Shipping)
        {

            group("Corrugation Specific")
            {
                CaptionML = ENU = 'Corrugation Specific';
                field("Created / Modified By"; "Created / Modified By")
                {

                }
                field("Approved / Blocked By"; "Approved / Blocked By")
                {

                }
                field("Chamber of Commerce Reg. No."; "Chamber of Commerce Reg. No.")
                {

                }
            }
        }
        addafter("Partner Type")
        {
            field("Payment Terms Print"; "Payment Terms Print")
            {

            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addlast(History)
        {
            action("Sales Order Line-Job Change")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Sales Order Line-Job Change';
                RunObject = Page 50178;
                RunPageView = SORTING ("Document Type", "Document No.", "Line No.")
                                  ORDER(Ascending)
                                  WHERE ("Short Closed Document" = CONST (false));
                RunPageLink = "Sell-to Customer No." = FIELD ("No.");
                trigger OnAction()
                begin

                end;
            }
        }
        addlast("&Customer")
        {
            action("Document Checklist")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Document Checklist';
                Promoted = true;
                RunObject = Page 50143;
                RunPageLink = "Table Name" = CONST (Customer),
                                  "No." = FIELD ("No."),
                                  Type = CONST (Document);

                PromotedIsBig = true;
                Image = CheckList;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
            // action(Approve1)
            // {
            //     ApplicationArea = All;
            //     CaptionML = ENU = 'Approve';
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     Image = Approve;
            //     PromotedCategory = Process;
            //     trigger OnAction()
            //     begin
            //         // lines added by deepak Kumar
            //         ApproveRecord;
            //         //Firoz 16-11-15
            //         TESTFIELD("Customer Posting Group");
            //         TESTFIELD("VAT Bus. Posting Group");
            //         TESTFIELD("Gen. Bus. Posting Group");
            //         TESTFIELD("Salesperson Code");
            //         //End Firoz 16-11-15

            //     end;
            // }
            action("Block Card")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Block Card';
                Promoted = true;
                PromotedIsBig = true;
                Image = ClearLog;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    // lines added by deepak kUmar
                    BlockRecord;
                end;
            }
        }

    }

}