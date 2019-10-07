page 50231 "Printing Operator Role Center"
{
    // version NAVW18.00

    Caption = 'Printing Operator Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control18)
            {
                ShowCaption = false;
                systempart(Control17; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("Requisition List")
            {
                Caption = 'Requisition List';
                RunObject = Page "Purchase Requisition List";
            }
            action("<Page Raw material list>")
            {
                Caption = ' Raw material list';
                RunObject = Page "Item List";
            }
            action("Production Requisition List")
            {
                Caption = 'Production Requisition List';
                RunObject = Page "Schedule Requisition List";
            }
            action("Published Production Schedule")
            {
                RunObject = Page "Published Schedule List";
            }
            action("Posted Sales Invoices")
            {
                Caption = 'Posted Sales Invoices';
                RunObject = Page "Posted Sales Invoices";
            }
            action("Pending Purch. Requistion List")
            {
                RunObject = Page "Pending Purch. Requistion List";
            }
            action("Pending Return Item Packing List")
            {
                RunObject = Page "Pending Return Item Pack List";
            }
            action("Equipment List")
            {
                Caption = 'Equipment List';
                RunObject = page "Equipment List";
            }
            action("Breakdown Registration")
            {
                Caption = 'Breakdown Registration';
                RunObject = page "Breakdown List";
            }
        }
        area(creation)
        {
            action("Output Journal-Corrugation")
            {
                RunObject = Page "Output Journal-CORRUGATION";
            }
            action("Output Jopurnal-Printing")
            {
                RunObject = Page "Output Journal";
            }
            action("Output Journal-Finishing")
            {
                RunObject = Page "Output Journal-FINISHING";
            }
            action("Production Order Status")
            {
                RunObject = Page "Production Order wise status";
            }
            action("Production Order Wise Status")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Production Order wise status";
            }
            action("Daily Production Status Report")
            {
                Image = "Report";
                RunObject = Report "Daily Production Status";
            }
            action("Daily Printing Status Report")
            {
                Image = "Report";
                RunObject = Report "Daily Production Printing";
            }
        }
    }
}

