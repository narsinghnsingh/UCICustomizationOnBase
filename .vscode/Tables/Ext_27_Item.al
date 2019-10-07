tableextension 50009 Ext_Item extends Item
{

    fields
    {
        field(50001; "Paper GSM"; Decimal)
        {
            Editable = false;
            MinValue = 0;
        }
        field(50002; "Paper Type"; Code[20])
        {
            Editable = false;
            trigger OnValidate()
            var
                AttributeValue: Record "Attribute Value";
            begin
                AttributeValue.RESET;
                AttributeValue.SETRANGE(AttributeValue."Attribute Code", 'PAPERTYPE');
                AttributeValue.SETRANGE(AttributeValue."Attribute Value", "Paper Type");
                IF AttributeValue.FINDFIRST THEN BEGIN
                    "FSC Category" := AttributeValue."Attribute Value Description";
                    MODIFY;
                END;
            end;

        }
        field(50003; Supplier; Code[20])
        {
            Editable = false;
        }
        field(50004; "Model No"; Code[20])
        {
            TableRelation = "Product Design Model Master"."Model No";

            trigger OnValidate()
            var
                ModelMaster: Record "M/W Price List";
            begin
                // Lines added bY Deepak Kumar
                ModelMaster.RESET;
                ModelMaster.SETRANGE(ModelMaster."No.", "Model No");
                IF ModelMaster.FINDFIRST THEN BEGIN
                    "Model Description" := ModelMaster.Description;
                    MODIFY(TRUE);
                END;
            end;
        }
        field(50005; "Model Description"; Text[100])
        {
        }
        field(50006; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(50007; "Customer Name"; Text[150])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Customer.Name WHERE ("No." = FIELD ("Customer No.")));
            Editable = false;
        }
        field(50027; "Last Purch. Order No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Max ("Purchase Line"."Document No."
            WHERE ("Document Type" = CONST (Order), Type = CONST (Item), "No." = FIELD ("No.")));

        }
        field(50029; "Pallet Height(mtr)"; Decimal)
        {
            InitValue = 2.4;
        }
        field(50030; "Qty. on Sales Order(Weight)"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            FieldClass = FlowField;
            CalcFormula = Sum ("Sales Line"."Order Quantity (Weight)"
            WHERE ("Document Type" = CONST (Order), Type = CONST (Item), "No." = FIELD ("No."),
            "Shortcut Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"),
            "Shortcut Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"), "Location Code" = FIELD ("Location Filter")
            , "Drop Shipment" = FIELD ("Drop Shipment Filter"), "Variant Code" = FIELD ("Variant Filter"),
            "Shipment Date" = FIELD ("Date Filter"), "Outstanding Quantity" = FILTER (> 0), "Short Closed Document" = FILTER (false)));
            CaptionML = ENU = 'Qty. on Sales Order(Weight)';
            DecimalPlaces = 0 : 5;
            Editable = false;

        }
        field(50031; "Outstanding Qty SO (Weight)"; Decimal)
        {
            FieldClass = FlowField;
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Sum ("Sales Line"."Outstanding  Quantity (Weight)"
            WHERE ("Document Type" = CONST (Order),
            Type = CONST (Item), "No." = FIELD ("No."),
            "Shortcut Dimension 1 Code" = FIELD ("Global Dimension 1 Filter"),
            "Shortcut Dimension 2 Code" = FIELD ("Global Dimension 2 Filter"),
            "Location Code" = FIELD ("Location Filter"),
            "Drop Shipment" = FIELD ("Drop Shipment Filter"),
            "Variant Code" = FIELD ("Variant Filter"),
            "Shipment Date" = FIELD ("Date Filter"), "Outstanding Quantity" = FILTER (> 0), "Short Closed Document" = FILTER (false)));
            CaptionML = ENU = 'Outstanding Qty SO (Weight)';
            DecimalPlaces = 0 : 5;
            Editable = false;

        }
        field(52001; "Roll ID Applicable"; Boolean)
        {
            Editable = true;
        }
        field(52002; "Bursting factor(BF)"; Decimal)
        {
        }
        field(52003; "Deckle Size (mm)"; Decimal)
        {
            Editable = false;
            MinValue = 0;
        }
        field(52004; "No. of Ply"; Option)
        {
            OptionCaption = 'NA,2,3,5,7';
            OptionMembers = NA,"2","3","5","7";
        }
        field(52005; "Percentage of Paper Wt."; Decimal)
        {
        }
        field(52006; "PO Quantity Variation %"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(52007; "Quality Spec ID"; Code[20])
        {
            TableRelation = "Quality Spec Header"."Spec ID" WHERE (Status = CONST (Certified));
        }
        field(52008; "QA Enable"; Boolean)
        {
        }
        field(52009; "Paper Origin"; Code[20])
        {
            Editable = false;
        }
        field(52011; "Quantity Per Pallet"; Integer)
        {
        }
        field(52012; "Heigth of Pallet (cm)"; Decimal)
        {
        }
        field(52013; "Plate Item No."; Code[20])
        {
            TableRelation = Item."No." WHERE ("Plate Item" = FILTER (true), "Inventory Value Zero" = FILTER (false));
        }
        field(52014; "Flute Type"; Code[20])
        {
        }
        field(52015; "Color Code"; Code[20])
        {
        }
        field(52016; "Plate Item"; Boolean)
        {
            Editable = false;
        }
        field(52017; "Die Number"; Code[20])
        {
        }
        field(52018; "Marked For Enq/Quote"; Boolean)
        {
        }
        field(52019; "Inventory as per Filter"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Item Ledger Entry".Quantity
            WHERE ("Item No." = FIELD ("No."),
            "Location Code" = FIELD ("Location Filter"),
            "Posting Date" = FIELD ("Date Filter")));
            CaptionML = ENU = 'Inventory as per Filter';
            DecimalPlaces = 0 : 5;
            Editable = false;

        }
        field(52020; "Flute 1"; Option)
        {
            Description = '3 Ply';
            Editable = false;
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(52021; "Flute 2"; Option)
        {
            Description = '5 Ply';
            Editable = false;
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(52022; "Flute 3"; Option)
        {
            Description = '7 Ply';
            Editable = false;
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(52023; "Board Length"; Decimal)
        {
            Editable = false;
        }
        field(52024; "Board Width"; Decimal)
        {
            Editable = false;
        }
        field(52025; "Marked for Production Schedule"; Boolean)
        {
            Description = 'deepak';
        }
        field(52026; "Box Length"; Code[20])
        {
            Description = 'Firoz 18-11-15';
        }
        field(52027; "Box Height"; Code[20])
        {
            Description = 'Firoz 18-11-15';
        }
        field(52028; "Box Width"; Code[20])
        {
            Description = 'Firoz 18-11-15';
        }
        field(52029; "FG GSM"; Code[20])
        {
            Description = 'Firoz 18-11-15';
        }
        field(52030; "Mother Job No."; Code[20])
        {
            Description = 'Deepak';
        }
        field(52031; "Plate Item No.2"; Code[20])
        {
            TableRelation = Item."No." WHERE ("Plate Item" = FILTER (true), "Inventory Value Zero" = FILTER (true));
        }
        field(52032; "Die Number 2"; Code[20])
        {
        }
        field(60001; "Item UID Code"; Code[200])
        {
            Editable = false;
        }
        field(60002; "Estimate No."; Code[20])
        {
            TableRelation = "Product Design Header"."Product Design No.";
        }
        field(60004; "Output Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Capacity Ledger Entry"."Output Quantity" WHERE ("Plate Item" = FIELD ("No.")));


        }
        field(60005; "Scrap Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Capacity Ledger Entry"."Scrap Quantity" WHERE ("Plate Item" = FIELD ("No.")));
            Enabled = false;

        }
        field(70001; Status; Option)
        {
            OptionCaption = 'Pending Approval,Approved,Blocked';
            OptionMembers = "Pending Approval",Approved,Blocked;
        }
        field(70003; "Board Item No."; Code[20])
        {
            Editable = true;
            TableRelation = Item."No.";
        }
        field(70004; "FG Item No."; Code[20])
        {
            Editable = true;
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                EstimateHeader.RESET;
                EstimateHeader.SETRANGE(EstimateHeader."Item Code", "FG Item No.");
                IF EstimateHeader.FINDFIRST THEN BEGIN
                    "Customer No." := EstimateHeader.Customer;
                    "Customer Name" := EstimateHeader.Name;
                    "Estimate No." := EstimateHeader."Product Design No.";
                    "Curr Prod. Order Desc." := EstimateHeader."Item Description";
                END;
            end;
        }
        field(71000; "Ready for Print"; Boolean)
        {

            trigger OnValidate()
            begin
                IF NOT "Artwork Availabe" THEN
                    MESSAGE('Artwork not available !');
                IF "Replace Plate" THEN
                    ERROR('Replace Plate must be no for printing plate %1', "No.");
            end;
        }
        field(71001; "Artwork Availabe"; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                //Deepak
                EstimateHeader.RESET;
                EstimateHeader.SETRANGE(EstimateHeader."Product Design No.", "Estimate No.");
                EstimateHeader.SETRANGE(EstimateHeader."Item Code", "FG Item No.");
                IF EstimateHeader.FINDFIRST THEN BEGIN
                    EstimateHeader."Artwork Available" := TRUE;
                    EstimateHeader.MODIFY(TRUE);
                END;
            end;
        }
        field(71002; "Replace Plate"; Boolean)
        {

            trigger OnValidate()
            begin
                "Ready for Print" := FALSE;
            end;
        }
        field(71003; "Req. For Purchase"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Req. For Purchase" THEN BEGIN
                    IF NOT "Artwork Availabe" THEN
                        MESSAGE('Artwork not available !');
                    IF NOT "Replace Plate" THEN BEGIN
                        CALCFIELDS("Qty. on Purch. Order");
                        IF "Qty. on Purch. Order" > 0 THEN
                            ERROR('The Plate Item %1 already exists on a purchase order', "No.");
                    END;
                END;
            end;
        }
        field(71004; "Negotiated Rate"; Decimal)
        {
        }
        field(71005; "Curr Prod. Order No."; Code[20])
        {
            Editable = false;
        }
        field(71006; "Repeat Prod. Order(Plate)"; Boolean)
        {
            Description = 'this signifies whether the curr. prod. order is repeat job or a new job';
            Editable = false;
        }
        field(71007; "Customer's Name(Curr. Prod)"; Text[250])
        {
            Description = 'to be displayed in plate master, sourced from the current prod. order//Deepak 170315';
            Editable = false;
        }
        field(71008; "Curr Prod. Order Desc."; Text[250])
        {
            Description = 'to display the prod order description//Deepak';
            Editable = false;
        }
        field(71009; "Artwork Approval Date & Time"; DateTime)
        {
            Description = 'for user to specify the artwork approval date';
        }
        field(71010; "Printing Threshold Limit"; Integer)
        {
            Description = 'for user to specify the Printing Threshold Limit of printing plates';
        }
        field(71011; "Customer Item Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Item."No. 2" WHERE ("No." = FIELD ("FG Item No.")));
            Description = 'to show Customer Item Code for FG Item No of Printing Plate.';

        }
        field(71013; "Available in Estimate Line"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Item Category"."Available for Estimate Line" WHERE (Code = FIELD ("Item Category Code")));
            Description = '//Deepak';

        }
        field(71014; "Available in Sales Line"; Boolean)
        {
            Description = '//Deepak';
        }
        field(71015; "Available in Purchase Line"; Boolean)
        {
            Description = '//Deepak';
        }
        field(71016; "Last Purchase Inv Price"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Purch. Inv. Line"."Direct Unit Cost"
            WHERE (Type = CONST (Item), "No." = FIELD ("No."), Quantity = FILTER (<> 0)));
            Editable = false;

        }
        field(50032; "Sub Comp No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Product Design Header"."Sub Comp No."
            WHERE ("Product Design No." = FIELD ("Estimate No."),
            "Item Code" = FIELD ("FG Item No.")));
            Editable = false;
        }
        field(50008; "Old Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            Editable = false;
            trigger OnValidate()
            begin
                VALIDATE("Price/Profit Calculation");
            end;
        }
        field(50009; "FSC Category"; Text[100])
        {
            Editable = false;
            DataClassification = ToBeClassified;

        }

    }

    fieldgroups
    {
        addlast(DropDown; "No.", Description, "Base Unit of Measure", "Unit Price", Inventory, "Description 2", "No. 2")
        {

        }
    }

    var
        EstimateHeader: Record "Product Design Header";
        "-Samadhan_Variables": Integer;
        UserSetup: Record "User Setup";

        ItemAttributeEntry: Record "Item Attribute Entry";
        Customer: Record Customer;

    trigger OnDelete()
    var
        ItemCrossReference: Record "Item Cross Reference";


    begin
        // Lines added BY deepak Kumar
        ERROR('Item Delete is Restricted, Please Contact your Administrator');
        EstimateHeader.RESET();
        EstimateHeader.SETRANGE(EstimateHeader."Item Code", "No.");
        IF EstimateHeader.FINDFIRST THEN
            ERROR('The Estimate No %1 exists for the item', EstimateHeader."Product Design No.");
        // Lines added By Deepak Kumar
        ItemAttributeEntry.SETRANGE("Item No.", "No.");
        ItemAttributeEntry.DELETEALL;
    end;

    procedure ApproveItem()
    var
        ItemCategory: Record "Item Category";
        UserSetup: Record "User Setup";
        Answer: Boolean;
        ItemMaster: Record Item;
    begin
        // lines added by deepak kUmar
        ItemCategory.GET("Item Category Code");
        IF ItemCategory."No2. Applicable" THEN
            TESTFIELD("No. 2");

        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Item, TRUE);
        UserSetup.SETRANGE(UserSetup."Approval Authority Item", TRUE);
        IF UserSetup.FINDFIRST THEN BEGIN
            ItemMaster.RESET;
            ItemMaster.SETRANGE(ItemMaster."Item UID Code", "Item UID Code");
            ItemMaster.SETFILTER(ItemMaster."No.", '<>%1', "No.");
            ItemMaster.SETRANGE(ItemMaster.Blocked, FALSE);
            ItemMaster.SETFILTER(ItemMaster."Item Category Code", '%1|%2|%3', 'FG', 'PAPER', 'FG_SUB'); //II
            IF ItemMaster.FINDFIRST THEN
                ERROR('Item No %1 with description %2 already exists', ItemMaster."No.", ItemMaster.Description);

            Answer := DIALOG.CONFIRM('Do you want to approve Item', TRUE, "No.");
            IF Answer = TRUE THEN BEGIN

                Blocked := FALSE;
                Status := 1;
                MODIFY(TRUE);
                MESSAGE('Approved')
            END;
        END ELSE BEGIN
            ERROR('You are not authorised for "Item", Please contact your system administrator');
        END;
    end;

    procedure BlockItem()
    var
        UserSetup: Record "User Setup";
        Answer: Boolean;
    begin
        // lines added by deepak kUmar
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERID);
        UserSetup.SETRANGE(UserSetup.Item, TRUE);
        UserSetup.SETRANGE(UserSetup."Approval Authority Item", TRUE);
        IF UserSetup.FINDFIRST THEN BEGIN
            Answer := DIALOG.CONFIRM('Do you want to block Item', TRUE, "No.");
            IF Answer = TRUE THEN BEGIN
                Blocked := TRUE;
                Status := 2;
                MODIFY(TRUE);
                MESSAGE('Blocked')
            END;
        END ELSE BEGIN
            ERROR('You are not authorised for "Item", Please contact your system administrator');
        END;
    end;
}