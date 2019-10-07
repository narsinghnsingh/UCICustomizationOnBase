pageextension 50045 Ext_9010_ProdPlannRoleCenter extends "Production Planner Role Center"
{
    layout
    {
        // Add changes to page layout here        
    }

    actions
    {
        addafter("Inventory &Valuation WIP")
        {
            group("Prodution Reports List")
            {
                CaptionML = ENU = 'Production Reports List';
                Image = Report;
                action("Daily Production Status")
                {
                    RunObject = Report "Daily Production Status";
                }
                action("Daily Printing Status")
                {
                    RunObject = Report "Daily Production Printing";
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
                action("Inventory Valuation Report")
                {
                    Image = "Report";
                    RunObject = Report "Inventory Valuation";
                }
                action("Production Order Wise Status")
                {
                    RunObject = Page "Production Order wise status";
                    Promoted = true;
                }
                action("Stock Details Reel Wise")
                {
                    RunObject = Report PaperAgeingInventory;
                    Promoted = true;
                }
                action("Pending Job details")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "List of Pending Job_New";
                }
                action("Ink & Pallat Report")
                {
                    Caption = 'Ink & Pallat Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Inks & Pallet Report";
                }
                action("Finished Goods Details")
                {
                    RunObject = Report "Finished Goods Details";
                }
                action("Paper Stock Details Report")
                {
                    RunObject = Report "Stock Abstract Details";
                }
                action("Stock Consumption Report")
                {
                    RunObject = Report "Stock Consumption";
                }
                action("Monthly Issue/Return/Consp.")
                {
                    RunObject = Report "Monthly Issue/Return/Consp.";
                }
                action("Customer Order Details")
                {
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "Customer - Order Detail";
                }
                action("FG Detail Report")
                {
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Page "FG Report";
                }
                action("WIP Stock")
                {
                    Caption = 'WIP Stock';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "WIP Stocks";
                }

                action("Jobwise Summary")
                {
                    CaptionML = ENU = 'Jobwise Summary Report';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    RunObject = Report "JobWise Summary";
                }
                action("Production & Sales Summary")
                {
                    Caption = 'Production & Sales Summary';
                    Image = Print;
                    RunObject = Report "Production and Sales SummaryN";
                }
            }
        }
        addlast(Embedding)
        {
            action("Production Items")
            {
                Caption = 'Production Items';
                RunObject = Page "Item List";
                RunPageView = WHERE ("Replenishment System" = CONST ("Prod. Order"));
            }
            action("Raw Material Items")
            {
                Caption = 'Raw Material Items';
                RunObject = Page "Item List";
                RunPageView = WHERE ("Replenishment System" = CONST (Purchase),
                                    "Production BOM No." = FILTER (= ''));
            }
            action("All Product Designs")
            {
                CaptionML = ENU = 'All Product Design List';
                RunObject = page "Product Design List";
            }
            action("Product Design List")
            {
                CaptionML = ENU = 'Production Product Design List';
                RunObject = Page "Production Product Design List";
            }
            action("New RPO Creation List")
            {
                RunObject = Page "Product Design List";
                RunPageView = ORDER(Ascending)
                              WHERE (Status = CONST (Approved),
                                    "Prod. Order Exists" = CONST (false));
            }
            action("Released Production Orders1")
            {
                Caption = 'Released Production Orders';
                RunObject = Page "Released Production Orders";
                RunPageView = WHERE (Status = CONST (Released),
                                    "Prod Status" = CONST (New));

            }

            action("In-Progress Production Orders")
            {
                RunObject = Page "Released Production Orders";
                RunPageView = WHERE ("Prod Status" = CONST ("In process"));
            }
            action("Production Scheduling")
            {
                RunObject = Page "Corr. Schedule List";
            }
            action("Published Production Scheduling ")
            {
                RunObject = Page "Published Schedule List";
            }

            action("Material Requisition List")
            {
                RunObject = Page "Schedule Requisition List";
            }
            action("Purchase Requisition List")
            {
                RunObject = Page "Purchase Requisition List";
            }
            action("Production Order Status")
            {
                RunObject = Page "Production Order Status";
            }
            action("Work Center Status")
            {
                RunObject = Page "Work Center Status";
            }
            action("Sales Order Details")
            {
                RunObject = Page "LPO Detail for Production";
            }
            action("All Product Design List")
            {
                Caption = 'All Approved Product Design';
                RunObject = Page "Product Design List";
                RunPageView = WHERE (Status = CONST (Approved));
                Visible = false;
            }
            action("Packing List")
            {
                RunObject = Page "Packing List";
            }
            action("Sales Dispatch List")
            {
                RunObject = Page "Sales Dispatch list";
            }
            action("Open Product Design List")
            {
                RunObject = Page "Product Design List";
            }
            action("Prod. Order Routing (Update WIP)")
            {
                RunObject = Page "Prod. Order Routing WIP Print";
            }
            action("Sales Order")
            {
                Caption = 'Sales Order (LPO)';
                RunObject = Page "LPO Scan Sales Order List";
            }
        }
        addlast("Product Design")
        {
            action("Model Master")
            {
                RunObject = Page "Product Design Model List";
            }
            action("Production BOM")
            {
                Caption = 'Production BOM';
                Image = BOM;
                RunObject = Page "Production BOM List";
            }
            action(Certified)
            {
                Caption = 'Certified';
                RunObject = Page "Production BOM List";
                RunPageView = WHERE (Status = CONST (Certified));
            }

            action("Work Centers")
            {
                Caption = 'Work Centers';
                RunObject = Page "Work Center List";
            }
            action(Internal)
            {
                Caption = 'Internal';
                Image = Comment;
                RunObject = Page "Work Center List";
                RunPageView = WHERE ("Subcontractor No." = FILTER (= ''));
            }
            action(Subcontracted)
            {
                Caption = 'Subcontracted';
                RunObject = Page "Work Center List";
                RunPageView = WHERE ("Subcontractor No." = FILTER (<> ''));
            }
        }
        addafter("&Purchase Order")
        {

            action("Repeat Job Creation")
            {
                RunObject = Page "Repeat Job Creation";
            }
            action("Output Journal-Corrugation ")
            {
                RunObject = Page "Output Journal-CORRUGATION";
            }
            action("Output Jopurnal-Printing")
            {
                Caption = 'Output Journal- Printing';
                RunObject = Page "Output Journal";
            }
            action("Output Journal-Finishing")
            {
                RunObject = Page "Output Journal-FINISHING";
            }
            action("Consumption Journal")
            {
                RunObject = Page "Consumption Journal";
            }
            action("Output Journal-Board Swap")
            {
                RunObject = Page "Output Journal Board Swap";
            }
            action("Item Journal")
            {
                RunObject = Page "Item Journal";
            }

            action("Corrugation Load Sheet")
            {
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Load In Corrugation";
            }
            action("Printing Load Sheet")
            {
                Caption = 'Printing Load Sheet';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Load In Printing";
            }
            action("Sales Order Wise status")
            {
                Caption = 'Sales Order Wise status';
                RunObject = Page "Sales  Order wise status";
            }
        }
    }
}