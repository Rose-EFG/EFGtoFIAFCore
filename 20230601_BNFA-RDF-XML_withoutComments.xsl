<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:efg="http://www.europeanfilmgateway.eu/efg"
    xmlns:fiaf="https://fiafcore.org/ontology/"
    exclude-result-prefixes="xs xd efg oai"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 1, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> Kristina Rose</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
    
    <xsl:variable name="map0"><!-- This could need a better solution, because this mapping would become very long for all the ISO codes -->
        <map value="https://fiafcore.org/ontology/Bulgaria">BG</map>       
    </xsl:variable>
    
    <xsl:variable name="map1"><!-- This is the map for language usage -->
        <map value="fiaf:DialogueLanguages">Audio</map>
        <map value="fiaf:Subtitles">Subtitles</map>
        <map value="fiaf:Intertitles">Intertitles</map>
    </xsl:variable>
    
    <xsl:variable name="map2"><!-- This is the map for activities; only subset of most common activities covered; to be extended to map all EFG activities --><!-- Director, Director of photography, Actor -->
        <map value="fiaf:Director">Director</map>
        <map value="fiaf:Cinematographer">Director of photography</map>
        <map value="fiaf:CastMember">Actor</map>
        <map value="fiaf:CameraOperator">Camera operator</map>
        <map value="fiaf:CostumeDesigner">Costume designer</map>
        <map value="fiaf:Distributor">Distributor</map>
        <map value="fiaf:FilmEditor">Editor</map>
        <map value="fiaf:MusicActivity">Music</map>
        <map value="fiaf:Narrator">Narrator</map>
        <map value="fiaf:Producer">Producer</map>
        <map value="fiaf:ProductionAssistant">Production assistant</map>
        <map value="fiaf:ProductionCompany">Production company</map>
        <map value="fiaf:ProductionDesigner">Production designer</map>
        <map value="fiaf:ScreenStory">Screenplay</map><!-- is that correct? -->
        <map value="fiaf:SetDesigner">Set designer</map>
        <map value="fiaf:SoundActivity">Sound</map>
        <map value="fiaf:SpecialEffects">Special effects</map>   
    </xsl:variable>
    
    <xsl:variable name="map3"><!-- This is the map for colour specifications -->
        <map value="https://fiafcore.org/ontology/BlackAndWhite">Black &amp; White</map>
        <map value="https://fiafcore.org/ontology/Colour">Colour</map>
        <map value="https://fiafcore.org/ontology/ColourBlackAndWhite">B/W &amp; Colour</map>
        <map value="https://fiafcore.org/ontology/Colour">Tinted / Toned / Hand coloured</map>
        <map value="https://fiafcore.org/ontology/ColourBlackAndWhite">Colour &amp; B/W </map>
    </xsl:variable>
    
    <xsl:variable name="map4"><!-- This is the map for title subclasses -->
        <map value="fiaf:PreferredTitle">Original title</map>
        <map value="fiaf:AlternativeTitle">Other title</map>
        <map value="fiaf:SeriesTitle">Series title</map>
        <map value="fiaf:SeriesTitle">Serial title</map>
        <map value="fiaf:PreferredTitle">Episode title</map><!-- ? -->
        <map value="fiaf:AlternativeTitle">TV title</map><!-- ? -->
        <map value="fiaf:AlternativeTitle">Version title</map><!-- ? -->
        <map value="fiaf:TranslatedTitle">Translated title</map>
        <map value="fiaf:WorkingTitle">Working title</map>
        <map value="fiaf:Intertitles">Segment title</map><!-- ? -->
        <map value="fiaf:AlternativeTitle">Spelling variation</map><!-- ? -->
        <map value="fiaf:SuppliedDevisedTitle">Archive title</map><!-- ? -->
        <map value="fiaf:Title">Subtitle</map><!-- ? -->
        <map value="fiaf:AlternativeTitle">Distribution title</map><!-- ? -->
        <map value="fiaf:Title">Tagline</map><!-- ? -->
        <map value="fiaf:Title">Compilation title</map><!-- ? -->
        <map value="fiaf:Title">n/a</map>       
    </xsl:variable>
    
    
    <xsl:template match="/">
        <rdf:RDF>
<!--            <xsl:call-template name="Works"/>-->
            <xsl:apply-templates select="//efg:efgEntity/efg:avcreation"/>
        </rdf:RDF>
    </xsl:template>
    
    
