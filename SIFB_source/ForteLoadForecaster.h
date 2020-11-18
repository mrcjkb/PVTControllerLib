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

#ifndef _FORTELOADFORECASTER_H_
#define _FORTELOADFORECASTER_H_

#include <basicfb.h>
#include <forte_bool.h>
#include <forte_uint.h>
#include <forte_int.h>
#include <forte_lreal.h>
#include <forte_array.h>
#include "LoadForecaster.h"
#include "MIXIN_ARR_BACKUP.h"

class FORTE_ForteLoadForecaster : public FORTE_LoadForecaster, MIXIN_ARR_BACKUP {
	DECLARE_FIRMWARE_FB(FORTE_ForteLoadForecaster)

private:

	void alg_initialize(void);
	void alg_updateMemory(void);

public:
	FORTE_ForteLoadForecaster(CStringDictionary::TStringId pa_nInstanceNameId, CResource *pa_poSrcRes) :
		FORTE_LoadForecaster(pa_nInstanceNameId, pa_poSrcRes) {
		m_fileName = "loadForecaster_backup.csv";
	};

	virtual ~FORTE_ForteLoadForecaster() {};

};

#endif //close the ifdef sequence from the beginning of the file