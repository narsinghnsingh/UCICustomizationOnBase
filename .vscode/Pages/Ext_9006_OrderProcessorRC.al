pageextension 50061 Ext_9006_OrderProcessorRC extends "Order Processor Role Center"
{
    // version NAVW18.00    
    layout
    {

    }
    actions
    {
        modify("Item Journals")
        {
            Visible = false;
        }
        modify(CashReceiptJournals)
        {
            Visible = false;
        }
        modify("Sales &Journal")
        {
            Visible = false;
        }
        modify("Transfer Orders")
        {
            Visible = false;
        }
        modify("Sales &Credit Memo")
        {
            Visible = false;
        }
        modify("Sales Orders - Microsoft Dynamics 365 for Sales")
        {
            Visible = false;
        }
        modify("Sales Credit Memos")
        {
            Visible = false;
        }
        modify("Sales Return Orders")
        {
            Visible = false;
        }
        modify("Sales Journals")
        {
            Visible = false;
        }

        modify("&Prices")
        {
            Visible = false;
        }
        modify("Sales Price &Worksheet")
        {
            Visible = false;
        }
        modify(Purchasing)
        {
            Visible = false;
        }
        modify(Inventory)
        {
            Visible = false;
        }
        modify("Self-Service")
        {
            Visible = false;
        }
        modify(Sales)
        {
            Visible = false;
        }

        addlast(Reports)
        {
            group(General)
            {
                Image = Sales;
                action("Customer order Details")
                {
                    RunObject = Report "Customer - Order Detail";
                }
                action("Booking/Sales Summary Details")
                {
                    RunObject = Report "WIP Stocks";
                }
                action("Daily Booking/Sales Register")
                {
                    RunObject = Report "Daily Booking/Sales Register";
                }
                action("Pending Job Summary")
                {
                    RunObject = Report "Pending Job Summary";
                }
                action("Finished Goods Details")
                {
                    RunObject = Report "Finished Goods Details";
                }
                action("Customer Wise DO Details")
                {
                    RunObject = Report FG;
                }
                action("Delivery Order Dispatched List")
                {
                    RunObject = Report "Delivery Order Dispatched List";
                }
                action("Invoice Brief")
                {
                    RunObject = Report "Additional Cost ChargeAssignmt";
                }

            }
        }

        addafter("Salesperson - Sales &Statistics")
        {
            action("Machine Wise Shift Wise Report")
            {
                Image = "Report";
                RunObject = Report "Machine Wise Shift Wise Report";
            }
            action("List of Pending Job")
            {
                Ellipsis = true;
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Report "List of Pending Job_New";
            }
            action("Inventory Order Details")
            {
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Report "Inventory Order Details";
            }
            action("Inventory - top 10 List")
            {
                Image = "Report";
                RunObject = Report "Inventory - Top 10 List";
            }
            action("Customer Item Details")
            {
                Image = "Report";
                RunObject = Report "Customer Items Details";
            }
            action("Customer Invoice Details")
            {
                Image = "Report";
                RunObject = Report "Product Dev. Details";
            }
            action("Confirm Schedule")
            {
                Image = "Report";
                RunObject = Report "Confirm Schedule";
            }
            action("Sales Register")
            {
                Image = Print;
                RunObject = Report "Sales Register";
            }
            action("Production & Sales Summary")
            {
                Caption = 'Production & Sales Summary';
                Image = Print;
                RunObject = Report "Production and Sales SummaryN";
            }
            action("Daily Production Status")
            {
                Image = "Report";
                RunObject = Report "Daily Production Status";
            }
            action("Production Order Wise Status")
            {
                RunObject = Page "Production Order wise status";
            }
            action("Sales Order Wise Status")
            {
                //RunObject = Report Report50196;
            }
            action("Jobwise Material Status Summary")
            {
                Caption = 'Jobwise Material Status Summary';
                RunObject = Report "Jobwise material statusSummar1";
            }
            action("Dept. Approved Product Design List")
            {
                RunObject = Page "Product Design List";
                RunPageView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.")
                              ORDER(Ascending)
                              WHERE ("Pre-Press Status" = FILTER ('"Updated & Confirmed"'),
                                    "Production Status" = FILTER ('"Updated & Confirmed"'),
                                    Status = CONST (Open));
            }
        }
        addafter("Transfer Orders")
        {
            action("Product Design List")
            {
                RunObject = Page "Product Design List";
            }
        }
        addafter("Sales &Credit Memo")
        {

            action("Short Closed SO")
            {
                RunObject = Page "Short Closed Sales Order";
            }
            action("Estimate Required by Sales")
            {
                RunObject = Page "Estimation Requird by Sales";
            }
            action("Plate Status")
            {
                RunObject = Page "All Plate Status";
            }
            action("Finished Production Orders")
            {
                RunObject = Page "Finished Production Orders";
            }
        }
    }
}

