codeunit 50002 CreateSpecificationSheet
{
    // version Samadhan Quality

    // Deepak Kumar


    trigger OnRun()
    begin
    end;

    var
        ItemCard: Record Item;
        SamplePlanCounter: Integer;

    procedure UpdatePaperTypeGSMinReceptLine()
    var
        PurchaseReceiptLine: Record "Purch. Rcpt. Line";
        ItemCard: Record Item;
        "Roll Master": Record "Item Variant";
        RollEntry: Record "Item Variant";
        LineCounter: Integer;
    begin
        // Lines added by Deepak Kumar
        PurchaseReceiptLine.Reset;
        PurchaseReceiptLine.SetRange(PurchaseReceiptLine.Type,PurchaseReceiptLine.Type::Item);
        PurchaseReceiptLine.SetRange(PurchaseReceiptLine.Paper,true);
        if PurchaseReceiptLine.FindFirst then begin
          repeat
            RollEntry.Reset;
            RollEntry.SetRange(RollEntry."Document No.",PurchaseReceiptLine."Document No.");
            RollEntry.SetRange(RollEntry."Item No.",PurchaseReceiptLine."No.");
            RollEntry.SetFilter(RollEntry."Document Line No.",'');
            if RollEntry.FindFirst then begin
              repeat
               LineCounter:=LineCounter+1;
                  RollEntry."Document Line No.":=PurchaseReceiptLine."Line No.";
                  RollEntry.Modify(true);
              until RollEntry.Next=0;
            end;

          until PurchaseReceiptLine.Next=0;
        end;

          Message('Complete %1',LineCounter);
    end;

    procedure CreatePaperGroup(PurcReceiptNo: Code[50])
    var
        PurchReceiptLine: Record "Purch. Rcpt. Line";
        PaperTypeBuffer: Record "Quality Type";
        TempPaperType: Code[50];
        TempPaperGSM: Code[50];
        PaperTypeBuffer1: Record "Quality Type";
    begin
        PurchReceiptLine.Reset;
        PurchReceiptLine.SetCurrentKey("Paper Type","Paper GSM");
        PurchReceiptLine.SetRange(PurchReceiptLine."Document No.",PurcReceiptNo);
        PurchReceiptLine.SetRange(PurchReceiptLine.Paper,true);
        PurchReceiptLine.SetFilter(PurchReceiptLine.Quantity,'>%1',0);
        if PurchReceiptLine.FindFirst then begin
           TempPaperType:='';
           TempPaperGSM:='';
            repeat
            PaperTypeBuffer.Reset;
            PaperTypeBuffer.SetRange(PaperTypeBuffer."Document Type",0);
            PaperTypeBuffer.SetRange(PaperTypeBuffer."Document No.",PurchReceiptLine."Document No.");
            PaperTypeBuffer.SetRange(PaperTypeBuffer."Paper Type",PurchReceiptLine."Paper Type");
            PaperTypeBuffer.SetRange(PaperTypeBuffer."Paper GSM",PurchReceiptLine."Paper GSM");
            if not PaperTypeBuffer.FindFirst then begin

                 //IF (PurchReceiptLine."Paper GSM" <> TempPaperGSM) AND (PurchReceiptLine."Paper Type" <> TempPaperType) THEN BEGIN
                    TempPaperType:=PurchReceiptLine."Paper Type";
                    TempPaperGSM:=PurchReceiptLine."Paper GSM";
                    PaperTypeBuffer1.Init;
                    PaperTypeBuffer1."Document Type":=0;
                    PaperTypeBuffer1."Document No.":=PurchReceiptLine."Document No.";
                    PaperTypeBuffer1."Paper Type":=PurchReceiptLine."Paper Type";
                    PaperTypeBuffer1."Paper GSM":=PurchReceiptLine."Paper GSM";
                    PaperTypeBuffer1.Insert(true);
                // END;
             end;
              until PurchReceiptLine.Next=0;
              Commit;
        end;
        PurchReceiptLine.Reset;
        PurchReceiptLine.SetCurrentKey("Paper Type","Paper GSM");
        PurchReceiptLine.SetRange(PurchReceiptLine."Document No.",PurcReceiptNo);
        PurchReceiptLine.SetFilter(PurchReceiptLine.Quantity,'>%1',0);
        PurchReceiptLine.SetRange(PurchReceiptLine.Paper,false);
        if PurchReceiptLine.FindFirst then begin
              repeat
               PaperTypeBuffer.Reset;
               PaperTypeBuffer.SetRange(PaperTypeBuffer."Document Type",0);
               PaperTypeBuffer.SetRange(PaperTypeBuffer."Document No.",PurchReceiptLine."Document No.");
               PaperTypeBuffer.SetRange(PaperTypeBuffer."Document Line No.",PurchReceiptLine."Line No.");
               if not PaperTypeBuffer.FindFirst then begin
                       PaperTypeBuffer1.Init;
                       PaperTypeBuffer1."Document Type":=0;
                       PaperTypeBuffer1."Document No.":=PurchReceiptLine."Document No.";
                       PaperTypeBuffer1."Document Line No.":=PurchReceiptLine."Line No.";
                       PaperTypeBuffer1.Validate("Item Code",PurchReceiptLine."No.");
                       PaperTypeBuffer1."Item Description":=PurchReceiptLine.Description;
                       PaperTypeBuffer1.Quantity:=PurchReceiptLine.Quantity;
                       PaperTypeBuffer1.Insert(true);
                end;
              until PurchReceiptLine.Next=0;
        end;
    end;

    procedure CreateInspectionLine(PurcReceiptNO: Code[50])
    var
        InspectionSheet: Record "Inspection Sheet";
        QualitySpecHeader: Record "Quality Spec Header";
        QualitySpecLine: Record "Quality Spec Line";
        PaperTypeBuffer: Record "Quality Type";
        PurchReceiptLine: Record "Purch. Rcpt. Line";
        EntryNumber: Integer;
    begin
        // Lines added by Deepak Kumar
        InspectionSheet.Reset;
        if InspectionSheet.FindLast then
          EntryNumber:=InspectionSheet."Entry No."
        else
          EntryNumber:=1;


        PaperTypeBuffer.Reset;
        PaperTypeBuffer.SetRange(PaperTypeBuffer."Document Type",0);
        PaperTypeBuffer.SetRange(PaperTypeBuffer."Document No.",PurcReceiptNO);
        if PaperTypeBuffer.FindFirst then begin
          repeat
           if PaperTypeBuffer."Document Line No." = 0 then begin
           InspectionSheet.Reset;
           InspectionSheet.SetRange(InspectionSheet."Source Type",0);
           InspectionSheet.SetRange(InspectionSheet."Source Document No.",PurcReceiptNO);
           InspectionSheet.SetRange(InspectionSheet."Paper Type",PaperTypeBuffer."Paper Type");
           InspectionSheet.SetRange(InspectionSheet."Paper GSM",PaperTypeBuffer."Paper GSM");
           if not InspectionSheet.FindFirst then begin

            QualitySpecHeader.Reset;
            QualitySpecHeader.SetRange(QualitySpecHeader."Paper Type",PaperTypeBuffer."Paper Type");
            QualitySpecHeader.SetRange(QualitySpecHeader."Paper GSM",PaperTypeBuffer."Paper GSM");
            if QualitySpecHeader.FindFirst then begin
           // SamplePlanCount(QualitySpecHeader."Sampling Plan",PaperTypeBuffer."Document No.",PaperTypeBuffer.Quantity);
             // REPEAT
                QualitySpecLine.Reset;
                QualitySpecLine.SetRange(QualitySpecLine."Spec ID",QualitySpecHeader."Spec ID");
                if QualitySpecLine.FindFirst then begin
                  repeat
                    InspectionSheet.Init;
                    EntryNumber:=EntryNumber+1;
                    InspectionSheet."Entry No.":=EntryNumber;
                    InspectionSheet."Source Type":=0;
                    InspectionSheet."Source Document No.":=PaperTypeBuffer."Document No.";
                    InspectionSheet."Spec ID":=QualitySpecHeader."Spec ID";
                    InspectionSheet."Created By":=UserId;
                    InspectionSheet."Created Date":=WorkDate;
                    InspectionSheet."Created Time":=Time;
                    InspectionSheet.Validate("QA Characteristic Code",QualitySpecLine."Character Code");
                    InspectionSheet."QA Characteristic Description":=QualitySpecLine.Description;
                    InspectionSheet."Normal Value (Num)":=QualitySpecLine."Normal Value (Num)";
                    InspectionSheet."Min. Value (Num)":=QualitySpecLine."Min. Value (Num)";
                    InspectionSheet."Max. Value (Num)":=QualitySpecLine."Max. Value (Num)";
                    InspectionSheet."Normal Value (Text)":=QualitySpecLine."Normal Value (Char)";
                    InspectionSheet."Min. Value (Text)":=QualitySpecLine."Min. Value (Char)";
                    InspectionSheet."Max. Value (Text)":=QualitySpecLine."Max. Value (Char)";
                    InspectionSheet."Unit of Measure":=QualitySpecLine."Unit of Measure Code";
                    InspectionSheet.Qualitative:=QualitySpecLine.Qualitative;
                    InspectionSheet.Quantitative:=QualitySpecLine.Quantitative;
                    InspectionSheet."Paper Type":=PaperTypeBuffer."Paper Type";
                    InspectionSheet."Paper GSM":=PaperTypeBuffer."Paper GSM";
                    InspectionSheet.Insert(true);

                  until QualitySpecLine.Next=0;
                end;
                //SamplePlanCounter:=SamplePlanCounter-1;
              //UNTIL SamplePlanCounter=0;
            end;
            end;
           end else begin
              InspectionSheet.Reset;
              InspectionSheet.SetRange(InspectionSheet."Source Type",0);
              InspectionSheet.SetRange(InspectionSheet."Source Document No.",PurcReceiptNO);
              InspectionSheet.SetRange(InspectionSheet."Source Document Line No.",PaperTypeBuffer."Document Line No.");
              if not InspectionSheet.FindFirst then begin
               ItemCard.Reset;
               ItemCard.SetRange(ItemCard."No.",PaperTypeBuffer."Item Code");
               ItemCard.SetRange(ItemCard."QA Enable",true);
               if ItemCard.FindFirst then begin
                ItemCard.TestField("Quality Spec ID");

                  QualitySpecHeader.Reset;
                  QualitySpecHeader.SetRange(QualitySpecHeader."Spec ID",ItemCard."Quality Spec ID");
                  if QualitySpecHeader.FindFirst then begin
                    SamplePlanCounter:=1;
                    SamplePlanCount(QualitySpecHeader."Sampling Plan",PaperTypeBuffer."Document No.",PaperTypeBuffer.Quantity);
                     repeat
                      QualitySpecLine.Reset;
                      QualitySpecLine.SetRange(QualitySpecLine."Spec ID",QualitySpecHeader."Spec ID");
                      if QualitySpecLine.FindFirst then begin
                        repeat
                          InspectionSheet.Init;
                          EntryNumber:=EntryNumber+1;
                          InspectionSheet."Entry No.":=EntryNumber;
                          InspectionSheet."Source Type":=0;
                          InspectionSheet."Source Document No.":=PaperTypeBuffer."Document No.";
                          InspectionSheet."Source Document Line No.":=PaperTypeBuffer."Document Line No.";

                          InspectionSheet."Spec ID":=QualitySpecHeader."Spec ID";
                          InspectionSheet."Created By":=UserId;
                          InspectionSheet."Created Date":=WorkDate;
                          InspectionSheet."Created Time":=Time;
                          InspectionSheet.Validate("QA Characteristic Code",QualitySpecLine."Character Code");
                          InspectionSheet."QA Characteristic Description":=QualitySpecLine.Description;
                          InspectionSheet."Normal Value (Num)":=QualitySpecLine."Normal Value (Num)";
                          InspectionSheet."Min. Value (Num)":=QualitySpecLine."Min. Value (Num)";
                          InspectionSheet."Max. Value (Num)":=QualitySpecLine."Max. Value (Num)";
                          InspectionSheet."Normal Value (Text)":=QualitySpecLine."Normal Value (Char)";
                          InspectionSheet."Min. Value (Text)":=QualitySpecLine."Min. Value (Char)";
                          InspectionSheet."Max. Value (Text)":=QualitySpecLine."Max. Value (Char)";
                          InspectionSheet."Unit of Measure":=QualitySpecLine."Unit of Measure Code";
                          InspectionSheet.Qualitative:=QualitySpecLine.Qualitative;
                          InspectionSheet.Quantitative:=QualitySpecLine.Quantitative;
                          InspectionSheet."Paper Type":=PaperTypeBuffer."Paper Type";
                          InspectionSheet."Paper GSM":=PaperTypeBuffer."Paper GSM";
                          InspectionSheet."Sample Code":='Sample-'+Format(SamplePlanCounter);
                          InspectionSheet.Insert(true);
                        until QualitySpecLine.Next=0;
                      end;
                      SamplePlanCounter:=SamplePlanCounter-1;
                     until SamplePlanCounter = 0;
                   end;
                 end;
              end;

           end;
          until PaperTypeBuffer.Next=0;
        end;
    end;

    procedure CreatePaperInspectionSheet(PurchaseReceiptNo: Code[50])
    begin
        // Lines added BY Deepak kUmar

        CreatePaperGroup(PurchaseReceiptNo);
        CreateInspectionLine(PurchaseReceiptNo);
    end;

    procedure SamplePlanCount(SampleCode: Code[50];DocumentNo: Code[50];Qty: Decimal)
    var
        SamplingPlanQA: Record "Sampling Plan QA";
    begin
        // Lines added by Deepak Kumar
        SamplingPlanQA.Reset;
        SamplingPlanQA.SetRange(SamplingPlanQA.Code,SampleCode);
        if SamplingPlanQA.FindFirst then begin
        
          if SamplingPlanQA."Sampling Type"=SamplingPlanQA."Sampling Type"::"Fixed Quantity" then begin
            SamplePlanCounter:=SamplingPlanQA."Fixed Quantity";
          end;
        
          if Qty <> 0 then begin
            if SamplingPlanQA."Sampling Type"=SamplingPlanQA."Sampling Type"::"Percentage Lot" then begin
              if SamplingPlanQA."Lot Percentage" <> 0 then begin
                SamplePlanCounter:=((Qty*SamplingPlanQA."Lot Percentage")/100);
              end;
            end;
        
            if SamplingPlanQA."Sampling Type"=SamplingPlanQA."Sampling Type"::"Complete Lot" then begin
              SamplePlanCounter:=Qty;
            end;
          end;
          /*IF SamplePlanCounter > 5 THEN BEGIN
            SamplePlanCounter:=5;
          END;*/// Not Required
        
        end;

    end;

    procedure AddInspectionLineSet(PurcReceiptNO: Code[50];EntryNo: Integer)
    var
        InspectionSheet: Record "Inspection Sheet";
        QualitySpecHeader: Record "Quality Spec Header";
        QualitySpecLine: Record "Quality Spec Line";
        PaperTypeBuffer: Record "Quality Type";
        PurchReceiptLine: Record "Purch. Rcpt. Line";
        EntryNumber: Integer;
    begin
        // Lines added by Deepak Kumar
        InspectionSheet.Reset;
        if InspectionSheet.FindLast then
          EntryNumber:=InspectionSheet."Entry No."
        else
          EntryNumber:=1;


        PaperTypeBuffer.Reset;
        PaperTypeBuffer.SetRange(PaperTypeBuffer."Document Type",0);
        PaperTypeBuffer.SetRange(PaperTypeBuffer."Document No.",PurcReceiptNO);
        if PaperTypeBuffer.FindFirst then begin
          repeat
           if PaperTypeBuffer."Document Line No." = 0 then begin
           InspectionSheet.Reset;
           InspectionSheet.SetRange(InspectionSheet."Source Type",0);
           InspectionSheet.SetRange(InspectionSheet."Source Document No.",PurcReceiptNO);
           InspectionSheet.SetRange(InspectionSheet."Paper Type",PaperTypeBuffer."Paper Type");
           InspectionSheet.SetRange(InspectionSheet."Paper GSM",PaperTypeBuffer."Paper GSM");
           if not InspectionSheet.FindFirst then begin

            QualitySpecHeader.Reset;
            QualitySpecHeader.SetRange(QualitySpecHeader."Paper Type",PaperTypeBuffer."Paper Type");
            QualitySpecHeader.SetRange(QualitySpecHeader."Paper GSM",PaperTypeBuffer."Paper GSM");
            if QualitySpecHeader.FindFirst then begin
            //SamplePlanCount(QualitySpecHeader."Sampling Plan",PaperTypeBuffer."Document No.",PaperTypeBuffer.Quantity);
             // REPEAT
                QualitySpecLine.Reset;
                QualitySpecLine.SetRange(QualitySpecLine."Spec ID",QualitySpecHeader."Spec ID");
                if QualitySpecLine.FindFirst then begin
                  repeat
                    InspectionSheet.Init;
                    EntryNumber:=EntryNumber+1;
                    InspectionSheet."Entry No.":=EntryNumber;
                    InspectionSheet."Source Type":=0;
                    InspectionSheet."Source Document No.":=PaperTypeBuffer."Document No.";
                    InspectionSheet."Spec ID":=QualitySpecHeader."Spec ID";
                    InspectionSheet."Created By":=UserId;
                    InspectionSheet."Created Date":=WorkDate;
                    InspectionSheet."Created Time":=Time;
                    InspectionSheet.Validate("QA Characteristic Code",QualitySpecLine."Character Code");
                    InspectionSheet."QA Characteristic Description":=QualitySpecLine.Description;
                    InspectionSheet."Normal Value (Num)":=QualitySpecLine."Normal Value (Num)";
                    InspectionSheet."Min. Value (Num)":=QualitySpecLine."Min. Value (Num)";
                    InspectionSheet."Max. Value (Num)":=QualitySpecLine."Max. Value (Num)";
                    InspectionSheet."Normal Value (Text)":=QualitySpecLine."Normal Value (Char)";
                    InspectionSheet."Min. Value (Text)":=QualitySpecLine."Min. Value (Char)";
                    InspectionSheet."Max. Value (Text)":=QualitySpecLine."Max. Value (Char)";
                    InspectionSheet."Unit of Measure":=QualitySpecLine."Unit of Measure Code";
                    InspectionSheet.Qualitative:=QualitySpecLine.Qualitative;
                    InspectionSheet.Quantitative:=QualitySpecLine.Quantitative;
                    InspectionSheet."Paper Type":=PaperTypeBuffer."Paper Type";
                    InspectionSheet."Paper GSM":=PaperTypeBuffer."Paper GSM";
                    InspectionSheet.Insert(true);

                  until QualitySpecLine.Next=0;
                end;
                //SamplePlanCounter:=SamplePlanCounter-1;
              //UNTIL SamplePlanCounter=0;
            end;
            end;
           end else begin
              InspectionSheet.Reset;
              InspectionSheet.SetRange(InspectionSheet."Source Type",0);
              InspectionSheet.SetRange(InspectionSheet."Source Document No.",PurcReceiptNO);
              InspectionSheet.SetRange(InspectionSheet."Source Document Line No.",PaperTypeBuffer."Document Line No.");
              if not InspectionSheet.FindFirst then begin
               ItemCard.Reset;
               ItemCard.SetRange(ItemCard."No.",PaperTypeBuffer."Item Code");
               ItemCard.SetRange(ItemCard."QA Enable",true);
               if ItemCard.FindFirst then begin
                ItemCard.TestField("Quality Spec ID");

                  QualitySpecHeader.Reset;
                  QualitySpecHeader.SetRange(QualitySpecHeader."Spec ID",ItemCard."Quality Spec ID");
                  if QualitySpecHeader.FindFirst then begin
                   // SamplePlanCount(QualitySpecHeader."Sampling Plan",PaperTypeBuffer."Document No.",PaperTypeBuffer.Quantity);
                   //  REPEAT
                      QualitySpecLine.Reset;
                      QualitySpecLine.SetRange(QualitySpecLine."Spec ID",QualitySpecHeader."Spec ID");
                      if QualitySpecLine.FindFirst then begin
                        repeat
                          InspectionSheet.Init;
                          EntryNumber:=EntryNumber+1;
                          InspectionSheet."Entry No.":=EntryNumber;
                          InspectionSheet."Source Type":=0;
                          InspectionSheet."Source Document No.":=PaperTypeBuffer."Document No.";
                          InspectionSheet."Source Document Line No.":=PaperTypeBuffer."Document Line No.";

                          InspectionSheet."Spec ID":=QualitySpecHeader."Spec ID";
                          InspectionSheet."Created By":=UserId;
                          InspectionSheet."Created Date":=WorkDate;
                          InspectionSheet."Created Time":=Time;
                          InspectionSheet.Validate("QA Characteristic Code",QualitySpecLine."Character Code");
                          InspectionSheet."QA Characteristic Description":=QualitySpecLine.Description;
                          InspectionSheet."Normal Value (Num)":=QualitySpecLine."Normal Value (Num)";
                          InspectionSheet."Min. Value (Num)":=QualitySpecLine."Min. Value (Num)";
                          InspectionSheet."Max. Value (Num)":=QualitySpecLine."Max. Value (Num)";
                          InspectionSheet."Normal Value (Text)":=QualitySpecLine."Normal Value (Char)";
                          InspectionSheet."Min. Value (Text)":=QualitySpecLine."Min. Value (Char)";
                          InspectionSheet."Max. Value (Text)":=QualitySpecLine."Max. Value (Char)";
                          InspectionSheet."Unit of Measure":=QualitySpecLine."Unit of Measure Code";
                          InspectionSheet.Qualitative:=QualitySpecLine.Qualitative;
                          InspectionSheet.Quantitative:=QualitySpecLine.Quantitative;
                          InspectionSheet."Paper Type":=PaperTypeBuffer."Paper Type";
                          InspectionSheet."Paper GSM":=PaperTypeBuffer."Paper GSM";
                          InspectionSheet.Insert(true);
                        until QualitySpecLine.Next=0;
                      end;
                      //SamplePlanCounter:=SamplePlanCounter-1;
                     //UNTIL SamplePlanCounter = 0;
                   end;
                 end;
              end;

           end;
          until PaperTypeBuffer.Next=0;
        end;
    end;
}

