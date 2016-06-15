<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp Plugin
Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template name="addResourceID">
        <!-- OXYGEN PATCH START  EXM-27369 -->
        <xsl:param name="doc"/>
        <xsl:variable name="resourceid">
            <xsl:choose>
                <xsl:when test="$doc/*/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/resourceid ')]">
                    <xsl:sequence select="$doc/*/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/resourceid ')]/normalize-space(@id)"/>
                </xsl:when>
                <xsl:when test="$doc//*[contains(@class, ' topic/topic ')]/@id">
                    <xsl:variable name="allIDs" select="$doc//*[contains(@class, ' topic/topic ')]/@id"/>
                    <xsl:variable name="HREF" select="@href"/>
                    <xsl:choose>
                        <xsl:when test="contains($HREF, '#')">
                            <xsl:variable name="anchor" select="substring-after($HREF, '#')"/>
                            <xsl:choose>
                                <xsl:when test="$anchor = $allIDs">
                                    <xsl:sequence select="$anchor"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="normalize-space(($allIDs)[1])"/>  
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="normalize-space(($allIDs)[1])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="count($resourceid) = 0 and string-length(base-uri($doc)) > 0">
                <xsl:message>Warning: no resource ID and no topic ID in file: <xsl:value-of select="base-uri($doc)"/></xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="resourceid"><xsl:value-of select="$resourceid"/></xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <!-- OXYGEN PATCH END  EXM-27369 -->
    </xsl:template>
</xsl:stylesheet>