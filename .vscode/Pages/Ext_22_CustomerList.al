pageextension 50005 Ext_22_CustomerList extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Customer Segment"; "Customer Segment")
            {

            }
            field(Address; Address)
            {

            }
            field("Address 2"; "Address 2")
            {

            }
            field(City; City)
            {

            }
            field("E-Mail"; "E-Mail")
            {

            }
            field("Credit Limit (LCY) Base"; "Credit Limit (LCY) Base")
            {

            }
            field("Cust. Credit Buffer(LCY)"; "Cust. Credit Buffer(LCY)")
            {
                CaptionML = ENU = 'Customer Buffer Amount LCY';
            }
            field(Balance; Balance)
            {

            }
            //  field("Balance (LCY)"; "Balance (LCY)")
            //  {

            //}
            // field("Balance Due"; "Balance Due")
            // {

            // }
            //            field("Balance Due (LCY)"; "Balance Due (LCY)")
            //          {

            //        }
            field("PDC Balance LCY"; "PDC Balance LCY")
            {

            }
            field("VAT Registration No."; "VAT Registration No.")
            {
                CaptionML = ENU = 'VAT TRN NO.';
            }
            field("Outstanding Orders1 (LCY)"; "Outstanding Orders1 (LCY)")
            {

            }
            field("Created On"; "Created On")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addfirst(History)
        {
            action("Update Customer Vat Reg  no.")
            {
                ApplicationArea = All;
                Visible = false;
                Enabled = false;
                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    Customer.RESET;
                    IF Customer.FINDFIRST THEN BEGIN
                        REPEAT
                            Customer."VAT Registration No." := Customer."VAT TRN NO.";
                            Customer.MODIFY(TRUE);
                        UNTIL Customer.NEXT = 0;
                        MESSAGE('Complete');
                    END;
                end;
            }
        }
        addlast(FinanceReports)
        {
            action("Customer Application Detail")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Customer Application Detail';
                Promoted = true;
                RunObject = Report "Customer - Payment Details";
                Image = Report;
                PromotedIsBig = true;
                PromotedCategory = Report;

                trigger OnAction()
                begin

                end;
            }
            action("Customer Creation Update")
            {
                trigger OnAction()
                var
                    Cust: Record Customer;
                    CustLedEntry: Record "Cust. Ledger Entry";
                begin
                    Cust.Reset();
                    Cust.SetRange("Created On", 0D);
                    IF Cust.FindSet then
                        repeat
                            CustLedEntry.Reset();
                            CustLedEntry.SetCurrentKey("Posting Date");
                            CustLedEntry.SetRange("Customer No.", Cust."No.");
                            if CustLedEntry.FindFirst then begin
                                Cust."Created On" := CustLedEntry."Posting Date";
                                Cust.Modify()
                            end;
                        until Cust.Next = 0;
                    Message('Done');
                end;
            }
        }
    }

}