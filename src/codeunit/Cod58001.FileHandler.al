codeunit 58001 "File Handler"
{   
    TableNo = "File Creation Log";

    trigger OnRun();
    begin
        CreateJsonData(Rec);
    end;

    local procedure CreateJsonData("Data": Record "File Creation Log");
    var
        JShipmentHeader: JsonObject;
        JShipmentArray: JsonArray;
        JShipmentLinesArray: JsonArray;
        JsonData: Text;
        StreamOut: OutStream;
    begin
        JShipmentHeader := CreateJsonHeader(Data);
        JShipmentArray.Add(JShipmentHeader);

        JShipmentLinesArray := CreateJsonLines(Data);
        JShipmentArray.Add(JShipmentLinesArray);

        if JShipmentArray.WriteTo(JsonData) then begin
            Data."Json Data".CreateOutStream(StreamOut);
            StreamOut.Write(JsonData);
            Data."Json Created" := true;
            Data.Modify(true);
        end;
    end;

    local procedure CreateJsonHeader(Data: Record "File Creation Log")JShipmentHeader: JsonObject;
    var
        ShipmentHeader: Record "Sales Shipment Header";
    begin
        if not ShipmentHeader.Get(Data."Sales Shipment No.") then
            exit;

        JShipmentHeader.Add('No.', ShipmentHeader."No.");
        JShipmentHeader.Add('Customer Name', ShipmentHeader."Ship-to Name");
        JShipmentHeader.Add('Customer Name 2', ShipmentHeader."Ship-to Name 2");
        JShipmentHeader.Add('Address', ShipmentHeader."Ship-to Address");
        JShipmentHeader.Add('Address 2', ShipmentHeader."Ship-to Address 2");
        JShipmentHeader.Add('City', ShipmentHeader."Ship-to City");
        JShipmentHeader.Add('Country/Region Code', ShipmentHeader."Ship-to Country/Region Code");
        JShipmentHeader.Add('Post Code', ShipmentHeader."Ship-to Post Code");

        exit;
    end;

    local procedure CreateJsonLines(Data: Record "File Creation Log") JShipmentLinesArray: JsonArray;
    var
        ShipmentLines: Record "Sales Shipment Line";
        JShipmentLines: JsonObject;
    begin
        ShipmentLines.SetFilter("Document No.", '%1', Data."Sales Shipment No.");
        if ShipmentLines.FindSet() then begin
            repeat
                JShipmentLines.Add('Line No.', ShipmentLines."Line No.");
                JShipmentLines.Add('Item No.', ShipmentLines."No.");
                JShipmentLines.Add('Quantity', ShipmentLines.Quantity);
                JShipmentLines.Add('Unit Price', ShipmentLines."Unit Price");

                JShipmentLinesArray.Add(JShipmentLines);
                Clear(JShipmentLines);
            until ShipmentLines.Next() = 0;
        end;

        exit;
    end;

    procedure DoPostRequeset(Data: Record "File Creation Log") ResponseText: Text;
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ReqMsg: HttpRequestMessage;
        RespMsg: HttpResponseMessage;
        Body: Text;
        Uri: Text;
        InStr: InStream;
    begin
        Data.CalcFields(Data."Json Data");
        
        if Data."Json Data".HasValue then begin
            Data."Json Data".CreateInStream(InStr);
            InStr.Read(Body);
        end;

        Content.WriteFrom(Body);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        
        ReqMsg.SetRequestUri('http://requestbin.fullcontact.com/v7s6r6v7'); // Random postbin
        ReqMsg.Method := 'POST';
        ReqMsg.Content(Content);

        Client.Send(ReqMsg, RespMsg);

        // Read the response content as json.
        RespMsg.Content().ReadAs(ResponseText);
    end;
}