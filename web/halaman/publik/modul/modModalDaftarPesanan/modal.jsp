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
    /* konf */
    ClsKonf oKonf = new ClsKonf();
    
    /* memeriksa sesi halaman pengguna */
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
    /* {VARIABEL} */
    String vHTMLGambarIcon = "pesanan64.png";
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vModKonfBanyakTampilanData", vModKonfBanyakTampilanData);
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/publik/modul/modModalDaftarPesanan" prefix="publik" %>
<publik:modal>
    <jsp:attribute name="atas">
        <!-- JS/CSS khusus di sini -->
	<script type="text/javascript">
            /* pemrogram: I Made Ariana (ariana@atlascitra.com)
             * waktu update: 2015.03.15/19:45 WIB
             */
            
            //<![CDATA[
                $(document).ready(function() {
                    /* ################### {VARIABEL GLOBAL} */
                    var vTgl = new Date();
                    var vWaktu;

                    /* ################### {NILAI AWAL VARIABEL} */
                    var vBanyakTampilanData = ${vModKonfBanyakTampilanData};
                    $('#idNoHalamanModal').val(0);
                    $('#idJumDataModal').val(vBanyakTampilanData);
                    $('#idKodeRadio').removeAttr('checked');
                
                    /* memanggil fungsi membuat tabel */
                    fBuatTabel(true);
                    
                    /* ################### {EVENT: MOUSE OVER} */
                    /* mouse over pada baris menampilkan tombol ubah dan hapus */
                    $('#idTabelDataModalR4').delegate('tbody > tr > td', 'mouseover', function() {
                        var vIndeks = $(this).parent().index();
                        //$('#idTabelData .clsTdTombolUbah').eq(vIndeks).removeAttr('style');
                        //$('#idTabelData .clsTdTombolHapus').eq(vIndeks).removeAttr('style');
                        //console.log($('.clsTombolUbah').eq(vIndeks).attr('value'));
                        $('.clsTombolPilihModal').eq(vIndeks).removeAttr('style');
                    });

                    /* ################### {EVENT: MOUSE LEAVE} */
                    /* mouse leave pada baris menyembunyikan tombol ubah dan hapus */
                    $('#idTabelDataModalR4').delegate('tbody > tr > td', 'mouseleave', function() {
                        var vIndeks = $(this).parent().index();
                        $('.clsTombolPilihModal').eq(vIndeks).attr('style','display:none');
                    });
                    
                    /* [T5] tombol pilih */
                    /*  metode akses berbeda karena dibuat secara live */
                    $(document).on('click', '.clsTombolPilihModal', function(e){ 
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        
                        var vKodeNama = $(this).attr("value");
                        var vArrKodeNama = vKodeNama.split("@");
                        var vKode = vArrKodeNama[0];
                        
                        var d = new Date();
                        var dtWaktu = d.getTime(); 
                        
                        Custombox.open({
                            id: 'idDetailPesanan',
                            target: '${URLModPublik}/modDetailBerita/modal.jsp?o=m&b='+ vKode + '&w='+dtWaktu,
                            effect: 'slide',
                            animation: 'top,top',
                            width: 700,
                            overlayClose: false,
                            zIndex: 2000,
                            cache: false
                        });
                        
                        // hindari > 1x klik
                        e.stopImmediatePropagation(); 
                    });
                    
                    /* [T6] tombol navigasi */
                    /* [T6:1]  tombol navigasi berikut */
                    $('.clsTombolNavBerikutModal').click(function(e){
                        e.preventDefault();                    
                        fBuatTabel(true);
                    });

                    /* [T6:2]  tombol navigasi sebelum */
                    $('.clsTombolNavSebelumModal').click(function(e){
                        e.preventDefault();
                        vJData = $('#idJumDataModal').val();
                        vOffset = parseInt($('#idNoHalamanModal').val())* vJData;
                        fBuatTabel(false);
                    });

                    /* [T7] tombol pencarian */
                    $('#idTombolCariModal').click(function(e){
                        e.preventDefault();
                        /* membuat tabel data */
                        fBuatTabel(false);
                    });

                    /* {EVENT: KEY UP} */
                    $('#idTeksCariModal').keyup(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();
                        if($('#idTeksCariModal').val() != ""){
                            /* membuat tabel */
                            fBuatTabel(false);
                        }
                    });
                    
                    /* {BAGIAN FUNGSI} */
                    /* [F1] fBuatTabel: membuat tabel. */                
                    function fBuatTabel(vFBerikut){
                        var vKolomCari = $('#idSelCariModal').val();
                        var vTeksCari = $('#idTeksCariModal').val();

                        /* #tabel ajax */
                        /* nomor halaman */
                        var vNoHalaman = parseInt($('#idNoHalamanModal').val());
                        if(!vFBerikut){
                            if(vNoHalaman != 1){
                                vNoHalaman -= 1;
                                $('#idNoHalamanModal').val(vNoHalaman);
                            }
                        }

                       var vJData = $('#idJumDataModal').val();
                       var vOffset = (vFBerikut)? parseInt(vNoHalaman) * vJData : (parseInt(vNoHalaman)-1)* vJData;

                       var vTgl = new Date();
                       var dtWaktu = vTgl.getTime();

                       /* urutan data */
                        var vUrutanData = $('#idUrutanDataModal').val();

                        /* tampilkan animasi */    
                        if(vFBerikut){
                            $('.clsGbrTombolBerikutModal').attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');
                        }else{
                            $('.clsGbrTombolSebelumModal').attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');
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
                               $("#idDivTabelDataModal").attr('style','display:none');
                               /* tampilkan pesan */
                               $("#idPesanTabelModal").removeClass("clsSembunyikanPesanModal");
                               $("#idPesanTabelModal").hide().addClass("clsTampilkanPesanModal")
                               $("#idPesanTabelModal").fadeIn().css('border','1px solid red');
                               $("#idPesanTabelModal").html("<b>Maaf, tidak ada data terkait kata pencarian tersebut.</b>");

                            }

                            /* bila tidak ada data dan kata pencarian kosong */
                            if(vDataSvr.trim() != "" && vArrDataSvr[0] == 0 && $('#idTeksCari').val() == ""){
                               /* sembunyikan bagian pencarian dan tabel */
                               //$("#idDivCariModal").attr('style','display:none');
                               $("#idDivTabelDataModal").attr('style','display:none');
                            }

                            if(vDataSvr.trim() != "" && vArrDataSvr[0] != 0){  
                                /* menampilkan navigasi */
                                if($(window.parent.document).find('#idDivNavigasiModal').hasClass('clsSembunyikanDiv')){
                                    $(window.parent.document).find('#idDivNavigasiModal').fadeOut().removeClass('clsSembunyikanDiv');
                                    $(window.parent.document).find('#idDivNavigasiModal').fadeIn().addClass('clsTampilkanDiv');
                                }

                                /* halaman maksimal */
                                var vNoHalamanMaks = (parseInt(vArrDataSvr[0]) - (parseInt(vArrDataSvr[0]) % parseInt(vJData)))/parseInt(vJData);
                                vNoHalamanMaks = ((parseInt(vArrDataSvr[0]) % parseInt(vJData)) > 0)? (vNoHalamanMaks + 1): vNoHalamanMaks;
                                $('#idNoHalamanModalMaksModal').val(vNoHalamanMaks);

                                /* halaman */                           
                                if(vFBerikut){
                                    vNoHalaman += 1;
                                    $('#idNoHalamanModal').val(vNoHalaman);
                                }

                                $("#idDivTabelDataModal").removeAttr('style','display:none');
                                /* sembunyikan tampilan pesan tabel */
                                $("#idPesanTabelModal").removeClass("clsTampilkanPesanModal");
                                $("#idPesanTabelModal").addClass("clsSembunyikanPesanModal");
                                $("#idPesanTabelModal").html('').css('border','none');
                                $("#idPesanTabelModal").css('display','none');

                                var oData = jQuery.parseJSON(vArrDataSvr[1].trim());
                                var i = 0;

                                /* hapus baris tabel */
                                $('#idTabelDataModalR4 tbody tr').remove();
                                /* iterasi baris */
                                $.each(oData,function(id,el){
                                    //console.log(id);
                                    //console.log(el.kode);
                                    //console.log(el.nama);
                                    i += 1;
                                    var vWarnaTr = (i%2==0) ? 'clsTrWarna':'clsTrBiasa';

                                    if(i<vJData && i != vArrDataSvr[2]){
                                        $('#idTabelDataModalR4 > tbody:last').append('<tr class=\"'+ vWarnaTr + '\">' + 
                                            '<td class=\"clsTdTanggal\">' + el.tanggal + ', Pkl. ' + el.jam + ' WIB</td>'+
                                            '<td class=\"clsTdNama\">' + el.judul + '</td>'+
                                            '<td class=\"clsTdTombolPilih\"><button class=\"clsTombolPilihModal shrink\" style=\"display:none\" value=\"' + el.kode + '@'+ el.judul + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolPilih.png\"></button></td>'+
                                            '</tr>');
                                    }

                                    if(i>=vJData || i == vArrDataSvr[2]){
                                        $('#idTabelDataModalR4 > tbody:last').append('<tr class=\"'+ vWarnaTr + '\">' + 
                                            '<td class=\"clsTdAkhir clsTdTanggal\">' + el.tanggal + ', Pkl. ' + el.jam + ' WIB</td>'+
                                            '<td class=\"clsTdNama clsTdAkhir\">' + el.judul + '</td>'+
                                            '<td class=\"clsTdTombolPilih clsTdPilihAkhir\"><button class=\"clsTombolPilihModal shrink\" style=\"display:none\" value=\"' + el.kode + '@'+ el.judul + '\"><img class=\"clsGbrTombol grow\" src=\"${URLModAdpubGambarTombol}/tombolPilih.png\"></button></td>'+
                                            '</tr>');
                                    }

                                });

                                /* tombol navigasi */
                                if(vFBerikut){
                                    $('.clsGbrTombolBerikutModal').attr('src','${URLModAdpubGambarTombol}/tombolBerikut24.png');
                                }else{
                                    $('.clsGbrTombolSebelumModal').attr('src','${URLModAdpubGambarTombol}/tombolSebelum24.png');
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
                                $('.clsTombolNavSebelumModal').attr('style','display:none');
                            }else{
                                $('.clsTombolNavSebelumModal').removeAttr('style','display:none');
                            }

                            if(vFNoHalaman == vFNoHalamanMaks){
                                $('.clsTombolNavBerikutModal').attr('style','display:none');
                            }else{
                                $('.clsTombolNavBerikutModal').removeAttr('style');
                            }
                        }

                        if(parseInt(vFNoHalamanMaks) == parseInt(0)){
                            $('.clsTombolNavSebelumModal').attr('style','display:none');
                            $('.clsTombolNavBerikutModal').attr('style','display:none');
                        }
                   }

                });
            //]]>     
	</script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
    <div class="clsModalIsiTabel700">
        <div class="clsModalJudulTabel700">
            <button type="button" class="close" onclick="Custombox.close('idDaftarPesanan');">&times;</button>
            <h4><img src="${URLModAdpubGambarMenu}/${vHTMLGambarIcon}"/> &nbsp; PESANAN</strong></h4>
        </div>
        <div class="clsModalBodyTabel700">
            <center>
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            <!-- tabel -->
            
                        <!-- bagian pencarian -->
                        <div id="idDivCariModal" class="clsSembunyikanDiv">
                            <table id="idTabelCariModal">
                                <tr>
                                    <td><select id="idSelCariModal" class="clsSelCariModal">
                                            <option value="nomor">Indeks</option>
                                            <option value="kode">Kode</option>
                                            <option value="judul" selected>Judul</option>
                                        </select>
                                    </td>
                                    <td><input type="text" id="idTeksCariModal" class="clsTeksCariModal" value=""/></td>
                                    <td class="clsTdCari"><button id="idTombolCariModal" class="clsTombolCariModal shrink"><img class="clsGbrTombolCariModal pulse-grow" src="${URLModAdpubGambarTombol}/tombolCari24.png"/></button></td>
                                </tr>
                            </table>
                        </div>

                        <!-- bagian pesan -->
                        <div id="idPesanTabelModal" class="clsSembunyikanPesanModal"></div>

                        <!-- bagian data -->
                        <div id="idDivTabelDataModalR4">
                            <table id="idTabelDataModalR4">
                                <thead class="clsThTabel">
                                    <th class="clsThTanggal">Tanggal</th>
                                    <th class="clsThJudul">Judul ${vModKonfNamaData}</th>
                                    <th class="clsThPilih"></th>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <!-- bagian navigasi -->
                        <div id="idDivNavigasiModal" class="clsSembunyikanDivModal">
                            <table id="idTabelNavigasiModal">
                                <tr>
                                    <td class="clsTdTeksJData">Jumlah Tampilan Data:</td>
                                    <td><input type="text" id="idJumDataModal" class="clsJumDataModal" value="5"/></td>
                                    <td>Urutan Data:</td>
                                    <td><select id="idUrutanDataModal" name="nmUrutanData">
                                            <option value="ASC" selected>a-Z # 123 # L-B</option>
                                            <option value="DESC">Z-a # 321 # B-L</option>
                                        </select>
                                    </td>
                                    <td class="clsTdTeksNoHalaman">
                                        Hal.-Total Hal.:
                                    </td>
                                    <td class="clsTdNoHalaman">
                                        <input type="text" id="idNoHalamanModal" class="clsNoHalamanModal" value="0" readonly/>
                                    </td>
                                    <td class="clsTdTeksDash">-</td>
                                    <td class="clsTdNoHalamanMaks">
                                        <input type="text" id="idNoHalamanModalMaksModal" class="clsNoHalamanMaksModal" value="0" readonly/>
                                    </td>
                                    <td class="clsTdSpasi"></td>
                                    <td class="clsTdSebelum">
                                        <button class="clsTombolNavSebelumModal shrink"><img class="clsGbrTombolSebelum pulse-grow" src="${URLModAdpubGambarTombol}/tombolSebelum24.png"/></button>
                                    </td>
                                    <td class="clsTdBerikut">
                                        <button class="clsTombolNavBerikutModal shrink"><img class="clsGbrTombolBerikut pulse-grow" src="${URLModAdpubGambarTombol}/tombolBerikut24.png"/></button>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    
            <!-- tabel -->
            </center>
        </div>
    </div>
  </jsp:attribute>
</publik:modal>