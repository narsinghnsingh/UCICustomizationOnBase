pageextension 50053 EXT_9003_AccReceivablesAdmRC extends "Acc. Receivables Adm. RC"
{
    layout
    {
        addlast("Control1900724808")
        {
            part("Acc. Receivable Activities"; "Small Business Owner Act.")
            {

            }
        }
    }
    // version NAVW18.00

    actions
    {
        addbefore("C&ustomer - List")
        {
            action("Production Order Wise Status")
            {
                RunObject = Page "Production Order wise status";
            }
            action("Daily Production Status")
            {
                Image = "Report";
                Promoted = true;
                RunObject = Report "Daily Production Status";
            }

            action("Sales Order Wise Status")
            {
                Image = "Order";
                RunObject = Page "Sales  Order wise status";
            }
            action("Daily Printing Status")
            {
                Caption = 'Daily Printing Status';
                Image = "Report";
                Promoted = true;
                RunObject = Report "Daily Production Printing";
            }
            action("Inventory Valuation ")
            {
                Image = "Report";
                RunObject = Report "Inventory Valuation";
            }
            action("Die / Block Charges Detail")
            {
                Caption = 'Die / Block Charges Detail';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = false;
                RunObject = Report "Plate Charge Not Invoiced";
            }
            action("Block Impression")
            {
                Image = "Report";
                Promoted = false;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = false;
                RunObject = Report "Block  Impression Report";
            }
            action("Die Impression")
            {
                Image = "Report";
                Promoted = false;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = false;
                RunObject = Report "Die Impression Report";
            }
            action("Jobwise Material status summary")
            {
                Image = "Report";
                RunObject = Report "Jobwise material statusSummar";
            }
            action("KnockOff Detail Summary")
            {
                Image = Report;
                RunObject = report "Knock Off Detail Report";
            }
            separator(Separator20)
            {
            }
            group(Reports)
            {
                Caption = 'Reports';
                Image = Sales;
                group(ActionGroup66)
                {
                    Caption = 'Reports';
                    Image = Sales;

                    action("Production Wise Variation")
                    {
                        Ellipsis = true;
                        Image = List;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Page "Product Wise Variation ";
                    }
                    action("Inventory Customer Sales")
                    {
                        Image = "Report";
                        RunObject = Report "Inventory - Customer Sales";
                    }
                    action("Change Log Entry")
                    {
                        Image = List;
                        Promoted = true;
                        PromotedCategory = Category4;
                        PromotedIsBig = true;
                        RunObject = Page "Change Log Entries";
                    }
                    action("User Personalization")
                    {
                        Image = User;
                        Promoted = true;
                        PromotedCategory = Category4;
                        PromotedIsBig = true;
                        RunObject = Page "User Personalization List";
                    }
                    action("Active Sessions")
                    {
                        Image = UserCertificate;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Active Session";
                    }
                    action("User setup")
                    {
                        Image = User;
                        Promoted = true;
                        PromotedCategory = Category4;
                        PromotedIsBig = true;
                        RunObject = Page "User Setup";
                    }
                    action("General Setup")
                    {
                        Image = Setup;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "General Ledger Setup";
                    }
                    action("General Posting Setup")
                    {
                        Image = Setup;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "General Posting Setup";
                    }
                    action("Fixed Asset Setup")
                    {
                        Image = Setup;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Fixed Asset Setup";
                    }
                    action("FA Posting Groups")
                    {
                        Image = FixedAssets;
                        Promoted = true;
                        PromotedCategory = Category4;
                        RunObject = Page "FA Posting Groups";
                    }
                    action("Payment Terms")
                    {
                        Image = PaymentDays;
                        Promoted = true;
                        PromotedCategory = Category4;
                        RunObject = Page "Payment Terms";
                    }
                    action("Accounting Period")
                    {
                        Image = AccountingPeriods;
                        Promoted = true;
                        PromotedCategory = Category4;
                        RunObject = Page "Accounting Periods";
                    }
                    action("Cost Accounting Setup")
                    {
                        Image = Setup;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Cost Accounting Setup";
                    }
                    action("Cash Flow Setup")
                    {
                        Image = Setup;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Cash Flow Setup";
                    }
                    action("Sales Register With Average")
                    {
                        Image = "Report";
                        RunObject = Report "Sales Register with Average";
                    }

                    action("Booking/Sales Summary Details")
                    {
                        Image = "Report";
                        RunObject = Report "WIP Stocks";
                    }

                    action("Sales Register")
                    {
                        Image = "Report";
                        RunObject = Report "Sales Register";
                    }
                    action("Daily Booking/Sales Register")
                    {
                        Image = "Report";
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
                        RunObject = Report "Pending Job Summary";
                    }
                    action("Customer Wise DO Details")
                    {
                        Image = "Report";
                        RunObject = Report FG;
                    }
                    action("Delivery Order Dispatched List")
                    {
                        Image = "Report";
                        RunObject = Report "Delivery Order Dispatched List";
                    }
                    action("PDC Report")
                    {
                        Image = "Report";
                        RunObject = Report "Jobwise material statusSummar";
                    }
                    action("Customer Order Detail")
                    {
                        Image = "Report";
                        RunObject = Report "Customer - Order Detail";
                    }
                    action("Customer Invoice Detail")
                    {
                        Image = "Report";
                        RunObject = Report "Product Dev. Details";
                    }
                    action("Customer Item Details")
                    {
                        Image = "Report";
                        RunObject = Report "Customer Items Details";
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
                        RunObject = Report "List of Pending Job_New";
                    }
                    action("Sales Person Sales Statistics")
                    {
                        Image = "Report";
                        RunObject = Report "Salesperson - Sales Statistics";
                    }
                }
                group(ActionGroup81)
                {
                    Caption = 'Reports';
                    Image = Sales;
                    action("Report Calc. and Post VAT Settlement")
                    {
                        Caption = 'Report Calc. and Post VAT Settlement';
                        Image = "Report";
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = "Report";
                        RunObject = Report "Calc. and Post VAT Settlement";
                    }
                    action("Stock Report Reel Wise")
                    {
                        Caption = 'Stock Report Reel Wise';
                        Image = "Report";
                        RunObject = Report PaperAgeingInventory;
                    }
                    action("Report Phys. Inventory List")
                    {
                        Caption = 'Report Phys. Inventory List';
                        RunObject = Report "Phys. Inventory List";
                    }
                    action("Pending Order Summary")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Pending Order Summary";
                    }
                    action("Stock Report Width Wise")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Stock Report Width Wise";
                    }
                    action("Production And Sales Summary")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "Production and Sales SummaryN";
                    }
                    action("Purchase Register")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "Purchase Register";
                    }
                    action("New Ledger Report")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report Ledger;
                    }
                    action("Monthly Issue/Return/Consumption")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Monthly Issue/Return/Consp.";
                    }
                    action("Inventory Valuation New")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Inventory Valuation Sam";
                    }
                    action("Production Variation")
                    {
                        RunObject = Page "Product Wise Variation ";
                    }
                    action("Stock Consumption Report")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "Stock Consumption";
                    }
                    action("WIP Stocks")
                    {
                        Caption = 'WIP Stocks';
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "WIP Stocks";
                    }
                    action(Action83)
                    {
                        Caption = 'Finished PO';
                        RunObject = Page "Purchase Order Archives";
                    }
                    action("Expected Collection Cust/Sales")
                    {
                        Caption = 'Expected Collection Cust/Sales';
                        RunObject = Report "Expected Collection Cust/Sales";
                    }
                    action("Orderwise Short or Excess Qty. Delivered")
                    {
                        Caption = 'Orderwise Short or Excess Qty. Delivered';
                        Image = "Report";
                        RunObject = Report "Orderwise Short/Excess Del.";
                    }
                }
            }
        }
        addbefore(Customers)
        {
            action("Chart Of Accounts")
            {
                RunObject = Page "Chart of Accounts";
            }
        }
        addafter("Sales Invoices")
        {
            action("Sales Dispatch List")
            {
                RunObject = Page "Sales Dispatch list";
            }

            action("Sales Credit Memo")
            {
                RunObject = Page "Sales Credit Memos";
            }
            action("PDC Journal")
            {
                RunObject = Page "Post Dated Cheque PDC";
            }

            action("Sales Journals")
            {
                Caption = 'Sales Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE ("Template Type" = CONST (Sales),
                                    Recurring = CONST (false));
                Visible = false;
            }
            action("Cash Receipt Journals")
            {
                Caption = 'Cash Receipt Journals';
                Image = Journals;
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE ("Template Type" = CONST ("Cash Receipts"),
                                    Recurring = CONST (false));
                Visible = false;
            }
            action("General Journals")
            {
                Caption = 'General Journals';
                Image = Journal;
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE ("Template Type" = CONST (General),
                                    Recurring = CONST (false));
                Visible = false;
            }
            action("Product Design")
            {
                RunObject = Page "Product Design List";
            }
            action(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page Dimensions;
            }
            action("Released PO")
            {
                Image = Production;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Released Production Orders";
            }
            action("Finished PO")
            {
                Image = Production;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Finished Production Orders";
            }
            action("Machine Center List")
            {
                RunObject = Page "Machine Center List";
            }
            action("All Plate Status")
            {
                RunObject = Page "All Plate Status";
            }
            action("All Production Orders")
            {
                Caption = 'All Production Orders';
                RunObject = Page "Production Order List";
            }
            action(RequestToApprove)
            {
                CaptionML = ENU = 'Request To Approve';
                Image = ApplyEntries;
                RunObject = page "Requests to Approve";
            }
        }

        addafter("Posted Documents")
        {
            group(Journals)
            {
                Caption = 'Journals';
                //Image = Journals;
                action("Purchase Journals")
                {
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE ("Template Type" = CONST (Purchases),
                                        Recurring = CONST (false));
                }
                action(Action152)
                {
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE ("Template Type" = CONST (General),
                                        Recurring = CONST (false));
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                //Image = FixedAssets;
                action(Action150)
                {
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                }
                action(Insurance)
                {
                    Caption = 'Insurance';
                    RunObject = Page "Insurance List";
                }
                action("Fixed Assets G/L Journals")
                {
                    Caption = 'Fixed Assets G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE ("Template Type" = CONST (Assets),
                                        Recurring = CONST (false));
                }
                action("Fixed Assets Journals")
                {
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE (Recurring = CONST (false));
                }
                action("Fixed Assets Reclass. Journals")
                {
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                }
                action("Insurance Journals")
                {
                    Caption = 'Insurance Journals';
                    RunObject = Page "Insurance Journal Batches";
                }
                action("<Action3>")
                {
                    Caption = 'Recurring General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE ("Template Type" = CONST (General),
                                        Recurring = CONST (true));
                }
                action("Recurring Fixed Asset Journals")
                {
                    Caption = 'Recurring Fixed Asset Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE (Recurring = CONST (true));
                }
            }
        }
        addafter("&Sales")
        {
            action("Hr Menu")
            {
                Image = Setup;
                RunObject = Page "HR Module";
            }
            action("Short Closed SO")
            {
                CaptionML = ENU = 'Short Closed SO';
                Image = Sales;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Short Closed Sales Order";
            }
            action("Change RPO status")
            {
                CaptionML = ENU = 'Change RPO Status';
                Image = ChangeStatus;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Change RPO Status";
            }
            action("Phy. Invent. Journal")
            {
                Caption = 'Phy. Invent. Journal';
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Phys. Inventory Journal";
            }
            action("Production Job Order")
            {
                CaptionML = ENU = 'Production Job Order';
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Production Order List";
            }
            separator(Task)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Bank Receipt Voucher")
            {
                Caption = 'Bank Receipt Voucher';
                Image = CashReceiptJournal;
                RunObject = Page "Bank Receipt Voucher";
            }
            separator(Separator111)
            {
            }
            action("Sale Person Wise Avg Sales Report")
            {
                Caption = 'Sale Person Wise Avg Sales Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "New Sales Avg Report";
            }
        }
    }
}

