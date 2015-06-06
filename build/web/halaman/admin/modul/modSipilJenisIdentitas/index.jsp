<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* variabel untuk diselipkan pada HTML/Javascript 
     * nilainya diambil dari berkas jsp ini/lain
     * bentuk penyelipannya pada HTML: ${vModKonfNamaData}
     */
    request.setAttribute("vModKonfNamaData", vModKonfNamaData);
    request.setAttribute("vModKonfIcon", vModKonfIcon); 
    request.setAttribute("vModKonfBanyakTampilanData", vModKonfBanyakTampilanData);
    
    /* memeriksa sesi halaman admin */
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

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/admin/modul/modSipilJenisIdentitas" prefix="admin" %>
<admin:index>
    <jsp:attribute name="atas">
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
                
                /* memanggil fungsi membuat tabel */
                fBuatTabel(true);
                
                /* ################### {EVENT: MOUSE OVER} */
                /* mouse over pada baris menampilkan tombol ubah dan hapus */
                $('#idTabelData').delegate('tbody > tr > td', 'mouseover', function() {
                    var vIndeks = $(this).parent().index();
                    //$('#idTabelData .clsTdTombolUbah').eq(vIndeks).removeAttr('style');
                    //$('#idTabelData .clsTdTombolHapus').eq(vIndeks).removeAttr('style');
                    //console.log($('.clsTombolUbah').eq(vIndeks).attr('value'));
                    $('.clsTombolUbah').eq(vIndeks).removeAttr('style');
                    $('.clsTombolHapus').eq(vIndeks).removeAttr('style');
                });
                
                /* ################### {EVENT: MOUSE LEAVE} */
                /* mouse leave pada baris menyembunyikan tombol ubah dan hapus */
                $('#idTabelData').delegate('tbody > tr > td', 'mouseleave', function() {
                    var vIndeks = $(this).parent().index();
                    $('.clsTombolUbah').eq(vIndeks).attr('style','display:none');
                    $('.clsTombolHapus').eq(vIndeks).attr('style','display:none');
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
                        target: '${URLMod}/modal.jsp?o=t&w=' + vWaktu,
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
                        target: '${URLMod}/modal.jsp?o=t&w=' + vWaktu,
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
                    var vKode = $(this).attr("value");
                    
                    /* menampilkan halaman dalam bentuk modal */
                    Custombox.open({
                        target: '${URLMod}/modal.jsp?o=u&k=' + vKode + '&w=' + vWaktu,
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
                    
                    var vKode = $(this).attr("value");
                    Custombox.open({
                        target: '${URLMod}/modal.jsp?o=h&k=' + vKode + '&w=' + vWaktu,
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
                
                /* ################### {CHECK BOX} */
                /* {EVENT:ON CLICK} */
                $('#idKodeCb').on('click', function(e){
                    if(this.checked) { // check select status
                        $("input[name='nmArrKodeCb[]']").each(function() { //loop through each checkbox
                            this.checked = true;  //select all checkboxes with class "checkbox1" 
                            $("#idGbrHapus32").attr('src','${URLModAdpubGambarTombol}/tombolHapusData16.png');
                            $("#idGbrHapus32").attr('alt','1'); /* aktif */
                            
                            /* masukkan ke dalam daftar hapus (apabila kode belum ada dalam daftar hapus) */
                            if(!fStatusAdaDlmArray($(this).val(),vArrKodeChecked) && $(this).val() != ""){
                                vArrKodeChecked.push($(this).val());
                                console.log("Masukkan ke dalam daftar hapus.");
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
                $(document).on('click', ".clsArrKodeCb",function(e){
                    /* apabila dicentang */
                    if(this.checked){
                        //console.log("Index -> " + this.checked);
                        console.log("Test -> " + $(this).val());
                        if(!fStatusAdaDlmArray($(this).val(),vArrKodeChecked) && $(this).val() != ""){
                            vArrKodeChecked.push($(this).val());
                            console.log("Masukkan ke dalam daftar hapus.");
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
                    console.log("Isi daftar hapus.");
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
                    
                    console.log("Semua kode dalam daftar hapus: " + vSemuaKode);
                    if(vSemuaKode != ""){
                         //alert($(this).attr("value"));
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        vWaktu = vTgl.getTime();
                        
                        var vKode = $(this).attr("value");
                        /* menampilkan modal */
                        Custombox.open({
                            target: '${URLMod}/modal.jsp?o=h&k=' + encodeURIComponent(vSemuaKode) + '&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            width: 380,
                            cache: false,
                            overlayClose: false
                        });
                    }
                    
                });
               
                /* {BAGIAN FUNGSI} */
                /* [F1] fBuatTabel: membuat tabel. */                
                function fBuatTabel(vFBerikut){
                    var vKolomCari = $('#idSelCari').val();
                    var vTeksCari = $('#idTeksCari').val();
                    
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
                           $("#idDivCari").attr('style','display:none');
                           $("#idDivTabelData").attr('style','display:none');
                           $("#idDivTambah48").removeClass('clsSembunyikanDiv').addClass('clsTampilkanDiv');
                           $("#idDivTambah48").fadeIn().show();
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
                            
                            /* hapus baris tabel */
                            $('#idTabelData tbody tr').remove();
                            /* iterasi baris */
                            $.each(oData,function(id,el){
                                //console.log(id);
                                //console.log(el.kode);
                                //console.log(el.nama);
                                i += 1;
                                var vWarnaTr = (i%2==0) ? 'clsTrWarna':'clsTrBiasa';
                                
                                if(i<vJData && i != vArrDataSvr[2]){
                                    $('#idTabelData > tbody:last').append('<tr class=\"'+ vWarnaTr + '\">' + 
                                        '<td class=\"clsTdCb\"><input type=\"checkbox\" id="idArrKodeCb[]" name=\"nmArrKodeCb[]\" class=\"clsArrKodeCb\" value=\"' + el.kode + '\"></td>'+
                                        '<td class=\"clsTdNomor\">' + (i + ((vNoHalaman-1)*vJData)) + '.</td>'+
                                        '<td>' + el.kode + '</td>'+
                                        '<td class=\"clsTdNama\">' + el.nama + '</td>'+
                                        '<td class=\"clsTdTombolHapus\"><button class=\"clsTombolHapus shrink\" style=\"display:none\" value=\"'+ el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolHapus.png\"></button></td>'+
                                        '<td class=\"clsTdTombolUbah\"><button class=\"clsTombolUbah shrink\" style=\"display:none\" value=\"' + el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolUbah.png\"></button></td>'+
                                        '</tr>');
                                }
                                
                                if(i>=vJData || i == vArrDataSvr[2]){
                                    $('#idTabelData > tbody:last').append('<tr class=\"'+ vWarnaTr + '\">' + 
                                        '<td class=\"clsTdCb clsTdCbAkhir\"><input type=\"checkbox\" id="idArrKodeCb[]" name=\"nmArrKodeCb[]\" class=\"clsArrKodeCb\" value=\"' + el.kode + '\"></td>'+
                                        '<td class=\"clsTdNomor clsTdAkhir\">' + (i + ((vNoHalaman-1)*vJData)) + '.</td>'+
                                        '<td class=\"clsTdAkhir\">' + el.kode + '</td>'+
                                        '<td class=\"clsTdNama clsTdAkhir\">' + el.nama + '</td>'+
                                        '<td class=\"clsTdTombolHapus clsTdAkhir\"><button class=\"clsTombolHapus shrink\" style=\"display:none\" value=\"'+ el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolHapus.png\"></button></td>'+
                                        '<td class=\"clsTdTombolUbah clsTdTambahAkhir\"><button class=\"clsTombolUbah shrink\" style=\"display:none\" value=\"' + el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolUbah.png\"></button></td>'+
                                        '</tr>');
                                }
                                
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
                        console.log()
                        if(vFArray[i] == vFAnggotaBaru){
                            vArrFaktor[i] = 0;
                            console.log("vArrFaktor[" + i + "]: " + vArrFaktor[i]);
                        }else{
                            vArrFaktor[i] = 1;
                            console.log("vArrFaktor[" + i + "]: " + vArrFaktor[i]);
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
                        console.log("vProduk: " + vProduk);
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
                                    <a href="${URLModAdmin}/modMenuUtama/index.jsp">
                                        <button class="clsTombolMenuBalik grow">
                                            <img src="${URLModAdpubGambarTombol}/tombolBalik48.png"/>
                                        </button>
                                    </a>
                                </td>
                                <td class="clsTdJudulMod">Administrasi Data ${vModKonfNamaData}</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="clsTdTerluar"><center>			
                            
                    <div id="idDivTambah48" class="clsSembunyikanDiv">
                        <a id="idTambah48" href="#modalTambah"><img class="pulse-grow" src="${URLModAdpubGambarData}/tambahData48.png"/></a>
                    </div>
                    <div id="idDivCari">
                        <table id="idTabelCari">
                            <tr>
                                <td><select id="idSelCari" class="clsSelCari">
                                        <option value="nomor">Indeks</option>
                                        <option value="kode">Kode</option>
                                        <option value="nama" selected>Nama</option>
                                    </select>
                                </td>
                                <td><input type="text" id="idTeksCari" class="clsTeksCari" value=""/></td>
                                <td class="clsTdCari"><button id="idTombolCari" class="clsTombolCari shrink"><img class="clsGbrTombolCari pulse-grow" src="${URLModAdpubGambarTombol}/tombolCari24.png"/></button></td>
                            </tr>
                        </table>
                    </div>
                            
                    <div id="idPesanTabel" class="clsSembunyikanPesan"></div>
                    
                    <div id="idDivTabelData">
                        <table id="idTabelData">
                            <thead class="clsThTabel">
                                <th class="clsThKodeCb"><input type="checkbox" id="idKodeCb" name="nmKodeCb" value=""></th>
                                <th class="clsThNomor">No.</th>
                                <th class="clsThKode">Kode</th>
                                <th class="clsThNama">Nama ${vModKonfNamaData}</th>
                                <th class="clsThOperasiHapus"><a id="idHapus32" href="#modalHapus"><img id="idGbrHapus32" class="pulse-grow" src="${URLModAdpubGambarTombol}/tombolHapusDataTA16.png" alt="0"/></a></th>
                                <th class="clsThOperasiTambah"><a id="idTambah32" href="#modalTambah"><img id="idGbrTambah32" class="pulse-grow" src="${URLModAdpubGambarTombol}/tombolTambahData16.png"/></a></th>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
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
</admin:index>