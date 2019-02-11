codeunit 58000 "Shpt Integration Subscriber"
{
    trigger OnRun();
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure SaveSalesShptHdrNoOnAfterPostSalesDoc(SalesHeader: Record "Sales Header";
    GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    SalesShptHdrNo: Code[20];
    RetRcpHdrNo: Code[20];
    SalesInvHdrNo: Code[20];
    SalesCrMemoHdrNo: Code[20])
    var
        FileCreationLog: Record "File Creation Log";
    begin
        if SalesShptHdrNo = '' then
            exit;
        
        FileCreationLog.Init;
        FileCreationLog."Sales Shipment No." := SalesShptHdrNo;
        FileCreationLog.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"File Creation Log", 'OnAfterInsertEvent', '', false, false)]
    local procedure CreateJsonDataOnAfterInsert(Rec: Record "File Creation Log")
    var
        FileHandler: Codeunit "File Handler";
        Success: Boolean;
    begin
        FileHandler.Run(Rec);
    end;
}