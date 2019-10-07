page 50028 "Sales Enquiry Line Item N"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Worksheet;
    SourceTable = "Enquiry Line Attribute Entry";
    SourceTableView = SORTING("Document No.","Line No.","Sorting Order")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            field("Item Category Code";"Item Category Code")
            {
                CaptionML = ENU = 'Item Category Code';

                trigger OnValidate()
                var
                    ItemCategaryAttributeSetup: Record "Product Design Model Master";
                    "Item Creation Buffer": Record "Item Cat. Attribute Setup";
                    Int: Integer;
                begin
                end;
            }
            repeater(Group)
            {
                field("Item Attribute Caption";"Item Attribute Caption")
                {
                }
                field("Item Attribute Value";"Item Attribute Value")
                {
                }
                field("Sorting Order";"Sorting Order")
                {
                }
                field(Master;Master)
                {
                }
                field("Add on Description (Pre)";"Add on Description (Pre)")
                {
                }
                field("Add on Description (Post)";"Add on Description (Post)")
                {
                }
                field("Caption show in Description";"Caption show in Description")
                {
                }
                field("Add on Description";"Add on Description")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Template")
            {
                Image = Template;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemCategaryAttributeSetup: Record "Product Design Model Master";
                    "Item Creation Buffer": Record "Item Cat. Attribute Setup";
                    Int: Integer;
                begin
                    // Lines added by deepak Kumar
                    //"Item Category Code":='FG';

                    TempEnqNo:=GetFilter("Document No.");
                    TempEnqLineNo:=GetFilter("Line No.");
                    GetTemplete("Document Type","Item Category Code","Document No.","Line No.");
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        DeleteBlankLine();
        UpdateEnquiry;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TempItemNumber: Code[30];
        Item: Record Item;
        EntryNumber: Integer;
        "Temp Description": Text[250];
        ItemCard: Page "Item Card";
        ItemCreationBuffer: Record "Enquiry Line Attribute Entry";
        iPG: Code[20];
        IAttrib: Record "Attribute Master";
        IAttrib2: Record "Attribute Master";
        NO2: Code[10];
        ARTICLE: Code[30];
        CheckDescription: Text[250];
        "Old Item Number": Code[30];
        "Base Unit": Code[10];
        ItemWizardPage: Page "Item Wizard";
        ItemCategory: Text[20];
        EnquiryLine: Record "Sales Line";
        salesEnquiryLine: Record "Sales Line";
        "Enquiry Line Attribute Entry": Record "Enquiry Line Attribute Entry";
        ItemAttributeEntry: Record "Product Design Component Table";
        TempItemM: Record Item;
        ItemCode: Code[200];
        ItemMaster: Record Item;
        TempEnqNo: Code[50];
        TempEnqLineNo: Code[50];
        DataEntered: Boolean;
        EnquiryLineAttributeEntry: Record "Enquiry Line Attribute Entry";
        UpdateDescription: Boolean;

    procedure CheckDuplication()
    var
        ItemBuffer: Record "Enquiry Line Attribute Entry";
        TempItemCode: Code[200];
        TempItemCodeValue: Text[1000];
        ItemMaster: Record Item;
    begin
        // Lines added by Deepak Kumar
        TempItemCode:='';
        TempItemCodeValue:='';
        CheckDescription:='';

        ItemBuffer.Reset;
        ItemBuffer.SetCurrentKey(ItemBuffer."Sorting Order");
        ItemBuffer.SetRange(ItemBuffer."User ID",UserId);
        ItemBuffer.SetRange(ItemBuffer."Document Type","Document Type");
        ItemBuffer.SetRange(ItemBuffer."Document No.","Document No.");
        ItemBuffer.SetRange(ItemBuffer."Line No.","Line No.");
        if ItemBuffer.FindFirst then begin
          TempItemCode:=Format(ItemBuffer."Item Category UID");
          TempItemCodeValue:=Format(ItemBuffer."Item Category Code");
          repeat
           // ItemBuffer.TESTFIELD(ItemBuffer."Item Attribute Value");
            TempItemCode:=TempItemCode+Format(ItemBuffer."Attribute Code UID")+Format(ItemBuffer."Attribute Value UID");
          until ItemBuffer.Next=0;
        end;


        ItemMaster.Reset;
        ItemMaster.SetFilter(ItemMaster."Item UID Code",TempItemCode);
        if ItemMaster.FindFirst then begin
           Message('This Specification of Item already exits, The identification value is %1',ItemMaster."No.");//As per Dicussion With ST Sir, System only sugget not block
        end;
    end;

    procedure SetEnquiryLine(NewSalesEnquiryLine: Record "Sales Line")
    begin
        EnquiryLine := NewSalesEnquiryLine;
    end;

    procedure UpdateEnquiry()
    begin
        if not FindFirst then
          exit;


        FindFirst;
        DataEntered:=false;
        repeat
          if not  DataEntered then
          begin
            if ("Item Attribute Value" <>  '')    then
              DataEntered:= true;
          end;
        until Next=0;
        //Deepak 20-04-15
        UpdateDescription:=true;
        ValidateValues;
        if UpdateDescription = false then
          exit;


        TempItemNumber:='';
        ItemCode:='';

        "Enquiry Line Attribute Entry".Reset;
        "Enquiry Line Attribute Entry".SetCurrentKey("Document No.","Line No.","Sorting Order");
        "Enquiry Line Attribute Entry".SetRange("Document No.","Document No.");
        "Enquiry Line Attribute Entry".SetRange("Line No.","Line No.");
        "Enquiry Line Attribute Entry".SetFilter("Enquiry Line Attribute Entry"."Item Attribute Code",'<> Base Unit of Measure');
        if "Enquiry Line Attribute Entry".FindFirst then begin
          ItemCode:=Format("Enquiry Line Attribute Entry"."Item Category UID");
          "Temp Description":='';
          repeat
             if "Enquiry Line Attribute Entry"."Add on Description" =  true then begin
               if "Enquiry Line Attribute Entry"."Caption show in Description" = true then begin
                  if "Temp Description"<>'' then
                   "Temp Description":="Temp Description"+' '+"Enquiry Line Attribute Entry"."Add on Description (Pre)"+' '+"Enquiry Line Attribute Entry"."Item Attribute Value"+' '+"Enquiry Line Attribute Entry"."Add on Description (Post)"
                  else
                   "Temp Description":="Enquiry Line Attribute Entry"."Add on Description (Pre)"+' '+"Enquiry Line Attribute Entry"."Item Attribute Value"+' '+"Enquiry Line Attribute Entry"."Add on Description (Post)";
               end else begin

                  if "Temp Description"<>'' then
                   "Temp Description":="Temp Description"+' '+"Enquiry Line Attribute Entry"."Item Attribute Value"
                  else
                   "Temp Description":="Enquiry Line Attribute Entry"."Item Attribute Value";
               end;
              end;

          until "Enquiry Line Attribute Entry".Next=0;
        end;
        // MESSAGE("Temp Description");
        salesEnquiryLine.Reset;
        salesEnquiryLine.SetRange(salesEnquiryLine."Document Type","Document Type");
        salesEnquiryLine.SetRange("Document No.","Document No.");
        salesEnquiryLine.SetRange("Line No.","Line No.");
        if salesEnquiryLine.FindFirst then begin
          if  salesEnquiryLine."Unit of Measure Code" = ''  then
            salesEnquiryLine.Validate(salesEnquiryLine."No.",salesEnquiryLine."No.");
          salesEnquiryLine.Description:="Temp Description";
          salesEnquiryLine.Modify(true);
        end;
    end;

    procedure ValidateValues()
    begin
        // Lines added bY Deepak Kumar 20-04-15
        if Rec.FindFirst then begin
          repeat
            if not Master = true then begin
              if "Item Attribute Value"= '' then begin
                Message('Item Attribute Value must have a value in Document No.= %1, Line No.= %2, Item Attribute Code= %3. It cannot be zero or empty. Due to this Description will not be generated',"Document No.","Line No.","Item Attribute Code");
                UpdateDescription:=false;
                MakeSalesEnqLineBlank;
                exit;
              end;
            end;
          until Next=0;
        end;
    end;

    procedure MakeSalesEnqLineBlank()
    begin
        salesEnquiryLine.Reset;
        salesEnquiryLine.SetRange(salesEnquiryLine."Document Type","Document Type");
        salesEnquiryLine.SetRange("Document No.","Document No.");
        salesEnquiryLine.SetRange("Line No.","Line No.");
        if salesEnquiryLine.FindFirst then begin
          if  salesEnquiryLine."Unit of Measure Code" = ''  then
            salesEnquiryLine.Validate(salesEnquiryLine."No.",salesEnquiryLine."No.");
          salesEnquiryLine.Description:='';
          salesEnquiryLine.Modify(true);
        end;
    end;

    procedure DeleteBlankLine()
    begin
        // Lines added By Deepak Kumar
        EnquiryLineAttributeEntry.Reset;
        EnquiryLineAttributeEntry.SetRange(EnquiryLineAttributeEntry."Document Type","Document Type");
        EnquiryLineAttributeEntry.SetRange(EnquiryLineAttributeEntry."Document No.","Document No.");
        EnquiryLineAttributeEntry.SetRange(EnquiryLineAttributeEntry."Item Attribute Code",'');
        if EnquiryLineAttributeEntry.FindFirst then begin
          EnquiryLineAttributeEntry.DeleteAll(true);
        end;
    end;
}

