<%@tag trimDirectiveWhitespaces="true"%>
<%@tag import="pilar.cls.clsKonf"%>
<%@tag description="desain modal reservasi" pageEncoding="UTF-8"%>
<%@ attribute name="atas" fragment="true" %>
<%@ attribute name="isi" fragment="true" %>

<% String vNamaModul = "modIndex"; %>
<% String vNamaData = "Index"; %>
<% String vTema = clsKonf.vKonfTema; %>

<% request.setAttribute("vNamaModul", vNamaModul); %>
<% request.setAttribute("vNamaData", vNamaData); %>
<% request.setAttribute("vTema", clsKonf.vKonfTema); %>
<% request.setAttribute("URL", clsKonf.vKonfURL); %>
<% request.setAttribute("URLMod", clsKonf.vKonfURL + "/halaman/publik/modul/" + vNamaModul); %>
<% request.setAttribute("URLModPublik", clsKonf.vKonfURL + "/halaman/publik/modul"); %>

<% request.setAttribute("URLModAdpubJSFw", clsKonf.vKonfURL + "/pilar/desain/"+ vTema +"/halaman/adpub/script/javascript/framework"); %>
<% request.setAttribute("URLModAdpubJSMd", clsKonf.vKonfURL + "/pilar/desain/"+vTema+"/halaman/adpub/script/javascript/modul"); %>
<% request.setAttribute("URLModAdpubCSSFw", clsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/css/framework"); %>
<% request.setAttribute("URLModAdpubCSSMd", clsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/css/modul"); %>

<% request.setAttribute("URLModAdpubGambarData", clsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/data"); %>
<% request.setAttribute("URLModAdpubGambarTombol", clsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/tombol"); %>
<% request.setAttribute("URLModAdpubGambarAnimasi", clsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/animasi"); %>
<% request.setAttribute("URLModAdpubGambarMenu", clsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/menu"); %>

<% request.setAttribute("URLModCSSStd", clsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/publik/modul/modStandar/css"); %>
<% request.setAttribute("URLModCSS", clsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/publik/modul/" + vNamaModul + "/css"); %>
<% request.setAttribute("URLModGambar", clsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/publik/modul/" + vNamaModul + "/gambar"); %>

<!DOCTYPE html>
<html class="no-js">
<head>
    <meta charset="utf-8">
    <!-- CSS bersama di sini --> 
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubCSSFw}/bootstrap/v3.1.1/bootstrap.min.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/index.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSS}/hover.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modCustomBox/css/custombox.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modNathanSlide/css/slide.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modDatePicker/css/datepicker.css" />
    
    <!-- JS bersama di sini -->
    <script type="text/javascript" src="${URLModAdpubJSFw}/jQuery/1.11.0/jquery-1.11.0.min.js"><!-- --></script>
    <script src="${URLModAdpubJSMd}/modCustomBox/js/custombox.js"></script>
    <script src="${URLModAdpubJSMd}/modNathanSlide/js/slides.min.jquery.js"></script>
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
  </body>
</html>
