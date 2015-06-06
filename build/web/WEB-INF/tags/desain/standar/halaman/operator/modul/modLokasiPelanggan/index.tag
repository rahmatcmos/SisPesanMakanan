<%@tag trimDirectiveWhitespaces="true"%>
<%@tag import="pilar.cls.ClsKonf"%>
<%@tag description="desain index modLokasiPelanggan" pageEncoding="UTF-8"%>
<%@ attribute name="atas" fragment="true" %>
<%@ attribute name="isi" fragment="true" %>

<% String vNamaModul = "modLokasiPelanggan"; %>
<% String vNamaData = "Lokasi Pelanggan"; %>
<% String vTema = ClsKonf.vKonfTema; %>

<% request.setAttribute("vNamaModul", vNamaModul); %>
<% request.setAttribute("vNamaData", vNamaData); %>
<% request.setAttribute("vTema", ClsKonf.vKonfTema); %>
<% request.setAttribute("URL", ClsKonf.vKonfURL); %>
<% request.setAttribute("URLMod", ClsKonf.vKonfURL + "/halaman/operator/modul/" + vNamaModul); %>
<% request.setAttribute("URLModOperator", ClsKonf.vKonfURL + "/halaman/operator/modul"); %>

<% request.setAttribute("URLModAdpubJSFw", ClsKonf.vKonfURL + "/pilar/desain/"+ vTema +"/halaman/adpub/script/javascript/framework"); %>
<% request.setAttribute("URLModAdpubJSMd", ClsKonf.vKonfURL + "/pilar/desain/"+vTema+"/halaman/adpub/script/javascript/modul"); %>
<% request.setAttribute("URLModAdpubCSSFw", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/css/framework"); %>
<% request.setAttribute("URLModAdpubCSSMd", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/css/modul"); %>

<% request.setAttribute("URLModOperatorStdGambarFavicon", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/operator/modul/modStandar/gambar/favicon"); %>

<% request.setAttribute("URLModAdpubGambarData", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/data"); %>
<% request.setAttribute("URLModAdpubGambarTombol", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/tombol"); %>
<% request.setAttribute("URLModAdpubGambarAnimasi", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/animasi"); %>
<% request.setAttribute("URLModAdpubGambarMenu", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/menu"); %>

<% request.setAttribute("URLModCSSStd", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/operator/modul/modStandar/css"); %>
<% request.setAttribute("URLModCSS", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/operator/modul/" + vNamaModul + "/css"); %>
<% request.setAttribute("URLModGambar", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/operator/modul/" + vNamaModul + "/gambar"); %>

<!DOCTYPE html>
<html class="no-js">
<head>
    <meta charset="utf-8">
    <title>Operatoristrasi Data ${vNamaData}</title>
    <link rel="shortcut icon" href="${URLModOperatorStdGambarFavicon}/favicon.ico" type="image/x-icon">
    <link rel="icon" href="${URLModOperatorStdGambarFavicon}/favicon.ico" type="image/x-icon">
    <!-- CSS bersama di sini -->  
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubCSSFw}/bootstrap/v3.3.2/bootstrap.min.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/index.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/tabel.data640.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/modal380.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubCSSMd}/modGbrHover/index.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modCustomBox/css/custombox.css" /> 
    
    <!-- JS bersama di sini -->
    <script type="text/javascript" src="${URLModAdpubJSFw}/jQuery/1.11.0/jquery-1.11.0.min.js"></script>
    <script src="${URLModAdpubJSMd}/modCustomBox/js/custombox.js"></script>
    <script src="${URLModAdpubJSMd}/modCustomBox/js/legacy.js"></script>
    <jsp:invoke fragment="atas"/>
  </head>

  <body>
    <table width="100%" border="1">
        <tr>
            <td width="20%">&nbsp;</td>
            <td width="60%"><jsp:invoke fragment="isi"/></td>
            <td width="20%">&nbsp;</td>
        </tr>		
    </table>
    <!-- bootstrap -->
    <script type="text/javascript" src="${URLModAdpubJSFw}/bootstrap/3.0.0/bootstrap.js"></script>
    <!-- custombox -->
    <script type="text/javascript" src="${URLModAdpubJSMd}/modCustomBox/js/custombox.js"></script>
  </body>
</html>