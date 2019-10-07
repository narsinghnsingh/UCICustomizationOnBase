report 50090 "RPO WISE Pallet Tag"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/RPO WISE Pallet Tag.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING (Status, "Prod. Order No.", "Line No.") ORDER(Ascending);
            RequestFilterFields = "Prod. Order No.", "Line No.";
            column(COMPIC; COMINFO.Picture)
            {
            }
            column(No_ProductionOrder; "Prod. Order Line"."Prod. Order No.")
            {
            }
            column(Description_ProductionOrder; "Prod. Order Line".Description)
            {
            }
            column(CreationDate_ProductionOrder; "Prod. Order Line"."Creation Date")
            {
            }
            column(SourceNo_ProductionOrder; "Prod. Order Line"."Item No.")
            {
            }
            column(EXT_NO; EXT_NO)
            {
            }
            column(CARTOONSIZE; CARTOONSIZE)
            {
            }
            column(CUST_NAME; CUST_NAME)
            {
            }
            column(PALLETNO; PALLETNO)
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
            column(ProductionDate; ProductionDate)
            {
            }
            column(PART_NO; PART_NO)
            {
            }
            column(RPOQTY; RPOQTY)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Print Logo" = true then begin
                    COMINFO.CalcFields(Picture);
                end;

                if "Made in U.A.E" = true then begin
                    TXT1 := 'Made  in  U.A.E'
                end else begin
                    TXT1 := '';
                end;

                if "Print Logo" = true then begin
                    TXT2 := 'P A L L E T   T A G';
                end else begin
                    TXT2 := '';
                end;

                /*ITEM.RESET;
                ITEM.SETRANGE(ITEM."No.","Item No.");
                IF ITEM.FINDFIRST THEN BEGIN
                  PART_NO := ITEM."No. 2";
                END;
                */

                if NAME_NOT_PRINTED = false then begin
                    PROD_ORD.Reset;
                    PROD_ORD.SetRange(PROD_ORD."No.", "Prod. Order No.");
                    if PROD_ORD.FindFirst then begin
                        CUST_NAME := PROD_ORD."Customer Name";
                    end;
                end else begin
                    CUST_NAME := '';
                end;

                PROD_ORD.Reset;
                PROD_ORD.SetRange(PROD_ORD."No.", "Prod. Order No.");
                if PROD_ORD.FindFirst then begin
                    SALES_NO := PROD_ORD."Sales Order No.";
                    // MESSAGE(SALES_NO);
                    SH.Reset;
                    SH.SetFilter(SH."Document Type", 'Order');
                    SH.SetRange(SH."No.", SALES_NO);
                    if SH.FindFirst then begin
                        EXT_NO := SH."External Document No.";
                        //   MESSAGE(EXT_NO);
                    end;
                end;





                ITEM_ATTRIBUTENTRY.Reset;
                ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item No.", "Item No.");
                ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'LENGTH');
                if ITEM_ATTRIBUTENTRY.FindFirst then begin
                    ITEM_LENGHT := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                end else begin
                    ITEM_LENGHT := '';
                end;

                ITEM_ATTRIBUTENTRY.Reset;
                ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item No.", "Item No.");
                ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'WIDTH');
                if ITEM_ATTRIBUTENTRY.FindFirst then begin
                    ITEM_WIDTH := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                end else begin
                    ITEM_WIDTH := '';
                end;


                ITEM_ATTRIBUTENTRY.Reset;
                ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item No.", "Item No.");
                ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'HEIGHT');
                if ITEM_ATTRIBUTENTRY.FindFirst then begin
                    ITEM_HEIGHT := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                end else begin
                    ITEM_HEIGHT := '';
                end;


                CARTOONSIZE := ITEM_LENGHT + ' ' + 'X' + ' ' + ITEM_WIDTH + ' ' + 'X' + ' ' + ITEM_HEIGHT;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
                field("Production Date"; ProductionDate)
                {
                }
                field(PALLETNO; PALLETNO)
                {
                    Caption = 'Pallet No.';
                }
                field(RPOQTY; RPOQTY)
                {
                    Caption = 'Quantity';
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
        SALES_NO: Code[20];
        EXT_NO: Text[250];
        PO: Record "Production Order";
        ITEM_DESCPTION: Text[250];
        PRODUCTION_DATE: Date;
        ITEM: Record Item;
        MATERIAL_CODE: Code[30];
        ITEM_ATTRIBUTENTRY: Record "Item Attribute Entry";
        ITEM_LENGHT: Code[10];
        ITEM_WIDTH: Code[10];
        ITEM_HEIGHT: Code[10];
        CARTOONSIZE: Text;
        PALLETNO: Integer;
        "Made in U.A.E": Boolean;
        TXT1: Text[50];
        "Print Logo": Boolean;
        TXT2: Text[250];
        COMPIC: Guid;
        ProductionDate: Date;
        RPOQTY: Integer;
        PART_NO: Code[50];
        NAME_NOT_PRINTED: Boolean;
        MfgSetup: Record "Manufacturing Setup";
        PROD_ORD: Record "Production Order";
}

