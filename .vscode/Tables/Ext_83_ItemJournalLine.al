tableextension 50017 Ext_ItemJournalLine extends "Item Journal Line"
{
    fields
    {
        field(50000; "Item Issue"; Boolean)
        {
        }
        field(50001; "Plate Item"; Code[20])
        {
            TableRelation = Item."No." WHERE ("Plate Item" = CONST (true));
        }
        field(50002; "Plate Variant"; Code[20])
        {
            Editable = false;
            TableRelation = "Item Variant".Code WHERE ("Item No." = FIELD ("Plate Item"));
        }
        field(50004; "Sampling Plan Counter"; Integer)
        {
            Description = 'store the no of sampling plans generated';
            Editable = false;
        }
        field(50005; "Origin Purch. Rcpt No."; Code[20])
        {
            Description = 'store in case of quality , the orginal Purch. Rcpt Header and Line no against which this ILE has been generated';
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(50006; "Origin Purch. Rcpt L No."; Integer)
        {
            Description = 'to store in case of quality , the orginal Purch. Rcpt Header and Line no against which this ILE has been generated';
        }
        field(50007; "Plate Item No. 2"; Code[20])
        {
        }
        field(50008; "Roll Inventory"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Description = 'Paper Roll Inventory';
            Editable = false;
            TableRelation = "Item Variant"."Remaining Quantity" WHERE (Code = FIELD ("Variant Code"));
        }
        field(50009; "Final Inventory"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Roll Inventory" < "Final Inventory" THEN
                    ERROR('The Final Inventory %1 cannot be greater than Roll Inventory %2', "Final Inventory", "Roll Inventory")
                ELSE
                    VALIDATE(Quantity, ("Roll Inventory" - "Final Inventory"));
            end;
        }
        field(50010; "Die Number"; Code[20])
        {
            TableRelation = "Fixed Asset"."No.";
        }
        field(50011; "Final Location"; Code[20])
        {
            TableRelation = Location WHERE ("Country/Region Code" = FILTER (<> ''));
        }
        field(50012; "Line Inserted"; Boolean)
        {
            Description = 'To flag lines processed in Post loop for inserting transfer lines to final location';
        }
        field(50013; "Paper Position"; Option)
        {
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(50014; "Quantity In PCS"; Decimal)
        {

            trigger OnValidate()
            begin
                //Deepak//UpdateOffSetQuantity;
            end;
        }
        field(50015; "Make Ready Qty"; Decimal)
        {

            trigger OnValidate()
            begin
                //Deepak
                //UpdateOffSetQuantity;
            end;
        }
        field(50016; "Item Weight"; Decimal)
        {
        }
        field(50017; "Part Code"; Option)
        {
            OptionCaption = ' ,Part-1,Part-2,Part-3,Part-4';
            OptionMembers = " ","Part-1","Part-2","Part-3","Part-4";
        }
        field(50018; "Remaining Quantity"; Decimal)
        {
        }
        field(50020; "Paper GSM"; Code[20])
        {
            Editable = true;
        }
        field(50021; "Paper Type"; Code[20])
        {
            Editable = true;
        }
        field(50022; "Deckle Size (mm)"; Decimal)
        {
            Editable = true;
            MinValue = 0;
        }
        field(50023; Origin; Code[20])
        {
            Editable = false;
        }
        field(50024; "Validate Paper ORIGIN"; Boolean)
        {
        }
        field(50025; "Additional Output"; Boolean)
        {
        }
        field(50026; "Schedule Doc. No."; Code[20])
        {
            TableRelation = "Production Schedule"."Schedule No." WHERE ("Schedule Published" = CONST (true), "Schedule Closed" = CONST (false));
        }
        field(50027; "Posted Output Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Order Type" = CONST (Production), "Order No." = FIELD ("Order No."),
            "Order Line No." = FIELD ("Order Line No."), "Operation No." = FIELD ("Operation No.")));
            Editable = false;
        }
        field(50028; "Subcontracting Order No."; Code[20])
        {
            Editable = false;
        }
        field(50029; "Production Order Sam"; Code[20])
        {
            TableRelation = "Production Order"."No.";
        }
        field(50030; "Prod. Order Line No. Sam"; Integer)
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE ("Prod. Order No." = FIELD ("Production Order Sam"));
        }
        field(50031; Inventory; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Item No." = FIELD ("Item No."), "Location Code" = FIELD (FILTER ("Location Code"))));
            CaptionML = ENU = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50032; "Other Consumption Type"; Option)
        {
            OptionCaption = ' ,Other Consumption,Negative Adjustment';
            OptionMembers = " ","Other Consumption","Negative Adjustment";
        }
        field(50033; "Take Up"; Decimal)
        {

        }
        field(50034; "Flute Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,A,B,C,E,F';
            OptionMembers = " ",A,B,C,E,F;
        }

        field(50035; "Old Production Order No."; code[20])
        {
            TableRelation = IF ("Order Type" = CONST (Production)) "Prod. Order Line"."Prod. Order No." WHERE (Status = CONST (Released));

        }
        field(50036; "Old Prod. Order Line No."; Integer)
        {
            TableRelation = IF ("Order Type" = CONST (Production)) "Prod. Order Line"."Line No." WHERE (Status = CONST (Released), "Prod. Order No." = FIELD ("Old Production Order No."));

            trigger OnValidate()
            var
                ProdOrderLine: Record "Prod. Order Line";
            begin
                ProdOrderLine.RESET;
                ProdOrderLine.SETRANGE(Status, ProdOrderLine.Status::Released);
                ProdOrderLine.SETRANGE("Prod. Order No.", "Old Production Order No.");
                ProdOrderLine.SETRANGE("Line No.", "Old Prod. Order Line No.");
                IF ProdOrderLine.FINDFIRST THEN
                    VALIDATE("Old Prod. Order Item No.", ProdOrderLine."Item No.")
                ELSE
                    "Old Prod. Order Item No." := '';

            end;

        }
        field(50037; "Old Prod. Order Item No."; Code[20])
        {
            Editable = false;
            trigger OnValidate()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
            begin
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Order Type", ItemLedgerEntry."Order Type"::Production);
                ItemLedgerEntry.SETRANGE("Order No.", "Old Production Order No.");
                ItemLedgerEntry.SETRANGE("Order Line No.", "Old Prod. Order Line No.");
                ItemLedgerEntry.SETRANGE("Item No.", "Old Prod. Order Item No.");
                ItemLedgerEntry.SETFILTER("Remaining Quantity", '>=%1', "Old Prod. Order Qty.");
                IF NOT ItemLedgerEntry.FINDFIRST THEN
                    ERROR('There is no sufficient entry to transfer in this Job %1', ItemLedgerEntry."Order No.");
            end;
        }
        field(50038; "Old Prod. Order Qty."; Decimal)
        {
            trigger OnValidate()
            begin
                IF "Old Prod. Order Qty." > "Output Quantity" THEN
                    ERROR('Old Order Qty. %1 should not be greater than Output Qty.%2', "Old Prod. Order Qty.", "Output Quantity");

            end;

        }
        field(50039; "Swap Output"; Boolean)
        {
            Editable = false;
        }
        field(50044; "Plate Variant 2"; Code[20])
        {
        }
        field(50047; "Salesperson Code"; Code[10])
        {
            CaptionML = ENU = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50048; "Sales Order No."; Code[20])
        {
        }
        field(60000; "Requisition No."; Code[20])
        {
            TableRelation = "Requisition Header"."Requisition No." WHERE ("Short Closed" = FILTER (false), Status = FILTER (Released));
            trigger OnValidate()
            var
                ReqHeader: Record "Requisition Header";
            begin
                ReqHeader.RESET();
                ReqHeader.SETRANGE(ReqHeader."Requisition No.", "Requisition No.");
                IF ReqHeader.FINDFIRST THEN BEGIN
                    IF (ReqHeader."Extra Material" = TRUE) THEN
                        ReqHeader.TESTFIELD(ReqHeader."Extra Material Approved", TRUE);
                    IF (ReqHeader."Requisition Type" = ReqHeader."Requisition Type"::"Production Order") OR (ReqHeader."Requisition Type" = ReqHeader."Requisition Type"::"Production Schedule") THEN BEGIN
                        VALIDATE("Order Type", 1);
                        VALIDATE("Order No.", ReqHeader."Prod. Order No");
                        VALIDATE("Order Line No.", ReqHeader."Prod. Order Line No.");
                    END;
                END;
            end;
        }
        field(60001; "Requisition Rem. Quantity"; Decimal)
        {
            Editable = false;
        }
        field(60003; "Requisition Line No."; Integer)
        {
            Editable = true;
            TableRelation = "Requisition Line SAM"."Requisition Line No." WHERE ("Requisition No." = FIELD ("Requisition No."));

            trigger OnValidate()
            var
                ReqLineSam: Record "Requisition Line SAM";
                Item: Record Item;
            begin

                TESTFIELD("Requisition No.");

                ReqLineSam.RESET;
                ReqLineSam.SETRANGE(ReqLineSam."Requisition No.", "Requisition No.");
                ReqLineSam.SETRANGE(ReqLineSam."Requisition Line No.", "Requisition Line No.");
                IF ReqLineSam.FINDFIRST THEN BEGIN
                    VALIDATE("Item No.", ReqLineSam."Item No.");
                    Item.GET(ReqLineSam."Item No.");
                    IF NOT Item."Roll ID Applicable" THEN
                        VALIDATE(Quantity, ReqLineSam.Quantity);

                    "Paper GSM" := FORMAT(Item."Paper GSM");
                    "Paper Type" := Item."Paper Type";
                    "Deckle Size (mm)" := Item."Deckle Size (mm)";
                    //  ORIGIN:=  Item.ORIGIN;
                    "Validate Paper ORIGIN" := ReqLineSam."Validate Origin";
                END;
            end;
        }
        field(60004; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                //Lines added by Deepak Kumar
                UpdateRunTime();
            end;
        }
        field(60005; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                //Lines added by Deepak Kumar
                UpdateRunTime();
            end;
        }
        field(60006; "Item Identifier"; Code[50])
        {
            CaptionML = ENU = 'Item Identifier ( Bar Code)';
            Description = 'For Bar Code Purpose';

            trigger OnValidate()
            var
                ItemIdentifier: Record "Item Identifier";
                ItemVariant: Record "Item Variant";
            begin
                // Lines added BY Deepak Kumar
                ItemIdentifier.RESET;
                ItemIdentifier.SETRANGE(ItemIdentifier.Code, "Item Identifier");
                IF ItemIdentifier.FINDFIRST THEN BEGIN

                    IF ItemIdentifier."Variant Code" <> '' THEN BEGIN
                        ItemVariant.RESET;
                        ItemVariant.SETRANGE(ItemVariant."Item No.", ItemIdentifier."Item No.");
                        ItemVariant.SETRANGE(ItemVariant.Code, ItemIdentifier."Variant Code");
                        IF ItemVariant.FINDFIRST THEN BEGIN
                            IF ItemVariant.Status <> ItemVariant.Status::Open THEN
                                ERROR('Roll is not in Use Status, Please Complete the Quality Process');
                        END;
                        VALIDATE("Item No.", ItemIdentifier."Item No.");
                        VALIDATE("Variant Code", ItemIdentifier."Variant Code");
                    END ELSE BEGIN
                        VALIDATE("Item No.", ItemIdentifier."Item No.");
                    END;
                    MODIFY(TRUE);
                END ELSE BEGIN
                    ERROR('Item Identifier not available, please check the Identifier values');
                END;
            end;
        }
        field(62001; "Employee Code"; Code[20])
        {
            Description = '//deepak';
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                // Lines added by Deepak kumar
                Employee.RESET;
                Employee.SETRANGE(Employee."No.", "Employee Code");
                IF Employee.FINDFIRST THEN BEGIN
                    "Employee Name" := Employee."First Name";
                END ELSE BEGIN
                    "Employee Name" := '';
                END;
            end;
        }
        field(62002; "Employee Name"; Text[150])
        {
            Description = '//deepak';
            Editable = false;
        }
        field(62003; "ILE Entry No."; Integer)
        {
            Description = '//firoz for revaluation';
        }

    }

    var
        InsSheet: Record "Inspection Sheet";
        RollMaster: Record "Item Variant";
        NoofDay: Integer;
        TempRunTime: Decimal;
        TempRunTime2: Decimal;
        Workshift: Record "Work Shift";
        ManSetup: Record "Manufacturing Setup";
        ILE: Record "Item Ledger Entry";
        RollLedgerEntry: Record "Item Variant";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Sam001: Label 'You cannot consume more than allowed percentage. Allowed percentage is %1 allowed quantity %2 actual remaining quantity is %3. Please get approval from authorised person.';
        Item: Record Item;

    procedure GenerateLine(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; RequisitionNumber: Code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        RequisitionHeader: Record "Requisition Header";
        RequisitionLine: Record "Requisition Line SAM";
        TempLineNumber: Integer;
        ItemJnlBatch: Record "Item Journal Batch";
        NoSeriesLine: Record "No. Series Line";
        DocNo: Code[20];

    begin

        //Lines added by Deepak Kumar
        ItemJnlBatch.GET(JournalTemplateName, JournalBatchName);
        DocNo := '';

        NoSeriesMgt.InitSeries(ItemJnlBatch."Posting No. Series", ItemJnlBatch."Posting No. Series", TODAY, DocNo, ItemJnlBatch."Posting No. Series");
        RequisitionHeader.RESET;
        RequisitionHeader.SETRANGE(RequisitionHeader."Requisition No.", RequisitionNumber);
        IF RequisitionHeader.FINDFIRST THEN BEGIN
            TempLineNumber := 0;
            RequisitionLine.RESET;
            RequisitionLine.SETRANGE(RequisitionLine."Requisition No.", RequisitionHeader."Requisition No.");
            RequisitionLine.SETFILTER("Remaining Quantity", '<>0');
            IF RequisitionLine.FINDFIRST THEN BEGIN
                REPEAT
                    TempLineNumber := TempLineNumber + 1;
                    ItemJournalLine.INIT;
                    ItemJournalLine."Journal Template Name" := JournalTemplateName;
                    ItemJournalLine."Journal Batch Name" := JournalBatchName;
                    ItemJournalLine."Line No." := TempLineNumber;
                    ItemJournalLine.INSERT(TRUE);
                    ItemJournalLine.VALIDATE("Item No.", RequisitionLine."Item No.");
                    Item.GET(ItemJournalLine."Item No.");
                    ItemJournalLine."Posting Date" := WORKDATE;
                    ItemJournalLine."Paper GSM" := FORMAT(Item."Paper GSM");
                    ItemJournalLine."Paper Type" := Item."Paper Type";
                    ItemJournalLine."Deckle Size (mm)" := Item."Deckle Size (mm)";
                    IF RequisitionHeader."Prod. Order No" <> '' THEN
                        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Consumption
                    ELSE
                        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";

                    ItemJournalLine.VALIDATE("Document No.", DocNo);
                    ItemJournalLine."Source Code" := 'ITEMJNL';
                    ItemJournalLine."Requisition No." := RequisitionLine."Requisition No.";
                    ItemJournalLine."Requisition Line No." := RequisitionLine."Requisition Line No.";
                    ItemJournalLine."Requisition Rem. Quantity" := RequisitionLine."Remaining Quantity";

                    IF RequisitionHeader."Prod. Order No" <> '' THEN BEGIN
                        ItemJournalLine.VALIDATE("Order Type", 1);
                        ItemJournalLine.VALIDATE("Order No.", RequisitionLine."Prod. Order No");
                        ItemJournalLine.VALIDATE("Order Line No.", RequisitionLine."Prod. Order Line No.");
                    END;
                    ItemJournalLine.Description := RequisitionLine.Description;

                    ItemJournalLine.MODIFY(TRUE);
                UNTIL RequisitionLine.NEXT = 0;
            END;
        END;
    end;

    procedure UpdateRunTime()
    begin
        // Lines added BY Deepak Kumar

        IF ("Start Date" > "End Date") AND ("End Date" <> 0D) THEN
            ERROR('End Date must be greater than Start Date.');

        IF ("Start Date" <> 0D) AND ("End Date" <> 0D) THEN BEGIN
            IF "Start Date" = "End Date" THEN BEGIN
                IF "Starting Time" > "Ending Time" THEN
                    ERROR('End Time must be greater than Start Time.');

                VALIDATE("Run Time", (("Ending Time" - "Starting Time") / 60000) - "Stop Time" - "Setup Time");
            END ELSE BEGIN
                NoofDay := "End Date" - "Start Date";
                IF NoofDay > 1 THEN
                    ERROR('Shift can not be more than one, Please check Start Date and End Date');

                TempRunTime := 235900T - "Starting Time";
                TempRunTime2 := "Ending Time" - 000100T;
                VALIDATE("Run Time", (((TempRunTime + TempRunTime2) / 60000) + 2) - "Stop Time" - "Setup Time");
            END;
        END;
    end;

    procedure ValidateShiftTime()
    begin
        Workshift.RESET;
        Workshift.SETRANGE(Workshift.Code, "Work Shift Code");
        IF Workshift.FINDFIRST THEN BEGIN
            IF Workshift."Shift Start Time" > "Starting Time" THEN
                MESSAGE('Start Time and/Or End Time beyond Shift Time, Shift Time %1 %2', Workshift."Shift Start Time", Workshift."Shift End Time");
            IF Workshift."Shift End Time" < "Ending Time" THEN
                MESSAGE('Start Time and/Or End Time beyond Shift Time, Shift Time %1 %2', Workshift."Shift Start Time", Workshift."Shift End Time");
        END;
    end;

    procedure ValidatePlate(ProductionOrderNumber: Code[100])
    var
        ProdOrder: Record "Production Order";
        ItemMaster: Record Item;
        ItemVariant: Record "Item Variant";
        PlateMaster: Record Item;
    begin
        // Lines added BY Deepak Kumar
        ManSetup.GET();
        IF ManSetup."Printing Plate Active" THEN BEGIN
            ProdOrder.RESET;
            ProdOrder.SETRANGE(ProdOrder.Status, ProdOrder.Status::Released);
            ProdOrder.SETRANGE(ProdOrder."Source Type", ProdOrder."Source Type"::Item);
            ProdOrder.SETRANGE(ProdOrder."No.", ProductionOrderNumber);
            IF ProdOrder.FINDFIRST THEN BEGIN
                ItemMaster.RESET;
                ItemMaster.SETRANGE(ItemMaster."No.", ProdOrder."Source No.");
                IF ItemMaster.FINDFIRST THEN BEGIN

                    ItemMaster.TESTFIELD(ItemMaster."Plate Item No.");
                    PlateMaster.RESET;
                    PlateMaster.SETRANGE(PlateMaster."No.", ItemMaster."Plate Item No.");
                    IF PlateMaster.FINDFIRST THEN BEGIN
                        PlateMaster.TESTFIELD("Ready for Print", TRUE);
                        VALIDATE("Plate Item", ItemMaster."Plate Item No.");
                        ItemVariant.RESET;
                        ItemVariant.SETRANGE(ItemVariant."Item No.", ItemMaster."Plate Item No.");
                        ItemVariant.SETRANGE(ItemVariant."Active Variant", TRUE);
                        IF ItemVariant.FINDFIRST THEN BEGIN
                            VALIDATE("Plate Variant", ItemVariant.Code);
                        END;
                    END;
                    //MODIFY(TRUE);
                END;
            END;
        END;
    end;

    procedure ValidateDie(ProductionOrderNumber: Code[100]; ProdOrderLineNo: Integer)
    var
        ProdOrderLine: Record "Prod. Order Line";
        ItemMaster: Record Item;
        ItemVariant: Record "Item Variant";
        PlateMaster: Record Item;
        DieMaster: Record "Fixed Asset";
        EstimateHeader: Record "Product Design Header";
    begin
        // Lines added BY Deepak Kumar
        /*ManSetup.GET();
        IF  MfgSetup."Die Mandatory"  THEN
          BEGIN
             ProdOrderLine.RESET;
             ProdOrderLine.SETRANGE(ProdOrderLine.Status,ProdOrderLine.Status::Released);
             ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.",ProductionOrderNumber);
             ProdOrderLine.SETRANGE(ProdOrderLine."Line No.",ProdOrderLineNo);
             IF ProdOrderLine.FINDFIRST THEN BEGIN
               EstimateHeader.RESET;
               EstimateHeader.SETRANGE(EstimateHeader."Product Design Type",ProdOrderLine."Product Design Type");
               EstimateHeader.SETRANGE(EstimateHeader."Product Design No.",ProdOrderLine."Product Design No.");
               EstimateHeader.SETRANGE(EstimateHeader."Sub Comp No.",ProdOrderLine."Sub Comp No.");
               IF EstimateHeader.FINDFIRST THEN BEGIN
                 IF EstimateHeader."Die Punching" THEN BEGIN
        
                 END;
               END;
        
        
               ItemMaster.RESET;
               ItemMaster.SETRANGE(ItemMaster."No.",ProdOrder."Source No.");
               IF ItemMaster.FINDFIRST THEN BEGIN
        
                 ItemMaster.TESTFIELD(ItemMaster."Die Number");
                 DieMaster.RESET;
                 DieMaster.SETRANGE(DieMaster."No.",ItemMaster."Die Number");
                 IF DieMaster.FINDFIRST THEN BEGIN
                  DieMaster.TESTFIELD(DieMaster.Inactive,FALSE);
                  DieMaster.TESTFIELD(DieMaster.Blocked,FALSE);
                  DieMaster.TESTFIELD(DieMaster.Die,TRUE);
                  VALIDATE("Die Number",DieMaster."No.");
                 END;
                 //MODIFY(TRUE);
               END;
             END;
          END;*/

    end;

    procedure CheckPreviousStageOutput(ProdOrderNumber: Code[20]; ProdOrderLineNumber: Integer; OperationNumber: Code[20]; OutputQty: Decimal; PreValue: Decimal)
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        Sam001: Label '<>''''';
        CapacityLedgerEntry: Record "Capacity Ledger Entry";
        ActualOutputQty: Decimal;
        ProductionOrderHeader: Record "Production Order";
        CurrOperationOutputQuantity: Decimal;
        ItemJournalLine: Record "Item Journal Line";
        CurrStageOutput: Decimal;
        PreviousStageOutput: Decimal;
        ProdOrderQuantity: Decimal;
        MaxOutputQuantity: Decimal;
        PreviousStageRouting: Record "Prod. Order Routing Line";
        PreviousStageAvalQuantity: Decimal;
        MfgSetup: Record "Manufacturing Setup";
        AddtionalOrderQuantity: Decimal;
        ProdOrderLine: Record "Prod. Order Line";
        ProductDesignHeader: Record "Product Design Header";
        Customer: Record Customer;
    begin
        CurrOperationOutputQuantity := 0;
        ActualOutputQty := 0;
        CurrStageOutput := 0;
        ProdOrderQuantity := 0;
        MaxOutputQuantity := 0;
        PreviousStageAvalQuantity := 0;



        // Lines added By Deepak Kumar/// for Check with Production Order Quantity
        ProductionOrderHeader.RESET;
        ProductionOrderHeader.SETRANGE(ProductionOrderHeader.Status, ProductionOrderHeader.Status::Released);
        ProductionOrderHeader.SETRANGE(ProductionOrderHeader."No.", ProdOrderNumber);
        IF ProductionOrderHeader.FINDFIRST THEN BEGIN
            ProductionOrderHeader.CALCFIELDS(ProductionOrderHeader."Additional Output Quantity");
            AddtionalOrderQuantity := ProductionOrderHeader."Additional Output Quantity";

            // Current Item Journal Line Update
            ItemJournalLine.RESET;
            ItemJournalLine.SETRANGE(ItemJournalLine."Order Type", ItemJournalLine."Order Type"::Production);
            ItemJournalLine.SETRANGE(ItemJournalLine."Order No.", ProdOrderNumber);
            ItemJournalLine.SETRANGE(ItemJournalLine."Order Line No.", ProdOrderLineNumber);
            ItemJournalLine.SETRANGE(ItemJournalLine."Operation No.", OperationNumber);
            IF ItemJournalLine.FINDFIRST THEN BEGIN
                REPEAT
                    CurrStageOutput := CurrStageOutput + ItemJournalLine."Output Quantity";
                UNTIL ItemJournalLine.NEXT = 0;
            END;
            CurrStageOutput := CurrStageOutput + (OutputQty - PreValue);


            // Lines Added by Deepak Kumar 23 04 15
            MfgSetup.GET;
            ProdOrderLine.RESET;
            ProdOrderLine.SETRANGE(ProdOrderLine.Status, ProdOrderLine.Status::Released);
            ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.", ProdOrderNumber);
            ProdOrderLine.SETRANGE(ProdOrderLine."Line No.", ProdOrderLineNumber);
            IF ProdOrderLine.FINDFIRST THEN BEGIN
                ProdOrderQuantity := ProdOrderLine.Quantity + ((ProdOrderLine.Quantity * MfgSetup."Output Tolerance %") / 100);
            END;

            ProductDesignHeader.RESET;
            ProductDesignHeader.SETRANGE(ProductDesignHeader."Product Design Type", ProductDesignHeader."Product Design Type"::Main);
            ProductDesignHeader.SETRANGE(ProductDesignHeader."Product Design No.", ProdOrderLine."Estimate Code");
            IF ProductDesignHeader.FINDFIRST THEN BEGIN
                Customer.GET(ProductDesignHeader.Customer);
                IF Customer."Conditional Shipping Tolerance" = TRUE THEN BEGIN
                    ProdOrderLine.RESET;
                    ProdOrderLine.SETRANGE(ProdOrderLine.Status, ProdOrderLine.Status::Released);
                    ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.", ProdOrderNumber);
                    ProdOrderLine.SETRANGE(ProdOrderLine."Line No.", ProdOrderLineNumber);
                    IF ProdOrderLine.FINDFIRST THEN BEGIN
                        ProdOrderQuantity := ProdOrderLine.Quantity + ((ProdOrderLine.Quantity * Customer."Production Tolerance %") / 100);
                    END;
                END;
            END;

            ProdOrderRoutingLine.RESET;
            ProdOrderRoutingLine.SETRANGE(ProdOrderRoutingLine.Status, ProdOrderRoutingLine.Status::Released);
            ProdOrderRoutingLine.SETRANGE(ProdOrderRoutingLine."Prod. Order No.", ProdOrderNumber);
            ProdOrderRoutingLine.SETRANGE(ProdOrderRoutingLine."Routing Reference No.", ProdOrderLineNumber);
            ProdOrderRoutingLine.SETRANGE(ProdOrderRoutingLine."Operation No.", OperationNumber);
            IF ProdOrderRoutingLine.FINDFIRST THEN BEGIN
                ProdOrderRoutingLine.CALCFIELDS(ProdOrderRoutingLine."Actual Output Quantity");
                CurrOperationOutputQuantity := ProdOrderRoutingLine."Actual Output Quantity";

                ProdOrderRoutingLine.CALCFIELDS(ProdOrderRoutingLine."Work Center Category");

                IF (ProdOrderRoutingLine."Die Cut Ups" > 0) AND (ProdOrderRoutingLine."Work Center Category" <> ProdOrderRoutingLine."Work Center Category"::Corrugation) THEN
                    MaxOutputQuantity := ((ProdOrderQuantity + AddtionalOrderQuantity) / ProdOrderRoutingLine."Die Cut Ups") * ProdOrderRoutingLine."No of Joints"
                ELSE
                    MaxOutputQuantity := ProdOrderQuantity + AddtionalOrderQuantity;

                IF (CurrStageOutput + CurrOperationOutputQuantity) > (MaxOutputQuantity) THEN BEGIN
                    ERROR('The maximum available Output Quantity is %1, The Production Order Quantity(with tolerance) is %2 and Board Up %3 No of Joints %4 Posted Quantity %5 Including Extra Quantity',
                    (MaxOutputQuantity - CurrOperationOutputQuantity), ProdOrderQuantity, ProdOrderRoutingLine."Die Cut Ups", ProdOrderRoutingLine."No of Joints", CurrOperationOutputQuantity);
                END;
            END;
        END;
        ///////////////////////////////////////////////

        // For Previus Stage Check
        MaxOutputQuantity := 0;
        ProdOrderRoutingLine.RESET;
        ProdOrderRoutingLine.SETRANGE(ProdOrderRoutingLine.Status, ProdOrderRoutingLine.Status::Released);
        ProdOrderRoutingLine.SETRANGE(ProdOrderRoutingLine."Prod. Order No.", ProdOrderNumber);
        ProdOrderRoutingLine.SETRANGE(ProdOrderRoutingLine."Routing Reference No.", ProdOrderLineNumber);
        ProdOrderRoutingLine.SETRANGE(ProdOrderRoutingLine."Operation No.", OperationNumber);
        ProdOrderRoutingLine.SETFILTER(ProdOrderRoutingLine."Previous Operation No.", Sam001);
        IF ProdOrderRoutingLine.FINDFIRST THEN BEGIN

            IF ProdOrderRoutingLine."Die Cut Ups" > 0 THEN
                MaxOutputQuantity := ((ProdOrderQuantity + AddtionalOrderQuantity) / ProdOrderRoutingLine."Die Cut Ups") * ProdOrderRoutingLine."No of Joints"
            ELSE
                MaxOutputQuantity := ProdOrderQuantity + AddtionalOrderQuantity;

            PreviousStageOutput := 0;
            PreviousStageRouting.RESET;
            PreviousStageRouting.SETRANGE(PreviousStageRouting.Status, PreviousStageRouting.Status::Released);
            PreviousStageRouting.SETRANGE(PreviousStageRouting."Prod. Order No.", ProdOrderNumber);
            PreviousStageRouting.SETRANGE(PreviousStageRouting."Routing Reference No.", ProdOrderLineNumber);
            PreviousStageRouting.SETRANGE(PreviousStageRouting."Operation No.", ProdOrderRoutingLine."Previous Operation No.");
            IF PreviousStageRouting.FINDFIRST THEN BEGIN
                PreviousStageRouting.CALCFIELDS(PreviousStageRouting."Actual Output Quantity");
                PreviousStageOutput := PreviousStageRouting."Actual Output Quantity";

                PreviousStageRouting.CALCFIELDS(PreviousStageRouting."Work Center Category");

                IF (PreviousStageRouting."Die Cut Ups" > 0) AND (PreviousStageRouting."Work Center Category" <> PreviousStageRouting."Work Center Category"::Corrugation) THEN
                    PreviousStageAvalQuantity := (PreviousStageOutput * PreviousStageRouting."Die Cut Ups") / PreviousStageRouting."No of Joints"
                ELSE
                    PreviousStageAvalQuantity := PreviousStageOutput;

            END;

            IF ProdOrderRoutingLine."Die Cut Ups" > 0 THEN
                PreviousStageAvalQuantity := (PreviousStageAvalQuantity / ProdOrderRoutingLine."Die Cut Ups") * ProdOrderRoutingLine."No of Joints";


            CurrStageOutput := 0;
            ItemJournalLine.RESET;
            ItemJournalLine.SETRANGE(ItemJournalLine."Order Type", ItemJournalLine."Order Type"::Production);
            ItemJournalLine.SETRANGE(ItemJournalLine."Order No.", ProdOrderNumber);
            ItemJournalLine.SETRANGE(ItemJournalLine."Order Line No.", ProdOrderLineNumber);
            ItemJournalLine.SETRANGE(ItemJournalLine."Operation No.", OperationNumber);
            IF ItemJournalLine.FINDFIRST THEN BEGIN
                REPEAT
                    CurrStageOutput := CurrStageOutput + ItemJournalLine."Output Quantity";
                UNTIL ItemJournalLine.NEXT = 0;
            END;

            CurrStageOutput := CurrStageOutput + (OutputQty - PreValue);
            ProdOrderRoutingLine.CALCFIELDS(ProdOrderRoutingLine."Actual Output Quantity");
            ActualOutputQty :=/*ActualOutputQty-*/ProdOrderRoutingLine."Actual Output Quantity";


            IF (ActualOutputQty + CurrStageOutput) > PreviousStageAvalQuantity THEN BEGIN
                ERROR('The maximum available Output Quantity is %1. Previous stage output quantity %2', (PreviousStageAvalQuantity - ActualOutputQty), PreviousStageAvalQuantity);
            END;



            IF (ActualOutputQty + CurrStageOutput) > MaxOutputQuantity THEN BEGIN
                ERROR('The maximum available Output Quantity is %1', MaxOutputQuantity);
            END;

        END;

    end;

    procedure GenerateLineOPM(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; RequisitionNumber: Code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        RequisitionHeader: Record "Requisition Header";
        RequisitionLine: Record "Requisition Line SAM";
        TempLineNumber: Integer;
        ItemJnlBatch: Record "Item Journal Batch";
        NoSeriesLine: Record "No. Series Line";
        DocNo: Code[20];
    begin

        //Lines added by Deepak Kumar
        ItemJnlBatch.GET(JournalTemplateName, JournalBatchName);
        DocNo := '';

        NoSeriesMgt.InitSeries(ItemJnlBatch."Posting No. Series", ItemJnlBatch."Posting No. Series", TODAY, DocNo, ItemJnlBatch."Posting No. Series");
        RequisitionHeader.RESET;
        RequisitionHeader.SETRANGE(RequisitionHeader."Requisition No.", RequisitionNumber);
        IF RequisitionHeader.FINDFIRST THEN BEGIN
            TempLineNumber := 0;
            RequisitionLine.RESET;
            RequisitionLine.SETRANGE(RequisitionLine."Requisition No.", RequisitionHeader."Requisition No.");
            RequisitionLine.SETFILTER("Remaining Quantity", '<>0');
            IF RequisitionLine.FINDFIRST THEN BEGIN
                REPEAT
                    TempLineNumber := TempLineNumber + 1;
                    ItemJournalLine.INIT;
                    ItemJournalLine."Journal Template Name" := JournalTemplateName;
                    ItemJournalLine."Journal Batch Name" := JournalBatchName;
                    ItemJournalLine."Line No." := TempLineNumber;
                    ItemJournalLine.INSERT(TRUE);
                    ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                    ItemJournalLine.VALIDATE("Item No.", RequisitionLine."Item No.");
                    ItemJournalLine."Posting Date" := WORKDATE;
                    ItemJournalLine.VALIDATE("Document No.", DocNo);
                    ItemJournalLine."Source Code" := 'ITEMJNL';
                    ItemJournalLine.VALIDATE(Quantity, RequisitionLine."Remaining Quantity");
                    ItemJournalLine."Requisition No." := RequisitionLine."Requisition No.";
                    ItemJournalLine."Requisition Line No." := RequisitionLine."Requisition Line No.";
                    ItemJournalLine."Requisition Rem. Quantity" := RequisitionLine."Remaining Quantity";
                    ItemJournalLine.Description := RequisitionLine.Description;

                    ItemJournalLine.MODIFY(TRUE);
                UNTIL RequisitionLine.NEXT = 0;
            END;
        END;
    end;

    procedure ConsumeBalanceMaterial(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; OrderNumber: Code[20])
    var
        ItemJournalLine: Record "Item Journal Line";
        ProdOrderLine: Record "Prod. Order Line";
        TempLineNumber: Integer;
        ItemJnlBatch: Record "Item Journal Batch";
        NoSeriesLine: Record "No. Series Line";
        DocNo: Code[20];
        ItemLedgerEntryD: Record "Item Ledger Entry";
        MfgSetup: Record "Manufacturing Setup";
        TempRemQty: Decimal;
        AllowedRemQty: Decimal;
        ProductionOrder: Record "Production Order";
    begin

        //Lines added by Deepak Kumar
        ItemJnlBatch.GET(JournalTemplateName, JournalBatchName);
        DocNo := '';

        NoSeriesMgt.InitSeries(ItemJnlBatch."Posting No. Series", ItemJnlBatch."Posting No. Series", TODAY, DocNo, ItemJnlBatch."Posting No. Series");
        TempLineNumber := 10000;
        ProdOrderLine.RESET;
        ProdOrderLine.SETRANGE(ProdOrderLine.Status, ProdOrderLine.Status::Released);
        ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.", OrderNumber);
        ProdOrderLine.SETFILTER(ProdOrderLine."Planning Level Code", '>0');
        IF ProdOrderLine.FINDFIRST THEN BEGIN
            REPEAT
                MfgSetup.GET;
                ProductionOrder.GET(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.");
                IF ProductionOrder."Allowed Extra Consumption" = FALSE THEN BEGIN
                    ItemLedgerEntryD.RESET;
                    ItemLedgerEntryD.SETRANGE(ItemLedgerEntryD."Entry Type", ItemLedgerEntryD."Entry Type"::Output);
                    ItemLedgerEntryD.SETRANGE(ItemLedgerEntryD."Order Type", ItemLedgerEntryD."Order Type"::Production);
                    ItemLedgerEntryD.SETRANGE(ItemLedgerEntryD."Order No.", ProdOrderLine."Prod. Order No.");
                    ItemLedgerEntryD.SETRANGE(ItemLedgerEntryD."Item No.", ProdOrderLine."Item No.");
                    ItemLedgerEntryD.SETFILTER(ItemLedgerEntryD."Remaining Quantity", '<>0');
                    IF ItemLedgerEntryD.FINDFIRST THEN BEGIN
                        REPEAT
                            TempRemQty += ItemLedgerEntryD."Remaining Quantity";
                        UNTIL ItemLedgerEntryD.NEXT = 0;
                        AllowedRemQty := ProdOrderLine."Finished Quantity" * MfgSetup."Allowed Extra Consumption %" / 100;
                        IF TempRemQty > AllowedRemQty THEN
                            ERROR(Sam001, MfgSetup."Allowed Extra Consumption %", AllowedRemQty, TempRemQty);
                    END;
                END;
                ItemLedgerEntryD.RESET;
                ItemLedgerEntryD.SETRANGE(ItemLedgerEntryD."Entry Type", ItemLedgerEntryD."Entry Type"::Output);
                ItemLedgerEntryD.SETRANGE(ItemLedgerEntryD."Order Type", ItemLedgerEntryD."Order Type"::Production);
                ItemLedgerEntryD.SETRANGE(ItemLedgerEntryD."Order No.", ProdOrderLine."Prod. Order No.");
                ItemLedgerEntryD.SETRANGE(ItemLedgerEntryD."Item No.", ProdOrderLine."Item No.");
                ItemLedgerEntryD.SETFILTER(ItemLedgerEntryD."Remaining Quantity", '<>0');
                IF ItemLedgerEntryD.FINDFIRST THEN BEGIN
                    REPEAT
                        TempLineNumber := TempLineNumber + 1000;
                        ItemJournalLine.INIT;
                        ItemJournalLine."Journal Template Name" := JournalTemplateName;
                        ItemJournalLine."Journal Batch Name" := JournalBatchName;
                        ItemJournalLine."Line No." := TempLineNumber;
                        ItemJournalLine.INSERT(TRUE);
                        ItemJournalLine.VALIDATE("Item No.", ItemLedgerEntryD."Item No.");
                        Item.GET(ItemJournalLine."Item No.");
                        ItemJournalLine."Posting Date" := WORKDATE;
                        ItemJournalLine."Paper GSM" := FORMAT(Item."Paper GSM");
                        ItemJournalLine."Paper Type" := Item."Paper Type";
                        ItemJournalLine."Deckle Size (mm)" := Item."Deckle Size (mm)";
                        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Consumption;
                        ItemJournalLine.VALIDATE("Document No.", DocNo);
                        ItemJournalLine."Source Code" := 'ITEMJNL';

                        ItemJournalLine.VALIDATE("Order Type", "Order Type"::Production);
                        ItemJournalLine.VALIDATE("Order No.", ProdOrderLine."Prod. Order No.");
                        ItemJournalLine.VALIDATE("Order Line No.", 10000);
                        ItemJournalLine.VALIDATE(Quantity, ItemLedgerEntryD."Remaining Quantity");
                        ItemJournalLine.VALIDATE(ItemJournalLine."Applies-to Entry", ItemLedgerEntryD."Entry No.");
                        ItemJournalLine.MODIFY(TRUE);
                    UNTIL ItemLedgerEntryD.NEXT = 0;
                END;
            UNTIL ProdOrderLine.NEXT = 0;
        END;
    end;
}