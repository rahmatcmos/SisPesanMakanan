<%@page import="pilar.cls.ClsKonf" %>

<% 
    ClsKonf oKonf = new ClsKonf();
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/admin/modul/modOtentifikasi" prefix="admin" %>
<admin:index>
  <jsp:attribute name="atas">
    <!-- JS/CSS khusus di sini -->
	<script type="text/javascript">
            $(document).ready(function() {
                /* kosongkan kolom */
                $("#idNama").val("");
                $("#idSandi").val("");
                $("#idKode").val("");
                /* fokus awal */
                $("#idNama").focus();

                // tombol kirim: apabila dite
                $("#idKirim").click(function(e) {
                    /* mencegah aksi bawaan submit */
                    e.preventDefault();

                    /* waktu unik */
                    var vWaktuKini = new Date();
                    var vMiliDetik = vWaktuKini.getTime();

                    /* operasi utama */
                    var vNama = $("#idNama").val();
                    var vSandi = $("#idSandi").val();
                    var vKode = $("#idKode").val();
                    var vCaptcha = $("#idCaptcha");

                    /* apabila salah satu kolom kosong jangan lakukan permintaan */
                    if(vNama.trim() == '' || vSandi.trim() =='' || vKode.trim() == ''){
                        Custombox.open({
                            target:'#idPesanModal',
                            effect: 'slide',
                            animation: 'top,top',
                            width: 500,
                            open: function(){
                                    $('#idIsiPesan').html('Maaf, pengisian kolom masih belum lengkap.');
                                },
                            close: function(){ 
                                    /* perbaharui captcha */
                                    vCaptcha.attr('src', '${URL}/clsCaptcha?w='+vMiliDetik);
                                    /* kembalikan icon tombol ke kondisi awal */
                                    $("#idImgKirim").attr('src','${URLModAdpubGambarTombol}/tombolAjaxKirim.png');
                                    /* fokus kolom */
                                    $("#idNama").focus();
                                }
                        });

                        e.preventDefault();	
                    }

                    /* semua kolom telah diisi, lakukan permintaan ajax */
                    if(vNama.trim() != '' && vSandi.trim() !='' && vKode.trim() != ''){				
                        /* operasi ajax */
                        var vPermintaan = $.ajax({
                                url: "${URL}/clsOtentifikasi?w="+ vMiliDetik,
                                type: "POST",
                                data: {dtNama:vNama, dtSandi:vSandi, dtKode:vKode},
                                dataType: "html"
                        });

                        $("#idImgKirim").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');

                        /* sedang melakukan permintaan submit * /
                        /* permintaan selesai diproses */
                        vPermintaan.done(function(vFDataServer) {					
                                $( "#log" ).html(vFDataServer);	
                                //alert(msg);
                                if(vFDataServer.trim() === '1'){
                                        //alert('Hi, ' + vFDataServer + '!');
                                        $("#idImgKirim").attr('src','${URLModAdpubGambarTombol}/tombolAjaxSukses.png');
                                        var vURL = "${URLModAdmin}/modMenuUtama/index.jsp";
                                        window.location.href = vURL;						
                                        //console.log(vURL);
                                }else{

                                    var vPesan;

                                    /* semua kolom belum benar */
                                    if(vFDataServer.trim() === '0'){
                                        vPesan = 'Maaf, Id dan kata sandi yang Anda masukkan tidak benar.';
                                        $("#idNama").val("");
                                        $("#idSandi").val("");
                                        $("#idKode").val("");
                                        /* fokus kolom */
                                        $("#idNama").focus();
                                    }

                                    /* kode captcha belum benar */
                                    if(vFDataServer.trim() === '2'){
                                        vPesan = 'Maaf, kode captcha Anda tidak benar.';
                                        $("#idKode").val("");
                                        /* fokus kolom */
                                        $("#idKode").focus();
                                    }

                                    /* mengganti icon tombol */
                                    $("#idImgKirim").attr('src','${URLModAdpubGambarTombol}/tombolAjaxKirim.png');
                                    /* menampilkan modal */
                                    Custombox.open({
                                            target: '#idPesanModal',
                                            effect: 'slide',
                                            animation: 'top,top',
                                            width: 500,
                                            open: function(){
                                                $('#idIsiPesan').html(vPesan);
                                            },
                                            close: function(){}
                                    });

                                    /* cegah untuk melakukan operasi bawaan */
                                    e.preventDefault();                                                    
                                }				
                            });

                            /* permintaan */
                            vPermintaan.fail(function( jqXHR, textStatus ) {
                                Custombox.open({
                                    target: '#idPesanModal',
                                    effect: 'slide',
                                    animation: 'top,top',
                                    width: 500,
                                    open: function(){
                                        $('#idIsiPesan').html('Terdapat kegagalan melakukan koneksi ke server.');
                                    },
                                    close: function(){}
                                });
                            });
                        }
                });

                /* tombol captcha */
                $("#idBuatCaptcha").click(function(e) {
                    /* mencegah aksi bawaan submit */
                    e.preventDefault();
                    /* waktu unik */
                    var vWaktuKini = new Date();
                    var vMiliDetik = vWaktuKini.getTime();
                    var vPermintaan = $.ajax({
                            url: "index.jsp?w="+ vMiliDetik,
                            type: "POST",
                            data: {w:vMiliDetik},
                            dataType: "html"
                    });

                    $("#idAnimasiAjaxCaptcha").attr('src','${URL}/pilar/desain/standar/halaman/adpub/gambar/animasi/putaranPanah.gif');

                    /* captcha */
                    vPermintaan.done(function(vFDataServer) {
                        $("#idCaptcha").attr('src', '${URL}/clsCaptcha?w='+vMiliDetik);
                        $("#idAnimasiAjaxCaptcha").attr('src','${URL}/pilar/desain/standar/halaman/adpub/gambar/tombol/tombolAjaxCaptcha.png');
                    });

                });
		});
	</script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
	<center>
	<div id="idBungkus"><div id="idLatar"></div>
            
	<div id="idFormMasuk">
            <div class="divTeksMasuk"><a class="clsTautanAdmin" href="${URLModOperator}/modOtentifikasi/index.jsp">Administrasi</a></div>
                <div id="divUbahTambah" class="">
                    <form id="idFmMasukAdmin" name="nmFmMasukAdmin" method="post" action="#" >
                        <table id="idtabelUbahTambah80" class="tabelUbahTambah80">
                            <tr class="trWarna">
                                <td class="tdKanan" width="140">ID</td><td></td><td><div id="idTeks"><input type="text" id="idNama" name="nmNama" value="" size="32" /></div></td></tr>
                            <tr>
                                <td class="tdKanan" width="140">Sandi</td><td></td><td><div id="idTeks"><input type="password" id="idSandi" name="nmSandi" value="" size="32" /></div></td></tr>
                            <tr class="trWarna">
                                <td class="tdKanan" width="140"></td><td></td><td><img id="idCaptcha" src="${URL}/clsCaptcha?w=1000" alt="" title="">
                                <a id="idBuatCaptcha" href="#">
                                <img id="idAnimasiAjaxCaptcha" border="0" alt="" width="16" height="16" src="${URL}/pilar/desain/standar/halaman/adpub/gambar/tombol/tombolAjaxCaptcha.png" align="bottom"></a></td></tr>
                            <tr><td class="tdKanan" width="140">Kode</td><td></td><td><div id="idTeks"><input type="text" id="idKode" name="nmKode" value="" size="32" /></div></td>
                            </tr>
                        </table> <!-- / tabel ini -->					
                        <table id="idtabelTombol" class="tabelTombol">
                            <tr>
                                <td class="clsTombol"><div class="cTdTombol"> <button id="idKirim" type="submit" class="clsPositif" name="kirim">
                                            <img id="idImgKirim" src="${URL}/pilar/desain/standar/halaman/adpub/gambar/tombol/tombolAjaxKirim.png" alt="Kirim"/>Kirim
                                </button></div>
                                </td>
                            </tr>
                        </table> 
                    </form>
                </div>
            </div>
	</div>	
</center>
                                
<!-- modal pesan -->
<div id="idPesanModal" class="modal-content">
    <div class="modal-header">
	<button type="button" class="close" onclick="Custombox.close();">&times;</button>
	<h4><img src="${URLModAdpubGambarMenu}/masuk.png"/> &nbsp; <strong>Informasi Sistem</strong></h4>
    </div>
    <div id="idIsiPesan" class="modal-body"></div>
</div>
  </jsp:attribute>
</admin:index>