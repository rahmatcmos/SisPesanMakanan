<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsHTML"%>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* variabel untuk diselipkan pada HTML/Javascript 
     * nilainya diambil dari berkas jsp ini/lain
     * bentuk penyelipannya pada HTML: ${vModKonfNamaData}
     */
    request.setAttribute("vModKonfNamaData", vModKonfNamaData);
    
    
%>

<%
    /* @formulir */
    
    /* {OBYEK} */
    ClsHTML oForm = new ClsHTML(); /* obyek form */
    ClsOlahKata oKata = new ClsOlahKata(); /* obyek olah kata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* {VARIABEL} */
    String vGetOperasi = oKata.fHapusSpasi(request.getParameter("o")),
        vHTMLModKonfNamaData = vModKonfNamaData,
        vHTMLGambarIcon = "", 
        vHTMLDataOperasi = "", 
        vHTMLOperasi = "",
        vGetKodeBerita = "",
        vKode = "",
        vJudul = "",
        vTeks = "",
        vTanggal = "",
        vJam = "";
    
    /* VAR GET */
    vGetKodeBerita = oKata.fHapusSpasi(request.getParameter("b"));
    
    /* {OPERASI DATA} */
    
    /* {FORM DATA} */
    /* [FD1] form pada operasi tambah dan ubah data */
    if(vGetOperasi.equals("m")){
        /* {ISI} */
        vJudul = oOpsBasisdata.fAmbilSatuData("", "", "tb_hlm_berita", "judul", "kode", vGetKodeBerita);
        vTanggal = oOpsBasisdata.fAmbilSatuData("", "", "tb_hlm_berita", "tanggal", "kode", vGetKodeBerita);
        vJam = oOpsBasisdata.fAmbilSatuData("", "", "tb_hlm_berita", "jam", "kode", vGetKodeBerita);
        vTeks = oOpsBasisdata.fAmbilSatuData("", "", "tb_hlm_berita", "teks", "kode", vGetKodeBerita);
        
        vHTMLOperasi = "m";
     }
    
    
    StringBuilder oSbBerita = new StringBuilder();
    oSbBerita.append("<div id=\"idJudulBerita\">").append(vJudul).append("</div>");
    oSbBerita.append("<div id=\"idTanggalBerita\">").append(vTanggal).append(", Pkl. ").append(vJam).append(" WIB</div>");
    oSbBerita.append("<div id=\"idTeksBerita\">").append(vTeks).append("</div>");
    
    String vBerita = oSbBerita.toString();
    /* variabel tag */
    request.setAttribute("vHTMLOperasi", vHTMLOperasi); 
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vHTMLDataOperasi", vHTMLDataOperasi);
    request.setAttribute("vHTMLModKonfNamaData", vHTMLModKonfNamaData);
    request.setAttribute("vBerita", vBerita);
   
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/publik/modul/modModalDetailBerita" prefix="publik" %>
<publik:modal>
    <jsp:attribute name="atas">
        <!-- JS/CSS khusus di sini -->
        
	<script type="text/javascript">
            /* pemrogram: I Made Ariana (ariana@atlascitra.com)
             * waktu update: 2015.03.15/19:45 WIB
             */
            
            //<![CDATA[
                $(document).ready(function() {
                    
                    
                });
            //]]>     
	</script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
    <div class="clsModalIsi700Teks">
        <div class="clsModalJudul700Teks">
            <button type="button" class="close" onclick="Custombox.close('idDetailBerita');">&times;</button>
            <h4><img src="${URLModAdpubGambarMenu}/detail_berita48.png"/> &nbsp; <strong>${vHTMLModKonfNamaData}</strong></h4>
        </div>
        <div class="clsModalBody700Teks">
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            ${vBerita}
        </div>
    </div>
  </jsp:attribute>
</publik:modal>