<%@page import="java.time.Instant"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="pilar.cls.ClsPelanggan"%>
<%@page import="java.io.File"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>
<%@page import="pilar.cls.ClsProduk"%>
<%@page import="java.util.List"%>
<%@page import="pilar.cls.ClsKeranjang"%>

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
    /* obyek olah kata */
    ClsOlahKata oKata = new ClsOlahKata();
    
    /* obyek basisdata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* variabel POST */
    String vOperasi = oKata.fHapusSpasi(request.getParameter("dtOperasi").toString()),
        vKeluaran="";
    
    if(!vOperasi.equals("")){
        /* ################### operasi tambah data */
        if(vOperasi.equals("t")){
            /* bila ada kode orang */
            if(!vKodeOrang.equals("")){
                vKeluaran = "1";
                /* 1) proses ke tabel faktur */
                String vKodeFaktur = "",
                        vPajak = "",
                        vBiayaAntar = "",
                        vTotal = "",
                        vKodeMetodePesan = "",
                        vKodeMetodeBayar = "",
                        vStatusPesanan = "0",
                        vStatusBayar = "0",
                        vCatatan = "",
                        vTanggal = "",
                        vJam = "",
                        vTimestamp = "";

                /* ## isi variabel */
                /* tanggal & jam */
                Date oTanggalKini = new Date();
                SimpleDateFormat oFormatTanggal = new SimpleDateFormat("yyyy-MM-dd");
                SimpleDateFormat oFormatWaktu = new SimpleDateFormat("HH:mm");

                vTanggal = oFormatTanggal.format(oTanggalKini);
                vJam = oFormatWaktu.format(oTanggalKini);

                /* timestamp */
                long vUnixTimestamp = Instant.now().getEpochSecond();
                vTimestamp = String.valueOf(vUnixTimestamp);

                ClsKode oKode = new ClsKode();
                vKodeFaktur = vModKonfKodeAwal + oKode.fBuatKodeAcak(14).toUpperCase();
                
                /* hitung total */
                /* obyek keranjang */
                ClsKeranjang oKeranjang = new ClsKeranjang();
                List<ClsProduk> vArrDaftarProduk = oKeranjang.ClsKeranjangBaru(request, "produk");
                
                /* pajak */
                String vPajakResto = oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_pajak", "pajak", "nomor", "1");

                Double vPajakTotal = 0.0;
                if(!vPajakResto.equals("")){
                    vPajakTotal = (Double.valueOf(vPajakResto)/100) * oKeranjang.fTotal();
                }
                
                vPajak = String.valueOf(vPajakTotal);
                
                /* biaya kurir */
                String vBiayaKurir = oOpsBasisdata.fAmbilSatuData("", "", "tb_resto_biaya_kurir", "biaya", "nomor", "1");

                Double vTotalKurir = oKeranjang.fTotal();

                if(!vBiayaKurir.equals("")){
                    vTotalKurir = (vPajakTotal + oKeranjang.fTotal()) + Double.valueOf(vBiayaKurir);
                }
                
                vBiayaAntar = vBiayaKurir;
                
                /* total */
                vTotal = Double.toString(vTotalKurir);
                /* ambil data */

                /* masukkan ke tabel faktur jual */
                oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        "tb_faktur_jual",
                        new String[]{"kode"}, 
                        new String[]{vKodeFaktur},
                        new String[]{"null",
                            vKodeFaktur,
                            vPajak,
                            vBiayaAntar,
                            vTotal,
                            vKodeOrang,
                            vKodeMetodePesan,
                            vKodeMetodeBayar,
                            vStatusPesanan,
                            vStatusBayar,
                            vCatatan,
                            vTanggal,
                            vJam,
                            vTimestamp
                        }, "t",true);

                /* 2) proses ke tabel transaksi */
                double vKuantitas = 0;
                double vHarga = 0;
                double vSubTotal = 0;
                
                for(ClsProduk vProduk: vArrDaftarProduk){
                    if(!vProduk.getvPrvKode().equals("")){

                        vKuantitas = Double.parseDouble(vProduk.getvPrvKuantitas());
                        vHarga = Double.parseDouble(vProduk.getvPrvHarga());
                        vSubTotal = vKuantitas * vHarga;

                        System.out.println(vProduk.getvPrvKode());
                        /* masukkan ke dalam tabel transaksi */
                        oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        "tb_transaksi_jual",
                        new String[]{"kode_faktur_jual"}, 
                        new String[]{vKodeFaktur},
                        new String[]{"null",
                            vKodeFaktur,
                            vProduk.getvPrvKode(),
                            vKodeOrang,
                            String.valueOf(vHarga),
                            String.valueOf(vKuantitas),
                            String.valueOf(vSubTotal),
                            vCatatan,
                            vTanggal,
                            vJam,
                            vTimestamp
                        }, "t",false);
                       
                    }
                    
                    /* 3) masukkan ke tabel operator pemesanan */
                    oOpsBasisdata.fOperasiBdDasar("",
                        vModKonfNamaBd, 
                        "tb_operator_pemesanan",
                        new String[]{"kode_faktur"}, 
                        new String[]{vKodeFaktur},
                        new String[]{"null",
                            vKodeFaktur,
                            "",
                            vKodeOrang,
                            "0",
                            vTanggal,
                            vJam,
                            vTimestamp
                        }, "t",true);

                }
            }
            
            /* bila tidak ada kode orang */
            if(vKodeOrang.equals("")){
                vKeluaran = "0";
            }
        }
    }
    
    out.println(vKeluaran);
%>