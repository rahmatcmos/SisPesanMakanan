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
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* {VARIABEL} */
    String vGetOperasi = oKata.fHapusSpasi(request.getParameter("o")),
        vHTMLModKonfNamaData = vModKonfNamaData,
        vHTMLGambarIcon = "", 
        vHTMLDataOperasi = "", 
        vHTMLOperasi = "",
        vHTMLForm = "",
        vKode = "", 
        vKodeKaryawan = "",
        vNama = "", 
        vCatatan = "",
        vKodeJenisOperator = "",
        vSandi = "",
        vAktif = "";
    
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
                new String[]{"kode","nama","sandi","catatan","kode_resto_karyawan","kode_resto_jenis_operator","aktif"}, 
                new String[]{"kode",vGetKode},
                "nomor", "DESC", new String[]{"0","1"},"=");
        
        /* data nantinya ditampilkan di-form */
        while(vArrHasil.next()){
            vKode = vArrHasil.getString("kode");
            vNama = vArrHasil.getString("nama");
            vKodeJenisOperator = vArrHasil.getString("kode_resto_jenis_operator");
            vSandi = vArrHasil.getString("sandi");
            vCatatan = vArrHasil.getString("catatan");
            vKodeKaryawan = vArrHasil.getString("kode_resto_karyawan");
            vAktif = vArrHasil.getString("aktif");
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
        String vKodeAcak = vModKonfKodeAwal + oKode.fBuatKodeAcak(6).toUpperCase();
        /* kode acak yang baru ditampilkan pada saat operasi penambahan data */
        vKode = (vGetOperasi.equals("t")) ? vKodeAcak : vKode;
        
        /* {DATA TAMBAHAN} */
        /* -------------------------------- */
        String vSelJenisOperator = "";
        
        /* A) operasi tambah data */
        if(vGetOperasi.equals("t")){
            /* 1) departemen */
            vSelJenisOperator = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_resto_jenis_operator", "");
            /* 2) aktif */
            vAktif = "@1&Ya#0&Tidak";
        }
        
        /* B) operasi ubah data */
        if(vGetOperasi.equals("u")){
            /* 1) jenis operator */
            vSelJenisOperator = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_resto_jenis_operator", vKodeJenisOperator);
            /* 2) aktif */
            StringBuilder vSbJK = new StringBuilder();
            if(vAktif.equals("1")){
                vSbJK.append("@");
                vSbJK.append(vAktif);
                vSbJK.append("&Ya#0&Tidak");
            }else{
                vSbJK.append("1&Ya#");
                vSbJK.append("@");
                vSbJK.append(vAktif);
                vSbJK.append("&Tidak");
            }
            vAktif = vSbJK.toString();
        }
        /* -------------------------------- */
        
        /* {FORM} */
        vHTMLForm = oForm.fForm("POST", "#", 
            new String[]{"Kode", "Kode Karyawan","Nama " + vModKonfNamaData,"Jenis Operator","Sandi","Aktif","Catatan"}, 
            new String[]{"!Kode", ">KodeKaryawan",">Nama","KodeJenisOperator","Sandi","Aktif","Catatan"}, 
            new String[]{"@t","@t","@t","s","@p","r","a"}, 
            new String[]{vKode,vKodeKaryawan,vNama,vSelJenisOperator,vSandi,vAktif,vCatatan}, 
            oForm.fTombol("bt", "idTombolSimpan","Simpan","tombolAjaxSimpan.png"),
            "idFormOperator", 
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
                "idFormKabupaten", 
                "clsForm",
                new String[]{"idKode",vGetKodeHapus});
    }
    
    
    /* variabel tag */
    request.setAttribute("vHTMLForm", vHTMLForm); 
    request.setAttribute("vHTMLOperasi", vHTMLOperasi); 
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vHTMLDataOperasi", vHTMLDataOperasi);
    
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/admin/modul/modRestoOperator" prefix="admin" %>
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
                        var vKodeKaryawan = $('#idKodeKaryawan').val();
                        var vNama = $('#idNama').val();
                        var vCatatan = $('#idCatatan').val();
                        var vKodeJenisOperator = $('#idKodeJenisOperator').val();
                        var vSandi = $('#idSandi').val();
                        var vAktif = $("input[name=nmAktif]:checked").val();
                        
                        /* bila kode dan nama diisi */
                        if(vKode != "" && vNama != ""){
                            /* tampilkan animasi gif */
                            $("#idGbrTombol").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');

                            /* [1] req. dilakukan */
                            var vReqSimpanData = $.ajax({
                                url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: vOperasi, 
                                    dtKode : vKode,
                                    dtKodeKaryawan : vKodeKaryawan, 
                                    dtNama : vNama,
                                    dtCatatan: vCatatan,
                                    dtKodeJenisOperator: vKodeJenisOperator,
                                    dtSandi: vSandi,
                                    dtAktif: vAktif
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
                                        $('#idNama').val('');
                                        $('#idKodeKaryawan').val('');
                                        $('#idSandi').val('');
                                        /* set fokus pada kolom berikut */
                                        $('#idNama').focus();
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
                    
                    /* I[1] : kode orang > click */
                    $('#idKodeKaryawan').click(function(e){
                        e.preventDefault();
                        
                        vWaktu = vTgl.getTime();
                    
                        /* menampilkan halaman dalam bentuk modal */
                        Custombox.open({
                            target: '${URLModAdmin}/modRestoModalKaryawan/modal.jsp?o=t&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            overlayClose: false
                        });
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
                    
                    /* select change */
                    $('#idKodeDepartemen').on('change', function() {
                        /* waktu */
                        vWaktu = vTgl.getTime();
                        var vKodeDepartemen = this.value;
                        /* req ajax mengambil data provinsi */
                        /* [1] req. dilakukan */
                        var vReqSimpanData = $.ajax({
                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                            type: "POST",
                            data: { dtOperasi: "s", 
                                dtKodeData: "pekerjaan",
                                dtKodeRef: vKodeDepartemen
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
                                $('#idKodePekerjaan option').each(function() {
                                    $(this).remove();
                                });

                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    $('#idKodePekerjaan').append(
                                        $('<option>', { 
                                            value: el.kode,
                                            text : el.kode + " " + el.nama 
                                                      }
                                          )
                                    );
                                });
                            }else{
                                /* hapus option dalam select */
                                $('#idKodePekerjaan option').each(function() {
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