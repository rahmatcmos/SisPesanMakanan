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
        vKodeBanner = "",
        vKodeFotoBanner = "",
        vNama = "",
        vFotoSampul = "",
        vKeterangan = "",
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        
        /* ################### operasi tambah data */
        if(vOperasi.equals("t")){
           /* variabel POST */
            /* request berasal dari modHalamanBannerModalUploadFotoBanner/modal.jsp */
            vKodeBanner = oKata.fHapusSpasi(request.getParameter("dtKodeBanner").toString());
            vKodeFotoBanner = oKata.fHapusSpasi(request.getParameter("dtKodeFotoBanner").toString());
            
            /* operasi basisdata */
            int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                        "", 
                        vModKonfNamaTabel, 
                        new String[]{"kode"},
                        new String[]{"kode_hlm_banner"},
                        new String[]{vKodeBanner},
                        new String[]{"="},
                        new String[]{""});
            vKeluaran = Integer.toString(vJumDataTotal);
            oOpsBasisdata.fTutupKoneksi();
            
        }
        
        /* ################### operasi ubah data */
        if(vOperasi.equals("u")){
            /* variabel POST */
            vKodeBanner = oKata.fHapusSpasi(request.getParameter("dtKodeBanner").toString());
            vKodeFotoBanner = oKata.fHapusSpasi(request.getParameter("dtKodeFotoBanner").toString());
            vNama = oKata.fSatuSpasi(request.getParameter("dtNama").toString());
            vFotoSampul = oKata.fHapusSpasi(request.getParameter("dtFotoSampul").toString());
            vKeterangan = oKata.fSatuSpasi(request.getParameter("dtKeterangan").toString());
            
            /* operasi basisdata */
            if(!vKodeBanner.equals("") && !vKodeFotoBanner.equals("")){
                /* foto sampul */
                System.out.println("Foto sampul: " + vFotoSampul);
                if(vFotoSampul.equals("1")){
                    /* set sampul foto yang lain = 0 dalam satu banner  */
                    oOpsBasisdata.fBeriNilaiSamaSemuaBarisPadaKolomX("", "", vModKonfNamaTabel, "sampul", "kode_hlm_banner",vKodeBanner,"0");
                    
                }
                
                oOpsBasisdata.fOperasiBdDasar("", 
                    vModKonfNamaBd, 
                    vModKonfNamaTabel, 
                    new String[]{"kode"}, new String[]{vKodeFotoBanner}, 
                    new String[]{"null",vKodeFotoBanner,vNama,"null","null","null",vFotoSampul,vKeterangan,"null"}, 
                    "u",
                    true);
                
                int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisiArr("", 
                        "", 
                        vModKonfNamaTabel, 
                        new String[]{"kode"},
                        new String[]{"kode_hlm_banner"},
                        new String[]{vKodeBanner},
                        new String[]{"="},
                        new String[]{""});
                vKeluaran = Integer.toString(vJumDataTotal);
                oOpsBasisdata.fTutupKoneksi();
            }
        }
        
        /* ################### operasi hapus data */
        if(vOperasi.equals("h")){
            /* variabel POST */
            vKodeBanner = oKata.fHapusSpasi(request.getParameter("dtKodeBanner").toString());
            vKodeFotoBanner = oKata.fHapusSpasi(request.getParameter("dtKodeFotoBanner").toString());
            //out.println(vKodeFotoBanner);
            /* hapus banyak data */
            if(vKodeFotoBanner.contains("#")){
                out.println("Ya mengandung #.");
                String[] vArrKode = vKodeFotoBanner.split("#");
                for(String vKodeHapus:vArrKode){
                    
                    /* # hapus berkas */
                    /* mengambil nama berkas */
                    String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "nama_berkas", "kode", vKodeHapus);
                    String vEkstensi = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "ekstensi", "kode", vKodeHapus);
                    out.println("Hapus --> " + vKodeHapus);
                    out.println("Berkas --> " + vNamaBerkas + vEkstensi);
                    
                    File vFlBerkas = new File(ClsKonf.vKonfDirFoto + File.separator + "banner" + File.separator + vNamaBerkas + vEkstensi);
                    File vFlBerkasResize = new File(ClsKonf.vKonfDirFoto + File.separator + "banner" + File.separator + "r" + vNamaBerkas + vEkstensi);
                    File vFlBerkasThumbnail = new File(ClsKonf.vKonfDirFoto + File.separator + "banner" + File.separator + "t" + vNamaBerkas + vEkstensi);
                   
                    if(vFlBerkas.delete() && vFlBerkasResize.delete() && vFlBerkasThumbnail.delete()){
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKodeHapus}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk banner ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_hlm_banner"},new String[]{vKodeBanner},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                        out.println("Sudah dihapus.");
                    }else{
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel,new String[]{"kode"}, new String[]{vKodeHapus}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk banner ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_hlm_banner"},new String[]{vKodeBanner},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                        out.println("Sudah dihapus.");
                    }
                    
                }
            }
            
            /* hapus data tunggal */
            if(!vKodeFotoBanner.contains("#")){
                /* operasi basisdata */
                if(!vKodeFotoBanner.equals("")){
                    /* # hapus berkas */
                    /* mengambil nama berkas */
                    String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "nama_berkas", "kode", vKodeFotoBanner);
                    String vEkstensi = oOpsBasisdata.fAmbilSatuData("", vModKonfNamaBd, vModKonfNamaTabel, "ekstensi", "kode", vKodeFotoBanner);
                    File vFlBerkas = new File(ClsKonf.vKonfDirFoto + File.separator + "banner" + File.separator + vNamaBerkas + vEkstensi);
                    File vFlBerkasResize = new File(ClsKonf.vKonfDirFoto + File.separator + "banner" + File.separator + "r" + vNamaBerkas + vEkstensi);
                    File vFlBerkasThumbnail = new File(ClsKonf.vKonfDirFoto + File.separator + "banner" + File.separator + "t" + vNamaBerkas + vEkstensi);
                    
                    System.out.println("Nama berkas: " + vNamaBerkas + vEkstensi);
                    
                    if(vFlBerkas.delete() && vFlBerkasResize.delete() && vFlBerkasThumbnail.delete()){
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel, new String[]{"kode"}, new String[]{vKodeFotoBanner}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk banner ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_hlm_banner"},new String[]{vKodeBanner},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                    }else{
                        oOpsBasisdata.fOperasiBdDasar("", vModKonfNamaBd, vModKonfNamaTabel, new String[]{"kode"}, new String[]{vKodeFotoBanner}, new String[]{""}, "h", true);
                        /* jumlah data total foto untuk banner ini */
                        int vJumDataTotal = oOpsBasisdata.fJumDataTotalKondisi("", "", vModKonfNamaTabel, new String[]{"kode"},new String[]{"kode_hlm_banner"},new String[]{vKodeBanner},"=");
                        oOpsBasisdata.fTutupKoneksi();
                        vKeluaran = Integer.toString(vJumDataTotal);
                    }
                    
                    
                    
                }
            }
        }
        
        /* ################### operasi ambil nama berkas */
        if(vOperasi.equals("b")){
           /* variabel POST */
            /* request berasal dari modHalamanBannerModalUploadFotoBanner/modal.jsp */
            vKodeBanner = oKata.fHapusSpasi(request.getParameter("dtKodeBanner").toString());
            vKodeFotoBanner = oKata.fHapusSpasi(request.getParameter("dtKodeFotoBanner").toString());
            
            String vNamaBerkas = oOpsBasisdata.fAmbilSatuData("", "", vModKonfNamaTabel, "nama_berkas", "kode", vKodeFotoBanner);
            vKeluaran = vNamaBerkas;
        }
        
    }
    
    out.println(vKeluaran);
%>