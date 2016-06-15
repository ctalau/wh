<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!--
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    -->
    <xsl:template name="addCustomMeta">
        <xsl:param name="namespace"/>
        <!-- EXM-28047 - For responsive layout, 
          set the width of the page to as long as the width of the device -->
        <xsl:element name="meta" namespace="{$namespace}">
            <xsl:attribute name="name">viewport</xsl:attribute>
            <xsl:attribute name="content">width=device-width, initial-scale=1.0</xsl:attribute>
        </xsl:element>
    </xsl:template>
            
</xsl:stylesheet>