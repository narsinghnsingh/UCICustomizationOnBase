pageextension 50007 Ext_26_VendorCard extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            
            field("Vendor Segment"; "Vendor Segment")
            {

            }
            field("Telex No."; "Telex No.")
            {

            }
            field("Mobile No."; "Mobile No.")
            {

            }

        }
        addlast("Foreign Trade")
        {
            group("Tax Information")
            {
                CaptionML = ENU = 'Tax Information';
                //   field("VAT Registration No."; "VAT Registration No.")
                //   {
                //    CaptionML = ENU = 'VAT TRN No.';
                //  }
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addlast("Ven&dor")
        {

            action("Approve134")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Approve';
                Promoted = true;
                PromotedIsBig = true;
                Image = Approve;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    // lines added by deepak Kumar
                    ApproveRecord;
                    //Firoz 16-11-15
                    TESTFIELD("Vendor Posting Group");
                    TESTFIELD("VAT Bus. Posting Group");
                    TESTFIELD("Gen. Bus. Posting Group");
                    //End Firoz 16-11-15
                end;

            }
            action(Block)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Block';
                Promoted = true;
                Visible = false;
                PromotedIsBig = true;
                Image = ClearLog;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    // lines added by deepak Kumar
                    BlockRecord;
                end;
            }
            action(UnBlock)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'UnBlock';
                Promoted = true;
                Visible = false;
                PromotedIsBig = true;
                Image = Undo;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    UnBlockRecord;
                end;
            }
        }
    }

}