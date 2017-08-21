<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE AdapterType SYSTEM "http://www.holobloc.com/xml/LibraryElement.dtd">
<AdapterType Name="ABatteryModel">
  <Identification Standard="61499-1"/>
  <VersionInfo Author="GE" Date="2008-04-22" Organization="4DIAC-Consortium" Version="0.0"/>
  <InterfaceList>
    <EventInputs>
      <Event Comment="Battery Simulation Arrival" Name="SIMIN" Type="Event">
        <With Var="CSIM"/>
      </Event>
    </EventInputs>
    <EventOutputs>
      <Event Comment="Battery Simulation Request" Name="SIM" Type="Event">
        <With Var="ECD"/>
        <With Var="ECD"/>
      </Event>
    </EventOutputs>
    <InputVars>
      <VarDeclaration Comment="Battery capacity after simulation in kWh" Name="CSIM" Type="LREAL"/>
    </InputVars>
    <OutputVars>
      <VarDeclaration Comment="Charging (positive)/discharging (negative) energy for battery simulation in kWh" Name="ECD" Type="LREAL"/>
    </OutputVars>
  </InterfaceList>
  <Service LeftInterface="SOCKET" RightInterface="PLUG">
    <ServiceSequence Name="request_confirm">
      <ServiceTransaction>
        <InputPrimitive Event="REQ" Interface="SOCKET" Parameters="REQD"/>
        <OutputPrimitive Event="REQ" Interface="PLUG" Parameters="REQD"/>
      </ServiceTransaction>
      <ServiceTransaction>
        <InputPrimitive Event="CNF" Interface="PLUG" Parameters="CNFD"/>
        <OutputPrimitive Event="CNF" Interface="SOCKET" Parameters="CNFD"/>
      </ServiceTransaction>
    </ServiceSequence>
    <ServiceSequence Name="indication_response">
      <ServiceTransaction>
        <InputPrimitive Event="IND" Interface="PLUG" Parameters="INDD"/>
        <OutputPrimitive Event="IND" Interface="SOCKET" Parameters="INDD"/>
      </ServiceTransaction>
      <ServiceTransaction>
        <InputPrimitive Event="RSP" Interface="SOCKET" Parameters="RSPD"/>
        <OutputPrimitive Event="RSP" Interface="PLUG" Parameters="RSPD"/>
      </ServiceTransaction>
    </ServiceSequence>
  </Service>
</AdapterType>
