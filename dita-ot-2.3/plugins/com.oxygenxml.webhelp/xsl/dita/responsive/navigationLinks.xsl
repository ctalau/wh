<?xml version="1.0" encoding="UTF-8"?>
<!--
    
    Oxygen Webhelp plugin
    Copyright (c) 1998-2016 Syncro Soft SRL, Romania.  All rights reserved.

-->

<!--
    This stylesheet is used to generate navigation links like: breadcrumb, sidetoc.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
    xmlns:oxygen="http://www.oxygenxml.com/functions"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg" version="2.0">

    <!--
        The extension of the output files.
    -->
    <xsl:param name="OUT_FILE_EXT">
        <xsl:variable 
            name="outExt" 
            select="oxygen:getParameter('args.outext')"/>
        <xsl:choose>
            <xsl:when test="string-length($outExt) > 0">
                <xsl:value-of select="if (starts-with($outExt, '.')) then $outExt else concat('.', $outExt) "/>
            </xsl:when>
            <xsl:otherwise>.html</xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    
    <!-- Extract the file name without extension -->
    <xsl:variable name="FILENAME_WITHOUT_EXT" select="oxygen:getFileName($FILENAME)"/>
    
    <!-- Compute the output file name -->
    <xsl:variable name="OUT_FILENAME" select="concat($FILENAME_WITHOUT_EXT, $OUT_FILE_EXT)"/>
    
    <!-- The path for the current file -->    
    <xsl:variable name="current-file"
        select="
            translate(
                if ($FILEDIR = '.') then
                    $OUT_FILENAME
                else
                    concat($FILEDIR, '/', $OUT_FILENAME), '\', '/')"/>

    <!-- All the 'topicref's for the current file -->
    <xsl:variable name="current-topicrefs"
        select="
            $toc//toc:topic[dita-ot:get-path($PATH2PROJ, .) = $current-file]"/>

    <!-- 
        Consider the first topicref as current 
    -->
    <xsl:variable name="current-topicref" select="$current-topicrefs[1]"/>

    <!-- 
        Template to generate side TOC 
    -->
    <xsl:template name="generateSideToc">
        <ul class="hidden-print">
            <xsl:apply-templates select="$current-topicref" mode="toc-pull">
                <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                <xsl:with-param name="children" as="element()*">
                    <xsl:apply-templates
                        select="$current-topicref/toc:topic"
                        mode="sideTocEntry">
                        <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                    </xsl:apply-templates>
                </xsl:with-param>
            </xsl:apply-templates>
        </ul>
    </xsl:template>

    <!-- 
        Stop recursion on 'map' 
    -->
    <xsl:template match="toc:toc" mode="toc-pull">
        <xsl:param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
        <xsl:param name="children" select="()" as="element()*"/>
        <xsl:param name="parent" select="parent::*" as="element()?"/>
        
        <xsl:copy-of select="$children"/>
    </xsl:template>

    <!--
        Propagate event to parent.
    -->
    <xsl:template match="*" mode="toc-pull" priority="-10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:param name="children" select="()" as="element()*"/>
        <xsl:param name="parent" select="parent::*" as="element()?"/>

        <xsl:apply-templates select="$parent" mode="toc-pull">
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            <xsl:with-param name="children" select="$children"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- 
        Process a 'topicref' 
    -->
    <xsl:template
        match="
        toc:topic
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]"
        mode="toc-pull" priority="10">

        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:param name="children" select="()" as="element()*"/>
        <xsl:param name="parent" select="parent::*" as="element()?"/>

        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>

        <xsl:variable name="topElement" select="count(ancestor::toc:topic) = 0"/>
        <xsl:apply-templates select="$parent" mode="toc-pull">
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            <xsl:with-param name="children" as="element()*">
                <!-- EXM-35236 - Do not generare siblings of the top level topic -->
                <xsl:if test="not($topElement)">
                    <!-- Previous siblings -->
                    <xsl:apply-templates
                        select="preceding-sibling::toc:topic"
                        mode="sideTocEntry">
                        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                    </xsl:apply-templates>
                </xsl:if>

                <!-- Current processed topicref -->
                <xsl:apply-templates select="." mode="sideTocEntry">
                    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                    <xsl:with-param name="children" select="$children"/>
                </xsl:apply-templates>
				
				<!-- EXM-35236 - Do not generare siblings of the top level topic -->
                <xsl:if test="not($topElement)">
                    <!-- Following siblings -->
                    <xsl:apply-templates
                        select="following-sibling::toc:topic"
                        mode="sideTocEntry">
                        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Templates in 'sideTocEntry' mode. They are used to generate entries for side TOC.
    -->
    <xsl:template match="*" mode="sideTocEntry" priority="-10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:apply-templates select="toc:topic" mode="sideTocEntry">
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Generate a TOC entry for each topicref. 
    -->
    <xsl:template
        match="
        toc:topic
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]"
        mode="sideTocEntry" 
        priority="10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:param name="children" select="()" as="element()*"/>

        <!-- Topic title -->
        <xsl:variable name="title" select="toc:title"/>

        <xsl:choose>
            <xsl:when test="normalize-space($title)">
                <li>
                    <xsl:variable name="isActive" select=". is $current-topicref"/>
                    <xsl:if test="$isActive">
                        <xsl:attribute name="class">active</xsl:attribute>
                    </xsl:if>

                    <span class="topicref">
                        <xsl:variable name="hrefAttr" as="attribute()">
                            <xsl:call-template name="computeHrefAttr"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="not($isActive) and normalize-space($hrefAttr)">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:if test="not(@scope = 'external')">
                                            <xsl:value-of select="$pathFromMaplist"/>
                                        </xsl:if>
                                        <xsl:choose>
                                            <xsl:when
                                                test="
                                                    @copy-to and not(contains(@chunk, 'to-content')) and
                                                    (not(@format) or @format = 'dita' or @format = 'ditamap')">
                                                <xsl:call-template name="replace-extension">
                                                  <xsl:with-param name="filename" select="@copy-to"/>
                                                  <xsl:with-param name="extension" select="$OUTEXT"/>
                                                </xsl:call-template>
                                                <xsl:if
                                                  test="not(contains(@copy-to, '#')) and contains($hrefAttr, '#')">
                                                  <xsl:value-of
                                                  select="concat('#', substring-after($hrefAttr, '#'))"
                                                  />
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:when
                                                test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                                                <xsl:call-template name="replace-extension">
                                                  <xsl:with-param name="filename" select="$hrefAttr"/>
                                                  <xsl:with-param name="extension" select="$OUTEXT"
                                                  />
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$hrefAttr"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:value-of select="$title"/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$title"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>

                    <xsl:if test="exists($children)">
                        <ul class="nav nav-list">
                            <xsl:copy-of select="$children"/>
                        </ul>
                    </xsl:if>
                </li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--
        Breadcrumb generation
    -->
    <xsl:template name="gen-user-breadcrumb">
        <xsl:param name="pathFromMaplist"/>
        <ol class="hidden-print">
            <!-- EXM-36063 - Link to home page -->
            <li>
                <span class="home">
                    <!-- Use a span inside the 'a' element, such that users can hide the text and add a background image. -->
                    <a href="{concat($PATH2PROJ, 'index.html')}"><span>Home</span></a>
                </span>
            </li>
            <xsl:apply-templates select="$current-topicrefs[1]" mode="breadcrumb-item-pull">
                <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
            </xsl:apply-templates>
        </ol>
    </xsl:template>
    
    <!-- Stop on map -->
    <xsl:template match="toc:toc" mode="breadcrumb-item-pull"/>

    <xsl:template match="*" mode="breadcrumb-item-pull" priority="-10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:apply-templates select="parent::*" mode="#current">
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template
            match="
            toc:topic
            [not(@toc = 'no')]
            [not(@processing-role = 'resource-only')]"
            mode="breadcrumb-item-pull" 
            priority="10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>

        <!-- Navigate to parent -->
        <xsl:apply-templates select="parent::*" mode="#current">
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>

        <!-- Generate a breadcrumb item for this -->
        <xsl:apply-templates select="." mode="sideTocEntry">
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:function name="dita-ot:get-path">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:param name="node" as="element()"/>
        <xsl:for-each select="$node[1]">
            <xsl:if test="not(@scope = 'external')">
                <xsl:call-template name="strip-leading-parent">
                    <xsl:with-param name="path" select="$pathFromMaplist"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:choose>
                <xsl:when
                    test="
                        @copy-to and not(contains(@chunk, 'to-content')) and
                        (not(@format) or @format = 'dita' or @format = 'ditamap')">
                    <xsl:value-of select="@copy-to"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="if (contains(@href, '#')) then substring-before(@href, '#') else @href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>

    <xsl:template name="strip-leading-parent">
        <xsl:param name="path" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="starts-with($path, '../')">
                <xsl:call-template name="strip-leading-parent">
                    <xsl:with-param name="path" select="substring($path, 4)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$path"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Compute the href attribute to be used when compute link to topic  -->
    <xsl:template name="computeHrefAttr">
        <xsl:choose>
            <xsl:when test="@href and @href ne 'javascript:void(0)'">
                <xsl:copy-of select="@href"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="toc:topic[1]/@href"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--
        Get the file name without extension.
    -->
    <xsl:function name="oxygen:getFileName">
        <xsl:param name="fileName"/>
        <xsl:variable name="tokens" select="tokenize($fileName, '\.')"/>
        
        <xsl:choose>
            <xsl:when test="count($tokens) = 0">
                <xsl:value-of select="$fileName"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="fn">
                    <xsl:for-each select="$tokens">
                        <xsl:if test="position() ne last()">
                            <xsl:value-of select="."/>
                            
                            <xsl:if test="position() ne (last() - 1)">
                                <xsl:value-of select="'.'"/>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:value-of select="$fn"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
