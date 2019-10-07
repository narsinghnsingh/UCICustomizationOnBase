page 50230 "Costing Inventory Role Center"
{
    // version NAVW18.00

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control99; "Finance Performance")
                {
                    Visible = false;
                }
                part(Control1902304208; "Account Manager Activities")
                {
                }
                part(Control1907692008; "My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control103; "Trailing Sales Orders Chart")
                {
                    Visible = false;
                }
                part(Control106; "My Job Queue")
                {
                    Visible = false;
                }
                // part(Control100; "Cash Flow Chart")
                // {
                // }
                part(Control1902476008; "My Vendors")
                {
                }
                part(Control108; "Report Inbox Part")
                {
                }
                //part(Control1903012608;"Connect Online")
                //{
                //}
                // systempart(; MyNotes)
                // {
                // }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Phy.  Inventories")
            {
                Caption = 'Phy.  Inventories';
                RunObject = Page "Phys. Inventory Journal";
            }
            action("Revaluation Journal")
            {
                Caption = 'Revaluation Journal';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Revaluation Journal";
            }
            action("Released Production Orders")
            {
                Caption = 'Released Production Orders';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Released Production Orders";
            }
            action("Finished Production Orders")
            {
                Caption = 'Finished Production Orders';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Finished Production Orders";
            }
            group(Reports)
            {
                Caption = 'Reports';
                Image = Sales;
                group(ActionGroup120)
                {
                    Caption = 'Reports';
                    Image = Sales;
                    action("VAT Entries")
                    {
                        Caption = 'VAT Entries';
                        Image = VATEntries;
                        Promoted = true;
                        PromotedIsBig = true;
                    }
                    action("<Report Calc. and Post VAT Settlement")
                    {
                        Caption = 'Report Calc. and Post VAT Settlement';
                        Image = "Report";
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = "Report";
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = false;
                        RunObject = Report "Calc. and Post VAT Settlement";
                    }
                    action("Paper Aging Inventory")
                    {
                        Caption = 'Paper Aging Inventory';
                        Ellipsis = true;
                        Image = "Report";
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = "Report";
                        RunObject = Report PaperAgeingInventory;
                    }
                    action("Daily Printing Status")
                    {
                        Image = "Report";
                        RunObject = Report "Daily Production Printing";
                    }
                    action("Daily Production Status")
                    {
                        Image = "Report";
                        RunObject = Report "Daily Production Status";
                    }
                    action("Sales Register")
                    {
                        Caption = 'Sales Register';
                        Image = "Report";
                        RunObject = Report "Sales Register";
                    }
                    action("Production Sale Summary")
                    {
                        Image = "Report";
                        Promoted = true;
                        RunObject = Report "Production and Sales SummaryN";
                    }
                    action("&G/L Trial Balance")
                    {
                        Caption = '&G/L Trial Balance';
                        Image = "Report";
                        RunObject = Report "Trial Balance";
                    }
                    action("&Bank Detail Trial Balance")
                    {
                        Caption = '&Bank Detail Trial Balance';
                        Image = "Report";
                        RunObject = Report "Bank Acc. - Detail Trial Bal.";
                    }
                    action("&Account Schedule")
                    {
                        Caption = '&Account Schedule';
                        Image = "Report";
                        RunObject = Report "Account Schedule";
                    }
                    action("Bu&dget")
                    {
                        Caption = 'Bu&dget';
                        Image = "Report";
                        RunObject = Report Budget;
                    }
                    action("Trial Bala&nce/Budget")
                    {
                        Caption = 'Trial Bala&nce/Budget';
                        Image = "Report";
                        RunObject = Report "Trial Balance/Budget";
                    }
                    action("Trial Balance by &Period")
                    {
                        Caption = 'Trial Balance by &Period';
                        Image = "Report";
                        RunObject = Report "Trial Balance by Period";
                    }
                    action("&Fiscal Year Balance")
                    {
                        Caption = '&Fiscal Year Balance';
                        Image = "Report";
                        RunObject = Report "Fiscal Year Balance";
                    }
                    action("Balance Comp. - Prev. Y&ear")
                    {
                        Caption = 'Balance Comp. - Prev. Y&ear';
                        Image = "Report";
                        RunObject = Report "Balance Comp. - Prev. Year";
                    }
                    action("Ink & Pallet Report")
                    {
                        Caption = 'Ink & Pallet Report';
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "Inks & Pallet Report";
                    }
                    action("&Closing Trial Balance")
                    {
                        Caption = '&Closing Trial Balance';
                        Image = "Report";
                        RunObject = Report "Closing Trial Balance";
                    }
                    action("Die Impression Report")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "Die Impression Report";
                    }
                    action("Block Impression Report")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "Block  Impression Report";
                    }
                }
            }
            separator(Separator49)
            {
            }
            action("Cash Flow Date List")
            {
                Caption = 'Cash Flow Date List';
                Image = "Report";
                RunObject = Report "Cash Flow Date List";
            }
            separator(Separator115)
            {
            }
            action("Reconcile Cus&t. and Vend. Accs")
            {
                Caption = 'Reconcile Cus&t. and Vend. Accs';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }
            separator(Separator53)
            {
            }
            action("Inventory Valuation Report")
            {
                Image = Print;
                RunObject = Report "Inventory Valuation";
            }
            separator(Separator60)
            {
            }
            action("&Intrastat - Checklist")
            {
                Caption = '&Intrastat - Checklist';
                Image = "Report";
                RunObject = Report "Intrastat - Checklist";
            }
            action("Intrastat - For&m")
            {
                Caption = 'Intrastat - For&m';
                Image = "Report";
                RunObject = Report "Intrastat - Form";
            }
            separator(Separator4)
            {
            }
            action("Purchase Register")
            {
                Image = Print;
                RunObject = Report "Purchase Register";
            }
            action("Cost Accounting P/L Statement")
            {
                Caption = 'Cost Accounting P/L Statement';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement";
            }
            group(ActionGroup162)
            {
                Caption = 'Reports';
                Image = Sales;
                group(ActionGroup161)
                {
                    Caption = 'Reports';
                    Image = Sales;
                    action("CA P/L Statement per Period")
                    {
                        Caption = 'CA P/L Statement per Period';
                        Image = "Report";
                        RunObject = Report "Cost Acctg. Stmt. per Period";
                    }
                    action("CA P/L Statement with Budget")
                    {
                        Caption = 'CA P/L Statement with Budget';
                        Image = "Report";
                        RunObject = Report "Cost Acctg. Statement/Budget";
                    }
                    action("Cost Accounting Analysis")
                    {
                        Caption = 'Cost Accounting Analysis';
                        Image = "Report";
                        RunObject = Report "Cost Acctg. Analysis";
                    }
                    action("Ageing Report for paper")
                    {
                        Image = Print;
                        Promoted = true;
                        RunObject = Report PaperAgeingInventory;
                    }
                    action("Stock Report Width Wise")
                    {
                        Image = Print;
                        RunObject = Report "Stock Report Width Wise";
                    }
                    action("Pending Order Summary")
                    {
                        Image = Print;
                        RunObject = Report "Pending Order Summary";
                    }
                    action("Stock Consumption Report")
                    {
                        RunObject = Report "Stock Consumption";
                    }
                    action("Monthly Issue/Return/Consp.")
                    {
                        RunObject = Report "Monthly Issue/Return/Consp.";
                    }
                    action("Paper Ageing Inventory")
                    {
                        Caption = 'PaperAgeingInventory';
                        RunObject = Report PaperAgeingInventory;
                    }
                    action("JobWise Material Status Summary")
                    {
                        Image = Print;
                        RunObject = Report "Jobwise material statusSummar";
                    }
                    separator(Separator123)
                    {
                    }
                    action("JobWise Costing")
                    {
                        Image = "Report";
                        Promoted = true;
                        PromotedCategory = "Report";
                        PromotedIsBig = true;
                        RunObject = Report "JobWise Costing";
                    }
                    action("Production Wise Status")
                    {
                        RunObject = Page "Production Order wise status";
                    }
                    action("New Ledger Report")
                    {
                        RunObject = Report Ledger;
                    }
                    action("Pending Job Details")
                    {
                        Image = Report2;
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Report "List of Pending Job";
                    }
                    action("Block Die Charges Report")
                    {
                        Caption = 'Block Die Charges Report';
                        Image = "Report";
                        RunObject = Report "Plate Charge Not Invoiced";
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
                    action("Production Variation Report")
                    {
                        Caption = 'Production Variation Report';
                        Image = WIPEntries;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Product Wise Variation ";
                    }
                    action("Product Design List")
                    {
                        Caption = 'Product Design List';
                        Image = Design;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Product Design List";
                    }
                    action("Machine Center")
                    {
                        Caption = 'Machine Center';
                        Image = MachineCenter;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = Page "Machine Center List";
                    }
                }
            }
        }
        area(embedding)
        {
            action("Chart of Accounts")
            {
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
                RunPageMode = Create;
            }
            action("Sales Invoice List")
            {
                RunObject = Page "Sales Invoice List";
            }
            action("General Ledger Entries")
            {
                RunObject = Page "General Ledger Entries";
            }
            action(Balance)
            {
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Vendor List";
                RunPageView = WHERE ("Balance (LCY)" = FILTER (<> 0));
            }
            action("Purchase Orders")
            {
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action("LC Detail List")
            {
                RunObject = Page "LC Detail List";
            }
            action(Budgets)
            {
                Caption = 'Budgets';
                RunObject = Page "G/L Budget Names";
            }
            action("Bank Accounts")
            {
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Action13)
            {
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = WHERE ("Balance (LCY)" = FILTER (<> 0));
            }
            action(Reminders)
            {
                Caption = 'Reminders';
                Image = Reminder;
                RunObject = Page "Reminder List";
            }
            action("Incoming Documents")
            {
                Caption = 'Incoming Documents';
                Image = Documents;
                RunObject = Page "Incoming Documents";
            }
            action("Material Requisition")
            {
                RunObject = Page "Purchase Requisition List";
            }
            action("Active Session")
            {
                RunObject = Page "Active Session";
            }
            action("All Prod Orders")
            {
                RunObject = Page "Production Order List";
            }
            action(PDC)
            {
                RunObject = Page "Post Dated Cheque PDC";
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action("Purchase Journals")
                {
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE ("Template Type" = CONST (Purchases),
                                        Recurring = CONST (false));
                }
                action("General Journals")
                {
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE ("Template Type" = CONST (General),
                                        Recurring = CONST (false));
                }
            }
            group("Cost Accounting")
            {
                Caption = 'Cost Accounting';
                action("Cost Types")
                {
                    Caption = 'Cost Types';
                    RunObject = Page "Chart of Cost Types";
                }
                action("Cost Centers")
                {
                    Caption = 'Cost Centers';
                    RunObject = Page "Chart of Cost Centers";
                }
                action("Cost Objects")
                {
                    Caption = 'Cost Objects';
                    RunObject = Page "Chart of Cost Objects";
                }
                action("Cost Allocations")
                {
                    Caption = 'Cost Allocations';
                    RunObject = Page "Cost Allocation Sources";
                }
                action("Cost Budgets")
                {
                    Caption = 'Cost Budgets';
                    RunObject = Page "Cost Budget Names";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
                action("Posted Purchase Invoices")
                {
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Return")
                {
                    RunObject = Page "Posted Return Shipments";
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("Issued Reminders")
                {
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                }
                action("Issued Fin. Charge Memos")
                {
                    Caption = 'Issued Fin. Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                }
                action("G/L Registers")
                {
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
                action("Cost Accounting Registers")
                {
                    Caption = 'Cost Accounting Registers';
                    RunObject = Page "Cost Registers";
                }
                action("Cost Accounting Budget Registers")
                {
                    Caption = 'Cost Accounting Budget Registers';
                    RunObject = Page "Cost Budget Registers";
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action(Currencies)
                {
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = Page Currencies;
                }
                action("Accounting Periods")
                {
                    Caption = 'Accounting Periods';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                }
                action("Number Series")
                {
                    Caption = 'Number Series';
                    Image = Setup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "No. Series";
                }
                action("Analysis Views")
                {
                    Caption = 'Analysis Views';
                    RunObject = Page "Analysis View List";
                }
                action("Account Schedules")
                {
                    Caption = 'Account Schedules';
                    RunObject = Page "Account Schedule Names";
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                }
                action("Bank Account Posting Groups")
                {
                    Caption = 'Bank Account Posting Groups';
                    RunObject = Page "Bank Account Posting Groups";
                }
            }
            group(ActionGroup127)
            {
                Caption = 'Material Requisition';
                Image = FixedAssets;
                action("Prod. Material Requisition ")
                {
                    Caption = 'Prod. Material Requisition ';
                    RunObject = Page "Schedule Requisition List";
                }
            }
        }
        area(creation)
        {
            action("Sales &Credit Memo")
            {
                Caption = 'Sales &Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Credit Memo";
                RunPageMode = Create;
            }
            action("Sales Invoices")
            {
                RunObject = Page "Sales Invoice List";
            }
        }
        area(processing)
        {
            separator(Separator67)
            {
            }
            action("Analysis &Views")
            {
                Caption = 'Analysis &Views';
                Image = AnalysisView;
                RunObject = Page "Analysis View List";
            }
            action("Analysis by &Dimensions")
            {
                Caption = 'Analysis by &Dimensions';
                Image = AnalysisViewDimension;
                RunObject = Page "Analysis by Dimensions";
            }
            action("Import Co&nsolidation from Database")
            {
                Caption = 'Import Co&nsolidation from Database';
                Ellipsis = true;
                Image = ImportDatabase;
                RunObject = Report "Import Consolidation from DB";
            }
            action("Adjust E&xchange Rates")
            {
                Caption = 'Adjust E&xchange Rates';
                Ellipsis = true;
                Image = AdjustExchangeRates;
                RunObject = Report "Adjust Exchange Rates";
            }
            action("P&ost Inventory Cost to G/L")
            {
                Caption = 'P&ost Inventory Cost to G/L';
                Image = PostInventoryToGL;
                RunObject = Report "Post Inventory Cost to G/L";
            }
            action("Production Order Re-Open")
            {
                Caption = 'Production Order Re-Open';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Change RPO Status";
            }
            separator(Vouchers)
            {
                Caption = 'Vouchers';
                IsHeader = false;
            }
            action("GRN Not Invoiced")
            {
                Promoted = true;
                RunObject = Page "Posted Purchase Rcpt. Subform";
                RunPageView = ORDER(Ascending)
                              WHERE ("Qty. Rcd. Not Invoiced" = FILTER (<> 0));
            }
            action("Item Journal")
            {
                RunObject = Page "Item Journal";
            }
            action("Bank Payment Voucher")
            {
                RunObject = Page "Bank Payment Voucher";
            }
            action("Bank Receipt Voucher")
            {
                RunObject = Page "Bank Receipt Voucher";
            }
            action("Contra Voucher")
            {
                RunObject = Page "Contra Voucher";
            }
            action("Purchase Planning")
            {
                RunObject = Page "Samadhan Purchase Planing";
            }
            action("Short Closed PO")
            {
                RunObject = Page "Short Closed Purchase Order";
            }
            action("Released Prod Order")
            {
                RunObject = Page "Released Production Orders";
            }
            action("Finished Prod Order")
            {
                RunObject = Page "Finished Production Orders";
            }
            action("Journal Voucher")
            {
                RunObject = Page "Journal Voucher";
            }
            separator(Separator97)
            {
            }
            action("C&reate Reminders")
            {
                Caption = 'C&reate Reminders';
                Ellipsis = true;
                Image = CreateReminders;
                RunObject = Report "Create Reminders";
                Visible = false;
            }
            action("Create Finance Charge &Memos")
            {
                Caption = 'Create Finance Charge &Memos';
                Ellipsis = true;
                Image = CreateFinanceChargememo;
                RunObject = Report "Create Finance Charge Memos";
                Visible = false;
            }
            separator(Separator73)
            {
            }
            separator(Separator80)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("General &Ledger Setup")
            {
                Caption = 'General &Ledger Setup';
                Image = Setup;
                RunObject = Page "General Ledger Setup";
            }
            action("Inventory Period")
            {
                Caption = 'Inventory Period';
                RunObject = Page "Inventory Periods";
            }
            action("&Sales && Receivables Setup")
            {
                Caption = '&Sales && Receivables Setup';
                Image = Setup;
                RunObject = Page "Sales & Receivables Setup";
            }
            action("&Purchases && Payables Setup")
            {
                Caption = '&Purchases && Payables Setup';
                Image = Setup;
                RunObject = Page "Purchases & Payables Setup";
            }
            action("Inventory Setup")
            {
                Caption = 'Inventory Setup';
                Image = Setup;
                RunObject = Page "Inventory Setup";
            }
            action("User Setup")
            {
                Caption = 'User Setup';
                Image = Setup;
                RunObject = Page "User Setup";
            }
            action("Inventory Posting Setup")
            {
                Image = Setup;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Inventory Posting Setup";
            }
            action("General Posting Setup")
            {
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "General Posting Setup";
            }
            action("Cost Accounting Setup")
            {
                Caption = 'Cost Accounting Setup';
                Image = CostAccountingSetup;
                RunObject = Page "Cost Accounting Setup";
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

