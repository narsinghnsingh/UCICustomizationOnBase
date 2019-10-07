pageextension 50059 Ext_9019_CEOPresidentRC extends "CEO and President Role Center"
{
    layout
    {
        addfirst(Control1900724808)
        {
            part("Finance Performance"; "Small Business Owner Act.")
            {

            }
        }
    }
    actions
    {
        addbefore("Recei&vables-Payables")
        {
            action("Purchase Planning")
            {
                ApplicationArea = "#Basic", "#Suite";
                Image = Purchase;
                Promoted = true;
                RunObject = Page "Samadhan Purchase Planing";
            }
            action("Sales Register")
            {
                ApplicationArea = "#Basic", "#Suite";
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Sales Register";
            }
            action("Pending Job details")
            {
                ApplicationArea = "#Basic", "#Suite";
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "List of Pending Job";
            }
            action("Machine Wise Shift Wise Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Machine Wise Shift Wise Report";
            }
            action("Inventory order Detail")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory Order Details";
            }
            action("Customer Item Details")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Customer Items Details";
            }
            action("Customer Invoice Detail")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Product Dev. Details";
            }
            action("Daily Production Report")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "Daily Production Status";
            }
            action("C&ustomer - List")
            {
                Caption = 'C&ustomer - List';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Customer - List";
            }
            action("Customer - &Balance to Date")
            {
                Caption = 'Customer - &Balance to Date';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Customer - Balance to Date";
            }
            action("Aged &Accounts Receivable")
            {
                Caption = 'Aged &Accounts Receivable';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Customer - &Summary Aging Simp.")
            {
                Caption = 'Customer - &Summary Aging Simp.';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Customer - Summary Aging Simp.";
            }
            action("Customer - Trial Balan&ce")
            {
                Caption = 'Customer - Trial Balan&ce';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Customer - Trial Balance";
            }
            action("Inventory Valuation ")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "Inventory Valuation";
            }
            action("Cus&tomer/Item Sales")
            {
                Caption = 'Cus&tomer/Item Sales';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Customer/Item Sales";
            }
            separator(Separator62)
            {
            }
            action("Customer &Document Nos.")
            {
                Caption = 'Customer &Document Nos.';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Customer Document Nos.";
            }
            action("Sales &Invoice Nos.")
            {
                Caption = 'Sales &Invoice Nos.';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Sales Invoice Nos.";
            }
            action("Sa&les Credit Memo Nos.")
            {
                Caption = 'Sa&les Credit Memo Nos.';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Sales Credit Memo Nos.";
            }
            action("Re&minder Nos.")
            {
                Caption = 'Re&minder Nos.';
                Image = "Report";
                RunObject = Report "Reminder Nos.";
            }
            action("Finance Cha&rge Memo Nos.")
            {
                Caption = 'Finance Cha&rge Memo Nos.';
                Image = "Report";
                RunObject = Report "Finance Charge Memo Nos.";
            }
            action("Booking/Sales Summary Details")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "WIP Stocks";
            }
            action("Daily Booking/Sales Register")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "Daily Booking/Sales Register";
            }
            action("Finished Goods Details")
            {
                Image = "Report";
                RunObject = Report "Finished Goods Details";
            }
            action("Invoice Brief")
            {
                Image = "Report";
                RunObject = Report "Additional Cost ChargeAssignmt";
            }
            action("Pending Job summary")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "Pending Job Summary";
            }
            action("Customer Wise DO Details")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report FG;
            }
            action("Delivery Order Dispatched List")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "Delivery Order Dispatched List";
            }
            action("PDC Report")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "Jobwise material statusSummar";
            }
            action("Customer Order Detail")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "Customer - Order Detail";
            }
            action("Inventory Top 10 List")
            {
                Image = "Report";
                RunObject = Report "Inventory - Top 10 List";
            }
            action("Inventory Order Details")
            {
                Image = "Report";
                RunObject = Report "Inventory Order Details";
            }
            action("List Of Pending Job")
            {
                Image = "Report";
                RunObject = Report "List of Pending Job";
            }
            action("Sales Person Sales Statistics")
            {
                Image = "Report";
                RunObject = Report "Salesperson - Sales Statistics";
            }
            action("Inventory Customer Sales")
            {
                Image = "Report";
                RunObject = Report "Inventory - Customer Sales";
            }
            separator(Separator11)
            {
            }

            action("FG Detail Report")
            {
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "FG Report";
            }
            action("Inventory Report New")
            {
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Inventory Valuation Sam";
            }
            action("Production & Sales Summary")
            {
                Caption = 'Production & Sales Summary';
                Image = Print;
                RunObject = Report "Production and Sales SummaryN";
            }
            action("Production Order wise status")
            {
                RunObject = Page "Production Order wise status";
                Promoted = true;
                PromotedIsBig = true;
            }
        }
        addbefore("Account Schedules")
        {
            action("Chart Of Accounts")
            {
                RunObject = Page "Chart of Accounts";
            }
        }
        addafter("Sales Invoices")
        {
            action("Approval Entries")
            {
                RunObject = Page "Approval Entries";
            }
            action("Pending Purch. Requistion List")
            {
                RunObject = Page "Pending Purch. Requistion List";
            }
            action("Posted Approval Entries")
            {
                RunObject = Page "Posted Approval Entries";
            }
            action("Approval Request Entries")
            {
                RunObject = Page "Approval Request Entries";
            }
        }
    }
}