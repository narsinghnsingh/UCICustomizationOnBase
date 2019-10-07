table 50036 "Enquiry Line Attribute Entry"
{
    // version Deepak


    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Item Category Code";Code[10])
        {
            TableRelation = "Item Category".Code;

            trigger OnValidate()
            begin
                ItemCategoryCode.Reset;
                ItemCategoryCode.SetRange(ItemCategoryCode.Code,"Item Category Code");
                if ItemCategoryCode.FindFirst then begin
                  "Item Category UID":=ItemCategoryCode."IC Code";
                end else begin
                  "Item Category UID":=0;
                end;
            end;
        }
        field(3;"Item Attribute Code";Code[30])
        {

            trigger OnValidate()
            var
                AttributeMaster: Record "Attribute Master";
            begin
                AttributeMaster.Reset;
                AttributeMaster.SetRange(AttributeMaster."Attribute Code","Item Attribute Code");
                if AttributeMaster.FindFirst then
                begin
                  "Item Attribute Caption":=AttributeMaster."Attribute Description";
                  "Add on Description (Pre)":=AttributeMaster."Add on Des. (Prefix)";
                  "Add on Description (Post)":=AttributeMaster."Add on Des. (Postfix)";
                  "Caption show in Description":=AttributeMaster."Suffix Add on Description";
                  Validate(Master,AttributeMaster.Master);
                  Validate("Master List",AttributeMaster."Master List");
                  Validate("Attribute Code UID",AttributeMaster."Attribute UID");
                end
                else
                  Error('Item Attribute Code not found');
            end;
        }
        field(4;"Item Attribute Value";Code[250])
        {
            TableRelation = IF (Master=FILTER(false)) "Attribute Value"."Attribute Value" WHERE ("Attribute Code"=FIELD("Item Attribute Code"))
                            ELSE IF (Master=FILTER(true),
                                     "Master List"=CONST(Vendor)) Vendor."No."
                                     ELSE IF (Master=FILTER(true),
                                              "Master List"=CONST("Product Group Code")) "Product Group".Code WHERE ("Item Category Code"=FIELD("Item Category Code"))
                                              ELSE IF (Master=FILTER(true),
                                                       "Master List"=CONST("Base Unit Of Measure")) "Unit of Measure".Code
                                                       ELSE IF (Master=FILTER(true),
                                                                "Master List"=CONST(ItemCrossReference)) "Item Cross Reference"."Cross-Reference No."
                                                                ELSE IF (Master=FILTER(true),
                                                                         "Master List"=CONST(Model)) "Product Design Model Master"."Model No";

            trigger OnValidate()
            begin
                if Master = true then
                  "Attribute Value UID":="Item Attribute Value"
                else begin
                  AttributeValueCode.Reset;
                  AttributeValueCode.SetRange(AttributeValueCode."Attribute Code","Item Attribute Code");
                  AttributeValueCode.SetRange(AttributeValueCode."Attribute Value","Item Attribute Value");
                  if AttributeValueCode.FindFirst then begin
                    "Attribute Value UID":=Format(AttributeValueCode."Attribute Value UID");
                    "Attribute Value Numeric":=AttributeValueCode."Attribute Value Numreric";
                  end else
                    "Attribute Value UID":='';
                end;
            end;
        }
        field(5;"Line No.";Integer)
        {
        }
        field(6;"User ID";Code[30])
        {
        }
        field(8;ItemCode;Code[50])
        {
        }
        field(9;"Document Type";Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Delivery Order,Enquiry';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry;
        }
        field(10;"Modified By";Text[200])
        {
        }
        field(11;"Item Category UID";Integer)
        {
        }
        field(12;"Attribute UID";Code[10])
        {
        }
        field(13;"Attribute Value UID";Code[10])
        {
        }
        field(14;"Value Exits";Boolean)
        {
            CalcFormula = Exist("Material / Process Link Code" WHERE (Description=FIELD("Item Attribute Value")));
            FieldClass = FlowField;
        }
        field(15;"Document No.";Code[20])
        {
        }
        field(17;"Item Attribute Caption";Text[100])
        {
            Editable = false;
        }
        field(18;"Sorting Order";Code[2])
        {
            Editable = false;
            Numeric = true;
        }
        field(19;Master;Boolean)
        {
        }
        field(20;"Master List";Option)
        {
            OptionCaption = ' ,Vendor,Product Group Code,Base Unit Of Measure,ItemCrossReference,Model';
            OptionMembers = " ",Vendor,"Product Group Code","Base Unit Of Measure",ItemCrossReference,Model;
        }
        field(22;"Update in Enquiry Line";Boolean)
        {
        }
        field(23;"Update in No. 2";Boolean)
        {
            InitValue = false;
        }
        field(24;"Spares Machine Code";Boolean)
        {
            InitValue = false;
        }
        field(25;"Attribute Value Numeric";Decimal)
        {

            trigger OnValidate()
            var
                AttributeSam: Record "M/W Price List";
            begin
            end;
        }
        field(26;"Add on Description (Pre)";Code[10])
        {
        }
        field(27;"Caption show in Description";Boolean)
        {
        }
        field(28;"Attribute Code UID";Integer)
        {
            Editable = false;
        }
        field(29;"Source Document No.";Code[30])
        {
        }
        field(30;"Source Douument Line No.";Integer)
        {
        }
        field(31;"Add on Description (Post)";Code[10])
        {
        }
        field(32;"Add on Description";Boolean)
        {
            Editable = true;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.","Item Category Code","Item Attribute Code")
        {
        }
        key(Key2;"Document No.","Line No.","Sorting Order")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EnquiryLine: Record "Sales Line";
        ItemCategoryCode: Record "Item Category";
        AttributeValueCode: Record "Attribute Value";

    procedure GetTemplete(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order",Enquiry;ItemCategory: Code[20];EnqNo: Code[20];EnqLineno: Integer)
    var
        ItemCategaryAttributeSetup: Record "Item Cat. Attribute Setup";
        "Enquiry Line Attribute Entry": Record "Enquiry Line Attribute Entry";
        Int: Integer;
        ICBuffer: Record "Enquiry Line Attribute Entry";
    begin
        // Lines added by Deepak Kumar
        "Enquiry Line Attribute Entry".Reset;
        "Enquiry Line Attribute Entry".SetRange("Enquiry Line Attribute Entry"."User ID",UserId);
        "Enquiry Line Attribute Entry".SetRange("Enquiry Line Attribute Entry"."Document No.",EnqNo);
        "Enquiry Line Attribute Entry".SetRange("Enquiry Line Attribute Entry"."Line No.",EnqLineno);
        if "Enquiry Line Attribute Entry".FindFirst then
          "Enquiry Line Attribute Entry".DeleteAll;

        //MESSAGE(EnquiryLine."Document No.");
        ItemCategaryAttributeSetup.Reset;
        ItemCategaryAttributeSetup.SetRange(ItemCategaryAttributeSetup."Item Category Code",ItemCategory);
        ItemCategaryAttributeSetup.SetCurrentKey(ItemCategaryAttributeSetup."Sorting Order");
        if ItemCategaryAttributeSetup.FindFirst then
        begin
          repeat
            "Enquiry Line Attribute Entry"."Document Type":=DocumentType;
            "Enquiry Line Attribute Entry"."Item Category Code":=ItemCategaryAttributeSetup."Item Category Code";
            "Enquiry Line Attribute Entry".Validate("Item Attribute Code",ItemCategaryAttributeSetup."Item Attribute");
            ItemCategaryAttributeSetup.CalcFields(ItemCategaryAttributeSetup."Item Attribute Caption");
            "Enquiry Line Attribute Entry"."Item Attribute Caption":=ItemCategaryAttributeSetup."Item Attribute Caption";
            "Enquiry Line Attribute Entry"."Sorting Order":=ItemCategaryAttributeSetup."Sorting Order";
            "Enquiry Line Attribute Entry"."User ID" := UserId;
            "Enquiry Line Attribute Entry"."Document No.":=EnqNo;
            "Enquiry Line Attribute Entry"."Line No.":=EnqLineno;
            "Enquiry Line Attribute Entry"."Add on Description":=ItemCategaryAttributeSetup."Add on Description";

            "Enquiry Line Attribute Entry".Insert(true);
            Commit;
          until  ItemCategaryAttributeSetup.Next=0;
            // Lines added for product group code
            "Enquiry Line Attribute Entry".Reset;
            "Enquiry Line Attribute Entry"."Document Type":=DocumentType;
            "Enquiry Line Attribute Entry"."Item Category Code":=ItemCategaryAttributeSetup."Item Category Code";
               "Enquiry Line Attribute Entry".Validate("Item Attribute Code",ItemCategaryAttributeSetup."Item Attribute");
            "Enquiry Line Attribute Entry".Master:=true;
            "Enquiry Line Attribute Entry"."Master List":="Enquiry Line Attribute Entry"."Master List"::"Product Group Code";
           "Enquiry Line Attribute Entry"."Document No.":=EnqNo;
            "Enquiry Line Attribute Entry"."Line No.":=EnqLineno;



            "Enquiry Line Attribute Entry"."Item Attribute Code":='Product Group Code';
            "Enquiry Line Attribute Entry"."Item Attribute Caption":='Product Group Code';
            "Enquiry Line Attribute Entry"."Sorting Order":='NA';
            "Enquiry Line Attribute Entry"."User ID" := UserId;
            "Enquiry Line Attribute Entry"."Update in Enquiry Line":=false;
            "Enquiry Line Attribute Entry".Insert(true);
            //Lines added by Deepak

            "Enquiry Line Attribute Entry".Reset;
            "Enquiry Line Attribute Entry"."Document Type":=DocumentType;
            "Enquiry Line Attribute Entry"."Item Category Code":=ItemCategaryAttributeSetup."Item Category Code";
               "Enquiry Line Attribute Entry".Validate("Item Attribute Code",ItemCategaryAttributeSetup."Item Attribute");
            "Enquiry Line Attribute Entry".Master:=true;
            "Enquiry Line Attribute Entry"."Master List":="Enquiry Line Attribute Entry"."Master List"::"Base Unit Of Measure";
            "Enquiry Line Attribute Entry"."Item Attribute Code":='Base Unit of Measure';
            "Enquiry Line Attribute Entry"."Item Attribute Caption":='Base Unit of Measure';
           "Enquiry Line Attribute Entry"."Document No.":=EnqNo;
            "Enquiry Line Attribute Entry"."Line No.":=EnqLineno;

            "Enquiry Line Attribute Entry"."Sorting Order":='NA';
            "Enquiry Line Attribute Entry"."User ID" := UserId;
            "Enquiry Line Attribute Entry"."Update in Enquiry Line":=false;
            "Enquiry Line Attribute Entry".Insert(true);
        end;
         Commit;
    end;

    procedure SetEnquiryLine(NewSalesEnquiryLine: Record "Sales Line")
    begin
        EnquiryLine := NewSalesEnquiryLine;
    end;
}

