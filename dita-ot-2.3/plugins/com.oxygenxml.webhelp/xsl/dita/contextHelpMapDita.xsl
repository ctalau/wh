<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
            xmlns:oxygen="http://www.oxygenxml.com/functions"
            exclude-result-prefixes="oxygen"
            version="2.0">
    
    <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
    <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
    
    <xsl:variable name="msgprefix">DOTX</xsl:variable>
    
  <!-- Extension of DITA output files for example .html -->
  <xsl:param name="OUT_EXT" select="'.html'"/>
  
  <!-- productID param in Webhelp-Feedback system. Used only in Webhelp-Feedback transform. -->  
  <xsl:param name="WEBHELP_PRODUCT_ID" select="''"/>
    
  <!-- version number param in Webhelp-Feedback system. Used only in Webhelp-Feedback transform. -->  
  <xsl:param name="WEBHELP_PRODUCT_VERSION" select="''"/>  

  <xsl:output method="xml" indent="yes"/>

  <xsl:key name="kTopicHrefs" 
              match="*[contains(@class, ' map/topicref ')]
                            [@href]
                            [not(@scope) or @scope = 'local']
                            [not(@processing-role) or @processing-role = 'normal']
                            [not(@format) or @format = 'dita' or @format = 'DITA']" 
              use="@href"/>
    
    <xsl:key name="kTopicIDs" 
                match="*[contains(@class, ' map/topicref ')]
                            [@href]
                            [not(@scope) or @scope = 'local']
                            [not(@processing-role) or @processing-role = 'normal']
                            [not(@format) or @format = 'dita' or @format = 'DITA']" 
                use="*[contains(@class, ' map/topicmeta ')]/@resourceid"/>
    
    
  <xsl:template match="/">
      <map>
          <xsl:if test="string-length($WEBHELP_PRODUCT_ID) > 0">
              <xsl:attribute name="productID">
                  <xsl:value-of select="$WEBHELP_PRODUCT_ID"/>
              </xsl:attribute>
          </xsl:if>
          <xsl:if test="string-length($WEBHELP_PRODUCT_VERSION) > 0">
              <xsl:attribute name="productVersion">
                  <xsl:value-of select="$WEBHELP_PRODUCT_VERSION"/>
              </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
      </map>
  </xsl:template>
    

    <xsl:template match="*[contains(@class, ' map/topicref ')]">
        <xsl:if test="@href and (not(@scope) or @scope = 'local')
                  and (not(@processing-role) or @processing-role = 'normal')
                  and (not(@format) or @format = 'dita' or @format = 'DITA')">
          <xsl:if test="generate-id(key('kTopicHrefs', @href)[1]) = generate-id()">
              <xsl:variable name="resourceid" select="*[contains(@class, ' map/topicmeta ')]/@resourceid"/>
              <xsl:if test="string-length($resourceid) > 0">
                  <xsl:variable name="topicref" select="."/>
                  <xsl:for-each select="tokenize($resourceid, ' ')">
                      <appContext>
                          <xsl:attribute name="helpID" select="."/>
                          <xsl:attribute name="path">
                              <xsl:call-template name="replace-extension">
                                  <xsl:with-param name="filename" select="$topicref/@href"/>
                                  <xsl:with-param name="extension" select="$OUT_EXT"/>
                              </xsl:call-template>
                          </xsl:attribute>
                      </appContext>
                  </xsl:for-each>
                  <xsl:if test="count(distinct-values(key('kTopicIDs', $resourceid)/@href)) > 1 
                                and generate-id(key('kTopicIDs', $resourceid)[1]) = generate-id()">
                      <xsl:message>Warning: duplicate resource ID: "<xsl:value-of select="$resourceid"/>" used in topic files:</xsl:message>
                      <xsl:for-each select="key('kTopicIDs', $resourceid)">
                        <xsl:message>    <xsl:value-of select="@href"/></xsl:message>
                    </xsl:for-each>
                  </xsl:if>
              </xsl:if>
          </xsl:if>
      </xsl:if>
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()"/>
</xsl:stylesheet>