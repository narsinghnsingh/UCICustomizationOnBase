report 50029 "Bundle Tag after post"
{
    // version Production/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Bundle Tag after post.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING ("Order No.");
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Order No.", "Order Line No.") ORDER(Ascending);
                RequestFilterFields = "Order No.";
                column(COMINFO_NAME; COMINFO.Name)
                {
                }
                column(OrderNo_SalesShipmentLine; "Sales Shipment Line"."Order No.")
                {
                }
                column(No_SalesShipmentLine; "Sales Shipment Line"."No.")
                {
                }
                column(DocumentNo_SalesShipmentLine; "Sales Shipment Line"."Document No.")
                {
                }
                column(CUST_NAME; CUST_NAME)
                {
                }
                column(MATERIAL_CODE; MATERIAL_CODE)
                {
                }
                column(ITEM_DESC; ITEM_DESC)
                {
                }
                column(CARTOONSIZE; CARTOONSIZE)
                {
                }
                dataitem("Packing List Line"; "Packing List Line")
                {
                    DataItemLink = "Packing List No." = FIELD ("Order No."), "Document Line No" = FIELD ("Line No.");
                    DataItemTableView = SORTING ("Sales Order No.", "Item No.") ORDER(Ascending);
                    column(ProdOrderNo_PackingListLine; "Packing List Line"."Prod. Order No.")
                    {
                    }
                    column(PRODUCTION_DATE; PRODUCTION_DATE)
                    {
                    }
                    column(NoofBoxBundle_PackingListLine; "Packing List Line"."No of Box/ Bundle")
                    {
                    }
                    column(QtyPerBoxBundle_PackingListLine; "Packing List Line"."Qty Per Box / Bundle")
                    {
                    }
                    column(Quantity_PackingListLine; "Packing List Line".Quantity)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        PO.Reset;
                        PO.SetRange(PO."No.", "Prod. Order No.");
                        if PO.FindFirst then begin
                            PRODUCTION_DATE := PO."Creation Date";
                        end else begin
                            PRODUCTION_DATE := 0D;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Packing List Line".SetFilter("Packing List Line"."Packing List No.", DOCNO);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    COMINFO.Get;

                    SS_HEADER.Reset;
                    SS_HEADER.SetRange(SS_HEADER."Sell-to Customer No.", "Sell-to Customer No.");
                    if SS_HEADER.FindFirst then begin
                        CUST_NAME := SS_HEADER."Sell-to Customer Name";
                    end else begin
                        CUST_NAME := '';
                        ;
                    end;

                    ITEM.Reset;
                    ITEM.SetRange(ITEM."No.", "No.");
                    if ITEM.FindFirst then begin
                        ITEM_DESC := ITEM.Description;
                        MATERIAL_CODE := ITEM."No. 2";
                    end else begin
                        ITEM_DESC := '';
                        MATERIAL_CODE := '';
                    end;

                    ITEM_ATTRIBUTENTRY.Reset;
                    ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item No.", "No.");
                    ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'LENGTH');
                    if ITEM_ATTRIBUTENTRY.FindFirst then begin
                        ITEM_LENGHT := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                    end else begin
                        ITEM_LENGHT := '';
                    end;

                    ITEM_ATTRIBUTENTRY.Reset;
                    ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item No.", "No.");
                    ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'WIDTH');
                    if ITEM_ATTRIBUTENTRY.FindFirst then begin
                        ITEM_WIDTH := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                    end else begin
                        ITEM_WIDTH := '';
                    end;


                    ITEM_ATTRIBUTENTRY.Reset;
                    ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item No.", "No.");
                    ITEM_ATTRIBUTENTRY.SetRange(ITEM_ATTRIBUTENTRY."Item Attribute Code", 'HEIGHT');
                    if ITEM_ATTRIBUTENTRY.FindFirst then begin
                        ITEM_HEIGHT := ITEM_ATTRIBUTENTRY."Item Attribute Value";
                    end else begin
                        ITEM_HEIGHT := '';
                    end;

                    CARTOONSIZE := ITEM_LENGHT + 'X' + ITEM_WIDTH + 'X' + ITEM_HEIGHT + ' ' + 'mm';
                end;

                trigger OnPreDataItem()
                begin
                    DOCNO := "Sales Shipment Line".GetFilter("Sales Shipment Line"."Order No.");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
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
        CUST_NAME: Text[250];
        SS_HEADER: Record "Sales Shipment Header";
        PO: Record "Production Order";
        PRODUCTION_DATE: Date;
        ITEM: Record Item;
        ITEM_DESC: Text[250];
        MATERIAL_CODE: Code[30];
        ITEM_ATTRIBUTENTRY: Record "Item Attribute Entry";
        ITEM_LENGHT: Code[10];
        ITEM_WIDTH: Code[10];
        ITEM_HEIGHT: Code[10];
        CARTOONSIZE: Text;
        DOCNO: Code[20];
}

