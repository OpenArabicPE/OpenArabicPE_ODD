<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
   <sch:title>OpenArabicPE: schematron rules for Arabic periodicals and supporting material</sch:title>
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:pattern>
        <sch:rule context="tei:death" role="warning">
            <sch:let name="v_date-death" value="@when"/>
            <sch:let name="v_date-birth" value="preceding-sibling::tei:birth/@when"/>
            <sch:assert test="if(string-length($v_date-death) = 10 and string-length($v_date-birth) = 10) then(xs:date($v_date-death) gt xs:date($v_date-birth)) else(number(substring($v_date-death,1,4)) gt number(substring($v_date-birth,1,4)))">A person born on or in <sch:value-of select="$v_date-birth"/> cannot have died on or in <sch:value-of select="$v_date-death"/>.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:death | tei:birth" role="warning">
            <sch:assert test="@when">This should be dated with a @when attribute.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="@when-custom" role="error">
            <sch:assert test="parent::node()/@datingMethod">The @when-custom attribute requires that @datingMethod is specified.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!--<sch:pattern>
        <sch:rule context="text()" role="warning">
            <sch:report test="matches(., '[&quot;'']')" role="warning">Text contains straight apostrophe or quotation mark</sch:report>
        </sch:rule>
    </sch:pattern>-->
    <sch:pattern>
        <sch:rule context="tei:p" role="error">
            <sch:assert test="string-length(.) gt 0">Abstract model violation: paragraphs cannot be empty</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- test if there is already a <person> with the same <persName> -->
    <sch:pattern>
        <sch:rule context="tei:person/tei:persName" role="warn">
            <sch:let name="v_id" value="@xml:id"/>
            <sch:let name="v_self" value="normalize-space(string())"/>
            <sch:report test="count(ancestor::tei:profileDesc/descendant::tei:persName[not(@type='flattened')][normalize-space(string()) = $v_self]) gt 1">The <sch:name/> <sch:value-of select="$v_self"/> already exists in this file.</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>
