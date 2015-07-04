<%@page import="pilar.cls.ClsPelanggan"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="pilar.cls.ClsSHA"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
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
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vEmail = "",
        vSandi = "",
        vNamaDepan = "",
        vNamaBelakang = "",
        vJenisKelamin = "",
        vTanggalLahir="",
        vKeluaran="",
        vNamaLengkap = "";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vEmail = oKata.fHapusSpasi(request.getParameter("dtEmail").toString());
            vSandi = oKata.fHapusSpasi(request.getParameter("dtSandi").toString());
            vNamaDepan = oKata.fSatuSpasi(request.getParameter("dtNamaDepan").toString()); 
            vNamaBelakang = oKata.fSatuSpasi(request.getParameter("dtNamaBelakang").toString());
            vJenisKelamin = oKata.fHapusSpasi(request.getParameter("dtJenisKelamin").toString());
            vTanggalLahir = oKata.fHapusSpasi(request.getParameter("dtTanggalLahir").toString());
            vNamaLengkap = vNamaDepan + " " + vNamaBelakang;
            
            ClsSHA oSHA = new ClsSHA();
            String vSandiEnkripsi = oSHA.fSHA256(vSandi);
            /* operasi basisdata */
            if(!vEmail.equals("") && 
                    !vSandi.equals("") && 
                    !vNamaDepan.equals("") &&
                    !vNamaBelakang.equals("") && 
                    !vJenisKelamin.equals("") &&
                    !vTanggalLahir.equals("")){
                /* membuat kode acak */
                ClsKode oKode = new ClsKode();
                String vKodeAcakOrang = "OR" + oKode.fBuatKodeAcak(14).toUpperCase();
                String vKodeAcakPelanggan = "PG" + oKode.fBuatKodeAcak(14).toUpperCase();
                
                Calendar now = Calendar.getInstance();
                
                String vTahunKini = String.valueOf(now.get(Calendar.YEAR));
                String vBulanKini =  String.valueOf(now.get(Calendar.MONTH) + 1);
                String vHariKini = String.valueOf(now.get(Calendar.DATE));
                String vTanggalKini = vTahunKini + "-" + vBulanKini + "-" + vHariKini;
                
                /* masukkan ke tabel orang */
                oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        "tb_sipil_orang",
                        new String[]{"kode"}, 
                        new String[]{vKodeOrang},
                        new String[]{"null",
                            "null",
                            "null",
                            vNamaDepan,
                            vNamaBelakang,
                            vNamaLengkap.trim(),
                            vJenisKelamin,
                            "null",
                            "null",
                            "null",
                            "null",
                            vTanggalLahir,
                            ""}, "u",true);
                
                /* masukkan ke tabel pelanggan */
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    "tb_pelanggan", 
                    new String[]{"kode_orang"}, new String[]{vKodeOrang}, 
                    new String[]{"null",
                        "null",
                        vEmail,vSandiEnkripsi,
                        "null",vTanggalKini}, 
                    "u",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalStd("", "", vModKonfNamaTabel, new String[]{"kode"});
                vKeluaran = "1";
                oOpsBasisdata.fTutupKoneksi();
            }
        }
    }
    
    out.println(vKeluaran);
%>