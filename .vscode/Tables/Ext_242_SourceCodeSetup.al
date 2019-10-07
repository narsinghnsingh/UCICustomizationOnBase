tableextension 50033 Ext_SourceCodeSetup extends "Source Code Setup"
{
    // version NAVW18.00,B2BPLM1.0

    // B2B Software Technologies
    // -----------------------------------------
    // Project : Plant Maintenance Addon
    // B2BPLM1.00.00
    // No. Sign          Dev     Date            Description
    // --------------------------------------------------------------------------
    // 01  B2BPLM1.00.00                       Added Field(50000)
    fields
    {
        field(50000; Equipment; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(50001; "Cash Receipt Voucher"; Code[10])
        {
            CaptionML = ENU = 'Cash Receipt Voucher';
            TableRelation = "Source Code";
        }
        field(50002; "Cash Payment Voucher"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(50003; "Bank Receipt Voucher"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(50004; "Bank Payment Voucher"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(50005; "Contra Voucher"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(50006; "Journal Voucher"; Code[10])
        {
            TableRelation = "Source Code";
        }
    }

}