<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
    xmlns:oxygen="http://www.oxygenxml.com/functions"
    xmlns:index="http://www.oxygenxml.com/ns/webhelp/index"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:import href="../../createMainFiles-mobile.xsl"/>
    <xsl:import href="../dita-utilities.xsl"/>
    
    <xsl:template name="customHeadScriptMobile">
        <!-- Google Custom Search code set by param webhelp.search.script -->
        <xsl:if test="string-length($WEBHELP_SEARCH_SCRIPT) > 0">
            <xsl:value-of select="unparsed-text($WEBHELP_SEARCH_SCRIPT)" disable-output-escaping="yes"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
