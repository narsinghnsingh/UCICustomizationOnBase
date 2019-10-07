report 50021 "Pallet Tag"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Pallet Tag.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Packing List Line"; "Packing List Line")
        {
            RequestFilterFields = "Prod. Order No.";
            column(COMP_NAME; COMINFO.Name)
            {
            }
            column(PIC; COMINFO.Picture)
            {
            }
            column(ProdOrderNo_PackingListLine; "Packing List Line"."Prod. Order No.")
            {
            }
            column(PRODUCTION_DATE; PRODUCTION_DATE)
            {
            }
            column(CUST_NAME; CUST_NAME)
            {
            }
            column(EXT_NO; EXT_NO)
            {
            }
            column(Quantity_PackingListLine; "Packing List Line".Quantity)
            {
            }
            column(ITEM_DESCPTION; ITEM_DESCPTION)
            {
            }
            column(MATERIAL_CODE; MATERIAL_CODE)
            {
            }
            column(ItemNo_PackingListLine; "Packing List Line"."Item No.")
            {
            }
            column(PalletNo_PackingListLine; "Packing List Line"."Pallet No.")
            {
            }
            column(PackingListNo_PackingListLine; "Packing List Line"."Packing List No.")
            {
            }
            column(CARTOONSIZE; CARTOONSIZE)
            {
            }
            column(PrintLogo; "Print Logo")
            {
            }
            column(Made_UAE; "Made in U.A.E")
            {
            }
            column(TXT1; TXT1)
            {
            }
            column(TXT2; TXT2)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF "Print Logo" = TRUE THEN BEGIN
                    COMINFO.CALCFIELDS(COMINFO.Picture);
                END;


                IF NAME_NOT_PRINTED = FALSE THEN BEGIN
                    SH.RESET;
                    SH.SETRANGE(SH."No.", "Sales Order No.");
                    IF SH.FINDFIRST THEN BEGIN
                        CUST_NAME := SH."Sell-to Customer Name";
                    END;

                END ELSE BEGIN
                    CUST_NAME := '';
                END;


                SH.RESET;
                SH.SETRANGE(SH."No.", "Sales Order No.");
                IF SH.FINDFIRST THEN BEGIN
                    EXT_NO := SH."External Document No.";
                END ELSE BEGIN
                    EXT_NO := '';
                END;



                PO.RESET;
                PO.SETRANGE(PO."No.", "Prod. Order No.");
                IF PO.FINDFIRST THEN BEGIN
                    PRODUCTION_DATE := PO."Creation Date";

                END ELSE BEGIN
                    PRODUCTION_DATE := 0D;
                    //ITEM_DESCPTION := '';
                END;
                ProdOrderLine.RESET;
                ProdOrderLine.SETRANGE(ProdOrderLine."Prod. Order No.", "Prod. Order No.");
                IF ProdOrderLine.FINDFIRST THEN BEGIN
                    ITEM_DESCPTION := ProdOrderLine.Description;
                END ELSE BEGIN
                    PO.RESET;
                    PO.SETRANGE(PO."No.", "Prod. Order No.");
                    IF PO.FINDFIRST THEN
                        ITEM_DESCPTION := PO.Description;

                END;


                ITEM.RESET;
                ITEM.SETRANGE(ITEM."No.", "Item No.");
                IF ITEM.FINDFIRST THEN BEGIN
                    MATERIAL_CODE := ITEM."No. 2";
                END ELSE BEGIN
                    MATERIAL_CODE := '';
                END;


                ITEM_ATTRIBUTENTRY.RESET;
                ITEM_ATTRIBUTENTRY.SETRANGE(ITEM_ATTRIBUTENTRY."Item No.", "Item No.");
                ITEM_ATTRIBUTENTRY.SETRANGE(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'LENGTH');
                IF ITEM_ATTRIBUTENTRY.FINDFIRST THEN BEGIN
                    ITEM_LENGHT := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                END ELSE BEGIN
                    ITEM_LENGHT := '';
                END;

                ITEM_ATTRIBUTENTRY.RESET;
                ITEM_ATTRIBUTENTRY.SETRANGE(ITEM_ATTRIBUTENTRY."Item No.", "Item No.");
                ITEM_ATTRIBUTENTRY.SETRANGE(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'WIDTH');
                IF ITEM_ATTRIBUTENTRY.FINDFIRST THEN BEGIN
                    ITEM_WIDTH := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                END ELSE BEGIN
                    ITEM_WIDTH := '';
                END;


                ITEM_ATTRIBUTENTRY.RESET;
                ITEM_ATTRIBUTENTRY.SETRANGE(ITEM_ATTRIBUTENTRY."Item No.", "Item No.");
                ITEM_ATTRIBUTENTRY.SETRANGE(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'HEIGHT');
                IF ITEM_ATTRIBUTENTRY.FINDFIRST THEN BEGIN
                    ITEM_HEIGHT := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                END ELSE BEGIN
                    ITEM_HEIGHT := '';
                END;

                /*ITEM.RESET;
                ITEM.SETRANGE(ITEM."No.","Item No.");
                IF  ITEM.FINDFIRST  THEN
                  BEGIN
                    MfgSetup.GET();
                    IF (ITEM."Item Category Code"  = MfgSetup."Component Category") THEN
                      BEGIN
                        ITEM_LENGHT := FORMAT(ITEM."Box Length(mm)") ;
                        ITEM_WIDTH  := FORMAT(ITEM."Box Width(mm)") ;
                        ITEM_HEIGHT := FORMAT(ITEM."Box Height(mm)") ;
                      END;
                  END; */
                //ItemCategory.reset;
                //ItemCategory.setrange(ItemCategory.Code,);
                CARTOONSIZE := ITEM_LENGHT + ' ' + 'X' + ' ' + ITEM_WIDTH + ' ' + 'X' + ' ' + ITEM_HEIGHT;


                IF "Made in U.A.E" = TRUE THEN BEGIN
                    TXT1 := 'Made  in  U.A.E'
                END ELSE BEGIN
                    TXT1 := '';
                END;

                IF "Print Logo" = TRUE THEN BEGIN
                    TXT2 := 'P A L L E T   T A G';
                END ELSE BEGIN
                    TXT2 := '';
                END;


                /*PackingListLine.RESET;
                PackingListLine.SETRANGE(PackingListLine."Prod. Order No.","Prod. Order No.");
                PackingListLine.SETRANGE(PackingListLine."Packing List No.","Packing List No.");
                PackingListLine.SETFILTER(PackingListLine.Posted,'TRUE');
                ROWNO :=1;
                  IF PackingListLine.FINDFIRST THEN BEGIN
                    REPEAT
                      PALLET_NO[ROWNO] := PackingListLine."Pallet No.";
                      PALLET_QTY [ROWNO] := PackingListLine.Quantity;
                    ROWNO := ROWNO +1;
                    UNTIL PackingListLine.NEXT=0;
                  END;*/


            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1)
                {
                    ShowCaption = false;
                }
                field("Print Logo"; "Print Logo")
                {
                    Caption = 'Print Logo';
                }
                field("Made in U.A.E"; "Made in U.A.E")
                {
                }
                field("Customer Name Blank"; NAME_NOT_PRINTED)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        COMINFO: Record "Company Information";
        SH: Record "Sales Header";
        CUST_NAME: Text[250];
        EXT_NO: Text[250];
        PO: Record "Production Order";
        ITEM_DESCPTION: Text[250];
        PRODUCTION_DATE: Date;
        "Made in U.A.E": Boolean;
        TXT1: Text[50];
        "Print Logo": Boolean;
        TXT2: Text[250];
        COMPIC: Guid;
        ITEM: Record Item;
        MATERIAL_CODE: Code[30];
        ITEM_ATTRIBUTENTRY: Record "Item Attribute Entry";
        ITEM_LENGHT: Code[10];
        ITEM_WIDTH: Code[10];
        ITEM_HEIGHT: Code[10];
        CARTOONSIZE: Text;
        NAME_NOT_PRINTED: Boolean;
        ItemCategory: Record "Item Category";
        MfgSetup: Record "Manufacturing Setup";
        ProdOrderLine: Record "Prod. Order Line";
        RPONo: Code[20];
        PackingListLine: Record "Packing List Line";
        PALLET_NO: array[100] of Integer;
        PALLET_QTY: array[100] of Decimal;
        ROWNO: Integer;
}

