<%@page import="pilar.cls.ClsKonf,pilar.cls.ClsAdmin" %>

<% 
    /* memeriksa sesi halaman admin */
    ClsKonf ClsKonf = new ClsKonf();
    ClsAdmin oAdmin = new ClsAdmin();
    try{
        if(session.getAttribute("sesID") != "" && !session.getId().equals("")){
            boolean vStatusSesi = oAdmin.fHalamanAdmin(session);
            if(!vStatusSesi){
                response.sendRedirect(ClsKonf.vKonfURL);
            }
        }
    }catch(Exception e){
        response.sendRedirect(ClsKonf.vKonfURL);
    }
    
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/admin/modul/modMenuUtama" prefix="admin" %>
<admin:index>
  <jsp:attribute name="atas">
    <!-- JS/CSS khusus di sini -->
	<script type="text/javascript">
		$( document ).ready(function() {
                    /* ################### {VARIABEL GLOBAL} */
                    var vTgl = new Date();
                    var vWaktu;
                    
                    /* menu */
                    $(function() {
                        $( '#dl-menuSistem' ).dlmenu({
                            animationClasses : { classin : 'dl-animate-in-2', classout : 'dl-animate-out-2' }
                        });
                    });
                    
                    $(function() {
                        $( '#dl-menuData' ).dlmenu({
                            animationClasses : { classin : 'dl-animate-in-2', classout : 'dl-animate-out-2' }
                        });
                    });
                    
                    $(function() {
                        $( '#dl-menuRestoran' ).dlmenu({
                            animationClasses : { classin : 'dl-animate-in-2', classout : 'dl-animate-out-2' }
                        });
                    });
                    
                    /* tautan */
                    /* 1) pengaturan lokasi */
                    $('#idPengaturanLokasi').click(function(e) {
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        vWaktu = vTgl.getTime();

                        /* menampilkan halaman dalam bentuk modal */
                        Custombox.open({
                            target: '${URLModAdmin}/modPengaturanLokasi/modal.jsp?o=u&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            overlayClose: false
                        });
                    });    
                    
                    $('#idMenuHalamanPublikProfilUsaha').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        vWaktu = vTgl.getTime();

                        /* menampilkan halaman dalam bentuk modal */
                        Custombox.open({
                            target: '${URLModAdmin}/modHalamanProfilUsaha/modal.jsp?o=u&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            overlayClose: false,
                            width: 700,
                            height: 500
                        });
                    });
                    
                    /* menu kontak */
                    $('#idMenuHalamanPublikKontak').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        vWaktu = vTgl.getTime();

                        /* menampilkan halaman dalam bentuk modal */
                        Custombox.open({
                            target: '${URLModAdmin}/modHalamanKontak/modal.jsp?o=u&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            overlayClose: false,
                            width: 700,
                            height: 500
                        });
                    });
                    
                    /* menu syarat */
                    $('#idMenuHalamanPublikSyarat').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        vWaktu = vTgl.getTime();

                        /* menampilkan halaman dalam bentuk modal */
                        Custombox.open({
                            target: '${URLModAdmin}/modHalamanSyarat/modal.jsp?o=u&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            overlayClose: false,
                            width: 700,
                            height: 500
                        });
                    });
                    
                    /* biaya kurir */
                    $('#idMenuRestoBiayaKurir').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        vWaktu = vTgl.getTime();

                        /* menampilkan halaman dalam bentuk modal */
                        Custombox.open({
                            target: '${URLModAdmin}/modRestoBiayaKurir/modal.jsp?o=u&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            overlayClose: false,
                            width: 380
                        });
                    });
                    
                    /* pajak restoran */
                    $('#idMenuRestoPajak').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        vWaktu = vTgl.getTime();

                        /* menampilkan halaman dalam bentuk modal */
                        Custombox.open({
                            target: '${URLModAdmin}/modRestoPajak/modal.jsp?o=u&w=' + vWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            overlayClose: false,
                            width: 380
                        });
                    });
                    
                    
                });
                
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
                                    <img src="${URLModAdpubGambarMenu}/menu.png"/>
                                </td>
                                <td class="clsTdJudulModMenu"><center>MENU UTAMA ADMIN</center></td>
                                <td class="clsTdMenuKeluar">
                                    <!-- menu keluar -->
                                    <a id="idKeluar" href="${URLModAdmin}/modKeluar/index.jsp"><img class="pulse-grow" src="${URLModAdpubGambarMenu}/keluar64.png"/></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                
                <tr>
                    <td class="clsTdTerluar">
                        <center>
                            <table id="idTabelMenu" class="clsTabelMenu">
                                <tr>
                                    <!-- ## menu: sistem -->
                                    <td class="clsGambar">
                                        <div id="dl-menuSistem" class="dl-menuwrapper" >
                                            <button class="dl-trigger grow"><img src="${URLModAdpubGambarMenu}/sistem64.png" height="45"/></button>
                                            <ul class="dl-menu">
                                                <li><a href="#">Admin</a></li>
                                                <li><a href="${URLModAdmin}/modRestoOperator/index.jsp">Operator</a></li>
                                                <li><a href="#">Halaman</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="#">Publik</a>
                                                            <ul class="dl-submenu">
                                                                <li><a id="idMenuHalamanPublikProfilUsaha" href="#">Profil Usaha</a></li>
                                                                <li><a id="idMenuHalamanPublikBerita" href="${URLModAdmin}/modHalamanBerita/index.jsp">Berita</a></li>
                                                                <li><a id="idMenuHalamanPublikKontak" href="">Kontak</a></li>
                                                                <li><a id="idMenuHalamanPublikBanner" href="${URLModAdmin}/modHalamanBanner/index.jsp">Banner</a></li>
                                                                <li><a id="idMenuHalamanPublikSyarat" href="#">Syarat Ketentuan</a></li>
                                                            </ul>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li><a href="#">Pengaturan</a>
                                                    <ul class="dl-submenu">
                                                        <li><a id="idPengaturanLokasi" href="#">Lokasi</a></li>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                    
                                    <!-- ## menu: data -->
                                    <td class="clsGambar">
                                          <div id="dl-menuData" class="dl-menuwrapper" >
                                            <button class="dl-trigger grow"><img src="${URLModAdpubGambarMenu}/data64.png" height="45"/></button>
                                            <ul class="dl-menu">
                                                <li><a href="#">Restoran</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modRestoDepartemen/index.jsp">Departemen</a></li>
                                                        <li><a href="${URLModAdmin}/modRestoPekerjaan/index.jsp">Pekerjaan</a></li>
                                                        <li><a href="${URLModAdmin}/modRestoJenisOperator/index.jsp">Jenis Operator</a></li>
                                                        <li><a id="idMenuRestoPajak" href="#">Pajak Restoran</a></li>
                                                        <li><a id="idMenuRestoBiayaKurir" href="#">Biaya Kurir</a></li>
                                                    </ul>
                                                </li>
                                                <li><a href="#">Geopolitik</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modGeopolitikNegara/index.jsp">Negara</a></li>
                                                        <li><a href="${URLModAdmin}/modGeopolitikProvinsi/index.jsp">Provinsi</a></li>
                                                        <li><a href="${URLModAdmin}/modGeopolitikKabupaten/index.jsp">Kabupaten</a></li>
                                                        <li><a href="${URLModAdmin}/modGeopolitikKecamatan/index.jsp">Kecamatan</a></li>
                                                        <li><a href="${URLModAdmin}/modGeopolitikJalan/index.jsp">Jalan</a></li>
                                                    </ul>
                                                </li>
                                                <li><a href="#">Finansial</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modFinansialMetodeBayar/index.jsp">Metode Bayar</a></li>
                                                        <li><a href="${URLModAdmin}/modFinansialAlatBayar/index.jsp">Alat Pembayaran</a></li>
                                                        <li><a href="${URLModAdmin}/modFinansialMataUang/index.jsp">Mata Uang</a></li>
                                                    </ul>
                                                </li>
                                                <li><a href="#">Telekomunikasi</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modTelkomNegara/index.jsp">Kode Negara</a></li>
                                                        <li><a href="${URLModAdmin}/modTelkomWilayah/index.jsp">Kode Wilayah</a></li>
                                                        <li><a href="${URLModAdmin}/modGeopolitikKabupaten/index.jsp">Kode Mobile Prefix</a></li>
                                                        <li><a href="${URLModAdmin}/modTelkomKodePos/index.jsp">Kode Pos</a></li>
                                                    </ul>
                                                </li>
                                                <li><a href="#">Kependudukan</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modSipilJenisIdentitas/index.jsp">Jenis Identitas</a></li>
                                                        <li><a href="${URLModAdmin}/modSipilGelar/index.jsp">Gelar</a></li>
                                                        <li><a href="${URLModAdmin}/modSipilSebutan/index.jsp">Sebutan</a></li>
                                                        <li><a href="${URLModAdmin}/modSipilOrang/index.jsp">Orang</a></li>
                                                    </ul>
                                                </li>
                                                <li><a href="#">Produk</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modProdukSatuan/index.jsp">Satuan</a></li>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                    
                                    <!-- ## menu: restoran -->
                                    <td class="clsGambar">
                                          <div id="dl-menuRestoran" class="dl-menuwrapper" >
                                            <button class="dl-trigger grow"><img src="${URLModAdpubGambarMenu}/restoran64.png" height="45"/></button>
                                            <ul class="dl-menu">
                                                <li><a href="#">Transaksi</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modRestoTransaksi/index.jsp">Transaksi</a></li>                                                   
                                                    </ul>
                                                </li>
                                                <li><a href="#">Produk</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modRestoKategoriProduk/index.jsp">Kategori Produk</a></li>
                                                        <li><a href="${URLModAdmin}/modRestoJenisProduk/index.jsp">Jenis Produk</a></li>
                                                        <li><a href="${URLModAdmin}/modRestoProduk/index.jsp">Produk</a></li>                                                        
                                                    </ul>
                                                </li>
                                                <li><a href="#">Karyawan</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modRestoKaryawan/index.jsp">Karyawan</a></li>
                                                    </ul>
                                                </li>
                                                <li><a href="#">Pelanggan</a>
                                                    <ul class="dl-submenu">
                                                        <li><a href="${URLModAdmin}/modPelanggan/index.jsp">Pelanggan</a></li>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr> 
                                <tr>
                                    <td class="clsTulisan">SISTEM</td>
                                    <td class="clsTulisan">DATA</td>
                                    <td class="clsTulisan">RESTORAN</td>
                                </tr>
                                
                                
                            </table>
                            </center>
                    </td>
                </tr>
            </table>
        </div>
    </center>
  </jsp:attribute>
</admin:index>