<!--    <xsl:template name="Works">-->
    <xsl:template match="//efg:efgEntity/efg:avcreation">
        <fiaf:WorkVariant>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="concat('http://example.org/EFG/',efg:identifier)"/>
            </xsl:attribute>
            <rdfs:label>
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="efg:title[1]/@lang"/>
                </xsl:attribute>
                <xsl:value-of select="efg:title[1]/efg:text"/>
            </rdfs:label>
            
            <!-- hasIdentifier -->
            <fiaf:hasIdentifier>
                <fiaf:Identifier>
                    <fiaf:hasIdentifierValue>
                        <xsl:value-of select="efg:recordSource/efg:sourceID"/>
                    </fiaf:hasIdentifierValue>
                </fiaf:Identifier>
            </fiaf:hasIdentifier> 
            
            <!-- hasTitle -->
            <xsl:for-each select="efg:title">
                <fiaf:hasTitle>
                    <xsl:variable name="idx4" select="index-of($map4/map, replace(./efg:relation,'^\s*(.+?)\s*$', '$1'))"/>
                    <xsl:variable name="TitleClass" select="$map4/map[$idx4]/@value"/>
                    <xsl:element name="{$TitleClass}">
                        <fiaf:hasTitleValue>
                            <xsl:attribute name="xml:lang"><xsl:value-of select="lower-case(./@lang)"/></xsl:attribute>
                            <xsl:value-of select="efg:text"/>
                        </fiaf:hasTitleValue>
                    </xsl:element>
                </fiaf:hasTitle>
            </xsl:for-each>
            

            <!-- This is the mapping that produces dummy URLs for countries from ISO codes -->
            <xsl:for-each select="efg:countryOfReference">
                <fiaf:hasCountry>                   
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="concat('http://example.org/EFG/country/',.)"/>
                    </xsl:attribute>
                </fiaf:hasCountry>                    
            </xsl:for-each>
            
            <!-- hasForm -->
            <xsl:for-each select="efg:keywords[@type='Form']">
                <fiaf:hasForm>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="concat('http://example.org/EFG/form/',replace(./efg:term,' ',''))"/>
                    </xsl:attribute>
                </fiaf:hasForm>
            </xsl:for-each>
            
            <!-- hasEvent -> Production Event -> has Activity -> hasAgent -->
            <xsl:if test="efg:productionYear|efg:relPerson">
                <fiaf:hasEvent>
                    <fiaf:ProductionEvent>
                        <xsl:for-each select="efg:productionYear">
                            <fiaf:hasEventDate>
                                <xsl:value-of select="."/>
                            </fiaf:hasEventDate>
                        </xsl:for-each>
                        <xsl:for-each select="efg:relPerson|efg:relCorporate"><!-- Much shorter way of mapping all the EFG activity types to their respective fiafcore class -->
                            <fiaf:hasActivity>
                                <xsl:variable name="idx2" select="index-of($map2/map, replace(./efg:type,'^\s*(.+?)\s*$', '$1'))"/>
                                <xsl:variable name="Activity" select="$map2/map[$idx2]/@value"/>
                                <xsl:element name="{$Activity}">
                                    <fiaf:hasAgent>
                                        <xsl:attribute name="rdf:resource">
                                            <xsl:value-of select="concat('http://example.org/EFG/',./efg:identifier)"/>
                                        </xsl:attribute>
                                    </fiaf:hasAgent>
                                </xsl:element>                               
                            </fiaf:hasActivity>
                        </xsl:for-each>
                    </fiaf:ProductionEvent>
                </fiaf:hasEvent>
            </xsl:if>
            
            <!-- hasManifestation -->
            <xsl:for-each select="efg:avManifestation">
                <fiaf:hasManifestation>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="concat('http://example.org/EFG/',./efg:identifier)"/>
                    </xsl:attribute>
                </fiaf:hasManifestation>
            </xsl:for-each>
            
        </fiaf:WorkVariant>       
        
        <!-- Agents -->
        <xsl:for-each select="efg:relPerson"><!-- This mapping will produce duplicate Agents and Corporate Bodies. Check if there's a way to tranform each Agent linked in multiple Works or in multiple instance in one work only once.-->
            <fiaf:Person>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="concat('http://example.org/EFG/',./efg:identifier)"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:value-of select="./efg:name"/>
                </rdfs:label>
            </fiaf:Person>
        </xsl:for-each>
        
        <xsl:for-each select="efg:relCorporate">
            <fiaf:CorporateBody>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="concat('http://example.org/EFG/',./efg:identifier)"/>
                </xsl:attribute>
                <rdfs:label>
                    <xsl:value-of select="./efg:name"/>
                </rdfs:label>
            </fiaf:CorporateBody>
        </xsl:for-each>
        
        <!-- Manifestation -->
        <xsl:for-each select="efg:avManifestation">
            <fiaf:Manifestation>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="concat('http://example.org/EFG/',./efg:identifier)"/>
                </xsl:attribute>

        
                <!-- hasIdentifier -->
                <fiaf:hasIdentifier>
                    <fiaf:Identifier>
                        <fiaf:hasIdentifierValue>
                            <xsl:value-of select="efg:recordSource/efg:sourceID"/>
                        </fiaf:hasIdentifierValue>
                    </fiaf:Identifier>
                </fiaf:hasIdentifier> 
                
                <!-- hasTitle -->
                <xsl:for-each select="efg:title">
                    <fiaf:hasTitle>
                        <xsl:variable name="idx4" select="index-of($map4/map, replace(./efg:relation,'^\s*(.+?)\s*$', '$1'))"/>
                        <xsl:variable name="TitleClass" select="$map4/map[$idx4]/@value"/>
                        <xsl:element name="{$TitleClass}">
                            <fiaf:hasTitleValue>
                                <xsl:attribute name="xml:lang"><xsl:value-of select="lower-case(./@lang)"/></xsl:attribute>
                                <xsl:value-of select="efg:text"/>
                            </fiaf:hasTitleValue>
                        </xsl:element>
                    </fiaf:hasTitle>
                </xsl:for-each>
                
                <!-- hasSoundCharacteristics -->
                <xsl:if test="efg:format/efg:sound">
                    <fiaf:hasSoundCharacteristic>
                        <xsl:if test="efg:format/efg:sound/@hasSound='true'">
                            <xsl:attribute name="rdf:resource">
                                <xsl:text>https://fiafcore.org/ontology/Sound</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="efg:format/efg:sound/@hasSound='false'">
                            <xsl:attribute name="rdf:resource">
                                <xsl:text>https://fiafcore.org/ontology/Silent</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </fiaf:hasSoundCharacteristic>
                </xsl:if>
                    
                <!-- hasColourCharacteristics -->
                <xsl:for-each select="efg:format/efg:colour">
                    <xsl:if test="not(.='n/a')">
                    <fiaf:hasColourCharacteristic>
                        <xsl:variable name="idx3" select="index-of($map3/map, replace(.,'^\s*(.+?)\s*$', '$1'))"/><!-- shorter way of mapping -->
                        <xsl:variable name="Colour" select="$map3/map[$idx3]/@value"/>
                        <xsl:attribute name="rdf:resource">
                            <xsl:value-of select="$Colour"/>
                        </xsl:attribute>
                    </fiaf:hasColourCharacteristic>
                    </xsl:if>
                </xsl:for-each>
                <!-- hasFormat -->
                <xsl:if test="efg:format/efg:gauge">
                    <fiaf:hasFormat>                       
                            <xsl:attribute name="rdf:resource">
                                <xsl:value-of select="concat('https://fiafcore.org/ontology/',replace(efg:format/efg:gauge,' ',''),'Film')"/>
                            </xsl:attribute>                   
                    </fiaf:hasFormat>
                </xsl:if>
                
                <!-- hasExtent -->               
                <xsl:if test="efg:duration">
                    <fiaf:hasExtent>                       
                        <fiaf:Minutes>
                            <fiaf:hasExtentValue>
                                <xsl:value-of select="efg:duration"/>
                            </fiaf:hasExtentValue>
                        </fiaf:Minutes>                  
                    </fiaf:hasExtent>
                </xsl:if>
                
                <xsl:if test="efg:dimesion/@unit='m'">
                    <fiaf:hasExtent>
                        <fiaf:Metres>
                            <xsl:value-of select="efg:dimesion"/>
                        </fiaf:Metres>
                    </fiaf:hasExtent>
                </xsl:if>
                
                <!-- hasLanguageUsage -->
                <xsl:for-each select="efg:language">
                    <fiaf:hasLanguageUsage>
                        <xsl:variable name="idx1" select="index-of($map1/map, replace(./@usage,'^\s*(.+?)\s*$', '$1'))"/>
                        <xsl:variable name="LanguageUsage" select="$map1/map[$idx1]/@value"/>
                        <xsl:element name="{$LanguageUsage}">
                            <fiaf:hasLanguage>
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of select="concat('http://example.org/EFG/language/',.)"/>
                                </xsl:attribute>
                            </fiaf:hasLanguage>
                        </xsl:element>
                    </fiaf:hasLanguageUsage>
                </xsl:for-each>
                    
                <!-- hasItem -->
                <xsl:for-each select="efg:item">
                    <fiaf:hasItem>
                        <xsl:attribute name="rdf:resource">
                            <xsl:value-of select="concat('http://example.org/EFG/',./efg:identifier)"/>
                        </xsl:attribute>
                    </fiaf:hasItem>
                </xsl:for-each>

            </fiaf:Manifestation>            
        </xsl:for-each>       
        
        <!-- Item -->
        <xsl:for-each select="//efg:item"><!-- in EFG, the Item entity contains the links to the video files (usually mp4 or Vimeo links) with the digitzed item. So there are no more properties to map, since these are not part of the FIAF Ontology. Additionally, these Items would all have the type "Video" regardless of the Format information given in the Manifestation.  -->
            <fiaf:Item>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="concat('http://example.org/EFG/',./efg:identifier)"/>
                </xsl:attribute>                
            </fiaf:Item>
        </xsl:for-each>
        
        </xsl:template>
    <!--</xsl:template>-->
    
</xsl:stylesheet>