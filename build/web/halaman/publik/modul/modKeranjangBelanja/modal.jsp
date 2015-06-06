<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="pilar.cls.ClsProduk"%>
<%@page import="pilar.cls.ClsKeranjang"%>
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
    /* direktori gambar tombol */
    String vDirGambarTombol = ClsKonf.vKonfURL + "/pilar/desain/" + ClsKonf.vKonfTema + "/halaman/adpub/gambar/tombol";
    /* obyek operasi basis data */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* obyek keranjang */
    ClsKeranjang oKeranjang = new ClsKeranjang();
    List<ClsProduk> vArrDaftarProduk = new ArrayList();
    vArrDaftarProduk = oKeranjang.ClsKeranjangBaru(request, "produk");
    
    if(vArrDaftarProduk.size() > 0){
        int i = 0;
        int j = 0;
        double vKuantitas = 0;
        double vHarga = 0;
        double vSubTotal = 0;

        StringBuilder oSb = new StringBuilder();

        for(ClsProduk vProduk: vArrDaftarProduk){
            if(!vProduk.getvPrvKode().equals("")){

            vKuantitas = Double.parseDouble(vProduk.getvPrvKuantitas());
            vHarga = Double.parseDouble(vProduk.getvPrvHarga());
            vSubTotal = vKuantitas * vHarga;

            i += 1;
            j = i % 2;
            String vStrTRClass = (j==0)? "class=\"clsTRWarna\"" : "class=\"clsTR\"";
            oSb.append("<tr id=\"fidTr" + vProduk.getvPrvKode() + "\" " + vStrTRClass + ">"
                    + "<td class=\"clsTdNo\">" + i + ".</td>"
                    + "<td><strong>" + vProduk.getvPrvKode() + "</strong></td>"
                    + "<td><strong>" + vProduk.getvPrvNama()+ "</strong></td>"
                    + "<td>" + vProduk.getvPrvHarga()+ "</td>"
                    + "<td><input type=\"text\" id=\"fidIpKts" + i + "\" name=\"fnmIpKts" + vProduk.getvPrvKode() + "\" value=\"" + vProduk.getvPrvKuantitas() + "\" class=\"clsKuantitas\" /></td>"
                    + "<td><em>" + vProduk.getvPrvSatuan() + "</em></td>"
                    + "<td class=\"clsTdSubTotal\"><strong>" + vSubTotal + "</strong></td>"
                    + "<td class=\"clsTdGambarTombol\"><button class=\"clsTombolKurang grow\" id=\"fidTombolKurang" + i + "\" value=\"" + vProduk.getvPrvKode() + "\">"
                    + "<img src=\"" + vDirGambarTombol + "/tombolKeranjangKurang.png\"/></button></td>"
                    + "</tr>");
            }
        }

        String vIsiTabel = oSb.toString();

        /* pajak */
        String vPajakResto = oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_pajak", "pajak", "nomor", "1");

        Double vPajakTotal = 0.0;
        if(!vPajakResto.equals("")){
            System.out.println(oKeranjang.fTotal());
            vPajakTotal = (Double.valueOf(vPajakResto)/100) * oKeranjang.fTotal();
        }
        

        /* biaya kurir */
        String vBiayaKurir = oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_biaya_kurir", "biaya", "nomor", "1");

        Double vTotalKurir = oKeranjang.fTotal();

        if(!vBiayaKurir.equals("")){
            vTotalKurir = (vPajakTotal + oKeranjang.fTotal()) + Double.valueOf(vBiayaKurir);
        }

        String vTotal = Double.toString(vTotalKurir);

        request.setAttribute("vIsiTabel", vIsiTabel);
        request.setAttribute("vPajakResto", vPajakResto);
        request.setAttribute("vPajakTotal", vPajakTotal);
        request.setAttribute("vBiayaKurir", vBiayaKurir);
        request.setAttribute("vTotal", vTotal);
        
        /* modal div */
        if(i > 0){
            request.setAttribute("idDivKeranjangBelanja","clsTampilkanDiv");
            request.setAttribute("divTabelBiayaKurir","clsTampilkanDiv");
            request.setAttribute("divTabelTotal","clsTampilkanDiv");
            request.setAttribute("idDivNavTrans","clsTampilkanDiv");
        }else{
            request.setAttribute("idDivKeranjangBelanja","clsSembunyikanDiv");
            request.setAttribute("divTabelBiayaKurir","clsSembunyikanDiv");
            request.setAttribute("divTabelTotal","clsSembunyikanDiv");
            request.setAttribute("idDivNavTrans","clsSembunyikanDiv");
            
            /* pesan */
            String vPesan = "Maaf, tas belanja Anda masih kosong.<br>"
                    + "Silahkan memilih menu yang hendak dipesan. ";
            
            request.setAttribute("vPesan",vPesan);
        }
    }else{
        /* modal div */
        request.setAttribute("idDivKeranjangBelanja","clsSembunyikanDiv");
        request.setAttribute("divTabelBiayaKurir","clsSembunyikanDiv");
        request.setAttribute("divTabelTotal","clsSembunyikanDiv");
        request.setAttribute("idDivNavTrans","clsSembunyikanDiv");
        
        /* pesan */
        String vPesan = "Maaf, tas belanja Anda masih kosong.<br>"
                + "Silahkan memilih menu yang hendak dipesan. ";

        request.setAttribute("vPesan",vPesan);
    }

