pageextension 50080 Ext_9013_MachineOpRoleCenter extends "Machine Operator Role Center"
{
    layout
    {
        // Add changes to page layout here
        modify(Control1900724808)
        {
            Visible = false;
        }
    }

    actions
    {
        addlast(Creation)
        {
            group("Posted Documents")
            {
                action("Posted PM Jobs")
                {
                    Caption = 'Posted PM Job List';
                    RunObject = page "Posted PM Job Card";
                }
                action("Posted Breakdown Jobs")
                {
                    Caption = 'Posted Breakdown Job List';
                    RunObject = page "Posted Job Cards";
                }
            }
        }

        modify("Released Production Orders")
        {
            Visible = false;
        }
        modify("Finished Production Orders")
        {
            Visible = false;
        }
        modify(Items)
        {
            Visible = false;
        }
        modify(ItemsProduced)
        {
            Visible = false;
        }
        modify(ItemsRawMaterials)
        {
            Visible = false;
        }
        modify("Stockkeeping Units")
        {
            Visible = false;
        }
        modify("Capacity Ledger Entries")
        {
            Visible = false;
        }
        modify("Inventory Put-aways")
        {
            Visible = false;
        }
        modify("Inventory Picks")
        {
            Visible = false;
        }
        modify(CapacityJournals)
        {
            Visible = false;
        }
        modify(RecurringCapacityJournals)
        {
            Visible = false;
        }
        modify("Inventory P&ick")
        {
            Visible = false;
        }
        modify("Inventory Put-&away")
        {
            Visible = false;
        }

        // Add changes to page actions here
        addafter("Finished Production Orders")
        {
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
            action("Breakdown Complaints")
            {
                Caption = 'Breakdown Complaints';
                RunObject = page "Breakdown Complaints List";
            }

            action("Breakdown Job List")
            {
                Caption = 'Breakdown Job List';
                RunObject = page "Breakdown Job List";
            }
            action("PM Job List")
            {
                Caption = 'PM Job List';
                RunObject = page "PM Job List";
            }

            action("Sub-Contracting Worksheet")
            {
                Caption = 'Sub-Contracting Worksheet';
                RunObject = page "Subcontracting Worksheet";
            }

            action("Maintenance Requisition List")
            {
                Caption = '';
                RunObject = page "Maintenance Requisition List";
            }
            action("Requisition List")
            {
                CaptionML = ENU = 'Purchase Requisition List';
                RunObject = Page "Purchase Requisition List";
            }
            action("Production Requisition List")
            {
                CaptionML = ENU = 'Production Requisition List';
                RunObject = Page "Schedule Requisition List";
            }
            action("Published Scedule")
            {
                CaptionML = ENU = 'Published Scedule';
                RunObject = Page "Published Schedule List";
            }
            action("Raw Material List")
            {
                CaptionML = ENU = 'Raw Material List';
                RunObject = Page "Item List";
            }
        }

        modify("Consumptio&n Journal")
        {
            Visible = false;
        }
        modify("Output &Journal")
        {
            Visible = false;
        }
        modify("&Capacity Journal")
        {
            Visible = false;
        }

        addafter("Inventory Put-&away")
        {
            action("Output Jopurnal-Corrugation")
            {
                CaptionML = ENU = 'Output Journal-Corrugation';
                Image = OutputJournal;
                RunObject = Page "Output Journal-CORRUGATION";
            }
            action("Output Journal-Finishing")
            {
                CaptionML = ENU = 'Output Journal-Finishing';
                Image = OutputJournal;
                RunObject = Page "Output Journal-FINISHING";
            }
            action("Production Order Status")
            {
                CaptionML = ENU = 'Production Order Status';
                RunObject = Page "Production Order wise status";
            }
            action("Daily Production Status Report")
            {
                CaptionML = ENU = 'Daily Production Status Report';
                Image = "Report";
                RunObject = Report "Daily Production Status";
            }
            action("Paper Stock Abstract Detail")
            {
                CaptionML = ENU = 'Paper Stock Abstract Detail';
                Image = "Report";
                RunObject = Report "Stock Abstract Details";
            }
            action("Paper Consumption ")
            {
                CaptionML = ENU = 'Paper Consumption';
                Image = "Report";
                RunObject = Report "Stock Consumption";
            }
        }
    }
}