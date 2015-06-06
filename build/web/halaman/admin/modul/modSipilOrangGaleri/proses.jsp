<%@page import="java.io.File"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* ################### memeriksa sesi halaman admin */
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
        response.sendRedirect(ClsKonf.vKonfURL);
    }
%>

<%
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vKodeOrang = "",
        vKodeFotoOrang = "",
        vNama = "",
        vFotoSampul = "",
        vKeterangan = "",
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("t")){
           /* variabel POST */
            /* request berasal dari modRestoModalUploadFotoOrang/modal.jsp */
            vKodeOrang = oKata.fHapusSpasi(request.getParameter("dtKodeOrang").toString());
            vKodeFotoOrang = oKata.fHapusSpasi(request.getParameter("dtKodeFotoOrang").toString());
            
            /* operasi basisdata */
            int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                        "", 
                        vModKonfNamaTabel, 
                        new String[]{"kode"},
                        new String[]{"kode_sipil_orang"},
                        new String[]{vKodeOrang},
                        new String[]{"="},
                        new String[]{""});
            vKeluaran = Integer.toString(vJumDataTotal);
            oOpsBasisdata.fTutupKoneksi();
            
        }
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vKodeOrang = oKata.fHapusSpasi(request.getParameter("dtKodeOrang").toString());
            vKodeFotoOrang = oKata.fHapusSpasi(request.getParameter("dtKodeFotoOrang").toString());
            vNama = oKata.fSatuSpasi(request.getParameter("dtNama").toString());
            vFotoSampul = oKata.fHapusSpasi(request.getParameter("dtFotoSampul").toString());
            vKeterangan = oKata.fSatuSpasi(request.getParameter("dtKeterangan").toString());
            
            /* operasi basisdata */
            if(!vKodeOrang.equals("") && !vKodeFotoOrang.equals("")){
                /* foto sampul */
                System.out.println("Foto sampul: " + vFotoSampul);
                if(vFotoSampul.equals("1")){
                    /* set sampul foto yang lain = 0 dalam satu orang  */
                    oOpsBasisdata.fBeriNilaiSamaSemuaBarisPadaKolomX("", "", vModKonfNamaTabel, "sampul", "kode_sipil_orang",vKodeOrang,"0");
                    
                }
                
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    vModKonfNamaTabel, 
                    new String[]{"kode"}, new String[]{vKodeFotoOrang}, 
                    new String[]{"null",vKodeFotoOrang,vNama,"null","null","null",vFotoSampul,vKeterangan,"null"}, 
                    "u",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                        "", 
                        vModKonfNamaTabel, 
                        new String[]{"kode"},
                        new String[]{"kode_sipil_orang"},
                        new String[]{vKodeOrang},
                        new String[]{"="},
                        new String[]{""});
                vKeluaran = Integer.toString(vJumDataTotal);
                oOpsBasisdata.fTutupKoneksi();
            }
        }
        
        /* ################### operasi hapus data */
        if(vOperasi.equals("h")){
            /* variabel POST */
            vKodeOrang = oKata.fHapusSpasi(request.getParameter("dtKodeOrang").toString());
            vKodeFotoOrang = oKata.fHapusSpasi(request.getParameter("dtKodeFotoOrang").toString());
            //out.println(vKodeFotoOrang);
            /* hapus banyak data */
            if(vKodeFotoOrang.contains("#")){
                out.println("Ya mengandung #.");
                String[] vArrKode = vKodeFotoOrang.split("#");
                for(String vKodeHapus:vArrKode){
                    
                    /* # hapus berkas */
                    /* mengambil nama berkas */
                    String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "nama_berkas", "kode", vKodeHapus);
                    String vEkstensi = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "ekstensi", "kode", vKodeHapus);
                    out.println("Hapus --> " + vKodeHapus);
                    out.println("Berkas --> " + vNamaBerkas + vEkstensi);
                    
                    File vFlBerkas = new File(ClsKonf.vKonfDirFoto + File.separator + vModKonfDirFoto + File.separator + vNamaBerkas + vEkstensi);
                    File vFlBerkasResize = new File(ClsKonf.vKonfDirFoto + File.separator + vModKonfDirFoto + File.separator + "r" + vNamaBerkas + vEkstensi);
                    File vFlBerkasThumbnail = new File(ClsKonf.vKonfDirFoto + File.separator + vModKonfDirFoto + File.separator + "t" + vNamaBerkas + vEkstensi);
                   
                    if(vFlBerkas.delete() && vFlBerkasResize.delete() && vFlBerkasThumbnail.delete()){
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKodeHapus}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk orang ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_sipil_orang"},new String[]{vKodeOrang},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                        out.println("Sudah dihapus.");
                    }else{
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKodeHapus}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk orang ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_sipil_orang"},new String[]{vKodeOrang},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                        out.println("Sudah dihapus.");
                    }
                    
                }
            }
            
            /* hapus data tunggal */
            if(!vKodeFotoOrang.contains("#")){
                /* operasi basisdata */
                if(!vKodeFotoOrang.equals("")){
                    /* # hapus berkas */
                    /* mengambil nama berkas */
                    String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "nama_berkas", "kode", vKodeFotoOrang);
                    String vEkstensi = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "ekstensi", "kode", vKodeFotoOrang);
                    File vFlBerkas = new File(ClsKonf.vKonfDirFoto + File.separator + vModKonfDirFoto + File.separator + vNamaBerkas + vEkstensi);
                    File vFlBerkasResize = new File(ClsKonf.vKonfDirFoto + File.separator + vModKonfDirFoto + File.separator + "r" + vNamaBerkas + vEkstensi);
                    File vFlBerkasThumbnail = new File(ClsKonf.vKonfDirFoto + File.separator + vModKonfDirFoto + File.separator + "t" + vNamaBerkas + vEkstensi);
                    
                    System.out.println("Nama berkas: " + vNamaBerkas + vEkstensi);
                    
                    if(vFlBerkas.delete() && vFlBerkasResize.delete() && vFlBerkasThumbnail.delete()){
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel, new String[]{"kode"}, new String[]{vKodeFotoOrang}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk orang ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_sipil_orang"},new String[]{vKodeOrang},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                    }else{
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel, new String[]{"kode"}, new String[]{vKodeFotoOrang}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk orang ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_sipil_orang"},new String[]{vKodeOrang},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                    }
                    
                    
                    
                }
            }
        }
        
        /* ################### operasi ambil nama berkas */
        if(vOperasi.equals("b")){
           /* variabel POST */
            /* request berasal dari modRestoModalUploadFotoOrang/modal.jsp */
            vKodeOrang = oKata.fHapusSpasi(request.getParameter("dtKodeOrang").toString());
            vKodeFotoOrang = oKata.fHapusSpasi(request.getParameter("dtKodeFotoOrang").toString());
            
            String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", "", vModKonfNamaTabel, "nama_berkas", "kode", vKodeFotoOrang);
            vKeluaran = vNamaBerkas;
        }
        
    }
    
    out.println(vKeluaran);
%>