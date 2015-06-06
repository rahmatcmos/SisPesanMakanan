<%@tag trimDirectiveWhitespaces="true"%>
<%@tag import="pilar.cls.ClsKonf"%>
<%@tag description="desain index modRestoOperator" pageEncoding="UTF-8"%>
<%@ attribute name="atas" fragment="true" %>
<%@ attribute name="isi" fragment="true" %>

<% String vNamaModul = "modRestoOperator"; %>
<% String vNamaData = "Operator"; %>
<% String vTema = ClsKonf.vKonfTema; %>

<% request.setAttribute("vNamaModul", vNamaModul); %>
<% request.setAttribute("vNamaData", vNamaData); %>
<% request.setAttribute("vTema", ClsKonf.vKonfTema); %>
<% request.setAttribute("URL", ClsKonf.vKonfURL); %>
<% request.setAttribute("URLMod", ClsKonf.vKonfURL + "/halaman/admin/modul/" + vNamaModul); %>
<% request.setAttribute("URLModAdmin", ClsKonf.vKonfURL + "/halaman/admin/modul"); %>

<% request.setAttribute("URLModAdpubJSFw", ClsKonf.vKonfURL + "/pilar/desain/"+ vTema +"/halaman/adpub/script/javascript/framework"); %>
<% request.setAttribute("URLModAdpubJSMd", ClsKonf.vKonfURL + "/pilar/desain/"+vTema+"/halaman/adpub/script/javascript/modul"); %>
<% request.setAttribute("URLModAdpubCSSFw", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/css/framework"); %>
<% request.setAttribute("URLModAdpubCSSMd", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/css/modul"); %>

<% request.setAttribute("URLModAdminStdGambarFavicon", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/admin/modul/modStandar/gambar/favicon"); %>

<% request.setAttribute("URLModAdpubGambarData", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/data"); %>
<% request.setAttribute("URLModAdpubGambarTombol", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/tombol"); %>
<% request.setAttribute("URLModAdpubGambarAnimasi", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/animasi"); %>
<% request.setAttribute("URLModAdpubGambarMenu", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/menu"); %>

<% request.setAttribute("URLModCSSStd", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/admin/modul/modStandar/css"); %>
<% request.setAttribute("URLModCSS", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/admin/modul/" + vNamaModul + "/css"); %>
<% request.setAttribute("URLModGambar", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/admin/modul/" + vNamaModul + "/gambar"); %>

<!DOCTYPE html>
<html class="no-js">
<head>
    <meta charset="utf-8">
    <title>Administrasi Data ${vNamaData}</title>
    <link rel="shortcut icon" href="${URLModAdminStdGambarFavicon}/favicon.ico" type="image/x-icon">
    <link rel="icon" href="${URLModAdminStdGambarFavicon}/favicon.ico" type="image/x-icon">
    <!-- CSS bersama di sini -->  
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubCSSFw}/bootstrap/v3.3.2/bootstrap.min.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/index.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/tabel.data640.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/tabel.data640.r3.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/modal380.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/modal700.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubCSSMd}/modGbrHover/index.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modCustomBox/css/custombox.css" /> 
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modDatePicker/css/datepicker.css" />
    
    <!-- JS bersama di sini -->
    <script type="text/javascript" src="${URLModAdpubJSFw}/jQuery/1.11.0/jquery-1.11.0.min.js"></script>
    <script src="${URLModAdpubJSMd}/modCustomBox/js/custombox.js"></script>
    <script src="${URLModAdpubJSMd}/modCustomBox/js/legacy.js"></script>
    <script src="${URLModAdpubJSMd}/modDatePicker/js/jquery.datetimepicker.js"></script>
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