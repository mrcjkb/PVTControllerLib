/*************************************************************************
 *** FORTE Library Element
 ***
 *** This file was generated using the 4DIAC FORTE Export Filter V1.0.x!
 ***
 *** Name: FB_WATCHDOG
 *** Description: Service Interface Function Block Type
 *** Version: 
 ***     0.0: 2017-09-10/4DIAC-IDE - 4DIAC-Consortium - 
 *************************************************************************/

#include "FB_WATCHDOG.h"
#ifdef FORTE_ENABLE_GENERATED_SOURCE_CPP
#include "FB_WATCHDOG_gen.cpp"
#endif
#include "stdio.h"
#include "fcntl.h"
#include "linux/watchdog.h"
#include "sys/ioctl.h"
#include "unistd.h"

DEFINE_FIRMWARE_FB(FORTE_FB_WATCHDOG, g_nStringIdFB_WATCHDOG)

const CStringDictionary::TStringId FORTE_FB_WATCHDOG::scm_anDataInputNames[] = { g_nStringIdQI, g_nStringIdTIMEOUT };

const CStringDictionary::TStringId FORTE_FB_WATCHDOG::scm_anDataInputTypeIds[] = { g_nStringIdBOOL, g_nStringIdTIME };

const CStringDictionary::TStringId FORTE_FB_WATCHDOG::scm_anDataOutputNames[] = { g_nStringIdQO, g_nStringIdSTATUS, g_nStringIdTIMEOUTO };

const CStringDictionary::TStringId FORTE_FB_WATCHDOG::scm_anDataOutputTypeIds[] = { g_nStringIdBOOL, g_nStringIdWSTRING, g_nStringIdTIME };

const TForteInt16 FORTE_FB_WATCHDOG::scm_anEIWithIndexes[] = { 0, 3 };
const TDataIOID FORTE_FB_WATCHDOG::scm_anEIWith[] = { 0, 1, 255, 0, 255 };
const CStringDictionary::TStringId FORTE_FB_WATCHDOG::scm_anEventInputNames[] = { g_nStringIdINIT, g_nStringIdREQ };

const TDataIOID FORTE_FB_WATCHDOG::scm_anEOWith[] = { 0, 1, 2, 255 };
const TForteInt16 FORTE_FB_WATCHDOG::scm_anEOWithIndexes[] = { 0, -1 };
const CStringDictionary::TStringId FORTE_FB_WATCHDOG::scm_anEventOutputNames[] = { g_nStringIdINITO };

const SFBInterfaceSpec FORTE_FB_WATCHDOG::scm_stFBInterfaceSpec = {
	2,  scm_anEventInputNames,  scm_anEIWith,  scm_anEIWithIndexes,
	1,  scm_anEventOutputNames,  scm_anEOWith, scm_anEOWithIndexes,  2,  scm_anDataInputNames, scm_anDataInputTypeIds,
	3,  scm_anDataOutputNames, scm_anDataOutputTypeIds,
	0, 0
};



void FORTE_FB_WATCHDOG::executeEvent(int pa_nEIID){
	switch (pa_nEIID) {
	case scm_nEventINITID:
		if (true == QI() && 0 == m_deviceHandle) {
			// Open watchdog
			if ((m_deviceHandle = open("/dev/watchdog", O_RDWR | O_NOCTTY)) < 0) {
				STATUS() = "OPEN_WATCHDOG_FAILED";
				QO() = false;
				m_deviceHandle = 0;
			}
			// Attempt to set timeout
			int timeout = (int) TIMEOUT().getInSeconds();
			int timeouto;
			if (ioctl(m_deviceHandle, WDIOC_SETTIMEOUT, &timeout) != 0) {
				STATUS() = "SET_TIMEOUT_FAILED";
				QO() = false;
			};
			ioctl(m_deviceHandle, WDIOC_GETTIMEOUT, &timeouto);
			ioctl(m_deviceHandle, WDIOC_KEEPALIVE, 0);
			TIMEOUTO().setFromSeconds(timeouto);
			STATUS() = "OK";
			QO() = true;
		}
		else {
			if (0 != m_deviceHandle) {
				write(m_deviceHandle, "V", 1);
				close(m_deviceHandle);
				m_deviceHandle = 0;
			}
			STATUS() = "TERMINATED";
			QO() = false;
		}
		sendOutputEvent(scm_nEventINITOID);
		break;
    case scm_nEventREQID:
		if (true == QI() && 0 != m_deviceHandle) {
			ioctl(m_deviceHandle, WDIOC_KEEPALIVE, 0);
		}
		break;
  }
}



