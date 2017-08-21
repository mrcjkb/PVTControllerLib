# PVTControllerLib
IEC 61499 function block library for building forecast based energy system control applications.
​
# Requires
* Any IEC 61499 compliant tool
* Full list of tools: http://www.iec61499.de/tools.htm
* The 4diac function block library: https://www.eclipse.org/4diac/en_lib.php

# Installation in 4diac
* https://www.eclipse.org/4diac/
* Create a new project in 4diac-IDE and copy the subdirectories into the workkspace, i.e.
  4DIAC-IDE 1.8.4\workspace\PVTController\PVTControllerLib
* Export the function blocks to the FORTE modules folder (see 4diac documentation: https://www.eclipse.org/4diac/documentation/html/4diacIDE/createOwnTypes.html#exportTypes)
* Add the modules to CMake and also add the following modules:
  FORTE_MODULE_Convert, FORTE_MODULE_Events, FORTE_MODULE_Functional, FORTE_MODULE_IEC61131, FORTE_MODULE_RT_Events, FORTE_MODULE_UTILS, FORTE_MODULE_Utils,
  FORTE_COM_FBDK (optional)
  (see: https://www.eclipse.org/4diac/documentation/html/installation/install.html#ownFORTE)
* Build FORTE
* The project includes various applications that can be extracted from the Applications.zip file and copied to the project's root directory.
​
# Documentation
The library was created using 4diac.
A detailed documentation of the project is in the works and a link to it will be added here as soon as it is published.
