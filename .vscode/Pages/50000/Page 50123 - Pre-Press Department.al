page 50123 "Pre-Press Department"
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
                part(Control1901851508;"SO Processor Activities")
                {
                    AccessByPermission = TableData "Sales Shipment Header"=R;
                    Visible = false;
                }
                part(Control1907692008;"My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                systempart(Control1901377608;MyNotes)
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
            action("Product Design List")
            {
                Caption = 'Product Design List';
                RunObject = Page "Pre Press Product Design List";
                RunPageView = SORTING("Product Design Type","Product Design No.","Sub Comp No.")
                              ORDER(Ascending)
                              WHERE("Product Design Type"=CONST(Main),
                                    Status=FILTER(Open|Approved),
                                    "Pre-Press Status"=FILTER("Update Pending from Pre-Press "));
            }
            action("Flexo Plate & Die Creation List")
            {
                RunObject = Page "Pre Press Product Design List";
                RunPageView = WHERE("Plate Required"=CONST(true),
                                    Status=FILTER(Open|Approved),
                                    "Pre-Press Status"=CONST("Updated & Confirmed"),
                                    "Plate Item No."=FILTER(=''));
            }
            action("Pending Plates")
            {
                RunObject = Page "Pending Plates";
            }
            action("All Plate Status")
            {
                RunObject = Page "All Plate Status";
            }
            action("Die List")
            {
                RunObject = Page "Die Master";
            }
            action("Purchase order")
            {
                Caption = 'Purchase Order';
                Image = ReturnOrder;
                RunObject = Page "Purchase Order List";
            }
            action("Purchase Requisition List")
            {
                RunObject = Page "Purchase Requisition List";
            }
            action("Sales Order")
            {
                RunObject = Page "LPO Scan Sales Order List";
            }
            action("Material Requisition List")
            {
                RunObject = Page "Schedule Requisition List";
            }
        }
        area(sections)
        {
            group(Setup)
            {
                Caption = 'Setup';
                Image = FiledPosted;
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
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
        }
    }
}

