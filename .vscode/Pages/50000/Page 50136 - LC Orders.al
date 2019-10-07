page 50136 "LC Orders"
{
    // version LC Detail

    CaptionML = ENU = 'LC Orders';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "LC Orders";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("LC No."; "LC No.")
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Issued To/Received From"; "Issued To/Received From")
                {
                }
                field("Order No."; "Order No.")
                {
                }
                field("Shipment Date"; "Shipment Date")
                {
                }
                field("Order Value"; "Order Value")
                {
                }
                field("Received Bank Receipt No."; "Received Bank Receipt No.")
                {
                }
                field(Renewed; Renewed)
                {
                }
            }
        }
    }

    actions
    {
    }
}

