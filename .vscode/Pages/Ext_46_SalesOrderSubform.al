pageextension 50015 Ext_46_SalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        modify("Unit Price")
        {
            Editable = false;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
        modify("Qty. to Ship")
        {
            Editable = false;
        }
        modify("Qty. to Invoice")
        {
            Editable = false;
        }
        // Add changes to page layout here
        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {

            }
        }
        addafter(Quantity)
        {
            field("Job Wise Inventory"; "Job Wise Inventory")
            {
                Editable = false;
            }
            // field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
            // {

            // }
            field("Inventory In FG Location"; "Inventory In FG Location")
            {
                Editable = false;
            }
        }
        addafter("Unit Cost (LCY)")
        {
            field("Net Weight"; "Net Weight")
            {
                Editable = false;
            }
        }
        addafter("Line Discount Amount")
        {
            field("Prod. Order No."; "Prod. Order No.")
            {

            }
            field("Prod. Order Line No."; "Prod. Order Line No.")
            {

            }
        }
        addafter("Quantity Invoiced")
        {
            // field("Appl.-to Item Entry"; "Appl.-to Item Entry")
            // {

            // }
        }
        addafter("Requested Delivery Date")
        {
            field("Salesperson Code"; "Salesperson Code")
            {

            }
        }
        addafter("Planned Shipment Date")
        {
            field("Sales Price per Unit (Company)"; "Sales Price per Unit (Company)")
            {

            }
            field("Variation %  Estimate Price"; "Variation %  Estimate Price")
            {

            }
            field("Variation % From Unit Price"; "Variation % From Unit Price")
            {

            }
            field("Order Line Type"; "Order Line Type")
            {

            }
            field(Remarks; Remarks)
            {

            }
            // field("Qty. to Invoice"; "Qty. to Invoice")
            // {

            // }
            // field("Qty. to Ship"; "Qty. to Ship")
            // {

            // }
            // field("Variant Code"; "Variant Code")
            // {

            // }
        }
        addafter("Shipping Agent Code")
        {
            field("Estimate Additional Cost"; "Estimate Additional Cost")
            {

            }
        }
        addafter("Document No.")
        {
            field("Shipment Weight"; "Shipment Weight")
            {
                Editable = false;
            }
        }
        addafter("Line No.")
        {
            field("Estimation No."; "Estimation No.")
            {

            }
            field("Estimate Price"; "Estimate Price")
            {
                Editable = false;
            }
            field("External Doc. No."; "External Doc. No.")
            {
                Editable = false;
            }
            field("Order Date"; "Order Date")
            {

            }
            field("Rate Per KG"; "Rate Per KG")
            {
                Editable = false;
            }
            field("Short Closed Document"; "Short Closed Document")
            {
                Editable = false;
            }
            field("Short Closed Quantity"; "Short Closed Quantity")
            {
                Editable = false;
            }
            field("Short Closed Amount"; "Short Closed Amount")
            {
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action("Additional Cost")
            {
                ApplicationArea = All;
                RunObject = Page 50095;
                RunPageView = SORTING ("No.", "Line No.");
                RunPageLink = "No." = FIELD ("Estimation No.");
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        UserSetup: Record "User Setup";

    trigger OnDeleteRecord(): Boolean
    begin
        UserSetup.CheckDeleteSalesLine(USERID);//Anurag 03-05-2017
    end;
}