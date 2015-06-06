<%@tag trimDirectiveWhitespaces="true"%>
<%@tag import="pilar.cls.ClsKonf"%>
<%@tag description="desain index modIndex" pageEncoding="UTF-8"%>
<%@ attribute name="atas" fragment="true" %>
<%@ attribute name="isi" fragment="true" %>

<% String vNamaModul = "modIndex"; %>
<% String vNamaData = "Index Publik"; %>
<% String vTema = ClsKonf.vKonfTema; %>

<% request.setAttribute("vNamaModul", vNamaModul); %>
<% request.setAttribute("vNamaData", vNamaData); %>
<% request.setAttribute("vTema", ClsKonf.vKonfTema); %>
<% request.setAttribute("URL", ClsKonf.vKonfURL); %>
<% request.setAttribute("URLMod", ClsKonf.vKonfURL + "/halaman/publik/modul/" + vNamaModul); %>
<% request.setAttribute("URLModAdmin", ClsKonf.vKonfURL + "/halaman/admin/modul"); %>
<% request.setAttribute("URLModPublik", ClsKonf.vKonfURL + "/halaman/publik/modul"); %>

<% request.setAttribute("URLModAdpubJSFw", ClsKonf.vKonfURL + "/pilar/desain/"+ vTema +"/halaman/adpub/script/javascript/framework"); %>
<% request.setAttribute("URLModAdpubJSMd", ClsKonf.vKonfURL + "/pilar/desain/"+vTema+"/halaman/adpub/script/javascript/modul"); %>
<% request.setAttribute("URLModAdpubCSSFw", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/css/framework"); %>
<% request.setAttribute("URLModAdpubCSSMd", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/css/modul"); %>

<% request.setAttribute("URLModPublikStdGambarFavicon", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/publik/modul/modStandar/gambar/favicon"); %>

<% request.setAttribute("URLModAdpubGambarData", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/data"); %>
<% request.setAttribute("URLModAdpubGambarTombol", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/tombol"); %>
<% request.setAttribute("URLModAdpubGambarAnimasi", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/animasi"); %>
<% request.setAttribute("URLModAdpubGambarMenu", ClsKonf.vKonfURL + "/pilar/desain/" + vTema + "/halaman/adpub/gambar/menu"); %>

<% request.setAttribute("URLModCSSStd", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/publik/modul/modStandar/css"); %>
<% request.setAttribute("URLModCSS", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/publik/modul/" + vNamaModul + "/css"); %>
<% request.setAttribute("URLModGambar", ClsKonf.vKonfURL+ "/pilar/desain/" + vTema + "/halaman/publik/modul/" + vNamaModul + "/gambar"); %>

<% request.setAttribute("URLModAdpubFoto", ClsKonf.vKonfURL + "/foto"); %>
<!DOCTYPE html>
<html class="no-js">
<head>
    <meta charset="utf-8">
    <title>R.M. Padang "Sederhana" - Pesan Antar 24 Jam</title>
    <link rel="shortcut icon" href="${URLModPublikStdGambarFavicon}/favicon.ico" type="image/x-icon">
    <link rel="icon" href="${URLModPublikStdGambarFavicon}/favicon.ico" type="image/x-icon">
    <!-- CSS bersama di sini -->  
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubCSSFw}/bootstrap/v3.3.2/bootstrap.min.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/index.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/tabel.data640.merah.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/modal380Nomor.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/modal500Teks.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/modal800NT.css" />
    <!-- modal berita -->
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/tabel.data640.r4.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/modal700.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/modal700Teks.css" />
    <!-- /modal berita -->
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/keranjang.belanja.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/upload.foto.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/galeri.foto.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModCSSStd}/tautan.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubCSSMd}/modGbrHover/index.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modCustomBox/css/custombox.css" /> 
    <link rel="stylesheet" href="${URLModAdpubJSMd}/modSmallipop/css/jquery.smallipop.css" type="text/css" media="all" title="Screen"/>
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modDatePicker/css/datepicker.css" />
    <link media="screen, print" type="text/css" rel="stylesheet" href="${URLModAdpubJSMd}/modCoinSlider/css/coin-slider-styles.css" />
    <!-- JS bersama di sini -->
    <script type="text/javascript" src="${URLModAdpubJSFw}/jQuery/1.11.0/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="${URLModAdpubJSFw}/jQueryUI/1.10.4/jquery-ui-1.10.4.min.js"></script>
    <script src="${URLModAdpubJSMd}/modCustomBox/js/custombox.js"></script>
    <script src="${URLModAdpubJSMd}/modCustomBox/js/legacy.js"></script>
    <script src="${URLModAdpubJSMd}/modForm/js/jquery.form.js"></script>
    <script src="${URLModAdpubJSMd}/modSmallipop/lib/jquery.smallipop.js"></script>
    <script src="${URLModAdpubJSMd}/modNumber/js/jquery.number.min.js"></script>
    <script src="${URLModAdpubJSMd}/modDatePicker/js/jquery.datetimepicker.js"></script>
    <script src="${URLModAdpubJSMd}/modCoinSlider/js/coin-slider.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&signed_in=false&libraries=places,geometry,directionService"></script>
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