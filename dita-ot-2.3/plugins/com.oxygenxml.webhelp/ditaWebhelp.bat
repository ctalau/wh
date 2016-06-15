@echo off

REM  Oxygen WebHelp Plugin
REM  Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

REM The path of the Java Virtual Machine install directory
set JVM_INSTALL_DIR=$JAVA_HOME

REM The path of the DITA Open Toolkit install directory
set DITA_OT_INSTALL_DIR=..\dita-ot-2.3

REM One of the following three values: 
REM      webhelp
REM      webhelp-responsive
REM      webhelp-feedback
REM      webhelp-mobile
set TRANSTYPE=webhelp-responsive

REM The path of the directory of the input DITA map file
set DITA_MAP_BASE_DIR=..\it-book

REM The name of the input DITA map file
set DITAMAP_FILE=taskbook.ditamap

REM  IMPORTANT NOTE: If you use DITA-OT version 2.x you must remove 
REM  dost-patches-DITA-1.8.jar and xercesPatches.jar from the  
REM  java command.

"%JVM_INSTALL_DIR%\bin\java"^
 -Xmx512m^
 -classpath^
 "%DITA_OT_INSTALL_DIR%\tools\ant\lib\ant-launcher.jar;%DITA_OT_INSTALL_DIR%\lib\ant-launcher.jar"^
 "-Dant.home=%DITA_OT_INSTALL_DIR%\tools\ant" org.apache.tools.ant.launch.Launcher^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\xercesImpl.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\xml-apis.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\xml-apis-ext.jar"^
 -lib "%DITA_OT_INSTALL_DIR%"^
 -lib "%DITA_OT_INSTALL_DIR%\lib"^
 -lib "%DITA_OT_INSTALL_DIR%\lib\saxon"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\license.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\log4j.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\resolver.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\lucene-analyzers-common-4.0.0.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\lucene-core-4.0.0.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\xhtml-indexer.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.highlight\lib\xslthl-2.1.0.jar"^
 -lib "%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\lib\webhelpXsltExtensions.jar"^
 -f "%DITA_OT_INSTALL_DIR%\build.xml"^
 "-Dtranstype=%TRANSTYPE%"^
 "-Dbasedir=%DITA_MAP_BASE_DIR%"^
 "-Doutput.dir=%DITA_MAP_BASE_DIR%\out\%TRANSTYPE%"^
 "-Ddita.temp.dir=%DITA_MAP_BASE_DIR%\temp\%TRANSTYPE%"^
 "-Dargs.hide.parent.link=no"^
 "-Ddita.dir=%DITA_OT_INSTALL_DIR%"^
 "-Dargs.xhtml.classattr=yes"^
 "-Dargs.input=%DITA_MAP_BASE_DIR%\%DITAMAP_FILE%"^
  "-Dwebhelp.skin.css=%DITA_OT_INSTALL_DIR%\plugins\com.oxygenxml.webhelp\predefined-skins\dita\oxygen\skin.css"^
 "-DbaseJVMArgLine=-Xmx384m"