page 50122 "Quality Department"
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
                part(Control1901851508; "SO Processor Activities")
                {
                    AccessByPermission = TableData "Sales Shipment Header" = R;
                    Visible = false;
                }
                part(Control1907692008; "My Customers")
                {
                }
                part(Control25; "Production Order ListPart")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
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
            action("Finished Goods Details")
            {
                RunObject = Report "Finished Goods Details";
            }
            separator(Separator17)
            {
            }
            action("Delivery Order Dispatched List")
            {
                RunObject = Report "Delivery Order Dispatched List";
            }
            action("Customer Wise DO Details")
            {
                RunObject = Report FG;
            }
            action("Die Impression Report")
            {
                RunObject = Report "Die Impression Report";
            }
            action("Block Impression Report")
            {
                RunObject = Report "Block  Impression Report";
            }
        }
        area(embedding)
        {
            action("Product Design List ")
            {
                RunObject = Page "Product Design List";
            }
            action("Pre Press Product Design List")
            {
                Caption = 'Pre Press Product Design List';
                RunObject = Page "Pre Press Product Design List";
                RunPageView = ORDER(Ascending)
                              WHERE ("Product Design Type" = CONST (Main),
                                    Status = FILTER (Open | Approved),
                                    "Pre-Press Status" = FILTER ("Update Pending from Pre-Press "));
            }
            action("Quality Inspection Paper")
            {
                RunObject = Page "Quality Purchase Receipts_PAPE";
            }
            action("Quality Inspection Others")
            {
                RunObject = Page "Quality Purchase Receipts_OTHE";
            }
            action("Material Requisition List")
            {
                RunObject = Page "Purchase Requisition List";
            }
            action("Quality Inspection FG")
            {
                Caption = 'Quality Inspection FG';
                Image = ReturnOrder;
                RunObject = Page "Inspection List";
            }
            action("Flexo Plate & Die Creation List")
            {
                RunObject = Page "Pre Press Product Design List";
                RunPageView = WHERE ("Plate Required" = CONST (true),
                                    Status = FILTER (Open | Approved),
                                    "Pre-Press Status" = CONST ("Updated & Confirmed"),
                                    "Plate Item No." = FILTER (= ''));
            }
            action("Pending Plates")
            {
                RunObject = Page "Pending Plates";
            }
            action("All Plate Status")
            {
                RunObject = Page "All Plate Status";
            }
            action("Sales Return Order List")
            {
                Caption = 'Sales Return Order List';
                RunObject = Page "Sales Return Order List";
            }
            action("Die List")
            {
                RunObject = Page "Die Master";
            }
            action("In-Progress Production Orders")
            {
                RunObject = Page "Released Production Orders";
                RunPageView = WHERE ("Prod Status" = CONST ("In process"));
            }
            action("FG Item List")
            {
                Caption = 'FG Item List';
                RunObject = Page "Item List";
                RunPageLink = "Item Category Code" = CONST ('FG');
            }
            action("Sales Order")
            {
                Caption = 'Sales Order (LPO)';
                RunObject = Page "LPO Scan Sales Order List";
            }
            action("Finished Production Orders")
            {
                RunObject = Page "Finished Production Orders";
            }
        }
        area(sections)
        {
            group(Setup)
            {
                Caption = 'Setup';
                Image = FiledPosted;
                action("Quality Parameter")
                {
                    Caption = 'Quality Parameter';
                    Image = PostedShipment;
                    RunObject = Page "Quality Parameters";
                }
                action("Item Specification")
                {
                    RunObject = Page "FG Item Quality Specification ";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Inspection FG")
                {
                    Caption = 'Posted Inspection FG';
                    Image = PostedShipment;
                    RunObject = Page "Posted Inspection List";
                }
                action("Posted Quality All")
                {
                    Caption = 'Posted Quality All';
                    Image = PostedOrder;
                    RunObject = Page "Posted Quality All";
                }
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            separator(Separator42)
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
            action("FG List")
            {
                Caption = 'FG List';
            }
            action("Material Re Class Journal")
            {
                Caption = 'Material Re Class Journal';
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Quality Reclass. Journal";
            }
            action("Scrap Journal")
            {
                RunObject = Page "Scrap Journal";
            }
        }
    }
}

