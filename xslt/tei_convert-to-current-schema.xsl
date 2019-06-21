<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- this stylesheet updates to OpenArabicPE TEI files to the most recent version of the schema -->
    
    <!-- identify the author of the change by means of a @xml:id -->
    <!-- toggle debugging messages -->
    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>
    
    <!-- identity transformation -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- fix position of <idno> in <biblStruct>: should come directly after <title> in <monogr>  -->
    <xsl:template match="tei:monogr[parent::tei:biblStruct/tei:idno]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <!-- document changes -->
                    <xsl:choose>
                        <xsl:when test="not(@change)">
                            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="m_documentation" select="@change"/>
                        </xsl:otherwise>
                    </xsl:choose>
            <xsl:apply-templates select="tei:title"/>
            <!-- move now faulty idnos from the parent biblStruct -->
            <xsl:apply-templates select="parent::tei:biblStruct/tei:idno" mode="m_documentation"/>
            <xsl:apply-templates select="tei:idno"/>
            <xsl:apply-templates select="tei:author"/>
            <xsl:apply-templates select="tei:editor"/>
            <xsl:apply-templates select="tei:imprint"/>
            <xsl:apply-templates select="tei:biblScope"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:biblStruct/tei:idno"/>
    <xsl:template match="tei:biblStruct[tei:idno]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <!-- fix @xml:id for biblStruct in sourceDesc -->
            <xsl:if test="parent::tei:sourceDesc">
                <xsl:attribute name="xml:id" select="concat('edition_',count(preceding-sibling::tei:biblStruct) +1)"/>
            </xsl:if>
            <!-- document changes -->
                    <xsl:choose>
                        <xsl:when test="not(@change)">
                            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="m_documentation" select="@change"/>
                        </xsl:otherwise>
                    </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- map div types -->
    <xsl:template match="tei:div[@type = ('article', 'bill', 'masthead', 'letter', 'advert')]">
        <xsl:copy>
            <!-- replicate attributes  -->
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type" select="'item'"/>
            <!-- there might be a better way of classifying the genre of a div -->
            <xsl:attribute name="subtype" select="@type"/>
            <!-- document changes -->
                    <xsl:choose>
                        <xsl:when test="not(@change)">
                            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="m_documentation" select="@change"/>
                        </xsl:otherwise>
                    </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:div[@type= 'item'][not(@subtype)]">
        <xsl:copy>
            <!-- replicate attributes  -->
            <xsl:apply-templates select="@*"/>
            <!-- there might be a better way of classifying the genre of a div -->
            <xsl:attribute name="subtype" select="'article'"/>
            <!-- document changes -->
                    <xsl:choose>
                        <xsl:when test="not(@change)">
                            <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates mode="m_documentation" select="@change"/>
                        </xsl:otherwise>
                    </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- map personal names -->
    <xsl:template match="tei:addName[@type='title']">
        <xsl:element name="tei:roleName">
            <!-- replicate attributes  -->
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type" select="'title'"/>
            <!-- document changes -->
            <xsl:choose>
                <xsl:when test="not(@change)">
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="m_documentation" select="@change"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:addName[@type='honorific']">
        <xsl:element name="tei:roleName">
            <!-- replicate attributes  -->
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type" select="'honorific'"/>
            <!-- document changes -->
            <xsl:choose>
                <xsl:when test="not(@change)">
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="m_documentation" select="@change"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:addName[@type='rank']">
        <xsl:element name="tei:roleName">
            <!-- replicate attributes  -->
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="type" select="'rank'"/>
            <!-- document changes -->
            <xsl:choose>
                <xsl:when test="not(@change)">
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="m_documentation" select="@change"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    <!-- notes -->
    <xsl:template match="tei:note[not(@type = ('bibliographic', 'editorial'))]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="@type = 'footnote'">
                <xsl:attribute name="place" select="'bottom'"/>
            </xsl:if>
            <xsl:if test="@type = 'endnote'">
                <xsl:attribute name="place" select="'end'"/>
            </xsl:if>
            <xsl:if test="@type = 'gloss'">
                <xsl:attribute name="place" select="'margin'"/>
            </xsl:if>
            <xsl:if test="@type = 'inline'">
                <xsl:attribute name="place" select="'inline'"/>
                <!-- check if there is a <bibl>  child -->
                <xsl:if test="tei:bibl">
                    <xsl:attribute name="type" select="'bibliographic'"/>
                </xsl:if>
            </xsl:if>
            <!-- document changes -->
            <xsl:choose>
                <xsl:when test="not(@change)">
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="m_documentation" select="@change"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:note[@type =('inline','footnote', 'endnote', 'gloss')]/@type"/>
    <!-- default attributes on pb and lb and @xml:id of sourceDesc/biblStruct-->
    <xsl:template match="tei:lb | tei:pb[@ed='print']">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="not(@ed)">
                <xsl:attribute name="ed" select="'print'"/>
            </xsl:if>
            <xsl:if test="not(@edRef)">
                <xsl:attribute name="edRef" select="'#edition_1'"/>
            </xsl:if>
            <!-- document changes -->
            <xsl:if test="not(@ed) or not(@edRef)">    
            <xsl:choose>
                <xsl:when test="not(@change)">
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="m_documentation" select="@change"/>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
    
    <!-- document the changes -->
    <xsl:template match="tei:revisionDesc" name="t_8">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#',$p_id-editor)"/>
                <xsl:attribute name="xml:id" select="$p_id-change"/>
                <xsl:attribute name="xml:lang" select="'en'"/>
                <xsl:text>Mapped elements from version 1 of the ODD to version 2</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- document changes on changed elements by means of the @change attribute linking to the @xml:id of the <tei:change> element -->
    <xsl:template match="@change" mode="m_documentation">
        <xsl:attribute name="change" select="concat(., ' #', $p_id-change)"/>
    </xsl:template>
    <xsl:template match="node()" mode="m_documentation">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="not(@change)">
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="m_documentation" select="@change"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>