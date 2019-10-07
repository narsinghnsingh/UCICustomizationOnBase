pageextension 50058 Ext_SalesRetrunSubForm extends "Sales Return Order Subform"
{
    layout
    {
        // Add changes to page layout here                 

    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnAfterGetCurrRecord()
    begin
        IF "Appl.-from Item Entry" <> 0 then
            CurrPage.Editable := false
        else
            CurrPage.Editable := true;
    end;

}