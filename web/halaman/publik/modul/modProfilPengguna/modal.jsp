<%@page import="pilar.cls.ClsPelanggan"%>
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
    
     /* memeriksa sesi halaman pengguna */
    ClsKonf oKonf = new ClsKonf();
    ClsPelanggan oPelanggan = new ClsPelanggan();
    ClsOperasiBasisdata oOpsBasisdataSesi = new ClsOperasiBasisdata();
    String vKodeOrang = "";
    String vNamaPelanggan = "";
    //System.out.println("Sesi  --> " + session.getAttribute("sesIDPub") + "#" + session.getId().equals(""));
    try{
        if(session.getAttribute("sesIDPub") != ""){
            String vIdSesi = session.getAttribute("sesIDPub").toString();
            String vSandiSesi = session.getAttribute("sesSandiPub").toString();
            
            String vSandiDB = oOpsBasisdataSesi.fAmbilSatuData("", "", "tb_pelanggan", "sandi", "email", vIdSesi);
            
            if(vSandiDB.equals(vSandiSesi)){
                vKodeOrang = oOpsBasisdataSesi.fAmbilSatuData("", "", "tb_pelanggan", "kode_orang", "email", vIdSesi);
                vNamaPelanggan = oOpsBasisdataSesi.fAmbilSatuData("", "", "tb_sipil_orang", "nama_lengkap", "kode", vKodeOrang);
                
            }
            
        }
    }catch(Exception e){
        /* pencatatan sistem */
        if(ClsKonf.vKonfCatatSistem == true){
            String vNamaBerkas = "index.jsp";
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
        vEmail = "",
        vSandi = "",
        vNamaDepan = "",
        vNamaBelakang = "",
        vJenisKelamin = "",
        vTanggalLahir = "";
    
    /* {OPERASI DATA} */
    
    /* {FORM DATA} */
    /* [FD1] form pada operasi tambah dan ubah data */
    if(vGetOperasi.equals("u")){
        
        ResultSet vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", 
                "", 
                "tb_pelanggan", 
                new String[]{"email","sandi"}, 
                new String[]{"kode_orang",vKodeOrang},
                "nomor", "DESC", new String[]{"0","1"},"=");
        
        /* data nantinya ditampilkan di-form */
        while(vArrHasil.next()){
            vEmail = vArrHasil.getString("email");
            vSandi = vArrHasil.getString("sandi");
        }
        
        /* ambil dari tabel orang */
        ResultSet vArrHasilOrang = oOpsBasisdata.fArrAmbilDataDbKondisi("", 
                "", 
                "tb_sipil_orang", 
                new String[]{"nama_depan","nama_belakang","jenis_kelamin","tanggal_lahir"}, 
                new String[]{"kode",vKodeOrang},
                "nomor", "DESC", new String[]{"0","1"},"=");
        
        /* data nantinya ditampilkan di-form */
        while(vArrHasilOrang.next()){
            vNamaDepan = vArrHasilOrang.getString("nama_depan");
            vNamaBelakang = vArrHasilOrang.getString("nama_belakang");
            vJenisKelamin = vArrHasilOrang.getString("jenis_kelamin");
            vTanggalLahir = vArrHasilOrang.getString("tanggal_lahir");
        }
        
         StringBuilder vSbJK = new StringBuilder();
            if(vJenisKelamin.equals("1")){
                vSbJK.append("@");
                vSbJK.append(vJenisKelamin);
                vSbJK.append("&Pria#0&Wanita");
            }else{
                vSbJK.append("1&Pria#");
                vSbJK.append("@");
                vSbJK.append(vJenisKelamin);
                vSbJK.append("&Wanita");
            }
            vJenisKelamin = vSbJK.toString();
        /* {DATA TAMBAHAN} */
        vJenisKelamin = "@1&Pria#0&Wanita";
        
        /* {FORM} */
        vHTMLForm = oForm.fForm("POST", "#", 
            new String[]{"E-mail", "Sandi","Nama Depan","Nama Belakang","Jenis Kelamin","Tanggal Lahir"}, 
            new String[]{"Email", "Sandi","NamaDepan","NamaBelakang","JenisKelamin","TanggalLahir"}, 
            new String[]{"@t","@p","@t","@t","r","@t"}, 
            new String[]{vEmail,vSandi,vNamaDepan,vNamaBelakang,vJenisKelamin,vTanggalLahir}, 
            oForm.fTombol("bt", "idTombolSimpan","Simpan","tombolAjaxSimpan.png"),
            "idFormPendaftaranPelanggan", 
            "clsForm");
        
        vHTMLOperasi = "u";
     }
    
    /* tahun lahir min dan maks */
    Date vTanggalSekarang =  new Date(System.currentTimeMillis());
    String vTahunLahirMaks = "";
    String vTahunLahirMin = "";
    SimpleDateFormat simpleDateformat = new SimpleDateFormat("yyyy");
    
    Calendar vKalenderMaks = Calendar.getInstance();
    vKalenderMaks.setTime(vTanggalSekarang);
    vKalenderMaks.add(Calendar.YEAR, -1);
    vTahunLahirMaks = simpleDateformat.format(vKalenderMaks.getTime());
    
    Calendar vKalenderMin = Calendar.getInstance();
    vKalenderMin.setTime(vTanggalSekarang);
    vKalenderMin.add(Calendar.YEAR, -90);
    vTahunLahirMin = simpleDateformat.format(vKalenderMin.getTime());
    
    /* variabel tag */
    request.setAttribute("vHTMLForm", vHTMLForm); 
    request.setAttribute("vHTMLOperasi", vHTMLOperasi); 
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vHTMLDataOperasi", vHTMLDataOperasi);
    
    request.setAttribute("vTahunLahirMin", vTahunLahirMin);
    request.setAttribute("vTahunLahirMaks", vTahunLahirMaks);
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/publik/modul/modProfilPengguna" prefix="publik" %>
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
                    
                    /* tanggal lahir */
                    $('#idTanggalLahir').datetimepicker({
                        timepicker:false,
                        format:'Y-m-d',
                        mask:true,
                        validateOnBlur:true,
                        closeOnDateSelect:true,
                        minDate:'${vTahunLahirMin}/01/01',
                        maxDate:'${vTahunLahirMaks}/01/01'
                    });
                    
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
                        var vNamaDepan = $('#idNamaDepan').val();
                        var vNamaBelakang = $('#idNamaBelakang').val();
                        var vJenisKelamin = $("input[name=nmJenisKelamin]:checked").val();
                        var vTanggalLahir = $('#idTanggalLahir').val();
                        
                        /* bila kode dan nama diisi */
                        if(vEmail != "" && 
                                vSandi != "" &&
                                vNamaDepan != "" &&
                                vNamaBelakang != "" &&
                                vJenisKelamin != "" &&
                                vTanggalLahir != ""){
                            /* tampilkan animasi gif */
                            $("#idGbrTombol").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');

                            /* [1] req. dilakukan */
                            var vReqSimpanData = $.ajax({
                                url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: vOperasi, 
                                    dtEmail : vEmail,
                                    dtSandi : vSandi,
                                    dtNamaDepan : vNamaDepan,
                                    dtNamaBelakang: vNamaBelakang,
                                    dtJenisKelamin: vJenisKelamin,
                                    dtTanggalLahir: vTanggalLahir
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
                                    
                                    /* menampilkan pesan modal */
                                    $("#idPesanModal").removeClass('clsSembunyikanPesan');
                                    $("#idPesanModal").hide().addClass('clsTampilkanPesan');
                                    $("#idPesanModal").fadeIn().css('border','1px solid green');
                                    $("#idPesanModal").html("Data Anda sudah diubah.");
                                    
                                },1000);
                                
                                setTimeout(function(e){
                                    Custombox.close();
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
            <h4><img src="${URLModAdpubGambarMenu}/daftar.png"/> &nbsp; <strong>Profil Pelanggan</strong></h4>
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