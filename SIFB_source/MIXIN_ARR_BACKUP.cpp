/*******************************************************************************
 * Mixin class for letting Forecaster function blocks bakup their states.
 *******************************************************************************/
#include "MIXIN_ARR_BACKUP.h"
#include <string.h>
#include <errno.h>

void MIXIN_ARR_BACKUP::openCSVFile(){
  if(0 == m_pstCSVFile){
	m_pstCSVFile = fopen(m_fileName, "r+");
  }
}

void MIXIN_ARR_BACKUP::closeCSVFile(){
  if(0 != m_pstCSVFile) {
	  fclose(m_pstCSVFile);
	}
	m_pstCSVFile = 0;
}

void MIXIN_ARR_BACKUP::resetCSVFile() {
	if (0 == m_pstCSVFile) {
		m_pstCSVFile = fopen(m_fileName, "w+");
	}
}


void MIXIN_ARR_BACKUP::writeCSVFileLine(CIEC_ANY* dataArray, const int& numValues){
	if (0 != m_pstCSVFile) {
		char acBuffer[30000];
		for (int j = 0; j < numValues; j++) {
			int nLen = dataArray[j].toString(acBuffer, 30000);
			fwrite(acBuffer, 1, nLen, m_pstCSVFile);
			fwrite(";", 1, 1, m_pstCSVFile);
		}
		fwrite("\n", 1, 1, m_pstCSVFile);
	}
}

void MIXIN_ARR_BACKUP::readCSVFileLine(CIEC_ANY* dataArray, const int& numValues) {
	if (0 != m_pstCSVFile) {
		char acBuffer[30000];
		fgets(acBuffer, 30000, m_pstCSVFile); // Reads up to first newline or end of file
		TForteUInt16 idxct = 0;
		char* pt;
		pt = strtok(acBuffer, ";");
		while (pt != 0 && idxct < numValues) {
			dataArray[idxct++].fromString(pt);
			pt = strtok(0, ";");
		}
	}
}


bool MIXIN_ARR_BACKUP::fileExists() {
	if (0 != m_pstCSVFile) { // file is open
		return true;
	}
	if (FILE * file = fopen(m_fileName, "r")) {
		fclose(file);
		return true;
	}
	return false;
}