tableextension 50045 Ext_ProdOrderComponent extends "Prod. Order Component"
{
    fields
    {
        field(50000; "Take Up"; Decimal)
        {
            Description = 'Deepak';
            InitValue = 1;
        }
        field(50001; "Paper Position"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4';
            OptionMembers = " ",Liner1,Flute1,Liner2,Flute2,Liner3,Flute3,Liner4;
        }
        field(50002; "Flute Type"; Option)
        {
            Description = 'Deepak';
            OptionCaption = ' ,A,B,C,E,F';
            OptionMembers = " ",A,B,C,E,F;
        }
        field(50003; "Actual Consumed"; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Order Type" = CONST (Production),
                                                                  "Order No." = FIELD ("Prod. Order No."),
                                                                  "Order Line No." = FIELD ("Prod. Order Line No."),
                                                                  "Item No." = FIELD ("Item No.")));
            Description = 'Deepak';
            FieldClass = FlowField;
        }
        field(51001; "Product Design Type"; Option)
        {
            Description = 'Deepak';
            Editable = false;
            OptionCaption = 'Main,Sub';
            OptionMembers = Main,Sub;
        }
        field(51002; "Product Design No."; Code[50])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(51003; "Sub Comp No."; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(51004; "Prod Schedule No."; Code[50])
        {
            Description = 'Deepak';
        }
        field(51005; "Schedule Component"; Boolean)
        {
            Description = 'Deepak';
        }
        field(51006; "Available Inventory"; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE ("Item No." = FIELD ("Item No.")));
            Description = 'Deepak';
            FieldClass = FlowField;
        }
        field(51007; "Schedule Status"; Option)
        {
            CalcFormula = Lookup ("Production Schedule".Status WHERE ("Schedule No." = FIELD ("Prod Schedule No.")));
            Description = 'Deepak';
            FieldClass = FlowField;
            OptionCaption = 'Open,Confirmed,Closed';
            OptionMembers = Open,Confirmed,Closed;
        }
        field(51008; "Quantity in Prod. Schedule"; Decimal)
        {
            CalcFormula = Sum ("Prod. Order Component"."Remaining Quantity" WHERE ("Item No." = FIELD ("Item No."),
                                                                                  "Schedule Component" = CONST (true),
                                                                                  "Schedule Status" = CONST (Confirmed)));
            Description = 'Deepak';
            FieldClass = FlowField;
        }
        field(51009; "Substitute Item"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(70000; "Item Category Code"; Code[10])
        {
            CaptionML = ENU = 'Item Category Code';
            Description = 'Deepak';
            TableRelation = "Item Category";
        }
        field(70001; "Alternative item by Store"; Code[20])
        {
            Description = 'Deepak';
            TableRelation = Item."No." WHERE ("Item Category Code" = FIELD ("Item Category Code"));

            trigger OnValidate()
            begin
                // Lines added by Deepak kUmar
                ValidateStoreUser;
                "Approved by Prod." := false;
                "Approved by Store" := false;
                Published := false;
                UpdateProdOrder("Prod. Order No.", "Prod. Order Line No.");
                Item.Reset;
                Item.SetRange(Item."No.", "Alternative item by Store");
                if Item.FindFirst then begin
                    "Alt. Item Store Description" := Item.Description;
                end else begin
                    "Alt. Item Store Description" := '';
                end;
            end;
        }
        field(70002; "Alt. Item Store Description"; Text[250])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(72001; "Alternative item by Prod."; Code[20])
        {
            Description = 'Deepak';
            TableRelation = Item."No." WHERE ("Item Category Code" = FIELD ("Item Category Code"));

            trigger OnValidate()
            begin
                // Lines added by Deepak kUmar
                ValidateProdUser;
                "Approved by Prod." := false;
                "Approved by Store" := false;
                Published := false;
                UpdateProdOrder("Prod. Order No.", "Prod. Order Line No.");

                Item.Reset;
                Item.SetRange(Item."No.", "Alternative item by Prod.");
                if Item.FindFirst then begin
                    "Alt. item by Prod. Description" := Item.Description;
                end else begin
                    "Alt. item by Prod. Description" := '';
                end;
            end;
        }
        field(72002; "Alt. item by Prod. Description"; Text[250])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(73001; "Approved by Store"; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(73002; "Approved by Prod."; Boolean)
        {
            CaptionML = ENU = 'Approved by Prod.';
            Description = 'Deepak';
            Editable = false;
        }
        field(73003; "Previous Item No"; Code[20])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(73004; "Previous Item Description"; Text[250])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(73005; "Published by"; Text[100])
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(73006; Published; Boolean)
        {
            Description = 'Deepak';
            Editable = false;
        }
        field(73008; Blocked; Boolean)
        {
            Description = 'Deepak';
        }
        field(73009; "Force Avail. for Requisition"; Boolean)
        {
            Description = '//Deepak';
        }
    }

    var
        "---Samadhan": Integer;
        UserSetup: Record "User Setup";
        Item: Record Item;

    procedure "--Samadhan"()
    begin
    end;

    procedure ValidateStoreUser()
    begin
        // Lines added BY Deepak kUmar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Store User", true);
        if not UserSetup.FindFirst then
            Error('You are not authorized user, Please contact your system Administrator');
    end;

    procedure ValidateProdUser()
    begin
        // Lines added BY Deepak kUmar
        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        UserSetup.SetRange(UserSetup."Auth. Production User", true);
        if not UserSetup.FindFirst then
            Error('You are not authorized user, Please contact your system Administrator');
    end;

    procedure UpdateProdOrder(ProdOrderNo: Code[50]; ProdOrderLineNo: Integer)
    var
        ProdOrderLine: Record "Prod. Order Line";
    begin
        // Lines added by Deepak kUmar
        ProdOrderLine.Reset;
        ProdOrderLine.SetRange(ProdOrderLine.Status, ProdOrderLine.Status::Released);
        ProdOrderLine.SetRange(ProdOrderLine."Prod. Order No.", ProdOrderNo);
        ProdOrderLine.SetRange(ProdOrderLine."Line No.", ProdOrderLineNo);
        if ProdOrderLine.FindFirst then begin
            ProdOrderLine."Material Approved by Store" := false;
            ProdOrderLine."Material Approved by Prod." := false;
            ProdOrderLine.Modify(true);
        end;
    end;
}