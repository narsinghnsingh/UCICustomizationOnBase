tableextension 50074 Ext_GenJournalTemplate extends "Gen. Journal Template"
{
    fields
    {
        field(50001; "Sub Type"; Option)
        {
            Caption = 'Sub Type';
            Description = '//deepak';
            OptionCaption = ' ,Cash Receipt Voucher,Cash Payment Voucher,Bank Receipt Voucher,Bank Payment Voucher,Contra Voucher,Journal Voucher';
            OptionMembers = " ","Cash Receipt Voucher","Cash Payment Voucher","Bank Receipt Voucher","Bank Payment Voucher","Contra Voucher","Journal Voucher";

            trigger OnValidate()
            begin
                SourceCodeSetup.GET;
                CASE "Sub Type" OF
                    "Sub Type"::"Cash Receipt Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Cash Receipt Voucher");
                            "Source Code" := SourceCodeSetup."Cash Receipt Voucher";
                            //"Page ID" := PAGE::Page16579;
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Cash Payment Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Cash Payment Voucher");
                            "Source Code" := SourceCodeSetup."Cash Payment Voucher";
                            //"Page ID" := PAGE::Page16576;
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Bank Receipt Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Bank Receipt Voucher");
                            "Source Code" := SourceCodeSetup."Bank Receipt Voucher";
                            //"Page ID" := PAGE::Page16569;
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Bank Payment Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Bank Payment Voucher");
                            "Source Code" := SourceCodeSetup."Bank Payment Voucher";
                            //"Page ID" := PAGE::Page16577;
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Contra Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Contra Voucher");
                            "Source Code" := SourceCodeSetup."Contra Voucher";
                            //"Page ID" := PAGE::Page16570;
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                    "Sub Type"::"Journal Voucher":
                        BEGIN
                            SourceCodeSetup.TESTFIELD("Journal Voucher");
                            "Source Code" := SourceCodeSetup."Journal Voucher";
                            //"Page ID" := PAGE::Page16571;
                            "Posting Report ID" := REPORT::"Voucher Register";
                        END;
                END;
            end;
        }

    }
    var
        SourceCodeSetup: Record "Source Code Setup";
}