%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/publik/modul/modKeranjangBelanja" prefix="publik" %>
<publik:modal>
    <jsp:attribute name="atas">
        <script type="text/javascript">
            /* pemrogram: I Made Ariana (ariana@atlascitra.com)
             * waktu update: 2015.03.15/19:45 WIB
             */
            
            //<![CDATA[
            $( document ).ready(function(e) {
                /* {VARIABEL GLOBAL} */
                var vTgl = new Date();
                    
                /* keranjang belanja */
                $('.clsTombolKurang').click(function(e) {
                    var vKode = $(this).attr("value");
                    
                    /* operasi ajax */
                    var d = new Date();
                    var dtWaktu = d.getTime(); 
                    
                    $("#idGbrTombol"+vKode).attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');
                    var request = $.ajax({
                        url: "${URL}/ClsSrvKeranjang?w=" + dtWaktu,
                        type: "POST",
                        data: { dtOperasi: "-", dtKode : vKode},
                        dataType: "html"
                    });
                        
                    /* request selesai */
                    request.done(function(e) {
                        /* perbaharui tabel: hapus baris */
                        $('#fidTr'+vKode).fadeOut(300, function(){ 
                            $(this).remove();

                            /* nomor urut & warna */
                            var vJumBaris = $('#idTabelKeranjang tr').length;
                            for(var i=0;i<vJumBaris;i++){
                                $('#idTabelKeranjang tr').eq(i).find('td').eq(0).text(i + '.');

                                if(i%2==0){
                                    $('#idTabelKeranjang tr').eq(i).addClass('clsTRWarna');
                                }else{
                                    $('#idTabelKeranjang tr').eq(i).removeClass('clsTRWarna');
                                }
                            }
                            
                             /* set total belanja */
                            var vTotal = $.number($.fn.fTotalBelanja(),1,'.','');
                            $('#idTabelTotal tr').eq(0).find('td').eq(2).text(vTotal);
                        });
                        
                        /* keranjang belanja */
                        var f = e.split('@');
                        var vIsiCookie = f[0];
                        var vJumIsiCookie = parseInt(f[1]);
                        if(vJumIsiCookie > 0 && vIsiCookie.trim() != ""){
                            /* perbaharui informasi parent window */
                            $(window.parent.document).find('#idKeranjangKosong').css("display","none");
                            $(window.parent.document).find('#idGbrKeranjangPenuh').css("display","inline");
                            $(window.parent.document).find('#idGbrCR').css("display","inline");
                            $(window.parent.document).find('#idKuantitas').text('('+vJumIsiCookie+')').effect("highlight").effect("pulsate");
                        }else if(vJumIsiCookie > 0 && vIsiCookie.trim() == ""){ 
                            Custombox.close();
                            $(window.parent.document).find('#idGbrCR').css("display","none");
                            $(window.parent.document).find('#idGbrKeranjangPenuh').css("display","none");
                            $(window.parent.document).find('#idKeranjangKosong').css("display","inline");
                            $(window.parent.document).find('#idKuantitas').text('');
                        }
                        /* gambar keranjang */
                        $("#idGbrTombol"+vKode).attr('src','desain/gambar/keranjangTambah.png');
                        
                    });

                    /* request gagal */
                    request.fail(function( jqXHR, textStatus ) {
                        alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        $("#idGbrTombol"+vKode).attr('src','${URLModAdpubGambarTombol}/tombolAjaxGagal.png');
                    });
                    
                });
                
                /* sub total */
                $('.clsKuantitas').keyup(function(e){
                    /* indeks baris tabel */
                    //var vIndeks = (this.id).replace('fidIpKts',''); 
                    var vIndeksBaris = $(this).closest('td').parent()[0].sectionRowIndex;
                   
                    /* kode produk */
                    var vKode = $('#'+this.id).attr("name").replace('fnmIpKts','');
                    /* kuantitas */
                    var vKuantitas = ($(this).val().trim() == '') ? 0.0 : parseFloat($(this).val());
                    /* harga */
                    var vHarga = parseFloat($('#idTabelKeranjang tr').eq(vIndeksBaris).find('td').eq(3).html());
                    //alert(vIndeksBaris + '# '+ vKode + '#Kts ' + vKuantitas +'#Rp '+vHarga+'#Id '+(this.id));
                    /* kalkulasi sub total */
                    var vSubTotal = parseFloat(vHarga * vKuantitas);
                    /* format angka sub total */
                    vSubTotal = $.number(vSubTotal,1,'.','');
                    
                    /* operasi ajax */
                    var d = new Date();
                    var dtWaktu = d.getTime();
                    
                    /* 1) melakukan permintaan */
                    $('#idTabelKeranjang tr').eq(vIndeksBaris).find('td').eq(6).html('<img src="${URLModAdpubGambarAnimasi}/animasiKotak.gif">');
                    var request = $.ajax({
                        url: "${URL}/ClsSrvKeranjang?w=" + dtWaktu,
                        type: "POST",
                        data: { dtOperasi: "*", dtKode : vKode, dtKuantitas : vKuantitas},
                        dataType: "html"
                    });
                    
                    /* 2) permintaan selesai */
                    request.done(function(e) {
                        /* set subtotal */
                        $('#idTabelKeranjang tr').eq(vIndeksBaris).find('td').eq(6).text(vSubTotal);
                        /* set total belanja */
                        var vTotal = $.number($.fn.fTotalBelanja(),1,'.','');
                        $('#idTabelTotal tr').eq(0).find('td').eq(2).text(vTotal);
                        
                        /* keranjang belanja */
                        var f = e.split('@');
                        var vIsiCookie = f[0];
                        var vJumIsiCookie = parseInt(f[1]);
                        if(vJumIsiCookie > 0 && vIsiCookie.trim() != ""){
                            /* perbaharui informasi parent window */
                            $(window.parent.document).find('#idKeranjangKosong').css("display","none");
                            $(window.parent.document).find('#idGbrKeranjangPenuh').css("display","inline");
                            $(window.parent.document).find('#idGbrCR').css("display","inline");
                            $(window.parent.document).find('#idKuantitas').text('('+vJumIsiCookie+')').effect("highlight").effect("pulsate");
                        }else if(vJumIsiCookie > 0 && vIsiCookie.trim() == ""){ 
                            Custombox.close();
                            $(window.parent.document).find('#idGbrCR').css("display","none");
                            $(window.parent.document).find('#idGbrKeranjangPenuh').css("display","none");
                            $(window.parent.document).find('#idKeranjangKosong').css("display","inline");
                            $(window.parent.document).find('#idKuantitas').text('');
                        }
                    });
                    
                    /* 3) permintaan gagal */
                    request.fail(function( jqXHR, textStatus ) {
                        alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        $('#idTabelKeranjang tr').eq(vIndeksBaris).find('td').eq(6).html('<img src=\"${URLModAdpubGambarTombol}/tombolAjaxGagal.png\">');
                    });                
                });
                
                /* kolom kuantitas */
                $(".clsKuantitas").keydown(function (e) {
                    // Allow: backspace, delete, tab, escape, enter and .
                    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
                         // Allow: Ctrl+A
                        (e.keyCode == 65 && e.ctrlKey === true) || 
                         // Allow: home, end, left, right
                        (e.keyCode >= 35 && e.keyCode <= 39)) {
                             // let it happen, don't do anything
                             return;
                    }
                    // Ensure that it is a number and stop the keypress
                    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                        e.preventDefault();
                    }
                });
                
                /* fTotal: kalkulasi total belanja */
                $.fn.fTotalBelanja = function() {
                    var vJumBaris = $('#idTabelKeranjang tr').length;
                    var vSubTotal= 0.0;
                    var vTotal = 0.0;
                    for(var i=1;i<vJumBaris;i++){
                        vSubTotal = parseFloat($('#idTabelKeranjang tr').eq(i).find('td').eq(6).html());
                        vTotal += parseFloat(vSubTotal);                        
                    }
                    
                    var vPajakResto = '${vPajakResto}';
                    var vPajakTotal = (parseFloat(vPajakResto)/100) * vTotal;
                    $('#idPajakResto').html(vPajakTotal);
                    /* nilai keluaran */
                    var vBiayaKurir = '${vBiayaKurir}';
                    // console.log("Biaya kurir: " + vBiayaKurir);
                    if(vBiayaKurir != "" || vBiayaKurir != "0"){
                        vTotal = (vTotal+vPajakTotal) + parseFloat (vBiayaKurir);
                    }
                    
                    return vTotal;
                 }; 
                 
                 /* #### navigasi transaksi */
                 
                 /* ----- tombol kanan */
                 $('#idDivButtonKanan').click(function(e){
                    e.preventDefault();
                    
                    /* sembunyikan tombol kanan */
                    $('#idDivTombolKanan').hide();
                    
                    /* sembunyikan form belanja */
                    $('#idDivKeranjangBelanja').hide();
                    
                    /* tampilkan form pembayaran */
                    $('#idDivPembayaran').removeClass('clsSembunyikanDiv');
                    $('#idDivPembayaran').addClass('clsTampilkanDiv');
                    $('#idDivPembayaran').show().fadeIn();
                    
                    /* tampilkan tombol keranjang belanja */
                    $('#idDivTombolKiri').removeClass('clsSembunyikanDiv');
                    $('#idDivTombolKiri').addClass('clsTampilkanDiv');
                    $('#idDivTombolKiri').show();
                    
                    /* modal */
                    $('#idGambarJudulModal').attr('src','${URLModAdpubGambarMenu}/pembayaran64.png');
                    $('#idSpanJudulModal').html('Pembayaran');
                    
                    /* # pilihan kasus */
                    var vNilaiTombolKanan = parseInt($('#idDivButtonKanan').attr("value"));
                    
                    /* 1) simpan data ke server */
                    if(vNilaiTombolKanan == 2){
                        console.log("Simpan data!");
                        $('#idDivTombolKanan').show();
                        
                        /* waktu */
                        var vWaktu = vTgl.getTime();
                        
                        /* ajax */
                        /* [1] req. dilakukan */
                        var vReqSimpanDataTranskasi = $.ajax({
                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: "t"
                                },
                                dataType: "html"
                        });
                        
                        /* [2] req. selesai */
                        vReqSimpanDataTranskasi.done(function(vFDataResp) {
                            var vDataResp = vFDataResp.trim();
                            //console.log("Halo: " + vFDataResp.toString());
                            if(vDataResp == "0"){
                                console.log("Membuka modal masuk.");
                                /* panggil modal login */
                                var d = new Date();
                                var dtWaktu = d.getTime(); 

                                Custombox.open({
                                    id: 'idModalMasuk',
                                    target: '${URLModPublik}/modMasuk/modal.jsp?o=m&w='+dtWaktu,
                                    effect: 'slide',
                                    animation: 'top,top',
                                    width: 380,
                                    cache: false,
                                    overlayClose: false,
                                    zIndex: 2000
                                });
                            }
                            
                            /* bila sudah login */
                            if(vDataResp == "1"){
                                /* sembunyikan metode pembayaran dan navigasi trans */
                                $('#idDivNavTrans').removeClass('clsTampilkanDiv');
                                $('#idDivNavTrans').addClass('clsSembunyikanDiv');
                                
                                $('#idDivPembayaran').removeClass('clsTampilkanDiv');
                                $('#idDivPembayaran').addClass('clsSembunyikanDiv');
                                
                                /* tampilkan pesan */
                                $('#idSpanPesan').html("Terima kasih atas belanja Anda.<br>Pesanan Anda akan tiba 30 menit sejak konfirmasi.");
                                
                                /* mengosongkan keranjang belanja */
                                /* operasi ajax */
                                var d = new Date();
                                var dtWaktu = d.getTime(); 

                                var vReqMengosongkanKeranjang = $.ajax({
                                    url: "${URL}/ClsSrvKeranjang?w=" + dtWaktu,
                                    type: "POST",
                                    data: { dtOperasi: "h", dtKode : ""},
                                    dataType: "html"
                                });
                                
                                /* [2] req. selesai */
                                vReqMengosongkanKeranjang.done(function(vFDataResp) {
                                    /* operasi tambahan aka post operation setelah 4000 ms */
                                    setTimeout(function(e){
                                        /* tutup modal ini */
                                        Custombox.close('idModalKeranjangBelanja');
                                    },4000);
                                    
                                    /* mengganti icon keranjang */
                                    $(window.parent.document).find('#idGambarKeranjang').attr('src','${URLModAdpubGambarTombol}/tombolKeranjang.png')
                                    $(window.parent.document).find('#idKuantitas').text('');
                                });
                                
                                /* [3] req. gagal */
                                vReqMengosongkanKeranjang.fail(function(e, textStatus ) {
                                    alert( "Permintaan ke server tidak berhasil: " + textStatus );
                                });
                            }
                        });
                        
                        /* [3] req. gagal */
                        vReqSimpanDataTranskasi.fail(function(e, textStatus ) {
                            alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        });
                    }
                    
                    /* 2) tampilkan tombol selesai */
                    if(vNilaiTombolKanan == 1){
                        $('#idSpanKanan').html("Selesai");
                        $('#idGambarKanan').attr('src','${URLModAdpubGambarMenu}/selesai.png');
                        vNilaiTombolKanan += 1;
                        $('#idDivButtonKanan').attr("value",vNilaiTombolKanan);
                        $('#idDivTombolKanan').show();
                    }
                });
                 
                /* ----- tombol kiri */
                $('#idDivButtonKiri').click(function(e){
                   e.preventDefault();

                   /* sembunyikan tombol kiri */
                   $('#idDivTombolKiri').hide();

                   /* sembunyikan form pembayaran */
                   $('#idDivPembayaran').removeClass('clsTampilkanDiv');
                   $('#idDivPembayaran').addClass('clsSembunyikanDiv');
                   $('#idDivPembayaran').hide();

                   /* tampilkan form belanja */
                   $('#idDivKeranjangBelanja').removeClass('clsSembunyikanDiv');
                   $('#idDivKeranjangBelanja').addClass('clsTampilkanDiv');
                   $('#idDivKeranjangBelanja').show().fadeIn();

                   /* tampilkan tombol pembayaran */
                   $('#idDivTombolKanan').removeClass('clsSembunyikanDiv');
                   $('#idDivTombolKanan').addClass('clsTampilkanDiv');
                   $('#idDivTombolKanan').show();

                   /* modal */
                   $('#idGambarJudulModal').attr('src','${URLModAdpubGambarMenu}/keranjangBelanja.png');
                   $('#idSpanJudulModal').html('Tas Belanja');

                   /* # pilihan kasus */
                   var vNilaiTombolKanan = parseInt($('#idDivButtonKanan').attr("value"));
                   //console.log("vNilaiTombolKanan: " + vNilaiTombolKanan);
                   /* 1) pada form pembayaran */
                   if(vNilaiTombolKanan == 2){
                       $('#idSpanKanan').html("Pembayaran");
                       $('#idGambarKanan').attr('src','${URLModAdpubGambarMenu}/pembayaran.png');
                       vNilaiTombolKanan -= 1;
                       $('#idDivButtonKanan').attr("value",vNilaiTombolKanan);
                       $('#idDivTombolKanan').show();
                   }

                });
                
            });
        </script>
