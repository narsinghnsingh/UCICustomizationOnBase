page 50093 "General Manager Role Center"
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
                part(Control1905113808; "Production Planner Activities")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control54; "My Job Queue")
                {
                    Visible = false;
                }
                systempart(Control1901377608; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Customer Order Details")
            {
                RunObject = Report "Customer - Order Detail";
            }
            action("Customer Item Details")
            {
                RunObject = Report "Customer Items Details";
            }
            action("Daily Booking/Sales Register")
            {
                RunObject = Report "Daily Booking/Sales Register";
            }
            action("Booking/Sales Summary Details")
            {
                RunObject = Report "WIP Stocks";
            }
            action("Finished Goods Details")
            {
                RunObject = Report "Finished Goods Details";
            }
            action("Pending Job Summary")
            {
                RunObject = Report "Pending Job Summary";
            }
            action("Invoice Brief")
            {
                RunObject = Report "Additional Cost ChargeAssignmt";
            }
            action("Customer Wise DO Details")
            {
                RunObject = Report FG;
            }
            action("Delivery Order Dispatched List")
            {
                RunObject = Report "Delivery Order Dispatched List";
            }

            action("Customer List")
            {
                Image = "Report";
                RunObject = Report "Customer - List";
            }
            action("Customer Item Sales")
            {
                Image = "Report";
                RunObject = Report "Customer/Item Sales";
            }
            action("Sales Register with Average")
            {
                Image = "Report";
                RunObject = Report "Sales Register with Average";
            }
            action("Customer - &Balance to Date")
            {
                Caption = 'Customer - &Balance to Date';
                Image = "Report";
                RunObject = Report "Customer - Balance to Date";
            }
            action("Aged &Accounts Receivable")
            {
                Caption = 'Aged &Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Customer - &Summary Aging Simp.")
            {
                Caption = 'Customer - &Summary Aging Simp.';
                Image = "Report";
                RunObject = Report "Customer - Summary Aging Simp.";
            }
            action("Customer - Trial Balan&ce")
            {
                Caption = 'Customer - Trial Balan&ce';
                Image = "Report";
                RunObject = Report "Customer - Trial Balance";
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
            action("Production Order Wise Status")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Production Order wise status";
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
            action("Production & Sales Summary")
            {
                Caption = 'Production & Sales Summary';
                Image = Print;
                RunObject = Report "Production and Sales SummaryN";
            }
        }
        area(embedding)
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
            action("Released Production Orders")
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
            action("Finished Production Orders")
            {
                Caption = 'Finished Production Orders';
                RunObject = Page "Finished Production Orders";
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

            action("Pending Purch. Requistion List")
            {
                RunObject = Page "Pending Purch. Requistion List";
            }
            action("Pending Return Item Packing List")
            {
                RunObject = Page "Pending Return Item Pack List";
            }
            action("All Product Design List")
            {
                Caption = 'All Approved Product Design';
                RunObject = Page "Product Design List";
            }
        }
        area(sections)
        {
            group("Product Design")
            {
                Caption = 'Product Design';
                Image = ProductDesign;
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
                action(Routings)
                {
                    Caption = 'Routings';
                    RunObject = Page "Routing List";
                }
                action("Routing Links")
                {
                    Caption = 'Routing Links';
                    RunObject = Page "Routing Links";
                }
                action("Standard Tasks")
                {
                    Caption = 'Standard Tasks';
                    RunObject = Page "Standard Tasks";
                }
            }
            group(Capacities)
            {
                Caption = 'Capacities';
                Image = Capacities;
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
                action("Machine Centers")
                {
                    Caption = 'Machine Centers';
                    RunObject = Page "Machine Center List";
                }
            }
        }
        area(creation)
        {
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            separator(Separator45)
            {
            }
            separator(Administration)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("&Manufacturing Setup")
            {
                Caption = '&Manufacturing Setup';
                Image = ProductionSetup;
                RunObject = Page "Manufacturing Setup";
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

