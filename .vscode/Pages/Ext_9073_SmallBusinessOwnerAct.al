pageextension 50054 "Small Business Owner Act." extends "Small Business Owner Act."
{
    // version NAVW18.00    
    layout
    {

        addafter("Released Sales Orders")
        {
            field("Credit/Return This Month"; "Credit/Return This Month")
            {
            }
            field("Signed Document Not Received"; "Signed Document Not Received")
            {
            }
            field("Ongoing Sales Invoices"; "Ongoing Sales Invoices")
            {
                DrillDownPageID = "Sales Invoice List";
                ToolTip = 'Shows the number of open sales invoices.';
            }
            field("SOs Pending Approval"; "SOs Pending Approval")
            {
                AccessByPermission = TableData "Sales Shipment Header" = R;
                DrillDownPageID = "Sales Order List";
            }

        }
        addbefore(Purchase)
        {
            //addafter("SOs Pending Approval")
            //{
            cuegroup("Sales Details")
            {

                Caption = 'Sales';
                field("Order Booked Todays"; "Order Booked Todays")
                {
                    Caption = 'Order Booked Todays-Value';
                }
                field("Order Booked Month till Date"; "Order Booked Month till Date")
                {
                    Caption = 'Order Booked Month till Date-Value';
                }
                field("Order Booked Todays Qty-FG"; "Order Booked Todays Qty-FG")
                {
                    Caption = 'Order Booked Todays Qty-FG';
                }
                field("Order Booked MTD Qty-FG"; "Order Booked MTD Qty-FG")
                {
                }
                field("Invoice Todays"; "Invoice Todays")
                {
                }
                field("Invoice Month till Date"; "Invoice Month till Date")
                {
                }
                field("Outstanding Sales Order FG"; "Outstanding Sales Order FG")
                {
                }
            }
        }
        addlast(Purchase)
        {
            field("Ongoing Purchase Invoices"; "Ongoing Purchase Invoices")
            {
                DrillDownPageID = "Purchase Invoices";
                ToolTip = 'Shows the number of open purchase invoices.';
            }

            field("Quantity Received Not Invoiced"; "Quantity Received Not Invoiced")
            {
            }
            field("POs Pending Approval"; "POs Pending Approval")
            {
                DrillDownPageID = "Purchase Order List";
            }
        }
        addafter(Purchase)
        {
            cuegroup("Financial Performance")
            {
                field("Overdue Purch. Invoice Amount"; "Overdue Purch. Invoice Amount")
                {
                    ToolTip = 'Shows the sum of your overdue payments to vendors.';

                    trigger OnDrillDown()
                    begin
                        ActivitiesMgt.DrillDownOverduePurchaseInvoiceAmount;
                    end;
                }
                field("Overdue Sales Invoice Amount"; "Overdue Sales Invoice Amount")
                {
                    ToolTip = 'Shows the sum of overdue payments from customers.';

                    trigger OnDrillDown()
                    begin
                        ActivitiesMgt.DrillDownCalcOverdueSalesInvoiceAmount;
                    end;
                }
                field("Sales This Month"; "Sales This Month")
                {
                    DrillDownPageID = "Sales Invoice List";
                    ToolTip = 'Shows the sum of sales in the current month.';

                    trigger OnDrillDown()
                    begin
                        ActivitiesMgt.DrillDownSalesThisMonth;
                    end;
                }
                field("Vendor Open Balance"; "Vendor Open Balance")
                {
                }
                field("Bank Un-reconciled"; "Bank Un-reconciled")
                {
                }
                field("Average Collection Days"; "Average Collection Days")
                {
                    ToolTip = 'Specifies how long customers took to pay invoices in the last three months. This is the average number of days from when invoices are issued to when customers pay the invoices.';
                }
                field("Bank Collection Amount"; "Bank Collection Amount")
                {
                }
            }
        }
        addafter("Financial Performance")
        {
            cuegroup(Production)
            {
                field("Rel. Prod. Orders - Corr"; "Rel. Prod. Orders - Corr")
                {
                }
                field("Rel. Prod. Orders - Corr Today"; "Rel. Prod. Orders - Corr Today")
                {
                }
                field("Top 10 Customer Sales YTD"; "Top 10 Customer Sales YTD")
                {
                    ToolTip = 'The share of sales this year made to the ten largest customers.';
                }
                field("Order Not Received in Period"; "Order Not Received in Period")
                {
                    Caption = 'Cust. List who''s order not received in last 180 days';
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues;
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;
        SetFilter("Due Date Filter", '>=%1', WorkDate);
        SetFilter("Overdue Date Filter", '<%1', WorkDate);
        SetFilter("Date Filter", '%1', WorkDate);
        SetRange("Month Filter", CalcDate('<-CM>', WorkDate), WorkDate);
        SetFilter("Date Filter 2", '<=%1', (WorkDate - 180));
    end;

    var
        GettingStartedMgt: Codeunit "Getting Started Mgt.";
        FileManagement: Codeunit "File Management";
        ActivitiesMgt: Codeunit "Activities Mgt.";

    local procedure CalculateCueFieldValues()
    begin
        if FieldActive("SOs Shipped Not Invoiced") then
            "SOs Shipped Not Invoiced" := CountSalesOrdersShippedNotInvoiced;
        // Lines added By Deepak Kumar
        if FieldActive("Overdue Sales Invoice Amount") then
            "Overdue Sales Invoice Amount" := ActivitiesMgt.CalcOverdueSalesInvoiceAmount(FALSE);
        if FieldActive("Overdue Purch. Invoice Amount") then
            "Overdue Purch. Invoice Amount" := ActivitiesMgt.CalcOverduePurchaseInvoiceAmount(FALSE);
        if FieldActive("Sales This Month") then
            "Sales This Month" := ActivitiesMgt.CalcSalesThisMonthAmount(FALSE);
        if FieldActive("Top 10 Customer Sales YTD") then
            "Top 10 Customer Sales YTD" := ActivitiesMgt.CalcTop10CustomerSalesRatioYTD;
        if FieldActive("Average Collection Days") then
            "Average Collection Days" := ActivitiesMgt.CalcAverageCollectionDays;
    end;
}
