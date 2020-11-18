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

#ifndef _FORTEPVFORECASTER_H_
#define _FORTEPVFORECASTER_H_

#include <basicfb.h>
#include <forte_bool.h>
#include <forte_uint.h>
#include <forte_int.h>
#include <forte_lreal.h>
#include <forte_array.h>
#include "PVForecaster.h"
#include "MIXIN_ARR_BACKUP.h"

class FORTE_FortePVForecaster : public FORTE_PVForecaster, MIXIN_ARR_BACKUP {
	DECLARE_FIRMWARE_FB(FORTE_FortePVForecaster)

private:

	void alg_initialize(void);
	void alg_updateMemory(void);

public:
	FORTE_FortePVForecaster(CStringDictionary::TStringId pa_nInstanceNameId, CResource *pa_poSrcRes) :
		FORTE_PVForecaster(pa_nInstanceNameId, pa_poSrcRes) {
		m_fileName = "pvForecaster_backup.csv";
	};

	virtual ~FORTE_FortePVForecaster() {};

};

#endif //close the ifdef sequence from the beginning of the file

