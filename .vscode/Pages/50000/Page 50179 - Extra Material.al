page 50179 "Extra Material"
{
    // version Requisition

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Requisition Line SAM";
    SourceTableView = SORTING ("Requisition No.", "Requisition Line No.")
                      ORDER(Ascending)
                      WHERE ("Temp Line" = CONST (true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Requisition Line No."; "Requisition Line No.")
                {
                }
                field("Schedule Prod. Order"; "Schedule Prod. Order")
                {
                }
                field("Prod. Order No"; "Prod. Order No")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        //ValidateProdOrder("Requisition No.","Prod. Order No","Prod. Order Line No.");
                    end;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {

                    trigger OnValidate()
                    begin
                        //ValidateProdOrder("Requisition No.","Prod. Order No","Prod. Order Line No.");
                    end;
                }
                field("Paper Position"; "Paper Position")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Of Measure"; "Unit Of Measure")
                {
                }
                field("Extra Material"; "Extra Material")
                {
                }
                field("Temp Line"; "Temp Line")
                {
                }
                field("Production Schedule No."; "Production Schedule No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Lines")
            {
                CaptionML = ENU = 'Update Lines';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TempReqLine: Record "Requisition Line SAM";
                    ProdOrderComponent: Record "Prod. Order Component";
                    NewProdOrderComponent: Record "Prod. Order Component";
                    RequisitionHeader: Record "Requisition Header";
                begin
                    // Lines added By Deepak Kumar
                    TempReqLine.Reset;
                    TempReqLine.SetRange(TempReqLine."Requisition No.", "Requisition No.");
                    TempReqLine.SetRange(TempReqLine."Temp Line", true);
                    if TempReqLine.FindFirst then begin
                        repeat
                            TempReqLine.TestField(TempReqLine."Prod. Order No");
                            TempReqLine.TestField(TempReqLine."Prod. Order Line No.");
                            TempReqLine.TestField(TempReqLine."Item No.");
                            TempReqLine.TestField(TempReqLine."Paper Position");
                            TempReqLine.TestField(TempReqLine.Quantity);

                            RequisitionHeader.Reset;
                            RequisitionHeader.SetRange(RequisitionHeader."Requisition Type", RequisitionHeader."Requisition Type"::"Production Schedule");
                            RequisitionHeader.SetRange(RequisitionHeader."Requisition No.", "Requisition No.");
                            if RequisitionHeader.FindFirst then begin
                                ProdOrderComponent.Reset;
                                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order No.", TempReqLine."Prod. Order No");
                                ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order Line No.", TempReqLine."Prod. Order Line No.");
                                ProdOrderComponent.SetRange(ProdOrderComponent."Paper Position", TempReqLine."Paper Position");
                                ProdOrderComponent.SetRange(ProdOrderComponent."Schedule Component", true);
                                ProdOrderComponent.SetRange(ProdOrderComponent."Prod Schedule No.", RequisitionHeader."Schedule Document No.");
                                if not ProdOrderComponent.FindFirst then
                                    Error('There is NO Prod. Order Component Line %1', ProdOrderComponent.GetFilters)
                            end;
                        until TempReqLine.Next = 0;
                    end;

                    TempReqLine.Reset;
                    TempReqLine.SetRange(TempReqLine."Requisition No.", "Requisition No.");
                    TempReqLine.SetRange(TempReqLine."Temp Line", true);
                    if TempReqLine.FindFirst then begin
                        TempLineNo := TempReqLine."Prod. Order Comp. Line No";
                        repeat
                            ProdOrderComponent.Reset;
                            ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order No.", TempReqLine."Prod. Order No");
                            ProdOrderComponent.SetRange(ProdOrderComponent."Prod. Order Line No.", TempReqLine."Prod. Order Line No.");
                            ProdOrderComponent.SetRange(ProdOrderComponent."Paper Position", TempReqLine."Paper Position");
                            ProdOrderComponent.SetRange(ProdOrderComponent."Schedule Component", true);
                            ProdOrderComponent.SetRange(ProdOrderComponent."Prod Schedule No.", RequisitionHeader."Schedule Document No.");
                            if ProdOrderComponent.FindFirst then begin
                                NewProdOrderComponent.Init;
                                NewProdOrderComponent := ProdOrderComponent;
                                TempLineNo := TempLineNo + 100;
                                NewProdOrderComponent."Line No." := TempLineNo;
                                NewProdOrderComponent."Expected Quantity" := 0;
                                NewProdOrderComponent."Remaining Quantity" := 0;
                                NewProdOrderComponent."Expected Qty. (Base)" := 0;
                                NewProdOrderComponent."Remaining Qty. (Base)" := 0;
                                NewProdOrderComponent.Validate(NewProdOrderComponent."Item No.", TempReqLine."Item No.");
                                //NewProdOrderComponent.VALIDATE(NewProdOrderComponent.Quantity,TempReqLine.Quantity);
                                NewProdOrderComponent.Validate("Expected Quantity", TempReqLine.Quantity);
                                NewProdOrderComponent.Validate("Remaining Quantity", TempReqLine.Quantity);
                                NewProdOrderComponent.Insert(true);
                                TempReqLine."Temp Line" := false;
                                TempReqLine.Modify(true);
                            end;
                        until TempReqLine.Next = 0;
                        Message('Line Updated');
                    end;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Lines added By Deepak Kumar
        "Extra Material" := true;
        "Temp Line" := true;
        ReqDocumentNumber := GetFilter("Requisition No.");
        ReqHeader.Reset;
        ReqHeader.SetRange(ReqHeader."Requisition No.", ReqDocumentNumber);
        if ReqHeader.FindFirst then
            "Production Schedule No." := ReqHeader."Schedule Document No.";
    end;

    var
        ReqHeader: Record "Requisition Header";
        ReqDocumentNumber: Text[50];
        TempLineNo: Integer;

    procedure ValidateProdOrder(ReqNumber: Code[50]; ProdOrderNumber: Code[100]; ProdOrderLineNo: Integer)
    var
        RequisitionHeader: Record "Requisition Header";
        ProdScheduleLine: Record "Production Schedule Line";
    begin
        // Lines added BY Deepak Kumar
        RequisitionHeader.Reset;
        RequisitionHeader.SetRange(RequisitionHeader."Requisition Type", RequisitionHeader."Requisition Type"::"Production Schedule");
        RequisitionHeader.SetRange(RequisitionHeader."Requisition No.", ReqNumber);
        if RequisitionHeader.FindFirst then begin
            if ProdOrderLineNo = 0 then begin
                ProdScheduleLine.Reset;
                ProdScheduleLine.SetRange(ProdScheduleLine."Schedule No.", RequisitionHeader."Schedule Document No.");
                ProdScheduleLine.SetRange(ProdScheduleLine."Prod. Order No.", ProdOrderNumber);
                if not ProdScheduleLine.FindFirst then
                    Error('Prod. Order Number %1 not exist in Production Schedule %2', ProdOrderNumber, RequisitionHeader."Schedule Document No.");
            end else begin
                ProdScheduleLine.Reset;
                ProdScheduleLine.SetRange(ProdScheduleLine."Schedule No.", RequisitionHeader."Schedule Document No.");
                ProdScheduleLine.SetRange(ProdScheduleLine."Prod. Order No.", ProdOrderNumber);
                ProdScheduleLine.SetRange(ProdScheduleLine."Prod. Order Line No.", ProdOrderLineNo);
                if not ProdScheduleLine.FindFirst then
                    Error('Prod. Order Number %1 Line No. %2 not exist in Production Schedule %3', ProdOrderNumber, ProdOrderLineNo, RequisitionHeader."Schedule Document No.");
            end;
        end;
    end;
}

