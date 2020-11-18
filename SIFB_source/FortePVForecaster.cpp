/*************************************************************************
*** FORTE Library Element
***
***
*** Name: FortePVForecaster
*** Description: Function block for holding historical PV power measurements and generating PV power forecasts.
***				 This is a subclass of the PVForecaster function block. It adds the functionality of saving its
***				 forecast data in a CSV file and loading it upon initialization if a file is available.
***				 In order for this CSIFB to work, the FORTE_PVForecaster class's private methods & properties
***				 must be set to protected and the alg_initialize() and alg_updateMemory() methods must be set to
***				 virtual.
*** Version:
***     1.0: 2017-09-10/Marc Jakobi - HTW Berlin -
*************************************************************************/

#include "FortePVForecaster.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "FortePVForecaster_gen.cpp"
#endif


DEFINE_FIRMWARE_FB(FORTE_FortePVForecaster, g_nStringIdFortePVForecaster)

void FORTE_FortePVForecaster::alg_initialize(void) {
	FORTE_PVForecaster::alg_initialize();
	if (QI()) {
		if (fileExists()) {
			openCSVFile();
			readCSVFileLine(PVMAXLASTDAY(), 1440);
			readCSVFileLine(PVMAXBEFORELASTDAY(), 1440);
			readCSVFileLine(PVMAXCURRDAY(), 1440);
			readCSVFileLine(POWERLASTDAY(), 1440);
			readCSVFileLine(POWERCURRDAY(), 1440);
			readCSVFileLine(LASTMAX(), 14400);
			readCSVFileLine(LASTMAXAGE(), 1440);
			readCSVFileLine(&AGEINDEX(), 1);
			closeCSVFile();
		}
	}
	else {
		closeCSVFile();
	}
}

void FORTE_FortePVForecaster::alg_updateMemory(void) {
	FORTE_PVForecaster::alg_updateMemory();
	resetCSVFile();
	writeCSVFileLine(PVMAXLASTDAY(), 1440);
	writeCSVFileLine(PVMAXBEFORELASTDAY(), 1440);
	writeCSVFileLine(PVMAXCURRDAY(), 1440);
	writeCSVFileLine(POWERLASTDAY(), 1440);
	writeCSVFileLine(POWERCURRDAY(), 1440);
	writeCSVFileLine(LASTMAX(), 14400);
	writeCSVFileLine(LASTMAXAGE(), 1440);
	writeCSVFileLine(&AGEINDEX(), 1);
	closeCSVFile();
}
