/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pilar.servlet.admin;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.image.RenderedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.*;
 
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import net.coobird.thumbnailator.Thumbnails;
import org.imgscalr.Scalr;
import static org.imgscalr.Scalr.*;

import pilar.cls.ClsKonf;
import pilar.cls.ClsKode;
import pilar.cls.ClsAdmin;
import pilar.cls.ClsCatat;
import pilar.cls.ClsOlahKata;
import pilar.cls.ClsOperasiBasisdata;
 
//@MultipartConfig          /* MIME type -> “multipart/form-data” */
@MultipartConfig(fileSizeThreshold=1024*1024*2,	// 2MB 
				 maxFileSize=1024*1024*10, // 10MB
				 maxRequestSize=1024*1024*50) // 50MB
//@WebServlet("/ClsSrvUploadFoto")
public class ClsSrvUploadFoto extends HttpServlet {
 
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,HttpServletResponse response) 
            throws ServletException, IOException {
        
        /* halaman admin atau tidak */
        /* @sesi halaman admin */
        ClsKonf oKonf = new ClsKonf();
        ClsAdmin oAdmin = new ClsAdmin();
        ClsOlahKata oOlahKata = new ClsOlahKata();
        
        try{
            HttpSession session = request.getSession();
            
            if(session.getAttribute("sesID") != "" && !session.getId().equals("")){
                boolean vStatusSesi = oAdmin.fHalamanAdmin(session);
                if(!vStatusSesi){
                    System.out.println("Bukan dalam sesi admin!");
                    response.sendRedirect(ClsKonf.vKonfURL);
                }
            }
        }catch(Exception e){
            /* pencatatan sistem */
                if(ClsKonf.vKonfCatatSistem == true){
                    String vNamaBerkas = "ClsSrvUploadFoto.java";
                    String vNamaServlet = "ClsSrvUploadFoto";
                    String vCatatan = vNamaBerkas + "#" + vNamaServlet + "#" + e.toString();
                    /* obyek catat */
                    ClsCatat oCatat = new ClsCatat();
                    oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                            ClsKonf.vKonfCatatKeBD, 
                            ClsKonf.vKonfCatatKeBerkas, 
                            vCatatan);
                }
        }
        
        /* {OPERASI UPLOAD} */
        /* data post */
        String vPostKodeRef = oOlahKata.fHapusSpasi(request.getParameter("nmKodeRef"));
        String vPostDataRef = oOlahKata.fHapusSpasi(request.getParameter("nmDataRef"));
        String vPostKode = oOlahKata.fHapusSpasi(request.getParameter("nmKode"));
        String vPostNama = oOlahKata.fSatuSpasi(request.getParameter("nmNama"));
        String vPostKeterangan = oOlahKata.fSatuSpasi(request.getParameter("nmKeterangan"));
        
        String vPostLebarFoto = oOlahKata.fHapusSpasi(request.getParameter("nmLebarFoto"));
        String vPostTinggiFoto = oOlahKata.fHapusSpasi(request.getParameter("nmTinggiFoto"));
        String vPostLebarThumb = oOlahKata.fHapusSpasi(request.getParameter("nmLebarThumb"));
        String vPostTinggiThumb = oOlahKata.fHapusSpasi(request.getParameter("nmTinggiThumb"));
        
        System.out.println(vPostLebarFoto + "#"+ vPostTinggiFoto + "#" + vPostLebarThumb + "#" + vPostTinggiThumb);
        
        boolean vBoolStatusDataPost = false;
        if(!vPostKodeRef.equals("") &&
                !vPostDataRef.equals("") &&
                !vPostKode.equals("") &&
                !vPostNama.equals("") &&
                !vPostLebarFoto.equals("") &&
                !vPostTinggiFoto.equals("") &&
                !vPostLebarThumb.equals("") &&
                !vPostTinggiThumb.equals("")){
            
            vBoolStatusDataPost = true;
        }
        
        // bila data post sudah terisi
        if(vBoolStatusDataPost){
            /* data apa? */
            String vDataRef = "";
            if(vPostDataRef.equals("produk")){
                vDataRef = "produk";
            }

            if(vPostDataRef.equals("orang")){
                vDataRef = "orang";
            }
            
            if(vPostDataRef.equals("berita")){
                vDataRef = "berita";
            }
            
            if(vPostDataRef.equals("banner")){
                vDataRef = "banner";
            }

            //System.out.println("vKode:vData:vKeterangan --> " + vKodeRef +":"+vDataRef+":"+vKeterangan);
            String vPesanRespon = "Berkas berhasil di-upload!";

            /* ambil bagian berkas menggunakan metode  HttpServletRequest’s getPart() */
            Part vBerkasPart = request.getPart("file");

            /* ekstrak nama berkas dari content-disposition header pada bagian berkas */
            String vNamaBerkas = fAmbilNamaBerkas(vBerkasPart);
            String vJenisKonten = vBerkasPart.getContentType().trim();
            String vEkstensi = "";
            System.out.println("Jenis berkas: " + vJenisKonten);

            boolean vBoolEkstensi = false;
            if(vJenisKonten.equals("image/jpeg")){
                vEkstensi = ".jpg";
                vBoolEkstensi = true;
            }
            if(vJenisKonten.equals("image/png")){
                vEkstensi = ".png";
                vBoolEkstensi = true;
            }
            /* bila ekstensi tidak valid */
            if(vBoolEkstensi){

                /* nama berkas baru */
                ClsKode oKode = new ClsKode();
                String vKodeAcak1 = oKode.fBuatKodeAcak(24);
                String vKodeAcak2 = oKode.fBuatKodeAcak(32);
                String vNamaBerkasBaru = vKodeAcak1 + vKodeAcak2;

                String vDirFoto = ClsKonf.vKonfDirFoto + File.separator + vDataRef + File.separator;
                System.out.println("Dir foto: " + vDirFoto);
                System.out.println("Nama berkas: " + vNamaBerkas);

                /* salin masukan berkas ke path tujuan */
                InputStream vInputStream = null;
                OutputStream vOutputStream = null;

                try {
                    File vLetakBerkasTujuan = new File(vDirFoto + vNamaBerkasBaru + vEkstensi);
                    System.out.println("vLetakBerkasTujuan: " + vLetakBerkasTujuan.getAbsolutePath());	
                    vInputStream = vBerkasPart.getInputStream();
                    vOutputStream = new FileOutputStream(vLetakBerkasTujuan);

                    int read = 0;
                    final byte[] bytes = new byte[1024];
                    while ((read = vInputStream.read(bytes)) != -1) {
                        vOutputStream.write(bytes, 0, read);
                    }

                    /* 1) resize foto -> tinggi: 400px -> untuk zoom */
                    int vIntLebarFoto = Integer.valueOf(vPostLebarFoto);
                    int vIntTinggiFoto = Integer.valueOf(vPostTinggiFoto);

                    Thumbnails.of(new File(vDirFoto + vNamaBerkasBaru + vEkstensi))
                        .size(vIntLebarFoto, vIntTinggiFoto)
                        .toFile(new File(vDirFoto + "r" + vNamaBerkasBaru + vEkstensi));

                    /* 2) thumbnail foto -> 200 x 200 */
                    int vIntLebarThumb = Integer.valueOf(vPostLebarThumb);
                    int vIntTinggiThumb = Integer.valueOf(vPostTinggiThumb);

                    BufferedImage oBfAsli = ImageIO.read(new File(vDirFoto + "r" + vNamaBerkasBaru + vEkstensi));
                    int vLebar = oBfAsli.getWidth();
                    int vTinggi = oBfAsli.getHeight();

                    double vRasioLT = (double)vLebar / (double)vTinggi;

                    /* bila lebar lebih panjang daripada tinggi */
                    if(vRasioLT > 1.0 ){
                        System.out.println("landscape");
                    }

                    /* bila lebar lebih pendek daripada tinggi */
                    if(vRasioLT < 1.0 ){
                        System.out.println("portrait");
                    }

                    /* bila lebar sama dengan tinggi */
                    if(vRasioLT == 1.0 ){
                        System.out.println("square");
                    }

                    if(vLebar < vIntLebarThumb){
                        /* resize lebar */
                        oBfAsli = Scalr.resize(oBfAsli, Scalr.Method.SPEED, Scalr.Mode.FIT_TO_WIDTH,
                                         vIntLebarThumb, vIntTinggiThumb, Scalr.OP_ANTIALIAS);
                    }

                    if(vTinggi < vIntTinggiThumb){
                        /* resize tinggi */
                        oBfAsli = Scalr.resize(oBfAsli, Scalr.Method.SPEED, Scalr.Mode.FIT_TO_HEIGHT,
                                         vIntLebarThumb, vIntTinggiThumb, Scalr.OP_ANTIALIAS);
                    }

                    oBfAsli = crop(oBfAsli,vIntLebarThumb, vIntTinggiThumb);
                    File vBerkasThumbnail = new File(vDirFoto + "t" + vNamaBerkasBaru + vEkstensi);

                    if(vEkstensi.equals(".jpg")){
                        ImageIO.write(oBfAsli, "jpg", vBerkasThumbnail);
                    }

                    if(vEkstensi.equals(".png")){
                        ImageIO.write(oBfAsli, "png", vBerkasThumbnail);
                    }

                    /* simpan ke basisdata */
                    if(vDataRef.equals("produk")){
                        this.fSimpanKeBasisdata(vDataRef, 
                                vPostKodeRef, 
                                vPostKode,
                                vPostNama,
                                vPostKeterangan, 
                                vNamaBerkas, 
                                vNamaBerkasBaru,
                                vEkstensi);
                    }

                    if(vDataRef.equals("orang")){
                        this.fSimpanKeBasisdata(vDataRef, 
                                vPostKodeRef, 
                                vPostKode,
                                vPostNama,
                                vPostKeterangan, 
                                vNamaBerkas, 
                                vNamaBerkasBaru,
                                vEkstensi);
                    }
                    
                    if(vDataRef.equals("berita")){
                        this.fSimpanKeBasisdata(vDataRef, 
                                vPostKodeRef, 
                                vPostKode,
                                vPostNama,
                                vPostKeterangan, 
                                vNamaBerkas, 
                                vNamaBerkasBaru,
                                vEkstensi);
                    }
                    
                    if(vDataRef.equals("banner")){
                        this.fSimpanKeBasisdata(vDataRef, 
                                vPostKodeRef, 
                                vPostKode,
                                vPostNama,
                                vPostKeterangan, 
                                vNamaBerkas, 
                                vNamaBerkasBaru,
                                vEkstensi);
                    }

                }catch(FileNotFoundException fne){
                        vPesanRespon = "Upload berkas gagal!";
                    } finally {
                    if (vOutputStream != null) {
                        vOutputStream.close();
                    }
                    if (vInputStream != null) {
                        vInputStream.close();
                    }
                }
            }
        }
    }
 
    /* fAmbilNamaBerkas: mengambil nama berkas */
    private String fAmbilNamaBerkas(Part vFPart){
        final String vPartHeader = vFPart.getHeader("content-disposition");
        
        for (String vKonten : vFPart.getHeader("content-disposition").split(";")) {
            if (vKonten.trim().startsWith("filename")){
                return vKonten.substring(vKonten.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
    
    public static BufferedImage fBuatThumbnail(BufferedImage vFBf,int vFLebar, int vFTinggi) {
        vFBf = crop(vFBf, vFLebar, vFTinggi);

        return pad(vFBf, 4);
    }
    
    public void fSimpanBfKeBerkas(BufferedImage vFBfImage, File vFBerkas, String vFEkstensi) throws IOException {
        
        Graphics2D bImageGraphics = vFBfImage.createGraphics();
        bImageGraphics.drawImage(vFBfImage, null, null);
            
        if(vFEkstensi.equals(".png")){
            ImageIO.write((RenderedImage) vFBfImage, "png", vFBerkas);
        }
        
        if(vFEkstensi.equals(".jpg")){
            ImageIO.write((RenderedImage) vFBfImage, "jpg", vFBerkas);
        }
        
    }
    private void fSimpanKeBasisdata(
            String vFDataRef,
            String vFKodeRef,
            String vFKode,
            String vFNama,
            String vFKeterangan,
            String vFNamaBerkasAsli, 
            String vFNamaBerkasBaru,
            String vFEkstensi){
        
        ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
        
        /* produk */
        if(vFDataRef.equals("produk")){
            oOpsBasisdata.fOperasiBdDasar("",
                "", 
                "tb_resto_produk_foto",
                new String[]{"kode"}, 
                new String[]{vFKode},
                new String[]{"null",vFKode,vFNama,vFNamaBerkasBaru,vFNamaBerkasAsli,vFEkstensi,"0",vFKeterangan,vFKodeRef}, "t",true);

        }
        
        /* orang */
        if(vFDataRef.equals("orang")){
            oOpsBasisdata.fOperasiBdDasar("",
                "", 
                "tb_sipil_orang_foto",
                new String[]{"kode"}, 
                new String[]{vFKode},
                new String[]{"null",vFKode,vFNama,vFNamaBerkasBaru,vFNamaBerkasAsli,vFEkstensi,"0",vFKeterangan,vFKodeRef}, "t",true);

        }
        
         /* berita */
        if(vFDataRef.equals("berita")){
            oOpsBasisdata.fOperasiBdDasar("",
                "", 
                "tb_hlm_berita_foto",
                new String[]{"kode"}, 
                new String[]{vFKode},
                new String[]{"null",vFKode,vFNama,vFNamaBerkasBaru,vFNamaBerkasAsli,vFEkstensi,"0",vFKeterangan,vFKodeRef}, "t",true);

        }
        
         /* banner */
        if(vFDataRef.equals("banner")){
            oOpsBasisdata.fOperasiBdDasar("",
                "", 
                "tb_hlm_banner_foto",
                new String[]{"kode"}, 
                new String[]{vFKode},
                new String[]{"null",vFKode,vFNama,vFNamaBerkasBaru,vFNamaBerkasAsli,vFEkstensi,"0",vFKeterangan,vFKodeRef}, "t",true);

        }
    
    }
}