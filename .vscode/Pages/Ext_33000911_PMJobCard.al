pageextension 50074 Ext_PMJobCard extends "PM Job Card"
{
    layout
    {
        // Add changes to page layout here
    }
    actions
    {
        // Add changes to page actions here
        addafter("<Action1102154066>")
        {
            action("Create Requisition")
            {
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction();
                var
                    RequisitionHeader: Record "Requisition Header";
                    PlantMainSetup: Record "Plant Maintenance Setup";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    PageRequisitionHeader: Page "Maintenance Requisition Header";
                begin
                    RequisitionHeader.RESET;
                    RequisitionHeader.SETRANGE("Requisition No.", "Requisition No.");
                    RequisitionHeader.SETRANGE("Ref. Document Number", "No.");
                    IF NOT RequisitionHeader.FINDFIRST THEN BEGIN
                        RequisitionHeader.INIT;
                        RequisitionHeader."Requisition Type" := RequisitionHeader."Requisition Type"::Maintenance;
                        PlantMainSetup.GET;
                        NoSeriesMgt.InitSeries(PlantMainSetup."Maintenance Requisition No.", '', 0D, RequisitionHeader."Requisition No.", PlantMainSetup."Maintenance Requisition No.");
                        RequisitionHeader.VALIDATE("Machine ID", "Machine ID");
                        RequisitionHeader.VALIDATE("Complaint No.", "Complaint No.");
                        RequisitionHeader."Ref. Document Number" := "No.";
                        RequisitionHeader."Maintenance Type" := Type;
                        RequisitionHeader."Maintenance Date" := "Maintenance Date";
                        RequisitionHeader."Work Center" := "Work Center";
                        RequisitionHeader.INSERT();
                        "Requisition No." := RequisitionHeader."Requisition No.";
                        MODIFY;
                        CLEAR(PageRequisitionHeader);
                        PageRequisitionHeader.SETRECORD(RequisitionHeader);
                        PageRequisitionHeader.RUN;
                    END ELSE BEGIN
                        //MESSAGE('Requisition already exist');
                        IF CONFIRM('Requisition %1 already exist against this Job %2 Do you want to open?', TRUE, "Requisition No.", "No.") THEN BEGIN
                            RequisitionHeader.RESET;
                            RequisitionHeader.SETRANGE("Requisition No.", "Requisition No.");
                            IF RequisitionHeader.FINDFIRST THEN BEGIN
                                CLEAR(PageRequisitionHeader);
                                PageRequisitionHeader.SETRECORD(RequisitionHeader);
                                PageRequisitionHeader.RUN;
                            END;
                        END ELSE
                            EXIT;
                    END;
                end;
            }

        }
    }

    var
        myInt: Integer;
}