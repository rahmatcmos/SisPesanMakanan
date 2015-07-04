<%@page import="pilar.cls.ClsPelanggan"%>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 

    /* memeriksa sesi halaman pengguna */
    ClsKonf oKonf = new ClsKonf();
    ClsPelanggan oPelanggan = new ClsPelanggan();
    ClsOperasiBasisdata oOpsBasisdataSesi = new ClsOperasiBasisdata();
    String vNamaPelanggan = "";
    String vKodeOrang = "";
    
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
    
    /* variabel untuk diselipkan pada HTML/Javascript 
     * nilainya diambil dari berkas jsp ini/lain
     * bentuk penyelipannya pada HTML: ${vModKonfNamaData}
     */
    request.setAttribute("vModKonfNamaData", vModKonfNamaData);
    request.setAttribute("vModKonfIcon", vModKonfIcon); 
    request.setAttribute("vModKonfBanyakTampilanData", vModKonfBanyakTampilanData);
    
    /* kode produk */
    ClsOlahKata oOlahKata = new ClsOlahKata();
    String vGetKodeProduk = "";
    request.setAttribute("vGetKodeProduk", vGetKodeProduk);
    
    /* ambil nama produk */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    String vNamaProduk = oOpsBasisdata.fAmbilSatuData("", "", 
            "tb_resto_produk", "nama", "kode", vGetKodeProduk);
    
    /* option menu */
    StringBuilder oSbOpsiMenu = new StringBuilder();
    
    ResultSet oArrOpsiMenu = oOpsBasisdata.fArrAmbilDataDbStd("", "", "tb_resto_jenis_produk", new String[]{"kode","nama"}, "nomor", "ASC", new String[]{""});
    while(oArrOpsiMenu.next()){
        String vKode = oArrOpsiMenu.getString("kode");
        String vNama = oArrOpsiMenu.getString("nama");
        oSbOpsiMenu.append("<option value=\"").append(vKode).append("\">").append(vNama).append("</option>");
    }
    
    /* opsi menu */
    String vOpsiMenu = oSbOpsiMenu.toString();
    
    /* ###### cookie ######### */
    String vNamaCookie = "produk";
    Cookie vArrCookie [] = request.getCookies ();
    Cookie vCookieProduk = null;
    if (vArrCookie != null){
        for (int i = 0; i < vArrCookie.length; i++) 
        {
            if (vArrCookie [i].getName().equals (vNamaCookie)){
                vCookieProduk = vArrCookie[i];
                break;
            }
        }
    }

    String vJumProduk = "";
    String vGambarKeranjang = "";


    if(vCookieProduk != null){
        String[] vArrCookieProduk = vCookieProduk.getValue().split("#");

        String s = vCookieProduk.getValue();
        byte[] b = s.getBytes("UTF-8");
        //System.out.println(b.length);

        if(vArrCookieProduk.length > 0 && !vArrCookieProduk[0].equals("")){
            vJumProduk = String.valueOf(vArrCookieProduk.length);
            //vKeranjangKosong = "style=\"display:none;\"";
            //vKeranjangPenuh = "";
            vGambarKeranjang = "tombolKeranjangPenuh.png";
            
        }
        
        if(vArrCookieProduk.length == 0){
            vJumProduk = "0";
            vGambarKeranjang = "tombolKeranjang.png";
        }
    }
   
    vNamaPelanggan = (vNamaPelanggan.equals("")) ? "Nama" : vNamaPelanggan;
    
    /* mengambil data banner */
    ResultSet oArrGambarBanner = oOpsBasisdata.fArrAmbilDataDbKondisiArr("", 
            "",
            "tb_hlm_banner_foto", 
            new String[]{"kode","nama","nama_berkas","ekstensi"}, 
            new String[]{"sampul"},
            new String[]{"1"},
            "nomor",
            "ASC", 
            new String[]{"0","5"},
            "=");
    
    StringBuilder oSbBannerHTML = new StringBuilder();
    
    oSbBannerHTML.append("<div id=\"idBanner\">");
    oSbBannerHTML.append(System.lineSeparator());
    
    int vB = 0;
    while(oArrGambarBanner.next()){
        String vKode = oArrGambarBanner.getString("kode");
        String vNama = oArrGambarBanner.getString("nama");
        String vNamaBerkas = oArrGambarBanner.getString("nama_berkas");
        String vEkstensi = oArrGambarBanner.getString("ekstensi");
        String vURLGambar = ClsKonf.vKonfURL + "/foto/banner/r" + vNamaBerkas + vEkstensi;
        
        oSbBannerHTML.append("<a href=\"img01_url\" target=\"_blank\">");
        oSbBannerHTML.append("<img src=\"").append(vURLGambar).append("\" alt=\"").append(vNama).append("\">");
        oSbBannerHTML.append("<span>").append(vNama).append("</span>");
        oSbBannerHTML.append("</a>");
        oSbBannerHTML.append(System.lineSeparator());
        vB += 1;
    }
    
    oSbBannerHTML.append("</div>");
    
    String vBannerHTML = (vB > 0) ?  oSbBannerHTML.toString() : "";
    
    /* akhir banner */
    
    /* variabel yg disisipkan pada HTML & JavaScript */
    request.setAttribute("vNamaProduk", vNamaProduk);
    request.setAttribute("vOpsiMenu", vOpsiMenu);
    request.setAttribute("vJumProduk", vJumProduk);
    request.setAttribute("vKodeOrang", vKodeOrang);
    request.setAttribute("vNamaPelanggan", vNamaPelanggan);
    request.setAttribute("vGambarKeranjang", vGambarKeranjang);
    request.setAttribute("vBannerHTML", vBannerHTML);
    
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/publik/modul/modIndex" prefix="publik" %>
<publik:index>
    <jsp:attribute name="atas">
    <link href='http://fonts.googleapis.com/css?family=Lobster' rel='stylesheet' type='text/css'>
    <!-- JS/CSS khusus di sini -->
    <script type="text/javascript">
        //<![CDATA[
            $(document).ready(function() {
                /* ################### {VARIABEL GLOBAL} */
                var vTgl = new Date();
                var vWaktu;
                
                /* ################### {NILAI AWAL VARIABEL} */
                var vBanyakTampilanData = ${vModKonfBanyakTampilanData};
                $('#idNoHalaman').val(0);
                $('#idJumData').val(vBanyakTampilanData);
                $('#idKodeCb').removeAttr('checked');
                
                /* banner */
                $('#idBanner').coinslider({width:790,height:380,delay:3000})
                
                /* memanggil fungsi membuat tabel */
                fBuatTabel(true);
                
                /* ################### {EVENT: MOUSE OVER} */
                /* mouse over pada baris menampilkan tombol ubah dan hapus */
                $(document).on('mouseover', '.clsBerkasFoto', function(e){ 
                    var vIndeks = $(this).attr('alt');
                    //console.log(vIndeks);
                    //$('#idTabelData .clsTdTombolUbah').eq(vIndeks).removeAttr('style');
                    //$('#idTabelData .clsTdTombolHapus').eq(vIndeks).removeAttr('style');
                    //console.log($('.clsTombolUbah').eq(vIndeks).attr('value'));
                    $('.clsTombolFoto').eq(vIndeks).removeAttr('style');
                    $('.clsTombolInfo').eq(vIndeks).removeAttr('style');
                    $('.clsTombolTambah').eq(vIndeks).removeAttr('style');
                });
                
                $(document).on('mouseover', '.clsTautanOpsGaleri', function(e){ 
                    var vIndeks = $(this).attr('rel');
                    //console.log(vIndeks);
                    //$('#idTabelData .clsTdTombolUbah').eq(vIndeks).removeAttr('style');
                    //$('#idTabelData .clsTdTombolHapus').eq(vIndeks).removeAttr('style');
                    //console.log($('.clsTombolUbah').eq(vIndeks).attr('value'));
                    $('.clsTombolFoto').eq(vIndeks).removeAttr('style');
                    $('.clsTombolInfo').eq(vIndeks).removeAttr('style');
                    $('.clsTombolTambah').eq(vIndeks).removeAttr('style');
                });
                
                
                /* ################### {EVENT: MOUSE LEAVE} */
                /* mouse leave pada baris menyembunyikan tombol ubah dan hapus */
                $(document).on('mouseleave', '.clsBerkasFoto', function(e){ 
                    var vIndeks = $(this).attr('alt');
                    $('.clsTombolFoto').eq(vIndeks).attr('style','display:none');
                    $('.clsTombolInfo').eq(vIndeks).attr('style','display:none');
                    $('.clsTombolTambah').eq(vIndeks).attr('style','display:none');
                });
                
                $(document).on('mouseleave', '.clsTautanOpsGaleri', function(e){ 
                    var vIndeks = $(this).attr('rel');
                    $('.clsTombolFoto').eq(vIndeks).attr('style','display:none');
                    $('.clsTombolInfo').eq(vIndeks).attr('style','display:none');
                    $('.clsTombolTambah').eq(vIndeks).attr('style','display:none');
                });
                
                /* ################### {BAGIAN TOMBOL [T]} */
                /* [T1] menambah data: bila belum ada data */
                $('#idTambah48').click(function(e) {
                    /* cegah aksi bawaan */
                    e.preventDefault();
                    vWaktu = vTgl.getTime();
                    
                    /* mengosongkan kolom pencarian */
                    $('#idTeksCari').val('');
                    /* menampilkan halaman dalam bentuk modal */
                    Custombox.open({
                        //target: '${URLMod}/modal.jsp?o=t&w=' + vWaktu,
                        target: '${URLModAdmin}/modRestoModalUploadFotoProduk/modal.jsp?o=t&p=${vGetKodeProduk}&w=' + vWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        overlayClose: false
                    });
                    
                });
                
                /* [T2] menambah data: bila sudah ada data */
                $('#idTambah32').click(function(e) {
                    /* cegah aksi bawaan */
                    e.preventDefault();
                    vWaktu = vTgl.getTime();
                    
                    /* mengosongkan kolom pencarian */
                    $('#idTeksCari').val('');
                    /* menampilkan halaman dalam bentuk modal */
                    Custombox.open({
                        //target: '${URLMod}/modal.jsp?o=t&w=' + vWaktu,
                        target: '${URLModAdmin}/modRestoModalUploadFotoProduk/modal.jsp?o=t&p=${vGetKodeProduk}&w=' + vWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        overlayClose: false
                    });
                    
                });                
                
                /* [T3] tombol mengubah data */ 
                /*  metode akses berbeda karena dibuat secara live */
                $(document).on('click', '.clsTombolUbah', function(e){ 
                   //alert($(this).attr("value"));
                    /* cegah aksi bawaan */
                    e.preventDefault();
                    vWaktu = vTgl.getTime();
                    
                    var vKodeProduk = '${vGetKodeProduk}';
                    var vKodeFotoProduk = $(this).attr("value");
                                        
                    /* menampilkan halaman dalam bentuk modal */
                    Custombox.open({
                        target: '${URLMod}/modal.jsp?o=u&p=' + vKodeProduk + '&k=' + vKodeFotoProduk + '&w=' + vWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 380,
                        cache: false,
                        overlayClose: false
                    });
                    
                });
                
                /* [T4] tombol menghapus data */
                $(document).on('click', '.clsTombolHapus', function(e){ 
                   //alert($(this).attr("value"));
                    /* cegah aksi bawaan */
                    e.preventDefault();
                    vWaktu = vTgl.getTime();
                    
                    var vKodeProduk = '${vGetKodeProduk}';
                    var vKodeFotoProduk = $(this).attr("value");
                    Custombox.open({
                        target: '${URLMod}/modal.jsp?o=h&p=' + vKodeProduk + '&k=' + vKodeFotoProduk + '&w=' + vWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 380,
                        cache: false,
                        overlayClose: false
                    });
                });
                
                /* [T5] tombol navigasi */
                /* [T5:1]  tombol navigasi berikut */
                $('.clsTombolNavBerikut').click(function(e){
                    e.preventDefault();                    
                    fBuatTabel(true);
                });
                
                /* [T5:1]  tombol navigasi sebelum */
                $('.clsTombolNavSebelum').click(function(e){
                    e.preventDefault();
                    vJData = $('#idJumData').val();
                    vOffset = parseInt($('#idNoHalaman').val())* vJData;
                    fBuatTabel(false);
                });
                
                /* [T6] tombol pencarian */
                $('#idTombolCari').click(function(e){
                    e.preventDefault();
                    /* membuat tabel data */
                    fBuatTabel(false);
                });
                
                /* {EVENT: KEY UP} */
                $('#idTeksCari').keyup(function(e){
                    /* cegah aksi bawaan */
                    e.preventDefault();
                    if($('#idTeksCari').val() != ""){
                        /* membuat tabel */
                        fBuatTabel(false);
                    }
                });
                
                /* ################### {EVENT: ON CHANGE} */
                $('#idSelCari').on('change', function(e) {
                  /* cegah aksi bawaan */
                    e.preventDefault();
                    /* membuat tabel */
                    fBuatTabel(false);
                });
                
                /* perubahan urutan data */
                $('#idUrutanData').on('change', function(e) {
                  /* cegah aksi bawaan */
                    e.preventDefault();
                    /* membuat tabel */
                    fBuatTabel(false);
                });
                
                /* perubahan jenis produk */
                $('#idSelJenisProduk').on('change', function(e) {
                  /* cegah aksi bawaan */
                    e.preventDefault();
                    /* membuat tabel */
                    fBuatTabel(false);
                    
                });
                /* ################### {CHECK BOX} */
                /* {EVENT:ON CLICK} */
                /* checkbox utama */
                $('#idKodeCb').on('click', function(e){
                    if(this.checked) { // check select status
                        $("input[name='nmArrKodeCb[]']").each(function() { //loop through each checkbox
                            this.checked = true;  
                            $("#idGbrHapus32").attr('src','${URLModAdpubGambarTombol}/tombolHapusData16.png');
                            $("#idGbrHapus32").attr('alt','1'); /* aktif */
                            
                            /* masukkan ke dalam daftar hapus (apabila kode belum ada dalam daftar hapus) */
                            if(!fStatusAdaDlmArray($(this).val(),vArrKodeChecked) && $(this).val() != ""){
                                vArrKodeChecked.push($(this).val());
                                //console.log("Masukkan ke dalam daftar hapus.");
                            }
                            
                            /* menambahkan tanda centang pada #idKodeCb */
                            $('#idKodeCb').attr("checked","checked");
                        });
                        
                    }else{
                        $("input[name='nmArrKodeCb[]']").each(function() { //loop through each checkbox
                            this.checked = false; //deselect all checkboxes with class "checkbox1"  
                            $("#idGbrHapus32").attr('src','${URLModAdpubGambarTombol}/tombolHapusDataTA16.png');
                            $("#idGbrHapus32").attr('alt','0'); /* aktif */
                            /* hapus dari daftar hapus */
                            vArrKodeChecked = fHapusAnggotaArray($(this).val(),vArrKodeChecked);
                        });
                        
                        /* menghilangkan tanda centang pada #idKodeCb*/
                        $('#idKodeCb').removeAttr("checked");
                    }
                    /*var checked = []
                    $("input[name='nmArrKodeCb[]']:checked").each(function (){
                        checked.push(parseInt($(this).val()));
                        console.log($(this).val());
                    }); */
                });
                
                /* checkbox item */
                var vArrKodeChecked = []; /* daftar kode yang akan dihapus */
                $(document).on('click', ".clsCheckBoxFoto",function(e){
                    /* apabila dicentang */
                    if(this.checked){
                        //console.log("Index -> " + this.checked);
                        //console.log("Test -> " + $(this).val());
                        if(!fStatusAdaDlmArray($(this).val(),vArrKodeChecked) && $(this).val() != ""){
                            vArrKodeChecked.push($(this).val());
                            //console.log("Masukkan ke dalam daftar hapus.");
                        }
                        
                        /* apabila ada data dalam daftar hapus */
                        if(vArrKodeChecked.length > 0){
                            /* beri tanda aktif pada tombol hapus --> warna menjadi merah */
                            $("#idGbrHapus32").attr('src','${URLModAdpubGambarTombol}/tombolHapusData16.png');
                            $("#idGbrHapus32").attr('alt','1'); /* aktif */
                        }
                        
                        /* memberi tanda centang pada #idKodeCb apabila anggota checkbox semuanya tercentang */
                        vBanyakTampilanData = $('#idJumData').val;
                        if(vArrKodeChecked.length == vBanyakTampilanData){
                            $('#idKodeCb').click();
                        }
                    }else{
                        /* hapus kode terkait dalam daftar hapus */
                        vArrKodeChecked = fHapusAnggotaArray($(this).val(),vArrKodeChecked);
                        /* menghilangkan tanda centang induk */
                        //console.log("#idKodeCb --> " + $('#idKodeCb').attr('checked'));
                        $('#idKodeCb').removeAttr('checked');
                        /* apabila tidak ada anggota dalam daftar hapus */
                        if(vArrKodeChecked.length == 0){
                            /* jadikan gambar tombol hapus tidak aktif --> gambar menjadi abu-abu */
                            $("#idGbrHapus32").attr('src','${URLModAdpubGambarTombol}/tombolHapusDataTA16.png');
                            $("#idGbrHapus32").attr('alt','0'); /* aktif */
                        }
                    }
                    
                });
                
                /* {TOMBOL HAPUS SEBELAH TOMBOL TAMBAH} */
                $("#idHapus32").click(function(e){
                    //console.log("Isi daftar hapus.");
                    var i = 0;
                    var vBoolPertama = true;
                    var vSemuaKode = "";
                    
                    if(vArrKodeChecked.length > 0){
                        for(i=0;i<vArrKodeChecked.length;i++){
                            if(vBoolPertama){
                                vSemuaKode = vArrKodeChecked[i];
                                vBoolPertama = false;
                            }else{
                                vSemuaKode = vSemuaKode + "#" + vArrKodeChecked[i]; 
                            }
                            //console.log(vArrKodeChecked[i]);
                        }
                    }
                    
                    //console.log("Semua kode dalam daftar hapus: " + vSemuaKode);
                    if(vSemuaKode != ""){
                         //alert($(this).attr("value"));
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        vWaktu = vTgl.getTime();
                        
                        var vKodeProduk = '${vGetKodeProduk}';
                        //var vKodeFotoProduk = $(this).attr("value");
                        /* menampilkan modal */
                        Custombox.open({
                            target: '${URLMod}/modal.jsp?o=h&p=' + vKodeProduk + '&k=' + encodeURIComponent(vSemuaKode) + '&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            width: 380,
                            cache: false,
                            overlayClose: false
                        });
                        
                        // mengosongkan variabel
                        vArrKodeChecked = [];
                        vSemuaKode = "";
                        $('#idKodeCb').attr("checked","");
                    }
                    
                });
               
                /* {BAGIAN FUNGSI} */
                /* [F1] fBuatTabel: membuat tabel. */                
                function fBuatTabel(vFBerikut){
                    var vJenisProduk = $('#idSelJenisProduk').val();
                    var vKolomCari = $('#idSelCari').val();
                    var vTeksCari = $('#idTeksCari').val();
                    var vKodeProduk = '${vGetKodeProduk}';
                    
                    /* #tabel ajax */
                    /* nomor halaman */
                    var vNoHalaman = parseInt($('#idNoHalaman').val());
                    if(!vFBerikut){
                        if(vNoHalaman != 1){
                            vNoHalaman -= 1;
                            $('#idNoHalaman').val(vNoHalaman);
                        }
                    }
                    
                   var vJData = $('#idJumData').val();
                   var vOffset = (vFBerikut)? parseInt(vNoHalaman) * vJData : (parseInt(vNoHalaman)-1)* vJData;
                    
                   var vTgl = new Date();
                   var dtWaktu = vTgl.getTime();
                   
                   /* urutan data */
                    var vUrutanData = $('#idUrutanData').val();

                    /* tampilkan animasi */    
                    if(vFBerikut){
                        $('.clsGbrTombolBerikut').attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');
                    }else{
                        $('.clsGbrTombolSebelum').attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');
                    }
                    
                    /* [1] melakukan permintaan */
                    var request = $.ajax({
                        url: '${URLMod}/tabel.jsp?o='+ vOffset + '&j='+ vJData +'&w=' + dtWaktu,
                        type: 'POST',
                        data: {
                            dtJenisProduk: vJenisProduk,
                            dtKodeProduk: vKodeProduk,
                            dtKolomCari: vKolomCari,
                            dtTeksCari: vTeksCari,
                            dtUrutanData: vUrutanData
                        },
                       dataType: 'text'
                    });

                    /* [2] permintaan selesai */
                    request.done(function(vDataSvr) {
                        var vArrDataSvr = (vDataSvr.trim() != "") ? vDataSvr.split('@') : [];
                        
                        /* bila tidak ada data dan kata pencarian TIDAK kosong */
                        if(vDataSvr.trim() != "" && vArrDataSvr[0] == 0 && $('#idTeksCari').val() != ""){
                            /* sembunyikan bagian pencarian dan tabel */
                            //$("#idDivCari").attr('style','display:none');
                            $("#idDivTabelData").attr('style','display:none');
                            
                            /* tampilkan pesan */
                            $("#idPesanTabel").removeClass("clsSembunyikanPesan");
                            $("#idPesanTabel").hide().addClass("clsTampilkanPesan")
                            $("#idPesanTabel").fadeIn().css('border','1px solid red');
                            $("#idPesanTabel").html("<b>Maaf, tidak ada data terkait kata pencarian tersebut.</b>");
                           
                        }
                        
                        /* bila tidak ada data dan kata pencarian kosong */
                        if(vDataSvr.trim() != "" && vArrDataSvr[0] == 0 && $('#idTeksCari').val() == ""){
                            /* sembunyikan bagian pencarian dan tabel */
                            //$("#idDivCari").attr('style','display:none');
                            //$("#idDivTabelData").attr('style','display:none');
                            /* hapus isi data foto lama */
                             $('#idDivData').html('');
                            
                            /* sembunyikan navigasi */
                            $("#idDivNavigasi").removeClass("clsTampilkanDiv");
                            $("#idDivNavigasi").addClass("clsSembunyikanDiv");
                             
                            /* tampilkan pesan */
                            $("#idPesanTabel").removeClass("clsSembunyikanPesan");
                            $("#idPesanTabel").addClass("clsTampilkanPesan");
                            $("#idPesanTabel").html('').css('border','none');
                            $("#idPesanTabel").css('display','none');
                        }
                        
                        if(vDataSvr.trim() != "" && vArrDataSvr[0] != 0){  
                            /* menampilkan navigasi */
                            if($(window.parent.document).find('#idDivNavigasi').hasClass('clsSembunyikanDiv')){
                                $(window.parent.document).find('#idDivNavigasi').fadeOut().removeClass('clsSembunyikanDiv');
                                $(window.parent.document).find('#idDivNavigasi').fadeIn().addClass('clsTampilkanDiv');
                            }
                                
                            /* halaman maksimal */
                            var vNoHalamanMaks = (parseInt(vArrDataSvr[0]) - (parseInt(vArrDataSvr[0]) % parseInt(vJData)))/parseInt(vJData);
                            vNoHalamanMaks = ((parseInt(vArrDataSvr[0]) % parseInt(vJData)) > 0)? (vNoHalamanMaks + 1): vNoHalamanMaks;
                            $('#idNoHalamanMaks').val(vNoHalamanMaks);
                            
                            /* halaman */                           
                            if(vFBerikut){
                                vNoHalaman += 1;
                                $('#idNoHalaman').val(vNoHalaman);
                            }
                           
                            $("#idDivTambah48").fadeOut();
                            $("#idDivTabelData").removeAttr('style','display:none');
                            /* sembunyikan tampilan pesan tabel */
                            $("#idPesanTabel").removeClass("clsTampilkanPesan");
                            $("#idPesanTabel").addClass("clsSembunyikanPesan");
                            $("#idPesanTabel").html('').css('border','none');
                            $("#idPesanTabel").css('display','none');
                           
                            var oData = jQuery.parseJSON(vArrDataSvr[1].trim());
                            var i = 0;
                            
                            /* hapus isi data foto lama */
                            $('#idDivData').html('');
                            
                            /* iterasi baris */
                            $.each(oData,function(id,el){
                                //console.log(id);
                                //console.log(el.kode);
                                //console.log(el.nama); 
                                //console.log(el.ekstensi);
                                    
                                var vFoto = '<div id=\"idDivKotakFoto\" class=\"clsDivKotakFoto wobble-vertical\">' + 
                                                '<div id=\"idDivBerkasFoto\" class=\"clsDivBerkasFoto\" >' +
                                                    '<img id=\"idBerkasFoto\" class=\"clsBerkasFoto\" src=\"' + '${URLModAdpubFoto}' + '/produk/t' + el.berkas + el.ekstensi + '\" alt=\"' + i + '\" />' +
                                                    '<a id=\"idTautanOpsGaleri\" class=\"clsTautanOpsGaleri\" href=\"\" rel=\"' + i + '\">' +
                                                        '<div id=\"idDivOpsTambah\" class=\"clsDivOpsTambah\"><button class=\"clsTombolTambah shrink\" style=\"display:none\" value=\"'+ el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolTambahKeKeranjang.png\"></button></div>' +
                                                        '<div id=\"idDivOpsInfo\" class=\"clsDivOpsInfo\"><button class=\"clsTombolInfo shrink\" style=\"display:none\" value=\"' + el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolInfo.png\"></button></div>' +
                                                        '<div id=\"idDivOpsFoto\" class=\"clsDivOpsFoto\"><button class=\"clsTombolFoto shrink\" style=\"display:none\" value=\"' + el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolFoto.png\"></button></div>' +
                                                    '</a>' +
                                                '</div>' +
                                                '<p>'+ el.nama +' <br>Rp ' + el.harga + ',-</p>' +
                                            '</div>';
                                    i+=1;
                                    /* berkas foto */

                                $('#idDivData').append(vFoto);
                            });
                            
                            $(document).on('click','.clsTautanOpsGaleri',function(e){
                                e.preventDefault();
                            });
                            
                            /* tombol navigasi */
                            if(vFBerikut){
                                $('.clsGbrTombolBerikut').attr('src','${URLModAdpubGambarTombol}/tombolBerikut24.png');
                            }else{
                                $('.clsGbrTombolSebelum').attr('src','${URLModAdpubGambarTombol}/tombolSebelum24.png');
                            }
                            
                            fTombolNavigasiTampil(vNoHalaman,vNoHalamanMaks);
                           //$('#idTabelData > tbody:last').hide().fadeIn(800);
                        }
                    });

                   /* [3] permintaan gagal */
                   request.fail(function(e, textStatus ) {

                   });
               };
               
               /* fTombolNavigasiTampil: menampilkan tombol navigasi */
               function fTombolNavigasiTampil(vFNoHalaman,vFNoHalamanMaks){
                    
                    if(parseInt(vFNoHalamanMaks)>0){
                        if(vFNoHalaman == "1"){
                            $('.clsTombolNavSebelum').attr('style','display:none');
                        }else{
                            $('.clsTombolNavSebelum').removeAttr('style','display:none');
                        }

                        if(vFNoHalaman == vFNoHalamanMaks){
                            $('.clsTombolNavBerikut').attr('style','display:none');
                        }else{
                            $('.clsTombolNavBerikut').removeAttr('style');
                        }
                    }
                    
                    if(parseInt(vFNoHalamanMaks) == parseInt(0)){
                        $('.clsTombolNavSebelum').attr('style','display:none');
                        $('.clsTombolNavBerikut').attr('style','display:none');
                    }
               }
               
               /* fStatusAdaDlmArray: status apakah suatu nilai sudah ada dalam array.
                 * true: sudah ada, false: belum ada  */
                function fStatusAdaDlmArray(vFAnggotaBaru, vFArray){
                    var i = 0;
                    var vArrFaktor = [];
                    for(i=0;i<vFArray.length;i++){
                        //console.log()
                        if(vFArray[i] == vFAnggotaBaru){
                            vArrFaktor[i] = 0;
                            //console.log("vArrFaktor[" + i + "]: " + vArrFaktor[i]);
                        }else{
                            vArrFaktor[i] = 1;
                            //console.log("vArrFaktor[" + i + "]: " + vArrFaktor[i]);
                        }
                    }
                    
                    /* 1 x 1 x 1 = 1 --> belum ada */
                    /* 1 x 0 x 1 = 0 --> ada */
                    /* 0 x 0 x 0 = 0 --> ada */
                    
                    /* hitung nilai produk */
                    i = 0;
                    var vBoolPertama = true;
                    var vProduk;
                    for(i=0;i<vArrFaktor.length;i++){
                        if(vBoolPertama){
                            vProduk = vArrFaktor[i];
                            vBoolPertama = false;
                        }else{
                            vProduk = vArrFaktor[i] * vProduk;
                        }
                        //console.log("vProduk: " + vProduk);
                    }
                    
                    return (vProduk==0)?true:false;
                }
                
                /* fHapusAnggotaArray: menghapus anggota array tertentu sesuai dengan nilainya */
                function fHapusAnggotaArray(vFNilaiAnggota,vFArray){
                    var vArrBaru = [];
                    var i = 0;
                    var j = 0;
                    
                    if(vFNilaiAnggota != ""){
                        for(i=0;i<vFArray.length;i++){
                            if(vFArray[i] != vFNilaiAnggota){
                                vArrBaru[j] = vFArray[i];
                                j += 1;
                            }
                        }
                    }
                    
                    return vArrBaru;
                }
                
                /* ### menu tooltip #### */
                
                var vMenuPengguna = '<a class="clsTautanProfilPengguna" href="#">Profil</a><br>' + 
                '<a class="clsTautanLokasiPelanggan" href="#">Lokasi</a><br>' + 
                '<a class="clsTautanPesananPelanggan" href="#">Pesanan</a><br>';
                
                $('#idTautanPengguna').smallipop({}, vMenuPengguna);
                
                $(".smallipop-instance").css("width","100px");
                
                $(document).on('click', '.clsTautanLokasiPelanggan',function(e){
                    e.preventDefault();
                    
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    
                    Custombox.open({
                        target: '${URLModPublik}/modLokasiPelanggan/modal.jsp?o=u&k=${vKodeOrang}&w='+dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 700,
                        cache: false,
                        overlayClose: false,
                        zIndex: 1000
                    });
                    
                });
                
                /* ### menu ### */
                
                /* 1) pendaftaran */
                $(document).on('click', '.clsTautanDaftar',function(e){
                    e.preventDefault();
                    
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    
                    Custombox.open({
                        target: '${URLModPublik}/modDaftarPengguna/modal.jsp?o=t&w='+dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 380,
                        cache: false,
                        overlayClose: false,
                        zIndex: 1000
                    });
                    
                });
                
                /* 2) masuk */
                $(document).on('click', '.clsTautanMasuk',function(e){
                    e.preventDefault();
                    
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    
                    Custombox.open({
                        target: '${URLModPublik}/modMasuk/modal.jsp?o=m&w='+dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 380,
                        cache: false,
                        overlayClose: false,
                        zIndex: 1000
                    });
                    
                });
                
                /* 3) profil */
                $(document).on('click', '.clsTautanProfil',function(e){
                    e.preventDefault();
                    
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    
                    Custombox.open({
                        target: '${URLModPublik}/modHalamanProfilUsaha/modal.jsp?o=m&w='+dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 700,
                        cache: false,
                        overlayClose: false,
                        zIndex: 1000
                    });
                    
                });
                
                /* 4) kontak */
                $(document).on('click', '.clsTautanKontak',function(e){
                    e.preventDefault();
                    
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    
                    Custombox.open({
                        target: '${URLModPublik}/modHalamanKontak/modal.jsp?o=m&w='+dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 380,
                        overlayClose: false,
                        zIndex: 1000,
                        cache: false
                    });
                    
                });
                
                /* 5) berita */
                $(document).on('click', '.clsTautanBerita',function(e){
                    e.preventDefault();
                    
                    var d = new Date();
                    var dtWaktu = d.getTime();
                    
                    Custombox.open({
                        id: 'idDaftarBerita',
                        target: '${URLModPublik}/modModalDaftarBerita/modal.jsp?o=m&w='+ dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 700,
                        overlayClose: false,
                        zIndex: 1000,
                        cache: false
                    });
                    
                    e.preventDefault();
                });
                
                /* 6) pesanan */
                $(document).on('click', '.clsTautanPesananPelanggan',function(e){
                    e.preventDefault();
                    
                    var d = new Date();
                    var dtWaktu = d.getTime();
                    
                    Custombox.open({
                        id: 'idDaftarBerita',
                        target: '${URLModPublik}/modModalDaftarPesanan/modal.jsp?o=m&w='+ dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 700,
                        overlayClose: false,
                        zIndex: 1000,
                        cache: false
                    });
                    
                    e.preventDefault();
                });
                
                /* 7) Profil Pengguna */
                $(document).on('click', '.clsTautanProfilPengguna',function(e){
                    e.preventDefault();
                    
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    
                    Custombox.open({
                        target: '${URLModPublik}/modProfilPengguna/modal.jsp?o=u&w='+dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 380,
                        cache: false,
                        overlayClose: false,
                        zIndex: 1000
                    });
                    
                });
                
                /* ### keranjang belanja ### */
                var vJumProduk = '${vJumProduk}';
                
                console.log("Jumlah produk: " + vJumProduk);
                if(vJumProduk > 0){
                    $('#idGambarKeranjang').attr('src','${URLModAdpubGambarTombol}/tombolKeranjangPenuh.png')
                }else{
                    $('#idGambarKeranjang').attr('src','${URLModAdpubGambarTombol}/tombolKeranjang.png')
                }
                
                $('.clsTombolKeranjang').click(function(e) {
                    e.preventDefault();
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    Custombox.open({
                        id: 'idModalKeranjangBelanja',
                        target: '${URLModPublik}/modKeranjangBelanja/modal.jsp?w='+dtWaktu,
                        effect: 'slide',
                        animation: 'top,top',
                        width: 800,
                        cache: false,
                        overlayClose: false,
                        zIndex: 1000
                    });
                }); 
                
                $(document).on('click', '.clsTombolTambah',function() {
                    var vKode = $(this).attr("value");
                    var vKuantitas = '1';
                    
                    /* ajax */
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    
                    $("#idGbrTombol" + vKode).attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');
                    var request = $.ajax({
                        url: "${URL}/ClsSrvKeranjang?w=" + dtWaktu,
                        type: "POST",
                        data: { dtOperasi: "+", dtKode : vKode, dtKuantitas: vKuantitas},
                        dataType: "html"
                    });
                        
                    /* request selesai */
                    request.done(function(e) {
                        var f = e.split('@');
                        var vIsiCookie = f[0];
                        var vJumIsiCookie = parseInt(f[1]);
                        if(vJumIsiCookie > 0 && vIsiCookie != ""){
                            $('#idGambarKeranjang').attr("src","${URLModAdpubGambarTombol}/tombolKeranjangPenuh.png").effect("highlight").effect("pulsate");
                            $('#idKuantitas').text(vJumIsiCookie);
                        }else if(vJumIsiCookie == 0 && vIsiCookie == ""){
                            $('#idGambarKeranjang').attr("src","${URLModAdpubGambarTombol}/tombolKeranjang.png").effect("highlight").effect("pulsate");
                        }
                        
                        //$("#idGbrTombol"+vKode).attr('src','desain/gambar/keranjangTambah.png');
                    });

                    /* request gagal */
                    request.fail(function( jqXHR, textStatus ) {
                        alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        //$("#idGbrTombol"+vKode).attr('src','desain/gambar/tombolAjaxGagal.png');
                    });
                });   
                
                var vNamaPelanggan = '${vNamaPelanggan}';
                if(vNamaPelanggan != "Nama"){
                    /* munculkan nama dan menu keluar */
                    $('#idMenuNK').removeClass("clsSembunyikanDiv");
                    $('#idMenuNK').addClass("clsTampilkanDiv");

                    /* sembunyikan menu daftar */
                    $('#idMenuDM').removeClass("clsTampilkanDiv");
                    $('#idMenuDM').addClass("clsSembunyikanDiv");
                }else{
                    
                    /* sembunyikan nama dan menu keluar */
                    $('#idMenuNK').removeClass("clsTampilkanDiv");
                    $('#idMenuNK').addClass("clsSembunyikanDiv");

                    /* munculkan menu daftar */
                    $('#idMenuDM').removeClass("clsSembunyikanDiv");
                    $('#idMenuDM').addClass("clsTampilkanDiv");
                                        
                }
                
                /* sticky menu */
                $("#idDivTabelMenuIndexPublik").sticky({topSpacing:0});
            /* akhir jQuery */
            });
        //]]>
    </script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
	<center>
            <div id="idDivTerluar">
            <table id="idTabelTerluar">
                <tr>
                    <td class="clsTdJudul">
                        <table id="idTabelJudulModul">
                            <tr>
                                <td class="clsTdGambar">
                                    <a href="${URLModAdmin}/modOtentifikasi/index.jsp">
                                        <button class="clsTombolLogo buzz-out">
                                            <img src="${URLModAdpubGambarMenu}/pengantar64.png"/>
                                        </button>
                                    </a>
                                </td>
                                <td class="clsTdJudulMod">
                                    R.M. Padang "Sederhana"
                                    <div class="clsDivMotto">Pesan Antar Masakan Padang Online 24 Jam</div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- menu -->
                <tr>
                    <td>
                        <div id="idDivTabelMenuIndexPublik">
                            <nav class="cl-effect-5" id="cl-effect-5">
                                <table id="idTabelMenuIndexPublik" class="clsTabelMenuIndexPublik">
                                    <tr>
                                        <td class="clsTdMenuUtama">
                                            <a class="clsTautanProfil" href="#cl-effect-5"><span data-hover="Profil Usaha">Profil Usaha</span></a> | 
                                            <a class="clsTautanBerita" href="#cl-effect-5"><span data-hover="Berita">Berita</span></a> | 
                                            <a class="clsTautanKontak" href="#cl-effect-5"><span data-hover="Kontak">Kontak</span></a></td>
                                        <td class="clsTdPelanggan">
                                            <div id="idMenuDM" class="clsTampilkanDiv">
                                                <a class="clsTautanDaftar" href="#cl-effect-5"><span data-hover="Daftar">Daftar</span></a> | 
                                                <a class="clsTautanMasuk" href="#cl-effect-5"><span data-hover="Masuk">Masuk</span></a></div>
                                            <div id="idMenuNK" class="clsSembunyikanDiv">
                                                <a id="idTautanPengguna" class="clsTautanMasuk" href="#cl-effect-5"><span id="idSpanNama" data-hover="${vNamaPelanggan}"><div id="idNama">${vNamaPelanggan}</div></span></a> | 
                                                <a class="clsTautanKeluar" href="${URLModPublik}/modKeluar/index.jsp"><span data-hover="Keluar">Keluar</span></a></div>
                                        </td>
                                        <td class="clsTdKeranjang">
                                            <button class="clsTombolKeranjang buzz-out">
                                                <img id="idGambarKeranjang" src="${URLModAdpubGambarTombol}/${vGambarKeranjang}"/>
                                            </button>
                                            <span id="idKuantitas">${vJumProduk}</span>
                                        </td>
                                    </tr>
                                </table>
                            </nav>
                        </div>
                    </td>
                </tr>
                <!-- akhir menu -->
                <tr>
                    <td class="clsTdTerluar">
                    <center>
                        
                    <!-- banner -->
                    ${vBannerHTML}
                    <!-- akhir banner -->
                    
                    <!-- produk -->
                    <div id="idDivTambah48" class="clsSembunyikanDiv">
                        <a id="idTambah48" href="#modalTambah"><img class="pulse-grow" src="${URLModAdpubGambarData}/tambahData48.png"/></a>
                    </div>
                    <div id="idDivCari" align="center">
                        <table id="idTabelCari" align="center">
                            <tr>
                                <td><select id="idSelJenisProduk" class="clsSelJenisProduk">
                                        <option value="menu" selected>Pilih Menu</option>
                                        ${vOpsiMenu}
                                    </select>
                                </td>
                                
                                <td><input type="text" id="idTeksCari" class="clsTeksCari" value=""/></td>
                                <td class="clsTdCari"><button id="idTombolCari" class="clsTombolCari shrink"><img class="clsGbrTombolCari pulse-grow" src="${URLModAdpubGambarTombol}/tombolCari24.png"/></button></td>
                            </tr>
                        </table>
                    </div>
                            
                    <div id="idPesanTabel" class="clsSembunyikanPesan"></div>
                    
                    
                    <div id="idDivData" align="center"></div>
                            
                    <div id="idDivNavigasi" class="clsSembunyikanDiv">
                        <table id="idTabelNavigasi">
                            <tr>
                                <td class="clsTdTeksJData">Jumlah Tampilan Data:</td>
                                <td><input type="text" id="idJumData" class="clsJumData" value="5"/></td>
                                <td>Urutan Data:</td>
                                <td><select id="idUrutanData" name="nmUrutanData">
                                        <option value="ASC" selected>a-Z # 123 # L-B</option>
                                        <option value="DESC">Z-a # 321 # B-L</option>
                                    </select>
                                </td>
                                <td class="clsTdTeksNoHalaman">Hal.-Total Hal.:</td>
                                <td class="clsTdNoHalaman"><input type="text" id="idNoHalaman" class="clsNoHalaman" value="0" readonly/></td>
                                <td class="clsTdTeksDash">-</td>
                                <td class="clsTdNoHalamanMaks"><input type="text" id="idNoHalamanMaks" class="clsNoHalamanMaks" value="0" readonly/></td>
                                <td class="clsTdSpasi"></td>
                                <td class="clsTdSebelum"><button class="clsTombolNavSebelum shrink"><img class="clsGbrTombolSebelum pulse-grow" src="${URLModAdpubGambarTombol}/tombolSebelum24.png"/></button></td>
                                <td class="clsTdBerikut"><button class="clsTombolNavBerikut shrink"><img class="clsGbrTombolBerikut pulse-grow" src="${URLModAdpubGambarTombol}/tombolBerikut24.png"/></button></td>
                            </tr>
                        </table>
                    </div>
                           
                </center></td>
            </tr>
        </table>
        </div>
    </center>
  </jsp:attribute>
</publik:index>