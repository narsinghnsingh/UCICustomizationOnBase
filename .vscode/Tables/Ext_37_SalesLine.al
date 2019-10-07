tableextension 50012 Ext_SalesLine extends "Sales Line"
{
    fields
    {
        field(50000; "Estimation No."; Code[20])
        {
            Description = '//Deepak';
            Editable = true;
            TableRelation = IF ("Document Type" = FILTER (Quote)) "Product Design Header"."Product Design No." ELSE
            IF ("Document Type" = FILTER (Order)) "Product Design Header"."Product Design No." WHERE ("Item Code" = FIELD ("No."));
            trigger OnValidate()
            var
                PDH: Record 50000;
            BEGIN
                PDH.RESET;
                PDH.SETRANGE(PDH."Product Design No.", "Estimation No.");
                PDH.SETRANGE(PDH.Status, PDH.Status::Blocked);
                IF PDH.FINDFIRST THEN
                    ERROR('The PDI %1 you have selected is currently blocked', PDH."Product Design No.");
            END;
        }
        field(50002; "Old Job No."; Code[20])
        {
            Description = '//Deepak';
            TableRelation = IF (Type = FILTER (= Item)) "Production Order"."No." WHERE ("Source No." = FIELD ("No."));
        }
        field(50005; "Estimate Price"; Decimal)
        {
            Description = '//Deepak';
            Editable = false;

            trigger OnValidate()
            begin
                // Lines added BY Deepak Kumar
                GetCompSalePrice;
            end;
        }
        field(50006; "Prod. Order No."; Code[20])
        {
            Description = '//Deepak';
            Editable = true;
            TableRelation = "Production Order"."No.";
            trigger OnValidate()
            var
                User_Setup: Record "User Setup";
            BEGIN
                User_Setup.RESET;
                IF User_Setup.GET(USERID) THEN BEGIN
                    IF NOT User_Setup."Change Sales Line" THEN
                        ERROR('You do not have permission to change the RPO Number, Kindly contact system administrator');
                END;
            END;
        }
        field(50007; "Prod. Order Line No."; Integer)
        {
            Description = '//Deepak';
            Editable = true;
            TableRelation = "Prod. Order Line"."Line No." WHERE ("Prod. Order No." = FIELD ("Prod. Order No."));
        }
        field(50008; "Cust. Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Customer.Name WHERE ("No." = FIELD ("Sell-to Customer No.")));
            Description = '//Deepak';

        }
        field(50009; "Profit Margin Per unit"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50010; "Profit Margin %"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50012; "Certificate of Analysis"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50013; "External Doc. No."; Code[35])
        {
            Description = '//Deepak';
        }
        field(50014; "Order Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Sales Header"."Order Date" WHERE ("No." = FIELD ("Document No.")));
            Description = '//Deepak';
            Editable = false;

        }
        field(50015; "SubJob Item"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50016; "New Prod. Order No."; Code[20])
        {
            Description = '//Deepak';
        }
        field(50018; "Marked for Prod. Order"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50019; "Repeat Job"; Boolean)
        {
            Description = '//Deepak';
            Editable = true;
        }
        field(50020; "Repeat Job Details"; Text[250])
        {
            Description = '//Deepak';
            Editable = true;
        }
        field(50021; "Shipment Weight"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50022; "Order Line Type"; Option)
        {
            Description = '//Deepak';
            OptionCaption = 'New,Replacement';
            OptionMembers = New,Replacement;
        }
        field(50023; Remarks; Text[150])
        {
            Description = '//Deepak';
        }
        field(50024; "Order Quantity (Weight)"; Decimal)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50025; "Outstanding  Quantity (Weight)"; Decimal)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50026; "Quality Inspection Sheet"; Code[50])
        {
            Description = '//Deepak';
            TableRelation = "Inspection Header"."No." WHERE ("Item No." = FIELD ("No."), Posted = CONST (true));
        }
        field(50027; "Sub Component Item"; Boolean)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50501; "Short Closed Document"; Boolean)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50502; "Short Closed Quantity"; Decimal)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(50503; "Short Closed Amount"; Decimal)
        {
            Description = '//Deepak';
        }
        field(50504; "Short Closed Amount (LCY)"; Decimal)
        {
            Description = '//Deepak';
        }
        field(51000; "Quote Status"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Sales Header"."Quote Status" WHERE ("Document Type" = FIELD ("Document Type"), "No." = FIELD ("Document No.")));
            Description = '//Deepak';
            Editable = false;

            OptionCaption = 'Open,Win,Loss,Cancel';
            OptionMembers = Open,Win,Loss,Cancel;
        }
        field(60001; "Select Item For Delivery Order"; Boolean)
        {
            Description = '//Deepak';
        }
        field(60002; "Ref. Sales Order No."; Code[50])
        {
            Description = '//Deepak';
        }
        field(60003; "Ref. Sales Order Line No."; Integer)
        {
            Description = '//Deepak';
        }
        field(60004; "Estimate Additional Cost"; Boolean)
        {
            Description = '//Deepak';
        }
        field(60008; "LPO(Order) Date"; Date)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(63000; "Inventory In FG Location"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Item No." = FIELD ("No."), "Location Code" = CONST ('FG')));
            Description = '//Deepak';

        }
        field(63001; "Order Item Code"; Code[20])
        {
            Description = '//Deepak';
            Editable = false;
            TableRelation = Item;
        }
        field(63002; "Delivery Method Code"; Code[20])
        {
            Description = '//Deepak';
            TableRelation = "Shipment Method";
        }
        field(63003; "Ship to Code"; Text[30])
        {
            Description = '//Deepak';
        }
        field(63004; "Level of Urgency"; Option)
        {
            Description = '//Deepak';
            OptionCaption = 'High,Medium,Low';
            OptionMembers = High,Medium,Low;
        }
        field(63005; "Estimate Revision Required"; Boolean)
        {
            Description = '//Deepak';
        }
        field(63006; "Estimate Revision Remarks"; Text[150])
        {
            Description = '//Deepak';
        }
        field(63007; "Salesperson Code"; Code[10])
        {
            Description = '//Deepak';
            TableRelation = "Salesperson/Purchaser";
        }
        field(63008; "Estimate Revised"; Boolean)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(63009; "Job Wise Inventory"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry"."Remaining Quantity" WHERE ("Item No." = FIELD ("No."), "Order Type" = FILTER (Production), "Order No." = FIELD ("Prod. Order No.")));
            Description = '//Deepak';

        }
        field(63010; "RPO Status"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Production Order".Status WHERE ("No." = FIELD ("Prod. Order No.")));
            Description = '//Deepak';

            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
        field(63011; "Documnet Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Sales Header"."Document Date" WHERE ("No." = FIELD ("Document No.")));
            Description = '//Deepak';

        }
        field(64001; "Sales Price per Unit (Company)"; Decimal)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(64002; "Variation %  Estimate Price"; Decimal)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(64003; "Variation % From Unit Price"; Decimal)
        {
            Description = '//Deepak';
            Editable = false;
        }
        field(64004; "Rate Per KG"; Decimal)
        {
            Description = '//Binay';
        }

    }

    var

        ProdOrderLine: Record "Prod. Order Line";
        SRSetup: Record "Sales & Receivables Setup";
        VarQty: Decimal;
        MfgSetup: Record "Manufacturing Setup";
        RollMaster: Record "Attribute Master";
        EstimateHeader: Record "Product Design Header";

    local procedure CalcProfit()
    begin
        // Lines added BY Deepak Kumar
        "Profit Margin Per unit" := "Unit Price" - "Estimate Price";
        "Profit Margin %" := (("Unit Price" - "Estimate Price") / "Unit Price" * 100);
    end;

    procedure ShowShipmentScheduleLines()
    var
        ShipmentScheduleLines: Record "Machine Cost Sheet";
        ShipmentScheduleSheet: Page "Purch. Receipts pending for QA";
    begin
        //Lines added BY Deepak Kumar
        /*s
        
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        TESTFIELD(Quantity);
        ShipmentScheduleLines.SETRANGE("No.","Document Type");
        ShipmentScheduleLines.SETRANGE(Name,"Document No.");
        ShipmentScheduleLines.SETRANGE("Document Line No.","Line No.");
        ShipmentScheduleSheet.SETTABLEVIEW(ShipmentScheduleLines);
        ShipmentScheduleSheet.RUNMODAL;
                                             */

    end;

    procedure ValidateOrder()
    var
        SalesOrder: Record "Sales Line";
    begin
        // Lines added BY Deepak Kumar
        MfgSetup.GET();
        SalesOrder.RESET;
        SalesOrder.SETRANGE(SalesOrder."Document Type", SalesOrder."Document Type"::Order);
        SalesOrder.SETRANGE(SalesOrder."Document No.", "Ref. Sales Order No.");
        SalesOrder.SETRANGE(SalesOrder."Line No.", "Ref. Sales Order Line No.");
        IF SalesOrder.FINDFIRST THEN BEGIN
            VarQty := (SalesOrder.Quantity * MfgSetup."Output Tolerance %") / 100;
            IF (SalesOrder.Quantity + VarQty - SalesOrder."Quantity Shipped") < Quantity THEN
                ERROR('You cannot ship more than %1 units.', (SalesOrder.Quantity + VarQty - SalesOrder."Quantity Shipped"));

        END ELSE BEGIN
            ERROR('Sales Order %1 Line Number %2 Item Code %3 not available in Sales Order', "Ref. Sales Order No.", "Ref. Sales Order Line No.", "No.");
        END;
    end;

    procedure GetCompSalePrice()
    var
        SalesPrice: Record "Sales Price";
        SalesHeader: Record "Sales Header";
        TempQty: Decimal;
    begin
        // Lines added bY Deepak Kumar
        /*
        IF Type <> Type::Item THEN
          EXIT;
        
        TempQty:=0;
        SalesHeader.RESET;
        SalesHeader.SETRANGE(SalesHeader."Document Type","Document Type");
        SalesHeader.SETRANGE(SalesHeader."No.","Document No.");
        IF SalesHeader.FINDFIRST THEN BEGIN
            SalesHeader.TESTFIELD(SalesHeader."Document Date");
            EstimateHeader.RESET;
            EstimateHeader.SETRANGE(EstimateHeader."Product Design No.","Estimation No.");
        //    EstimateHeader.SETRANGE(EstimateHeader."Item Code","No.");
            IF EstimateHeader.FINDFIRST THEN BEGIN
            TempQty:=Quantity*(EstimateHeader.Grammage/1000);
            SalesPrice.RESET;
            SalesPrice.SETRANGE(SalesPrice."Sales Type",SalesPrice."Sales Type"::"All Customers");
            SalesPrice.SETFILTER(SalesPrice."Ending Date",'%1|>=%2',0D,SalesHeader."Document Date");
            SalesPrice.SETRANGE(SalesPrice."Starting Date",0D,SalesHeader."Document Date");
            SalesPrice.SETRANGE(SalesPrice."No. of Ply",EstimateHeader."No. of Ply");
            SalesPrice.SETFILTER(SalesPrice."Minimum Quantity",'>=%1',TempQty);
            IF SalesPrice.FINDFIRST THEN BEGIN
              "Company Sales Price":=SalesPrice."Unit Price"* (EstimateHeader.Grammage/1000);
              IF "Company Sales Price" > 0 THEN  BEGIN
              "Variation %  Estimate Price":=(("Estimate Price"-"Company Sales Price")/"Company Sales Price") *100;
              "Variation % From Unit Price":=(("Unit Price"-"Company Sales Price")/"Company Sales Price") *100;
              END;
            END
            END;
        END;
         */

    end;

    procedure QuoteVariation()
    begin
        // Lines added By Deepak Kumar
        IF "Sales Price per Unit (Company)" = 0 THEN
            "Sales Price per Unit (Company)" := 1;
        "Variation % From Unit Price" := (("Unit Price" - "Sales Price per Unit (Company)") / "Sales Price per Unit (Company)") * 100;
    end;
}