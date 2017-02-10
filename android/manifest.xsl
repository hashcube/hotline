<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:android="http://schemas.android.com/apk/res/android">

  <xsl:param name="hotlineAppID" />
  <xsl:param name="hotlineAppKey" />
  <xsl:param name="package" />

  <xsl:output indent="yes" />
  <xsl:template match="comment()" />

  <xsl:template match="meta-data[@android:name='HOTLINE_APP_ID']">
    <meta-data android:name="HOTLINE_APP_ID" android:value="{$hotlineAppID}" />
  </xsl:template>

  <xsl:template match="meta-data[@android:name='HOTLINE_APP_KEY']">
    <meta-data android:name="HOTLINE_APP_KEY" android:value="{$hotlineAppKey}" />
  </xsl:template>

  <xsl:template match="provider/@android:authorities[.='your_package_name.provider']">
    <xsl:attribute name="android:authorities">
      <xsl:value-of select="concat($package, '.provider')" />
    </xsl:attribute>
  </xsl:template>

  <xsl:output indent="yes" />
  <xsl:template match="comment()" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
