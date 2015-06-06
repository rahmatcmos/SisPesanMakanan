<%@tag trimDirectiveWhitespaces="true"%>
<%@tag import="pilar.cls.ClsKonf"%>
<%@tag description="desain modal modHalamanBannerGaleri" pageEncoding="UTF-8"%>
<%@ attribute name="atas" fragment="true" %>
<%@ attribute name="isi" fragment="true" %>

<% String vNamaModul = "modHalamanBannerGaleri"; %>
<% String vNamaData = "Galeri Foto Banner"; %>
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

<% request.setAttribute("URLModAdpubGambarData", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/data"); %>
<% request.setAttribute("URLModAdpubGambarAnimasi", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/animasi"); %>
<% request.setAttribute("URLModAdpubGambarTombol", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/tombol"); %>

<% request.setAttribute("URLModCSSStd", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/admin/modul/modStandar/css"); %>
<% request.setAttribute("URLModCSS", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/admin/modul/" + vNamaModul + "/css"); %>
<% request.setAttribute("URLModGambar", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/admin/modul/" + vNamaModul + "/gambar"); %>

<% request.setAttribute("URLModAdpubFoto", ClsKonf.vKonfURL + "/foto"); %>
<jsp:invoke fragment="atas"/>
<jsp:invoke fragment="isi"/>
  