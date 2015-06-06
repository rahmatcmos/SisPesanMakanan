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
    
    /* @sesi halaman admin */
    ClsKonf oKonf = new ClsKonf();
    ClsAdmin oAdmin = new ClsAdmin();
    try{
        if(session.getAttribute("sesID") != "" && !session.getId().equals("")){
            boolean vStatusSesi = oAdmin.fHalamanAdmin(session);
            if(!vStatusSesi){
                response.sendRedirect(ClsKonf.vKonfURL);
            }
        }
    }catch(Exception e){
        /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaBerkas = "modal.jsp";
                String vNamaModul = vModKonfNamaData;
                String vCatatan = vNamaBerkas + "#" + vNamaModul + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
    }
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
        vTeks = "",
        vPublikasi = "",
        vKodeFoto = "";
    
    /* {OPERASI DATA} */
    
    /* [OD1] operasi ubah (+/-) data */
    if(vGetOperasi.equals("u")){
        vHTMLOperasi = "Ubah";
        
        
        /* ambil data */
        ResultSet vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", 
                "", 
                vModKonfNamaTabel, 
                new String[]{"teks","kode_foto","publikasi"}, 
                new String[]{"nomor","1"},
                "nomor", "DESC", new String[]{"0","1"},"=");
        
        /* data nantinya ditampilkan di-form */
        while(vArrHasil.next()){
            vTeks = vArrHasil.getString("teks");
            vKodeFoto = vArrHasil.getString("kode_foto");
            vPublikasi = vArrHasil.getString("publikasi");
        }
        
        /* gambar icon */
        vHTMLGambarIcon = "ubahData32.png";
        vHTMLDataOperasi = "u";
    }
    
    
    /* {FORM DATA} */
    /* [FD1] form pada operasi tambah dan ubah data */
    if(vGetOperasi.equals("u")){
        
        /* {DATA TAMBAHAN} */
        if(vGetOperasi.equals("u")){
            StringBuilder vSbJK = new StringBuilder();
            if(vPublikasi.equals("1")){
                vSbJK.append("@");
                vSbJK.append(vPublikasi);
                vSbJK.append("&Ya#0&Tidak");
            }else{
                vSbJK.append("1&Ya#");
                vSbJK.append("@");
                vSbJK.append(vPublikasi);
                vSbJK.append("&Tidak");
            }
            vPublikasi = vSbJK.toString();
        }
        
        /* {FORM} */
        vHTMLForm = oForm.fForm("POST", "#", 
            new String[]{"Foto","Publikasi","Teks"}, 
            new String[]{"KodeFoto","Publikasi","Teks"}, 
            new String[]{"@t","r","a"}, 
            new String[]{vKodeFoto,vPublikasi,vTeks}, 
            oForm.fTombol("bt", "idTombolSimpan","Simpan","tombolAjaxSimpan.png"),
            "idFormHalamanProfilUsaha", 
            "clsFormTE");
     }
    
    /* variabel tag */
    request.setAttribute("vHTMLForm", vHTMLForm); 
    request.setAttribute("vHTMLOperasi", vHTMLOperasi); 
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vHTMLDataOperasi", vHTMLDataOperasi);
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/admin/modul/modHalamanSyarat" prefix="admin" %>
<admin:modal>
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
                    
                    /* TEXT AREA */
                    $("#idTeks").jqte();
                    
                    /* {BAGIAN TOMBOL[T]} */
                    /* [T1] tombol simpan */
                    $('#idTombolSimpan').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();

                        /* waktu */
                        vWaktu = vTgl.getTime();
                        
                        /* {DATA} */
                        /* data yg dikirim */
                        var vOperasi = '${vHTMLDataOperasi}';
                        var vKodeFoto = $("#idKodeFoto").val();
                        var vTeks = $("#idTeks").val();
                        var vPublikasi = $("input[name=nmPublikasi]:checked").val();
                        
                        /* bila teks memiliki diisi */
                        if(vTeks != ""){
                            /* tampilkan animasi gif */
                            $("#idGbrTombol").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');

                            /* [1] req. dilakukan */
                            var vReqSimpanData = $.ajax({
                                url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: vOperasi,
                                    dtKodeFoto: vKodeFoto,
                                    dtPublikasi: vPublikasi,
                                    dtTeks : vTeks
                                },
                                dataType: "html"
                            });


                            /* [2] req. selesai */
                            vReqSimpanData.done(function(vFDataSvr) {
                                /* [#] notifikasi */
                                
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
                                    
                                },1000);
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
    <div class="clsModalIsi700TE">
        <div class="clsModalJudul700TE">
            <button type="button" class="close" onclick="Custombox.close();">&times;</button>
            <h4><img src="${URLModAdpubGambarData}/${vHTMLGambarIcon}"/> &nbsp; <strong>${vHTMLOperasi} Data ${vModKonfNamaData}</strong></h4>
        </div>
        <div class="clsModalBody700TE">
            <center>
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            ${vHTMLForm}
            </center>
        </div>
    </div>
  </jsp:attribute>
</admin:modal>