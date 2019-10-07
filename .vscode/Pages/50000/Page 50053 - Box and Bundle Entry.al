page 50053 "Box and Bundle Entry"
{
    // version Packing List Samadhan

    PageType = CardPart;
    SourceTable = "Packing List Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Type Of Packing";"Type Of Packing")
                {
                    OptionCaption = ',Box,Bundle';
                }
                field("No of Box/ Bundle";"No of Box/ Bundle")
                {

                    trigger OnValidate()
                    begin
                        //Deepak
                        "Select for Shipment":=true;
                        UpdateQty;
                    end;
                }
                field("Qty Per Box / Bundle";"Qty Per Box / Bundle")
                {

                    trigger OnValidate()
                    begin
                        UpdateQty;
                    end;
                }
                field(Quantity;Quantity)
                {
                    Editable = false;
                }
                field("Item No.";"Item No.")
                {
                }
                field("Select for Shipment";"Select for Shipment")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select All")
            {
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Lines added by Deepak Kumar
        "Document Type":="Document Type"::Order;
        TempPackingNo:=GetFilter("Sales Order No.");
        "Sales Order No.":=GetFilter("Sales Order No.");

        "Item No.":=GetFilter("Item No.");
        "Packing List No.":=GetFilter("Sales Order No.");
        "Type Of Packing":=1;

        PackingListLine.Reset;
        PackingListLine.SetCurrentKey("Packing List No.","Pallet No.");
        PackingListLine.SetRange(PackingListLine."Packing List No.",GetFilter("Sales Order No."));
        if PackingListLine.FindLast then begin
          TempPackingLineNumber:=PackingListLine."Pallet No."+10;
        end else begin
          TempPackingLineNumber:=10;
        end;

        "Pallet No.":=TempPackingLineNumber;
        //INSERT(TRUE);
        //COMMIT;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //if Rec.FINDFIRST then begin
          SetRange("Select for Shipment",true);
          if Rec.FindFirst then begin
              TotalQty:=0;
              repeat
                TotalQty+=Quantity;
              until Next=0;
              SalesLine.Reset;
              SalesLine.SetRange(SalesLine."Document Type",SalesLine."Document Type"::Order);
              SalesLine.SetRange(SalesLine."Document No.","Sales Order No.");
              SalesLine.SetRange(SalesLine."Line No.","Document Line No");
              if  SalesLine.FindFirst then begin

                IteM.Reset;
                IteM.SetRange(IteM."No.",SalesLine."No.");
                if IteM.FindFirst then begin
                  IteM.SetFilter(IteM."Location Filter",SalesLine."Location Code");
                  IteM.SetRange(IteM."Date Filter",0D,WorkDate);
                  IteM.CalcFields(IteM."Net Change");
                  if IteM."Net Change" < TotalQty then
                    Error('Available inventory is only %1',IteM."Net Change");
                end;
                CustCheckCreditLimit.SalesLineCheck(SalesLine);

                if "Document Type" = "Document Type"::"Delivery Order" then
                  SalesLine.Validate(SalesLine.Quantity,TotalQty)
                else
                  SalesLine.Validate(SalesLine."Qty. to Ship",TotalQty);

              SalesLine.Modify(true);
              end;
          end;
    end;

    var
        SalesLine: Record "Sales Line";
        TotalQty: Decimal;
        TempPackingNo: Code[50];
        TempPackingLineNumber: Integer;
        PackingListLine: Record "Packing List Line";
        TempLineNumber: Integer;
        IteM: Record Item;
        TempDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Delivery Order";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";

    procedure UpdateQty()
    begin
        // Lines added by Deepak Kumar
        Quantity:="No of Box/ Bundle"*"Qty Per Box / Bundle";
    end;
}

