/*************************************************************************
*** FORTE Library Element
***
***
*** Name: ForteLoadForecaster
*** Description: Function block for holding historical load power measurements and generating load forecasts.
***				 This is a subclass of the LoadForecaster function block. It adds the functionality of saving its
***				 forecast data in a CSV file and loading it upon initialization if a file is available.
***				 In order for this CSIFB to work, the FORTE_LoadForecaster class's private methods & properties
***				 must be set to protected and the alg_initialize() and alg_updateMemory() methods must be set to
***				 virtual.
*** Version:
***     1.0: 2017-09-10/Marc Jakobi - HTW Berlin -
*************************************************************************/

#include "ForteLoadForecaster.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "ForteLoadForecaster_gen.cpp"
#endif


DEFINE_FIRMWARE_FB(FORTE_ForteLoadForecaster, g_nStringIdForteLoadForecaster)

void FORTE_ForteLoadForecaster::alg_initialize(void) {
	FORTE_LoadForecaster::alg_initialize();
	if (QI()) {
		if (fileExists()) {
			openCSVFile();
			readCSVFileLine(POWERLASTDAY(), 1440);
			readCSVFileLine(POWERCURRDAY(), 1440);
			closeCSVFile();
		}
	}
	else {
		closeCSVFile();
	}
}

void FORTE_ForteLoadForecaster::alg_updateMemory(void) {
	FORTE_LoadForecaster::alg_updateMemory();
	resetCSVFile();
	writeCSVFileLine(POWERLASTDAY(), 1440);
	writeCSVFileLine(POWERCURRDAY(), 1440);
	closeCSVFile();
}
