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
        vTeks = "",
        vHTMLForm = "",
            vNama = "",
            vEmail = "",
            vPerihal = "",
            vKomentar = "";
    
    /* {OPERASI DATA} */
    
    /* {FORM DATA} */
    /* [FD1] form pada operasi tambah dan ubah data */
    if(vGetOperasi.equals("m")){
        
        /* {ISI} */
        vTeks = oOpsBasisdata.fAmbilSatuData("", "", "tb_hlm_kontak", "teks", "nomor", "1");
        
        /* {FORM} */
        vHTMLForm = oForm.fForm("POST", "#", 
            new String[]{"Nama", "E-mail", "Perihal", "Komentar"}, 
            new String[]{"KontakNama", "KontakEmail", "KontakPerihal", "KontakKomentar"}, 
            new String[]{"@t","@t","@t","a"}, 
            new String[]{vNama,vEmail,vPerihal,vKomentar}, 
            oForm.fTombol("bt", "idTombolSimpan","Kirim","tombolAjaxSimpan.png"),
            "idFormKontak", 
            "clsForm");
        
        vHTMLOperasi = "m";
     }
    
    /* variabel tag */
    request.setAttribute("vHTMLOperasi", vHTMLOperasi); 
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vHTMLDataOperasi", vHTMLDataOperasi);
    request.setAttribute("vHTMLModKonfNamaData", vHTMLModKonfNamaData);
    request.setAttribute("vTeks", vTeks);
    request.setAttribute("vHTMLForm", vHTMLForm);
   
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/publik/modul/modHalamanKontak" prefix="publik" %>
<publik:modal>
    <jsp:attribute name="atas">
        <!-- JS/CSS khusus di sini -->
        
	<script type="text/javascript">
            /* pemrogram: I Made Ariana (ariana@atlascitra.com)
             * waktu update: 2015.03.15/19:45 WIB
             */
            
            //<![CDATA[
                $(document).ready(function() {
                    
                    /* [T1] tombol simpan */
                    $('#idTombolSimpan').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        
                        /* var POST */
                        var vOperasi = "m";
                        var vKontakNama = $('#idKontakNama').val();
                        var vKontakEmail = $('#idKontakEmail').val();
                        var vKontakPerihal = $('#idKontakPerihal').val();
                        var vKontakKomentar = $('#idKontakKomentar').val();
                        //var vCaptha = $('#idCapthca').val();
                        
                        /* bila semua kolom diisi */
                        if(vKontakNama != "" && 
                                vKontakEmail != "" && 
                                vKontakPerihal != "" && 
                                vKontakKomentar != ""){
                            
                            /* waktu */
                            var vTgl = new Date();
                            var vWaktu = vTgl.getTime();

                            /* [1] req. dilakukan */
                            var vReqSimpanData = $.ajax({
                                url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: vOperasi, 
                                    dtNama : vKontakNama, 
                                    dtEmail : vKontakEmail,
                                    dtPerihal: vKontakPerihal,
                                    dtKomentar: vKontakKomentar
                                },
                                dataType: "html"
                            });

                            /* [2] req. selesai */
                            vReqSimpanData.done(function(vFDataSvr) {
                                /* tutup modal */
                                Custombox.close();
                            });

                            /* [3] req. gagal */
                            vReqSimpanData.fail(function(e, textStatus ) {


                            });
                        
                        }
                        
                    });
                });
            //]]>     
	</script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
    <div class="clsModalIsi380">
        <div class="clsModalJudul380">
            <button type="button" class="close" onclick="Custombox.close();">&times;</button>
            <h4><img src="${URLModAdpubGambarMenu}/kontak.png"/> &nbsp; <strong>${vHTMLModKonfNamaData}</strong></h4>
        </div>
        <div class="clsModalBody380">
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            ${vTeks}
            
            <div class="clsFormKontak" align="center">
                ${vHTMLForm}
            </div>
        </div>
    </div>
  </jsp:attribute>
</publik:modal>