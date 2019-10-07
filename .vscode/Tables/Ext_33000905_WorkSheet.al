
tableextension 50072 Ext_WorkSheet extends "Work Sheet"
{
    fields
    {
        // Add changes to page layout here        
        field(50015; "Requisition No"; Code[20])
        {
            TableRelation = "Requisition Header"."Requisition No." WHERE ("Requisition Type" = CONST (Maintenance), "Ref. Document Number" = FIELD ("Job Card No."));
        }
        field(50016; "Requisition Line No."; Integer)
        {
            TableRelation = "Requisition Line SAM"."Requisition Line No." WHERE ("Requisition No." = FIELD ("Requisition No"));
            trigger OnValidate()
            var
                RequisitionLine: Record "Requisition Line SAM";
                RequisitionHeader: Record "Requisition Header";
                PMJobHeader: Record "PM Job Header";
            begin
                TESTFIELD("Requisition No");
                RequisitionLine.RESET;
                RequisitionLine.SETRANGE("Requisition No.", "Requisition No");
                RequisitionLine.SETRANGE("Requisition Line No.", "Requisition Line No.");
                IF RequisitionLine.FINDFIRST THEN BEGIN
                    VALIDATE("I/R Code", RequisitionLine."Item No.");
                    VALIDATE("I/R Description", RequisitionLine.Description);
                    VALIDATE(Quantity, RequisitionLine.Quantity);
                    VALIDATE("Location Code", 'MAINT');
                    VALIDATE("Posting Date", WORKDATE);
                    PMJobHeader.RESET;
                    IF PMJobHeader.GET("Job Card No.", "Machine ID") THEN BEGIN
                        VALIDATE("Shortcut Dimension 1 Code", PMJobHeader."Shortcut Dimension 1 Code");
                        VALIDATE("Shortcut Dimension 2 Code", PMJobHeader."Shortcut Dimension 2 Code");
                        VALIDATE("Dimension Set ID", PMJobHeader."Dimension Set ID");
                    END;
                END;
            end;
        }
    }

}