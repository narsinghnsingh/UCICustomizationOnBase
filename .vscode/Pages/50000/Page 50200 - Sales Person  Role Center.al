page 50200 "Sales Person  Role Center"
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
                // part(Control21;"Connect Online")
                // {
                // }
                part(Control1907692008; "My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                systempart(d; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("All Plate Status")
            {
                Image = Form;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "All Plate Status";
            }
            action("Item List ")
            {
                Image = Item;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Item List";
            }
            action("List of Pending Job")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "List of Pending Job_New";
            }
            action(Statement)
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 50112;
            }
            action("Sales Register ")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Sales Register";
            }
            separator(Separator17)
            {
            }
            action("Daily Booking / Sales Regsiter")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Daily Booking/Sales Register";
            }
            action("Jobwise Material Status")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Jobwise material status";
            }
            action("Daily Production Status")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Daily Production Status";
            }
            action("Customer Detail Trail")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Customer - Detail Trial Bal.";
            }
        }
    }
}

