<%@page import="pilar.cls.ClsPelanggan"%>
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
    String vGetKodeOrang = oKata.fHapusSpasi(request.getParameter("k"));
    String vGetOperasi = oKata.fHapusSpasi(request.getParameter("o")),
        vHTMLModKonfNamaData = vModKonfNamaData,
        vHTMLGambarIcon = "", 
        vHTMLDataOperasi = "", 
        vHTMLOperasi = "",
        vHTMLForm = "",
        vLintangResto = "",
        vBujurResto = "",
        vLintang = "",
        vBujur = "",
        vKodeNegara = "",
        vKodeProvinsi = "",
        vKodeKabupaten = "",
        vKodeKecamatan = "",
        vCatatan = "";
    
    /* {OPERASI DATA} */
    
    /* [OD1] operasi ubah (+/-) data */
    if(vGetOperasi.equals("u")){
        vHTMLOperasi = "Ubah";
        /* ambil data lintang dan bujur lokasi restoran */
        vLintangResto = oOpsBasisdata.fAmbilSatuData("", "", "tb_pengaturan_lokasi", "lintang", "nomor", "1");
        vBujurResto = oOpsBasisdata.fAmbilSatuData("", "", "tb_pengaturan_lokasi", "bujur", "nomor", "1");
        
        /* ambil data lintang dan bujur lokasi pelanggan */
        ResultSet vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", 
                "", 
                "tb_lokasi_pelanggan", 
                new String[]{"lintang","bujur","kode_geo_negara","kode_geo_provinsi","kode_geo_kabupaten","kode_orang","catatan"}, 
                new String[]{"kode_orang",vKodeOrang},
                "nomor", "DESC", new String[]{"0","1"},"=");
        
        /* data nantinya ditampilkan di-form */
        while(vArrHasil.next()){
            vLintang = vArrHasil.getString("lintang");
            vBujur = vArrHasil.getString("bujur");
            vKodeNegara = vArrHasil.getString("kode_geo_negara");
            vKodeProvinsi = vArrHasil.getString("kode_geo_provinsi");
            vKodeKabupaten = vArrHasil.getString("kode_geo_kabupaten");
            vKodeOrang = vArrHasil.getString("kode_orang");
            vCatatan = vArrHasil.getString("catatan");
        }
        
        /* gambar icon */
        vHTMLGambarIcon = "lokasi.png";
        vHTMLDataOperasi = "u";
    }
    
    
    /* {FORM DATA} */
    /* [FD1] form pada operasi tambah dan ubah data */
    if(vGetOperasi.equals("u")){
        
        /* {DATA TAMBAHAN} */
        /* -------------------------------- */
        String vSelNegara = "";
        String vSelProvinsi = "";
        String vSelKabupaten = "";
        
        /* B) operasi ubah data */
        if(vGetOperasi.equals("u")){
            /* 1) negara */
            vSelNegara = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_negara", vKodeNegara);
            /* 2) provinsi */
            vSelProvinsi = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_provinsi", vKodeProvinsi);
            /* 3) kabupaten */
            vSelKabupaten = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_kabupaten", vKodeKabupaten);
        }
        /* -------------------------------- */
        
        /* {FORM} */
        vHTMLForm = oForm.fForm("POST", "#", 
            new String[]{"Lintang", "Bujur","Negara","Provinsi","Kabupaten","Catatan"}, 
            new String[]{"Lintang", "Bujur","KodeNegara","KodeProvinsi","KodeKabupaten","Catatan"}, 
            new String[]{"@t","@t","s","s","s","a"}, 
            new String[]{vLintang,vBujur,vSelNegara,vSelProvinsi,vSelKabupaten,vCatatan}, 
            oForm.fTombol("bt", "idTombolSimpan","Simpan","tombolAjaxSimpan.png"),
            "idFormPengaturanLokasi", 
            "clsForm");
     }
    
    /* variabel tag */
    request.setAttribute("vHTMLForm", vHTMLForm); 
    request.setAttribute("vHTMLOperasi", vHTMLOperasi); 
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vHTMLDataOperasi", vHTMLDataOperasi);
    request.setAttribute("vLintangResto", vLintangResto);
    request.setAttribute("vBujurResto", vBujurResto);
    request.setAttribute("vLintang", vLintang);
    request.setAttribute("vBujur", vBujur);
    request.setAttribute("vGetKodeOrang",vKodeOrang);
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/publik/modul/modHalamanLokasi" prefix="publik" %>
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
                    var vLintang = '${vLintang}';
                    var vBujur = '${vBujur}';
                    
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
                        var vKodeNegara = $('#idKodeNegara').val();
                        var vKodeProvinsi = $('#idKodeProvinsi').val();
                        var vKodeKabupaten = $('#idKodeKabupaten').val();
                        var vKodeOrang = '${vGetKodeOrang}';
                        var vLintang = $('#idLintang').val();
                        var vBujur = $('#idBujur').val();
                        var vCatatan = $('#idCatatan').val();
                        
                        /* bila kode dan nama diisi */
                        if(vLintang != "" && vBujur != ""){
                            /* tampilkan animasi gif */
                            $("#idGbrTombol").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');

                            /* [1] req. dilakukan */
                            var vReqSimpanData = $.ajax({
                                url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: vOperasi, 
                                    dtLintang : vLintang, 
                                    dtBujur : vBujur,
                                    dtKodeNegara: vKodeNegara,
                                    dtKodeProvinsi: vKodeProvinsi,
                                    dtKodeKabupaten: vKodeKabupaten,
                                    dtKodeOrang: vKodeOrang,
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

                    /* {SELECT CHANGE} */
                    /* 1) Negara */
                    $('#idKodeNegara').on('change', function() {
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
                                $('#idKodeProvinsi option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* option awal */
                                $('#idKodeProvinsi').append(
                                        $('<option>', { 
                                            value: '',
                                            text : 'Pilih Provinsi' 
                                                      }
                                        )
                                );
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    $('#idKodeProvinsi').append(
                                        $('<option>', { 
                                            value: el.kode,
                                            text : el.kode + " " + el.nama 
                                                      }
                                        )
                                    );
                                });
                            }else{
                                /* hapus option dalam select: provinsi */
                                $('#idKodeProvinsi option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kabupaten */
                                $('#idKodeKabupaten option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kecamatan */
                                $('#idKodeKecamatan option').each(function() {
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
                    $('#idKodeProvinsi').on('change', function() {
                        /* waktu */
                        vWaktu = vTgl.getTime();
                        var vKodeNegara =   $('#idKodeNegara :selected').val();
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
                                $('#idKodeKabupaten option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* option awal */
                                $('#idKodeKabupaten').append(
                                        $('<option>', { 
                                            value: '',
                                            text : 'Pilih Kabupaten' 
                                                      }
                                        )
                                );
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    $('#idKodeKabupaten').append(
                                        $('<option>', { 
                                            value: el.kode,
                                            text : el.kode + " " + el.nama 
                                                      }
                                          )
                                    );
                                });
                            }else{
                                /* hapus option dalam select: kabupaten */
                                $('#idKodeKabupaten option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kecamatan */
                                $('#idKodeKecamatan option').each(function() {
                                    $(this).remove();
                                });
                            }
                        });

                        /* [3] req. gagal */
                        vReqSimpanData.fail(function(e, textStatus ) {
                            alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        });
                    });
                    
                    /* ######### peta */
                    var vMap;
                    var vDirectionsService = new google.maps.DirectionsService();
                    var vDirectionsDisplay;
                    var vPusatKoordinat;
                    var vPenandaTempat;
                    var vPenandaHasilCari;
                    /* data dari basisdata */
                    var vLintangResto = '${vLintangResto}';
                    var vBujurResto = '${vBujurResto}';
                    
                    /* koordinat awal: lokasi resto */
                    var vLintangAwal = (vLintang == "") ? '${vLintangResto}' : '${vLintang}'; /* lat */
                    var vBujurAwal = (vBujur == "") ?'${vBujurResto}': '${vBujur}'; /* long */

                    /* muat google maps */
                    google.maps.event.addDomListener(window, 'load', fInisialisasiPeta(vLintangAwal,vBujurAwal,vLintangResto,vBujurResto,18)); 

                    /* ketika kolom lintang di-blur */
                    $('#idLintang').blur(function(e){
                        e.preventDefault();
                        /* muat google maps */
                        if($('#idBujur').val() != ""){
                            google.maps.event.addDomListener(window, 'load', fInisialisasiPeta($("#idLintang").val(),$("#idBujur").val(),vLintangResto,vBujurResto,18));
                        }
                    });

                    /* ketika kolom bujur di-blur */
                    $('#idBujur').blur(function(e){
                        e.preventDefault();
                        /* muat google maps */
                        if($('#idLintang').val() != ""){
                            google.maps.event.addDomListener(window, 'load', fInisialisasiPeta($("#idLintang").val(),$("#idBujur").val(),vLintangResto,vBujurResto,18));
                        }
                    });
                    
                    if($('#idLintang').val() != '' && $('#idBujur').val() != ''){
                        google.maps.event.addDomListener(window, 'load', fInisialisasiPeta($("#idLintang").val(),$("#idBujur").val(),vLintangResto,vBujurResto,18));
                    }

                    var vArrCakupanTempat;
                    var vArrPenandaTempat = [];
                    /* fungsi inisialisasi peta */
                    function fInisialisasiPeta(vFLintang,vFBujur,vFLintangResto,vFBujurResto,vFZoom) {
                        vPusatKoordinat = new google.maps.LatLng(vFLintang, vFBujur);
                        vDirectionsDisplay = new google.maps.DirectionsRenderer();
                        /* opsi peta */
                        var vOpsiPeta = {
                            zoom: vFZoom,
                            center: vPusatKoordinat,
                            scrollwheel: true,
                            mapTypeId: google.maps.MapTypeId.ROADMAP,
                            mapTypeControl: true,
                            mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DEFAULT },
                            navigationControl: true,
                            navigationControlOptions: {style: google.maps.NavigationControlStyle.DEFAULT }
                        };

                        /* objek peta */
                        vMap = new google.maps.Map(document.getElementById('idPetaKanvasModal'),vOpsiPeta);

                        // {AWAL}
                        /* penanda */
                        vPenandaTempat = new google.maps.Marker({
                                draggable: true,
                                map: vMap,
                                icon: '${URLModAdpubGambarPeta}/lokasiTanda.png',
                                animation: google.maps.Animation.DROP,
                                position: vPusatKoordinat
                            });
                        vArrPenandaTempat = [];
                        /* membuat kolom pencarian */
                        var vMasukanPencarian = /** @type {HTMLInputElement} */(document.getElementById('pac-input'));
                        vMap.controls[google.maps.ControlPosition.TOP_LEFT].push(vMasukanPencarian);

                        /* hasil pencarian */
                        var searchBox = new google.maps.places.SearchBox(
                            /** @type {HTMLInputElement} */(vMasukanPencarian));

                        // {MENCARI LOKASI}
                        // Listen for the event fired when the user selects an item from the
                        // pick list. Retrieve the matching places for that item.
                        google.maps.event.addListener(searchBox, 'places_changed', function() {
                            var vArrTempat = searchBox.getPlaces();

                            if (vArrTempat.length == 0) {
                                return;
                            }

                            for (var i = 0, vPenandaHasilCari; vPenandaHasilCari = vArrPenandaTempat[i]; i++) {
                                vPenandaHasilCari.setMap(null);
                            }

                            /* untuk setiap tempat, berikan icon, nama tempat, dan lokasi */
                            vArrPenandaTempat = [];
                            vArrCakupanTempat = new google.maps.LatLngBounds();
                            for (var i = 0, vTempat; vTempat = vArrTempat[i]; i++) {

                                /* buat penanda untuk setiap tempat */
                                vPenandaTempat = new google.maps.Marker({
                                    map: vMap,
                                    zoom: 10,
                                    icon: '${URLModAdpubGambarPeta}/lokasiTanda.png',
                                    title: vTempat.name,
                                    position: vTempat.geometry.location,
                                    draggable: true,
                                    animation: google.maps.Animation.DROP,
                                    idLokasi: 'idLokasi' + i
                                });

                                vArrPenandaTempat.push(vPenandaTempat);                    
                                vArrCakupanTempat.extend(vTempat.geometry.location);

                                google.maps.event.addListener(vPenandaTempat,'dragend',function() {
                                    var vIdLokasi = this.idLokasi;
                                    var lat = document.getElementById('lat_' + vIdLokasi);
                                    var lng = document.getElementById('lng_' + vIdLokasi);

                                    var vLintangBujur = this.getPosition();

                                    $("#idLintang").val(vLintangBujur.lat());
                                    $("#idBujur").val(vLintangBujur.lng());
                                    console.log('vArrPenandaTempat ID -> ' + vPenandaTempat.idLokasi);
                                    fBuatRute(vFLintangResto,vFBujurResto,$('#idLintang').val(),$('#idBujur').val());
                                });
                            }

                            vMap.fitBounds(vArrCakupanTempat);
                        });
                        /* {AKHIR MENCARI LOKASI} */

                        // Bias the SearchBox results towards places that are within the bounds of the
                        // current map's viewport.
                        google.maps.event.addListener(vMap, 'bounds_changed', function() {
                            var vArrCakupanTempat = vMap.getBounds();
                            searchBox.setBounds(vArrCakupanTempat);
                        });            

                        google.maps.event.addListener(vPenandaTempat,'dragend',function() {
                            var vLintangBujur = vPenandaTempat.getPosition();
                            $("#idLintang").val(vLintangBujur.lat());
                            $("#idBujur").val(vLintangBujur.lng());
                            fBuatRute(vFLintangResto,vFBujurResto,$('#idLintang').val(),$('#idBujur').val());
                        });

                        google.maps.event.trigger(vPenandaTempat,"click");
                    }
                    
                    /* fToogleBounce: membuat animasi bounce pada marker */
                    function fToggleBounce(vFMarker) {
                      if (vFMarker.getAnimation() != null) {
                        vFMarker.setAnimation(null);
                      } else {
                        vFMarker.setAnimation(google.maps.Animation.BOUNCE);
                      }
                    }
                    
                    function fBuatRute(vFLintangResto,vFBujurResto,vFLintangPelanggan,vFBujurPelanggan){
                        //console.log('vArrPenandaTempat ID -> ' + vPenandaTempat.idLokasi);
                        var vKoordResto = new google.maps.LatLng(vFLintangResto,vFBujurResto);
                        var vKoordPelanggan = new google.maps.LatLng(vFLintangPelanggan,vFBujurPelanggan);
                        /* 1) hitung jarak titik resto dengan titik lokasi pelanggan */
                        var vJarakRestoPelanggan = google.maps.geometry.spherical.computeDistanceBetween(vKoordResto, 
                            vKoordPelanggan);
                            
                        console.log("Jarak lokasi resto-pelanggan: " + vJarakRestoPelanggan);
                        var vIntJarakRP = parseInt(vJarakRestoPelanggan);
                        
                        if(vIntJarakRP > 10000){
                            $('#idPesanModal').html("Maaf, lokasi pengantaran Anda belum dapat kami layani.<br>" +
                                    "Batas pelayanan antar kami sejauh radius 10 km dari lokasi kami."
                                );
                            /* tampilkan pesan */
                            $('#idPesanModal').addClass("clsTampilkanDiv");
                            $('#idPesanModal').removeClass("clsSembunyikanDiv");
                        }else{
                            /* tampilkan pesan */
                            $('#idPesanModal').removeClass("clsTampilkanDiv");
                            $('#idPesanModal').addClass("clsSembunyikanDiv");
                        }
                            
                        /*2)  membuat rute */
                        var bounds = new google.maps.LatLngBounds();
                        bounds.extend(vKoordResto);
                        bounds.extend(vKoordPelanggan);

                        vMap.fitBounds(bounds);
                        var request = {
                            origin: vKoordResto,
                            destination: vKoordPelanggan,
                            travelMode: google.maps.TravelMode.DRIVING
                        };
                            
                        vDirectionsService.route(request, function (response, status) {
                            if (status == google.maps.DirectionsStatus.OK) {
                                vDirectionsDisplay.setDirections(response);
                                vDirectionsDisplay.setMap(vMap);
                                /* marker */
                                var vArrLeg = response.routes[ 0 ].legs[ 0 ];
                                //fBuatMarker(vArrLeg.start_location, '', 'Restoran' );
                                //fBuatMarker(vArrLeg.end_location, '', 'Pelanggan' );
                                $('#idCatatan').val(vArrLeg.end_address);
                            } else {
                                alert("Directions Request from " + vKoordResto.toUrlValue(6) + " to " + vKoordPelanggan.toUrlValue(6) + " failed: " + status);
                            }
                        });
                    }
                    /* fBuatMarker: membuat marker */
                    function fBuatMarker(vFPosisi, vFIcon, vFTitle) {
                        new google.maps.Marker({
                            position: vFPosisi,
                            map: vMap,
                            icon: vFIcon,
                            title: vFTitle
                        });
                    }

                    
                });
            //]]>     
	</script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
    <div class="clsModalIsi">
        <div class="clsModalJudul">
            <button type="button" class="close" onclick="Custombox.close();">&times;</button>
            <h4><img src="${URLModAdpubGambarMenu}/lokasi.png"/> &nbsp; <strong>${vHTMLOperasi} Data ${vModKonfNamaData}</strong></h4>
        </div>
        <div class="clsModalBody">
            <center>
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            
            <input id="pac-input" class="controls" type="text" placeholder="Pencarian Lokasi">
            <div id="idPetaKanvasModal"></div>
            ${vHTMLForm}
            </center>
        </div>
    </div>
  </jsp:attribute>
</publik:modal>