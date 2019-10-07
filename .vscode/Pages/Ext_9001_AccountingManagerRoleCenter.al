pageextension 50040 Ext_9001_AccountManaRolCenter extends "Accounting Manager Role Center"
{
    actions
    {
        // Add changes to page actions here
        addbefore("&G/L Trial Balance")
        {
            action(Action146)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Phy.  Inventories';
                RunObject = Page "Phys. Inventory Journal";
                trigger OnAction()
                begin

                end;
            }
            action(Action147)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Revaluation Journal';
                RunObject = Page "Revaluation Journal";
                Promoted = true;
                Image = AdjustEntries;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
            action(Action171)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Released Production Orders';
                RunObject = Page "Released Production Orders";
                Promoted = true;
                Image = OpenJournal;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }
            action(Action182)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Finished Production Orders';
                RunObject = Page "Finished Production Orders";
                Promoted = true;
                Image = OpenJournal;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }

        }
        addbefore(Action49)
        {
            group(ActionGroup160)
            {
                CaptionML = ENU = 'Reports';
                Image = Sales;
                group(Action120)
                {
                    CaptionML = ENU = 'Reports';
                    Image = Sales;
                    action(Action173)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'VAT Entries';
                        Promoted = true;
                        PromotedIsBig = true;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Report Calc. and Post VAT Settlement")
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Report Calc. and Post VAT Settlement';
                        RunObject = Report "Calc. and Post VAT Settlement";
                        Promoted = false;
                        Image = Report;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Paper Aging Inventory")
                    {
                        ApplicationArea = All;

                        Ellipsis = true;
                        CaptionML = ENU = 'Paper Aging Inventory';
                        RunObject = Report 50073;
                        Promoted = false;
                        Image = Report;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Daily Printing Status")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50092;
                        Image = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Daily Production Status")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50013;
                        Image = Report;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action(Action166)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Sales Register';
                        RunObject = Report 50007;
                        Image = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Production Sale Summary")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50091;
                        Promoted = true;
                        Image = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action(Action163)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Ink & Pallet Report';
                        RunObject = Report 50041;
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = Report;
                        PromotedCategory = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Die Impression Report")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50027;
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = Report;
                        PromotedCategory = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Block Impression Report")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50017;
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = Report;
                        PromotedCategory = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }

        }
        addafter("VAT - VIES Declaration Dis&k")
        {
            action("Inventory Valuation Report")
            {
                ApplicationArea = All;
                RunObject = Report 1001;
                Image = Print;
                trigger OnAction()
                begin

                end;
            }
        }
        addafter("Intrastat - For&m")
        {
            action("Purchase Register")
            {
                ApplicationArea = All;
                RunObject = Report 50020;
                Image = Print;
                trigger OnAction()
                begin

                end;
            }
        }
        addafter("Cost Accounting Analysis")
        {
            group(Action162)
            {
                CaptionML = ENU = 'Reports';
                group(Reports)
                {
                    CaptionML = ENU = 'Reports';
                    Image = Report;
                    action("Ageing Report for paper")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50073;
                        Promoted = true;
                        Image = Print;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Stock Report Width Wise")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50051;
                        Image = Print;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Pending Order Summary")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50061;
                        Image = Print;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Stock Consumption Report")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50045;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Monthly Issue/Return/Consp.")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50075;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Paper Ageing Inventory")
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'PaperAgeingInventory';
                        RunObject = Report 50073;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("JobWise Material Status Summary")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50015;
                        Image = Print;
                        trigger OnAction()
                        begin

                        end;
                    }
                    separator("------")
                    {

                    }
                    action("JobWise Costing")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50028;
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = Report;
                        PromotedCategory = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Production Wise Status")
                    {
                        ApplicationArea = All;
                        RunObject = Page 50186;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("New Ledger Report")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50069;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Pending Job Details")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50084;
                        Promoted = true;
                        Image = Report2;
                        PromotedCategory = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action(Action159)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Block Die Charges Report';
                        RunObject = Report 50002;
                        Image = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("FG Detail Report")
                    {
                        ApplicationArea = All;
                        RunObject = Page 740;
                        Promoted = true;
                        Image = Report2;
                        PromotedCategory = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Inventory Report New")
                    {
                        ApplicationArea = All;
                        RunObject = Report 50080;
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = Report2;
                        PromotedCategory = Report;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action(Action149)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Production Variation Report';
                        RunObject = Page "Employee List";
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = WIPEntries;
                        PromotedCategory = Process;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action(Action150)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Product Design List';
                        RunObject = Page 50000;
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = Design;
                        PromotedCategory = Process;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action(Action151)
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'Machine Center';
                        RunObject = Page 99000761;
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = MachineCenter;
                        PromotedCategory = Process;
                        trigger OnAction()
                        begin

                        end;
                    }
                    action("JOB CARD CORRUGATION Actual")
                    {
                        ApplicationArea = All;
                        CaptionML = ENU = 'JOB CARD CORRUGATION Actual';
                        RunObject = Report "JOB CARD CORRUGATION Actual";
                        Promoted = true;
                        PromotedIsBig = true;
                        Image = MachineCenter;
                        PromotedCategory = Process;
                    }
                }
            }
        }
        addafter(Vendors)
        {
            action("Sales Invoice List")
            {
                ApplicationArea = All;
                RunObject = Page "Sales Invoice List";
                trigger OnAction()
                begin

                end;
            }
            action("Purchase Credit Memo List")
            {
                ApplicationArea = All;
                RunObject = Page "Purchase Credit Memos";
                trigger OnAction()
                begin

                end;
            }
            action("Purchase Return List")
            {
                ApplicationArea = All;
                RunObject = Page "Purchase Return Order List";
                trigger OnAction()
                begin

                end;
            }
            action("General Ledger Entries")
            {
                ApplicationArea = All;
                RunObject = Page "General Ledger Entries";
                trigger OnAction()
                begin

                end;
            }

        }
        addafter("Purchase Orders")
        {
            action("Transfer Order")
            {
                ApplicationArea = All;
                RunObject = Page "Transfer Orders";
                trigger OnAction()
                begin

                end;
            }
            action("LC Detail List")
            {
                ApplicationArea = All;
                RunObject = Page 50134;
                trigger OnAction()
                begin

                end;
            }
        }
        addafter("Incoming Documents")
        {
            action("Material Requisition")
            {
                ApplicationArea = All;
                RunObject = Page 50147;
                trigger OnAction()
                begin

                end;
            }
            action("Active Session")
            {
                ApplicationArea = All;
                RunObject = Page 50184;
                trigger OnAction()
                begin

                end;
            }
            action("All Prod Orders")
            {
                ApplicationArea = All;
                RunObject = Page "Production Order List";
                trigger OnAction()
                begin

                end;
            }
            action(PDC)
            {
                ApplicationArea = All;
                RunObject = Page 50082;
                trigger OnAction()
                begin

                end;
            }
        }
        addafter("Posted Purchase Invoices")
        {
            action("Posted Purchase Receipts")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Posted Purchase Receipts';
                RunObject = Page "Posted Purchase Receipts";
                trigger OnAction()
                begin

                end;
            }
        }
        addbefore(Action97)
        {
            group(Activties)
            {
                CaptionML = ENU = 'Tasks';
                Image = Production;
                group("General Task")
                {
                    CaptionML = ENU = 'General Tasks';
                    Image = TaskList;
                    action("Production Order Re-Open")
                    {
                        RunObject = Page "Change RPO Status";
                        Image = Undo;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = True;
                        Visible = false;
                    }
                    action("GRN Not Invoiced")
                    {
                        RunObject = page "Posted Purchase Rcpt. Subform";
                        RunPageView = ORDER(Ascending) WHERE ("Qty. Rcd. Not Invoiced" = FILTER (<> 0));
                        Promoted = true;
                    }
                    action("Output Journal-Corrugation ")
                    {
                        RunObject = page "Output Journal-CORRUGATION";
                    }
                    action("Output Jopurnal-Printing")
                    {
                        RunObject = page "Output Journal";
                    }
                    action("Output Jopurnal-Finishing")
                    {
                        RunObject = page "Output Journal-FINISHING";
                    }
                    action("Cash Payment Voucher")
                    {
                        RunObject = page "Cash Payment Voucher";
                    }
                    action("Cash Receipt Voucher")
                    {
                        RunObject = page "Cash Receipt Voucher";
                    }
                    action("Bank Payment Voucher")
                    {
                        RunObject = page "Bank Payment Voucher";
                    }
                    action("Bank Receipt Voucher")
                    {
                        RunObject = page "Bank Receipt Voucher";
                    }
                    action("Contra Voucher")
                    {
                        RunObject = page "Contra Voucher";
                    }
                    action("Purchase Planning")
                    {
                        RunObject = page "Samadhan Purchase Planing";
                    }
                    action("Pending for Approval Purch. Req")
                    {
                        RunObject = page "Pending Purch. Requistion List";
                    }
                    action("Short Closed PO")
                    {
                        RunObject = page "Short Closed Purchase Order";
                    }
                    action("Released Production Orders")
                    {
                        RunObject = Page "Released Production Orders";
                    }
                    action("Finished Production Orders")
                    {
                        RunObject = Page "Finished Production Orders";
                    }
                    action("Journal voucher")
                    {
                        RunObject = page "Journal Voucher";
                    }
                }
            }
        }
    }

}