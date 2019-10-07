pageextension 50002 Ext_18_GLAccountLits extends "G/L Account List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Net Change"; "Net Change")
            {

            }
            field(Balance; Balance)
            {

            }
            field("Balance at Date"; "Balance at Date")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}