page 50229 "Procurement Manager"
{
    // version NAVW18.00

    Caption = 'Procurement Manager';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control1907662708; "Purchase Agent Activities")
                {
                }
                part(Control1902476008; "My Vendors")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control25; "Purchase Performance")
                {
                    Visible = false;
                }
                part(Control37; "Purchase Performance")
                {
                    Visible = false;
                }
                part(Control21; "Inventory Performance")
                {
                    Visible = false;
                }
                part(Control44; "Inventory Performance")
                {
                    Visible = false;
                }
                part(Control45; "Report Inbox Part")
                {
                    Visible = false;
                }
                part(Control35; "My Job Queue")
                {
                    Visible = false;
                }
                part(Control1905989608; "My Items")
                {
                }
                // part(Control1903012608; "Connect Online")
                // {
                //     Visible = false;
                // }
                systempart(Control43; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
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
            action("Vendor - T&op 10 List")
            {
                Caption = 'Vendor - T&op 10 List';
                Image = "Report";
                RunObject = Report "Vendor - Top 10 List";
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
            action("Vendor/&Item Purchases")
            {
                Caption = 'Vendor/&Item Purchases';
                Image = "Report";
                RunObject = Report "Vendor/Item Purchases";
            }
            separator(Separator28)
            {
            }
            action("Inventory - &Availability Plan")
            {
                Caption = 'Inventory - &Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Inventory &Purchase Orders")
            {
                Caption = 'Inventory &Purchase Orders';
                Image = "Report";
                RunObject = Report "Inventory Purchase Orders";
            }
            action("Inventory - &Vendor Purchases")
            {
                Caption = 'Inventory - &Vendor Purchases';
                Image = "Report";
                RunObject = Report "Inventory - Vendor Purchases";
            }
            action("Item Issued Details")
            {
                Image = Print;
                Promoted = true;
                RunObject = Report "Item Issued Report";
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
        area(embedding)
        {
            action("Purchase Orders")
            {
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action("Pending Confirmation")
            {
                Caption = 'Pending Confirmation';
                RunObject = Page "Purchase Order List";
                RunPageView = WHERE (Status = FILTER (Open));
            }
            action("Partially Delivered")
            {
                Caption = 'Partially Delivered';
                RunObject = Page "Purchase Order List";
                RunPageView = WHERE (Status = FILTER (Released),
                                    Receive = FILTER (true),
                                    "Completely Received" = FILTER (false));
            }
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
            action("Purchase Quotes")
            {
                Caption = 'Purchase Quotes';
                RunObject = Page "Purchase Quotes";
            }
            action("Blanket Purchase Orders")
            {
                Caption = 'Blanket Purchase Orders';
                RunObject = Page "Blanket Purchase Orders";
            }
            action("Material Receipt Window")
            {
                RunObject = Page "GRN List";
            }
            action("Purchase Return Orders")
            {
                Caption = 'Purchase Return Orders';
                RunObject = Page "Purchase Return Order List";
            }
            action("Purchase Credit Memos")
            {
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE ("Replenishment System" = CONST (Purchase),
                                    "Production BOM No." = FILTER (''));
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
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Return Shipments")
                {
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
            }
        }
        area(creation)
        {
            action("Purchase &Quote")
            {
                Caption = 'Purchase &Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Quote";
                RunPageMode = Create;
            }
            action("Purchase &Order")
            {
                Caption = 'Purchase &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
            action("Purchase &Return Order")
            {
                Caption = 'Purchase &Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Return Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
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
            action("Purchase Planning")
            {
                Caption = 'Purchase Planning';
                Image = Planning;
                RunObject = Page "Samadhan Purchase Planing";
            }
            separator(Separator38)
            {
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
            action(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page Dimensions;
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

