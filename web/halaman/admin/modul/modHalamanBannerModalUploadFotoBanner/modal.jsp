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
    ClsOlahKata oOlahKata = new ClsOlahKata(); /* obyek olah kata */
    /* kode produk */
    String vGetKodeBanner = oOlahKata.fHapusSpasi(request.getParameter("b"));
    //System.out.println("modHalamanBannerModalUploadFotoBanner -> modal.jsp -> vKodeBanner: " + vGetKodeBanner);
    
    /* kode foto produk */
    ClsKode oKode = new ClsKode();
    String vKodeFotoBanner = vModKonfKodeAwal + oKode.fBuatKodeAcak(14).toUpperCase();
    
    /* @formulir */
    String vHTMLGambarIcon = "tambahData32.png";
    request.setAttribute("vModKonfNamaData", vModKonfNamaData);
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vGetKodeBanner", vGetKodeBanner);
    request.setAttribute("vKodeFotoBanner", vKodeFotoBanner);
    
    request.setAttribute("vModKonfLebarFoto", vModKonfLebarFoto);
    request.setAttribute("vModKonfTinggiFoto", vModKonfTinggiFoto);
    request.setAttribute("vModKonfLebarThumb", vModKonfLebarThumb);
    request.setAttribute("vModKonfTinggiThumb", vModKonfTinggiThumb);
    
    request.setAttribute("vModKondDataRef", vModKondDataRef);
    request.setAttribute("vModKonfDirFoto", vModKonfDirFoto);
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/admin/modul/modHalamanBannerModalUploadFotoBanner" prefix="admin" %>
<admin:modal>
    <jsp:attribute name="atas">
        <!-- JS/CSS khusus di sini -->
        
	<script type="text/javascript">
            /* pemrogram: I Made Ariana (ariana@atlascitra.com)
             * waktu update: 2015.03.15/19:45 WIB
             */
            
            //<![CDATA[
                $(document).ready(function() {
                    var vTgl = new Date();
                    
                    var options = {
                        beforeSubmit: function(){
                            var vNama = $('#idNama').val();
                            var vNamaBerkas = $('#idNamaBerkasRef').val();

                            if(vNama != "" && vNamaBerkas != ""){
                                $("#idPesanUpload").html("<font color='blue'>Foto siap di-upload.</font>");
                                return true;
                            }else{
                                if(vNama == ""){
                                    $("#idPesanUpload").html("<font color='red'>Mohon mengisi nama foto.</font>");
                                }

                                if(vNamaBerkas == ""){
                                    $("#idPesanUpload").html("<font color='red'>Mohon memilih foto yang hendak di-upload.</font>");
                                }
                                
                                return false;
                            }
                        },
                        /* # sebelum dikirim */
                        beforeSend : function() {

                            $("#idBarProgress").width('0%');
                            $("#idPesanUpload").empty();
                            $("#idPersenUpload").html("0%");
                            
                            
                        },
                        /* # ketika dikirim */
                        uploadProgress : function(event, position, total, percentComplete) {
                            $("#idKotakProgress").removeClass("clsSembunyikanDiv");
                            $("#idKotakProgress").addClass("clsTampilkanDiv");

                            $("#idBarProgress").width(percentComplete + '%');
                            $("#idPersenUpload").html(percentComplete + '%');

                            // change message text to red after 50%
                            if (percentComplete > 50) {
                                $("#idPesanUpload").html("<font color='red'>Berkas foto sedang di-upload ...</font>");
                            }
                        },
                        /* # ketika berhasil dikirim */
                        success : function() {
                            /* bar progress */
                            $("#idBarProgress").width('100%');
                            $("#idPersenUpload").html('100%');
                        },
                        /* # selesai dikirim */
                        complete : function(response) {
                            
                            /* 1) memeriksa apakah berkas sudah ada */
                            /* data-data yang dikirim */
                            var vWaktu = vTgl.getTime();
                            var vOperasi = 't';
                            var vKodeBanner = '${vGetKodeBanner}';
                            var vKodeFotoBanner = '${vKodeFotoBanner}';
                            
                            /* operasi ajax */
                            var vReqAmbilNamaBerkasFoto = $.ajax({
                                url: "${URLModAdmin}/modHalamanBannerGaleri/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { 
                                    dtOperasi: "b", 
                                    dtKodeBanner: vKodeBanner,
                                    dtKodeFotoBanner : vKodeFotoBanner
                                },
                                dataType: "text"
                            });
                            
                             /* [2] req. selesai */
                             var vBoolPerbaharuiTabel = false;
                            vReqAmbilNamaBerkasFoto.done(function(vFDataSvr) {
                                //console.log(vFDataSvr);
                                if(vFDataSvr.trim() != ""){
                                    var vURLFoto = '${URLModAdpubFoto}' + '/${vModKonfDirFoto}/t' + vFDataSvr + '.jpg';
                                    var vURLValid = fURLValid(vURLFoto);


                                    if(vURLValid == 200){
                                        vBoolPerbaharuiTabel = true;

                                    }else{
                                        while(vURLValid != 200){
                                            //alert(vURLValid ? "Valid URL!!!" : "Damn...");
                                            vURLValid = fURLValid(vURLFoto);
                                            vBoolPerbaharuiTabel = 200 ? true:false;
                                        }
                                    }

                                    /* 2) memerbaharui tabel parent */
                                    if(vBoolPerbaharuiTabel){
                                        /* data-data yang dikirim */
                                        var vWaktu = vTgl.getTime();
                                        var vOperasi = 't';
                                        var vKodeBanner = '${vGetKodeBanner}';
                                        var vKodeFotoBanner = '${vKodeFotoBanner}';

                                        /* nilai kriteria dan teks pencarian */
                                        var vKolomCari = $(window.parent.document).find('#idSelCari').val();
                                        var vTeksCari = $(window.parent.document).find('#idTeksCari').val();

                                        /* operasi ajax */
                                        var vReqSimpanDataFoto = $.ajax({
                                            url: "${URLModAdmin}/modHalamanBannerGaleri/proses.jsp?w=" + vWaktu,
                                            type: "POST",
                                            data: { 
                                                dtOperasi: vOperasi, 
                                                dtKodeBanner: vKodeBanner,
                                                dtKodeFotoBanner : vKodeFotoBanner
                                            },
                                            dataType: "text"
                                        });

                                        /* [2] req. selesai */
                                        vReqSimpanDataFoto.done(function(vFDataSvr) {
                                            /* [#] notifikasi */

                                            /* operasi tambahan aka post operation setelah 3000 ms */
                                            setTimeout(function(e){
                                                /* menampilkan bagian pencarian dan tabel */
                                                $(window.parent.document).find("#idDivCari").removeAttr('style','display:none');
                                                $(window.parent.document).find("#idDivTabelData").removeAttr('style','display:none');
                                                $(window.parent.document).find("#idDivTambah48").attr('style','display:none');
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
                                            //console.log('fPerbaharuiNavigasi');
                                            fPerbaharuiNavigasi("tu",vFDataSvr,vJumData,vNoHalamanMaks,vNoHalaman);

                                            /* [#] update parent tabel */
                                            /* mengambil kembali nilai no halaman apabila pada proses perbaharui navigasi 
                                             * terdapat perubahan no halaman */
                                            vNoHalaman = parseInt($(window.parent.document).find('#idNoHalaman').val());
                                            /* [#] perbaharui tombol navigasi */
                                            //console.log("fTombolNavigasiTampil >> " + vNoHalaman + " # " + vNoHalamanMaks);
                                            fTombolNavigasiTampil(vNoHalaman,vNoHalamanMaks);

                                            /* # memanggil fungsi fPerbaharuiTabel */
                                            //console.log("fPerbaharuiTabel");
                                            fPerbaharuiTabel("tu",vFDataSvr,vJumData,vNoHalamanMaks,vNoHalaman);
                                        });

                                        /* [3] req. gagal */
                                        vReqSimpanDataFoto.fail(function(e, textStatus ) {
                                            alert( "Permintaan ke server tidak berhasil: " + textStatus );
                                        });

                                        /* 4) pesan */
                                        $("#idPesanUpload").html("<font color='blue'>Foto sudah di-upload.</font>");

                                        /* 5) tutup modal */
                                        setTimeout(function(e){
                                            Custombox.close();
                                        },2000);

                                    }
                                }
                                
                            });
                            
                            /* [3] req. gagal */
                            vReqAmbilNamaBerkasFoto.fail(function(e, textStatus ) {
                                alert( "Permintaan ke server tidak berhasil: " + textStatus );
                            });
                            
                            
                            
                        },
                        error : function() {
                            $("#idPesanUpload").html("<font color='red'>Terdapat error, foto tidak dapat di-upload.</font>");
                        }
                    };
                    
                    /* nama berkas */
                    $('input[type=file]').change(function(e){
                        $('#idNamaBerkas').html($(this).val());
                        $('#idNamaBerkasRef').val($(this).val());
                    });
                    
                    
                    $("#idUploadForm").ajaxForm(options);
                    
                    /* {BAGIAN FUNGSI} */
                    /* [F1] fPerbaharuiNavigasi: memerbaharui navigasi */
                    function fPerbaharuiNavigasi(
                        vFOperasi,
                        vFJumDataBd,
                        vFJumData,
                        vFNoHalamanMaks,
                        vFNoHalaman){
                        
                        /*console.log("fPerbaharuiNavigasi >> " + 
                                vFOperasi + " # " +
                                vFJumDataBd + " # " +
                                vFJumData + " # " +
                                vFNoHalamanMaks + " # " +
                                vFNoHalaman); */
                        
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
                        var vKodeBanner = '${vGetKodeBanner}';
                        var vKodeFotoBanner = '${vGetKodeBanner}';
                        var vKolomCari = $(window.parent.document).find('#idSelCari').val();
                        var vTeksCari = $(window.parent.document).find('#idTeksCari').val();
                        
                        //console.log("vReqDataTabel.start");
                        var vReqDataTabel = $.ajax({
                            url: '${URLModAdmin}/modHalamanBannerGaleri/tabel.jsp?o=' + vOffset + '&j='+ vFJumData + '&w=' + vWaktu,
                            type: 'POST',
                            data: {
                                dtKodeBanner: vKodeBanner,
                                dtKodeFotoBanner: vKodeFotoBanner,
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
                                
                                /* parsing data JSON */
                                var oData = jQuery.parseJSON(vArrDataSvr[1].trim());
                                var i = 0;
                                
                                //* hapus isi data foto lama */
                                $('#idDivData').html('');
                                
                                
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    //console.log(id);
                                    //console.log(el.kode);
                                    //console.log(el.nama);  

                                    //var vURLFoto = '${URLModAdpubFoto}' + '/${vModKonfDirFoto}/t' + el.berkas + '.jpg';

                                    var vFoto = '<div id=\"idDivKotakFoto\" class=\"clsDivKotakFoto wobble-vertical\">' + 
                                                    '<div id=\"idDivBerkasFoto\" class=\"clsDivBerkasFoto\" >' +
                                                        '<img id=\"idBerkasFoto\" class=\"clsBerkasFoto\" src=\"' + '${URLModAdpubFoto}' + '/${vModKonfDirFoto}/t' + el.berkas + el.ekstensi + '\" alt=\"' + i + '\" />' +
                                                        '<a id=\"idTautanOpsGaleri\" class=\"clsTautanOpsGaleri\" href=\"\" rel=\"' + i + '\">' +
                                                            '<div id=\"idDivOpsHapus\" class=\"clsDivOpsHapus\"><button class=\"clsTombolHapus shrink\" style=\"display:none\" value=\"'+ el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolHapus.png\"></button></div>' +
                                                            '<div id=\"idDivOpsUbah\" class=\"clsDivOpsUbah\"><button class=\"clsTombolUbah shrink\" style=\"display:none\" value=\"' + el.kode + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolUbah.png\"></button></div>' +
                                                        '</a>' +
                                                    '</div>' +
                                                    '<p>'+ '<input class=\"clsCheckBoxFoto\" type=\"checkbox\" name=\"nmArrKodeCb[]\" value=\"' + el.kode + '\">' +  el.nama +'</p>' +
                                                '</div>';
                                    i+=1;
                                    /* berkas foto */

                                    $('#idDivData').append(vFoto);
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
                    
                    /* F[4]: memeriksa keberadaan berkas (setelah upload) */
                    function fURLValid(vFURL) {
                        var http = jQuery.ajax({
                           type:"HEAD",
                           url: vFURL,
                           async: false
                        })
                        return http.status; /* status ada: 200 */s
                   }
                });
            //]]>     
	</script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
    <div class="clsModalIsi">
        <div class="clsModalJudul">
            <button type="button" class="close" onclick="Custombox.close();">&times;</button>
            <h4><img src="${URLModAdpubGambarData}/${vHTMLGambarIcon}"/> &nbsp; <strong>${vHTMLOperasi} ${vModKonfNamaData}</strong></h4>
        </div>
        <div class="clsModalBody">
            
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            
            <form id="idUploadForm" action="${URL}/ClsSrvUploadFoto" method="post" enctype="multipart/form-data">
                <table id="idTabelUploadFoto">
                    <tr>
                        <td class="clsKolomLabel">Berkas Foto</td>
                        <td></td>
                        <td><label class="clsCustom-upload"><input type="file" size="60" id="idBerkasUpload" name="file">Pilih Foto</label></td>
                    </tr>
                    <tr>
                        <td class="clsKolomLabel">Nama Berkas</td>
                        <td></td>
                        <td class="clsKolomMasukan"><div id="idNamaBerkas">----</div></td>
                    </tr>
                    <tr>
                        <td class="clsKolomLabel">Kode</td>
                        <td></td>
                        <td><input type="text" id="idKode" name="nmKode" value="${vKodeFotoBanner}" readonly/></td>
                    </tr>
                    <tr>
                        <td class="clsKolomLabel">Nama</td>
                        <td></td>
                        <td><input type="text" id="idNama" name="nmNama" value="" /></td>
                    </tr>
                    <tr>
                        <td class="clsKolomLabel">Keterangan</td>
                        <td></td>
                        <td><textarea id="idKeterangan" name="nmKeterangan"></textarea></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        <td class="clsKolomTombol">
                            <input id="idTombolUploadForm" class="clsTombolUploadForm" type="submit" value="Kirim">
                        </td>
                    </tr>
                </table>
                
                <div id="idKotakProgress" class="clsSembunyikanDiv">
                    <div id="idBarProgress"></div>
                    <div id="idPersenUpload">0%</div>                    
                </div>
                
                <div id="idPesanUpload"></div>
                <input type="hidden" id="idKode" name="nmKodeRef" value="${vGetKodeBanner}"/>
                <input type="hidden" id="idData" name="nmDataRef" value="${vModKondDataRef}"/>
                <input type="hidden" id="idNamaBerkasRef" name="nmNamaBerkasRef" value=""/>
                
                <input type="hidden" id="idLebarFoto" name="nmLebarFoto" value="${vModKonfLebarFoto}"/>
                <input type="hidden" id="idTinggiFoto" name="nmTinggiFoto" value="${vModKonfTinggiFoto}"/>
                <input type="hidden" id="idLebarThumb" name="nmLebarThumb" value="${vModKonfLebarThumb}"/>
                <input type="hidden" id="idTinggiThumb" name="nmTinggiThumb" value="${vModKonfTinggiThumb}"/>
            </form>
        </div>
    </div>
  </jsp:attribute>
</admin:modal>