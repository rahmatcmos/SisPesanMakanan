package pilar.cls;

import java.io.UnsupportedEncodingException;
import java.util.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

public class ClsCookie {
    private Cookie vPrvCookie;
    
    /* ClsCookie (Constructor): membuat cookie baru */
    public ClsCookie(Cookie[] vFCookies, String vFNamaCookie, int vFLamaDisimpan){
        /* periksa apakah cookie dengan nama  yg dimasukkan dalam vFNamaCookie sudah ada? */
        boolean vStatusCookie = false;
        
        if(vFCookies != null){
            for(Cookie vCookie : vFCookies){
               if(vCookie.getName().equals(vFNamaCookie)){
                   vStatusCookie = true;
                   vPrvCookie = vCookie;
                   break;
               }
            }
        }
        
        /* apabila belum ada cookie(s) */
        if(vStatusCookie == false){
            Date now=new Date();
            String timestamp = now.toString();
            /* buat cookie baru */
            vPrvCookie = new Cookie(vFNamaCookie,"");
            /* menetapkan lama cookies disimpan */
            vPrvCookie.setMaxAge(60*60*vFLamaDisimpan); /* vFLamaDisimpan dalam jam */
        }
    }
    
    /* fTambahCookie: menambah isi cookie */
    public void fTambahCookie(String vFIsiCookie, int vFKuantitas, String vFNamaCookie, HttpServletResponse vFResponse) throws UnsupportedEncodingException{
        /* ambil cookie isbn yang sudah ada */
        String vIsiCookie = vPrvCookie.getValue();
        /* tambahkan di akhir cookies sebuah nilai baru */
        StringBuilder vSb = new StringBuilder();
        
        if(vIsiCookie.equals("")){
            boolean vPertama = false;
            
            for(int i=0; i<vFKuantitas;i++){
                if(vPertama == false){
                    vSb.append(vFIsiCookie);
                    vPertama = true;
                }else{
                    //vSb.append(vFIsiCookie);
                    vSb.append("#");
                    vSb.append(vFIsiCookie);
                }
            }
        }else{
            vSb.append(vIsiCookie);
            for(int j=0; j<vFKuantitas;j++){    
                vSb.append("#");
                vSb.append(vFIsiCookie);
            }
        }
        
        /* hitung ukuran byte cookie */
        byte[] vCookieBytes = vSb.toString().getBytes("UTF-8");
        //System.out.println(b.length);
        
        if(vCookieBytes.length < 3800){
            /* buat cookie baru dengan nilai baru dari cookie lama */
            vPrvCookie = new Cookie(vFNamaCookie,vSb.toString());        
            /* tambahkan cookie baru ke dalam response */
            vFResponse.addCookie(vPrvCookie); 
        }
    }
    
    /* fHapusCookie: menghapus nilai cookie dengan isi tertentu */
    public void fHapusCookie(String vFIsiCookie, String vFNamaCookie, HttpServletResponse vFResponse) throws UnsupportedEncodingException{
        /* ambil cookie produk yang sudah ada */
        String vIsiCookie = vPrvCookie.getValue();
        StringBuilder vSb = new StringBuilder();
        /* array isi cookie */
        String[] vArrIsiCookie = vIsiCookie.split("#");
        
        boolean vPertama = true;
        for(String vKode : vArrIsiCookie){
            if(!vKode.equals(vFIsiCookie)){
                if(vPertama){
                    vSb.append(vKode);
                    vPertama = false;
                }else{
                    vSb.append("#");
                    vSb.append(vKode);
                }
            }
        }
        
        /* hitung ukuran byte cookie */
        byte[] vCookieBytes = vSb.toString().getBytes("UTF-8");
        //System.out.println(b.length);
        
        if(vCookieBytes.length < 3800){
            /* buat cookie baru dengan nilai baru dari cookie lama */
            vPrvCookie = new Cookie(vFNamaCookie,vSb.toString());        
            /* tambahkan cookie baru ke dalam response */
            vFResponse.addCookie(vPrvCookie); 
        } 
    }
    
    /* fIsiCookieISBN: mengambil isi cookie */
    public String[] fIsiCookie(){
        return vPrvCookie.getValue().split("#");
    }
    
    /* fHapusSemuaCookie */
    public void fHapusSemuaCookie(String vFNamaCookie, HttpServletResponse vFResponse) throws UnsupportedEncodingException{
        /* ambil cookie produk yang sudah ada */
        vPrvCookie = new Cookie(vFNamaCookie,null);
        vPrvCookie.setMaxAge(0);
        vPrvCookie.setValue("");
        vFResponse.addCookie(vPrvCookie); 
    }
    
}
