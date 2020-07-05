<?xml version="1.0"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:pnr="http://xml.nls.fi/Nimisto/Nimistorekisteri/2009/02" 
    xmlns:gml="http://www.opengis.net/gml" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    version="2.0"
    exclude-result-prefixes="pnr gml">

 <xsl:output method="text" encoding ="UTF-8"/>

 <xsl:strip-space elements="*"/>

 <!--
 Run from command line: java -jar -Xmx4096m saxon9he.jar paikka.xml nimet.xsl > nimet.csv 
 -->


<xsl:template match="//gml:featureMember">

   <xsl:variable name="piste">
        <xsl:value-of select="pnr:Paikka/pnr:paikkaSijainti/gml:Point/gml:pos"/>
   </xsl:variable>

   <xsl:variable name="nimi">
        <xsl:value-of select="pnr:Paikka/pnr:nimi/pnr:PaikanNimi/pnr:kirjoitusasu"/>
   </xsl:variable>

   <xsl:variable name="kieli">
        <xsl:value-of select="pnr:Paikka/pnr:nimi/pnr:PaikanNimi/pnr:kieliKoodi"/>
   </xsl:variable>

   <xsl:for-each select=".">
      <xsl:value-of select="$piste"/><xsl:text>,</xsl:text><xsl:value-of select="$nimi"/><xsl:text>,</xsl:text><xsl:value-of select="$kieli"/><xsl:text>
    </xsl:text>
   </xsl:for-each>

 </xsl:template>

</xsl:stylesheet>
