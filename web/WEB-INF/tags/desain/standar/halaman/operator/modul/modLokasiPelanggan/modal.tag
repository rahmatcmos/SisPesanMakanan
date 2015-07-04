<%@tag trimDirectiveWhitespaces="true"%>
<%@tag import="pilar.cls.ClsKonf"%>
<%@tag description="desain modal modLokasiPelanggan" pageEncoding="UTF-8"%>
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

<% request.setAttribute("URLModAdpubGambarData", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/data"); %>
<% request.setAttribute("URLModAdpubGambarAnimasi", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/animasi"); %>
<% request.setAttribute("URLModAdpubGambarTombol", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/tombol"); %>
<% request.setAttribute("URLModAdpubGambarPeta", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/peta"); %>
<% request.setAttribute("URLModAdpubGambarMenu", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/menu"); %>

<% request.setAttribute("URLModCSSStd", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/operator/modul/modStandar/css"); %>
<% request.setAttribute("URLModCSS", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/operator/modul/" + vNamaModul + "/css"); %>
<% request.setAttribute("URLModGambar", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/operator/modul/" + vNamaModul + "/gambar"); %>


<jsp:invoke fragment="atas"/>
<jsp:invoke fragment="isi"/>
  