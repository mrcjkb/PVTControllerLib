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

#ifndef _FB_WATCHDOG_H_
#define _FB_WATCHDOG_H_

#include <funcbloc.h>
#include <forte_bool.h>
#include <forte_time.h>
#include <forte_wstring.h>

class FORTE_FB_WATCHDOG: public CFunctionBlock{
  DECLARE_FIRMWARE_FB(FORTE_FB_WATCHDOG)

private:
  static const CStringDictionary::TStringId scm_anDataInputNames[];
  static const CStringDictionary::TStringId scm_anDataInputTypeIds[];
  CIEC_BOOL &QI() {
    return *static_cast<CIEC_BOOL*>(getDI(0));
  };

  CIEC_TIME &TIMEOUT() {
    return *static_cast<CIEC_TIME*>(getDI(1));
  };

  static const CStringDictionary::TStringId scm_anDataOutputNames[];
  static const CStringDictionary::TStringId scm_anDataOutputTypeIds[];
  CIEC_BOOL &QO() {
    return *static_cast<CIEC_BOOL*>(getDO(0));
  };

  CIEC_WSTRING &STATUS() {
    return *static_cast<CIEC_WSTRING*>(getDO(1));
  };

  CIEC_TIME &TIMEOUTO() {
	  return *static_cast<CIEC_TIME*>(getDO(2));
  };

  static const TEventID scm_nEventINITID = 0;
  static const TEventID scm_nEventREQID = 1;
  static const TForteInt16 scm_anEIWithIndexes[];
  static const TDataIOID scm_anEIWith[];
  static const CStringDictionary::TStringId scm_anEventInputNames[];

  static const TEventID scm_nEventINITOID = 0;
  static const TForteInt16 scm_anEOWithIndexes[];
  static const TDataIOID scm_anEOWith[];
  static const CStringDictionary::TStringId scm_anEventOutputNames[];

  static const SFBInterfaceSpec scm_stFBInterfaceSpec;

   FORTE_FB_DATA_ARRAY(1, 2, 3, 0);

  void executeEvent(int pa_nEIID);

  int m_deviceHandle;

public:
  FUNCTION_BLOCK_CTOR(FORTE_FB_WATCHDOG){
  };

  virtual ~FORTE_FB_WATCHDOG(){};

};

#endif //close the ifdef sequence from the beginning of the file

