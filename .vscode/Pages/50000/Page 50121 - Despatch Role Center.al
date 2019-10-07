page 50121 "Despatch Role Center"
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
            action("Customer Wise DO Details")
            {
                RunObject = Report FG;
            }
            action("Daily Production Status Report")
            {
                RunObject = Report "Daily Production Status";
            }
            action("Delivery Order Dispatched List")
            {
                Caption = 'Delivery Order Dispatched List';
                Image = "Report";
                RunObject = Report "Delivery Order Dispatched List";
            }
            action("Production Order Wise Status")
            {
                RunObject = Page "Production Order wise status";
            }
            action("JobWise Material Report")
            {
                Caption = 'JobWise Material Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Jobwise material status";
            }
            action("JobWise Material Summary")
            {
                Caption = 'JobWise Material Summary ';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Jobwise material statusSummar";
            }
            action("Customer Invoice Detail")
            {
                RunObject = Report "Product Dev. Details";
            }
            action("Pending Job Details")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "List of Pending Job";
            }
            action("Packing List")
            {
                RunObject = Page "Packing List";
            }
            action("Output Journal Printing")
            {
                Caption = 'Output Journal Printing';
                RunObject = Page "Output Journal";
            }
            action("Output Journal Corrugation")
            {
                RunObject = Page "Output Journal-CORRUGATION";
            }
            action(" Published Schedule List")
            {
                Caption = ' Published Schedule List';
                RunObject = Page "Published Schedule List";
            }
        }
        area(embedding)
        {
            action("RPO Wise packing Status")
            {
                RunObject = Page "Packing List Quantity";
            }
            action("Sales Dispatch List")
            {
                RunObject = Page "Sales Dispatch list";
            }
            action("Sales Return Orders")
            {
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page "Sales Return Order List";
            }
            action("Short Closed Sales Order")
            {
                RunObject = Page "Short Closed Sales Order";
            }
            action("Material Requisition List")
            {
                RunObject = Page "Purchase Requisition List";
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Shipments")
                {
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                }
            }
        }
        area(creation)
        {
            action("Sales &Return Order")
            {
                Caption = 'Sales &Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Return Order";
                RunPageMode = Create;
            }
            action("Output Journal - Finishing")
            {
                RunObject = Page "Output Journal-FINISHING";
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
            action("Packing List N")
            {
                Caption = 'Packing List';
                Image = PickWorksheet;
                Promoted = true;
                RunObject = Page "Packing List";
            }
        }
    }
}

