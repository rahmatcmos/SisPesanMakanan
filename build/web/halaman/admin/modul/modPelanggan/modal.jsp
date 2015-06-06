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
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata(); /* obyek basisdata */
    
    /* {VARIABEL} */
    String vGetOperasi = oKata.fHapusSpasi(request.getParameter("o")),
        vHTMLModKonfNamaData = vModKonfNamaData,
        vHTMLGambarIcon = "", 
        vHTMLDataOperasi = "", 
        vHTMLOperasi = "",
        vHTMLForm = "",
        vKode = "", 
        vKodeSebutan = "",
        vNama = "",
        vNamaDepan = "",
        vNamaBelakang = "",
        vJenisKelamin = "",
        vKodeNegaraLahir = "",
        vKodeProvinsiLahir = "",
        vKodeKabupatenLahir = "",
        vKodeKecamatanLahir = "",
        vTanggalLahir = "",
        vCatatan = "";
    
    /* {OPERASI DATA} */
    /* [OD1] operasi tambah (+) data */
    if(vGetOperasi.equals("t")){
        vHTMLOperasi = "Tambah";
        vHTMLGambarIcon = "tambahData32.png";
        vHTMLDataOperasi = "t"; /* untuk diletakkan pada HTML */
    }
    
    /* [OD2] operasi ubah (+/-) data */
    if(vGetOperasi.equals("u")){
        vHTMLOperasi = "Ubah";
        String vGetKode = request.getParameter("k").trim();
        
        /* ambil data */
        ResultSet vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", 
                "", 
                vModKonfNamaTabel, 
                new String[]{"kode",
                        "kode_sebutan",
                        "nama_depan",
                        "nama_belakang",
                        "jenis_kelamin",
                        "tl_kode_geo_negara",
                        "tl_kode_geo_provinsi",
                        "tl_kode_geo_kabupaten",
                        "tl_kode_geo_kecamatan",
                        "tanggal_lahir",
                        "catatan"}, 
                new String[]{"kode",vGetKode},
                "nomor", "DESC", new String[]{"0","1"},"=");
        
        /* data nantinya ditampilkan di-form */
        while(vArrHasil.next()){
            vKode = vArrHasil.getString("kode");
            vKodeSebutan = vArrHasil.getString("kode_sebutan");
            vNamaDepan = vArrHasil.getString("nama_depan");
            vNamaBelakang = vArrHasil.getString("nama_belakang");
            vJenisKelamin = vArrHasil.getString("jenis_kelamin");
            vKodeNegaraLahir = vArrHasil.getString("tl_kode_geo_negara");
            vKodeProvinsiLahir = vArrHasil.getString("tl_kode_geo_provinsi");
            vKodeKabupatenLahir = vArrHasil.getString("tl_kode_geo_kabupaten");
            vKodeKecamatanLahir = vArrHasil.getString("tl_kode_geo_kecamatan");
            vTanggalLahir = vArrHasil.getString("tanggal_lahir");
            vCatatan = vArrHasil.getString("catatan");
        }
        /* gambar icon */
        vHTMLGambarIcon = "ubahData32.png";
        vHTMLDataOperasi = "u";
    }
    
    /* [OD3] operasi hapus (-) data */
    String vGetKodeHapus = "";
    String vKodeNama = "";
    if(vGetOperasi.equals("h")){
        vHTMLOperasi = "Hapus";
        vGetKodeHapus = request.getParameter("k").trim();
        String[] vArrKodeHapus = vGetKodeHapus.split("#");
        
        
        if(vArrKodeHapus.length == 0){
            /* ambil data */
            ResultSet vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", "", vModKonfNamaTabel, new String[]{"kode","nama"}, new String[]{"kode",vGetKodeHapus}, "nomor", "DESC", new String[]{"0","1"},"=");

            /* data nantinya ditampilkan di-form */
            while(vArrHasil.next()){
                vKode = vArrHasil.getString("kode");
                vNama = vArrHasil.getString("nama");
            }
            
            vKodeNama = "[ " + vKode + " ] " + vNama;
        }
        
        if(vArrKodeHapus.length > 0){
            StringBuilder oSbKode = new StringBuilder();
            
            boolean vPertama = true;
            for(String vKodeHapus : vArrKodeHapus){
                /* ambil data */
                ResultSet vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", "", vModKonfNamaTabel, new String[]{"kode","nama"}, new String[]{"kode",vKodeHapus}, "nomor", "DESC", new String[]{"0","1"},"=");

                /* data nantinya ditampilkan di-form */
                while(vArrHasil.next()){
                    vKode = vArrHasil.getString("kode");
                    vNama = vArrHasil.getString("nama");
                }
                
                if(vPertama){
                    oSbKode.append("[ ").append(vKode).append(" ] ").append(" ").append(vNama);
                    vPertama = false;
                }else{
                    oSbKode.append(", [ ").append(vKode).append(" ] ").append(" ").append(vNama);
                }
                
            }
            
            vKodeNama = oSbKode.toString();
        }
        /* gambar icon */
        vHTMLGambarIcon = "hapusData32.png";
        vHTMLDataOperasi = "h";
    }
    
    /* {FORM DATA} */
    /* [FD1] form pada operasi tambah dan ubah data */
    if(vGetOperasi.equals("t") || vGetOperasi.equals("u")){
        /* membuat kode acak */
        ClsKode oKode = new ClsKode();
        String vKodeAcak = vModKonfKodeAwal + oKode.fBuatKodeAcak(14).toUpperCase();
        /* kode acak yang baru ditampilkan pada saat operasi penambahan data */
        vKode = (vGetOperasi.equals("t")) ? vKodeAcak : vKode;
        
        /* {DATA TAMBAHAN} */
        /* -------------------------------- */
        String vSelKodeSebutan = "";
        String vSelNegaraLahir = "";
        String vSelProvinsiLahir = "";
        String vSelKabupatenLahir = "";
        String vSelKecamatanLahir = "";
        
        /* A) operasi tambah data */
        if(vGetOperasi.equals("t")){
            /* 1) negara */
            vSelNegaraLahir = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_negara", "");
            /* 2) provinsi */
            vSelProvinsiLahir = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_provinsi", "");
            /* 3) kabupaten */
            vSelKabupatenLahir = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_kabupaten", "");
            /* 4) kecamatan */
            vSelKecamatanLahir = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_kecamatan", "");
            /* 5) jenis kelamin */
            vJenisKelamin = "@1&Pria#0&Wanita";
            /* 6) sebutan */
            vSelKodeSebutan = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_sipil_sebutan", "");
        }
        
        /* B) operasi ubah data */
        if(vGetOperasi.equals("u")){
            /* 1) negara */
            vSelNegaraLahir = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_negara", vKodeNegaraLahir);
            /* 2) provinsi */
            vSelProvinsiLahir = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_provinsi", vKodeProvinsiLahir);
            /* 3) kabupaten */
            vSelKabupatenLahir = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_kabupaten", vKodeKabupatenLahir);
            /* 4) kecamatan */
            vSelKecamatanLahir = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_kecamatan", vKodeKecamatanLahir);
            /* 5) jenis kelamin */
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
            
            /* 6) sebutan */
            vSelKodeSebutan = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_sipil_sebutan", vKodeSebutan);
        
        }
        /* -------------------------------- */
        /* {FORM} */
        vHTMLForm = oForm.fForm("POST", "#", 
            new String[]{"Kode",
                "Sebutan",
                "Nama Depan ",
                "Nama Belakang",
                "Jenis Kelamin",
                "Negara Lahir",
                "Provinsi Lahir",
                "Kabupaten Lahir",
                "Kecamatan Lahir",
                "Tanggal Lahir",
                "Catatan"}, 
            new String[]{"!Kode",
                "KodeSebutan",
                "NamaDepan",
                "NamaBelakang",
                "JenisKelamin",
                "KodeNegaraLahir",
                "KodeProvinsiLahir",
                "KodeKabupatenLahir",
                "KodeKecamatanLahir",
                "TanggalLahir",
                "Catatan"}, 
            new String[]{"@t",
                "s",
                "@t",
                "@t",
                "r",
                "s",
                "s",
                "s",
                "s",
                "@t",
                "a"}, 
            new String[]{vKode,
                vSelKodeSebutan,
                vNamaDepan,
                vNamaBelakang,
                vJenisKelamin,
                vSelNegaraLahir,
                vSelProvinsiLahir,
                vSelKabupatenLahir,
                vSelKecamatanLahir,
                vTanggalLahir,
                vCatatan}, 
            oForm.fTombol("bt", "idTombolSimpan","Simpan","tombolAjaxSimpan.png"),
            "idFormOrang", 
            "clsForm");
     }
    
    /* [FD2] form pada operasi hapus data */
    if(vGetOperasi.equals("h")){
        String vKalimat = "Apakah benar data <b>" + vKodeNama + "</b> ingin dihapus?";
        
        vHTMLForm = oForm.fFormYaTidak("POST","#",vKalimat, 
                "idTabelFormYaTidak", 
                new String[]{"idTombolYa","idTombolTidak"}, 
                new String[]{"Ya","Tidak"}, 
                new String[]{"tombolYa16.png","tombolTidak16.png"},
                "idFormOrang", 
                "clsForm",
                new String[]{"idKode",vGetKodeHapus});
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

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/admin/modul/modPelanggan" prefix="admin" %>
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
                    
                    /* {BAGIAN TOMBOL[T]} */
                    /* [T1] tombol hapus */
                    /* [T1:1] tombol "Ya" */
                    $('#idTombolYa').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        
                        /* data-data yang dikirim */
                        vWaktu = vTgl.getTime();
                        vOperasi = '${vHTMLDataOperasi}';
                        vKode = $('#idKode').val();
                        
                        /* nilai kriteria dan teks pencarian */
                        vKolomCari = $(window.parent.document).find('#idSelCari').val();
                        vTeksCari = $(window.parent.document).find('#idTeksCari').val();
                        
                        /* tampilkan animasi gif */
                        $("#idTombolYa").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');
                        
                        /* operasi ajax */
                        var vReqHapusData = $.ajax({
                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                            type: "POST",
                            data: { 
                                dtOperasi: vOperasi, 
                                dtKode : vKode
                            },
                            dataType: "text"
                        });

                        /* request selesai */
                        vReqHapusData.done(function(vFDataSvr) {
                            /* vFDataSvr: jumlah data total di tabel DB */
                            //console.log("vFDataSvr: " + vFDataSvr)
                            /* notifikasi */
                            $("#idTombolYa").attr('src','${URLModAdpubGambarTombol}/tombolAjaxSukses.png');
                                setTimeout(function(e){
                                    /* jumlah halaman keseluruhan di kolom */
                                    var vNoHalamanMaks = $(window.parent.document).find('#idNoHalamanMaks').val(); /* SI: saat ini */
                                    /* banyak data yang ditampilkan */
                                    var vJumData = $(window.parent.document).find('#idJumData').val();
                                    /* jumlah halaman maksimal sesuai dgn jumlah total data di tabel */
                                    var vNoHalamanMaks = (parseInt(vFDataSvr) - (parseInt(vFDataSvr) % parseInt(vJumData)))/parseInt(vJumData);
                                    vNoHalamanMaks = ((parseInt(vFDataSvr) % parseInt(vJumData)) > 0) ? (vNoHalamanMaks + 1) : vNoHalamanMaks;
                                    /* halaman saat ini */
                                    var vNoHalaman = parseInt($(window.parent.document).find('#idNoHalaman').val());
                                    
                                    /* [#] perbaharui parameter navigasi */
                                    //console.log('fPerbaharuiNavigasi');
                                    fPerbaharuiNavigasi("h",vFDataSvr,vJumData,vNoHalamanMaks,vNoHalaman);
                                    
                                    /* [#] update parent tabel */
                                    /* mengambil kembali nilai no halaman apabila pada proses perbaharui navigasi 
                                     * terdapat perubahan no halaman */
                                    vNoHalaman = parseInt($(window.parent.document).find('#idNoHalaman').val());
                                    /* [#] perbaharui tombol navigasi */
                                    //console.log("fTombolNavigasiTampil >> " + vNoHalaman + " # " + vNoHalamanMaks);
                                    fTombolNavigasiTampil(vNoHalaman,vNoHalamanMaks);
                                    
                                    /* memanggil fungsi fPerbaharuiTabel */
                                    //console.log("fPerbaharuiTabel");
                                    fPerbaharuiTabel("h",vFDataSvr,vJumData,vNoHalamanMaks,vNoHalaman);
                                    
                            },1000);

                            /* tutup modal */
                            Custombox.close('');
                        });

                        /* request gagal */
                        vReqHapusData.fail(function(e, textStatus ) {
                            alert( "Permintaan ke server tidak berhasil: " + e + '#' + textStatus );
                            $("#idGbrTombol").attr('src','${URLModAdpubGambarTombol}/tombolAjaxGagal.png');
                        });

                    });
                    
                    /* [T1:2] tombol "Tidak" */
                    $('#idTombolTidak').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        
                        /* tutup modal */
                        Custombox.close();
                    });

                    /* [T2] tombol simpan */
                    $('#idTombolSimpan').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();

                        /* waktu */
                        vWaktu = vTgl.getTime();
                        
                        /* {DATA} */
                        /* data yg dikirim */
                        var vOperasi = '${vHTMLDataOperasi}';
                        var vKode = $('#idKode').val();
                        var vKodeSebutan = $('#idKodeSebutan').val();
                        var vNamaDepan = $('#idNamaDepan').val();
                        var vNamaBelakang = $('#idNamaBelakang').val();
                        var vJenisKelamin = $("input[name=nmJenisKelamin]:checked").val();
                        var vKodeNegaraLahir = $('#idKodeNegaraLahir').val();
                        var vKodeProvinsiLahir = $('#idKodeProvinsiLahir').val();
                        var vKodeKabupatenLahir = $('#idKodeKabupatenLahir').val();
                        var vKodeKecamatanLahir = $('#idKodeKecamatanLahir').val();
                        var vTanggalLahir = $('#idTanggalLahir').val();
                        var vCatatan = $('#idCatatan').val();
                        
                        /* bila kode dan nama diisi */
                        if(vKode != "" && vNamaDepan != ""){
                            /* tampilkan animasi gif */
                            $("#idGbrTombol").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');

                            /* [1] req. dilakukan */
                            var vReqSimpanData = $.ajax({
                                url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: vOperasi, 
                                    dtKode : vKode, 
                                    dtKodeSebutan : vKodeSebutan,
                                    dtNamaDepan : vNamaDepan,
                                    dtNamaBelakang: vNamaBelakang,
                                    dtJenisKelamin: vJenisKelamin,
                                    dtKodeNegaraLahir : vKodeNegaraLahir,
                                    dtKodeProvinsiLahir : vKodeProvinsiLahir,
                                    dtKodeKabupatenLahir : vKodeKabupatenLahir,
                                    dtKodeKecamatanLahir : vKodeKecamatanLahir,
                                    dtTanggalLahir : vTanggalLahir,
                                    dtCatatan: vCatatan
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

                                    /* rutin untuk operasi tambah */
                                    if(vOperasi == 't'){
                                        /* {KODE ACAK BARU} */
                                        /* waktu kini */
                                        vWaktu = vTgl.getTime();

                                        /* [1] req. dilakukan */
                                        var vReqKodeAcak = $.ajax({
                                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                            type: "POST",
                                            data: { dtOperasi: "k"
                                            },
                                            dataType: "text"
                                        });
                                        /* [2] req. selesai */
                                        vReqKodeAcak.done(function(vFDataSvr){
                                                var vKodeAcak = (vFDataSvr.trim() != "") ? vFDataSvr : "Error";
                                                $('#idKode').val(vKodeAcak);                                            
                                            }   
                                        );                            
                                        /* [3] req. gagal */
                                        vReqKodeAcak.fail(function(textStatus){
                                            alert( "Gagal melakukan permintaan membuat kode acak: " + textStatus );
                                        });

                                        /* mengosongkan kolom berikut */                                    
                                        $('#idCatatan').val('');
                                        $('#idNamaDepan').val('');
                                        $('#idNamaBelakang').val('');
                                        $('#idTanggalLahir').val('');
                                        /* set fokus pada kolom berikut */
                                        $('#idNamaDepan').focus();
                                    }

                                    /* mengubah gambar tombol */
                                    $("#idGbrTombol").attr('src','${URLModAdpubGambarTombol}/tombolAjaxSimpan.png');
                                    /* fokus pada kode */
                                    $('#idKode').focus();
                                },1000);

                                /* [#] update parent tabel */
                                /* banyak halaman maksimum (di kolom) */
                                var vNoHalamanMaks = $(window.parent.document).find('#idNoHalamanMaks').val(); 
                                /* banyak data yang ditampilkan (di kolom) */
                                var vJumData = $(window.parent.document).find('#idJumData').val();
                                /* jumlah halaman maksimal sesuai dgn jumlah total data (di basisdata) */
                                var vNoHalamanMaks = (parseInt(vFDataSvr) - (parseInt(vFDataSvr) % parseInt(vJumData)))/parseInt(vJumData);
                                vNoHalamanMaks = ((parseInt(vFDataSvr) % parseInt(vJumData)) > 0) ? (vNoHalamanMaks + 1) : vNoHalamanMaks;
                                /* halaman saat ini (di kolom) */
                                var vNoHalaman = parseInt($(window.parent.document).find('#idNoHalaman').val());

                                /* [#] perbaharui parameter navigasi */
                                console.log('fPerbaharuiNavigasi');
                                fPerbaharuiNavigasi("tu",vFDataSvr,vJumData,vNoHalamanMaks,vNoHalaman);

                                /* [#] update parent tabel */
                                /* mengambil kembali nilai no halaman apabila pada proses perbaharui navigasi 
                                 * terdapat perubahan no halaman */
                                vNoHalaman = parseInt($(window.parent.document).find('#idNoHalaman').val());
                                /* [#] perbaharui tombol navigasi */
                                console.log("fTombolNavigasiTampil >> " + vNoHalaman + " # " + vNoHalamanMaks);
                                fTombolNavigasiTampil(vNoHalaman,vNoHalamanMaks);

                                /* memanggil fungsi fPerbaharuiTabel */
                                console.log("fPerbaharuiTabel");
                                fPerbaharuiTabel("tu",vFDataSvr,vJumData,vNoHalamanMaks,vNoHalaman);
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
                            $("#idNama").focus();
                        }else{
                            /* menampilkan pesan modal */
                            $("#idPesanModal").removeClass('clsSembunyikanPesan');
                            $("#idPesanModal").hide().addClass('clsTampilkanPesan');
                            $("#idPesanModal").fadeIn().css('border','1px solid red');
                            
                            $("#idPesanModal").html("<b>Mohon mengisi kolom nama.</b>");
                            $("#idNama").focus();
                        }
                        
                    });                    

                    /* {BAGIAN FUNGSI} */
                    /* [F1] fPerbaharuiNavigasi: memerbaharui navigasi */
                    function fPerbaharuiNavigasi(
                        vFOperasi,
                        vFJumDataBd,
                        vFJumData,
                        vFNoHalamanMaks,
                        vFNoHalaman){
                        
                        console.log("fPerbaharuiNavigasi >> " + 
                                vFOperasi + " # " +
                                vFJumDataBd + " # " +
                                vFJumData + " # " +
                                vFNoHalamanMaks + " # " +
                                vFNoHalaman);
                        
                        switch(vFOperasi){
                            case "tu":
                                /* pada operasi penambahan atau ubah data:
                                 * [1] no halaman TETAP
                                 * [2] ubah banyak halaman maksimal
                                 */
                                
                                if(vFNoHalaman == 0){
                                    $(window.parent.document).find('#idNoHalamanMaks').val(vFNoHalamanMaks);
                                    $(window.parent.document).find('#idNoHalaman').val(vFNoHalamanMaks);
                                }else{
                                    $(window.parent.document).find('#idNoHalamanMaks').val(vFNoHalamanMaks);
                                    $(window.parent.document).find('#idNoHalaman').val(vFNoHalaman);
                                }
                                
                                break;
                            case "h":
                                //console.log("fPerbaharuiNavigasi >> vFOperasi == hapus ");
                                /* ambil no halaman maks di kolom input saat ini */
                                var vNoHalamanMaksSI = $(window.parent.document).find('#idNoHalamanMaks').val(); /* SI: saat ini */
                                /* bila nilai halaman maks melebihi halaman maks yg dihitung dari DB */
                                if(parseInt(vNoHalamanMaksSI) > parseInt(vFNoHalamanMaks)){
                                    //console.log("fPerbaharuiNavigasi >> no halaman kolom > no halaman maks ");
                                    
                                    /* set no halaman maks */
                                    $(window.parent.document).find('#idNoHalamanMaks').val(vFNoHalamanMaks);
                                    
                                    if(parseInt(vFNoHalamanMaks) == parseInt(0)){
                                        $(window.parent.document).find('#idNoHalaman').val('0')
                                    }
                                    
                                    /* [#] perbaharui nomor halaman */
                                    /* bila nomor halaman melebih jumlah halaman maks */
                                    if(parseInt(vFNoHalaman) > parseInt(vFNoHalamanMaks)){
                                        /* bila tidak berada di halaman 1 */
                                        if(parseInt(vFNoHalaman) != parseInt(1)){
                                            /* kurangi nomor halaman */
                                            vFNoHalaman -= 1;
                                            /* tampilkan nomor halaman yang baru */
                                            $(window.parent.document).find('#idNoHalaman').val(vFNoHalaman)
                                        }
                                        
                                    }
                                }
                                 
                                break;
                        }
                        
                    }
                    
                    /* [F2] fPerbaharuiTabel: memerbaharui tabel */
                    function fPerbaharuiTabel(
                        vFOperasi,
                        vFJumDataBd,
                        vFJumData,
                        vFNoHalamanMaks,
                        vFNoHalaman){
                        
                        /* offset data db DB */
                        var vOffset;

                       /* waktu */
                       vWaktu = vTgl.getTime();
                       //console.log('#Perbaharui tabel : vFBerikut -> ' + vFBerikut + ', ' + 'vOffset -> ' + vOffset);
                       
                        switch(vFOperasi){
                            case "tu":
                                vOffset = (parseInt(vFNoHalaman)-1) * parseInt(vFJumData);
                                //console.log('Offset: ' + vOffset);
                                break;
                            case "h": /* hapus */
                                /* offset dimulai dari 0 
                                 * bila ada 7 data berarti indeksnya dari 0 s.d. 6 
                                 * misalnya berada di halaman 2 dgn jumlah tampilan 5 data 
                                 * maka pada halaman pertama menampilkan data indeks 0 s.d. 4 
                                 * dan pada halaman kedua menampilkan data indeks 5 s.d. 6 
                                 * demikian terus dengan awal offset bertambah 5 --> 0,5,10,15, .. */
                                vOffset = (vFNoHalaman == 0) ? 0 : (parseInt(vFNoHalaman)-1) * parseInt(vFJumData);
                                break;
                        }
                        /* melakukan permintaan */    
                        /* urutan data */
                        var vUrutanData = $(window.parent.document).find('#idUrutanData').val();
                        
                        /* nilai kriteria dan teks pencarian */
                        var vKolomCari = $(window.parent.document).find('#idSelCari').val();
                        var vTeksCari = $(window.parent.document).find('#idTeksCari').val();
                        
                        console.log("vReqDataTabel.start");
                        var vReqDataTabel = $.ajax({
                            url: '${URLMod}/tabel.jsp?o=' + vOffset + '&j='+ vFJumData + '&w=' + vWaktu,
                            type: 'POST',
                            data: {
                                dtKolomCari: vKolomCari,
                                dtTeksCari: vTeksCari,
                                dtUrutanData: vUrutanData
                            },
                           dataType: 'text'
                       });

                       /* permintaan selesai */
                       //console.log("vReqDataTable.done");
                       vReqDataTabel.done(function(vFDataSvr){ 
                           var vArrDataSvr = [];
                           
                           if(vFDataSvr.trim() != ""){
                               vArrDataSvr = vFDataSvr.split('@');
                           }
                           
                           //console.log("vArrDataSvr[0]: " + vArrDataSvr[0]);
                           if(vFDataSvr.trim() != "" && parseInt(vArrDataSvr[0]) > parseInt(0)){
                                /* menampilkan pencarian */
                                if($(window.parent.document).find('#idDivCari').hasClass('clsSembunyikanDiv')){
                                    $(window.parent.document).find('#idDivCari').fadeOut().removeClass('clsSembunyikanDiv');
                                    $(window.parent.document).find('#idDivCari').fadeIn().addClass('clsTampilkanDiv');
                                }
                                /* menampilkan tabel data */
                                if($(window.parent.document).find('#idDivTabelData').hasClass('clsSembunyikanDiv')){
                                    $(window.parent.document).find('#idDivTabelData').fadeOut().removeClass('clsSembunyikanDiv');
                                    $(window.parent.document).find('#idDivTabelData').fadeIn().addClass('clsTampilkanDiv');
                                }
                                /* menampilkan navigasi */
                                if($(window.parent.document).find('#idDivNavigasi').hasClass('clsSembunyikanDiv')){
                                    $(window.parent.document).find('#idDivNavigasi').fadeOut().removeClass('clsSembunyikanDiv');
                                    $(window.parent.document).find('#idDivNavigasi').fadeIn().addClass('clsTampilkanDiv');
                                }
                                /* hapus baris tabel */
                                //$(window.parent.document).find("#idDivTabelData").attr('style','display:inline');
                                $(window.parent.document).find('#idTabelData tbody tr').remove();
                                
                                /* parsing data JSON */
                                var oData = jQuery.parseJSON(vArrDataSvr[1].trim());
                                var i = 0;
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    //console.log(el.kode);
                                    //console.log(el.nama);
                                    i += 1;
                                    var vWarnaTr = (i%2==0) ? 'clsTrWarna' : 'clsTrBiasa';
                                    
                                    if(i<vFJumData && i != vArrDataSvr[2]){
                                        $(window.parent.document).find('#idTabelData > tbody:last').append('<tr class=\"'+ vWarnaTr + '\">' + 
                                            '<td class=\"clsTdCb\"><input type=\"checkbox\" name=\"nmArrKodeCb[]\" value=\"' + el.kode + '\"></td>'+
                                            '<td class=\"clsTdNomor\">' + (i + ((vFNoHalaman-1)*vFJumData)) + '.</td>'+
                                            '<td>' + el.kode + '</td>'+
                                            '<td class=\"clsTdNama\">' + el.nama + '</td>'+
                                            '<td class=\"clsTdTombolUploadFoto\"><button class=\"clsTombolUploadFoto shrink\" style=\"display:none\" value=\"'+ el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolUploadFoto.png\"></button></td>'+
                                            '<td class=\"clsTdTombolHapus\"><button class=\"clsTombolHapus\" style=\"display:none\" value=\"'+ el.kode + '\"><img class=\"clsGbrTombol\" src=\"${URLModAdpubGambarTombol}/tombolHapus.png\"></button></td>'+
                                            '<td class=\"clsTdTombolUbah\"><button class=\"clsTombolUbah\" style=\"display:none\" value=\"' + el.kode + '\"><img class=\"clsGbrTombol\" src=\"${URLModAdpubGambarTombol}/tombolUbah.png\"></button></td>'+
                                            '</tr>');
                                    }
                                    if(i>=vFJumData || i == vArrDataSvr[2]){
                                        $('#idTabelData > tbody:last').append('<tr class=\"'+ vWarnaTr + '\">' + 
                                            '<td class=\"clsTdCb clsTdCbAkhir\"><input type=\"checkbox\" name=\"nmArrKodeCb[]\" value=\"' + el.kode + '\"></td>'+
                                            '<td class=\"clsTdNomor clsTdAkhir\">' + (i + ((vFNoHalaman-1)*vFJumData)) + '.</td>'+
                                            '<td class=\"clsTdAkhir\">' + el.kode + '</td>'+
                                            '<td class=\"clsTdNama clsTdAkhir\">' + el.nama + '</td>'+
                                            '<td class=\"clsTdTombolUploadFoto\"><button class=\"clsTombolUploadFoto shrink\" style=\"display:none\" value=\"'+ el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolUploadFoto.png\"></button></td>'+
                                            '<td class=\"clsTdTombolHapus clsTdAkhir\"><button class=\"clsTombolHapus shrink\" style=\"display:none\" value=\"'+ el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolHapus.png\"></button></td>'+
                                            '<td class=\"clsTdTombolUbah clsTdTambahAkhir\"><button class=\"clsTombolUbah shrink\" style=\"display:none\" value=\"' + el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolUbah.png\"></button></td>'+
                                            '</tr>');
                                    }
                                });
                                
                            }
                           
                            //console.log("vArrDataSvr[0]: " + vArrDataSvr[0]);
                            if(parseInt(vArrDataSvr[0]) == parseInt(0)){
                                /* sembunyikan tampilan tabel */
                                $(window.parent.document).find("#idDivTabelData").removeClass('clsTampilkanDiv').addClass('clsSembunyikanDiv');
                                /* sembunyikan tampilan pencarian */
                                $(window.parent.document).find("#idDivCari").removeClass('clsTampilkanDiv').addClass('clsSembunyikanDiv');
                                /* sembunyikan tampilan navigasi */
                                $(window.parent.document).find("#idDivNavigasi").removeClass('clsTampilkanDiv').addClass('clsSembunyikanDiv');
                                /* tampilkan tombol tambah */
                                $(window.parent.document).find("#idDivTambah48").removeClass('clsSembunyikanDiv').addClass('clsTampilkanDiv');
                                $(window.parent.document).find("#idDivTambah48").fadeIn().show();
                            }
                       });

                       /* permintaan gagal */
                       vReqDataTabel.fail(function(e, textStatus){
                            //console.log(e);
                       });
                    };
                    
                    /* [F3] fTombolNavigasiTampil: kelakuan tombol navigasi */
                    function  fTombolNavigasiTampil(vFNoHalaman,vFNoHalamanMaks){
                        //console.log("fTombolNavigasiTampil >> " + vFNoHalaman + " # " + vFNoHalamanMaks);
                        /* bila berada di halaman awal  */
                        if(parseInt(vFNoHalaman) == 1){
                            /* bila jumlah halaman maks = 1 */
                            if(vFNoHalamanMaks == 1){
                                //console.log("Berada di halaman 1.");
                                $(window.parent.document).find('.clsTombolNavSebelum').attr('style','display:none');
                                $(window.parent.document).find('.clsTombolNavBerikut').attr('style','display:none');
                            }
                            
                            if(vFNoHalamanMaks > 1){
                                $(window.parent.document).find('.clsTombolNavBerikut').removeAttr('style','display:none');
                                $(window.parent.document).find('.clsTombolNavBerikut').attr('src','${URLModAdpubGambarTombol}/tombolBerikut24.png');
                            }
                        }
                        
                        /* bila berada di halaman akhir */
                        if(parseInt(vFNoHalaman) == parseInt(vFNoHalamanMaks)){
                            //console.log("Berada di halaman akhir.");
                            $(window.parent.document).find('.clsTombolNavBerikut').attr('style','display:none');
                        }
                        
                        /* bila berada di antara halaman 1 dan akhir */
                        if(parseInt(vFNoHalaman) > 1 && parseInt(vFNoHalaman) < parseInt(vFNoHalamanMaks)){
                            //console.log("Berada di halaman antara 1 s.d. akhir.");
                            /* tampilkan tombol sebelum */
                            $(window.parent.document).find('.clsTombolNavSebelum').removeAttr('style','display:none');
                            /* tampilkan tombol berikut */
                            $(window.parent.document).find('.clsTombolNavBerikut').removeAttr('style','display:none');
                        }
                    }
                    
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
                    
                    /* {SELECT CHANGE} */
                    /* 1) Negara */
                    $('#idKodeNegaraLahir').on('change', function() {
                        /* waktu */
                        vWaktu = vTgl.getTime();
                        var vKodeNegara = this.value;
                        /* req ajax mengambil data provinsi */
                        /* [1] req. dilakukan */
                        var vReqSimpanData = $.ajax({
                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                            type: "POST",
                            data: { dtOperasi: "s", 
                                dtKodeData: "provinsi",
                                dtKodeRef: vKodeNegara
                            },
                            dataType: "html"
                        });


                        /* [2] req. selesai */
                        vReqSimpanData.done(function(vFDataSvr){
                            /* [#] notifikasi */
                            /* masukkan data provinsi keluaran proses.jsp ke select */
                            var vArrDataSvr = [];

                            if(vFDataSvr.trim() != ""){
                                vArrDataSvr = vFDataSvr.split('@');
                            }

                            //console.log("vArrDataSvr[0]: " + vArrDataSvr[0]);
                            if(vFDataSvr.trim() != "" && parseInt(vArrDataSvr[0]) > parseInt(0)){
                                /* parsing data JSON */
                                var oData = jQuery.parseJSON(vArrDataSvr[1].trim());

                                /* hapus option dalam select */
                                $('#idKodeProvinsiLahir option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* option awal */
                                $('#idKodeProvinsiLahir').append(
                                        $('<option>', { 
                                            value: '',
                                            text : 'Pilih Provinsi' 
                                                      }
                                        )
                                );
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    $('#idKodeProvinsiLahir').append(
                                        $('<option>', { 
                                            value: el.kode,
                                            text : el.kode + " " + el.nama 
                                                      }
                                        )
                                    );
                                });
                            }else{
                                /* hapus option dalam select: provinsi */
                                $('#idKodeProvinsiLahir option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kabupaten */
                                $('#idKodeKabupatenLahir option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kecamatan */
                                $('#idKodeKecamatanLahir option').each(function() {
                                    $(this).remove();
                                });
                            }
                        });

                        /* [3] req. gagal */
                        vReqSimpanData.fail(function(e, textStatus ) {
                            alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        });
                    });
                    
                    /* 2) Provinsi */
                    $('#idKodeProvinsiLahir').on('change', function() {
                        /* waktu */
                        vWaktu = vTgl.getTime();
                        var vKodeNegara =   $('#idKodeNegaraLahir :selected').val();
                        var vKodeProvinsi = this.value;
                        /* req ajax mengambil data provinsi */
                        /* [1] req. dilakukan */
                        var vReqSimpanData = $.ajax({
                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                            type: "POST",
                            data: { dtOperasi: "s", 
                                dtKodeData: "kabupaten",
                                dtKodeRef: vKodeNegara + "#" + vKodeProvinsi,
                            },
                            dataType: "html"
                        });


                        /* [2] req. selesai */
                        vReqSimpanData.done(function(vFDataSvr){
                            /* [#] notifikasi */
                            /* masukkan data provinsi keluaran proses.jsp ke select */
                            var vArrDataSvr = [];

                            if(vFDataSvr.trim() != ""){
                                vArrDataSvr = vFDataSvr.split('@');
                            }

                            //console.log("vArrDataSvr[0]: " + vArrDataSvr[0]);
                            if(vFDataSvr.trim() != "" && parseInt(vArrDataSvr[0]) > parseInt(0)){
                                /* parsing data JSON */
                                var oData = jQuery.parseJSON(vArrDataSvr[1].trim());

                                /* hapus option dalam select */
                                $('#idKodeKabupatenLahir option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* option awal */
                                $('#idKodeKabupatenLahir').append(
                                        $('<option>', { 
                                            value: '',
                                            text : 'Pilih Kabupaten' 
                                                      }
                                        )
                                );
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    $('#idKodeKabupatenLahir').append(
                                        $('<option>', { 
                                            value: el.kode,
                                            text : el.kode + " " + el.nama 
                                                      }
                                          )
                                    );
                                });
                            }else{
                                /* hapus option dalam select: kabupaten */
                                $('#idKodeKabupatenLahir option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kecamatan */
                                $('#idKodeKecamatanLahir option').each(function() {
                                    $(this).remove();
                                });
                            }
                        });

                        /* [3] req. gagal */
                        vReqSimpanData.fail(function(e, textStatus ) {
                            alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        });
                    });
                    
                    /* 3) Kabupaten */
                    $('#idKodeKabupatenLahir').on('change', function() {
                        /* waktu */
                        vWaktu = vTgl.getTime();
                        var vKodeNegara = $('#idKodeNegaraLahir :selected').val();
                        var vKodeProvinsi = $('#idKodeProvinsiLahir :selected').val();
                        var vKodeKabupaten = this.value;
                        /* req ajax mengambil data provinsi */
                        /* [1] req. dilakukan */
                        var vReqSimpanData = $.ajax({
                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                            type: "POST",
                            data: { dtOperasi: "s", 
                                dtKodeData: "kecamatan",
                                dtKodeRef: vKodeNegara + "#" + vKodeProvinsi+ "#" + vKodeKabupaten,
                            },
                            dataType: "html"
                        });


                        /* [2] req. selesai */
                        vReqSimpanData.done(function(vFDataSvr){
                            /* [#] notifikasi */
                            /* masukkan data provinsi keluaran proses.jsp ke select */
                            var vArrDataSvr = [];

                            if(vFDataSvr.trim() != ""){
                                vArrDataSvr = vFDataSvr.split('@');
                            }

                            //console.log("vArrDataSvr[0]: " + vArrDataSvr[0]);
                            if(vFDataSvr.trim() != "" && parseInt(vArrDataSvr[0]) > parseInt(0)){
                                /* parsing data JSON */
                                var oData = jQuery.parseJSON(vArrDataSvr[1].trim());

                                /* hapus option dalam select */
                                $('#idKodeKecamatanLahir option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* option awal */
                                $('#idKodeKecamatanLahir').append(
                                        $('<option>', { 
                                            value: '',
                                            text : 'Pilih Kecamatan' 
                                                      }
                                        )
                                );
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    $('#idKodeKecamatanLahir').append(
                                        $('<option>', { 
                                            value: el.kode,
                                            text : el.kode + " " + el.nama 
                                                      }
                                          )
                                    );
                                });
                            }else{
                                /* hapus option dalam select */
                                $('#idKodeKecamatanLahir option').each(function() {
                                    $(this).remove();
                                });
                            }
                        });

                        /* [3] req. gagal */
                        vReqSimpanData.fail(function(e, textStatus ) {
                            alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        });
                    });

                });
            //]]>     
	</script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
    <div class="clsModalIsi">
        <div class="clsModalJudul">
            <button type="button" class="close" onclick="Custombox.close();">&times;</button>
            <h4><img src="${URLModAdpubGambarData}/${vHTMLGambarIcon}"/> &nbsp; <strong>${vHTMLOperasi} Data ${vModKonfNamaData}</strong></h4>
        </div>
        <div class="clsModalBody">
            <center>
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            ${vHTMLForm}
            </center>
        </div>
    </div>
  </jsp:attribute>
</admin:modal>