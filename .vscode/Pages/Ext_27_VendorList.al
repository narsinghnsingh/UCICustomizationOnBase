pageextension 50008 Ext_27_VendorList extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("VAT TRN NO."; "VAT TRN NO.")
            {
                Visible = false;
                Enabled = false;
            }

            field("Payment Method Code"; "Payment Method Code")
            {

            }
            field(Balance; Balance)
            {

            }
            field("Balance Due"; "Balance Due")
            {

            }
            field("Net Change"; "Net Change")
            {

            }
            field("Net Change (LCY)"; "Net Change (LCY)")
            {

            }
            field("PDC Balance LCY"; "PDC Balance LCY")
            {

            }
            field("Purchases (LCY)"; "Purchases (LCY)")
            {

            }
            field("G/L Account No."; "G/L Account No.")
            {

            }
            field("Vendor Segment"; "Vendor Segment")
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
            field(County; County)
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast("&Purchases")
        {
            action("Update Vendor Vat Reg. No.")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Update Vendor Vat Reg. No.';
                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Vendor.RESET;
                    IF Vendor.FINDFIRST THEN BEGIN
                        REPEAT
                            Vendor."VAT Registration No." := Vendor."VAT TRN NO.";
                            Vendor.MODIFY(TRUE);
                        UNTIL Vendor.NEXT = 0;
                        MESSAGE('Khush Raho');
                    END;
                end;
            }

        }
        addlast(Action5)
        {
            action("Pending Order Summary Paper")
            {
                ApplicationArea = All;
                RunObject = Report "Pending Order Summary";
                trigger OnAction()
                begin

                end;
            }
        }
        addlast("Financial Management")
        {
            action("Vendor Payment")
            {
                ApplicationArea = All;
                RunObject = Report 411;
                RunPageOnRec = true;
                trigger OnAction()
                begin

                end;
            }
            action("Knock Off Detail Vendor")
            {
                ApplicationArea = all;
                Image = Report;
                RunObject = Report "Knock Off Detail Vendor";
                RunPageOnRec = true;

            }
        }
    }

}