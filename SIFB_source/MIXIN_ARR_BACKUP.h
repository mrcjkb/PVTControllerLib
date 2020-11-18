/*******************************************************************************
 * Mixin class for letting Forecaster function blocks bakup their states.
 *******************************************************************************/
#ifndef _MIXIN_ARR_BACKUP_H_
#define _MIXIN_ARR_BACKUP_H_

#include <funcbloc.h>
#include <forte_any.h>
#include <forte_array.h>
#include <forte_string.h>
#include <forte_bool.h>
#include <stdio.h>

class MIXIN_ARR_BACKUP {

  protected:
	void openCSVFile();
	void closeCSVFile();
	void resetCSVFile();
	void writeCSVFileLine(CIEC_ANY* dataArray, const int& numValues);
	void readCSVFileLine(CIEC_ANY* dataArray, const int& numValues);
	bool fileExists();

	char* m_fileName;

  private:

	FILE *m_pstCSVFile;

	CStringDictionary::TStringId *m_anDataInputNames;
	CStringDictionary::TStringId *m_anDataInputTypeIds;

	TDataIOID *m_anEIWith;

	CStringDictionary::TStringId m_nConfiguredFBTypeNameId;

};

#endif //close the ifdef sequence from the beginning of the file
