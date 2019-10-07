tableextension 50051 Ext_ItemCategory extends "Item Category"
{
    fields
    {
        field(50001; "IC Code"; Integer)
        {
            //AutoIncrement = true;
            Editable = false;
            NotBlank = true;

        }
        field(50002; "No Series"; Code[10])
        {
            CaptionML = ENU = 'Item Category No. Series';
            Description = '//Deepak';
            TableRelation = "No. Series";
        }
        field(50003; "QA Enable"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50007; "No2. Applicable"; Boolean)
        {
            Description = '//Deepak';
        }
        field(50008; "Starch Group"; Boolean)
        {
            Description = '//Deepak';
        }

        field(50009; "Def. Inventory Posting Group"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Inventory Posting Group".Code;
        }

        field(50010; "Def. Gen. Prod. Posting Group"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group".Code;
        }

        field(50011; "Def. Tax Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tax Group".Code;
        }

        field(50012; "Def. Costing Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = FIFO,LIFO,Specific,Average,Standard;
        }

        field(50013; "Def. VAT Prod. Posting Group"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group".Code;

        }
        field(60005; "Def. Replenishment System"; Option)
        {
            CaptionML = ENU = 'Replenishment System';
            Description = '//Deepak';
            OptionCaption = 'Purchase,Prod. Order,,Assembly';
            OptionMembers = Purchase,"Prod. Order",,Assembly;
        }
        field(60006; "Def. Manufacturing Policy"; Option)
        {
            CaptionML = ENU = 'Manufacturing Policy';
            Description = '//Deepak';
            OptionCaption = 'Make-to-Stock,Make-to-Order';
            OptionMembers = "Make-to-Stock","Make-to-Order";
        }
        field(60007; "Def. Capital Item"; Boolean)
        {
            CaptionML = ENU = 'Capital Item';
            Description = '//Deepak';
        }
        field(60008; "Def. Fixed Asset"; Boolean)
        {
            CaptionML = ENU = 'Fixed Asset';
            Description = '//Deepak';
        }
        field(60009; "Roll ID Applicable"; Boolean)
        {
            Description = '//Deepak';
        }
        field(60010; "PO Quantity Variation %"; Decimal)
        {
            Description = '//Deepak';
        }
        field(60011; "Available for Estimate Line"; Boolean)
        {
            Description = '//Deepak';
        }
        field(60012; "Plate Item"; Boolean)
        {
            Description = '//Deepak';
        }
        field(61000; "Profit Markup %"; Decimal)
        {
            CaptionML = ENU = 'Profit %';
            DecimalPlaces = 0 : 5;
            Description = '//Deepak';
        }
        field(61001; "Tariff No."; Code[20])
        {
            CaptionML = ENU = 'Tariff No.';
            Description = '//Deepak';
            TableRelation = "Tariff Number";
        }
        field(61002; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU = 'Global Dimension 1 Code';
            Description = '//Deepak';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(61003; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU = 'Global Dimension 2 Code';
            Description = '//Deepak';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(61004; "Reordering Policy"; Option)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            CaptionML = ENU = 'Reordering Policy';
            Description = '//Deepak';
            OptionCaption = ' ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot';
            OptionMembers = " ","Fixed Reorder Qty.","Maximum Qty.","Order","Lot-for-Lot";
        }
        field(61005; "Minimum Order Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            CaptionML = ENU = 'Minimum Order Quantity';
            DecimalPlaces = 0 : 5;
            Description = '//Deepak';
            MinValue = 0;
        }
        field(61006; "Maximum Order Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            CaptionML = ENU = 'Maximum Order Quantity';
            DecimalPlaces = 0 : 5;
            Description = '//Deepak';
            MinValue = 0;
        }
        field(61007; "Safety Stock Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            CaptionML = ENU = 'Safety Stock Quantity';
            DecimalPlaces = 0 : 5;
            Description = '//Deepak';
            MinValue = 0;
        }
        field(61008; "Order Multiple"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            CaptionML = ENU = 'Order Multiple';
            DecimalPlaces = 0 : 5;
            Description = '//Deepak';
            MinValue = 0;
        }
        field(61009; "Maximum Inventory"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            CaptionML = ENU = 'Maximum Inventory';
            DecimalPlaces = 0 : 5;
            Description = '//Deepak';
        }
        field(61010; "Reorder Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            CaptionML = ENU = 'Reorder Quantity';
            DecimalPlaces = 0 : 5;
            Description = '//Deepak';
        }

    }
    trigger OnInsert()
    var
        ItemCategory: Record "Item Category";
    begin
        ItemCategory.Reset();
        ItemCategory.SetCurrentKey("IC Code");
        IF ItemCategory.FindLast() then
            "IC Code" := ItemCategory."IC Code" + 1
        else
            "IC Code" := 1;
    end;
}