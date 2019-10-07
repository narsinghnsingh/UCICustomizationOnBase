table 50021 "Inspection Header"
{
    // version Samadhan Quality


    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;
        }
        field(2;"Source Type";Option)
        {
            CaptionML = ENU = 'Source Type';
            InitValue = Output;
            NotBlank = true;
            OptionCaption = 'Purchase Receipt,Output,Sales Order,Open';
            OptionMembers = "Purchase Receipt",Output,"Sales Order",Open;
        }
        field(3;"Job No.";Code[40])
        {
            TableRelation = IF ("Source Type"=CONST(Output)) "Production Order"."No." WHERE (Status=CONST(Released));

            trigger OnValidate()
            begin
                UpdateItem;
            end;
        }
        field(4;"Job Line No.";Integer)
        {
            InitValue = 10000;
            TableRelation = IF ("Source Type"=CONST(Output)) "Prod. Order Line"."Line No." WHERE (Status=FILTER(Released),
                                                                                                  "Prod. Order No."=FIELD("Job No."));

            trigger OnValidate()
            begin
                UpdateItem;
            end;
        }
        field(10;"Item No.";Code[20])
        {
            TableRelation = Item."No." WHERE (Blocked=CONST(false));

            trigger OnValidate()
            begin
                Item.Get("Item No.");
                "Item Description":=Item.Description;
                "Specification ID":=Item."Quality Spec ID";
            end;
        }
        field(11;"Item Description";Text[250])
        {
            Editable = false;
        }
        field(12;"Specification ID";Code[20])
        {
            TableRelation = "Quality Spec Header"."Spec ID" WHERE (Status=CONST(Certified));
        }
        field(13;Posted;Boolean)
        {
        }
        field(14;Remarks;Text[250])
        {
            CaptionML = ENU = 'Remark for footer';
            InitValue = 'THIS IS TO CERTIFY THAT ABOVE - MENTIONED PRODUCT UTILIZES A MATERIAL THAT CONFORMS WITHTHE TECHNICAL SPCEFICATION. THIS MATERIAL IS "FREE FROM PESTICIDES AND HEAVY METALS”';
        }
        field(15;"Vendor No.";Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                Vendor.Reset;
                Vendor.SetRange(Vendor."No.","Vendor No.");
                if Vendor.FindFirst then begin
                  "Vendor Name":=Vendor.Name;

                end else begin
                  "Vendor Name":='';

                end;
            end;
        }
        field(16;"Insp. Date";Date)
        {
        }
        field(17;"Insp. By";Code[100])
        {
        }
        field(18;"Inspection Type";Option)
        {
            Description = '//Deepak';
            OptionCaption = 'Production,Sample Paper,Item';
            OptionMembers = Production,"Sample Paper",Item;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                "Job No.":='';
                "Job Line No.":=0;
                "Item No.":='';
                "Item Description":='';
                "Specification ID":='';
                "Paper Type":='';
                "Paper GSM":='';
            end;
        }
        field(2000;"Paper Type";Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=FILTER('PAPERTYPE'));
        }
        field(2001;"Paper GSM";Code[10])
        {
            Description = '//Deepak';
            TableRelation = "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=FILTER('PAPERGSM'));
        }
        field(2002;Sample;Boolean)
        {
            Description = '//Deepak';
        }
        field(2003;"Sample Remarks";Text[150])
        {
            Description = '//Deepak';
        }
        field(2005;"Vendor Name";Text[150])
        {
            Description = '//Deepak';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
         // Lines added by Deepak kUmar
         if "No." = '' then begin
            QASetup.Get;
            QASetup.TestField(QASetup."Inspection No. Series");
            NoSeriesMgt.InitSeries(QASetup."Inspection No. Series",'',0D,"No.",QASetup."Inspection No. Series");
          end;
    end;

    var
        Item: Record Item;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        QASetup: Record "Manufacturing Setup";
        ProdOrder: Record "Prod. Order Line";
        Vendor: Record Vendor;

    procedure UpdateItem()
    begin
        if "Source Type"= "Source Type":: Output then begin
          ProdOrder.Reset;
          ProdOrder.SetRange(ProdOrder.Status,ProdOrder.Status::Released);
          ProdOrder.SetRange(ProdOrder."Prod. Order No.","Job No.");
          ProdOrder.SetRange(ProdOrder."Line No.","Job Line No.");
          if ProdOrder.FindFirst then begin
            Validate("Item No.",ProdOrder."Item No.");
          end;
        end;
    end;

    procedure GenerateSpecLine(InspectionDocumentNo: Code[50])
    var
        InspectionLine: Record "Inspection Sheet";
        InspectionHeader: Record "Inspection Header";
        SpecHeader: Record "Quality Spec Header";
        SpecLine: Record "Quality Spec Line";
        InspectionSheet: Record "Inspection Sheet";
        EntryNumber: Integer;
    begin
        // Lines added BY deepak Kumar
        InspectionSheet.Reset;
        if InspectionSheet.FindLast then
          EntryNumber:=InspectionSheet."Entry No."
        else
          EntryNumber:=1;



        if "Inspection Type" = "Inspection Type"::"Sample Paper" then begin

          InspectionHeader.Reset;
          InspectionHeader.SetRange(InspectionHeader."No.",InspectionDocumentNo);
          if InspectionHeader.FindFirst then begin
            SpecHeader.Reset;
            SpecHeader.SetRange(SpecHeader."Paper Type","Paper Type");
            SpecHeader.SetRange(SpecHeader."Paper GSM","Paper GSM");
            if SpecHeader.FindFirst then begin
              SpecLine.Reset;
              SpecLine.SetRange(SpecLine."Spec ID",SpecHeader."Spec ID");
              if SpecLine.FindFirst then begin
                repeat
                  EntryNumber:=EntryNumber+1;
                  InspectionLine.Init;
                  InspectionLine."Entry No.":=EntryNumber;
                  InspectionLine."Source Type":=InspectionLine."Source Type"::Output;
                  InspectionLine."Source Document No.":=InspectionHeader."Job No.";
                  InspectionLine."Source Document Line No.":=InspectionHeader."Job Line No.";
                  InspectionLine."Inspection No.":=InspectionHeader."No.";
                  InspectionLine."Document Date":=WorkDate;
                  InspectionLine."Item No.":=InspectionHeader."Item No.";
                  InspectionLine."Item Description":=InspectionHeader."Item Description";
                  InspectionLine."Spec ID":=InspectionHeader."Specification ID";
                  InspectionLine."Created By":=UserId;
                  InspectionLine."Created Date":=Today;
                  InspectionLine."Created Time":=Time;
                  InspectionLine."Prod. Order No.":=InspectionHeader."Job No.";
                  InspectionLine."Prod. Order Line No.":=InspectionHeader."Job Line No.";
                  InspectionLine."QA Characteristic Code":=SpecLine."Character Code";
                  InspectionLine."QA Characteristic Description":=SpecLine.Description;
                  InspectionLine."Normal Value (Num)":=SpecLine."Normal Value (Num)";
                  InspectionLine."Min. Value (Num)":=SpecLine."Min. Value (Num)";
                  InspectionLine."Max. Value (Num)":=SpecLine."Max. Value (Num)";
                  InspectionLine."Normal Value (Text)":=SpecLine."Normal Value (Char)";
                  InspectionLine."Min. Value (Text)":=SpecLine."Min. Value (Char)";
                  InspectionLine."Max. Value (Text)":=SpecLine."Max. Value (Char)";
                  InspectionLine.Qualitative:=SpecLine.Qualitative;
                  InspectionLine.Quantitative:=SpecLine.Quantitative;
                  InspectionLine."Paper Type":=SpecHeader."Paper Type";
                  InspectionLine."Paper GSM":=SpecHeader."Paper GSM";
                  InspectionLine.Insert(true);

                until SpecLine.Next=0;
              end;
              Message('Inspection Line Created');
            end;
          end;


        end else begin

          InspectionHeader.Reset;
          InspectionHeader.SetRange(InspectionHeader."No.",InspectionDocumentNo);
          if InspectionHeader.FindFirst then begin
            InspectionHeader.TestField(InspectionHeader."Specification ID");
            SpecHeader.Reset;
            SpecHeader.SetRange(SpecHeader."Spec ID",InspectionHeader."Specification ID");
            if SpecHeader.FindFirst then begin
              SpecLine.Reset;
              SpecLine.SetRange(SpecLine."Spec ID",SpecHeader."Spec ID");
              if SpecLine.FindFirst then begin
                repeat
                  EntryNumber:=EntryNumber+1;
                  InspectionLine.Init;
                  InspectionLine."Entry No.":=EntryNumber;
                  InspectionLine."Source Type":=InspectionLine."Source Type"::Output;
                  InspectionLine."Source Document No.":=InspectionHeader."Job No.";
                  InspectionLine."Source Document Line No.":=InspectionHeader."Job Line No.";
                  InspectionLine."Inspection No.":=InspectionHeader."No.";
                  InspectionLine."Document Date":=WorkDate;
                  InspectionLine."Item No.":=InspectionHeader."Item No.";
                  InspectionLine."Item Description":=InspectionHeader."Item Description";
                  InspectionLine."Spec ID":=InspectionHeader."Specification ID";
                  InspectionLine."Created By":=UserId;
                  InspectionLine."Created Date":=Today;
                  InspectionLine."Created Time":=Time;
                  InspectionLine."Prod. Order No.":=InspectionHeader."Job No.";
                  InspectionLine."Prod. Order Line No.":=InspectionHeader."Job Line No.";
                  InspectionLine."QA Characteristic Code":=SpecLine."Character Code";
                  InspectionLine."QA Characteristic Description":=SpecLine.Description;
                  InspectionLine."Normal Value (Num)":=SpecLine."Normal Value (Num)";
                  InspectionLine."Min. Value (Num)":=SpecLine."Min. Value (Num)";
                  InspectionLine."Max. Value (Num)":=SpecLine."Max. Value (Num)";
                  InspectionLine."Normal Value (Text)":=SpecLine."Normal Value (Char)";
                  InspectionLine."Min. Value (Text)":=SpecLine."Min. Value (Char)";
                  InspectionLine."Max. Value (Text)":=SpecLine."Max. Value (Char)";
                  // Lines added By Deepak Kumar
                  InspectionLine."Sequence No":=SpecLine."Sequence No";
                  //End;
                  InspectionLine.Qualitative:=SpecLine.Qualitative;
                  InspectionLine.Quantitative:=SpecLine.Quantitative;
                  InspectionLine."Paper Type":=SpecHeader."Paper Type";
                  InspectionLine."Paper GSM":=SpecHeader."Paper GSM";
                  InspectionLine.Insert(true);

                until SpecLine.Next=0;
              end;
              Message('Inspection Line Created');
            end;
          end;
        end;
    end;

    procedure PostOutputInspection(InspectionNo: Code[50])
    var
        InspectionHeader: Record "Inspection Header";
        InspectionLine: Record "Inspection Sheet";
        PostedInspectionHeader: Record "Posted Inspection Sheet";
    begin
        // Lines added by Deepak Kumar
        InspectionHeader.Reset;
        InspectionHeader.SetRange(InspectionHeader."No.",InspectionNo);
        if InspectionHeader.FindFirst then begin

        if (InspectionHeader."Inspection Type" = InspectionHeader."Inspection Type"::Item) or
        (InspectionHeader."Inspection Type" = InspectionHeader."Inspection Type"::"Sample Paper")  then begin
            InspectionLine.Reset;
            InspectionLine.SetRange(InspectionLine."Source Type",InspectionLine."Source Type"::Output);
            InspectionLine.SetRange(InspectionLine."Inspection No.",InspectionHeader."No.");
            if InspectionLine.FindFirst then begin
              repeat
                if InspectionLine.Qualitative then begin
                  InspectionLine.TestField(InspectionLine."Actual  Value (Text)");
                end;
                if InspectionLine.Quantitative then
                InspectionLine.TestField(InspectionLine."Actual Value (Num)");
              until InspectionLine.Next=0;
            end;

            InspectionLine.Reset;
            InspectionLine.SetRange(InspectionLine."Source Type",InspectionLine."Source Type"::Output);
            InspectionLine.SetRange(InspectionLine."Inspection No.",InspectionHeader."No.");
            if InspectionLine.FindFirst then begin
              repeat
                PostedInspectionHeader.Init;
                PostedInspectionHeader."Inspection Receipt No.":=InspectionHeader."No.";
                PostedInspectionHeader."Item No.":=InspectionLine."Item No.";
                PostedInspectionHeader."QA Characteristic Code":=InspectionLine."QA Characteristic Code";
                PostedInspectionHeader."QA Characteristic Description":=InspectionLine."QA Characteristic Description";
                PostedInspectionHeader."Document Type":=InspectionLine."Source Type";
                PostedInspectionHeader."Document No.":=InspectionLine."Source Document No.";
                PostedInspectionHeader."Posting Date":=WorkDate;
                PostedInspectionHeader."Document Date":=InspectionLine."Document Date";
                PostedInspectionHeader."Item Description":=InspectionLine."Item Description";
                PostedInspectionHeader.Quantity:=InspectionLine."Quantity (Base)";
                PostedInspectionHeader."Spec ID":=InspectionLine."Spec ID";
                PostedInspectionHeader."Created By":=InspectionLine."Created By";
                PostedInspectionHeader."Created Date":=InspectionLine."Created Date";
                PostedInspectionHeader."Created Time":=InspectionLine."Created Time";
                PostedInspectionHeader."Posted Time":=Time;
                PostedInspectionHeader."Posted By":=UserId;
                PostedInspectionHeader."Item Type":=InspectionLine."Item Type";
                PostedInspectionHeader."Unit of Measure Code":=InspectionLine."Unit of Measure Code";
                PostedInspectionHeader."Qty. per Unit of Measure":=InspectionLine."Qty. per Unit of Measure";
                PostedInspectionHeader."Prod. Order No.":=InspectionHeader."Job No.";
                PostedInspectionHeader."Prod. Order Line No.":=InspectionHeader."Job Line No.";
                PostedInspectionHeader."Source Type":=InspectionHeader."Source Type";
                PostedInspectionHeader."Source Document No.":=InspectionHeader."Job No.";
                PostedInspectionHeader."Source Line No.":=InspectionHeader."Job Line No.";
                PostedInspectionHeader."Normal Value (Num)":=InspectionLine."Normal Value (Num)";
                PostedInspectionHeader."Min. Value (Num)":=InspectionLine."Min. Value (Num)";
                PostedInspectionHeader."Max. Value (Num)":=InspectionLine."Max. Value (Num)";
                PostedInspectionHeader."Actual Value (Num)":=InspectionLine."Actual Value (Num)";
                PostedInspectionHeader."Normal Value (Text)":=InspectionLine."Normal Value (Text)";
                PostedInspectionHeader."Min. Value (Text)":=InspectionLine."Min. Value (Text)";
                PostedInspectionHeader."Max. Value (Text)":=InspectionLine."Max. Value (Text)";
                PostedInspectionHeader."Actual  Value (Text)":=InspectionLine."Actual  Value (Text)";
                PostedInspectionHeader."Unit of Measure":=InspectionLine."Unit of Measure";
                PostedInspectionHeader."Reason Code":=InspectionLine."Reason Code";
                PostedInspectionHeader.Remarks:=InspectionLine.Remarks;
                PostedInspectionHeader."Inspection Persons":=InspectionLine."Inspection Persons";
                PostedInspectionHeader.Qualitative:=InspectionLine.Qualitative;
                PostedInspectionHeader."Sample Code":=InspectionLine."Sample Code";
                PostedInspectionHeader.Quantitative:=InspectionLine.Quantitative;
                PostedInspectionHeader."Paper Type":=InspectionLine."Paper Type";
                PostedInspectionHeader."Paper GSM":=InspectionLine."Paper GSM";
                // LOines added BY Deepak Kumar
                PostedInspectionHeader."Sequence No":=InspectionLine."Sequence No";
                //End;
                PostedInspectionHeader."Observation 1 (Num)":=InspectionLine."Observation 1 (Num)";
                PostedInspectionHeader."Observation 2 (Num)":=InspectionLine."Observation 2 (Num)";
                PostedInspectionHeader."Observation 3 (Num)":=InspectionLine."Observation 3 (Num)";
                PostedInspectionHeader."Observation 4 (Num)":=InspectionLine."Observation 4 (Num)";
                PostedInspectionHeader.Insert(true);


              until InspectionLine.Next=0;
            end;
          InspectionLine.DeleteAll;
         end;

        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


          if InspectionHeader."Inspection Type" = InspectionHeader."Inspection Type"::Production then begin

            InspectionLine.Reset;
            InspectionLine.SetRange(InspectionLine."Source Type",InspectionLine."Source Type"::Output);
            InspectionLine.SetRange(InspectionLine."Source Document No.",InspectionHeader."Job No.");
            InspectionLine.SetRange(InspectionLine."Source Document Line No.",InspectionHeader."Job Line No.");
            if InspectionLine.FindFirst then begin
              repeat
                if InspectionLine.Qualitative then begin
                  InspectionLine.TestField(InspectionLine."Actual  Value (Text)");
                end;
                if InspectionLine.Quantitative then
                InspectionLine.TestField(InspectionLine."Actual Value (Num)");
              until InspectionLine.Next=0;
            end;

            InspectionLine.Reset;
            InspectionLine.SetRange(InspectionLine."Source Type",InspectionLine."Source Type"::Output);
            InspectionLine.SetRange(InspectionLine."Source Document No.",InspectionHeader."Job No.");
            InspectionLine.SetRange(InspectionLine."Source Document Line No.",InspectionHeader."Job Line No.");
            if InspectionLine.FindFirst then begin
              repeat
                PostedInspectionHeader.Init;
                PostedInspectionHeader."Inspection Receipt No.":=InspectionHeader."No.";
                PostedInspectionHeader."Item No.":=InspectionLine."Item No.";
                PostedInspectionHeader."QA Characteristic Code":=InspectionLine."QA Characteristic Code";
                PostedInspectionHeader."QA Characteristic Description":=InspectionLine."QA Characteristic Description";
                PostedInspectionHeader."Document Type":=InspectionLine."Source Type";
                PostedInspectionHeader."Document No.":=InspectionLine."Source Document No.";
                PostedInspectionHeader."Posting Date":=WorkDate;
                PostedInspectionHeader."Document Date":=InspectionLine."Document Date";
                PostedInspectionHeader."Item Description":=InspectionLine."Item Description";
                PostedInspectionHeader.Quantity:=InspectionLine."Quantity (Base)";
                PostedInspectionHeader."Spec ID":=InspectionLine."Spec ID";
                PostedInspectionHeader."Created By":=InspectionLine."Created By";
                PostedInspectionHeader."Created Date":=InspectionLine."Created Date";
                PostedInspectionHeader."Created Time":=InspectionLine."Created Time";
                PostedInspectionHeader."Posted Time":=Time;
                PostedInspectionHeader."Posted By":=UserId;
                PostedInspectionHeader."Item Type":=InspectionLine."Item Type";
                PostedInspectionHeader."Unit of Measure Code":=InspectionLine."Unit of Measure Code";
                PostedInspectionHeader."Qty. per Unit of Measure":=InspectionLine."Qty. per Unit of Measure";
                PostedInspectionHeader."Prod. Order No.":=InspectionHeader."Job No.";
                PostedInspectionHeader."Prod. Order Line No.":=InspectionHeader."Job Line No.";
                PostedInspectionHeader."Source Type":=InspectionHeader."Source Type";
                PostedInspectionHeader."Source Document No.":=InspectionHeader."Job No.";
                PostedInspectionHeader."Source Line No.":=InspectionHeader."Job Line No.";
                PostedInspectionHeader."Normal Value (Num)":=InspectionLine."Normal Value (Num)";
                PostedInspectionHeader."Min. Value (Num)":=InspectionLine."Min. Value (Num)";
                PostedInspectionHeader."Max. Value (Num)":=InspectionLine."Max. Value (Num)";
                PostedInspectionHeader."Actual Value (Num)":=InspectionLine."Actual Value (Num)";
                PostedInspectionHeader."Normal Value (Text)":=InspectionLine."Normal Value (Text)";
                PostedInspectionHeader."Min. Value (Text)":=InspectionLine."Min. Value (Text)";
                PostedInspectionHeader."Max. Value (Text)":=InspectionLine."Max. Value (Text)";
                PostedInspectionHeader."Actual  Value (Text)":=InspectionLine."Actual  Value (Text)";
                PostedInspectionHeader."Unit of Measure":=InspectionLine."Unit of Measure";
                PostedInspectionHeader."Reason Code":=InspectionLine."Reason Code";
                PostedInspectionHeader.Remarks:=InspectionLine.Remarks;
                PostedInspectionHeader."Inspection Persons":=InspectionLine."Inspection Persons";
                PostedInspectionHeader.Qualitative:=InspectionLine.Qualitative;
                PostedInspectionHeader."Sample Code":=InspectionLine."Sample Code";
                PostedInspectionHeader.Quantitative:=InspectionLine.Quantitative;
                PostedInspectionHeader."Paper Type":=InspectionLine."Paper Type";
                PostedInspectionHeader."Paper GSM":=InspectionLine."Paper GSM";
                // LOines added BY Deepak Kumar
                PostedInspectionHeader."Sequence No":=InspectionLine."Sequence No";
                //End;
                PostedInspectionHeader."Observation 1 (Num)":=InspectionLine."Observation 1 (Num)";
                PostedInspectionHeader."Observation 2 (Num)":=InspectionLine."Observation 2 (Num)";
                PostedInspectionHeader."Observation 3 (Num)":=InspectionLine."Observation 3 (Num)";
                PostedInspectionHeader."Observation 4 (Num)":=InspectionLine."Observation 4 (Num)";
                PostedInspectionHeader.Insert(true);


              until InspectionLine.Next=0;
            end;
          InspectionLine.DeleteAll;
         end;
          InspectionHeader.Posted:=true;
          InspectionHeader.Modify(true);
          Message('Posted');
        end;
    end;
}

