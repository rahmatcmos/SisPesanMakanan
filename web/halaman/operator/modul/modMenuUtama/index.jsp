<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsKonf,pilar.cls.ClsOperator" %>

<% 
    /* memeriksa sesi halaman operator */
    ClsKonf ClsKonf = new ClsKonf();
    ClsOperator oOperator = new ClsOperator();
    try{
        if(session.getAttribute("sesIDOp") != "" && !session.getId().equals("")){
            boolean vStatusSesi = oOperator.fHalamanOperator(session);
            if(!vStatusSesi){
                response.sendRedirect(ClsKonf.vKonfURL);
            }
        }
    }catch(Exception e){
        response.sendRedirect(ClsKonf.vKonfURL);
    }
    
    /* jenis operator */
    String vJenisOp =  session.getAttribute("sesJenisOp").toString();
    
    request.setAttribute("vKodeOperator", session.getAttribute("sesKodeOp").toString());
%>

<% 
    /* obyek operasi basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    /* mengambil kode operator */
    String vOperatorPemesanan = "JOFK7ABU";
    String vOperatorJuruMasak = "JOEF4WJE";
    String vOperatorKurir = "JORYQRVH";
    
    /* 1) operator pemesanan */
    if(vJenisOp.equals(vOperatorPemesanan)){
        request.setAttribute("vJenisOperator", "PEMESANAN");
        request.setAttribute("vGambarMenu", "pemesanan.png");
        request.setAttribute("vModulPesananOperator", "modPesananOperatorPemesanan");
    }
    
    /* 2) operator juru masak */
    if(vJenisOp.equals(vOperatorJuruMasak)){
        request.setAttribute("vJenisOperator", "JURU MASAK");
        request.setAttribute("vGambarMenu", "jurumasak.png");
        request.setAttribute("vModulPesananOperator", "modPesananOperatorJuruMasak");
    }
    
    /* 3) operator kurir */
    if(vJenisOp.equals(vOperatorKurir)){
        request.setAttribute("vJenisOperator", "PENGANTARAN");
        request.setAttribute("vGambarMenu", "pengantaran.png");
        request.setAttribute("vModulPesananOperator", "modPesananOperatorKurir");
    }
    
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/operator/modul/modMenuUtama" prefix="operator" %>
<operator:index>
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
                                    <img src="${URLModAdpubGambarMenu}/${vGambarMenu}"/>
                                </td>
                                <td class="clsTdJudulModMenu"><center>MENU UTAMA<br>OPERATOR ${vJenisOperator}</center></td>
                                <td class="clsTdMenuKeluar">
                                    <!-- menu keluar -->
                                    &nbsp;
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
                                    <!-- ## menu: profil -->
                                    <td class="clsGambar">
                                        <div id="dl-menuSistem" class="dl-menuwrapper" >
                                            <button class="dl-trigger grow"><img src="${URLModAdpubGambarMenu}/profil64.png" height="45"/></button>
                                        </div>
                                    </td>
                                    
                                    <!-- ## menu: transaksi/tugas -->
                                    <td class="clsGambar">
                                        <div id="dl-menuData" class="dl-menuwrapper" >
                                            <a id="idKeluar" href="${URLModOperator}/${vModulPesananOperator}/index.jsp"><button class="dl-trigger grow"><img src="${URLModAdpubGambarMenu}/tugas48.png" height="45"/></button></a>
                                        </div>
                                    </td>
                                    
                                    <!-- ## menu: keluar -->
                                    <td class="clsGambar">
                                          <div id="dl-menuRestoran" class="dl-menuwrapper" >
                                            <a id="idKeluar" href="${URLModOperator}/modKeluar/index.jsp"><button class="dl-trigger grow"><img src="${URLModAdpubGambarMenu}/keluar64.png" height="45"/></button></a>
                                            
                                        </div>
                                    </td>
                                </tr> 
                                <tr>
                                    <td class="clsTulisan">PROFIL</td>
                                    <td class="clsTulisan">PESANAN</td>
                                    <td class="clsTulisan">KELUAR</td>
                                </tr>
                                
                                
                            </table>
                            </center>
                    </td>
                </tr>
            </table>
        </div>
    </center>
  </jsp:attribute>
</operator:index>