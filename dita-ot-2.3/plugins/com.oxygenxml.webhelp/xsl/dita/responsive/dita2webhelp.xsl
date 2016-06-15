<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
  xmlns:oxygen="http://www.oxygenxml.com/functions"
  exclude-result-prefixes="#all"
  version="2.0">
  
  <!-- Basic processing -->  
  <xsl:import href="../desktop/fixup.xsl"/>
  
  <!-- Add navigation links like side toc(mini toc) or breadcrumb-->
  <xsl:import href="navigationLinks.xsl"/>
  
  <xsl:import href="commonExtension.xsl"/>
  <xsl:import href="../dita2webhelp.xsl"/>
  
  <!-- Apply selected template -->
  <xsl:import href="topicComponentsExpander.xsl"/>
  <xsl:import href="../../functions.xsl"/>
  
  <!-- Enable debugging from here. --> 
  <xsl:param name="WEBHELP_DEBUG" select="false()"/>
  
  <xsl:param name="genAddDiv" select="true()"/>
  
  <!-- The path of toc.xml -->
  <xsl:param name="TOC_XML_FILEPATH" select="'in/toc.xml'"/>
  
  <xsl:variable name="toc" select="document(oxygen:makeURL($TOC_XML_FILEPATH))/toc:toc"/>
  
  <!-- 
    The URL of the Webhelp template. 
    It is used to define which components will be displayed in Webhelp and also it defines the Webhelp layout. 
  -->
  <xsl:param name="WEBHELP_TEMPLATE_URL"/>
  
  <xsl:variable name="WEBHELP_IS_RESPONSIVE" select="true()"/>
  
  <!-- File path of image with the company logo. -->
  <xsl:param name="WEBHELP_LOGO_IMAGE" select="''"/>
  
  <!-- URL that will be opened when the logo image set with 
         the webhelp.logo.image parameter is clicked in the Webhelp page. -->
  <xsl:param name="WEBHELP_LOGO_IMAGE_TARGET_URL" select="''"/>
  
  <xsl:param name="WEBHELP_DEBUG_DITA_OT_OUTPUT" select="'no'"/>
  
  <xsl:param name="WEBHELP_DITAMAP_URL"/>
  
  
  <xsl:param name="WEBHELP_PARAMETERS_URL" />
  
  <!-- Namespace in which to output TOC links -->
  <xsl:param name="namespace" select="'http://www.w3.org/1999/xhtml'"/>
  
  <!-- Normal Webhelp transformation, filtered. -->
  <xsl:template match="/">
    
    <xsl:variable name="topicContent">
      <xsl:apply-imports/>
    </xsl:variable>    
    
    <xsl:choose>
      <xsl:when test="$WEBHELP_DEBUG">
        <!-- This generates Invalid HTML, but is OK for debugging. -->
        <html>
          <xsl:apply-templates select="$topicContent" mode="fixup_desktop"/>                 
          <hr/>
          <h1>Original content:</h1>
          <xsl:copy-of select="$topicContent"/>                
        </html>
      </xsl:when>
      <xsl:otherwise>
        <!-- Make small fixes over the DITA-OT HTML content -->
        <xsl:variable name="topicContent">
          <xsl:apply-templates select="$topicContent" mode="fixup_desktop"/>        
        </xsl:variable>
        
        <!-- Make sure that every node from document has HTML namespace-->
        <xsl:variable name="topicContent">
          <xsl:apply-templates select="$topicContent" mode="fixup_XHTML_NS"/>
        </xsl:variable>
        
        <!-- Write to a separate file the content emited by DITA-OT -->
        <xsl:if test="$WEBHELP_DEBUG_DITA_OT_OUTPUT = 'yes'">
          <xsl:variable name="fileName" select="substring-before($FILENAME, '.')"/>
          <xsl:variable name="dita_ot_res" select="concat($OUTPUTDIR, '/', $FILEDIR, '/', $fileName, '_dita.html')"/>
          <xsl:variable name="dita_ot_res_url" select="relpath:toUrl($dita_ot_res)"/>
          <xsl:result-document href="{$dita_ot_res_url}">
            <xsl:copy-of select="$topicContent"/>
          </xsl:result-document>
        </xsl:if>
        
        <!-- Apply the current selected template -->
        <xsl:variable name="wh_template_doc" select="doc($WEBHELP_TEMPLATE_URL)"/>        
        <xsl:apply-templates select="$wh_template_doc" mode="copy_template">
          <xsl:with-param name="ditaot_topicContent" select="$topicContent" tunnel="yes"/>
          <!-- EXM-36737 - Context node used for messages localization -->
          <xsl:with-param name="initial_context_node" select="/*" tunnel="yes" as="element()"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
</xsl:stylesheet>