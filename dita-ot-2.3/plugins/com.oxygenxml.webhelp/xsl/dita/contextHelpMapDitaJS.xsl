<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:oxygen="http://www.oxygenxml.com/functions"
    exclude-result-prefixes="oxygen"
    version="2.0">
    
    
    
    <xsl:output method="text" />
    
    <xsl:template match="map">
        <xsl:text>var contextIds = {</xsl:text>
        <xsl:for-each select="appContext">
            <xsl:text>"</xsl:text><xsl:value-of select="@helpID"/><xsl:text>":"</xsl:text><xsl:value-of select="@path"/><xsl:text>"</xsl:text>
            <xsl:if test="not(position() eq last())"><xsl:text>,</xsl:text>
            </xsl:if>            
        </xsl:for-each>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()"/>
</xsl:stylesheet>