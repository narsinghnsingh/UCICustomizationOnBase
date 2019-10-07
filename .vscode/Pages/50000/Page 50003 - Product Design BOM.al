page 50003 "Product Design BOM"
{
    // version Estimate Samadhan

    DeleteAllowed = false;
    PageType = Worksheet;
    UsageCategory = Tasks;
    SourceTable = "Product Design Line";
    SourceTableView = SORTING ("Product Design Type", "Product Design No.", "Sub Comp No.", "Line No.")
                      ORDER(Ascending)
                      WHERE ("Work Center Category" = CONST (Materials),
                            Type = CONST (Item));

    layout
    {
        area(content)
        {
            grid(Control29)
            {
                ShowCaption = false;
                field("Product Design Type"; "Product Design Type")
                {
                    Editable = false;
                }
                field("Product Design No."; "Product Design No.")
                {
                    Editable = false;
                }
                field("Sub Comp No."; "Sub Comp No.")
                {
                    Editable = false;
                }
                field("Item Description"; ItemDescription)
                {
                    CaptionML = ENU = 'Item Description';
                    Editable = false;
                }
                field(FGGSM; FGGSM)
                {
                    CaptionML = ENU = 'FG GSM';
                    Editable = false;
                }
                field("No. of Ups"; NoOfUps)
                {
                    Editable = false;
                }
                field(CalculatedGSM; CalculatedGSM)
                {
                    CaptionML = ENU = 'Calculated GSM';
                    Editable = false;
                }
                field(ItemFlute; ItemFlute)
                {
                    CaptionML = ENU = 'Item Flute';
                    Editable = false;
                }
                field(CalculatedDeckleSize; CalculatedDeckleSize)
                {
                    CaptionML = ENU = 'Calculated Deckle Size';
                    Editable = false;
                }
            }
            repeater(Control5)
            {
                Editable = IsEditable;
                ShowCaption = false;
                field(Type; Type)
                {
                    Editable = false;
                }
                field("Paper Position"; "Paper Position")
                {
                    Editable = false;
                }
                field("Deckle Size Filter"; "Deckle Size Filter")
                {
                    CaptionML = ENU = 'Deckle Size';
                }
                field("BF (Burst Factor) Filter"; "BF (Burst Factor) Filter")
                {
                    CaptionML = ENU = 'BF (Burst Factor)';
                }
                field("Paper GSM Filter"; "Paper GSM Filter")
                {
                    CaptionML = ENU = 'Paper GSM';
                }
                field("No."; "No.")
                {
                    StyleExpr = SetStyleFormat;
                }
                field(Description; Description)
                {
                    Importance = Promoted;
                    StyleExpr = SetStyleFormat;
                }
                field("Flute Type"; "Flute Type")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Of Measure"; "Unit Of Measure")
                {
                }
                field("Customer GSM"; "Customer GSM")
                {
                }
                field("Paper Bursting Strength(BS)"; "Paper Bursting Strength(BS)")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Line Amount"; "Line Amount")
                {
                }
                field("Wt. Average Price"; "Wt. Average Price")
                {
                }
                field("Last Purchase Price"; "Last Purchase Price")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Line Type"; "Line Type")
                {
                }
                field("Take Up"; "Take Up")
                {
                    Editable = false;
                }
                field("Paper Weight (gms)"; "Paper Weight (gms)")
                {
                }
                field("Paper Required KG"; "Paper Required KG")
                {
                    CaptionML = ENU = 'Paper Required KG( Per )';
                    DecimalPlaces = 0 : 5;
                }
                field(Inventory; Inventory)
                {
                }
                field("Component Of"; "Component Of")
                {
                }
                field("Consume / Process For"; "Consume / Process For")
                {
                    CaptionML = ENU = 'Consume For';
                }
                field("Extra Trim"; "Extra Trim")
                {
                }
                field("Extra Trim Weight (KG)"; "Extra Trim Weight (KG)")
                {
                }
                field("Trim more than Allowed"; "Trim more than Allowed")
                {
                }
            }
            part("Item Details"; "Paper Inventory")
            {
                CaptionML = ENU = 'Item Details';
                Editable = false;
                ShowFilter = false;
                SubPageLink = "Deckle Size (mm)" = FIELD (FILTER ("Deckle Size Filter")),
                              "Paper GSM" = FIELD (FILTER ("Paper GSM Filter")),
                              "Bursting factor(BF)" = FIELD (FILTER ("BF (Burst Factor) Filter"));
            }
        }
    }

    actions
    {
        area(creation)
        {

            action("Calculate Details")
            {
                Image = CalculateConsumption;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Lines added BY Deepak Kumar
                    EstimateHeader.CalcDetail("Product Design No.");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        // Lines added BY Deepak Kumar
        SetStyleFormat := SetStyle;
    end;

    trigger OnAfterGetRecord()
    begin
        // Lines added BY Deepak Kumar
        ProductDesignHeader.Reset;
        ProductDesignHeader.SetRange("Product Design Type", "Product Design Type");
        ProductDesignHeader.SetRange("Product Design No.", "Product Design No.");
        ProductDesignHeader.SetRange(Status, ProductDesignHeader.Status::Approved);
        if ProductDesignHeader.FindFirst then
            IsEditable := false
        else
            IsEditable := true;

        SetStyleFormat := SetStyle;
        EstimateHeader.Reset;
        EstimateHeader.SetRange(EstimateHeader."Product Design Type", "Product Design Type");
        EstimateHeader.SetRange(EstimateHeader."Product Design No.", "Product Design No.");
        EstimateHeader.SetRange(EstimateHeader."Sub Comp No.", "Sub Comp No.");
        if EstimateHeader.FindFirst then begin
            ItemDescription := EstimateHeader."Item Description";
            /*
            ItemAttribute.RESET;
            ItemAttribute.SETRANGE(ItemAttribute."Item No.",EstimateHeader."Item Code");
            IF ItemAttribute.FINDFIRST THEN BEGIN
              REPEAT
                IF ItemAttribute."Item Attribute Code" = 'FG_GSM' THEN
                  FGGSM:=ItemAttribute."Item Attribute Value"


                IF ItemAttribute."Item Attribute Code" = 'FLUTE' THEN
                  ItemFlute:=ItemAttribute."Item Attribute Value";

              UNTIL ItemAttribute.NEXT=0;
            END;
            */
            ItemMaster.Reset;
            ItemMaster.SetRange(ItemMaster."No.", EstimateHeader."Item Code");
            if ItemMaster.FindFirst then begin
                FGGSM := ItemMaster."FG GSM";
                ItemFlute := ItemMaster."Flute Type";
            end else begin
                FGGSM := '';
                ItemFlute := '';
            end;
            CalculatedDeckleSize := Format(EstimateHeader."Roll Width (mm)");
            CalculatedGSM := Format(EstimateHeader.Grammage);
            NoOfUps := Format(EstimateHeader."Board Ups");
        end else begin
            EstimateHeader."Item Description" := '';
            ItemFlute := '';
            CalculatedDeckleSize := '';
            FGGSM := '';
            CalculatedGSM := '';
            NoOfUps := '';
        end;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Lines added BY Deepak Kumar
        Type := Type::Item;
        "Work Center Category" := "Work Center Category"::Materials;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // Lines added By Deepak kumar
        TempFluteMaster := '';
        EstimateLine.Reset;
        EstimateLine.SetRange(EstimateLine."Product Design Type", "Product Design Type");
        EstimateLine.SetRange(EstimateLine."Product Design No.", "Product Design No.");
        EstimateLine.SetRange(EstimateLine."Sub Comp No.", "Sub Comp No.");
        if EstimateLine.FindFirst then begin
            repeat
                if (EstimateLine."Paper Position" = 2) or (EstimateLine."Paper Position" = 4) or (EstimateLine."Paper Position" = 6) or (EstimateLine."Paper Position" = 8) then begin
                    if EstimateLine."No." <> '' then
                        EstimateLine.TestField(EstimateLine."Flute Type");
                    if TempFluteMaster = '' then
                        TempFluteMaster := Format(EstimateLine."Flute Type")
                    else
                        TempFluteMaster := TempFluteMaster + '+' + Format(EstimateLine."Flute Type");

                end;
            until EstimateLine.Next = 0;
            if ItemFlute <> TempFluteMaster then
                Message('Flute Type must be same as per Item Master');
        end;
    end;

    var
        EstimateLine: Record "Product Design Line";
        EstimateHeader: Record "Product Design Header";
        SetStyleFormat: Text;
        ItemDescription: Text[250];
        FGGSM: Text;
        ItemFlute: Text;
        CalculatedDeckleSize: Text;
        ItemAttribute: Record "Item Attribute Entry";
        CalculatedGSM: Text;
        NoOfUps: Code[10];
        ItemMaster: Record Item;
        TempFluteMaster: Text;
        IsEditable: Boolean;
        ProductDesignHeader: Record "Product Design Header";

    procedure SetStyle(): Text
    begin
        // Lines added By Deepak Kumar
        if "Trim more than Allowed" then begin
            exit('UnFavorable');
        end;
        /*
        EXIT('Unfavorable');
        EXIT('StandardAccent');
        EXIT('Favorable');
         */

    end;
}