</jsp:attribute>
  
<jsp:attribute name="isi">
<div class="clsModalIsi800NT">
    <div class="clsModalJudul800NT">
        <button type="button" class="close" onclick="Custombox.close();">&times;</button>
        <h4><img id="idGambarJudulModal" src="${URLModAdpubGambarMenu}/keranjangBelanja.png"/> &nbsp; <strong><span id="idSpanJudulModal">TAS BELANJA</span></strong></h4>
    </div>
    <div class="clsModalBody800NT">
        
        <!-- keranjang belanja -->
        <div id="idDivKeranjangBelanja" class="${idDivKeranjangBelanja}" align="center">
            <div id="divTabelKeranjang" align="center">
                <table id="idTabelKeranjang" class="clsTabelKeranjang">
                    <th class="clsThNo">No.</th><th>Kode</th><th class="clsThNama">Nama</th><th>Harga (Rp)</th><th>Kuantitas</th><th>Satuan</th><th class="clsThSubTotal" colspan="2">Sub Total (Rp)</th>
                    ${vIsiTabel}
                </table>
            </div>
        
            <div id="divTabelBiayaKurir" class="${divTabelBiayaKurir}">
                <table id="idTabelPengantaran" class="clsTabelPengantaran">
                    <tr>
                        <td class="clsGambar"><img src="${URLModAdpubGambarMenu}/resto48.png"></td>
                        <td class="clsTeks">Pajak Restoran (${vPajakResto}%): Rp <span id="idPajakResto">${vPajakTotal}</span></td>
                        <td>&nbsp;</td>
                        <td class="clsGambar"><img src="${URLModAdpubGambarMenu}/pengantar48.png"></td>
                        <td class="clsTeks">Biaya Pengantaran: Rp ${vBiayaKurir} (diluar pajak)</td>
                    </tr>
                </table>
            </div>
        
            <div id="divTabelTotal" align="center" class="${divTabelTotal}">
                <table id="idTabelTotal" class="clsTabelTotal">
                    <tr>
                        <td><strong>TOTAL</strong></td>
                        <td class="clsTdMtUang">Rp</td>
                        <td class="clsTdTotal">${vTotal}</td>
                    </tr>
                </table>
            </div>
        </div>
                    
        <!-- pembayaran -->
        <div id="idDivPembayaran" class="clsSembunyikanDiv" align="center">
            <table id="idTabelMetodePembayaran">
                <tr>
                    <td>Silahkan memilih metode pembayaran yang dikehendaki:</td>
                </tr>
                <tr>
                    <td>
                        <table id="idTabelPilihMetodePembayaran">
                            <tr>
                                <td><input type="radio" name="nmSelMetodePembayaran" value="cod" checked></td>
                                <td>Pembayaran di Tempat (COD)</td>
                            </tr>
                            <tr>
                                <td><input type="radio" name="nmSelMetodePembayaran" value="deb"></td>
                                <td>Kartu Debit (Mandiri/BCA)</td>
                            </tr>
                            <tr>
                                <td><input type="radio" name="nmSelMetodePembayaran" value="cre"></td>
                                <td>Kartu Kredit (Visa/MasterCard)</td>
                            </tr>
                            <tr>
                                <td><input type="radio" name="nmSelMetodePembayaran" value="pol"></td>
                                <td>Pembayaran Online (idCash/Bitcoin/PayPal)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
                    
        <!-- navigasi transaksi -->
        <div id="idDivNavTrans" class="${idDivNavTrans}" align="center">
            <table id="idTabelNavTrans" class="clsTabelNavTrans">
                <tr>
                    <td class="clsTdKiri">
                        <div id="idDivTombolKiri" class="clsSembunyikanDiv">
                            <button id="idDivButtonKiri" class="clsTombolKiri buzz-out">
                                <img id="idGambarKiri" class="clsGambarTombolKiri" src="${URLModAdpubGambarMenu}/keranjangBelanja.png">
                            </button> <strong><span id="idSpanKiri">Tas Belanja</span></strong>
                        </div>
                    </td>
                    <td class="clsTdKanan">
                        <div id="idDivTombolKanan" class="clsTampilkanDiv">
                            <button id="idDivButtonKanan" class="clsTombolKanan buzz-out" value="1">
                                <img id="idGambarKanan" class="clsGambarTombolKanan" src="${URLModAdpubGambarMenu}/pembayaran.png">
                            </button> <strong><span id="idSpanKanan">Pembayaran</span></strong>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
                            
        <span id="idSpanPesan">${vPesan}</span>
    
    <!-- akhir -->
    </div>
        
  </jsp:attribute>
</publik:modal>