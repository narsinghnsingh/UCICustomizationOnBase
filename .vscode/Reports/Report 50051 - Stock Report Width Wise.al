report 50051 "Stock Report Width Wise"
{
    // version Purchase/Sadaf

    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Stock Report Width Wise.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(CompName; "Company Information".Name)
            {
            }
            column(CompPic; "Company Information".Picture)
            {
            }
            column(Sys_Date; WorkDate)
            {
            }
            dataitem(Item; Item)
            {
                //DataItemTableView = SORTING ("Item Category Code", "Model Description", "Model No", "Paper Type") ORDER(Ascending) WHERE ("Item Category Code" = FILTER ('PAPER'), Blocked = CONST (false));
                RequestFilterFields = "Item Category Code", "Date Filter";
                column(DeckleSize1; Item."Deckle Size (mm)")
                {
                }
                column(PaperType1; Item."Paper Type")
                {
                }
                column(GSM1; Item."Paper GSM")
                {
                }
                column(Item_Qty1; ItemQty)
                {
                }
                column(Remaining_Qty1; ItemReminingQty)
                {
                }
                column(ItemCategoryCode; "Item Category Code")
                {
                }
                column(ItemReminingQty1; TotalQty)
                {
                }
                column(UOM; Item."Base Unit of Measure")
                {
                }
                column(Maxdate; Maxdate)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Item.CalcFields(Item."Qty. on Purch. Order");
                    DSRemainingQty := 0;
                    ItemReminingQty := 0;

                    if "Item Category Code" = 'PAPER' then begin
                        ItemQty := 0;
                        ItemLedgerEntry.Reset;
                        ItemLedgerEntry.SetRange("Item No.", "No.");
                        ItemLedgerEntry.SetRange("Posting Date", 0D, Maxdate);
                        if ItemLedgerEntry.Find('-') then begin
                            repeat
                                ;
                                ItemQty := ItemQty + ItemLedgerEntry.Quantity;
                            until ItemLedgerEntry.Next = 0;
                        end;

                        PurchaseLine.Reset;
                        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SetRange("No.", "No.");
                        PurchaseLine.SetFilter(PurchaseLine."Outstanding Quantity", '<>0');
                        if PurchaseLine.Find('-') then begin
                            repeat
                                ;
                                ItemReminingQty := ItemReminingQty + PurchaseLine."Outstanding Quantity";
                                UOM := PurchaseLine."Unit of Measure Code";
                            until PurchaseLine.Next = 0;
                        end;
                    end;
                    if ItemReminingQty < 0 then ItemReminingQty := 0;
                    TotalQty := 0;
                    TotalQty := (ItemQty + ItemReminingQty);

                    if DSRemainingQty < 0 then DSRemainingQty := 0;
                end;

                trigger OnPreDataItem()
                begin
                    Maxdate := GetRangeMax("Date Filter");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Company Information".CalcFields("Company Information".Picture);
            end;
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
        AttributeEntry: Record "Item Attribute Entry";
        PaperType: Code[50];
        GSM: Integer;
        DeckleSize: Decimal;
        DuplexLength: Code[50];
        DuplexWidth: Code[50];
        LengthWidth: Code[60];
        PaperTypeDS: Code[50];
        GSMDS: Code[60];
        DeckleSizeDS: Code[60];
        DSQty: Decimal;
        DSRemainingQty: Decimal;
        ItemQty: Decimal;
        ItemReminingQty: Decimal;
        PurchaseLine: Record "Purchase Line";
        ItemLedgerQty: Decimal;
        ItemLedgerEntry: Record "Item Ledger Entry";
        Maxdate: Date;
        TotalQty: Decimal;
        UOM: Code[20];
}

