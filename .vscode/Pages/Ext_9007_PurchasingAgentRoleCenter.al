pageextension 50044 Ext_PurchasingAgentRoleCenter extends "Purchasing Agent Role Center"
{
    layout
    {

    }

    actions
    {
        addafter("Inventory &Cost and Price List")
        {
            separator("General Tasks")
            {
                CaptionML = ENU = 'General Tasks';
                IsHeader = true;
            }
            action("Label Print")
            {
                Image = BarCode;
                RunObject = Report "Expected Collection Cust/Sales";
            }
            action("Purchase Order  VAT  ")
            {
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Print VAT Order";
            }
            action("Purchase Register")
            {
                Image = Print;
                RunObject = Report "Purchase Register";
            }
            action("GRN Detail")
            {
                Image = "Report";
                RunObject = Report "GRV Details";
            }
            action("Material Receipt Vendor wise Report")
            {
                Caption = 'Material Receipt Vendor wise Report';
                Image = "Report";
                Promoted = true;
                RunObject = Report "GRV Details Date Wise";
            }
            action("Pending Order Summary")
            {
                Image = "Report";
                RunObject = Report "Pending Order Summary";
            }
            action("List of pending job")
            {
                Image = "Report";
                RunObject = Report "List of Pending Job_New";
            }
            action("Statement ")
            {
                Image = "Report";
                RunObject = Report Statement;
            }
            action("Sales Register ")
            {
                Image = "Report";
                RunObject = Report "Sales Register";
            }
            action("Daily Booking / Sales Regsiter")
            {
                Image = "Report";
                RunObject = Report "Daily Booking/Sales Register";
            }
            action("Jobwise Material Status")
            {
                Image = "Report";
                RunObject = Report "Jobwise material status";
            }
            action("Daily Production Status")
            {
                Image = "Report";
                RunObject = Report "Daily Production Status";
            }
            separator(Separator28)
            {
            }
            action("Item Issued Details")
            {
                Image = Print;
                Promoted = true;
                RunObject = Report "Item Issued Report";
            }
            action("Pending Job Details")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "List of Pending Job";
            }
            action("Inventory Valuation Report")
            {
                RunObject = Report "Inventory Valuation";
            }
            action("Stock Abstract Report")
            {
                Image = Print;
                RunObject = Report "Stock Abstract Details";
            }
            action("Stock Details Reel Wise")
            {
                RunObject = Report PaperAgeingInventory;
            }
            action("Inventory - Transaction Detail")
            {
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Inventory - Transaction Detail";
            }
            action("Stock Consumption Report")
            {
                RunObject = Report "Stock Consumption";
            }
            action("Monthly Issue/Return/Consp.")
            {
                RunObject = Report "Monthly Issue/Return/Consp.";
            }
            action("Ink & Pallet Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Inks & Pallet Report";
            }
            action("Roll Print")
            {
                Image = PrintAttachment;
                RunObject = Page "Roll Details for bar CodePrint";
            }
            action("Print Purchase OrderVAT")
            {
                Caption = 'Print Purchase OrderVAT';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Print VAT Order";
            }

        }
        addafter("PurchaseOrdersPartDeliv")
        {
            action("Released Production Order list")
            {
                RunObject = Page "Released Production Orders";
            }
            action("Material Requisition OPM")
            {
                RunObject = Page "Purchase Requisition List";
                RunPageView = WHERE ("Marked Purchase Requisition" = CONST (false));
            }
            action("Purchase Requisition List")
            {
                RunObject = Page "Purchase Requisition List";
                RunPageView = WHERE ("Marked Purchase Requisition" = CONST (true));
            }
            action("Material Requisition List")
            {
                RunObject = Page "Schedule Requisition List";
            }
            action("Schedule Wise Paper Consumption List")
            {
                Caption = 'Schedule Wise Paper Consumption List';
                RunObject = Page "Published Schedule List";
            }

            action("Material Receipt Window")
            {
                RunObject = Page "GRN List";
            }
            action("Short Close Purchase order")
            {
                RunObject = Page "Short Closed Purchase Order";
            }
            action("Posted Item Issue List")
            {
                RunObject = Page "Item Ledger Entries";
                RunPageView = WHERE ("Entry Type" = FILTER ("Negative Adjmt." | Consumption));
            }
            action("Approval Entries")
            {
                RunObject = Page "Approval Entries";
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
        addafter(Tasks)
        {
            action("Paper Issue Journal")
            {
                Image = Journal;
                Promoted = false;
                RunObject = Page "Item Issue Journal";
            }
            action("OPM Issue Journal")
            {
                RunObject = Page "OPM Consumption Journal";
            }

            action("Purchase Planing")
            {
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Samadhan Purchase Planing";
            }
        }
    }
}