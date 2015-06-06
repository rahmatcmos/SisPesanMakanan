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
        vHTMLForm = "",
        vEmail = "",
        vSandi = "";
    
    /* {OPERASI DATA} */
    
    /* {FORM DATA} */
    /* [FD1] form pada operasi tambah dan ubah data */
    if(vGetOperasi.equals("m")){
        
        /* {FORM} */
        vHTMLForm = oForm.fForm("POST", "#", 
            new String[]{"E-mail", "Sandi"}, 
            new String[]{"Email", "Sandi"}, 
            new String[]{"@t","@p"}, 
            new String[]{vEmail,vSandi}, 
            oForm.fTombol("bt", "idTombolSimpan","Kirim","tombolAjaxSimpan.png"),
            "idFormMasukPengguna", 
            "clsForm");
        
        vHTMLOperasi = "m";
     }
    
        
    /* variabel tag */
    request.setAttribute("vHTMLForm", vHTMLForm); 
    request.setAttribute("vHTMLOperasi", vHTMLOperasi); 
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vHTMLDataOperasi", vHTMLDataOperasi);
    
   
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/publik/modul/modMasuk" prefix="publik" %>
<publik:modal>
    <jsp:attribute name="atas">
        <!-- JS/CSS khusus di sini -->
        
	<script type="text/javascript">
            /* pemrogram: I Made Ariana (ariana@atlascitra.com)
             * waktu update: 2015.03.15/19:45 WIB
             */
            
            //<![CDATA[
                $(document).ready(function() {
                    /* {VARIABEL GLOBAL} */
                    var vTgl = new Date();
                    var vWaktu, vOperasi, vKode; /* data yang dikirim */
                    var vArrDataSvr = []; /* nilai data dari server */
                    var vKolomCari, vTeksCari;
                    
                    /* {BAGIAN TOMBOL[T]} */
                    
                    /* [T1] tombol simpan */
                    $('#idTombolSimpan').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();

                        /* waktu */
                        vWaktu = vTgl.getTime();
                        
                        /* {DATA} */
                        /* data yg dikirim */
                        var vOperasi = '${vHTMLOperasi}';
                        var vEmail = $('#idEmail').val();
                        var vSandi = $('#idSandi').val();
                        
                        /* bila kode dan nama diisi */
                        if(vEmail != "" && 
                                vSandi != "" ){
                            /* tampilkan animasi gif */
                            $("#idGbrTombol").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');

                            /* [1] req. dilakukan */
                            var vReqSimpanData = $.ajax({
                                url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: vOperasi, 
                                    dtEmail : vEmail,
                                    dtSandi : vSandi
                                },
                                dataType: "html"
                            });


                            /* [2] req. selesai */
                            vReqSimpanData.done(function(vFDataSvr) {
                                /* [#] notifikasi */
                                var vFArrDataSvr = vFDataSvr.split("#");
                                /* mengubah gambar tombol */
                                $("#idGbrTombol").attr('src','${URLModAdpubGambarTombol}/tombolAjaxSukses.png');
                                
                                /* operasi tambahan aka post operation setelah 3000 ms */
                                setTimeout(function(e){
                                    /* menampilkan bagian pencarian dan tabel */
                                    $(window.parent.document).find("#idDivCari").removeAttr('style','display:none');
                                    $(window.parent.document).find("#idDivTabelData").removeAttr('style','display:none');
                                    $(window.parent.document).find("#idDivTambah48").attr('style','display:none');

                                    /* mengubah gambar tombol */
                                    $("#idGbrTombol").attr('src','${URLModAdpubGambarTombol}/tombolAjaxSimpan.png');
                                    
                                    /* menampilkan pesan modal */
                                    $("#idPesanModal").removeClass('clsSembunyikanPesan');
                                    $("#idPesanModal").hide().addClass('clsTampilkanPesan');
                                    
                                    
                                    if(vFArrDataSvr[0].trim()== 0){
                                        $("#idPesanModal").html("Data Anda tidak valid!");
                                        $("#idPesanModal").fadeIn().css('border','1px solid red');
                                    }
                                    
                                    if(vFArrDataSvr[0].trim()== 1){
                                        /* sembunyikan form */
                                        $('#idFormMasukPengguna').hide();
                                        /* tampilkan pesan */
                                        $("#idPesanModal").html("Data Anda valid!<br>Tunggu sebentar ..");
                                        $("#idPesanModal").fadeIn().css('border','1px solid green');
                                        
                                        /* munculkan nama dan menu keluar */
                                        $(window.parent.document).find('#idMenuNK').removeClass("clsSembunyikanDiv");
                                        $(window.parent.document).find('#idMenuNK').addClass("clsTampilkanDiv");
                                        
                                        /* sembunyikan menu daftar */
                                        $(window.parent.document).find('#idMenuDM').removeClass("clsTampilkanDiv");
                                        $(window.parent.document).find('#idMenuDM').addClass("clsSembunyikanDiv");
                                        /* menampilkan nama pengguna */
                                        $(window.parent.document).find('#idNama').html(vFArrDataSvr[1]);
                                        $(window.parent.document).find('#idSpanNama').attr("data-hover",vFArrDataSvr[1].trim());
                                        
                                    }
                                    
                                },1000);
                                
                                setTimeout(function(e){
                                    if(vFArrDataSvr[0].trim()== 1){
                                        Custombox.close();
                                    }
                                },4000);
                            });

                            /* [3] req. gagal */
                            vReqSimpanData.fail(function(e, textStatus ) {
                                alert( "Permintaan ke server tidak berhasil: " + textStatus );
                                $("#idGbrTombol").attr('src','${URLModAdpubGambarTombol}/tombolAjaxGagal.png');
                            });
                            
                            /* menyembunyikan pesan modal */
                            $("#idPesanModal").fadeOut().css('border','0px solid red');
                            $("#idPesanModal").removeClass('clsTampilkanPesan');
                            $("#idPesanModal").hide().addClass('clsSembunyikanPesan');
                            
                            $("#idPesanModal").html("");
                        }else{
                            /* menampilkan pesan modal */
                            $("#idPesanModal").removeClass('clsSembunyikanPesan');
                            $("#idPesanModal").hide().addClass('clsTampilkanPesan');
                            $("#idPesanModal").fadeIn().css('border','1px solid red');
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
            <h4><img src="${URLModAdpubGambarMenu}/masuk.png"/> &nbsp; <strong>Masuk (Sign in)</strong></h4>
        </div>
        <div class="clsModalBody380">
            <center>
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            ${vHTMLForm}
            </center>
        </div>
    </div>
  </jsp:attribute>
</publik:modal>