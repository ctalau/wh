<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
  xmlns:index="http://www.oxygenxml.com/ns/webhelp/index" 
  xmlns:File="java:java.io.File"
  xmlns:oxygen="http://www.oxygenxml.com/functions" xmlns:d="http://docbook.org/ns/docbook"
  xmlns:whc="http://www.oxygenxml.com/webhelp/components" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

  <!-- Localization of text strings displayed in Webhelp output. -->
  <xsl:import href="../original/relpath_util.xsl"/>
  <xsl:import href="../dita_common.xsl"/>
  <xsl:import href="../createMainFiles.xsl"/>
  <xsl:import href="../desktop/fixupNS.xsl"/>

  <!-- Used to expand Webhelp components -->
  <xsl:import href="commonComponentsExpander.xsl"/>
  <xsl:import href="mainPageComponentsExpander.xsl"/>

  <!-- The folder with the XHTML files -->
  <xsl:param name="XHTML_FOLDER"/>

  <!-- Folder with output files. -->
  <xsl:param name="OUTPUTDIR"/>

  <!-- Base folder of Webhelp module. -->
  <xsl:param name="BASEDIR"/>

  <!-- Default file extension for HTML output files. -->
  <xsl:param name="OUTEXT" select="'.html'"/>

  <!-- Language for localization of strings in output page. -->
  <xsl:param name="DEFAULTLANG">en-us</xsl:param>

  <!-- Copyright notice inserted by user that runs transform. -->
  <xsl:param name="WEBHELP_COPYRIGHT"/>

  <!-- Name of product displayed in title of email notification sent to users. -->
  <xsl:param name="WEBHELP_PRODUCT_NAME"/>

  <!-- The URL for the search template. -->
  <xsl:param name="WEBHELP_SEARCH_TEMPLATE_URL"/>

  <!-- The URL for the main page template. -->
  <xsl:param name="WEBHELP_INDEX_HTML_URL"/>

  <!-- The URL for the Index page template. -->
  <xsl:param name="WEBHELP_INDEXTERMS_TEMPLATE_URL"/>

  <!-- 
     If this parameter is set to 'false' then the relevance stars are not 
     added anymore for the search results displayed on the Search tab.
     By default this parameter is set to true.
   -->
  <xsl:param name="WEBHELP_SEARCH_RANKING" select="'true'"/>

  <!-- Parameter used for computing the relative path of the topic. 
  	  In case of docbook, this should be empty. -->
  <xsl:param name="PATH2PROJ" select="''"/>

  <!-- The path of toc.xml -->
  <xsl:param name="TOC_XML_FILEPATH" select="'in/toc.xml'"/>

  <!-- Custom CSS set in DITA-OT params for custom CSS. -->
  <xsl:param name="CSS" select="''"/>
  <xsl:param name="CSSPATH" select="''"/>

  <!-- CSS that is set as Webhelp skin in the DITA Webhelp transform. -->
  <xsl:param name="WEBHELP_SKIN_CSS" select="''"/>

  <!-- File path of image used as favicon -->
  <xsl:param name="WEBHELP_FAVICON" select="''"/>

  <!-- Custom JavaScript code set by param webhelp.head.script -->
  <xsl:param name="WEBHELP_HEAD_SCRIPT" select="''"/>

  <!-- Google Custom Search code set by param webhelp.search.script -->
  <xsl:param name="WEBHELP_SEARCH_SCRIPT" select="''"/>

  <!-- Google Custom Search code set by param webhelp.search.results -->
  <xsl:param name="WEBHELP_SEARCH_RESULT" select="''"/>

  <!-- Custom JavaScript code set by param webhelp.body.script -->
  <xsl:param name="WEBHELP_BODY_SCRIPT" select="''"/>

  <!-- Oxygen version that created the WebHelp pages. -->
  <xsl:param name="WEBHELP_VERSION"/>

  <!-- Oxygen build number that created the WebHelp pages. -->
  <xsl:param name="WEBHELP_BUILD_NUMBER"/>

  <!-- File path of image with the company logo. -->
  <xsl:param name="WEBHELP_LOGO_IMAGE" select="''"/>

  <!-- URL that will be opened when the logo image set with 
         the webhelp.logo.image parameter is clicked in the Webhelp page. -->
  <xsl:param name="WEBHELP_LOGO_IMAGE_TARGET_URL" select="''"/>

  <xsl:param name="WEBHELP_DEBUG_DITA_OT_OUTPUT" select="'no'"/>

  <xsl:param name="WEBHELP_DITAMAP_URL"/>

  <xsl:param name="WEBHELP_FOOTER_INCLUDE" select="'yes'"/>
  <xsl:param name="WEBHELP_FOOTER_FILE" select="''"/>
  <xsl:param name="WEBHELP_TRIAL_LICENSE" select="'no'"/>

  <xsl:param name="WEBHELP_PARAMETERS_URL"/>

  <!-- Namespace in which to output TOC links -->
  <xsl:param name="namespace" select="'http://www.w3.org/1999/xhtml'"/>
  
  <xsl:output 
    name="wh-output"
    method="xhtml" 
    encoding="UTF-8"
    indent="no"
    doctype-public=""
    doctype-system="about:legacy-compat"
    omit-xml-declaration="yes"/>
  
  <!--<xsl:variable name="toc" select="document(oxygen:makeURL($TOC_XML_FILEPATH))/toc:toc"/>-->

  <xsl:template match="/">
    <!-- EXM-36308 - Generate the lang attributes in a temporary element -->
    <xsl:variable name="html_temp">
      <html_temp>
        <xsl:call-template name="setTopicLanguage">
          <xsl:with-param name="withFrames" select="false()"/>
        </xsl:call-template>
      </html_temp>
    </xsl:variable>
    
    <xsl:call-template name="create-localization-files"/>
    <xsl:call-template name="generate-search-file">
      <xsl:with-param name="html_temp" select="$html_temp"/>
    </xsl:call-template>
    <xsl:call-template name="generate-index-file">
      <xsl:with-param name="html_temp" select="$html_temp"/>
    </xsl:call-template>
    <xsl:call-template name="generate-main-file">
      <xsl:with-param name="html_temp" select="$html_temp"/>
    </xsl:call-template>
  </xsl:template>


  <!-- 
    Creates the Search file using the given template.
  -->
  <xsl:template name="generate-search-file">
    <xsl:param name="html_temp" as="item()*"/>
    <!-- Apply the current selected template -->
    <xsl:variable name="wh_search_template" select="doc($WEBHELP_SEARCH_TEMPLATE_URL)"/>

    <xsl:variable name="output_search_URL"
      select="concat(File:toURI(File:new(string($OUTPUTDIR))), 'search.html')"/>

    <xsl:result-document href="{$output_search_URL}" format="wh-output">
      <xsl:apply-templates select="$wh_search_template" mode="copy_template">
        <xsl:with-param name="html_temp" select="$html_temp" tunnel="yes" as="item()*"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template>

  <!-- 
    Creates the Index file using the given template.
  -->
  <xsl:template name="generate-index-file">
    <xsl:param name="html_temp" as="item()*"/>
    <!-- Apply the current selected template -->
    <xsl:variable name="wh_index_terms_template" select="doc($WEBHELP_INDEXTERMS_TEMPLATE_URL)"/>

    <xsl:variable name="output_index_terms_URL"
      select="concat(File:toURI(File:new(string($OUTPUTDIR))), 'indexTerms.html')"/>

    <xsl:result-document href="{$output_index_terms_URL}" format="wh-output">
      <xsl:apply-templates select="$wh_index_terms_template" mode="copy_template">
        <xsl:with-param name="html_temp" select="$html_temp" tunnel="yes" as="item()*"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template>

  <!-- 
    Generate the index terms grouped by the first letter.
  -->
  <xsl:template match="index:index" mode="create-index">
    
    <xsl:for-each-group select="index:term" group-by="upper-case(substring(@name, 1, 1))">
      <xsl:sort select="current-grouping-key()"/>
      <!-- Output the first letter -->
      <li class="wh_term_group">
        <span class="wh_first_letter"><xsl:value-of select="current-grouping-key()"/></span>
        <ul>
          <!-- Iterates over the current group and output its items -->
          <xsl:apply-templates select="current-group()" mode="#current">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </ul>
      </li>
      
    </xsl:for-each-group>
  </xsl:template>

  <!-- 
    Generates a list item for each index term.
  -->  
  <xsl:template match="index:term" mode="create-index">
    <li class="wh_term">
      <span><xsl:value-of select="@name"/></span>
      <!-- Generate links for each target -->
      <xsl:for-each select="index:target">
        <a class="wh_term_target" href="{.}">[<xsl:value-of select="position()"/>]</a>
      </xsl:for-each>
      
      <!-- Handle nested index terms -->
      <xsl:if test="count(index:term) > 0">      
        <ul>
          <xsl:apply-templates mode="#current" select="index:term">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <!--
    Template used to generate indexterms
  -->
  <xsl:template match="whc:webhelp_index_terms" mode="copy_template">
    <div>
      <xsl:call-template name="generateComponentClassAttribute">
        <xsl:with-param name="compClass">wh_index_terms</xsl:with-param>
      </xsl:call-template>
      <xsl:copy-of select="@* except @class"/>
      <xsl:if test="count($index/*) > 0">
        <xsl:variable name="compContent">
          <div id="iList">
            <xsl:variable name="indexterms">
              
              <ul id="indexList">
                <xsl:apply-templates select="$index" mode="create-index"/>
              </ul>
            </xsl:variable>
            <!--<xsl:copy-of select="$indexterms"/>-->
            <xsl:apply-templates select="$indexterms" mode="fixup_XHTML_NS"/>
          </div>
        </xsl:variable>
        
        <xsl:call-template name="outputComponentContent">
          <xsl:with-param name="compContent" select="$compContent"/>
          <xsl:with-param name="compName" select="local-name()"/>
        </xsl:call-template>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- 
    Creates the index.html 
  -->
  <xsl:template name="generate-main-file">
    <xsl:param name="html_temp" as="item()*"/>
    <!-- Apply the current selected template -->
    <xsl:variable name="wh_main_page_template" select="doc($WEBHELP_INDEX_HTML_URL)"/>    
    <xsl:variable name="output_main_page_URL"
      select="concat(File:toURI(File:new(string($OUTPUTDIR))), 'index.html')"/>  
      
    <xsl:result-document href="{$output_main_page_URL}" format="wh-output">
      
      <xsl:variable name="mainPageTemplate">
        <xsl:apply-templates select="$wh_main_page_template" mode="fixup_XHTML_NS"/>
      </xsl:variable>
      
      <xsl:apply-templates select="$mainPageTemplate" mode="copy_template">
        <xsl:with-param name="html_temp" select="$html_temp" tunnel="yes" as="item()*"/>
        <!-- EXM-36737 - Context node used for messages localization -->
        <xsl:with-param name="initial_context_node" select="/*" tunnel="yes" as="element()"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>
